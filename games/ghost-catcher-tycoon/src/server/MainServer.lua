--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Server entry point: initializes all game systems, manages remotes, and coordinates player lifecycle.
--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load shared modules
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local Enums = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("enums"))

-- Load systems
print("[DEBUG] Loading systems...")
local DataManager = require(script.Parent:WaitForChild("data"):WaitForChild("DataManager"))
print("[DEBUG] Loaded DataManager")
local CurrencySystem = require(script.Parent:WaitForChild("systems"):WaitForChild("CurrencySystem"))
print("[DEBUG] Loaded CurrencySystem")
local VacuumSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("VacuumSystem"))
local GhostSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSystem"))
local ProductionSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("ProductionSystem"))
local HQSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("HQSystem"))
local TrainingSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("TrainingSystem"))
local ZoneSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("ZoneSystem"))
local MonetizationSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("MonetizationSystem"))
local AutoCatchSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("AutoCatchSystem"))
local AutoTrainSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("AutoTrainSystem"))
local QuestSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("QuestSystem"))
local LeaderboardSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("LeaderboardSystem"))
local GachaSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("GachaSystem"))
local CosmeticsSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("CosmeticsSystem"))
local PvPSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("PvPSystem"))
local PrestigeSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("PrestigeSystem"))
local EventSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("EventSystem"))
local EggSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("EggSystem"))
local BossSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("BossSystem"))
local GhostService = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostService"))
local GhostSpawner = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSpawner"))
print("[DEBUG] All systems loaded")

-- Initialize systems
local dataManager = DataManager:new()
local currencySystem = CurrencySystem:new()
local vacuumSystem = VacuumSystem:new()
local ghostSystem = GhostSystem:new()
local productionSystem = ProductionSystem:new()
local hqSystem = HQSystem:new()
local trainingSystem = TrainingSystem:new()
local zoneSystem = ZoneSystem:new()
local monetizationSystem = MonetizationSystem:new()
local autoCatchSystem = AutoCatchSystem:new()
local autoTrainSystem = AutoTrainSystem:new()
local questSystem = QuestSystem:new()
local leaderboardSystem = LeaderboardSystem:new()
local gachaSystem = GachaSystem:new()
local cosmeticsSystem = CosmeticsSystem:new()
local pvpSystem = PvPSystem:new()
local prestigeSystem = PrestigeSystem:new()
local eventSystem = EventSystem:new()
local eggSystem = EggSystem:new()
local bossSystem = BossSystem:new()
local ghostService = GhostService:new()
local ghostSpawner = GhostSpawner:new()

-- Link systems together
currencySystem:setDataManager(dataManager)
productionSystem:setCurrencySystem(currencySystem)
productionSystem:setGhostSystem(ghostSystem)
productionSystem:setHQSystem(hqSystem)
productionSystem:setEventSystem(eventSystem)
productionSystem:setPrestigeSystem(prestigeSystem)
hqSystem:setCurrencySystem(currencySystem)
trainingSystem:setCurrencySystem(currencySystem)
trainingSystem:setGhostSystem(ghostSystem)
zoneSystem:setCurrencySystem(currencySystem)
zoneSystem:setGhostSystem(ghostSystem)
monetizationSystem:setCurrencySystem(currencySystem)
monetizationSystem:setGhostSystem(ghostSystem)
autoCatchSystem:setGhostSystem(ghostSystem)
autoCatchSystem:setVacuumSystem(vacuumSystem)
autoCatchSystem:setMonetizationSystem(monetizationSystem)
autoTrainSystem:setTrainingSystem(trainingSystem)
autoTrainSystem:setGhostSystem(ghostSystem)
autoTrainSystem:setMonetizationSystem(monetizationSystem)
autoTrainSystem:setCurrencySystem(currencySystem)
questSystem:setDataManager(dataManager)
leaderboardSystem:setDataManager(dataManager)
gachaSystem:setGhostSystem(ghostSystem)
gachaSystem:setCurrencySystem(currencySystem)
gachaSystem:setDataManager(dataManager)
cosmeticsSystem:setCurrencySystem(currencySystem)
cosmeticsSystem:setDataManager(dataManager)
pvpSystem:setGhostSystem(ghostSystem)
pvpSystem:setCurrencySystem(currencySystem)
pvpSystem:setDataManager(dataManager)
prestigeSystem:setCurrencySystem(currencySystem)
prestigeSystem:setGhostSystem(ghostSystem)
prestigeSystem:setHQSystem(hqSystem)
prestigeSystem:setZoneSystem(zoneSystem)
prestigeSystem:setDataManager(dataManager)
eggSystem:setCurrencySystem(currencySystem)
eggSystem:setGhostSystem(ghostSystem)
bossSystem:setCurrencySystem(currencySystem)
bossSystem:setGhostSystem(ghostSystem)
bossSystem:setZoneSystem(zoneSystem)

