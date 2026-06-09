--
-- Ghost Catcher Tycoon - Zone Manager
-- Handles zone renaming, detection, and barrier creation
--

local ZoneManager = {}
ZoneManager.__index = ZoneManager

local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))
local PhaseManager = require(game:GetService("ServerScriptService"):WaitForChild("PhaseManager"))

-- Map workspace folder names to ZoneData names (now 1:1 since ZoneAutoBuilder uses ZoneData names)
local ZONE_MAPPING = {
	Hub = "Starting Area",
	["Whisper Woods"] = "Whisper Woods",
	["Foggy Fields"] = "Foggy Fields",
	["Gloomy Graveyard"] = "Gloomy Graveyard",
	["Electro Alley"] = "Electro Alley",
	["Frostbite Caverns"] = "Frostbite Caverns",
	["Sunken Spirit Reef"] = "Sunken Spirit Reef",
	["Clocktower District"] = "Clocktower District",
	["Astral Observatory"] = "Astral Observatory",
	["Phantom Fortress"] = "Phantom Fortress",
	["The Rift"] = "The Rift",
	["Eternity Nexus"] = "Eternity Nexus",
}

function ZoneManager:new()
	local self = setmetatable({}, ZoneManager)
	self.playerZones = {} -- Track which zone each player is in
	self.zoneRegions = {} -- Store zone boundary info
	self.zoneSystem = nil
	return self
end

function ZoneManager:setZoneSystem(zoneSystem)
	self.zoneSystem = zoneSystem
end

function ZoneManager:initialize()
	print("[ZoneManager] Initializing...")

	-- Wait for ZoneContainer to exist (ZoneAutoBuilder might still be building)
	local zoneContainer = workspace:WaitForChild("ZoneContainer", 30)
	if not zoneContainer then
		warn("[ZoneManager] ZoneContainer not found after 30 seconds - zone detection disabled!")
		return
	end

	print("[ZoneManager] ZoneContainer found, proceeding...")

	-- Rename workspace zones to match ZoneData
	self:renameZones()

	-- Create invisible barriers around locked zones
	self:createBarriers()

	-- Initialize PhaseManager for private Starting Area instances
	local phaseManager = PhaseManager:new()
	phaseManager:initialize()
	self.phaseManager = phaseManager

	-- Start zone detection loop for all players
	self:startZoneDetection()

	print("[ZoneManager] Initialized!")
end

function ZoneManager:renameZones()
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then
		warn("[ZoneManager] ZoneContainer not found in workspace")
		return
	end

	for workspaceFolder, zoneDataName in pairs(ZONE_MAPPING) do
		local folder = zoneContainer:FindFirstChild(workspaceFolder)
		if folder then
			-- Store the real name for internal use, but display ZoneData name to players
			if not folder:GetAttribute("ZoneDataName") then
				folder:SetAttribute("ZoneDataName", zoneDataName)
				print("[ZoneManager] Mapped " .. workspaceFolder .. " → " .. zoneDataName)
			end
		end
	end
end

function ZoneManager:getZoneBoundary(zoneFolder)
	-- Try to find a part or model that defines the zone boundaries
	-- Look for a part named "Boundary", "Zone", or use the folder's PrimaryPart

	local boundary = zoneFolder:FindFirstChild("Boundary")
	if boundary and boundary:IsA("BasePart") then
		return boundary
	end

	-- If no explicit boundary, use folder's PrimaryPart if it exists
	if zoneFolder:IsA("Model") and zoneFolder.PrimaryPart then
		return zoneFolder.PrimaryPart
	end

	-- Otherwise, try to find any part in the folder
	for _, child in ipairs(zoneFolder:GetDescendants()) do
		if child:IsA("BasePart") and child.Name ~= "Barrier" then
			return child
		end
	end

	return nil
end

function ZoneManager:createBarriers()
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then
		warn("[ZoneManager] ZoneContainer not found, cannot create barriers")
		return
	end

	-- Create barriers for each locked zone
	for workspaceFolder, zoneDataName in pairs(ZONE_MAPPING) do
		local zoneFolder = zoneContainer:FindFirstChild(workspaceFolder)
		if zoneFolder then
			local boundary = self:getZoneBoundary(zoneFolder)
			if boundary then
				-- Create an invisible barrier part
				local barrier = Instance.new("Part")
				barrier.Name = "ZoneBarrier_" .. zoneDataName
				barrier.Transparency = 1
				barrier.CanCollide = true
				barrier.CFrame = boundary.CFrame
				barrier.Size = boundary.Size + Vector3.new(10, 10, 10)
				barrier.Parent = zoneFolder
				barrier:SetAttribute("ZoneName", zoneDataName)

				print("[ZoneManager] Created barrier for " .. zoneDataName)
			end
		end
	end
