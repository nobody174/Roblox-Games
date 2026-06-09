--
-- Level System — Ghost Catcher Tycoon
-- Manages player leveling (1-100) and XP progression with skill point awards
--

local LevelSystem = {}

-- XP requirements per level bracket
local XP_REQUIREMENTS = {
	-- Levels 1-10: 100 XP per level
	{minLevel = 1, maxLevel = 10, xpPerLevel = 100},
	-- Levels 11-25: 250 XP per level
	{minLevel = 11, maxLevel = 25, xpPerLevel = 250},
	-- Levels 26-50: 500 XP per level
	{minLevel = 26, maxLevel = 50, xpPerLevel = 500},
	-- Levels 51-75: 1000 XP per level
	{minLevel = 51, maxLevel = 75, xpPerLevel = 1000},
	-- Levels 76-100: 2500 XP per level
	{minLevel = 76, maxLevel = 100, xpPerLevel = 2500},
}

-- Max level cap
local MAX_LEVEL = 100

-- Player progression data: [userId] = {level, currentXP, totalXP, skillPoints, levelUpCallbacks}
local playerProgressions = {}

-- Get XP requirement for a specific level
local function getXPRequirement(level)
	if level > MAX_LEVEL then
		return 0
	end

	for _, bracket in ipairs(XP_REQUIREMENTS) do
		if level >= bracket.minLevel and level <= bracket.maxLevel then
			return bracket.xpPerLevel
		end
	end

	return 0
end

-- Calculate total XP needed to reach a level from level 1
local function getTotalXPForLevel(targetLevel)
	if targetLevel <= 1 then return 0 end

	local totalXP = 0
	for level = 2, math.min(targetLevel, MAX_LEVEL) do
		totalXP = totalXP + getXPRequirement(level)
	end

	return totalXP
end

-- Initialize player progression on join
function LevelSystem:initializePlayer(userId)
	if not playerProgressions[userId] then
		playerProgressions[userId] = {
			level = 1,
			currentXP = 0,
			totalXP = 0,
			skillPoints = 0,
			levelUpCallbacks = {},
		}
	end
	return playerProgressions[userId]
end

-- Get player progression data
function LevelSystem:getProgression(userId)
	if not playerProgressions[userId] then
		self:initializePlayer(userId)
	end
	return playerProgressions[userId]
end

-- Get player level
function LevelSystem:getLevel(userId)
	local prog = self:getProgression(userId)
	return prog.level
end

-- Get current XP in current level
function LevelSystem:getCurrentXP(userId)
	local prog = self:getProgression(userId)
	return prog.currentXP
end

-- Get XP needed for next level
function LevelSystem:getXPForNextLevel(userId)
	local prog = self:getProgression(userId)

	if prog.level >= MAX_LEVEL then
		return 0
	end

	return getXPRequirement(prog.level + 1)
end

-- Get total XP earned (all time)
function LevelSystem:getTotalXP(userId)
	local prog = self:getProgression(userId)
	return prog.totalXP
end

-- Get skill points available
function LevelSystem:getSkillPoints(userId)
	local prog = self:getProgression(userId)
	return prog.skillPoints
end

-- Get progression to next level as percentage (0-1)
function LevelSystem:getProgressPercent(userId)
	local prog = self:getProgression(userId)
	local xpNeeded = self:getXPForNextLevel(userId)

	if xpNeeded == 0 then
		return 1.0
	end

	return math.min(prog.currentXP / xpNeeded, 1.0)
end

-- Add XP to player (handles leveling up)
function LevelSystem:addXP(userId, amount)
	if amount <= 0 then
		return {
			success = false,
			reason = "INVALID_XP_AMOUNT",
		}
	end

	local prog = self:getProgression(userId)
	prog.totalXP = prog.totalXP + amount
	prog.currentXP = prog.currentXP + amount

	-- Check for level ups
	local leveledUp = false
	while prog.level < MAX_LEVEL do
		local xpNeeded = self:getXPForNextLevel(userId)

		if prog.currentXP >= xpNeeded then
			prog.currentXP = prog.currentXP - xpNeeded
			self:levelUp(userId)
			leveledUp = true
		else
			break
		end
	end

	return {
		success = true,
		xpAdded = amount,
		level = prog.level,
		currentXP = prog.currentXP,
		leveledUp = leveledUp,
		skillPoints = prog.skillPoints,
	}
end

-- Level up player (internal, called by addXP)
function LevelSystem:levelUp(userId)
	local prog = self:getProgression(userId)

	if prog.level >= MAX_LEVEL then
		return {
			success = false,
			reason = "MAX_LEVEL_REACHED",
		}
	end

	prog.level = prog.level + 1
	prog.skillPoints = prog.skillPoints + 1

	-- Call level up callbacks
	for _, callback in ipairs(prog.levelUpCallbacks) do
		callback(prog.level)
	end

	return {
		success = true,
		newLevel = prog.level,
		skillPointsGained = 1,
		totalSkillPoints = prog.skillPoints,
	}
end

-- Use a skill point
function LevelSystem:useSkillPoint(userId)
	local prog = self:getProgression(userId)

	if prog.skillPoints <= 0 then
		return {
			success = false,
			reason = "NO_SKILL_POINTS",
			skillPoints = prog.skillPoints,
		}
	end

	prog.skillPoints = prog.skillPoints - 1

	return {
		success = true,
		skillPointsRemaining = prog.skillPoints,
	}
end

-- Refund a skill point
function LevelSystem:refundSkillPoint(userId)
	local prog = self:getProgression(userId)
	prog.skillPoints = prog.skillPoints + 1

	return {
		success = true,
		skillPointsRefunded = 1,
		skillPointsRemaining = prog.skillPoints,
	}
end

-- Register callback for level up event
function LevelSystem:onLevelUp(userId, callback)
	local prog = self:getProgression(userId)
	table.insert(prog.levelUpCallbacks, callback)
end

-- Get player level info (for UI display)
function LevelSystem:getLevelInfo(userId)
	local prog = self:getProgression(userId)
	local currentXP = prog.currentXP
	local nextLevelXP = self:getXPForNextLevel(userId)

	return {
		level = prog.level,
		currentXP = currentXP,
		nextLevelXP = nextLevelXP,
		progressPercent = self:getProgressPercent(userId),
		skillPoints = prog.skillPoints,
		totalXP = prog.totalXP,
		maxLevel = MAX_LEVEL,
		isMaxLevel = prog.level >= MAX_LEVEL,
	}
end

-- Force set level (admin only)
function LevelSystem:setLevel(userId, level)
	if level < 1 or level > MAX_LEVEL then
		return {
			success = false,
			reason = "INVALID_LEVEL",
		}
	end

	local prog = self:getProgression(userId)
	local previousLevel = prog.level
	local previousSkillPoints = prog.skillPoints

	prog.level = level
	prog.currentXP = 0
	prog.totalXP = getTotalXPForLevel(level)
	prog.skillPoints = previousSkillPoints + (level - previousLevel)

	return {
		success = true,
		previousLevel = previousLevel,
		newLevel = level,
		skillPointsGained = level - previousLevel,
	}
end

-- Clean up on player leave
function LevelSystem:removePlayer(userId)
	playerProgressions[userId] = nil
end

return LevelSystem