-- GhostService is standalone; no interdependencies needed
-- Other systems can call ghostService:givePlayerGhost(player, stats) as needed

-- Start ghost spawning in zones
ghostSpawner:startSpawning()

print("[Ghost Catcher Tycoon] Server started")

-- Setup RemoteEvents in ReplicatedStorage
local function setupRemotes()
	print("[DEBUG] setupRemotes() starting...")
	local rs = game:GetService("ReplicatedStorage")
	print("[DEBUG] Got ReplicatedStorage")

	-- Create folders if they don't exist
	if not rs:FindFirstChild("Remotes") then
		local remotesFolder = Instance.new("Folder")
		remotesFolder.Name = "Remotes"
		remotesFolder.Parent = rs
		print("[DEBUG] Created Remotes folder")
	end

	local remotesFolder = rs:FindFirstChild("Remotes")
	if not remotesFolder then
		error("[ERROR] Remotes folder not found after creation!")
		return
	end
	print("[DEBUG] Found/created Remotes folder")

	-- Create RemoteEvents
	local function createRemote(name, className)
		if not remotesFolder:FindFirstChild(name) then
			local remote = Instance.new(className)
			remote.Name = name
			remote.Parent = remotesFolder
			print("[DEBUG] Created remote: " .. name)
			return remote
		end
		return remotesFolder:FindFirstChild(name)
	end

	createRemote(Constants.Remotes.ChargeVacuum, "RemoteEvent")
	createRemote(Constants.Remotes.CatchGhost, "RemoteEvent")
	createRemote(Constants.Remotes.BringGhostsHome, "RemoteEvent")
	createRemote(Constants.Remotes.TrainGhost, "RemoteEvent")
	createRemote(Constants.Remotes.UpgradeRoom, "RemoteEvent")
	createRemote(Constants.Remotes.UnlockZone, "RemoteEvent")
	createRemote(Constants.Remotes.UpdateUI, "RemoteEvent")
	createRemote(Constants.Remotes.ShowNotification, "RemoteEvent")
	createRemote(Constants.Remotes.GetGameState, "RemoteFunction")
	createRemote(Constants.Remotes.SpawnBoss, "RemoteEvent")
	createRemote(Constants.Remotes.PurchaseGamePass, "RemoteEvent")
	createRemote(Constants.Remotes.PurchaseProduct, "RemoteEvent")
	createRemote("HatchEgg", "RemoteEvent")

	print("[Ghost Catcher Tycoon] Remotes created")
end

-- Setup player join
local function onPlayerJoined(player)
	print("[Ghost Catcher Tycoon] Player joined: " .. player.Name)

	-- Load player data
	local playerData = dataManager:loadPlayerData(player)
	print("[Ghost Catcher Tycoon] Data loaded for " .. player.Name)

	-- Initialize all systems for this player
	vacuumSystem:initializePlayer(player)
	ghostSystem:initializePlayer(player)
	productionSystem:initializePlayer(player)
	hqSystem:initializePlayer(player)
	trainingSystem:initializePlayer(player)
	zoneSystem:initializePlayer(player)
	monetizationSystem:initializePlayer(player)
	autoCatchSystem:initializePlayer(player)
	autoTrainSystem:initializePlayer(player)
	questSystem:initializePlayer(player)
	leaderboardSystem:initializePlayer(player)
	gachaSystem:initializePlayer(player)
	cosmeticsSystem:initializePlayer(player)
	pvpSystem:initializePlayer(player)
	prestigeSystem:initializePlayer(player)
	eventSystem:initializePlayer(player)
	eggSystem:initializePlayer(player)

	-- Send initial game state to client
	local rs = Constants.Paths.ReplicatedStorage
	local getGameStateRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.GetGameState)

	getGameStateRemote.OnServerInvoke = function(player)
		local data = dataManager:getPlayerData(player)
		-- Add real-time data
		data.VacuumCharge = vacuumSystem:getCharge(player)
		data.GhostCount = ghostSystem:getPlayerGhostCount(player)
		data.ProductionRate = productionSystem:calculateEnergyPerSecond(player)
		return data
	end
