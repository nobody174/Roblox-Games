--
-- Ghost Catcher Tycoon - Phase 4 Extended (Minimal Ghost Spawning + Optional Handlers)
-- No dependencies - spawns test ghosts directly, includes room upgrades, ghost training, egg hatching, zone unlocks
--
local Players = game:GetService("Players")

print("[PHASE 4] Starting Phase 4 extended testing server...")

local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

print("[PHASE 4] Constants loaded")
print("[PHASE 4] Config loaded (spawn rate: " .. Config.GhostSpawnRate .. "s, catch distance: " .. Config.GhostCatchDistance .. " studs)")

-- Load SystemManager to initialize all systems (Quests, Bosses, Leaderboard, Prestige, etc.)
local serverScriptService = game:GetService("ServerScriptService")
local systemsFolder = serverScriptService:FindFirstChild("systems")
local SystemManager = nil

if systemsFolder then
	local systemManagerModule = systemsFolder:FindFirstChild("SystemManager")
	if systemManagerModule and systemManagerModule:IsA("ModuleScript") then
		SystemManager = require(systemManagerModule)
	end
end

-- Initialize SystemManager in background (don't block MainServer)
if SystemManager and SystemManager.initialize then
	task.spawn(function()
		SystemManager:initialize()
		print("[PHASE 4] SystemManager initialized")
	end)
else
	warn("[PHASE 4] SystemManager not found in systems folder or not a ModuleScript - systems disabled")
end

print("[PHASE 4] Proceeding with MainServer initialization...")
print("[PHASE 4] About to load ZoneManager...")

-- Load ZoneManager for zone detection and barriers
local zoneManager = nil
local zoneManagerModule = game:GetService("ServerScriptService"):FindFirstChild("ZoneManager")
if zoneManagerModule then
	local ZoneManager = require(zoneManagerModule)
	zoneManager = ZoneManager:new()
	print("[PHASE 4] ZoneManager loaded")
else
	warn("[PHASE 4] ZoneManager not found in ServerScriptService - zone detection disabled")
	warn("[PHASE 4] To enable: Create ModuleScript 'ZoneManager' in ServerScriptService and paste ZoneManager.lua code")
end
local dataManager = nil
local dataManagerModule = game:GetService("ServerScriptService"):FindFirstChild("Data")
if dataManagerModule then
	local DataManager = require(dataManagerModule:FindFirstChild("DataManager"))
	dataManager = DataManager:new()
	print("[PHASE 4] DataManager loaded")
else
	print("[PHASE 4] DataManager not found - running in memory-only mode for testing")
end

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
createRemote(Constants.Remotes.UpgradeRoom, "RemoteEvent")
createRemote(Constants.Remotes.TrainGhost, "RemoteEvent")
createRemote(Constants.Remotes.GachaPull, "RemoteEvent")
createRemote(Constants.Remotes.UnlockZone, "RemoteEvent")
createRemote(Constants.Remotes.BringGhostsHome, "RemoteEvent")
createRemote(Constants.Remotes.ChallengePlayer, "RemoteFunction")
createRemote(Constants.Remotes.RespondToChallenge, "RemoteFunction")
createRemote(Constants.Remotes.BattleResult, "RemoteEvent")
createRemote("ReleaseGhost", "RemoteEvent")

-- Create admin command remote immediately
if not remotesFolder:FindFirstChild("AdminCommand") then
	local adminRemote = Instance.new("RemoteFunction")
	adminRemote.Name = "AdminCommand"
	adminRemote.Parent = remotesFolder
end

print("[PHASE 4] Remotes created (including optional handlers)")

-- ==================== GAME CONFIGURATION ====================

-- Load GhostData and ZoneData for spawning
local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))
local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))
local GhostAI = require(game:GetService("ServerScriptService"):WaitForChild("GhostAI"))

-- Load Equipment System modules
local EquipmentData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("EquipmentData"))
local PlayerInventory = require(game:GetService("ServerScriptService"):WaitForChild("PlayerInventory"))
local CatchingSystem = require(game:GetService("ServerScriptService"):WaitForChild("CatchingSystem"))

print("[PHASE 4] Equipment systems loaded")

-- Ghost spawning setup
local activeGhosts = {}
local rarityColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(0, 255, 0),
	Rare = Color3.fromRGB(0, 0, 255),
	Epic = Color3.fromRGB(180, 80, 255),
	Legendary = Color3.fromRGB(255, 200, 50),
	Corrupted = Color3.fromRGB(255, 60, 60),
}

-- Room upgrade configuration
local roomConfig = {
	GhostChamber = { baseCost = 100, costMultiplier = 1.5, maxLevel = 10 },
	TrainingFacility = { baseCost = 150, costMultiplier = 1.5, maxLevel = 10 },
	EnergyReactor = { baseCost = 200, costMultiplier = 1.5, maxLevel = 10 },
	ResearchLab = { baseCost = 300, costMultiplier = 1.5, maxLevel = 10 },
	BossArena = { baseCost = 500, costMultiplier = 1.5, maxLevel = 10 },
}

