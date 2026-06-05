--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local QuestSystem = {}
QuestSystem.__index = QuestSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function QuestSystem:new()
	local self = setmetatable({}, QuestSystem)
	self.questData = {}
	self.dataManager = nil
	return self
end

function QuestSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function QuestSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.questData then
		self.questData = {}
	end

	local quests = {
		Daily = {},
		Weekly = {},
		LastDailyReset = 0,
		LastWeeklyReset = 0,
	}

	if self.dataManager then
		local data = self.dataManager:getPlayerData(player)
		if data and data.Quests then
			quests = data.Quests
		end
	end

	self.questData[userId] = quests
	self:_resetQuestsIfNeeded(player)
end

function QuestSystem:removePlayer(userId)
	self.questData[userId] = nil
end

function QuestSystem:_resetQuestsIfNeeded(player)
	local userId = player.UserId
	local quests = self.questData[userId]
	local now = os.time()

	-- Check daily reset
	local lastDailyTime = quests.LastDailyReset or 0
	if self:_shouldResetDaily(lastDailyTime, now) then
		quests.Daily = {}
		quests.LastDailyReset = now
		self:_generateDailyQuests(player)
	end

	-- Check weekly reset
	local lastWeeklyTime = quests.LastWeeklyReset or 0
	if self:_shouldResetWeekly(lastWeeklyTime, now) then
		quests.Weekly = {}
		quests.LastWeeklyReset = now
		self:_generateWeeklyQuests(player)
	end

	-- Ensure quests exist
	if #quests.Daily == 0 then
		self:_generateDailyQuests(player)
	end
	if #quests.Weekly == 0 then
		self:_generateWeeklyQuests(player)
	end
end

function QuestSystem:_shouldResetDaily(lastTime, now)
	local lastDate = os.date("!*t", lastTime)
	local nowDate = os.date("!*t", now)

	-- Different day if year or day of year differs
	if lastDate.year ~= nowDate.year or lastDate.yday ~= nowDate.yday then
		return true
	end
	return false
end

function QuestSystem:_shouldResetWeekly(lastTime, now)
	local lastDate = os.date("!*t", lastTime)
	local nowDate = os.date("!*t", now)

	-- Check if week changed (different week number or year)
	local lastWeek = math.floor((lastDate.yday - lastDate.wday) / 7)
	local nowWeek = math.floor((nowDate.yday - nowDate.wday) / 7)

	if lastDate.year ~= nowDate.year or lastWeek ~= nowWeek then
		return true
	end
	return false
end

function QuestSystem:_generateDailyQuests(player)
	local userId = player.UserId
	local quests = self.questData[userId]

	for i = 1, Config.Quests.DailyQuestCount do
		local questType = self:_selectRandomQuestType()
		local quest = self:_createQuest(questType, "Daily")
		table.insert(quests.Daily, quest)
	end
end

function QuestSystem:_generateWeeklyQuests(player)
	local userId = player.UserId
	local quests = self.questData[userId]

	for i = 1, Config.Quests.WeeklyQuestCount do
		local questType = self:_selectRandomQuestType()
		local quest = self:_createQuest(questType, "Weekly")
		table.insert(quests.Weekly, quest)
	end
end

function QuestSystem:_selectRandomQuestType()
	local types = {}
	for typeName, _ in pairs(Config.Quests.Types) do
		table.insert(types, typeName)
	end
	return types[math.random(1, #types)]
end

function QuestSystem:_createQuest(questType, frequency)
	local questConfig = Config.Quests.Types[questType]
	local targetIndex = math.random(1, #questConfig.Targets)
	local target = questConfig.Targets[targetIndex]

	return {
		Type = questType,
		Frequency = frequency,
		Target = target,
		Progress = 0,
		Completed = false,
		Claimed = false,
		Description = string.format(questConfig.Description, target),
		Rewards = questConfig.Rewards,
	}
end

function QuestSystem:getQuests(player, frequency)
	local userId = player.UserId
	local quests = self.questData[userId]

	if frequency == "Daily" then
		return quests.Daily or {}
	elseif frequency == "Weekly" then
		return quests.Weekly or {}
	end

	return {}
end

function QuestSystem:updateQuestProgress(player, questType, amount)
	local userId = player.UserId
	local quests = self.questData[userId]

	-- Update daily quests
	for _, quest in ipairs(quests.Daily or {}) do
		if quest.Type == questType and not quest.Completed then
			quest.Progress = math.min(quest.Progress + amount, quest.Target)
			if quest.Progress >= quest.Target then
				quest.Completed = true
			end
		end
	end

	-- Update weekly quests
	for _, quest in ipairs(quests.Weekly or {}) do
		if quest.Type == questType and not quest.Completed then
			quest.Progress = math.min(quest.Progress + amount, quest.Target)
			if quest.Progress >= quest.Target then
				quest.Completed = true
			end
		end
	end

	-- Persist quest changes to DataStore
	self:_persistQuests(player)
end

function QuestSystem:claimReward(player, frequency, questIndex)
	local userId = player.UserId
	local quests = self.questData[userId]
	local questList = frequency == "Daily" and quests.Daily or quests.Weekly

	if not questList or not questList[questIndex] then
		return false, "Quest not found"
	end

	local quest = questList[questIndex]

	if not quest.Completed then
		return false, "Quest not completed"
	end

	if quest.Claimed then
		return false, "Reward already claimed"
	end

	quest.Claimed = true
	self:_persistQuests(player)
	return true, quest.Rewards
end

function QuestSystem:hasClaimableRewards(player)
	local userId = player.UserId
	local quests = self.questData[userId]

	for _, quest in ipairs(quests.Daily or {}) do
		if quest.Completed and not quest.Claimed then
			return true
		end
	end

	for _, quest in ipairs(quests.Weekly or {}) do
		if quest.Completed and not quest.Claimed then
			return true
		end
	end

	return false
end

function QuestSystem:_persistQuests(player)
	self.dataManager:updatePlayerData(player, { Quests = self.questData[player.UserId] })
end

return QuestSystem
-- Built with assistance from Claude Code by Anthropic.