end

-- Setup player leave
local function onPlayerLeft(player)
	print("[Ghost Catcher Tycoon] Player left: " .. player.Name)

	-- Save player data before removing
	dataManager:savePlayerData(player)

	-- Clean up player-specific data in all systems
	vacuumSystem:removePlayer(player.UserId)
	ghostSystem:removePlayer(player.UserId)
	productionSystem:removePlayer(player.UserId)
	hqSystem:removePlayer(player.UserId)
	trainingSystem:removePlayer(player.UserId)
	zoneSystem:removePlayer(player.UserId)
	monetizationSystem:removePlayer(player.UserId)
	autoCatchSystem:removePlayer(player.UserId)
	autoTrainSystem:removePlayer(player.UserId)
	questSystem:removePlayer(player.UserId)
	leaderboardSystem:removePlayer(player.UserId)
	gachaSystem:removePlayer(player.UserId)
	cosmeticsSystem:removePlayer(player.UserId)
	pvpSystem:removePlayer(player.UserId)
	prestigeSystem:removePlayer(player.UserId)
	eventSystem:removePlayer(player.UserId)
	eggSystem:removePlayer(player.UserId)
	dataManager:clearCache(player.UserId)
end

-- Setup vacuum charging remote
local function setupVacuumRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local chargeVacuumRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.ChargeVacuum)

	chargeVacuumRemote.OnServerEvent:Connect(function(player)
		if vacuumSystem:chargeVacuum(player) then
			-- Charge successful
		else
			-- Handle charge failure
			print("[Error] Failed to charge vacuum for " .. player.Name)
		end
	end)

	print("[Ghost Catcher Tycoon] Vacuum remote setup complete")
end

-- Setup catch ghost remote
local function setupCatchRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local catchRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.CatchGhost)

	catchRemote.OnServerEvent:Connect(function(player)
		local vacuum = vacuumSystem:getCharge(player)

		-- Check if player has enough vacuum charge
		if vacuum < 10 then
			Constants.Remotes.ShowNotification:FireClient(player, "❌ Not enough charge!", Color3.fromRGB(255, 100, 100))
			return
		end

		-- Find nearest ghost to player
		local character = player.Character
		if not character then return end

		local playerPos = character:FindFirstChild("HumanoidRootPart").Position
		local closestGhost = nil
		local closestDist = 100

		for ghostInstance, data in pairs(ghostSpawner.activeGhosts) do
			if ghostInstance and ghostInstance.Parent then
				local dist = (ghostInstance.Position - playerPos).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestGhost = ghostInstance
				end
			end
		end

		if not closestGhost then
			Constants.Remotes.ShowNotification:FireClient(player, "👻 No ghosts nearby!", Color3.fromRGB(100, 150, 255))
			return
		end

		-- Get ghost data
		local ghostName = closestGhost:GetAttribute("GhostName")
		local rarity = closestGhost:GetAttribute("Rarity")
		local personality = closestGhost:GetAttribute("Personality")

		-- Deduct charge
		vacuumSystem:deductCharge(player, 10)

		-- Add ghost to inventory
		ghostService:givePlayerRandomGhost(player, ghostName)

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
		currencySystem:addEnergy(player, coins, "catch")

		-- Remove ghost from world
		ghostSpawner:removeGhost(closestGhost)

		-- Notify player
		Constants.Remotes.ShowNotification:FireClient(player, "✨ Caught " .. ghostName .. "! +" .. coins .. " coins", Color3.fromRGB(100, 255, 100))

		print("[Ghost Catcher] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ")")
	end)

	print("[Ghost Catcher Tycoon] Catch remote setup complete")
end

