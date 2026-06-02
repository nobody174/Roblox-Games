--[=[
  Ghost Catcher Tycoon - Ghost System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

-- Mock Config
local Config = {
	DefaultGhostStorage = 5,
	Rarities = {
		Common = { BaseEnergyOutput = 1, CatchChance = 0.80, Weight = 0.50 },
		Uncommon = { BaseEnergyOutput = 2, CatchChance = 0.60, Weight = 0.30 },
	},
	Zones = {
		Forest = {
			RarityWeights = { Common = 0.70, Uncommon = 0.30 },
			DifficultyModifier = 0.8,
		},
	},
}

local GhostSystem = {}
GhostSystem.__index = GhostSystem

function GhostSystem:new()
	local self = setmetatable({}, GhostSystem)
	self.playerGhosts = {}
	self.playerStorage = {}
	return self
end

function GhostSystem:initializePlayer(player)
	self.playerGhosts[player.id] = {}
	self.playerStorage[player.id] = 0
end

function GhostSystem:canAddGhost(userId)
	return (self.playerStorage[userId] or 0) < Config.DefaultGhostStorage
end

function GhostSystem:addGhost(player, ghost)
	if not self:canAddGhost(player.id) then
		return false
	end
	self.playerGhosts[player.id][ghost.id] = ghost
	self.playerStorage[player.id] = (self.playerStorage[player.id] or 0) + 1
	return true
end

function GhostSystem:getPlayerGhostCount(player)
	return self.playerStorage[player.id] or 0
end

-- Run tests
TestRunner:register("GhostSystem: Initialize player", function()
	local system = GhostSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertEquals(system:getPlayerGhostCount(player), 0, "Initial ghost count should be 0")
end)

TestRunner:register("GhostSystem: Add ghost up to limit", function()
	local system = GhostSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	-- Add ghosts up to limit
	for i = 1, Config.DefaultGhostStorage do
		local ghost = { id = "ghost" .. i, rarity = "Common" }
		local result = system:addGhost(player, ghost)
		TestRunner:assertTrue(result, "Should successfully add ghost " .. i)
	end

	TestRunner:assertEquals(system:getPlayerGhostCount(player), Config.DefaultGhostStorage, "Should have max ghosts")
end)

TestRunner:register("GhostSystem: Reject ghost when full", function()
	local system = GhostSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	-- Fill storage
	for i = 1, Config.DefaultGhostStorage do
		local ghost = { id = "ghost" .. i, rarity = "Common" }
		system:addGhost(player, ghost)
	end

	-- Try to add one more
	local ghost = { id = "overflow", rarity = "Common" }
	local result = system:addGhost(player, ghost)
	TestRunner:assertFalse(result, "Should reject ghost when storage full")
end)

TestRunner:register("GhostSystem: Storage check", function()
	local system = GhostSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertTrue(system:canAddGhost(player.id), "Should be able to add ghost to empty storage")

	-- Fill storage
	for i = 1, Config.DefaultGhostStorage do
		local ghost = { id = "ghost" .. i, rarity = "Common" }
		system:addGhost(player, ghost)
	end

	TestRunner:assertFalse(system:canAddGhost(player.id), "Should not be able to add when full")
end)

-- Run all tests
TestRunner:run()
