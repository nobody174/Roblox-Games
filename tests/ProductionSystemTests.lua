--[=[
  Ghost Catcher Tycoon - Production System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	Rarities = {
		Common = { BaseEnergyOutput = 1 },
		Uncommon = { BaseEnergyOutput = 2 },
		Rare = { BaseEnergyOutput = 5 },
	},
}

local ProductionSystem = {}
ProductionSystem.__index = ProductionSystem

function ProductionSystem:new()
	local self = setmetatable({}, ProductionSystem)
	self.currencySystem = nil
	self.ghostSystem = nil
	self.lastProductionTick = {}
	self.accumulatedEnergy = {}
	return self
end

function ProductionSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function ProductionSystem:initializePlayer(player)
	self.lastProductionTick[player.id] = os.time()
	self.accumulatedEnergy[player.id] = 0
end

function ProductionSystem:calculateEnergyPerSecond(player)
	if not self.ghostSystem then return 0 end

	local ghosts = self.ghostSystem:getPlayerGhosts(player)
	local totalEnergy = 0

	for ghostId, ghost in pairs(ghosts) do
		if ghost and ghost.stats then
			local baseEnergy = ghost.stats.energyProduction or 1
			totalEnergy = totalEnergy + (baseEnergy * (ghost.level or 1))
		end
	end

	return totalEnergy
end

-- Mock Ghost System
local MockGhostSystem = {}
function MockGhostSystem:new()
	local self = setmetatable({}, MockGhostSystem)
	self.ghosts = {}
	return self
end

function MockGhostSystem:getPlayerGhosts(player)
	return self.ghosts[player.id] or {}
end

function MockGhostSystem:addGhost(player, ghost)
	if not self.ghosts[player.id] then
		self.ghosts[player.id] = {}
	end
	self.ghosts[player.id][ghost.id] = ghost
end

-- Run tests
TestRunner:register("ProductionSystem: Initialize player", function()
	local system = ProductionSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertEquals(system.accumulatedEnergy[player.id], 0, "Initial accumulated energy should be 0")
end)

TestRunner:register("ProductionSystem: Calculate energy with no ghosts", function()
	local system = ProductionSystem:new()
	local ghostSystem = MockGhostSystem:new()
	system:setGhostSystem(ghostSystem)

	local player = { id = 1 }
	system:initializePlayer(player)

	local energy = system:calculateEnergyPerSecond(player)
	TestRunner:assertEquals(energy, 0, "Energy should be 0 with no ghosts")
end)

TestRunner:register("ProductionSystem: Calculate energy with one ghost", function()
	local system = ProductionSystem:new()
	local ghostSystem = MockGhostSystem:new()
	system:setGhostSystem(ghostSystem)

	local player = { id = 1 }
	system:initializePlayer(player)

	-- Add a ghost
	local ghost = {
		id = "ghost1",
		rarity = "Common",
		level = 1,
		stats = { energyProduction = 5 },
	}
	ghostSystem:addGhost(player, ghost)

	local energy = system:calculateEnergyPerSecond(player)
	TestRunner:assertEquals(energy, 5, "Energy should be 5 for one level 1 ghost with 5 energy")
end)

TestRunner:register("ProductionSystem: Calculate energy with multiple ghosts", function()
	local system = ProductionSystem:new()
	local ghostSystem = MockGhostSystem:new()
	system:setGhostSystem(ghostSystem)

	local player = { id = 1 }
	system:initializePlayer(player)

	-- Add multiple ghosts
	local ghosts = {
		{ id = "g1", rarity = "Common", level = 1, stats = { energyProduction = 5 } },
		{ id = "g2", rarity = "Uncommon", level = 2, stats = { energyProduction = 3 } },
	}

	for _, ghost in ipairs(ghosts) do
		ghostSystem:addGhost(player, ghost)
	end

	local energy = system:calculateEnergyPerSecond(player)
	-- 5 * 1 + 3 * 2 = 5 + 6 = 11
	TestRunner:assertEquals(energy, 11, "Energy should sum all ghosts considering level")
end)

TestRunner:run()
