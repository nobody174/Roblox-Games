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

-- Load SystemManager
local SystemManager = require(script.Parent:WaitForChild("SystemManager"))

-- Initialize all systems via SystemManager
print("[DEBUG] Initializing SystemManager...")
local success = SystemManager:initialize()
if not success then
	error("[ERROR] SystemManager initialization failed!")
	return
end

-- Link system dependencies
SystemManager:linkDependencies()

-- Get system instances for use in this script
local dataManager = SystemManager:getSystem("DataManager")
local currencySystem = SystemManager:getSystem("CurrencySystem")
local vacuumSystem = SystemManager:getSystem("VacuumSystem")
local ghostSystem = SystemManager:getSystem("GhostSystem")
local productionSystem = SystemManager:getSystem("ProductionSystem")
local hqSystem = SystemManager:getSystem("HQSystem")
local trainingSystem = SystemManager:getSystem("TrainingSystem")
local zoneSystem = SystemManager:getSystem("ZoneSystem")
local monetizationSystem = SystemManager:getSystem("MonetizationSystem")
local autoCatchSystem = SystemManager:getSystem("AutoCatchSystem")
local autoTrainSystem = SystemManager:getSystem("AutoTrainSystem")
local questSystem = SystemManager:getSystem("QuestSystem")
local leaderboardSystem = SystemManager:getSystem("LeaderboardSystem")
local gachaSystem = SystemManager:getSystem("GachaSystem")
local cosmeticsSystem = SystemManager:getSystem("CosmeticsSystem")
local pvpSystem = SystemManager:getSystem("PvPSystem")
local prestigeSystem = SystemManager:getSystem("PrestigeSystem")
local eventSystem = SystemManager:getSystem("EventSystem")
local eggSystem = SystemManager:getSystem("EggSystem")
local bossSystem = SystemManager:getSystem("BossSystem")
local ghostService = SystemManager:getSystem("GhostService")
local ghostSpawner = SystemManager:getSystem("GhostSpawner")

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

	-- Initialize player in all systems
	SystemManager:initializePlayer(player)

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
	for name, system in pairs(SystemManager:getAllSystems()) do
		if system.removePlayer then
			system:removePlayer(player.UserId)
		end
	end

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

		-- Track quest progress for catching ghosts
		questSystem:updateQuestProgress(player, "CatchGhosts", 1)

		-- Update leaderboard stats
		leaderboardSystem:updatePlayerStat(player, "GhostsCaught", ghostSystem:getPlayerGhostCount(player))

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

-- Setup boss damage remote (for dealing damage to bosses)
local function setupBossDamageRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local spawnBossRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.SpawnBoss)

	spawnBossRemote.OnServerEvent:Connect(function(player, bossId)
		-- Note: This remote could be extended to handle boss-specific actions
		-- For now, boss spawning is handled automatically in the production loop
		print("[BossSystem] SpawnBoss remote called by " .. player.Name .. " for boss ID: " .. tostring(bossId))
	end)

	print("[Ghost Catcher Tycoon] Boss remote setup complete")
end

-- Setup prestige remote
local function setupPrestigeRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local remotesFolder = rs:FindFirstChild("Remotes")

	-- Create or find Prestige remote
	local prestigeRemote = remotesFolder:FindFirstChild("Prestige")
	if not prestigeRemote then
		prestigeRemote = Instance.new("RemoteEvent")
		prestigeRemote.Name = "Prestige"
		prestigeRemote.Parent = remotesFolder
	end

	prestigeRemote.OnServerEvent:Connect(function(player)
		local success, result = prestigeSystem:performPrestige(player)
		if success then
			local message = "✨ Prestiged to level " .. result.newLevel .. "!"
			Constants.Remotes.ShowNotification:FireClient(player, message, Color3.fromRGB(100, 100, 255))
			print("[PrestigeSystem] " .. player.Name .. " prestiged to level " .. result.newLevel)
		else
			local message = "❌ Prestige failed: " .. result
			Constants.Remotes.ShowNotification:FireClient(player, message, Color3.fromRGB(255, 100, 100))
			print("[Error] Prestige failed for " .. player.Name .. ": " .. result)
		end
	end)

	print("[Ghost Catcher Tycoon] Prestige remote setup complete")
end

