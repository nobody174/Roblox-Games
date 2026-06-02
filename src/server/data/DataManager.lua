--[=[
  Ghost Catcher Tycoon - Data Manager
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local DataManager = {}
DataManager.__index = DataManager

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

local DataStoreService = Constants.Services.DataStoreService
local playerDataStore = DataStoreService:GetDataStore(Constants.DataStores.PlayerData)

-- Cache for loaded player data (UserId -> PlayerData)
local playerDataCache = {}

local function getDefaultPlayerData(userId)
	return {
		UserId = userId,
		CreatedAt = os.time(),
		LastPlayed = os.time(),
		Energy = Config.InitialEnergy,
		Ghosts = {}, -- Array of ghost objects
		GhostCount = 0,
		HQ = {
			GhostChamber = { Level = 1 },
			TrainingFacility = { Level = 1 },
			EnergyReactor = { Level = 1 },
			ResearchLab = { Level = 0 },
			BossArena = { Level = 0 },
		},
		UnlockedZones = {
			Forest = true,
			Graveyard = false,
			Mansion = false,
			DarkDimension = false,
		},
		GamePasses = {
			AutoCatch = false,
			AutoTrain = false,
			DoubleEnergy = false,
			VIPZone = false,
			ExtraStorage = false,
		},
		Settings = {
			VolumeLevel = 1.0,
			EffectsEnabled = true,
		},
		Statistics = {
			TotalGhostsCaught = 0,
			TotalEnergieEarned = 0,
			TotalEnergyEarned = 0,
			GhostsCaught = 0,
			HighestZoneReached = "Forest",
			SessionTime = 0,
		},
		Prestige = {
			Level = 0,
			TotalPrestiges = 0,
		},
		Quests = {
			Daily = {},
			Weekly = {},
			LastDailyReset = 0,
			LastWeeklyReset = 0,
		},
		Gacha = {
			PityCount = 0,
			LegendaryPityCount = 0,
			TotalPulls = 0,
		},
		Cosmetics = {
			UnlockedSkins = { Default = true },
			GhostSkins = {},
		},
	}
end

function DataManager:new()
	local self = setmetatable({}, DataManager)
	self.saveQueue = {}
	self.isSaving = false
	return self
end

function DataManager:loadPlayerData(player)
	local userId = player.UserId

	-- Return cached data if available
	if playerDataCache[userId] then
		return playerDataCache[userId]
	end

	local success = false
	local data = nil
	local errorMsg = nil

	-- Retry logic for loading
	for attempt = 1, Config.DataStoreRetries do
		success, data = pcall(function()
			return playerDataStore:GetAsync(userId)
		end)

		if success then
			break
		end

		errorMsg = data
		task.wait(Config.DataStoreRetryDelay)
	end

	if not success then
		warn("Failed to load data for player " .. player.Name .. ": " .. tostring(errorMsg))
		-- Return default data if load fails
		data = getDefaultPlayerData(userId)
	elseif data == nil then
		-- First time player
		data = getDefaultPlayerData(userId)
	end

	-- Cache the data
	playerDataCache[userId] = data
	return data
end

function DataManager:savePlayerData(player)
	local userId = player.UserId
	local data = playerDataCache[userId]

	if not data then
		return false
	end

	-- Update metadata
	data.LastPlayed = os.time()

	local success = false
	local errorMsg = nil

	-- Retry logic for saving
	for attempt = 1, Config.DataStoreRetries do
		success, errorMsg = pcall(function()
			playerDataStore:SetAsync(userId, data)
		end)

		if success then
			break
		end

		task.wait(Config.DataStoreRetryDelay)
	end

	if not success then
		warn("Failed to save data for player " .. player.Name .. ": " .. tostring(errorMsg))
		return false
	end

	return true
end

function DataManager:getPlayerData(player)
	local userId = player.UserId
	return playerDataCache[userId]
end

function DataManager:updatePlayerData(player, updates)
	local userId = player.UserId
	local data = playerDataCache[userId]

	if not data then
		return false
	end

	-- Merge updates into data
	for key, value in pairs(updates) do
		if typeof(value) == "table" and typeof(data[key]) == "table" then
			-- Deep merge for nested tables
			for subkey, subvalue in pairs(value) do
				data[key][subkey] = subvalue
			end
		else
			data[key] = value
		end
	end

	-- Queue for saving (batched)
	self.saveQueue[userId] = data
	return true
end

function DataManager:addEnergy(player, amount)
	local userId = player.UserId
	local data = playerDataCache[userId]

	if not data then
		return false
	end

	-- Cap energy to prevent overflow
	local newEnergy = math.min(data.Energy + amount, Constants.Limits.MaxEnergyStorage)
	data.Energy = newEnergy

	-- Queue for saving
	self.saveQueue[userId] = data
	return true
end

function DataManager:removeEnergy(player, amount)
	local userId = player.UserId
	local data = playerDataCache[userId]

	if not data then
		return false
	end

	if data.Energy < amount then
		return false
	end

	data.Energy = data.Energy - amount

	-- Queue for saving
	self.saveQueue[userId] = data
	return true
end

function DataManager:getEnergy(player)
	local data = self:getPlayerData(player)
	return data and data.Energy or 0
end

function DataManager:processSaveQueue()
	for userId, data in pairs(self.saveQueue) do
		-- Find player by UserId
		local player = Constants.Services.Players:FindFirstChild(tostring(userId))

		if player then
			self:savePlayerData(player)
		else
			-- Player left, still save their data
			local success, err = pcall(function()
				playerDataStore:SetAsync(userId, data)
			end)

			if not success then
				warn("Failed to save offline player data: " .. tostring(err))
			end
		end
	end

	self.saveQueue = {}
end

function DataManager:clearCache(userId)
	playerDataCache[userId] = nil
end

return DataManager