-- Egg configuration (simplified for Phase 4)
local eggConfig = {
	["Common Egg"] = { cost = 250, rarity = "Common" },
	["Uncommon Egg"] = { cost = 1200, rarity = "Uncommon" },
	["Rare Egg"] = { cost = 5000, rarity = "Rare" },
	["Epic Egg"] = { cost = 15000, rarity = "Epic" },
	["Legendary Egg"] = { cost = 45000, rarity = "Legendary" },
}

-- Zone configuration (first 5 zones for Phase 4)
local zoneConfig = {
	["Whisper Woods"] = { unlocked = true, cost = 0 },
	["Foggy Fields"] = { unlocked = false, cost = 1500 },
	["Gloomy Graveyard"] = { unlocked = false, cost = 6000 },
	["Electro Alley"] = { unlocked = false, cost = 18000 },
	["Frostbite Caverns"] = { unlocked = false, cost = 42000 },
}

-- Available ghosts for hatching (simplified list)
local availableGhosts = {
	Common = { "Puffling", "Wobbler", "Peekaboo", "Drifter", "Blinklet" },
	Uncommon = { "Sparkling Sprite", "Shadowling", "Giggler", "Lantern Wisp", "Dustwhirl" },
	Rare = { "Voltgeist", "Frostwhisper", "Bloomshade", "Geargrin", "Tidebound" },
	Epic = { "Phantom Knight", "Inferno Wraith", "Astral Drifter", "Cryo Reaper", "Thunder Jester" },
	Legendary = { "Ancient One", "Void King", "Star Reaper", "Eternal Shade", "Primordial Ghost" },
}

-- ==================== GHOST SPAWNING ====================

-- Modified spawnGhost to support both shared zones and phased zones
local function spawnGhost(zoneName, targetFolder)
	-- Use targetFolder if provided (for private phases), otherwise use shared ZoneContainer
	local searchContainer = targetFolder or workspace:FindFirstChild("ZoneContainer")
	if not searchContainer then return nil end

	local zoneFolder = searchContainer:FindFirstChild(zoneName)
	if not zoneFolder then return nil end

	-- Get zone-specific spawn pool from ZoneData
	local zoneInfo = ZoneData[zoneName]
	if not zoneInfo or not zoneInfo.Spawns then
		return nil -- Zone has no spawn data
	end

	-- Select ghost using weighted random from zone's spawn pool
	local totalWeight = 0
	for _, spawnEntry in ipairs(zoneInfo.Spawns) do
		totalWeight = totalWeight + spawnEntry.Weight
	end

	local randomWeight = math.random(1, totalWeight)
	local currentWeight = 0
	local ghostName = "Puffling" -- Fallback
	local rarity = "Common" -- Fallback

	for _, spawnEntry in ipairs(zoneInfo.Spawns) do
		currentWeight = currentWeight + spawnEntry.Weight
		if randomWeight <= currentWeight then
			ghostName = spawnEntry.Ghost
			rarity = spawnEntry.Rarity or "Common"  -- Use rarity from spawn pool
			break
		end
	end
	local color = rarityColors[rarity] or Color3.fromRGB(200, 200, 200)

	-- Find zone terrain to spawn near it
	local terrainPart = nil
	for _, child in ipairs(zoneFolder:GetChildren()) do
		if child:IsA("BasePart") then
			terrainPart = child
			break
		end
	end

	-- Spawn position relative to zone terrain
	local zoneCenter = terrainPart and terrainPart.Position or Vector3.new(0, 25, 0)
	local spawnPos = zoneCenter + Vector3.new(math.random(-50, 50), 15, math.random(-50, 50))

	-- Build a ghost model: round head + glowing eyes (simplified)
	local ghostModel = Instance.new("Model")
	ghostModel.Name = ghostName
	ghostModel.Parent = zoneFolder

	-- Main head (round sphere)
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Shape = Enum.PartType.Ball
	body.Size = Vector3.new(3, 3, 3)
	body.CanCollide = false
	body.Anchored = false
	body.Color = color
	body.Material = Enum.Material.SmoothPlastic
	body.Transparency = 0.15
	body.TopSurface = Enum.SurfaceType.Smooth
	body.BottomSurface = Enum.SurfaceType.Smooth
	body.CastShadow = false
	body.Position = spawnPos
	body.Parent = ghostModel
	ghostModel.PrimaryPart = body

	-- Left eye
	local eyeL = Instance.new("Part")
	eyeL.Name = "EyeL"
	eyeL.Shape = Enum.PartType.Ball
	eyeL.Size = Vector3.new(0.6, 0.6, 0.6)
	eyeL.CanCollide = false
	eyeL.Anchored = false
	eyeL.Color = Color3.fromRGB(255, 255, 255)
	eyeL.Material = Enum.Material.Neon
	eyeL.CastShadow = false
	eyeL.Position = spawnPos + Vector3.new(-0.6, 0.4, -1.3)
	eyeL.Parent = ghostModel

	local eyeLWeld = Instance.new("WeldConstraint")
	eyeLWeld.Part0 = body
	eyeLWeld.Part1 = eyeL
	eyeLWeld.Parent = body

	-- Right eye
	local eyeR = eyeL:Clone()
	eyeR.Name = "EyeR"
	eyeR.Position = spawnPos + Vector3.new(0.6, 0.4, -1.3)
	eyeR.Parent = ghostModel

	local eyeRWeld = Instance.new("WeldConstraint")
	eyeRWeld.Part0 = body
	eyeRWeld.Part1 = eyeR
	eyeRWeld.Parent = body


	-- Glow light
	local light = Instance.new("PointLight")
	light.Brightness = 1.5
	light.Range = 18
	light.Color = color
	light.Parent = body

	-- Keep it floating (no gravity)
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
	bodyVelocity.Parent = body

	-- Gentle bobbing animation
	local baseY = spawnPos.Y
	local bobTask = task.spawn(function()
		local t = 0
		while ghostModel.Parent do
			t = t + 0.05
			local newY = baseY + math.sin(t) * 0.8
			bodyVelocity.Velocity = Vector3.new(0, (newY - body.Position.Y) * 5, 0)
			task.wait(0.05)
		end
	end)

	-- Name/rarity billboard above ghost
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 120, 0, 45)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.MaxDistance = 40
	billboard.AlwaysOnTop = false
	billboard.Parent = body

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.TextSize = 13
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = ghostName
	nameLabel.Parent = billboard

	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Size = UDim2.new(1, 0, 0.4, 0)
	rarityLabel.Position = UDim2.new(0, 0, 0.6, 0)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.TextColor3 = color
	rarityLabel.TextStrokeTransparency = 0
	rarityLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	rarityLabel.TextSize = 11
	rarityLabel.Font = Enum.Font.Gotham
	rarityLabel.Text = rarity
	rarityLabel.Parent = billboard

	-- Use body as the catch target, tag with attributes
	body:SetAttribute("GhostName", ghostName)
	body:SetAttribute("Rarity", rarity)
	ghostModel:SetAttribute("GhostName", ghostName)
	ghostModel:SetAttribute("Rarity", rarity)

	-- Track by model (catch code checks Part, so also track body)
	activeGhosts[body] = { name = ghostName, rarity = rarity }
	local ghost = body  -- keep variable name for catch system compatibility

	-- Initialize AI behavior based on rarity
	GhostAI:initializeGhost(ghostModel, rarity)

	-- Auto-despawn after 60 seconds
	task.delay(60, function()
		if ghostModel.Parent then
			activeGhosts[body] = nil
			ghostModel:Destroy()
		end
	end)

	return ghost
