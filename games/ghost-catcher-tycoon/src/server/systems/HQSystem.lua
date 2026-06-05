--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local HQSystem = {}
HQSystem.__index = HQSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function HQSystem:new()
	local self = setmetatable({}, HQSystem)
	self.playerRooms = {} -- UserId -> { roomName: { level, upgraded, timestamp } }
	self.currencySystem = nil
	return self
end

function HQSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function HQSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.playerRooms then
		self.playerRooms = {}
	end
	self.playerRooms[userId] = {}

	-- Initialize all rooms at level 1
	if Config and Config.Rooms then
		for roomName, roomConfig in pairs(Config.Rooms) do
			self.playerRooms[userId][roomName] = {
				level = 1,
				upgraded = false,
				timestamp = os.time(),
			}
		end
	end
end

function HQSystem:getRoomLevel(player, roomName)
	local userId = player.UserId
	if self.playerRooms[userId] and self.playerRooms[userId][roomName] then
		return self.playerRooms[userId][roomName].level
	end
	return 1
end

function HQSystem:upgradeRoom(player, roomName)
	local userId = player.UserId

	if not self.playerRooms[userId] then
		self:initializePlayer(player)
	end

	if not self.playerRooms[userId][roomName] then
		return false, "Room not found"
	end

	local currentLevel = self.playerRooms[userId][roomName].level
	local roomConfig = Config.Rooms[roomName]

	if not roomConfig then
		return false, "Invalid room"
	end

	-- Check if at max level
	if currentLevel >= roomConfig.MaxLevel then
		return false, "Already max level"
	end

	-- Calculate upgrade cost
	local upgradeCost = self:calculateUpgradeCost(roomName, currentLevel)

	-- Check if player has enough energy
	if not self.currencySystem then
		return false, "Currency system not initialized"
	end

	local playerEnergy = self.currencySystem:getEnergy(player)
	if playerEnergy < upgradeCost then
		return false, "Not enough energy"
	end

	-- Perform upgrade
	self.currencySystem:subtractEnergy(player, upgradeCost)
	self.playerRooms[userId][roomName].level = currentLevel + 1
	self.playerRooms[userId][roomName].upgraded = true
	self.playerRooms[userId][roomName].timestamp = os.time()

	return true, self.playerRooms[userId][roomName]
end

function HQSystem:calculateUpgradeCost(roomName, currentLevel)
	local roomConfig = Config.Rooms[roomName]
	if not roomConfig then return 0 end

	-- Cost increases by 50% per level
	local baseCost = roomConfig.BaseCost
	return math.ceil(baseCost * (1.5 ^ (currentLevel - 1)))
end

function HQSystem:getRoomMultiplier(roomName)
	local roomConfig = Config.Rooms[roomName]
	if not roomConfig then return 1.0 end

	return roomConfig.Multiplier or 1.0
end

function HQSystem:getEnergyMultiplier(player)
	local userId = player.UserId

	if not self.playerRooms[userId] then
		self:initializePlayer(player)
	end

	local energyRoom = Config.Rooms.EnergyVault
	if not energyRoom then return 1.0 end

	local level = self:getRoomLevel(player, "EnergyVault")
	local baseMultiplier = energyRoom.Multiplier or 1.0

	-- Each level adds +0.1 multiplier
	return baseMultiplier + ((level - 1) * 0.1)
end

function HQSystem:getStorageBonus(player)
	local userId = player.UserId

	if not self.playerRooms[userId] then
		self:initializePlayer(player)
	end

	local storageRoom = Config.Rooms.GhostVault
	if not storageRoom then return 0 end

	local level = self:getRoomLevel(player, "GhostVault")

	-- Each level adds storage
	return (level - 1) * Config.GhostStoragePerUpgrade
end

function HQSystem:getPlayerRooms(player)
	local userId = player.UserId
	return self.playerRooms[userId] or {}
end

function HQSystem:removePlayer(userId)
	self.playerRooms[userId] = nil
end

return HQSystem
-- Built with assistance from Claude Code by Anthropic.

