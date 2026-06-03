--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local LeaderboardSystemTests = {}

local function createMockDataManager()
	local mock = {}
	function mock:getPlayerData(player)
		return {
			TotalEnergyEarned = 0,
			GhostsCaught = 0,
			Prestige = { Level = 0 },
			HighestZone = "Forest",
		}
	end
	return mock
end

local function createMockPlayer(userId, name)
	return {
		UserId = userId or 1,
		Name = name or "TestPlayer",
	}
end

function LeaderboardSystemTests:testInitializePlayer()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)

	assert(leaderboardSystem.playerStats[1] ~= nil, "Player stats should be initialized")
	assert(leaderboardSystem.playerStats[1].Username == "Player1", "Username should match")
	assert(leaderboardSystem.playerStats[1].TotalEnergyEarned == 0, "Energy should start at 0")
	print("[PASS] testInitializePlayer")
end

function LeaderboardSystemTests:testRemovePlayer()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)
	leaderboardSystem:removePlayer(1)

	assert(leaderboardSystem.playerStats[1] == nil, "Player stats should be removed")
	print("[PASS] testRemovePlayer")
end

function LeaderboardSystemTests:testUpdatePlayerStat()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)

	leaderboardSystem:updatePlayerStat(player, "TotalEnergyEarned", 5000)
	assert(leaderboardSystem.playerStats[1].TotalEnergyEarned == 5000, "Energy should update")

	leaderboardSystem:updatePlayerStat(player, "GhostsCaught", 25)
	assert(leaderboardSystem.playerStats[1].GhostsCaught == 25, "Ghosts caught should update")
	print("[PASS] testUpdatePlayerStat")
end

function LeaderboardSystemTests:testUpdateHighestZone()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)

	leaderboardSystem:updatePlayerStat(player, "HighestZone", "Graveyard")
	assert(leaderboardSystem.playerStats[1].HighestZone == "Graveyard", "Zone should update to higher rank")

	-- Attempt to downgrade zone (should fail)
	leaderboardSystem:updatePlayerStat(player, "HighestZone", "Forest")
	assert(leaderboardSystem.playerStats[1].HighestZone == "Graveyard", "Zone should not downgrade")
	print("[PASS] testUpdateHighestZone")
end

function LeaderboardSystemTests:testGetLeaderboard()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player1 = createMockPlayer(1, "Player1")
	local player2 = createMockPlayer(2, "Player2")

	leaderboardSystem:initializePlayer(player1)
	leaderboardSystem:initializePlayer(player2)

	leaderboardSystem:updatePlayerStat(player1, "TotalEnergyEarned", 5000)
	leaderboardSystem:updatePlayerStat(player2, "TotalEnergyEarned", 10000)

	local leaderboard = leaderboardSystem:getLeaderboard("TotalEnergyEarned")
	assert(#leaderboard > 0, "Leaderboard should have entries")
	assert(leaderboard[1].UserId == 2, "First place should be player2")
	assert(leaderboard[1].Rank == 1, "Rank should be 1")
	assert(leaderboard[2].UserId == 1, "Second place should be player1")
	assert(leaderboard[2].Rank == 2, "Rank should be 2")
	print("[PASS] testGetLeaderboard")
end

function LeaderboardSystemTests:testGetPlayerRank()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player1 = createMockPlayer(1, "Player1")
	local player2 = createMockPlayer(2, "Player2")

	leaderboardSystem:initializePlayer(player1)
	leaderboardSystem:initializePlayer(player2)

	leaderboardSystem:updatePlayerStat(player1, "GhostsCaught", 10)
	leaderboardSystem:updatePlayerStat(player2, "GhostsCaught", 20)

	local rank = leaderboardSystem:getPlayerRank(player2, "GhostsCaught")
	assert(rank == 1, "Player2 should be rank 1")

	rank = leaderboardSystem:getPlayerRank(player1, "GhostsCaught")
	assert(rank == 2, "Player1 should be rank 2")
	print("[PASS] testGetPlayerRank")
end

function LeaderboardSystemTests:testGetPlayerPosition()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player1 = createMockPlayer(1, "Player1")
	local player2 = createMockPlayer(2, "Player2")

	leaderboardSystem:initializePlayer(player1)
	leaderboardSystem:initializePlayer(player2)

	leaderboardSystem:updatePlayerStat(player1, "PrestigeLevel", 5)
	leaderboardSystem:updatePlayerStat(player2, "PrestigeLevel", 5)

	local position = leaderboardSystem:getPlayerPosition(player1, "PrestigeLevel")
	assert(position ~= nil, "Position should be returned")
	print("[PASS] testGetPlayerPosition")
end

function LeaderboardSystemTests:testGetAllLeaderboards()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)

	local allLeaderboards = leaderboardSystem:getAllLeaderboards()
	assert(allLeaderboards ~= nil, "Should return all leaderboards")
	print("[PASS] testGetAllLeaderboards")
end

function LeaderboardSystemTests:testGetPlayerStats()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1, "Player1")
	leaderboardSystem:initializePlayer(player)

	local stats = leaderboardSystem:getPlayerStats(player)
	assert(stats ~= nil, "Should return player stats")
	assert(stats.UserId == 1, "UserId should match")
	assert(stats.Username == "Player1", "Username should match")
	print("[PASS] testGetPlayerStats")
end

function LeaderboardSystemTests:testLeaderboardSorting()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	for i = 1, 5 do
		local player = createMockPlayer(i, "Player" .. i)
		leaderboardSystem:initializePlayer(player)
		leaderboardSystem:updatePlayerStat(player, "TotalEnergyEarned", i * 1000)
	end

	local leaderboard = leaderboardSystem:getLeaderboard("TotalEnergyEarned")
	assert(leaderboard[1].Value > leaderboard[2].Value, "Should be sorted descending")
	assert(leaderboard[2].Value > leaderboard[3].Value, "Should be sorted descending")
	print("[PASS] testLeaderboardSorting")
end

function LeaderboardSystemTests:testLeaderboardTopCount()
	local LeaderboardSystem = require(game:GetService("ServerScriptService"):WaitForChild("LeaderboardSystem"))
	local leaderboardSystem = LeaderboardSystem:new()
	leaderboardSystem:setDataManager(createMockDataManager())

	-- Create more players than TopCount
	for i = 1, 15 do
		local player = createMockPlayer(i, "Player" .. i)
		leaderboardSystem:initializePlayer(player)
		leaderboardSystem:updatePlayerStat(player, "GhostsCaught", i * 10)
	end

	local leaderboard = leaderboardSystem:getLeaderboard("GhostsCaught")
	assert(#leaderboard <= 10, "Leaderboard should be capped at TopCount")
	print("[PASS] testLeaderboardTopCount")
end

function LeaderboardSystemTests:runAll()
	print("\n[TEST SUITE] LeaderboardSystem Tests")
	self:testInitializePlayer()
	self:testRemovePlayer()
	self:testUpdatePlayerStat()
	self:testUpdateHighestZone()
	self:testGetLeaderboard()
	self:testGetPlayerRank()
	self:testGetPlayerPosition()
	self:testGetAllLeaderboards()
	self:testGetPlayerStats()
	self:testLeaderboardSorting()
	self:testLeaderboardTopCount()
	print("[TEST SUITE] LeaderboardSystem Tests - All passed!\n")
end

return LeaderboardSystemTests
-- Built with assistance from Claude Code by Anthropic.