end

-- Spawn ghosts every N seconds in all zones (mapped from ZoneData)
-- Spawning will start after ZoneManager is initialized (to ensure PhaseManager is ready)
local spawnLoopStarted = false

local function startGhostSpawnLoop()
	if spawnLoopStarted then return end
	spawnLoopStarted = true

	task.spawn(function()
		local spawnCount = 0
		while true do
			task.wait(Config.GhostSpawnRate)
			-- Zone names now match ZoneAutoBuilder output (theme names)
			local zoneMapping = {
				"Hub",  -- Starting Area
				"Whisper Woods",
				"Foggy Fields",
				"Gloomy Graveyard",
				"Electro Alley",
				"Frostbite Caverns",
				"Sunken Spirit Reef",
				"Clocktower District",
				"Astral Observatory",
				"Phantom Fortress",
				"The Rift",
				"Eternity Nexus",
			}

			spawnCount = spawnCount + 1
			local spawnedThisRound = 0
			for _, zoneName in ipairs(zoneMapping) do
				if spawnGhost(zoneName) then
					spawnedThisRound = spawnedThisRound + 1
				end
			end

			-- Don't spawn ghosts in Starting Area - it's a home/HQ zone
			-- (PhaseManager still creates private phases, but they're ghost-free)

			if spawnedThisRound > 0 then
				print("[PHASE 4] Spawn cycle #" .. spawnCount .. ": Spawned " .. spawnedThisRound .. " ghosts")
			end
		end
	end)
end

-- Expose world-spawn for admin testing (used by !sw command)
_G.AdminSpawnWorld = function(player, ghostName)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	local pos = character.HumanoidRootPart.Position + Vector3.new(0, 5, -8)
	local rarity = GhostData.RarityMap[ghostName] or "Common"
	local color = rarityColors[rarity] or Color3.fromRGB(200, 200, 200)

	local ghostModel = Instance.new("Model")
	ghostModel.Name = ghostName
	ghostModel.Parent = workspace

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Shape = Enum.PartType.Ball
	body.Size = Vector3.new(3, 3, 3)
	body.CanCollide = false
	body.Color = color
	body.Material = Enum.Material.SmoothPlastic
	body.Transparency = 0.15
	body.Position = pos
	body.Parent = ghostModel
	ghostModel.PrimaryPart = body


	-- Keep floating
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(0, math.huge, 0)
	bv.Parent = body

	-- Bobbing
	local baseY = pos.Y
	task.spawn(function()
		local t = 0
		while ghostModel.Parent do
			t = t + 0.05
			bv.Velocity = Vector3.new(0, (baseY + math.sin(t) * 0.8 - body.Position.Y) * 5, 0)
			task.wait(0.05)
		end
	end)

	local light = Instance.new("PointLight")
	light.Brightness = 1.5
	light.Range = 18
	light.Color = color
	light.Parent = body

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 140, 0, 45)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.Parent = body
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = ghostName .. "\n[IMAGE TEST]"
	lbl.Parent = billboard

	body:SetAttribute("GhostName", ghostName)
	body:SetAttribute("Rarity", rarity)
	activeGhosts[body] = { name = ghostName, rarity = rarity }

	task.delay(30, function()
		if ghostModel.Parent then
			activeGhosts[body] = nil
			ghostModel:Destroy()
		end
	end)
	print("[ADMIN] Spawned " .. ghostName .. " in world near " .. player.Name)