-- Setup training remote
local function setupTrainingRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local trainRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.TrainGhost)

	trainRemote.OnServerEvent:Connect(function(player, ghostId, targetLevel)
		local success, result = trainingSystem:startTraining(player, ghostId, targetLevel)
		if success then
			-- Training started successfully
			Constants.Remotes.ShowNotification:FireClient(player, "🎓 Training: " .. result.ghostId .. " → Level " .. result.targetLevel, Color3.fromRGB(120, 50, 200))
			print("[Ghost Catcher Tycoon] " .. player.Name .. " started training ghost to level " .. result.targetLevel)
		else
			-- Training failed
			Constants.Remotes.ShowNotification:FireClient(player, "❌ " .. tostring(result), Color3.fromRGB(255, 100, 100))
			print("[Error] Training failed for " .. player.Name .. ": " .. result)
		end
	end)

	print("[Ghost Catcher Tycoon] Training remote setup complete")
end

-- Setup zone unlock remote
local function setupZoneRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local unlockRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.UnlockZone)

	unlockRemote.OnServerEvent:Connect(function(player, zoneName)
		local success, result = zoneSystem:unlockZone(player, zoneName)
		if not success then
			print("[Error] Zone unlock failed for " .. player.Name .. ": " .. result)
		end
	end)

	print("[Ghost Catcher Tycoon] Zone remote setup complete")
end

-- Setup HQ room upgrade remote
local function setupUpgradeRoomRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local upgradeRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.UpgradeRoom)

	upgradeRemote.OnServerEvent:Connect(function(player, roomName)
		local success, result = hqSystem:upgradeRoom(player, roomName)
		if success then
			-- Notify client
			Constants.Remotes.ShowNotification:FireClient(player, "✅ " .. roomName .. " upgraded to level " .. result.level, Color3.fromRGB(100, 255, 100))
			print("[Ghost Catcher Tycoon] " .. player.Name .. " upgraded " .. roomName .. " to level " .. result.level)
		else
			-- Notify client of failure
			Constants.Remotes.ShowNotification:FireClient(player, "❌ " .. tostring(result), Color3.fromRGB(255, 100, 100))
			print("[Error] Room upgrade failed for " .. player.Name .. ": " .. tostring(result))
		end
	end)

	print("[Ghost Catcher Tycoon] Upgrade room remote setup complete")
end

-- Setup monetization remote
local function setupMonetizationRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local passRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.PurchaseGamePass)
	local productRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.PurchaseProduct)

	passRemote.OnServerEvent:Connect(function(player, passName)
		local success, result = monetizationSystem:grantGamePass(player, passName)
		if not success then
			print("[Error] GamePass grant failed for " .. player.Name .. ": " .. result)
		end
	end)

	productRemote.OnServerEvent:Connect(function(player, productName, quantity)
		local success, result = monetizationSystem:purchaseProduct(player, productName, quantity or 1)
		if not success then
			print("[Error] Product purchase failed for " .. player.Name .. ": " .. result)
		end
	end)

	print("[Ghost Catcher Tycoon] Monetization remotes setup complete")
end

-- Setup egg hatching remote
local function setupEggRemote()
	print("[DEBUG] setupEggRemote() called")

	if not eggSystem then
		print("[Error] eggSystem is nil!")
		return
	end

	local rs = Constants.Paths.ReplicatedStorage
	print("[DEBUG] Got ReplicatedStorage")

	local remotesFolder = rs:FindFirstChild("Remotes")
	if not remotesFolder then
		print("[Error] Remotes folder not found!")
		return
	end

	print("[DEBUG] Found Remotes folder")

	local hatchEggRemote = remotesFolder:FindFirstChild("HatchEgg")
	if not hatchEggRemote then
		print("[Error] HatchEgg remote not found!")
		print("[DEBUG] Available remotes: " .. table.concat(remotesFolder:GetChildren(), ", "))
		return
	end

	print("[DEBUG] Found HatchEgg remote")

	hatchEggRemote.OnServerEvent:Connect(function(player, eggType)
		print("[DEBUG] HatchEgg remote fired - Player: " .. player.Name .. ", EggType: " .. tostring(eggType))

		local success, ghost, message = eggSystem:hatchEgg(player, eggType)
		print("[DEBUG] hatchEgg returned - Success: " .. tostring(success) .. ", Message: " .. tostring(message))

		local updateRemote = rs:FindFirstChild("Remotes"):FindFirstChild(Constants.Remotes.UpdateUI)
		if success and updateRemote then
			print("[DEBUG] Sending update to client")
			-- Send ghost data to client
			updateRemote:FireClient(player, {
				Ghost = ghost,
				GhostCount = ghostSystem:getPlayerGhostCount(player),
				Energy = currencySystem:getEnergy(player),
			})
		end

		-- Send notification
		local notificationRemote = rs:FindFirstChild("Remotes"):FindFirstChild(Constants.Remotes.ShowNotification)
		if notificationRemote then
			print("[DEBUG] Sending notification: " .. tostring(message))
			notificationRemote:FireClient(player, message)
		end

		if not success then
			print("[Error] Egg hatch failed for " .. player.Name .. ": " .. message)
		else
			print("[Ghost Catcher Tycoon] Egg hatched! " .. player.Name .. " got " .. ghost.name .. " (" .. ghost.rarity .. ")")
		end
	end)

	print("[Ghost Catcher Tycoon] Egg remote setup complete")
