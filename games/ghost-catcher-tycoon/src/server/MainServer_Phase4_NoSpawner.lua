--
-- Ghost Catcher Tycoon - Phase 4 Testing (Minimal Ghost Spawning)
-- No dependencies - spawns test ghosts directly
--
local Players = game:GetService("Players")

print("[PHASE 4] Starting Phase 4 minimal testing server...")

local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

print("[PHASE 4] Constants loaded")

-- Setup RemoteEvents
local rs = game:GetService("ReplicatedStorage")

if not rs:FindFirstChild("Remotes") then
	local remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = rs
end

local remotesFolder = rs:FindFirstChild("Remotes")

local function createRemote(name, className)
	if not remotesFolder:FindFirstChild(name) then
		local remote = Instance.new(className)
		remote.Name = name
		remote.Parent = remotesFolder
		return remote
	end
	return remotesFolder:FindFirstChild(name)
end

createRemote(Constants.Remotes.ChargeVacuum, "RemoteEvent")
createRemote(Constants.Remotes.CatchGhost, "RemoteEvent")
createRemote(Constants.Remotes.UpdateUI, "RemoteEvent")
createRemote(Constants.Remotes.ShowNotification, "RemoteEvent")
createRemote(Constants.Remotes.GetGameState, "RemoteFunction")

print("[PHASE 4] Remotes created")

-- Simple ghost spawning (no dependencies)
local activeGhosts = {}
local ghostNames = { "Specter", "Phantom", "Wraith", "Banshee", "Poltergeist", "Shade", "Apparition", "Spirit" }
local rarities = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted" }
local rarityColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(0, 255, 0),
	Rare = Color3.fromRGB(0, 0, 255),
	Epic = Color3.fromRGB(180, 80, 255),
	Legendary = Color3.fromRGB(255, 200, 50),
	Corrupted = Color3.fromRGB(255, 60, 60),
}

local function spawnGhost(zoneName)
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then return nil end

	local zoneFolder = zoneContainer:FindFirstChild(zoneName)
	if not zoneFolder then return nil end

	local ghostName = ghostNames[math.random(1, #ghostNames)]
	local rarity = rarities[math.random(1, #rarities)]

	local ghost = Instance.new("Part")
	ghost.Name = ghostName
	ghost.Shape = Enum.PartType.Ball
	ghost.Size = Vector3.new(2, 2, 2)
	ghost.CanCollide = false
	ghost.Color = rarityColors[rarity] or Color3.fromRGB(200, 200, 200)
	ghost.Material = Enum.Material.Neon
	ghost.TopSurface = Enum.SurfaceType.Smooth
	ghost.BottomSurface = Enum.SurfaceType.Smooth
	ghost.Position = Vector3.new(math.random(-200, 200), 20, math.random(-200, 200))
	ghost.Parent = zoneFolder

	-- Disable gravity so ghosts float
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = ghost

	ghost:SetAttribute("GhostName", ghostName)
	ghost:SetAttribute("Rarity", rarity)

	local light = Instance.new("PointLight")
	light.Brightness = 2
	light.Range = 15
	light.Color = rarityColors[rarity]
	light.Parent = ghost

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.MaxDistance = 200
	billboard.Parent = ghost

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 12
	label.Font = Enum.Font.GothamBold
	label.Text = ghostName .. " (" .. rarity .. ")"
	label.Parent = billboard

	activeGhosts[ghost] = { name = ghostName, rarity = rarity }

	-- Auto-despawn after 60 seconds
	task.delay(60, function()
		if ghost.Parent then
			ghost:Destroy()
			activeGhosts[ghost] = nil
		end
	end)

	return ghost
end

-- Spawn ghosts every 3 seconds
task.spawn(function()
	while true do
		task.wait(3)
		local zones = { "Zone_1_Meadow", "Zone_2_Desert", "Zone_3_Frost", "Zone_4_Haunted", "Zone_5_Tech" }
		for _, zoneName in ipairs(zones) do
			spawnGhost(zoneName)
		end
	end
end)

print("[PHASE 4] Ghost spawning started")

-- Player data
local playerData = {}

-- Charge remote handler
local chargeRemote = remotesFolder:FindFirstChild(Constants.Remotes.ChargeVacuum)
if chargeRemote then
	chargeRemote.OnServerEvent:Connect(function(player)
		if not playerData[player.UserId] then
			playerData[player.UserId] = { charge = 0, coins = 0, ghosts = 0 }
		end
		playerData[player.UserId].charge = math.min(playerData[player.UserId].charge + 25, 100)
		print("[PHASE 4] " .. player.Name .. " charged. New charge: " .. playerData[player.UserId].charge .. "%")
	end)
	print("[PHASE 4] Charge handler connected")
end

-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		if not playerData[player.UserId] then
			playerData[player.UserId] = { charge = 0, coins = 0, ghosts = 0 }
		end

		local charge = playerData[player.UserId].charge

		-- Check if player has enough charge
		if charge < 10 then
			print("[PHASE 4] " .. player.Name .. " tried to catch but has insufficient charge (" .. charge .. "%)")
			return
		end

		-- Find nearest ghost to player
		local character = player.Character
		if not character then return end

		local playerPos = character:FindFirstChild("HumanoidRootPart")
		if not playerPos then return end

		playerPos = playerPos.Position
		local closestGhost = nil
		local closestDist = 100

		for ghostInstance, ghostData in pairs(activeGhosts) do
			if ghostInstance and ghostInstance.Parent then
				local dist = (ghostInstance.Position - playerPos).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestGhost = ghostInstance
				end
			end
		end

		if not closestGhost then
			print("[PHASE 4] " .. player.Name .. " tried to catch but no ghosts nearby")
			return
		end

		-- Get ghost data
		local ghostName = closestGhost:GetAttribute("GhostName")
		local rarity = closestGhost:GetAttribute("Rarity")

		-- Deduct charge
		playerData[player.UserId].charge = math.max(playerData[player.UserId].charge - 10, 0)

		-- Award coins based on rarity
		local coinReward = {
			Common = 1,
			Uncommon = 3,
			Rare = 10,
			Epic = 25,
			Legendary = 50,
			Corrupted = 75,
		}
		local coins = coinReward[rarity] or 1
		playerData[player.UserId].coins = playerData[player.UserId].coins + coins
		playerData[player.UserId].ghosts = playerData[player.UserId].ghosts + 1

		-- Remove ghost from world
		closestGhost:Destroy()
		activeGhosts[closestGhost] = nil

		print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") for " .. coins .. " coins!")
	end)
	print("[PHASE 4] Catch handler connected")
end

-- UI update loop (broadcast every second)
task.spawn(function()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data then
				local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
				if updateRemote then
					updateRemote:FireClient(player, {
						VacuumCharge = data.charge,
						Energy = data.coins,
						GhostCount = data.ghosts,
					})
				end
			end
		end
	end
end)

print("[PHASE 4] ✅ Phase 4 testing server ready!")
print("[PHASE 4] Ghosts spawning every 3 seconds in all zones")
print("[PHASE 4] Click CHARGE to increase vacuum charge by 25%")
print("[PHASE 4] Click CATCH to catch nearby ghosts and earn coins")