end

print("[PHASE 4] Ghost spawning started")

-- ==================== PLAYER DATA ====================

local playerData = {}

-- Expose playerData globally so admin commands can access it
_G.GhostCatcherPlayerData = playerData

local function getMaxGhostSlots(chamberLevel)
	return 5 + (chamberLevel * 10)
end

local function initPlayerData(userId)
	if not playerData[userId] then
		playerData[userId] = {
			charge = 0,
			coins = 0,
			energy = 0,
			ghosts = 0,
			ghostInventory = {}, -- { ghostName: { level, rarity } }
			rooms = {
				GhostChamber = { level = 0 },
				TrainingFacility = { level = 0 },
				EnergyReactor = { level = 0 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = { ["Whisper Woods"] = true },
		}
	end
	return playerData[userId]
end

-- ==================== DATASTORE INTEGRATION ====================

-- Hook player join to load data from DataStore
Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId

	-- Load from DataStore if available (or create new)
	local dmData = nil
	if dataManager then
		dmData = dataManager:loadPlayerData(player)
	end

	-- Initialize or load simple data structure for fast access
	if dmData and dmData.Coins then
		-- Restore from previous session
		playerData[userId] = {
			charge = 0, -- Charge always resets on join
			coins = dmData.Coins or 0,
			ghosts = (dmData.GhostCount or 0),
			ghostInventory = dmData.GhostInventory or {},
			rooms = dmData.Rooms or {
				GhostChamber = { level = 0 },
				TrainingFacility = { level = 0 },
				EnergyReactor = { level = 0 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = dmData.UnlockedZones or { ["Whisper Woods"] = true },
		}
		print("[PHASE 4] Loaded player data for " .. player.Name .. " from DataStore")
	else
		-- New player
		initPlayerData(userId)
		print("[PHASE 4] Created new player data for " .. player.Name)
	end

	-- Initialize player in SystemManager systems (for Quests, Bosses, etc.)
	if SystemManager then
		task.spawn(function()
			SystemManager:initializePlayer(player)
		end)
	end

	-- Initialize zone detection for player
	if zoneManager then
		-- ZoneManager will handle this in startZoneDetection
	end

	-- Initialize equipment inventory
	PlayerInventory:initializePlayer(userId)
	print("[PHASE 4] Equipment inventory initialized for " .. player.Name)
end)

-- Hook player leave to save data to DataStore
Players.PlayerRemoving:Connect(function(player)
	local userId = player.UserId
	local data = playerData[userId]

	if data then
		-- Save to DataStore
		local saveSuccess = dataManager:savePlayerData(player)
		if saveSuccess then
			print("[PHASE 4] Saved player data for " .. player.Name .. " to DataStore")
		else
			warn("[PHASE 4] Failed to save player data for " .. player.Name)
		end

		-- Clear from memory
		playerData[userId] = nil

		-- Clean up equipment inventory
		PlayerInventory:removePlayer(userId)
		print("[PHASE 4] Cleaned up equipment for " .. player.Name)
	end
end)

-- Auto-save every 30 seconds (batched)
task.spawn(function()
	while true do
		task.wait(30)
		if dataManager then
			for userId, data in pairs(playerData) do
				local player = Players:FindFirstChild(tostring(userId))
				if player then
					-- Update DataStore with current in-memory data
					dataManager:updatePlayerData(player, {
						Coins = data.coins,
						GhostCount = data.ghosts,
						GhostInventory = data.ghostInventory,
						Rooms = data.rooms,
						UnlockedZones = data.unlockedZones,
					})
				end
			end

			-- Process save queue
			dataManager:processSaveQueue()
		end
	end
end)

print("[PHASE 4] DataStore integration hooked")

-- ==================== REMOTE HANDLERS ====================

-- Charge remote handler
local chargeRemote = remotesFolder:FindFirstChild(Constants.Remotes.ChargeVacuum)
if chargeRemote then
	chargeRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)
		data.charge = math.min(data.charge + 25, 100)
		print("[PHASE 4] " .. player.Name .. " charged. New charge: " .. data.charge .. "%")
	end)
	print("[PHASE 4] Charge handler connected")
end

-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)

		local charge = data.charge

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
		local closestDist = Config.GhostCatchDistance

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

		-- Check inventory limit
		local maxSlots = getMaxGhostSlots(data.rooms.GhostChamber.level)
		local currentCount = 0
		for _ in pairs(data.ghostInventory) do
			currentCount = currentCount + 1
		end

		if currentCount >= maxSlots then
			print("[PHASE 4] " .. player.Name .. " tried to catch but inventory is full (" .. currentCount .. "/" .. maxSlots .. ")")
			local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
			if notifyRemote then
				notifyRemote:FireClient(player, "Inventory full! Release ghosts or upgrade Ghost Chamber", Color3.fromRGB(255, 100, 100))
			end
			return
		end

		-- Deduct charge
		data.charge = math.max(data.charge - 10, 0)

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
		data.coins = data.coins + coins
		data.ghosts = data.ghosts + 1

		-- Add to ghost inventory
		local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = { name = ghostName, level = 1, rarity = rarity }

		-- Remove ghost from world (destroy whole model if it exists)
		local ghostParent = closestGhost.Parent
		if ghostParent and ghostParent:IsA("Model") then
			ghostParent:Destroy()
		else
			closestGhost:Destroy()
		end
		activeGhosts[closestGhost] = nil

		print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") for " .. coins .. " coins!")
	end)
	print("[PHASE 4] Catch handler connected")
