--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Data Persistence System
-- Handles loading, saving, and validating player data with retry logic and fallback mechanisms
--
local DataPersistence = {}
DataPersistence.__index = DataPersistence

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

-- Configuration
local SAVE_INTERVAL = 300 -- 5 minutes in seconds
local RETRY_ATTEMPTS = 3
local RETRY_DELAY = 1 -- seconds
local DATA_VERSION = 1
local USE_JSON_FILES = game:GetService("RunService"):IsStudio() -- Use JSON in Studio for testing

-- Initialize DataStore service with fallback for Studio
local DataStoreService = Constants.Services.DataStoreService
local playerDataStore

local success, err = pcall(function()
	playerDataStore = DataStoreService:GetDataStore(Constants.DataStores.PlayerData)
end)

if not success then
	warn("DataStore unavailable (expected in Studio): " .. tostring(err))
	playerDataStore = nil
end

-- JSON file system for testing (Studio mode)
local JSONFileSystem = {}
local JSON_FOLDER = "player_data_json"

function JSONFileSystem:ensureFolder()
	local success, err = pcall(function()
		local ServerStorage = game:GetService("ServerStorage")
		if not ServerStorage:FindFirstChild(JSON_FOLDER) then
			local folder = Instance.new("Folder")
			folder.Name = JSON_FOLDER
			folder.Parent = ServerStorage
		end
	end)
	return success
end

function JSONFileSystem:encode(data)
	return game:GetService("HttpService"):JSONEncode(data)
end

function JSONFileSystem:decode(json)
	return game:GetService("HttpService"):JSONDecode(json)
end

function JSONFileSystem:save(userId, data)
	if not self:ensureFolder() then
		return false
	end

	local success, err = pcall(function()
		local ServerStorage = game:GetService("ServerStorage")
		local folder = ServerStorage:FindFirstChild(JSON_FOLDER)

		local moduleScript = folder:FindFirstChild("userId_" .. userId)
		if not moduleScript then
			moduleScript = Instance.new("ModuleScript")
			moduleScript.Name = "userId_" .. userId
			moduleScript.Parent = folder
		end

		local json = self:encode(data)
		moduleScript.Source = "return " .. json
	end)

	if not success then
		warn("Failed to save JSON data for player " .. userId .. ": " .. tostring(err))
		return false
	end

	return true
end

function JSONFileSystem:load(userId)
	if not self:ensureFolder() then
		return nil
	end

	local success, data = pcall(function()
		local ServerStorage = game:GetService("ServerStorage")
		local folder = ServerStorage:FindFirstChild(JSON_FOLDER)

		if not folder then
			return nil
		end

		local moduleScript = folder:FindFirstChild("userId_" .. userId)
		if not moduleScript then
			return nil
		end

		local chunk = loadstring(moduleScript.Source)
		if not chunk then
			return nil
		end

		return chunk()
	end)

	if not success then
		warn("Failed to load JSON data for player " .. userId .. ": " .. tostring(data))
		return nil
	end

	return data
end

-- Cache for loaded player data
local playerDataCache = {}
local saveQueues = {}
local autoSaveThreads = {}

local function getDefaultPlayerData(userId)
	return {
		userId = userId,
		createdAt = os.time(),
		lastSaved = os.time(),
		version = DATA_VERSION,
		progression = {
			level = 1,
			xp = 0,
			skillPoints = 0,
		},
		equipment = {
			equipped = {},
			owned = {},
		},
		resources = {
			coins = 0,
			energy = Config.InitialEnergy,
			maxEnergy = Config.InitialEnergy,
		},
		zones = {
			unlockedZones = { Forest = true },
		},
		quests = {
			activeDaily = {},
			completedToday = {},
			streak = 0,
		},
		ghosts = {
			inventory = {},
			totalCaught = 0,
		},
	}
end

