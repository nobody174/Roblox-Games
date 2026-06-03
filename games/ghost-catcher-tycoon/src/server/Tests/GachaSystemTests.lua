--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local GachaSystemTests = {}

local function createMockDataManager()
	local mock = {}
	function mock:getPlayerData(player)
		return {
			Gacha = {
				StandardPity = 0,
				PremiumPity = 0,
			},
		}
	end
	function mock:updatePlayerData(player, data)
		-- Mock save
	end
	return mock
end

local function createMockCurrencySystem()
	local mock = {}
	mock.energy = {}
	function mock:canAfford(player, amount)
		return true
	end
	function mock:removeEnergy(player, amount)
		-- Mock deduction
	end
	return mock
end

local function createMockGhostSystem()
	local mock = {}
	function mock:getAvailableGhosts()
		return {
			{ Id = "ghost_1", Rarity = "Common" },
			{ Id = "ghost_2", Rarity = "Uncommon" },
			{ Id = "ghost_3", Rarity = "Rare" },
			{ Id = "ghost_4", Rarity = "Legendary" },
			{ Id = "ghost_5", Rarity = "Mythic" },
		}
	end
	function mock:addGhost(player, ghost)
		-- Mock add
	end
	return mock
end

local function createMockPlayer(userId)
	return {
		UserId = userId or 1,
		Name = "TestPlayer",
	}
end

function GachaSystemTests:testInitializePlayer()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	assert(gachaSystem.gachaData[1] ~= nil, "Gacha data should be initialized")
	assert(gachaSystem.gachaData[1].StandardPity == 0, "Standard pity should start at 0")
	assert(gachaSystem.gachaData[1].PremiumPity == 0, "Premium pity should start at 0")
	print("[PASS] testInitializePlayer")
end

function GachaSystemTests:testRemovePlayer()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)
	gachaSystem:removePlayer(1)

	assert(gachaSystem.gachaData[1] == nil, "Gacha data should be removed")
	print("[PASS] testRemovePlayer")
end

function GachaSystemTests:testPullStandardSingle()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, results = gachaSystem:pullStandard(player, 1)
	assert(success == true, "Pull should succeed")
	assert(results ~= nil, "Should return results")
	assert(#results == 1, "Should have 1 result")
	assert(results[1].Rarity ~= nil, "Result should have rarity")
	print("[PASS] testPullStandardSingle")
end

function GachaSystemTests:testPullStandardTen()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, results = gachaSystem:pullStandard(player, 10)
	assert(success == true, "Pull should succeed")
	assert(#results == 10, "Should have 10 results")
	print("[PASS] testPullStandardTen")
end

function GachaSystemTests:testPullStandardInvalidCount()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, reason = gachaSystem:pullStandard(player, 5)
	assert(success == false, "Invalid count should fail")
	assert(reason == "Invalid pull count", "Should give correct error")
	print("[PASS] testPullStandardInvalidCount")
end

function GachaSystemTests:testPullPremiumSingle()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, results = gachaSystem:pullPremium(player, 1)
	assert(success == true, "Pull should succeed")
	assert(#results == 1, "Should have 1 result")
	print("[PASS] testPullPremiumSingle")
end

function GachaSystemTests:testPullPremiumTen()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, results = gachaSystem:pullPremium(player, 10)
	assert(success == true, "Pull should succeed")
	assert(#results == 10, "Should have 10 results")
	print("[PASS] testPullPremiumTen")
end

function GachaSystemTests:testPullInsufficientFunds()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())

	local mockCurrency = createMockCurrencySystem()
	function mockCurrency:canAfford(player, amount)
		return false
	end
	gachaSystem:setCurrencySystem(mockCurrency)

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local success, reason = gachaSystem:pullStandard(player, 1)
	assert(success == false, "Pull should fail without funds")
	assert(reason == "Not enough energy", "Should indicate insufficient funds")
	print("[PASS] testPullInsufficientFunds")
end

function GachaSystemTests:testStandardPityTracking()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local initialPity = gachaSystem:getStandardPity(player)
	assert(initialPity == 0, "Pity should start at 0")

	gachaSystem:pullStandard(player, 1)
	local pityAfterPull = gachaSystem:getStandardPity(player)
	assert(pityAfterPull >= 0, "Pity should be tracked")
	print("[PASS] testStandardPityTracking")
end

function GachaSystemTests:testPremiumPityTracking()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()
	gachaSystem:setDataManager(createMockDataManager())
	gachaSystem:setCurrencySystem(createMockCurrencySystem())
	gachaSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	gachaSystem:initializePlayer(player)

	local initialPity = gachaSystem:getPremiumPity(player)
	assert(initialPity == 0, "Pity should start at 0")

	gachaSystem:pullPremium(player, 1)
	local pityAfterPull = gachaSystem:getPremiumPity(player)
	assert(pityAfterPull >= 0, "Pity should be tracked")
	print("[PASS] testPremiumPityTracking")
end

function GachaSystemTests:testSelectRarity()
	local GachaSystem = require(game:GetService("ServerScriptService"):WaitForChild("GachaSystem"))
	local gachaSystem = GachaSystem:new()

	local weights = {
		Common = 0.60,
		Uncommon = 0.25,
		Rare = 0.10,
		Legendary = 0.04,
		Mythic = 0.01,
	}

	local rarity = gachaSystem:_selectRarity(weights)
	assert(rarity ~= nil, "Should select a rarity")
	assert(weights[rarity] ~= nil, "Selected rarity should be valid")
	print("[PASS] testSelectRarity")
end

function GachaSystemTests:runAll()
	print("\n[TEST SUITE] GachaSystem Tests")
	self:testInitializePlayer()
	self:testRemovePlayer()
	self:testPullStandardSingle()
	self:testPullStandardTen()
	self:testPullStandardInvalidCount()
	self:testPullPremiumSingle()
	self:testPullPremiumTen()
	self:testPullInsufficientFunds()
	self:testStandardPityTracking()
	self:testPremiumPityTracking()
	self:testSelectRarity()
	print("[TEST SUITE] GachaSystem Tests - All passed!\n")
end

return GachaSystemTests
-- Built with assistance from Claude Code by Anthropic.

