--[=[
  Ghost Catcher Tycoon - Zone System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	Zones = {
		Forest = {
			DisplayName = "Enchanted Forest",
			UnlockCost = 0,
			EnergyMultiplier = 1.0,
		},
		Graveyard = {
			DisplayName = "Haunted Graveyard",
			UnlockCost = 500,
			EnergyMultiplier = 1.2,
		},
		Mansion = {
			DisplayName = "Haunted Mansion",
			UnlockCost = 5000,
			EnergyMultiplier = 1.5,
		},
	},
}

local ZoneSystem = {}
ZoneSystem.__index = ZoneSystem

function ZoneSystem:new()
	local self = setmetatable({}, ZoneSystem)
	self.unlockedZones = {}
	self.bossActive = {}
	self.currencySystem = nil
	return self
end

function ZoneSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function ZoneSystem:initializePlayer(player)
	self.unlockedZones[player.id] = {}
	self.unlockedZones[player.id]["Forest"] = true

	for zoneName, _ in pairs(Config.Zones) do
		if zoneName ~= "Forest" then
			self.unlockedZones[player.id][zoneName] = false
		end
	end

	self.bossActive[player.id] = {}
end

function ZoneSystem:isZoneUnlocked(player, zoneName)
	if not self.unlockedZones[player.id] then
		self:initializePlayer(player)
	end
	return self.unlockedZones[player.id][zoneName] or false
end

function ZoneSystem:getUnlockedZones(player)
	if not self.unlockedZones[player.id] then
		self:initializePlayer(player)
	end

	local unlocked = {}
	for zoneName, isUnlocked in pairs(self.unlockedZones[player.id]) do
		if isUnlocked then
			table.insert(unlocked, zoneName)
		end
	end
	return unlocked
end

function ZoneSystem:isBossActive(player, zoneName)
	if not self.bossActive[player.id] then
		return false
	end
	return self.bossActive[player.id][zoneName] ~= nil
end

-- Run tests
TestRunner:register("ZoneSystem: Initialize player with Forest unlocked", function()
	local system = ZoneSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertTrue(system:isZoneUnlocked(player, "Forest"), "Forest should be unlocked")
	TestRunner:assertFalse(system:isZoneUnlocked(player, "Graveyard"), "Graveyard should be locked")
end)

TestRunner:register("ZoneSystem: Get unlocked zones", function()
	local system = ZoneSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local unlocked = system:getUnlockedZones(player)
	TestRunner:assertEquals(#unlocked, 1, "Should have 1 unlocked zone")
	TestRunner:assertTrue(unlocked[1] == "Forest", "Should be Forest")
end)

TestRunner:register("ZoneSystem: Boss not active initially", function()
	local system = ZoneSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:isBossActive(player, "Forest"), "No boss should be active")
end)

TestRunner:register("ZoneSystem: Multiple players have separate zones", function()
	local system = ZoneSystem:new()
	local player1 = { id = 1 }
	local player2 = { id = 2 }

	system:initializePlayer(player1)
	system:initializePlayer(player2)

	-- Both should have Forest unlocked
	TestRunner:assertTrue(system:isZoneUnlocked(player1, "Forest"), "Player 1: Forest unlocked")
	TestRunner:assertTrue(system:isZoneUnlocked(player2, "Forest"), "Player 2: Forest unlocked")

	-- Manually unlock for player1
	system.unlockedZones[player1.id]["Graveyard"] = true

	TestRunner:assertTrue(system:isZoneUnlocked(player1, "Graveyard"), "Player 1: Graveyard unlocked")
	TestRunner:assertFalse(system:isZoneUnlocked(player2, "Graveyard"), "Player 2: Graveyard locked")
end)

TestRunner:run()
