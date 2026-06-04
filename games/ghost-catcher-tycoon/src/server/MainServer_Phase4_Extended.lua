--
-- Ghost Catcher Tycoon - Phase 4 Extended (Minimal Ghost Spawning + Optional Handlers)
-- No dependencies - spawns test ghosts directly, includes room upgrades, ghost training, egg hatching, zone unlocks
--
local Players = game:GetService("Players")

print("[PHASE 4] Starting Phase 4 extended testing server...")

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
createRemote(Constants.Remotes.UpgradeRoom, "RemoteEvent")
createRemote(Constants.Remotes.TrainGhost, "RemoteEvent")
createRemote(Constants.Remotes.GachaPull, "RemoteEvent")
createRemote(Constants.Remotes.UnlockZone, "RemoteEvent")
createRemote(Constants.Remotes.BringGhostsHome, "RemoteEvent")

-- Create admin command remote immediately
if not remotesFolder:FindFirstChild("AdminCommand") then
	local adminRemote = Instance.new("RemoteFunction")
	adminRemote.Name = "AdminCommand"
	adminRemote.Parent = remotesFolder
end

print("[PHASE 4] Remotes created (including optional handlers)")

-- ==================== GAME CONFIGURATION ====================

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

-- ==================== PLAYER DATA ====================

local playerData = {}

-- Expose playerData globally so admin commands can access it
_G.GhostCatcherPlayerData = playerData

local function initPlayerData(userId)
	if not playerData[userId] then
		playerData[userId] = {
			charge = 0,
			coins = 0,
			ghosts = 0,
			ghostInventory = {}, -- { ghostName: { level, rarity } }
			rooms = {
				GhostChamber = { level = 1 },
				TrainingFacility = { level = 1 },
				EnergyReactor = { level = 1 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = { ["Whisper Woods"] = true },
		}
	end
	return playerData[userId]
end

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

		-- Remove ghost from world
		closestGhost:Destroy()
		activeGhosts[closestGhost] = nil

		print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") for " .. coins .. " coins!")
	end)
	print("[PHASE 4] Catch handler connected")
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

		-- Calculate cost (cost scales with level)
		local cost = math.ceil(config.baseCost * (config.costMultiplier ^ (room.level - 1)))

		-- Check coins
		if data.coins < cost then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade " .. roomName .. " but has insufficient coins (" .. data.coins .. " < " .. cost .. ")")
			return
		end

		-- Deduct coins and upgrade
		data.coins = data.coins - cost
		room.level = room.level + 1

		print("[PHASE 4] " .. player.Name .. " upgraded " .. roomName .. " to level " .. room.level .. " for " .. cost .. " coins!")
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

		-- Calculate cost (scales with ghost level and rarity)
		local rarityMultiplier = { Common = 1, Uncommon = 1.5, Rare = 2, Epic = 3, Legendary = 5 }
		local multiplier = rarityMultiplier[ghost.rarity] or 1
		local baseCost = 50 * multiplier
		local cost = math.ceil(baseCost * (ghost.level))

		-- Check coins
		if data.coins < cost then
			print("[PHASE 4] " .. player.Name .. " tried to train " .. ghost.name .. " but has insufficient coins (" .. data.coins .. " < " .. cost .. ")")
			return
		end

		-- Deduct coins and train
		data.coins = data.coins - cost
		ghost.level = ghost.level + 1

		print("[PHASE 4] " .. player.Name .. " trained " .. ghost.name .. " to level " .. ghost.level .. " for " .. cost .. " coins!")
	end)
	print("[PHASE 4] TrainGhost handler connected")
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

		-- Send immediate broadcast to update client UI
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				Energy = data.coins,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] UnlockZone handler connected")
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
		local ghostName = arg or "Wraith"
		local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = {
			name = ghostName,
			rarity = "Rare",
			level = 1
		}
		data.ghosts = data.ghosts + 1
		print("[ADMIN] " .. player.Name .. " spawned ghost: " .. ghostName)
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
				local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
				if updateRemote then
					updateRemote:FireClient(player, {
						VacuumCharge = data.charge,
						Energy = data.coins,
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

print("[PHASE 4] ✅ Phase 4 extended testing server ready!")
print("[PHASE 4] Ghosts spawning every 3 seconds in all zones")
print("[PHASE 4] Click CHARGE to increase vacuum charge by 25%")
print("[PHASE 4] Click CATCH to catch nearby ghosts and earn coins")
print("[PHASE 4] Optional handlers ready:")
print("[PHASE 4]   - UpgradeRoom: Upgrade HQ rooms (costs coins)")
print("[PHASE 4]   - TrainGhost: Level up caught ghosts (costs coins)")
print("[PHASE 4]   - HatchEgg: Gacha pull random ghost (costs coins)")
print("[PHASE 4]   - UnlockZone: Unlock new zones (costs coins)")
