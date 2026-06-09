--
-- Ghost Catcher Tycoon - Quest Manager
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
local QuestManager = {}
QuestManager.__index = QuestManager

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function QuestManager:new()
	local self = setmetatable({}, QuestManager)
	self.playerQuestData = {}
	self.dataManager = nil
	self.eventSystem = nil
	return self
end

function QuestManager:setDataManager(dataManager)
	self.dataManager = dataManager
end

function QuestManager:setEventSystem(eventSystem)
	self.eventSystem = eventSystem
end

function QuestManager:initializePlayer(player)
	local userId = player.UserId

	if not self.playerQuestData[userId] then
		self.playerQuestData[userId] = {
			dailyQuests = {},
			challengeQuests = {},
			streakData = {
				currentStreak = 0,
				lastCompletionDate = 0,
				totalCompletions = 0,
				streakRewardClaimed = false,
			},
			questEvents = {},
			lastDailyReset = 0,
		}
	end

	if self.dataManager then
		local playerData = self.dataManager:getPlayerData(player)
		if playerData and playerData.QuestManagerData then
			self.playerQuestData[userId] = playerData.QuestManagerData
		end
	end

	self:_checkAndResetDailyQuests(player)
	self:_initializeChallengeQuests(player)
end

function QuestManager:removePlayer(userId)
	self.playerQuestData[userId] = nil
end

