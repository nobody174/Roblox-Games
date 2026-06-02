--[=[
  Ghost Catcher Tycoon - Auto-Train System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	Training = {
		MaxGhostLevel = 10,
	},
}

local AutoTrainSystem = {}
AutoTrainSystem.__index = AutoTrainSystem

function AutoTrainSystem:new()
	local self = setmetatable({}, AutoTrainSystem)
	self.autoTrainActive = {}
	self.monetizationSystem = nil
	self.ghostSystem = nil
	return self
end

function AutoTrainSystem:setMonetizationSystem(monetizationSystem)
	self.monetizationSystem = monetizationSystem
end

function AutoTrainSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function AutoTrainSystem:initializePlayer(player)
	self.autoTrainActive[player.id] = {
		active = false,
		targetLevel = Config.Training.MaxGhostLevel,
		ghostsList = {},
	}
end

function AutoTrainSystem:isAutoTrainEnabled(player)
	if not self.monetizationSystem then return false end
	return self.monetizationSystem:hasGamePass(player, "AutoTrain")
end

function AutoTrainSystem:getAutoTrainSpeedMultiplier(player)
	local baseSpeed = 1.0
	if self.monetizationSystem then
		local boostCount = self.monetizationSystem:getProductCount(player, "TrainingBoost")
		if boostCount > 0 then
			return baseSpeed * 2.0
		end
	end
	return baseSpeed
end

function AutoTrainSystem:setAutoTrainTarget(player, targetLevel)
	if not self.autoTrainActive[player.id] then
		self:initializePlayer(player)
	end

	if targetLevel < 1 or targetLevel > Config.Training.MaxGhostLevel then
		return false, "Invalid target level"
	end

	self.autoTrainActive[player.id].targetLevel = targetLevel
	return true, targetLevel
end

function AutoTrainSystem:addGhostToAutoTrain(player, ghostId)
	if not self.autoTrainActive[player.id] then
		self:initializePlayer(player)
	end

	for _, id in ipairs(self.autoTrainActive[player.id].ghostsList) do
		if id == ghostId then
			return false, "Ghost already in queue"
		end
	end

	table.insert(self.autoTrainActive[player.id].ghostsList, ghostId)
	return true, ghostId
end

function AutoTrainSystem:removeGhostFromAutoTrain(player, ghostId)
	if not self.autoTrainActive[player.id] then
		return false, "Not initialized"
	end

	for i, id in ipairs(self.autoTrainActive[player.id].ghostsList) do
		if id == ghostId then
			table.remove(self.autoTrainActive[player.id].ghostsList, i)
			return true, i
		end
	end

	return false, "Ghost not in queue"
end

function AutoTrainSystem:getAutoTrainQueue(player)
	if not self.autoTrainActive[player.id] then
		self:initializePlayer(player)
	end

	return {
		enabled = self:isAutoTrainEnabled(player),
		targetLevel = self.autoTrainActive[player.id].targetLevel,
		ghostsList = self.autoTrainActive[player.id].ghostsList,
		count = #self.autoTrainActive[player.id].ghostsList,
	}
end

-- Mock Monetization System
local MockMonetizationSystem = {}
MockMonetizationSystem.__index = MockMonetizationSystem

function MockMonetizationSystem:new()
	local self = setmetatable({}, MockMonetizationSystem)
	self.passes = {}
	self.products = {}
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

function MockMonetizationSystem:getProductCount(player, productName)
	return self.products[player.id] and self.products[player.id][productName] or 0
end

function MockMonetizationSystem:addProduct(player, productName, count)
	if not self.products[player.id] then
		self.products[player.id] = {}
	end
	self.products[player.id][productName] = (self.products[player.id][productName] or 0) + count
end

-- Run tests
TestRunner:register("AutoTrainSystem: Initialize player", function()
	local system = AutoTrainSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:isAutoTrainEnabled(player), "Should not be enabled initially")
	TestRunner:assertEquals(system.autoTrainActive[player.id].targetLevel, 10, "Target level should be 10")
end)

TestRunner:register("AutoTrainSystem: AutoTrain disabled without GamePass", function()
	local system = AutoTrainSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:isAutoTrainEnabled(player), "Should be disabled without pass")
end)

TestRunner:register("AutoTrainSystem: AutoTrain enabled with GamePass", function()
	local system = AutoTrainSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	monetization:grantPass(player, "AutoTrain")
	TestRunner:assertTrue(system:isAutoTrainEnabled(player), "Should be enabled with pass")
end)

TestRunner:register("AutoTrainSystem: Set target level", function()
	local system = AutoTrainSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local success, level = system:setAutoTrainTarget(player, 5)
	TestRunner:assertTrue(success, "Should set target level")
	TestRunner:assertEquals(system.autoTrainActive[player.id].targetLevel, 5, "Target level should be 5")
end)

TestRunner:register("AutoTrainSystem: Add ghost to queue", function()
	local system = AutoTrainSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local success, ghostId = system:addGhostToAutoTrain(player, "ghost1")
	TestRunner:assertTrue(success, "Should add ghost")
	TestRunner:assertEquals(#system.autoTrainActive[player.id].ghostsList, 1, "Queue should have 1 ghost")
end)

TestRunner:register("AutoTrainSystem: Prevent duplicate ghosts in queue", function()
	local system = AutoTrainSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	system:addGhostToAutoTrain(player, "ghost1")
	local success, msg = system:addGhostToAutoTrain(player, "ghost1")

	TestRunner:assertFalse(success, "Should reject duplicate")
	TestRunner:assertEquals(#system.autoTrainActive[player.id].ghostsList, 1, "Queue should still have 1 ghost")
end)

TestRunner:register("AutoTrainSystem: Training speed multiplier", function()
	local system = AutoTrainSystem:new()
	local monetization = MockMonetizationSystem:new()
	system:setMonetizationSystem(monetization)

	local player = { id = 1 }
	system:initializePlayer(player)

	local baseSpeed = system:getAutoTrainSpeedMultiplier(player)
	TestRunner:assertEquals(baseSpeed, 1.0, "Base speed should be 1.0")

	monetization:addProduct(player, "TrainingBoost", 1)
	local boostedSpeed = system:getAutoTrainSpeedMultiplier(player)
	TestRunner:assertEquals(boostedSpeed, 2.0, "Boosted speed should be 2.0")
end)

TestRunner:register("AutoTrainSystem: Get queue status", function()
	local system = AutoTrainSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	system:addGhostToAutoTrain(player, "ghost1")
	system:addGhostToAutoTrain(player, "ghost2")

	local queue = system:getAutoTrainQueue(player)
	TestRunner:assertEquals(queue.count, 2, "Queue should have 2 ghosts")
	TestRunner:assertEquals(queue.targetLevel, 10, "Target level should be 10")
end)

TestRunner:run()