end

-- Setup production loop
local function setupProductionLoop()
	while true do
		task.wait(Config.Production.UpdateFrequency)

		-- Process production, training, and auto systems for all online players
		for _, player in pairs(Players:GetPlayers()) do
			productionSystem:tick(player)
			trainingSystem:tick(player)
			autoCatchSystem:tick(player, zoneSystem:getUnlockedZones(player)[1] or "Forest")
			autoTrainSystem:tick(player)

			-- Send updated UI data
			local updateRemote = Constants.Paths.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				local uiData = {
					Energy = currencySystem:getEnergy(player),
					VacuumCharge = vacuumSystem:getCharge(player),
					GhostCount = ghostSystem:getPlayerGhostCount(player),
					ProductionRate = productionSystem:calculateEnergyPerSecond(player),
					UnlockedZones = zoneSystem:getUnlockedZones(player),
					MonetizationData = monetizationSystem:getPlayerMonetizationData(player),
					AutoCatchEnabled = autoCatchSystem:isAutoCatchEnabled(player),
					AutoTrainQueue = autoTrainSystem:getAutoTrainQueue(player),
				}
				updateRemote:FireClient(player, uiData)
			end
		end
	end
end

-- Setup periodic saving
local function setupAutoSave()
	local lastSaveTime = 0

	while true do
		task.wait(Config.AutoSaveInterval)

		-- Process save queue
		dataManager:processSaveQueue()

		-- Save all online players
		for _, player in pairs(Players:GetPlayers()) do
			dataManager:savePlayerData(player)
		end

		lastSaveTime = os.clock()
	end
end

-- Main initialization
local function initialize()
	print("[Ghost Catcher Tycoon] Initializing...")

	-- Setup remotes
	setupRemotes()

	-- Connect player events
	Players.PlayerAdded:Connect(onPlayerJoined)
	Players.PlayerRemoving:Connect(onPlayerLeft)

	-- Handle players already in game (in case script loads late)
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(onPlayerJoined, player)
	end

	-- Setup remotes
	local ok1, err1 = pcall(setupVacuumRemote)
	if not ok1 then print("[Error] Vacuum setup failed: " .. tostring(err1)) end

	local okCatch, errCatch = pcall(setupCatchRemote)
	if not okCatch then print("[Error] Catch setup failed: " .. tostring(errCatch)) end

	local ok2, err2 = pcall(setupTrainingRemote)
	if not ok2 then print("[Error] Training setup failed: " .. tostring(err2)) end

	local ok3, err3 = pcall(setupZoneRemote)
	if not ok3 then print("[Error] Zone setup failed: " .. tostring(err3)) end

	local okUpgrade, errUpgrade = pcall(setupUpgradeRoomRemote)
	if not okUpgrade then print("[Error] Upgrade room setup failed: " .. tostring(errUpgrade)) end

	local ok4, err4 = pcall(setupMonetizationRemote)
	if not ok4 then print("[Error] Monetization setup failed: " .. tostring(err4)) end

	print("[CHECKPOINT] All standard remotes setup")

	local ok5, err5 = pcall(setupEggRemote)
	print("[CHECKPOINT] EggSystem setup returned: " .. tostring(ok5))
	if not ok5 then print("[Error] EggSystem setup failed: " .. tostring(err5)) end

	print("[CHECKPOINT] All remotes complete")

	-- Start production loop
	task.spawn(setupProductionLoop)

	-- Start auto-save loop
	task.spawn(setupAutoSave)

	print("[Ghost Catcher Tycoon] Server initialization complete!")
end

-- Run initialization
initialize()
-- Built with assistance from Claude Code by Anthropic.

