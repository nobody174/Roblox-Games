--[=[
  Ghost Catcher Tycoon - Quest System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local QuestSystemTests = {}

local function createMockDataManager()
	local mock = {}
	function mock:getPlayerData(player)
		return {
			Quests = {
				Daily = {},
				Weekly = {},
				LastDailyReset = 0,
				LastWeeklyReset = 0,
			},
		}
	end
	function mock:updatePlayerData(player, data)
		-- Mock save
	end
	return mock
end

local function createMockPlayer(userId)
	return {
		UserId = userId or 1,
		Name = "TestPlayer",
	}
end

function QuestSystemTests:testInitializePlayer()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	assert(questSystem.questData[1] ~= nil, "Quest data should be initialized")
	assert(questSystem.questData[1].Daily ~= nil, "Daily quests should exist")
	assert(questSystem.questData[1].Weekly ~= nil, "Weekly quests should exist")
	print("[PASS] testInitializePlayer")
end

function QuestSystemTests:testRemovePlayer()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)
	questSystem:removePlayer(1)

	assert(questSystem.questData[1] == nil, "Quest data should be removed")
	print("[PASS] testRemovePlayer")
end

function QuestSystemTests:testGenerateDailyQuests()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local dailyQuests = questSystem:getQuests(player, "Daily")
	assert(#dailyQuests > 0, "Daily quests should be generated")
	assert(dailyQuests[1].Type ~= nil, "Quest should have a type")
	assert(dailyQuests[1].Target ~= nil, "Quest should have a target")
	assert(dailyQuests[1].Progress == 0, "Quest should start with 0 progress")
	print("[PASS] testGenerateDailyQuests")
end

function QuestSystemTests:testGenerateWeeklyQuests()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local weeklyQuests = questSystem:getQuests(player, "Weekly")
	assert(#weeklyQuests > 0, "Weekly quests should be generated")
	assert(weeklyQuests[1].Type ~= nil, "Quest should have a type")
	assert(weeklyQuests[1].Frequency == "Weekly", "Quest should be marked as weekly")
	print("[PASS] testGenerateWeeklyQuests")
end

function QuestSystemTests:testUpdateQuestProgress()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	-- Get a daily quest and manually set its type for testing
	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Type = "CatchGhosts"
	dailyQuests[1].Target = 10

	questSystem:updateQuestProgress(player, "CatchGhosts", 5)
	assert(dailyQuests[1].Progress == 5, "Progress should be 5")

	questSystem:updateQuestProgress(player, "CatchGhosts", 5)
	assert(dailyQuests[1].Progress == 10, "Progress should be 10")
	assert(dailyQuests[1].Completed == true, "Quest should be completed")
	print("[PASS] testUpdateQuestProgress")
end

function QuestSystemTests:testProgressCapAtTarget()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Type = "CatchGhosts"
	dailyQuests[1].Target = 10

	questSystem:updateQuestProgress(player, "CatchGhosts", 20)
	assert(dailyQuests[1].Progress == 10, "Progress should cap at target")
	print("[PASS] testProgressCapAtTarget")
end

function QuestSystemTests:testClaimReward()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Completed = true

	local success, rewards = questSystem:claimReward(player, "Daily", 1)
	assert(success == true, "Claim should succeed")
	assert(rewards ~= nil, "Should return rewards")
	assert(dailyQuests[1].Claimed == true, "Quest should be marked claimed")
	print("[PASS] testClaimReward")
end

function QuestSystemTests:testClaimRewardAlreadyClaimed()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Completed = true
	dailyQuests[1].Claimed = true

	local success, reason = questSystem:claimReward(player, "Daily", 1)
	assert(success == false, "Second claim should fail")
	assert(reason == "Reward already claimed", "Should indicate already claimed")
	print("[PASS] testClaimRewardAlreadyClaimed")
end

function QuestSystemTests:testClaimRewardIncomplete()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Completed = false

	local success, reason = questSystem:claimReward(player, "Daily", 1)
	assert(success == false, "Incomplete quest claim should fail")
	assert(reason == "Quest not completed", "Should indicate not completed")
	print("[PASS] testClaimRewardIncomplete")
end

function QuestSystemTests:testHasClaimableRewards()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	assert(questSystem:hasClaimableRewards(player) == false, "Should have no claimable at start")

	local dailyQuests = questSystem:getQuests(player, "Daily")
	dailyQuests[1].Completed = true

	assert(questSystem:hasClaimableRewards(player) == true, "Should have claimable rewards")
	print("[PASS] testHasClaimableRewards")
end

function QuestSystemTests:testGetQuestsDaily()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local quests = questSystem:getQuests(player, "Daily")
	assert(quests ~= nil, "Should return daily quests")
	assert(#quests > 0, "Should have quests")
	print("[PASS] testGetQuestsDaily")
end

function QuestSystemTests:testGetQuestsWeekly()
	local QuestSystem = require(game:GetService("ServerScriptService"):WaitForChild("QuestSystem"))
	local questSystem = QuestSystem:new()
	questSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	questSystem:initializePlayer(player)

	local quests = questSystem:getQuests(player, "Weekly")
	assert(quests ~= nil, "Should return weekly quests")
	assert(#quests > 0, "Should have quests")
	print("[PASS] testGetQuestsWeekly")
end

function QuestSystemTests:runAll()
	print("\n[TEST SUITE] QuestSystem Tests")
	self:testInitializePlayer()
	self:testRemovePlayer()
	self:testGenerateDailyQuests()
	self:testGenerateWeeklyQuests()
	self:testUpdateQuestProgress()
	self:testProgressCapAtTarget()
	self:testClaimReward()
	self:testClaimRewardAlreadyClaimed()
	self:testClaimRewardIncomplete()
	self:testHasClaimableRewards()
	self:testGetQuestsDaily()
	self:testGetQuestsWeekly()
	print("[TEST SUITE] QuestSystem Tests - All passed!\n")
end

return QuestSystemTests