function QuestManager:getActiveQuests(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return {}
	end

	return {
		daily = data.dailyQuests,
		challenges = data.challengeQuests,
	}
end

function QuestManager:getQuestProgress(player, questId)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return nil
	end

	for _, quest in ipairs(data.dailyQuests) do
		if quest.id == questId then
			return quest
		end
	end

	for _, quest in ipairs(data.challengeQuests) do
		if quest.id == questId then
			return quest
		end
	end

	return nil
end

function QuestManager:trackQuestEvent(player, eventType, value)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return
	end

	-- Track based on event type
	if eventType == "GhostCaught" then
		self:_trackGhostCaught(player, value)
	elseif eventType == "CoinsEarned" then
		self:_trackCoinsEarned(player, value)
	elseif eventType == "ZoneVisited" then
		self:_trackZoneVisited(player, value)
	elseif eventType == "CorruptedCaught" then
		self:_trackCorruptedCaught(player, value)
	end

	self:_persistQuestData(player)
end

function QuestManager:_trackGhostCaught(player, ghostRarity)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	for _, quest in ipairs(data.dailyQuests) do
		if quest.questType == "CatchCommon" and ghostRarity == "Common" then
			quest.progress = math.min(quest.progress + 1, quest.target)
			quest.completed = quest.progress >= quest.target
		elseif quest.questType == "CatchRare" and ghostRarity == "Rare" then
			quest.progress = math.min(quest.progress + 1, quest.target)
			quest.completed = quest.progress >= quest.target
		elseif quest.questType == "CatchLegendary" and ghostRarity == "Legendary" then
			quest.progress = math.min(quest.progress + 1, quest.target)
			quest.completed = quest.progress >= quest.target
		end
	end

	for _, quest in ipairs(data.challengeQuests) do
		if quest.questType == "Catch10Corrupted" and ghostRarity == "Corrupted" then
			if not quest.playerDied then
				quest.progress = math.min(quest.progress + 1, quest.target)
				quest.completed = quest.progress >= quest.target
			end
		end
	end
end

function QuestManager:_trackCoinsEarned(player, coinAmount)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	for _, quest in ipairs(data.dailyQuests) do
		if quest.questType == "Earn10kCoins" then
			quest.progress = math.min(quest.progress + coinAmount, quest.target)
			quest.completed = quest.progress >= quest.target
		end
	end
end

function QuestManager:_trackZoneVisited(player, zoneName)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	for _, quest in ipairs(data.dailyQuests) do
		if quest.questType == "CatchInEachZone" then
			if not quest.visitedZones then
				quest.visitedZones = {}
			end
			if not quest.visitedZones[zoneName] then
				quest.visitedZones[zoneName] = true
				quest.progress = quest.progress + 1
				quest.completed = quest.progress >= quest.target
			end
		end
	end

	for _, quest in ipairs(data.challengeQuests) do
		if quest.questType == "CatchInAll12Zones" then
			if not quest.visitedZones then
				quest.visitedZones = {}
			end
			if not quest.visitedZones[zoneName] then
				quest.visitedZones[zoneName] = true
				quest.progress = quest.progress + 1
				quest.completed = quest.progress >= quest.target
			end
		end
	end
end

function QuestManager:_trackCorruptedCaught(player, caught)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	for _, quest in ipairs(data.challengeQuests) do
		if quest.questType == "Catch10Corrupted" and caught then
			if not quest.playerDied then
				quest.progress = math.min(quest.progress + 1, quest.target)
				quest.completed = quest.progress >= quest.target
			end
		end
	end
end

function QuestManager:completeQuest(player, questId)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return false, "Player data not found"
	end

	for _, quest in ipairs(data.dailyQuests) do
		if quest.id == questId and quest.completed and not quest.claimed then
			quest.claimed = true
			quest.claimedTime = os.time()
			self:_awardQuestReward(player, quest)
			self:_updateStreak(player)
			self:_persistQuestData(player)
			return true, quest.rewards
		end
	end

	for _, quest in ipairs(data.challengeQuests) do
		if quest.id == questId and quest.completed and not quest.claimed then
			quest.claimed = true
			quest.claimedTime = os.time()
			self:_awardQuestReward(player, quest)
			self:_persistQuestData(player)
			return true, quest.rewards
		end
	end

	return false, "Quest not found or not completable"
end

function QuestManager:_awardQuestReward(player, quest)
	if not self.dataManager then
		return
	end

	local rewards = quest.rewards

	-- Award coins
	if rewards.coins and rewards.coins > 0 then
		self.dataManager:addPlayerResource(player, "coins", rewards.coins)
	end

	-- Award XP
	if rewards.xp and rewards.xp > 0 then
		self.dataManager:addPlayerResource(player, "xp", rewards.xp)
	end

	-- Emit quest completion event
	if self.eventSystem then
		self.eventSystem:emit("QuestCompleted", {
			player = player,
			questId = quest.id,
			questType = quest.questType,
			rewards = rewards,
		})
	end
end

function QuestManager:_updateStreak(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]
	local now = os.time()
	local lastCompletion = data.streakData.lastCompletionDate or 0

	-- Get day of last completion
	local lastDay = os.date("*t", lastCompletion)
	local currentDay = os.date("*t", now)

	-- Check if last completion was yesterday (within 24h but different day)
	local daysSince = math.floor((now - lastCompletion) / 86400)

	if daysSince == 0 then
		-- Already completed today
		return
	elseif daysSince == 1 then
		-- Completed yesterday, continue streak
		data.streakData.currentStreak = data.streakData.currentStreak + 1
	else
		-- Streak broken, reset
		data.streakData.currentStreak = 1
	end

	data.streakData.lastCompletionDate = now
	data.streakData.totalCompletions = data.streakData.totalCompletions + 1
	data.streakData.streakRewardClaimed = false

	-- Check for streak milestones
	self:_checkStreakMilestones(player)
end

function QuestManager:_checkStreakMilestones(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]
	local streak = data.streakData.currentStreak

	if streak == 3 and not data.streakData.rewarded3Day then
		-- 3 day streak: +50% reward next quest
		data.streakData.rewarded3Day = true
		data.streakData.nextQuestMultiplier = 1.5
		if self.eventSystem then
			self.eventSystem:emit("StreakMilestone", {
				player = player,
				streak = 3,
				reward = "50% bonus on next quest",
			})
		end
	end

	if streak == 7 and not data.streakData.rewarded7Day then
		-- 7 day streak: Unlock cosmetic
		data.streakData.rewarded7Day = true
		if self.dataManager then
			self.dataManager:unlockedCosmetic(player, "7DayStreakParticles")
		end
		if self.eventSystem then
			self.eventSystem:emit("StreakMilestone", {
				player = player,
				streak = 7,
				reward = "Cosmetic: 7 Day Streak Particles",
			})
		end
	end

	if streak == 30 and not data.streakData.rewarded30Day then
		-- 30 day streak: Title "Dedication"
		data.streakData.rewarded30Day = true
		if self.dataManager then
			self.dataManager:awardTitle(player, "Dedication")
		end
		if self.eventSystem then
			self.eventSystem:emit("StreakMilestone", {
				player = player,
				streak = 30,
				reward = "Title: Dedication",
			})
		end
	end
end

function QuestManager:getStreakInfo(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return nil
	end

	return {
		currentStreak = data.streakData.currentStreak,
		totalCompletions = data.streakData.totalCompletions,
		lastCompletionDate = data.streakData.lastCompletionDate,
		nextQuestMultiplier = data.streakData.nextQuestMultiplier or 1.0,
	}
end

function QuestManager:resetDailyQuests(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return
	end

	data.dailyQuests = {}
	data.lastDailyReset = os.time()
	self:_generateDailyQuests(player)
	self:_persistQuestData(player)
end

function QuestManager:_checkAndResetDailyQuests(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]
	local now = os.time()

	local lastReset = data.lastDailyReset or 0
	local lastDate = os.date("*t", lastReset)
	local currentDate = os.date("*t", now)

	-- Reset if different day
	if lastDate.year ~= currentDate.year or lastDate.yday ~= currentDate.yday then
		self:resetDailyQuests(player)
	elseif #data.dailyQuests == 0 then
		self:_generateDailyQuests(player)
	end
end

function QuestManager:_generateDailyQuests(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	-- Check player level (requires level 25)
	local playerLevel = self:_getPlayerLevel(player)
	if playerLevel < 25 then
		return
	end

	local dailyQuestTemplates = {
		{
			id = "daily_catch_5_common",
			questType = "CatchCommon",
			title = "Catch 5 Common Ghosts",
			description = "Catch 5 Common ghosts",
			target = 5,
			progress = 0,
			completed = false,
			claimed = false,
			rewards = { coins = 500, xp = 100 },
		},
		{
			id = "daily_catch_2_rare",
			questType = "CatchRare",
			title = "Catch 2 Rare Ghosts",
			description = "Catch 2 Rare ghosts",
			target = 2,
			progress = 0,
			completed = false,
			claimed = false,
			rewards = { coins = 2000, xp = 300 },
		},
		{
			id = "daily_catch_in_each_zone",
			questType = "CatchInEachZone",
			title = "Catch a Ghost in Each Zone",
			description = "Catch a ghost in each zone",
			target = 12,
			progress = 0,
			completed = false,
			claimed = false,
			rewards = { coins = 1000, xp = 250 },
			visitedZones = {},
		},
		{
			id = "daily_earn_10k_coins",
			questType = "Earn10kCoins",
			title = "Earn 10,000 Coins",
			description = "Earn 10,000 coins",
			target = 10000,
			progress = 0,
			completed = false,
			claimed = false,
			rewards = { coins = 2000, xp = 200 },
		},
		{
			id = "daily_catch_1_legendary",
			questType = "CatchLegendary",
			title = "Catch 1 Legendary Ghost",
			description = "Catch 1 Legendary ghost",
			target = 1,
			progress = 0,
			completed = false,
			claimed = false,
			rewards = { coins = 5000, xp = 500 },
		},
	}

	data.dailyQuests = dailyQuestTemplates
end

function QuestManager:_initializeChallengeQuests(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data.challengeQuests or #data.challengeQuests == 0 then
		local playerLevel = self:_getPlayerLevel(player)

		data.challengeQuests = {}

		-- Level 35+ quests
		if playerLevel >= 35 then
			table.insert(data.challengeQuests, {
				id = "challenge_catch_10_corrupted",
				questType = "Catch10Corrupted",
				title = "Catch 10 Corrupted Ghosts Without Dying",
				description = "Catch 10 Corrupted ghosts without dying in one session",
				target = 10,
				progress = 0,
				completed = false,
				claimed = false,
				rewards = { coins = 50000, xp = 5000 },
				playerDied = false,
				sessionStartTime = os.time(),
			})

			table.insert(data.challengeQuests, {
				id = "challenge_catch_all_zones",
				questType = "CatchInAll12Zones",
				title = "Catch Ghosts in All 12 Zones",
				description = "Catch ghosts in all 12 zones in one session",
				target = 12,
				progress = 0,
				completed = false,
				claimed = false,
				rewards = { coins = 30000, xp = 3000 },
				visitedZones = {},
				sessionStartTime = os.time(),
			})

			table.insert(data.challengeQuests, {
				id = "challenge_personal_record",
				questType = "PersonalRecord",
				title = "Beat Personal Record",
				description = "Catch the most ghosts in 1 hour (adds to leaderboard)",
				target = 0, -- Dynamic, based on player's best
				progress = 0,
				completed = false,
				claimed = false,
				rewards = { cosmetic = "LeaderboardTop10Glow", xp = 3000 },
				sessionStartTime = os.time(),
				hourStartTime = os.time(),
			})
		end
	end
end

function QuestManager:_getPlayerLevel(player)
	if self.dataManager then
		local playerData = self.dataManager:getPlayerData(player)
		if playerData and playerData.level then
			return playerData.level
		end
	end
	return 1
end

function QuestManager:_persistQuestData(player)
	if self.dataManager then
		local userId = player.UserId
		self.dataManager:updatePlayerData(player, {
			QuestManagerData = self.playerQuestData[userId]
		})
	end
end

function QuestManager:playerDied(player)
	local userId = player.UserId
	local data = self.playerQuestData[userId]

	if not data then
		return
	end

	for _, quest in ipairs(data.challengeQuests) do
		if quest.questType == "Catch10Corrupted" then
			quest.playerDied = true
			quest.completed = false
			quest.progress = 0
		end
	end

	self:_persistQuestData(player)
end

return QuestManager
-- Built with assistance from Claude Code by Anthropic.
