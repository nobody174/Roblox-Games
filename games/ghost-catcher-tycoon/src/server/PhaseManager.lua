--
-- Ghost Catcher Tycoon - Phase Manager
-- Handles private instanced zones (phasing) for players
-- Starting Area is per-player, other zones are shared
--

local PhaseManager = {}
PhaseManager.__index = PhaseManager

function PhaseManager:new()
	local self = setmetatable({}, PhaseManager)
	self.playerPhases = {}      -- Maps userId -> phaseId (private zone instance)
	self.phaseInstances = {}    -- Maps phaseId -> {folder, players}
	self.nextPhaseId = 1
	return self
end

-- Create a private Starting Area instance for a player
function PhaseManager:createPlayerPhase(player)
	local userId = player.UserId

	-- Check if player already has a phase
	if self.playerPhases[userId] then
		return self.playerPhases[userId]
	end

	local phaseId = self.nextPhaseId
	self.nextPhaseId = self.nextPhaseId + 1

	-- Create phase folder in workspace
	local phaseFolder = Instance.new("Folder")
	phaseFolder.Name = "Phase_" .. phaseId .. "_" .. player.Name
	phaseFolder.Parent = workspace

	-- Clone Starting Area (Hub) into this phase
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if zoneContainer then
		local hubZone = zoneContainer:FindFirstChild("Hub")
		if hubZone then
			-- Clone the Hub zone for this player's private instance
			local clonedHub = hubZone:Clone()
			clonedHub.Name = "Hub"
			clonedHub.Parent = phaseFolder
		end
	end

	-- Store phase info
	self.phaseInstances[phaseId] = {
		folder = phaseFolder,
		players = {[userId] = true},
		createdAt = os.time()
	}

	self.playerPhases[userId] = phaseId

	print("[PhaseManager] Created private phase #" .. phaseId .. " for " .. player.Name)

	return phaseId
end

-- Get the phase instance folder for a player
function PhaseManager:getPlayerPhaseFolder(player)
	local userId = player.UserId
	local phaseId = self.playerPhases[userId]

	if phaseId and self.phaseInstances[phaseId] then
		return self.phaseInstances[phaseId].folder
	end

	return nil
end

-- Teleport player to their private Starting Area phase
function PhaseManager:teleportPlayerToPhase(player)
	local phaseFolder = self:getPlayerPhaseFolder(player)
	if not phaseFolder then
		warn("[PhaseManager] No phase folder for player " .. player.Name)
		return false
	end

	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	-- Find the Hub zone in the phase folder
	local hubZone = phaseFolder:FindFirstChild("Hub")
	if not hubZone then
		return false
	end

	-- Find terrain part to spawn near
	local terrainPart = nil
	for _, child in ipairs(hubZone:GetChildren()) do
		if child:IsA("BasePart") then
			terrainPart = child
			break
		end
	end

	if terrainPart then
		-- Teleport to phase with slight offset
		local spawnPos = terrainPart.Position + Vector3.new(0, 10, 0)
		player.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPos)
		return true
	end

	return false
end

-- Check if a zone is in a player's private phase
function PhaseManager:isZoneInPhase(player, zoneName)
	local phaseFolder = self:getPlayerPhaseFolder(player)
	if not phaseFolder then
		return false
	end

	return phaseFolder:FindFirstChild(zoneName) ~= nil
end

-- Clean up player's phase when they leave
function PhaseManager:cleanupPlayerPhase(player)
	local userId = player.UserId
	local phaseId = self.playerPhases[userId]

	if phaseId and self.phaseInstances[phaseId] then
		local phaseInstance = self.phaseInstances[phaseId]

		-- Remove player from phase
		phaseInstance.players[userId] = nil

		-- If phase is empty, delete it
		if not next(phaseInstance.players) then
			phaseInstance.folder:Destroy()
			self.phaseInstances[phaseId] = nil
			print("[PhaseManager] Deleted empty phase #" .. phaseId)
		end
	end

	self.playerPhases[userId] = nil
end

-- Initialize phases for all players (call once on server start)
function PhaseManager:initialize()
	print("[PhaseManager] Initializing...")

	local Players = game:GetService("Players")

	-- Create phases for existing players
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			self:createPlayerPhase(player)
			-- Delay teleport to ensure character is ready
			task.delay(0.5, function()
				if player and player.Parent then
					self:teleportPlayerToPhase(player)
				end
			end)
		end
	end

	-- Create phase for new players on spawn
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			task.wait(0.5) -- Wait for character to be fully loaded

			-- Create phase if doesn't exist
			if not self.playerPhases[player.UserId] then
				self:createPlayerPhase(player)
			end

			-- Teleport to private phase
			self:teleportPlayerToPhase(player)
			print("[PhaseManager] Teleported " .. player.Name .. " to private phase")
		end)
	end)

	-- Clean up when players leave
	Players.PlayerRemoving:Connect(function(player)
		self:cleanupPlayerPhase(player)
	end)

	print("[PhaseManager] Initialized!")
end

return PhaseManager
