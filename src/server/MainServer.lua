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

-- Initialize systems
local dataManager = DataManager:new()
local currencySystem = CurrencySystem:new()
local vacuumSystem = VacuumSystem:new()
local ghostSystem = GhostSystem:new()
local productionSystem = ProductionSystem:new()
local hqSystem = HQSystem:new()

-- Link systems together
currencySystem:setDataManager(dataManager)
productionSystem:setCurrencySystem(currencySystem)
productionSystem:setGhostSystem(ghostSystem)
productionSystem:setHQSystem(hqSystem)
hqSystem:setCurrencySystem(currencySystem)

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

-- Setup production loop
local function setupProductionLoop()
	while true do
		task.wait(Config.Production.UpdateFrequency)

		-- Process production for all online players
		for _, player in pairs(Players:GetPlayers()) do
			productionSystem:tick(player)

			-- Send updated UI data
			local updateRemote = Constants.Paths.ReplicatedStorage:FindChild("Remotes"):FindChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				local uiData = {
					Energy = currencySystem:getEnergy(player),
					VacuumCharge = vacuumSystem:getCharge(player),
					GhostCount = ghostSystem:getPlayerGhostCount(player),
					ProductionRate = productionSystem:calculateEnergyPerSecond(player),
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

	-- Start production loop
	task.spawn(setupProductionLoop)

	-- Start auto-save loop
	task.spawn(setupAutoSave)

	print("[Ghost Catcher Tycoon] Server initialization complete!")
end

-- Run initialization
initialize()