local function validateDataStructure(data)
	if not data or typeof(data) ~= "table" then
		return false, "Data is not a table"
	end

	local required = {
		"userId", "createdAt", "lastSaved", "version",
		"progression", "equipment", "resources", "zones", "quests", "ghosts"
	}

	for _, field in ipairs(required) do
		if data[field] == nil then
			return false, "Missing required field: " .. field
		end
	end

	-- Validate nested structures
	if typeof(data.progression) ~= "table" then
		return false, "progression is not a table"
	end
	if typeof(data.equipment) ~= "table" then
		return false, "equipment is not a table"
	end
	if typeof(data.resources) ~= "table" then
		return false, "resources is not a table"
	end
	if typeof(data.zones) ~= "table" then
		return false, "zones is not a table"
	end
	if typeof(data.quests) ~= "table" then
		return false, "quests is not a table"
	end
	if typeof(data.ghosts) ~= "table" then
		return false, "ghosts is not a table"
	end

	-- Validate progression fields
	if typeof(data.progression.level) ~= "number" or data.progression.level < 1 then
		return false, "Invalid progression.level"
	end
	if typeof(data.progression.xp) ~= "number" or data.progression.xp < 0 then
		return false, "Invalid progression.xp"
	end
	if typeof(data.progression.skillPoints) ~= "number" or data.progression.skillPoints < 0 then
		return false, "Invalid progression.skillPoints"
	end

	-- Validate resources fields
	if typeof(data.resources.coins) ~= "number" or data.resources.coins < 0 then
		return false, "Invalid resources.coins"
	end
	if typeof(data.resources.energy) ~= "number" or data.resources.energy < 0 then
		return false, "Invalid resources.energy"
	end
	if typeof(data.resources.maxEnergy) ~= "number" or data.resources.maxEnergy < data.resources.energy then
		return false, "Invalid resources.maxEnergy"
	end

	-- Validate ghosts
	if typeof(data.ghosts.totalCaught) ~= "number" or data.ghosts.totalCaught < 0 then
		return false, "Invalid ghosts.totalCaught"
	end

	return true
end

local function sanitizeData(data)
	if not data then
		return nil
	end

	-- Clamp numeric values
	if data.progression then
		data.progression.level = math.max(1, math.floor(data.progression.level or 1))
		data.progression.xp = math.max(0, math.floor(data.progression.xp or 0))
		data.progression.skillPoints = math.max(0, math.floor(data.progression.skillPoints or 0))
	end

	if data.resources then
		data.resources.coins = math.max(0, math.floor(data.resources.coins or 0))
		data.resources.energy = math.max(0, math.floor(data.resources.energy or 0))
		data.resources.maxEnergy = math.max(data.resources.energy, math.floor(data.resources.maxEnergy or 0))
	end

	if data.ghosts then
		data.ghosts.totalCaught = math.max(0, math.floor(data.ghosts.totalCaught or 0))
		if not data.ghosts.inventory then
			data.ghosts.inventory = {}
		end
	end

	return data
end

function DataPersistence:new()
	local self = setmetatable({}, DataPersistence)
	self.playerDataCache = {}
	self.saveQueues = {}
	self.autoSaveThreads = {}
	return self
end

function DataPersistence:loadPlayerData(player)
	local userId = player.UserId

	-- Return cached data if available
	if self.playerDataCache[userId] then
		return self.playerDataCache[userId]
	end

	local data = nil

	-- Try DataStore first if available
	if playerDataStore and not USE_JSON_FILES then
		for attempt = 1, RETRY_ATTEMPTS do
			local success, result = pcall(function()
				return playerDataStore:GetAsync(userId)
			end)

			if success then
				data = result
				break
			end

			if attempt < RETRY_ATTEMPTS then
				task.wait(RETRY_DELAY)
			end
		end
	elseif USE_JSON_FILES then
		-- Try JSON file system for testing
		data = JSONFileSystem:load(userId)
	end

	-- Validate loaded data
	if data then
		local valid, err = validateDataStructure(data)
		if not valid then
			warn("Corrupted data for player " .. player.Name .. " (" .. userId .. "): " .. err)
			data = nil
		else
			data = sanitizeData(data)
		end
	end

	-- Use default data if loading failed
	if not data then
		data = getDefaultPlayerData(userId)
	end

	-- Cache the data
	self.playerDataCache[userId] = data
	return data
end

