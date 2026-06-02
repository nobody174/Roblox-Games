--[=[
  Ghost Catcher Tycoon - Main Server
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load shared modules
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local Enums = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("enums"))

-- Load systems
local DataManager = require(script.Parent:WaitForChild("data"):WaitForChild("DataManager"))
local CurrencySystem = require(script.Parent:WaitForChild("systems"):WaitForChild("CurrencySystem"))
local VacuumSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("VacuumSystem"))
local GhostSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSystem"))
local ProductionSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("ProductionSystem"))
local HQSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("HQSystem"))
local TrainingSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("TrainingSystem"))
local ZoneSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("ZoneSystem"))
local MonetizationSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("MonetizationSystem"))

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

-- Link systems together
currencySystem:setDataManager(dataManager)
productionSystem:setCurrencySystem(currencySystem)
productionSystem:setGhostSystem(ghostSystem)
productionSystem:setHQSystem(hqSystem)
hqSystem:setCurrencySystem(currencySystem)
trainingSystem:setCurrencySystem(currencySystem)
trainingSystem:setGhostSystem(ghostSystem)
zoneSystem:setCurrencySystem(currencySystem)
zoneSystem:setGhostSystem(ghostSystem)
monetizationSystem:setCurrencySystem(currencySystem)
monetizationSystem:setGhostSystem(ghostSystem)

print("[Ghost Catcher Tycoon] Server started")

-- Setup RemoteEvents in ReplicatedStorage
local function setupRemotes()
	local rs = Constants.Paths.ReplicatedStorage

	-- Create folders if they don't exist
	if not rs:FindChild("Remotes") then
		local remotesFolder = Instance.new("Folder")
		remotesFolder.Name = "Remotes"
		remotesFolder.Parent = rs
	end

	local remotesFolder = rs:FindChild("Remotes")

	-- Create RemoteEvents
	local function createRemote(name, className)
		if not remotesFolder:FindChild(name) then
			local remote = Instance.new(className)
			remote.Name = name
			remote.Parent = remotesFolder
			return remote
		end
		return remotesFolder:FindChild(name)
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

-- Setup training remote
local function setupTrainingRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local trainRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.TrainGhost)

	trainRemote.OnServerEvent:Connect(function(player, ghostId, targetLevel)
		local success, result = trainingSystem:startTraining(player, ghostId, targetLevel)
		if not success then
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

-- Setup production loop
local function setupProductionLoop()
	while true do
		task.wait(Config.Production.UpdateFrequency)

		-- Process production and training for all online players
		for _, player in pairs(Players:GetPlayers()) do
			productionSystem:tick(player)
			trainingSystem:tick(player)

			-- Send updated UI data
			local updateRemote = Constants.Paths.ReplicatedStorage:FindChild("Remotes"):FindChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				local uiData = {
					Energy = currencySystem:getEnergy(player),
					VacuumCharge = vacuumSystem:getCharge(player),
					GhostCount = ghostSystem:getPlayerGhostCount(player),
					ProductionRate = productionSystem:calculateEnergyPerSecond(player),
					UnlockedZones = zoneSystem:getUnlockedZones(player),
					MonetizationData = monetizationSystem:getPlayerMonetizationData(player),
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
	setupVacuumRemote()
	setupTrainingRemote()
	setupZoneRemote()
	setupMonetizationRemote()

	-- Start production loop
	task.spawn(setupProductionLoop)

	-- Start auto-save loop
	task.spawn(setupAutoSave)

	print("[Ghost Catcher Tycoon] Server initialization complete!")
end

-- Run initialization
initialize()
