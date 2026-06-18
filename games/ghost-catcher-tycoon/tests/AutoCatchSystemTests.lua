--[=[
  Ghost Catcher Tycoon - Auto-Catch System Tests
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	AutoCatch = {
		BaseRate = 1,
	},
	Zones = {
		Forest = { DisplayName = "Forest" },
		Graveyard = { DisplayName = "Graveyard" },
	},
}

local AutoCatchSystem = {}
AutoCatchSystem.__index = AutoCatchSystem

function AutoCatchSystem:new()
	local self = setmetatable({}, AutoCatchSystem)
	self.autoCatchActive = {}
	self.monetizationSystem = nil
	self.ghostSystem = nil
	return self
end

function AutoCatchSystem:setMonetizationSystem(monetizationSystem)
	self.monetizationSystem = monetizationSystem
end

function AutoCatchSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function AutoCatchSystem:initializePlayer(player)
	self.autoCatchActive[player.id] = {
		active = false,
		lastCatchTime = 0,
		catchRate = 1,
		zone = "Forest",
	}
end

function AutoCatchSystem:isAutoCatchEnabled(player)
	if not self.monetizationSystem then return false end
	return self.monetizationSystem:hasGamePass(player, "AutoCatch")
end

function AutoCatchSystem:getAutoCatchRate(player)
	local baseRate = Config.AutoCatch.BaseRate
	local boostMultiplier = 1.0
	if self.monetizationSystem then
		boostMultiplier = self.monetizationSystem:getGamePassBonus(player, "Faster Vacuum")
	end
	return baseRate * boostMultiplier
end

function AutoCatchSystem:setAutoCatchZone(player, zone)
	if not self.autoCatchActive[player.id] then
		self:initializePlayer(player)
	end
	if not Config.Zones[zone] then
		return false, "Invalid zone"
	end
	self.autoCatchActive[player.id].zone = zone
	return true, zone
end

function AutoCatchSystem:getAutoCatchZone(player)
	if not self.autoCatchActive[player.id] then
		self:initializePlayer(player)
	end
	return self.autoCatchActive[player.id].zone or "Forest"
end

-- Mock Monetization System
local MockMonetizationSystem = {}
MockMonetizationSystem.__index = MockMonetizationSystem

function MockMonetizationSystem:new()
	local self = setmetatable({}, MockMonetizationSystem)
	self.passes = {}
	return self
end

function MockMonetizationSystem:hasGamePass(player, passName)
	return self.passes[player.id] and self.passes[player.id][passName] or false
end

function MockMonetizationSystem:grantPass(player, passName)
	if not self.passes[player.id] then
		self.passes[player.id] = {}
	end
	self.passes[player.id][passName] = true
end

function MockMonetizationSystem:getGamePassBonus(player, passName)
	if not self:hasGamePass(player, passName) then
		return 1.0
	end
	if passName == "Faster Vacuum" then
		return 2.0
	end
	return 1.0
end

-- Run tests
TestRunner:register("AutoCatchSystem: Initialize player", function()
	local system = AutoCatchSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:isAutoCatchEnabled(player), "Should not be enabled initially")
	TestRunner:assertEquals(system:getAutoCatchZone(player), "Forest", "Default zone should be Forest")
end)

TestRunner:register("AutoCatchSystem: AutoCatch disabled without GamePass", function()
	local system = AutoCatchSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:isAutoCatchEnabled(player), "Should be disabled without pass")
end)

TestRunner:register("AutoCatchSystem: AutoCatch enabled with GamePass", function()
	local system = AutoCatchSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	monetization:grantPass(player, "AutoCatch")
	TestRunner:assertTrue(system:isAutoCatchEnabled(player), "Should be enabled with pass")
end)

TestRunner:register("AutoCatchSystem: Catch rate calculation", function()
	local system = AutoCatchSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	local baseRate = system:getAutoCatchRate(player)
	TestRunner:assertEquals(baseRate, 1, "Base rate should be 1")

	monetization:grantPass(player, "Faster Vacuum")
	local boostedRate = system:getAutoCatchRate(player)
	TestRunner:assertEquals(boostedRate, 2, "Boosted rate should be 2")
end)

TestRunner:register("AutoCatchSystem: Set and get zone", function()
	local system = AutoCatchSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local success, zone = system:setAutoCatchZone(player, "Graveyard")
	TestRunner:assertTrue(success, "Should set zone successfully")
	TestRunner:assertEquals(system:getAutoCatchZone(player), "Graveyard", "Zone should be Graveyard")
end)

TestRunner:register("AutoCatchSystem: Reject invalid zone", function()
	local system = AutoCatchSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local success, msg = system:setAutoCatchZone(player, "InvalidZone")
	TestRunner:assertFalse(success, "Should reject invalid zone")
end)

TestRunner:run()