function DataPersistence:savePlayerData(player, immediate)
	local userId = player.UserId
	local data = self.playerDataCache[userId]

	if not data then
		return false
	end

	-- Validate before saving
	local valid, err = validateDataStructure(data)
	if not valid then
		warn("Cannot save invalid data for player " .. player.Name .. ": " .. err)
		return false
	end

	-- Update metadata
	data.lastSaved = os.time()

	local success = false
	local errorMsg = nil

	-- Try DataStore if available
	if playerDataStore and not USE_JSON_FILES then
		for attempt = 1, RETRY_ATTEMPTS do
			success, errorMsg = pcall(function()
				playerDataStore:SetAsync(userId, data)
			end)

			if success then
				break
			end

			if attempt < RETRY_ATTEMPTS then
				task.wait(RETRY_DELAY)
			end
		end

		if not success then
			warn("Failed to save data for player " .. player.Name .. " (attempt " .. RETRY_ATTEMPTS .. "): " .. tostring(errorMsg))
			return false
		end
	elseif USE_JSON_FILES then
		-- Try JSON file system for testing
		success = JSONFileSystem:save(userId, data)
		if not success then
			warn("Failed to save JSON data for player " .. player.Name)
			return false
		end
	end

	return true
end

function DataPersistence:initializeNewPlayer(player)
	local userId = player.UserId

	-- Check if player already has data
	if self.playerDataCache[userId] then
		return self.playerDataCache[userId]
	end

	-- Create new player data
	local data = getDefaultPlayerData(userId)
	self.playerDataCache[userId] = data

	-- Save immediately
	self:savePlayerData(player, true)

	return data
end

function DataPersistence:validateData(data)
	return validateDataStructure(data)
end

function DataPersistence:getPlayerData(player)
	return self.playerDataCache[player.UserId]
end

function DataPersistence:updatePlayerData(player, updates)
	local userId = player.UserId
	local data = self.playerDataCache[userId]

	if not data then
		return false
	end

	-- Deep merge updates
	for key, value in pairs(updates) do
		if typeof(value) == "table" and typeof(data[key]) == "table" then
			for subkey, subvalue in pairs(value) do
				data[key][subkey] = subvalue
			end
		else
			data[key] = value
		end
	end

	-- Queue for saving
	self:queueSave(player)

	return true
end

function DataPersistence:queueSave(player)
	local userId = player.UserId

	if not self.saveQueues[userId] then
		self.saveQueues[userId] = {
			player = player,
			timestamp = os.time(),
		}
	end
end

function DataPersistence:processSaveQueue()
	for userId, info in pairs(self.saveQueues) do
		if info.player and info.player.Parent then
			self:savePlayerData(info.player)
		else
			-- Player left; try to save data anyway
			local data = self.playerDataCache[userId]
			if data then
				data.lastSaved = os.time()

				if playerDataStore and not USE_JSON_FILES then
					pcall(function()
						playerDataStore:SetAsync(userId, data)
					end)
				elseif USE_JSON_FILES then
					JSONFileSystem:save(userId, data)
				end
			end
		end
	end

	self.saveQueues = {}
end

function DataPersistence:startAutoSave(player)
	local userId = player.UserId

	-- Stop previous auto-save thread if exists
	if self.autoSaveThreads[userId] then
		task.cancel(self.autoSaveThreads[userId])
	end

	-- Start new auto-save thread
	self.autoSaveThreads[userId] = task.spawn(function()
		while player and player.Parent do
			task.wait(SAVE_INTERVAL)

			if player and player.Parent and self.playerDataCache[userId] then
				self:savePlayerData(player)
			end
		end
	end)
end

function DataPersistence:stopAutoSave(player)
	local userId = player.UserId

	if self.autoSaveThreads[userId] then
		task.cancel(self.autoSaveThreads[userId])
		self.autoSaveThreads[userId] = nil
	end
end

function DataPersistence:clearCache(player)
	local userId = player.UserId
	self.playerDataCache[userId] = nil
	self.saveQueues[userId] = nil
end

function DataPersistence:getPlayerDataSize(player)
	local data = self.playerDataCache[player.UserId]
	if not data then
		return 0
	end

	local json = game:GetService("HttpService"):JSONEncode(data)
	return #json
end

function DataPersistence:getAllPlayerDataSizes()
	local sizes = {}
	for userId, data in pairs(self.playerDataCache) do
		local json = game:GetService("HttpService"):JSONEncode(data)
		sizes[userId] = #json
	end
	return sizes
end

return DataPersistence
-- Built with assistance from Claude Code by Anthropic.
