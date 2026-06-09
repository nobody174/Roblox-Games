--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local LeaderboardSystem = {}
LeaderboardSystem.__index = LeaderboardSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function LeaderboardSystem:new()
	local self = setmetatable({}, LeaderboardSystem)
	self.playerStats = {}
	self.leaderboards = {}
	self.lastUpdateTime = 0
	self.dataManager = nil
	return self
end

function LeaderboardSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function LeaderboardSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.playerStats then
		self.playerStats = {}
	end

	local stats = {
		UserId = userId,
		Username = player.Name,
		TotalEnergyEarned = 0,
		GhostsCaught = 0,
		PrestigeLevel = 0,
		HighestZone = "Forest",
	}

	if self.dataManager then
		local data = self.dataManager:getPlayerData(player)
		if data then
			stats.TotalEnergyEarned = data.TotalEnergyEarned or 0
			stats.GhostsCaught = data.GhostsCaught or 0
			stats.PrestigeLevel = (data.Prestige and data.Prestige.Level) or 0
			stats.HighestZone = data.HighestZone or "Forest"
		end
	end

	self.playerStats[userId] = stats
	self:_updateLeaderboards()
end

function LeaderboardSystem:removePlayer(userId)
	self.playerStats[userId] = nil
	self:_updateLeaderboards()
end

function LeaderboardSystem:updatePlayerStat(player, statName, value)
	local userId = player.UserId

	if not self.playerStats[userId] then
		return
	end

	if statName == "TotalEnergyEarned" or statName == "GhostsCaught" or statName == "PrestigeLevel" then
		self.playerStats[userId][statName] = value
	elseif statName == "HighestZone" then
		-- Only update if new zone is higher rank
		local currentRank = Config.Leaderboard.ZoneRanks[self.playerStats[userId].HighestZone] or 0
		local newRank = Config.Leaderboard.ZoneRanks[value] or 0
		if newRank > currentRank then
			self.playerStats[userId].HighestZone = value
		end
	end

	-- Persist stats to DataStore
	self.dataManager:updatePlayerData(player, { LeaderboardStats = self.playerStats[userId] })

	self:_updateLeaderboards()
end

function LeaderboardSystem:_updateLeaderboards()
	local now = os.time()

	-- Rate limit updates to prevent excessive sorting
	if now - self.lastUpdateTime < Config.Leaderboard.UpdateInterval then
		return
	end

	self.lastUpdateTime = now

	-- Rebuild all leaderboards
	for _, category in ipairs(Config.Leaderboard.Categories) do
		self.leaderboards[category] = self:_buildLeaderboard(category)
	end
end

function LeaderboardSystem:_buildLeaderboard(category)
	local entries = {}

	for userId, stats in pairs(self.playerStats) do
		table.insert(entries, {
			UserId = userId,
			Username = stats.Username,
			Value = stats[category] or 0,
		})
	end

	-- Sort by value descending
	table.sort(entries, function(a, b)
		return a.Value > b.Value
	end)

	-- Keep only top entries
	local result = {}
	for i = 1, math.min(Config.Leaderboard.TopCount, #entries) do
		entries[i].Rank = i
		table.insert(result, entries[i])
	end

	return result
end

function LeaderboardSystem:getLeaderboard(category)
	if not self.leaderboards[category] then
		return {}
	end
	return self.leaderboards[category]
end

function LeaderboardSystem:getPlayerRank(player, category)
	local userId = player.UserId
	local leaderboard = self:getLeaderboard(category)

	for _, entry in ipairs(leaderboard) do
		if entry.UserId == userId then
			return entry.Rank
		end
	end

	return nil
end

function LeaderboardSystem:getPlayerPosition(player, category)
	local userId = player.UserId

	if not self.playerStats[userId] then
		return nil
	end

	local leaderboard = self:getLeaderboard(category)
	local playerValue = self.playerStats[userId][category] or 0

	local position = 1
	for _, entry in ipairs(leaderboard) do
		if entry.Value > playerValue then
			position = position + 1
		end
	end

	return position
end

function LeaderboardSystem:getAllLeaderboards()
	return self.leaderboards
end

function LeaderboardSystem:getPlayerStats(player)
	return self.playerStats[player.UserId]
end

return LeaderboardSystem
-- Built with assistance from Claude Code by Anthropic.

