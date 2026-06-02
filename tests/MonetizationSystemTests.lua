--[=[
  Ghost Catcher Tycoon - Monetization System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	GamePasses = {
		DoubleEnergy = { Price = 399, Description = "Double energy" },
		ExtraStorage = { Price = 299, Description = "Extra storage" },
		AutoCatch = { Price = 699, Description = "Auto catch" },
	},
	Products = {
		EnergyPack = { Amount = 1000, Price = 100 },
		GhostEgg = { Price = 299 },
		BossTicket = { Price = 199 },
	},
}

local MonetizationSystem = {}
MonetizationSystem.__index = MonetizationSystem

function MonetizationSystem:new()
	local self = setmetatable({}, MonetizationSystem)
	self.playerGamePasses = {}
	self.playerProducts = {}
	return self
end

function MonetizationSystem:initializePlayer(player)
	self.playerGamePasses[player.id] = {}
	self.playerProducts[player.id] = {}

	for passName, _ in pairs(Config.GamePasses) do
		self.playerGamePasses[player.id][passName] = false
	end

	for productName, _ in pairs(Config.Products) do
		self.playerProducts[player.id][productName] = 0
	end
end

function MonetizationSystem:grantGamePass(player, passName)
	if not self.playerGamePasses[player.id] then
		self:initializePlayer(player)
	end

	if not Config.GamePasses[passName] then
		return false, "GamePass not found"
	end

	if self.playerGamePasses[player.id][passName] then
		return false, "Already owns"
	end

	self.playerGamePasses[player.id][passName] = true
	return true, Config.GamePasses[passName]
end

function MonetizationSystem:hasGamePass(player, passName)
	if not self.playerGamePasses[player.id] then
		self:initializePlayer(player)
	end
	return self.playerGamePasses[player.id][passName] or false
end

function MonetizationSystem:getGamePassBonus(player, passName)
	if not self:hasGamePass(player, passName) then
		return 1.0
	end

	if passName == "DoubleEnergy" then
		return 2.0
	end
	return 1.0
end

function MonetizationSystem:getProductCount(player, productName)
	if not self.playerProducts[player.id] then
		self:initializePlayer(player)
	end
	return self.playerProducts[player.id][productName] or 0
end

function MonetizationSystem:addProduct(player, productName, quantity)
	if not self.playerProducts[player.id] then
		self:initializePlayer(player)
	end
	self.playerProducts[player.id][productName] = (self.playerProducts[player.id][productName] or 0) + quantity
end

-- Run tests
TestRunner:register("MonetizationSystem: Initialize player", function()
	local system = MonetizationSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertFalse(system:hasGamePass(player, "DoubleEnergy"), "Should not have pass initially")
	TestRunner:assertEquals(system:getProductCount(player, "BossTicket"), 0, "Should have 0 products")
end)

TestRunner:register("MonetizationSystem: Grant GamePass", function()
	local system = MonetizationSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	local success, result = system:grantGamePass(player, "DoubleEnergy")
	TestRunner:assertTrue(success, "Should grant pass")
	TestRunner:assertTrue(system:hasGamePass(player, "DoubleEnergy"), "Should own pass")
end)

TestRunner:register("MonetizationSystem: Cannot grant duplicate pass", function()
	local system = MonetizationSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	system:grantGamePass(player, "DoubleEnergy")
	local success, result = system:grantGamePass(player, "DoubleEnergy")

	TestRunner:assertFalse(success, "Should not grant duplicate")
end)

TestRunner:register("MonetizationSystem: GamePass bonus", function()
	local system = MonetizationSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	TestRunner:assertEquals(system:getGamePassBonus(player, "DoubleEnergy"), 1.0, "No bonus without pass")

	system:grantGamePass(player, "DoubleEnergy")
	TestRunner:assertEquals(system:getGamePassBonus(player, "DoubleEnergy"), 2.0, "2x bonus with pass")
end)

TestRunner:register("MonetizationSystem: Add and count products", function()
	local system = MonetizationSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	system:addProduct(player, "BossTicket", 3)
	TestRunner:assertEquals(system:getProductCount(player, "BossTicket"), 3, "Should have 3 tickets")

	system:addProduct(player, "BossTicket", 2)
	TestRunner:assertEquals(system:getProductCount(player, "BossTicket"), 5, "Should have 5 total")
end)

TestRunner:register("MonetizationSystem: Multiple players separate", function()
	local system = MonetizationSystem:new()
	local player1 = { id = 1 }
	local player2 = { id = 2 }

	system:initializePlayer(player1)
	system:initializePlayer(player2)

	system:grantGamePass(player1, "DoubleEnergy")

	TestRunner:assertTrue(system:hasGamePass(player1, "DoubleEnergy"), "Player 1 has pass")
	TestRunner:assertFalse(system:hasGamePass(player2, "DoubleEnergy"), "Player 2 doesn't have pass")
end)

TestRunner:run()