end

-- Bring Ghosts Home remote handler
local bringRemote = remotesFolder:FindFirstChild(Constants.Remotes.BringGhostsHome)
if bringRemote then
	bringRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)

		-- Award bonus coins (10% of ghosts * 10 coins per ghost)
		local bonusCoins = math.ceil(data.ghosts * 10 * 0.1)
		data.coins = data.coins + bonusCoins

		print("[PHASE 4] " .. player.Name .. " brought ghosts home! Earned " .. bonusCoins .. " bonus coins")

		-- Send immediate broadcast to update UI
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] BringGhostsHome handler connected")
end

-- ==================== OPTIONAL HANDLERS ====================

-- UpgradeRoom remote handler
local upgradeRoomRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpgradeRoom)
if upgradeRoomRemote then
	upgradeRoomRemote.OnServerEvent:Connect(function(player, roomName)
		local data = initPlayerData(player.UserId)

		-- Validate room
		if not roomConfig[roomName] or not data.rooms[roomName] then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade invalid room: " .. roomName)
			return
		end

		local room = data.rooms[roomName]
		local config = roomConfig[roomName]

		-- Check max level
		if room.level >= config.maxLevel then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade " .. roomName .. " beyond max level")
			return
		end

		-- Calculate cost (cost scales with level): 100 * (nextLevel ^ 1.5)
		local nextLevel = room.level + 1
		local cost = math.floor(100 * (nextLevel ^ 1.5))

		-- Check coins
		if data.coins < cost then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade " .. roomName .. " but has insufficient coins (" .. data.coins .. " < " .. cost .. ")")
			return
		end

		-- Deduct coins and upgrade
		data.coins = data.coins - cost
		room.level = room.level + 1

		print("[PHASE 4] " .. player.Name .. " upgraded " .. roomName .. " to level " .. room.level .. " for " .. cost .. " coins!")

		-- Send immediate broadcast to update client UI
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] UpgradeRoom handler connected")
end

-- TrainGhost remote handler
local trainGhostRemote = remotesFolder:FindFirstChild(Constants.Remotes.TrainGhost)
if trainGhostRemote then
	trainGhostRemote.OnServerEvent:Connect(function(player, ghostKey)
		local data = initPlayerData(player.UserId)

		-- Validate ghost
		if not data.ghostInventory[ghostKey] then
			print("[PHASE 4] " .. player.Name .. " tried to train non-existent ghost: " .. ghostKey)
			return
		end

		local ghost = data.ghostInventory[ghostKey]

		-- Check max level
		if ghost.level >= 10 then
			print("[PHASE 4] " .. player.Name .. " tried to train " .. ghost.name .. " beyond max level 10")
			return
		end

		-- Calculate cost (scales with ghost level): level * 75
		local cost = ghost.level * 75

		-- Check energy
		if data.energy < cost then
			print("[PHASE 4] " .. player.Name .. " tried to train " .. ghost.name .. " but has insufficient energy (" .. data.energy .. " < " .. cost .. ")")
			return
		end

		-- Deduct energy and train
		data.energy = data.energy - cost
		ghost.level = ghost.level + 1

		print("[PHASE 4] " .. player.Name .. " trained " .. ghost.name .. " to level " .. ghost.level .. " for " .. cost .. " energy!")

		-- Send immediate broadcast to update client UI with full payload
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] TrainGhost handler connected")
end