end

function ZoneManager:startZoneDetection()
	local Players = game:GetService("Players")

	-- Detect zone for existing players
	for _, player in ipairs(Players:GetPlayers()) do
		self:startPlayerZoneDetection(player)
	end

	-- Detect zone for new players
	Players.PlayerAdded:Connect(function(player)
		self:startPlayerZoneDetection(player)
	end)

	-- Clean up when players leave
	Players.PlayerRemoving:Connect(function(player)
		self.playerZones[player.UserId] = nil
	end)
end

function ZoneManager:startPlayerZoneDetection(player)
	task.spawn(function()
		while player and player.Parent do
			task.wait(0.5) -- Check zone every 0.5 seconds

			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart

				-- Check if player character is inside a phase folder (private Starting Area)
				local currentZone = nil
				local isInPhase = false

				if self.phaseManager then
					local phaseFolder = self.phaseManager:getPlayerPhaseFolder(player)
					if phaseFolder and hrp.Parent:IsDescendantOf(phaseFolder) then
						-- Player is inside their private phase
						currentZone = "Starting Area"
						isInPhase = true
					end
				end

				-- If not in phase, check shared zones
				if not isInPhase then
					currentZone = self:detectPlayerZone(hrp)
				end

				if currentZone then
					local userId = player.UserId
					if self.playerZones[userId] ~= currentZone then
						self.playerZones[userId] = currentZone

						-- Get zone description from ZoneData
						local zoneDescription = ""
						if ZoneData[currentZone] then
							zoneDescription = ZoneData[currentZone].Special or ""
						end

						-- Broadcast zone change to client
						local updateRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
							and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("UpdateUI")
						if updateRemote then
							updateRemote:FireClient(player, {
								CurrentZone = currentZone,
								CurrentZoneDescription = zoneDescription
							})
						end

						print("[ZoneManager] " .. player.Name .. " entered " .. currentZone .. " (" .. zoneDescription .. ")")
					end
				end
			end
		end
	end)
end

function ZoneManager:detectPlayerZone(hrp)
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then
		return "Starting Area"
	end

	-- First, check if player is ON a bridge (threshold covers entire bridge length)
	local bridgeThreshold = 100  -- Bridges are 100 studs long, this covers the full length
	local bridgesFolder = zoneContainer:FindFirstChild("Bridges")
	if bridgesFolder then
		-- Check all parts in the Bridges folder
		for _, child in ipairs(bridgesFolder:GetDescendants()) do
			if child:IsA("BasePart") then
				local distance = (hrp.Position - child.Position).Magnitude
				if distance < bridgeThreshold then
					return "Bridge"
				end
			end
		end
	end

	-- If not on a bridge, find closest zone island
	local closestZone = "Starting Area"
	local closestDistance = 500 -- Large threshold

	for _, zoneFolder in ipairs(zoneContainer:GetChildren()) do
		if zoneFolder:IsA("Folder") or zoneFolder:IsA("Model") then
			-- Skip bridges folder in this pass (already checked above)
			if zoneFolder.Name ~= "Bridges" then
				-- Find terrain part (usually named "Terrain" or similar)
				local terrainPart = nil
				for _, child in ipairs(zoneFolder:GetChildren()) do
					if child:IsA("BasePart") then
						terrainPart = child
						break
					end
				end

				if terrainPart then
					local distance = (hrp.Position - terrainPart.Position).Magnitude

					-- If player is reasonably close to this zone's terrain
					if distance < closestDistance then
						closestDistance = distance
						-- Map workspace folder name to ZoneData name
						closestZone = ZONE_MAPPING[zoneFolder.Name] or zoneFolder.Name
					end
				end
			end
		end
	end

	return closestZone
end

function ZoneManager:canPlayerEnterZone(player, zoneName)
	if not self.zoneSystem then
		return true -- Allow entry if zone system not initialized
	end

	return self.zoneSystem:isZoneUnlocked(player, zoneName)
end

function ZoneManager:getPlayerZone(player)
	return self.playerZones[player.UserId] or "Starting Area"
end

return ZoneManager
-- Built with assistance from Claude Code by Anthropic.
