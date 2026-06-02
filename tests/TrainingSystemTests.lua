--[=[
  Ghost Catcher Tycoon - Training System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require(script.Parent:WaitForChild("testRunner"))

local Config = {
	Training = {
		BaseTrainingTime = 300,
		TrainingTimeMultiplier = 2,
		BaseTrainingCost = 50,
		TrainingCostMultiplier = 2,
		MaxGhostLevel = 10,
	},
}

local TrainingSystem = {}
TrainingSystem.__index = TrainingSystem

function TrainingSystem:new()
	local self = setmetatable({}, TrainingSystem)
	self.trainingQueue = {}
	self.currencySystem = nil
	self.ghostSystem = nil
	return self
end

function TrainingSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function TrainingSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function TrainingSystem:initializePlayer(player)
	self.trainingQueue[player.id] = {}
end

function TrainingSystem:calculateTrainingCost(ghost, level)
	local baseCost = Config.Training.BaseTrainingCost
	local multiplier = Config.Training.TrainingCostMultiplier

	local personalityMod = 1.0
	if ghost.personality == "Lazy" then
		personalityMod = 0.7
	elseif ghost.personality == "Hyper" then
		personalityMod = 1.3
	end

	return math.ceil(baseCost * (multiplier ^ (level - 1)) * personalityMod)
end

-- Run tests
TestRunner:register("TrainingSystem: Initialize player", function()
	local system = TrainingSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertEquals(#system.trainingQueue[player.id], 0, "Training queue should be empty")
end)

TestRunner:register("TrainingSystem: Calculate training cost level 1", function()
	local system = TrainingSystem:new()
	local ghost = { personality = "Angry", level = 1 }

	local cost = system:calculateTrainingCost(ghost, 1)
	TestRunner:assertEquals(cost, 50, "Level 1 cost should be 50")
end)

TestRunner:register("TrainingSystem: Calculate cost with personality bonus", function()
	local system = TrainingSystem:new()

	local lazyGhost = { personality = "Lazy", level = 1 }
	local lazyCost = system:calculateTrainingCost(lazyGhost, 1)
	TestRunner:assertEquals(lazyCost, 35, "Lazy personality should reduce cost to 35")

	local hyperGhost = { personality = "Hyper", level = 1 }
	local hyperCost = system:calculateTrainingCost(hyperGhost, 1)
	TestRunner:assertEquals(hyperCost, 65, "Hyper personality should increase cost to 65")
end)

TestRunner:register("TrainingSystem: Calculate exponential cost scaling", function()
	local system = TrainingSystem:new()
	local ghost = { personality = "Angry", level = 1 }

	local cost1 = system:calculateTrainingCost(ghost, 1)
	local cost2 = system:calculateTrainingCost(ghost, 2)
	local cost3 = system:calculateTrainingCost(ghost, 3)

	TestRunner:assertEquals(cost1, 50, "Level 1: 50")
	TestRunner:assertEquals(cost2, 100, "Level 2: 100 (50 * 2)")
	TestRunner:assertEquals(cost3, 200, "Level 3: 200 (50 * 4)")
end)

TestRunner:run()
