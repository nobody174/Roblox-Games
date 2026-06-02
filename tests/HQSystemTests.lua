--[=[
  Ghost Catcher Tycoon - HQ System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require(script.Parent:WaitForChild("testRunner"))

local Config = {
	Rooms = {
		EnergyVault = {
			BaseCost = 100,
			MaxLevel = 10,
			Multiplier = 1.0,
		},
		GhostVault = {
			BaseCost = 200,
			MaxLevel = 10,
		},
	},
	GhostStoragePerUpgrade = 5,
}

local HQSystem = {}
HQSystem.__index = HQSystem

function HQSystem:new()
	local self = setmetatable({}, HQSystem)
	self.playerRooms = {}
	self.currencySystem = nil
	return self
end

function HQSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function HQSystem:initializePlayer(player)
	self.playerRooms[player.id] = {}
	for roomName, roomConfig in pairs(Config.Rooms) do
		self.playerRooms[player.id][roomName] = { level = 1, upgraded = false }
	end
end

function HQSystem:getRoomLevel(player, roomName)
	if self.playerRooms[player.id] and self.playerRooms[player.id][roomName] then
		return self.playerRooms[player.id][roomName].level
	end
	return 1
end

function HQSystem:calculateUpgradeCost(roomName, currentLevel)
	local roomConfig = Config.Rooms[roomName]
	if not roomConfig then return 0 end
	local baseCost = roomConfig.BaseCost
	return math.ceil(baseCost * (1.5 ^ (currentLevel - 1)))
end

function HQSystem:getEnergyMultiplier(player)
	local level = self:getRoomLevel(player, "EnergyVault")
	local baseMultiplier = Config.Rooms.EnergyVault.Multiplier or 1.0
	return baseMultiplier + ((level - 1) * 0.1)
end

function HQSystem:getStorageBonus(player)
	local level = self:getRoomLevel(player, "GhostVault")
	return (level - 1) * Config.GhostStoragePerUpgrade
end

-- Run tests
TestRunner:register("HQSystem: Initialize player rooms", function()
	local system = HQSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertEquals(system:getRoomLevel(player, "EnergyVault"), 1, "Room should start at level 1")
	TestRunner:assertEquals(system:getRoomLevel(player, "GhostVault"), 1, "Room should start at level 1")
end)

TestRunner:register("HQSystem: Calculate upgrade cost", function()
	local system = HQSystem:new()

	local cost1 = system:calculateUpgradeCost("EnergyVault", 1)
	TestRunner:assertEquals(cost1, 100, "Level 1 upgrade cost should be base cost (100)")

	local cost2 = system:calculateUpgradeCost("EnergyVault", 2)
	TestRunner:assertEquals(cost2, 150, "Level 2 upgrade cost should be 100 * 1.5 = 150")

	local cost3 = system:calculateUpgradeCost("EnergyVault", 3)
	TestRunner:assertEquals(cost3, 225, "Level 3 upgrade cost should be 100 * 2.25 = 225")
end)

TestRunner:register("HQSystem: Energy multiplier", function()
	local system = HQSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local mult1 = system:getEnergyMultiplier(player)
	TestRunner:assertEquals(mult1, 1.0, "Level 1 multiplier should be 1.0")

	-- Simulate level up
	system.playerRooms[player.id]["EnergyVault"].level = 5
	local mult5 = system:getEnergyMultiplier(player)
	TestRunner:assertEquals(mult5, 1.4, "Level 5 multiplier should be 1.0 + (4 * 0.1) = 1.4")
end)

TestRunner:register("HQSystem: Storage bonus", function()
	local system = HQSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local bonus1 = system:getStorageBonus(player)
	TestRunner:assertEquals(bonus1, 0, "Level 1 storage bonus should be 0")

	-- Simulate level up
	system.playerRooms[player.id]["GhostVault"].level = 3
	local bonus3 = system:getStorageBonus(player)
	TestRunner:assertEquals(bonus3, 10, "Level 3 storage bonus should be 2 * 5 = 10")
end)

TestRunner:run()
