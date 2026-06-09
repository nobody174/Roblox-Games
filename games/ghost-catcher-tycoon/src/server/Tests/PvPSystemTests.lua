--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local PvPSystemTests = {}

local function createMockDataManager()
	local mock = {}
	function mock:getPlayerData(player)
		return {
			PvP = {
				LastBattleTime = 0,
				Wins = 0,
				Losses = 0,
				Rating = 1000,
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
	function mock:addEnergy(player, amount)
		-- Mock add
	end
	return mock
end

local function createMockGhostSystem()
	local mock = {}
	function mock:getPlayerGhosts(player)
		return {
			{ Id = "ghost_1", Rarity = "Common", Level = 1 },
			{ Id = "ghost_2", Rarity = "Uncommon", Level = 2 },
		}
	end
	return mock
end

local function createMockPlayer(userId)
	return {
		UserId = userId or 1,
		Name = "TestPlayer",
	}
end

function PvPSystemTests:testInitializePlayer()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	assert(pvpSystem.pvpData[1] ~= nil, "PvP data should be initialized")
	assert(pvpSystem.pvpData[1].Wins == 0, "Wins should start at 0")
	assert(pvpSystem.pvpData[1].Losses == 0, "Losses should start at 0")
	assert(pvpSystem.pvpData[1].Rating == 1000, "Rating should start at 1000")
	print("[PASS] testInitializePlayer")
end

function PvPSystemTests:testRemovePlayer()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)
	pvpSystem:removePlayer(1)

	assert(pvpSystem.pvpData[1] == nil, "PvP data should be removed")
	print("[PASS] testRemovePlayer")
end

function PvPSystemTests:testCanBattle()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())
	pvpSystem:setGhostSystem(createMockGhostSystem())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local canBattle, reason = pvpSystem:canBattle(player)
	assert(canBattle == true, "Should be able to battle")
	print("[PASS] testCanBattle")
end

function PvPSystemTests:testCanBattleNoGhosts()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local mockGhost = createMockGhostSystem()
	function mockGhost:getPlayerGhosts(player)
		return {}
	end
	pvpSystem:setGhostSystem(mockGhost)

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local canBattle, reason = pvpSystem:canBattle(player)
	assert(canBattle == false, "Cannot battle without ghosts")
	assert(reason == "No ghosts to battle with", "Should indicate no ghosts")
	print("[PASS] testCanBattleNoGhosts")
end

function PvPSystemTests:testCalculateGhostPower()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()

	local ghost = { Rarity = "Uncommon", Level = 5 }
	local power = pvpSystem:_calculateGhostPower(ghost)
	assert(power > 0, "Ghost should have positive power")
	print("[PASS] testCalculateGhostPower")
end

function PvPSystemTests:testCalculateGhostPowerHigherRarity()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()

	local commonGhost = { Rarity = "Common", Level = 1 }
	local rareGhost = { Rarity = "Rare", Level = 1 }

	local commonPower = pvpSystem:_calculateGhostPower(commonGhost)
	local rarePower = pvpSystem:_calculateGhostPower(rareGhost)

	assert(rarePower > commonPower, "Rare ghost should have more power than common")
	print("[PASS] testCalculateGhostPowerHigherRarity")
end

function PvPSystemTests:testCalculateTeamPower()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()

	local ghosts = {
		{ Rarity = "Common", Level = 1 },
		{ Rarity = "Uncommon", Level = 2 },
		{ Rarity = "Rare", Level = 3 },
	}

	local power = pvpSystem:_calculateTeamPower(ghosts)
	assert(power > 0, "Team should have positive power")
	print("[PASS] testCalculateTeamPower")
end

function PvPSystemTests:testStartBattle()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())
	pvpSystem:setCurrencySystem(createMockCurrencySystem())
	pvpSystem:setGhostSystem(createMockGhostSystem())

	local attacker = createMockPlayer(1)
	local defender = createMockPlayer(2)

	pvpSystem:initializePlayer(attacker)
	pvpSystem:initializePlayer(defender)

	local success, result = pvpSystem:startBattle(attacker, defender)
	assert(success == true, "Battle should succeed")
	assert(result.Winner ~= nil, "Should have a winner")
	assert(result.Reward ~= nil, "Should have reward")
	print("[PASS] testStartBattle")
end

function PvPSystemTests:testStartBattleNoGhosts()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local mockGhost = createMockGhostSystem()
	function mockGhost:getPlayerGhosts(player)
		return {}
	end
	pvpSystem:setGhostSystem(mockGhost)

	local attacker = createMockPlayer(1)
	local defender = createMockPlayer(2)

	pvpSystem:initializePlayer(attacker)
	pvpSystem:initializePlayer(defender)

	local success, reason = pvpSystem:startBattle(attacker, defender)
	assert(success == false, "Battle should fail without ghosts")
	print("[PASS] testStartBattleNoGhosts")
end

function PvPSystemTests:testGetPlayerStats()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local stats = pvpSystem:getPlayerStats(player)
	assert(stats ~= nil, "Should return stats")
	assert(stats.Wins == 0, "Initial wins should be 0")
	print("[PASS] testGetPlayerStats")
end

function PvPSystemTests:testGetPlayerRating()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local rating = pvpSystem:getPlayerRating(player)
	assert(rating == 1000, "Initial rating should be 1000")
	print("[PASS] testGetPlayerRating")
end

function PvPSystemTests:testGetPlayerWins()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local wins = pvpSystem:getPlayerWins(player)
	assert(wins == 0, "Initial wins should be 0")
	print("[PASS] testGetPlayerWins")
end

function PvPSystemTests:testGetPlayerLosses()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local losses = pvpSystem:getPlayerLosses(player)
	assert(losses == 0, "Initial losses should be 0")
	print("[PASS] testGetPlayerLosses")
end

function PvPSystemTests:testGetWinRate()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	-- No battles yet
	local winRate = pvpSystem:getWinRate(player)
	assert(winRate == 0, "Win rate with no battles should be 0")

	-- Simulate some wins/losses
	pvpSystem.pvpData[1].Wins = 3
	pvpSystem.pvpData[1].Losses = 2

	winRate = pvpSystem:getWinRate(player)
	assert(winRate == 0.6, "Win rate should be 3/5 = 0.6")
	print("[PASS] testGetWinRate")
end

function PvPSystemTests:testGetTimeSinceLastBattle()
	local PvPSystem = require(game:GetService("ServerScriptService"):WaitForChild("PvPSystem"))
	local pvpSystem = PvPSystem:new()
	pvpSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	pvpSystem:initializePlayer(player)

	local timeSince = pvpSystem:getTimeSinceLastBattle(player)
	assert(timeSince >= 0, "Time since last battle should be non-negative")
	print("[PASS] testGetTimeSinceLastBattle")
end

function PvPSystemTests:runAll()
	print("\n[TEST SUITE] PvPSystem Tests")
	self:testInitializePlayer()
	self:testRemovePlayer()
	self:testCanBattle()
	self:testCanBattleNoGhosts()
	self:testCalculateGhostPower()
	self:testCalculateGhostPowerHigherRarity()
	self:testCalculateTeamPower()
	self:testStartBattle()
	self:testStartBattleNoGhosts()
	self:testGetPlayerStats()
	self:testGetPlayerRating()
	self:testGetPlayerWins()
	self:testGetPlayerLosses()
	self:testGetWinRate()
	self:testGetTimeSinceLastBattle()
	print("[TEST SUITE] PvPSystem Tests - All passed!\n")
end

return PvPSystemTests
-- Built with assistance from Claude Code by Anthropic.