-- ReleaseGhost remote handler
local releaseGhostRemote = remotesFolder:FindFirstChild("ReleaseGhost")
if releaseGhostRemote then
	releaseGhostRemote.OnServerEvent:Connect(function(player, ghostKey)
		local data = initPlayerData(player.UserId)

		-- Validate ghost exists
		if not data.ghostInventory[ghostKey] then
			print("[PHASE 4] " .. player.Name .. " tried to release non-existent ghost: " .. ghostKey)
			return
		end

		local ghost = data.ghostInventory[ghostKey]
		print("[PHASE 4] " .. player.Name .. " released " .. ghost.name .. " (key: " .. ghostKey .. ")")

		-- Remove ghost from inventory
		data.ghostInventory[ghostKey] = nil
		data.ghosts = math.max(0, data.ghosts - 1)

		-- Broadcast updated state
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] ReleaseGhost handler connected")
end

-- HatchEgg remote handler (gacha)
local hatchEggRemote = remotesFolder:FindFirstChild(Constants.Remotes.GachaPull)
if hatchEggRemote then
	hatchEggRemote.OnServerEvent:Connect(function(player, eggName)
		local data = initPlayerData(player.UserId)

		-- Validate egg
		if not eggConfig[eggName] then
			print("[PHASE 4] " .. player.Name .. " tried to hatch invalid egg: " .. eggName)
			return
		end

		local eggData = eggConfig[eggName]

		-- Check coins
		if data.coins < eggData.cost then
			print("[PHASE 4] " .. player.Name .. " tried to hatch " .. eggName .. " but has insufficient coins (" .. data.coins .. " < " .. eggData.cost .. ")")
			return
		end

		-- Check inventory limit
		local maxSlots = getMaxGhostSlots(data.rooms.GhostChamber.level)
		local currentCount = 0
		for _ in pairs(data.ghostInventory) do
			currentCount = currentCount + 1
		end

		if currentCount >= maxSlots then
			print("[PHASE 4] " .. player.Name .. " tried to hatch but inventory is full (" .. currentCount .. "/" .. maxSlots .. ")")
			local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
			if notifyRemote then
				notifyRemote:FireClient(player, "Inventory full! Release ghosts or upgrade Ghost Chamber", Color3.fromRGB(255, 100, 100))
			end
			return
		end

		-- Deduct coins
		data.coins = data.coins - eggData.cost

		-- Roll for rarity (simplified: use egg's base rarity)
		local rarity = eggData.rarity

		-- Get random ghost from that rarity pool
		local ghostPool = availableGhosts[rarity] or availableGhosts["Common"]
		local hatchedName = ghostPool[math.random(1, #ghostPool)]

		-- Add to inventory
		local inventoryKey = hatchedName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = { name = hatchedName, level = 1, rarity = rarity }
		data.ghosts = data.ghosts + 1

		print("[PHASE 4] " .. player.Name .. " hatched " .. eggName .. " and received " .. hatchedName .. " (" .. rarity .. ")!")

		-- Send immediate broadcast to update client UI
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] GachaPull handler connected")
end

-- UnlockZone remote handler
local unlockZoneRemote = remotesFolder:FindFirstChild(Constants.Remotes.UnlockZone)
if unlockZoneRemote then
	unlockZoneRemote.OnServerEvent:Connect(function(player, zoneName)
		local data = initPlayerData(player.UserId)

		-- Validate zone
		if not zoneConfig[zoneName] then
			print("[PHASE 4] " .. player.Name .. " tried to unlock invalid zone: " .. zoneName)
			return
		end

		local zoneData = zoneConfig[zoneName]

		-- Check if already unlocked (unlockedZones is a dictionary)
		local isUnlocked = data.unlockedZones[zoneName] == true

		if isUnlocked then
			print("[PHASE 4] " .. player.Name .. " tried to unlock already-unlocked zone: " .. zoneName)
			return
		end

		-- Check coins
		if data.coins < zoneData.cost then
			print("[PHASE 4] " .. player.Name .. " tried to unlock " .. zoneName .. " but has insufficient coins (" .. data.coins .. " < " .. zoneData.cost .. ")")
			return
		end

		-- Deduct coins and unlock
		data.coins = data.coins - zoneData.cost
		data.unlockedZones[zoneName] = true

		print("[PHASE 4] " .. player.Name .. " unlocked " .. zoneName .. " for " .. zoneData.cost .. " coins!")

		-- Send immediate broadcast to update client UI with full payload
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Coins = data.coins,
				Energy = data.energy,
				GhostCount = data.ghosts,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] UnlockZone handler connected")
end

-- ==================== EQUIPMENT MANAGEMENT REMOTES ====================

-- Purchase Equipment
local purchaseEquipmentRemote = createRemote("PurchaseEquipment", "RemoteFunction")
purchaseEquipmentRemote.OnServerInvoke = function(player, equipmentName)
	local userId = player.UserId
	local result = CatchingSystem:purchaseEquipment(userId, equipmentName)

	if result.success then
		print("[PHASE 4] " .. player.Name .. " purchased " .. equipmentName)
		local data = initPlayerData(userId)
		data.coins = PlayerInventory:getCoins(userId)
	else
		print("[PHASE 4] " .. player.Name .. " failed to purchase " .. equipmentName .. ": " .. result.reason)
	end

	return result
end

-- Equip Equipment
local equipEquipmentRemote = createRemote("EquipEquipment", "RemoteFunction")
equipEquipmentRemote.OnServerInvoke = function(player, equipmentName)
	local userId = player.UserId
	local result = CatchingSystem:equipEquipment(userId, equipmentName)

	if result.success then
		print("[PHASE 4] " .. player.Name .. " equipped " .. equipmentName)
	end

	return result
end

-- Get Equipment Info
local getEquipmentRemote = createRemote("GetEquipmentInfo", "RemoteFunction")
getEquipmentRemote.OnServerInvoke = function(player, ghostRarity)
	local userId = player.UserId
	return CatchingSystem:getEquipmentInfo(userId, ghostRarity)
end

-- Get All Player Equipment
local getPlayerEquipmentRemote = createRemote("GetPlayerEquipment", "RemoteFunction")
getPlayerEquipmentRemote.OnServerInvoke = function(player)
	local userId = player.UserId
	return CatchingSystem:getPlayerEquipmentStats(userId)
end

print("[PHASE 4] Equipment management remotes created")

-- ==================== PVP SYSTEM ====================

-- Get PvP system from SystemManager (will be available after initialization)
local function getPvPSystem()
	if SystemManager then
		return SystemManager:getSystem("PvPSystem")
	end
	return nil
end

-- Challenge another player
local challengeRemote = remotesFolder:FindFirstChild(Constants.Remotes.ChallengePlayer)
if challengeRemote then
	challengeRemote.OnServerInvoke = function(attacker, defenderName)
		local pvpSystem = getPvPSystem()
		if not pvpSystem then
			return false, "PvP system not initialized"
		end

		local defender = Players:FindFirstChild(defenderName)
		if not defender then
			return false, "Player not found"
		end

		if defender == attacker then
			return false, "Cannot challenge yourself"
		end

		local success, result = pvpSystem:startBattle(attacker, defender)
		if success then
			-- Broadcast battle result to both players
			local battleRemote = remotesFolder:FindFirstChild(Constants.Remotes.BattleResult)
			if battleRemote then
				battleRemote:FireClient(attacker, result)
				battleRemote:FireClient(defender, result)
			end
			return true, result
		else
			return false, result
		end
	end
	print("[PHASE 4] PvP Challenge handler connected")
end

-- Get PvP stats
local respondRemote = remotesFolder:FindFirstChild(Constants.Remotes.RespondToChallenge)
if respondRemote then
	respondRemote.OnServerInvoke = function(player)
		local pvpSystem = getPvPSystem()
		if not pvpSystem then
			return {}
		end

		return pvpSystem:getPlayerStats(player) or {
			Wins = 0,
			Losses = 0,
			Rating = 1000,
			LastBattleTime = 0
		}
	end
	print("[PHASE 4] PvP Stats handler connected")
end

-- ==================== ADMIN COMMANDS ====================

-- Server-side admin command handler
local function processAdminCommand(player, command, arg)
	local data = initPlayerData(player.UserId)
	if not data then return end

	if command == "coin" or command == "gold" then
		data.coins = data.coins + 1000
		print("[ADMIN] " .. player.Name .. " gained 1000 coins (total: " .. data.coins .. ")")
		return true
	elseif command == "energy" then
		data.coins = data.coins + 1000
		print("[ADMIN] " .. player.Name .. " gained 1000 energy (total: " .. data.coins .. ")")
		return true
	elseif command == "ghost" then
		local ghostName = arg or "Captain Wisp"
		local rarity = GhostData.RarityMap[ghostName] or "Common"
		local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = {
			name = ghostName,
			rarity = rarity,
			level = 1
		}
		data.ghosts = data.ghosts + 1
		print("[ADMIN] " .. player.Name .. " spawned ghost: " .. ghostName .. " (" .. rarity .. ")")
		return true
	elseif command == "spawnworld" then
		-- Spawn a specific ghost in the world near the player so you can see the image on it
		local ghostName = arg or "Captain Wisp"
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local pos = character.HumanoidRootPart.Position + Vector3.new(0, 5, -8)
			local zoneContainer = workspace:FindFirstChild("ZoneContainer")
			local targetFolder = zoneContainer and zoneContainer:FindFirstChild("Zone_1_Meadow") or workspace
			-- Temporarily override spawn position by calling spawnGhost with fixed position
			local rarity = GhostData.RarityMap[ghostName] or "Common"
			local color = rarityColors[rarity] or Color3.fromRGB(200, 200, 200)

			local ghostModel = Instance.new("Model")
			ghostModel.Name = ghostName
			ghostModel.Parent = targetFolder

			local body = Instance.new("Part")
			body.Shape = Enum.PartType.Ball
			body.Size = Vector3.new(3, 3, 3)
			body.CanCollide = false
			body.Color = color
			body.Material = Enum.Material.SmoothPlastic
			body.Transparency = 0.15
			body.Position = pos
			body.Parent = ghostModel
			ghostModel.PrimaryPart = body

			local imageId = GhostData.GhostImages and GhostData.GhostImages[ghostName]
			if imageId and imageId ~= 0 then
				local face = Instance.new("Part")
				face.Name = "Face"
				face.Size = Vector3.new(2.5, 2.5, 0.05)
				face.CanCollide = false
				face.Anchored = false
				face.Color = Color3.fromRGB(255, 255, 255)
				face.Material = Enum.Material.SmoothPlastic
				face.CastShadow = false
				face.Position = pos + Vector3.new(0, 0.3, -1.55)
				face.Parent = ghostModel

				local faceWeld = Instance.new("WeldConstraint")
				faceWeld.Part0 = body
				faceWeld.Part1 = face
				faceWeld.Parent = body

				local decal = Instance.new("Decal")
				decal.Texture = "rbxassetid://" .. imageId
				decal.Face = Enum.NormalId.Front
				decal.Parent = face
			end

			local light = Instance.new("PointLight")
			light.Brightness = 1.5
			light.Range = 18
			light.Color = color
			light.Parent = body

			local billboard = Instance.new("BillboardGui")
			billboard.Size = UDim2.new(0, 120, 0, 45)
			billboard.StudsOffset = Vector3.new(0, 2.5, 0)
			billboard.Parent = body

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, 0, 1, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			nameLabel.TextStrokeTransparency = 0
			nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			nameLabel.TextSize = 13
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.Text = ghostName .. "\n[PREVIEW]"
			nameLabel.Parent = billboard

			body:SetAttribute("GhostName", ghostName)
			body:SetAttribute("Rarity", rarity)
			activeGhosts[body] = { name = ghostName, rarity = rarity }

			task.delay(30, function()
				if ghostModel.Parent then
					activeGhosts[body] = nil
					ghostModel:Destroy()
				end
			end)

			print("[ADMIN] Spawned " .. ghostName .. " in world near " .. player.Name)
		end
		return true
	end
end

-- Connect admin command remote
local adminRemote = remotesFolder:FindFirstChild("AdminCommand")
if adminRemote then
	adminRemote.OnServerInvoke = function(player, command, arg)
		return processAdminCommand(player, command, arg)
	end
	print("[PHASE 4] Admin command system ready (/coin, /energy, /ghost)")
end

-- ==================== UI BROADCAST ====================

-- UI update loop (broadcast every second)
task.spawn(function()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data then
				-- Calculate energy production from ghosts
				local totalEnergyPerSec = 0
				for _, ghost in pairs(data.ghostInventory) do
					if ghost and ghost.level then
						-- Base energy scales with ghost level
						local baseEnergy = 0.7
						-- Rarity multiplier (from GhostData)
						local rarityMultipliers = {
							Common = 1,
							Uncommon = 1.5,
							Rare = 2,
							Epic = 3,
							Legendary = 6,
							Corrupted = 9
						}
						local rarityMult = rarityMultipliers[ghost.rarity] or 1
						-- Total energy per second for this ghost
						totalEnergyPerSec = totalEnergyPerSec + (baseEnergy * ghost.level * rarityMult)
					end
				end

				-- Add energy production to energy pool
				data.energy = data.energy + totalEnergyPerSec

				-- Broadcast UI update
				local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
				if updateRemote then
					updateRemote:FireClient(player, {
						VacuumCharge = data.charge,
						Coins = data.coins,
						Energy = data.energy,
						GhostCount = data.ghosts,
						GhostInventory = data.ghostInventory,
						Rooms = data.rooms,
						UnlockedZones = data.unlockedZones,
					})
				end
			end
		end
	end
end)

-- ==================== STARTUP ====================

-- Initialize ZoneManager for zone detection and barriers
if zoneManager and zoneManager.initialize then
	zoneManager:initialize()
	print("[PHASE 4] ZoneManager initialized, starting ghost spawn loop...")
	startGhostSpawnLoop()
end

print("[PHASE 4] ✅ Phase 4 extended testing server ready!")
print("[PHASE 4] Ghosts spawning every " .. Config.GhostSpawnRate .. " seconds in all zones")
print("[PHASE 4] Catch distance: " .. Config.GhostCatchDistance .. " studs (must be within this range)")
print("[PHASE 4] Click CHARGE to increase vacuum charge by 25%")
print("[PHASE 4] Click CATCH to catch nearby ghosts and earn coins")
print("[PHASE 4] Optional handlers ready:")
print("[PHASE 4]   - UpgradeRoom: Upgrade HQ rooms (costs coins)")
print("[PHASE 4]   - TrainGhost: Level up caught ghosts (costs coins)")
print("[PHASE 4]   - HatchEgg: Gacha pull random ghost (costs coins)")
print("[PHASE 4]   - UnlockZone: Unlock new zones (costs coins)")