-- Setup quest claim remote
local function setupQuestRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local remotesFolder = rs:FindFirstChild("Remotes")

	-- Create or find Quest claim remote
	local questRemote = remotesFolder:FindFirstChild("ClaimQuestReward")
	if not questRemote then
		questRemote = Instance.new("RemoteEvent")
		questRemote.Name = "ClaimQuestReward"
		questRemote.Parent = remotesFolder
	end

	questRemote.OnServerEvent:Connect(function(player, frequency, questIndex)
		local success, result = questSystem:claimReward(player, frequency, questIndex)
		if success then
			local rewards = result
			-- Apply rewards to player
			if rewards.Energy then
				currencySystem:addEnergy(player, rewards.Energy, "quest_reward")
			end
			local message = "🎁 Quest completed! +" .. (rewards.Energy or 0) .. " energy"
			Constants.Remotes.ShowNotification:FireClient(player, message, Color3.fromRGB(100, 200, 100))
			print("[QuestSystem] " .. player.Name .. " claimed quest reward: " .. (rewards.Energy or 0) .. " energy")
		else
			local message = "❌ Quest claim failed: " .. result
			Constants.Remotes.ShowNotification:FireClient(player, message, Color3.fromRGB(255, 100, 100))
		end
	end)

	print("[Ghost Catcher Tycoon] Quest remote setup complete")
end

-- Setup leaderboard remote
local function setupLeaderboardRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local remotesFolder = rs:FindFirstChild("Remotes")

	-- Create or find GetLeaderboard remote
	local leaderboardRemote = remotesFolder:FindFirstChild("GetLeaderboard")
	if not leaderboardRemote then
		leaderboardRemote = Instance.new("RemoteFunction")
		leaderboardRemote.Name = "GetLeaderboard"
		leaderboardRemote.Parent = remotesFolder
	end

	leaderboardRemote.OnServerInvoke = function(player, category)
		-- Return the leaderboard for the requested category
		local leaderboard = leaderboardSystem:getLeaderboard(category or "TotalEnergyEarned")
		local playerRank = leaderboardSystem:getPlayerRank(player, category or "TotalEnergyEarned")

		return {
			Leaderboard = leaderboard,
			PlayerRank = playerRank or "Unranked",
		}
	end

	print("[Ghost Catcher Tycoon] Leaderboard remote setup complete")
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

			-- Attempt boss spawn for each zone the player has unlocked
			if player.Character then
				-- Try to spawn bosses in unlocked zones (bosses are in zones 3, 5, 7, 9, 10)
				local bossZoneIds = { 3, 5, 7, 9, 10 }
				for _, zoneId in ipairs(bossZoneIds) do
					-- Each zone has a 15% chance per tick to spawn a boss
					local bossModel = bossSystem:trySpawnBoss(player, zoneId)
					-- Note: if bossModel is nil, it just means spawn chance failed (normal)
				end
			end

			-- Update leaderboard energy stat
			leaderboardSystem:updatePlayerStat(player, "TotalEnergyEarned", currencySystem:getEnergy(player))

			-- Send updated UI data
			local updateRemote = Constants.Paths.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				local prestigeLevel = prestigeSystem:getPrestigeLevel(player)
				local canPrestige, _ = prestigeSystem:canPrestige(player)
				local dailyQuests = questSystem:getQuests(player, "Daily")
				local weeklyQuests = questSystem:getQuests(player, "Weekly")
				local leaderboardRank = leaderboardSystem:getPlayerRank(player, "TotalEnergyEarned")
				local uiData = {
					Energy = currencySystem:getEnergy(player),
					VacuumCharge = vacuumSystem:getCharge(player),
					GhostCount = ghostSystem:getPlayerGhostCount(player),
					ProductionRate = productionSystem:calculateEnergyPerSecond(player),
					UnlockedZones = zoneSystem:getUnlockedZones(player),
					MonetizationData = monetizationSystem:getPlayerMonetizationData(player),
					AutoCatchEnabled = autoCatchSystem:isAutoCatchEnabled(player),
					AutoTrainQueue = autoTrainSystem:getAutoTrainQueue(player),
					PrestigeLevel = prestigeLevel,
					CanPrestige = canPrestige,
					PrestigeBonuses = prestigeSystem:getPrestigeBonuses(player),
					DailyQuests = dailyQuests,
					WeeklyQuests = weeklyQuests,
					HasClaimableRewards = questSystem:hasClaimableRewards(player),
					LeaderboardRank = leaderboardRank or "Unranked",
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

	local okBoss, errBoss = pcall(setupBossDamageRemote)
	if not okBoss then print("[Error] Boss remote setup failed: " .. tostring(errBoss)) end

	local okPrestige, errPrestige = pcall(setupPrestigeRemote)
	if not okPrestige then print("[Error] Prestige remote setup failed: " .. tostring(errPrestige)) end

	local okQuest, errQuest = pcall(setupQuestRemote)
	if not okQuest then print("[Error] Quest remote setup failed: " .. tostring(errQuest)) end

	local okLeaderboard, errLeaderboard = pcall(setupLeaderboardRemote)
	if not okLeaderboard then print("[Error] Leaderboard remote setup failed: " .. tostring(errLeaderboard)) end

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

