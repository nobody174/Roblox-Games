--
-- Skill Tree System — Ghost Catcher Tycoon
-- Manages skill point allocation across 5 categories (15 skills total)
--

local SkillTree = {}

-- Skill tree structure: 5 categories with 3 skills each
local SKILLS = {
	Catching = {
		name = "Catching",
		skills = {
			{
				id = "catch_accuracy",
				name = "Accuracy Boost",
				description = "Increase catch rate by 5% per level",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "catch_critical",
				name = "Critical Catch",
				description = "5% chance per level to instantly catch any ghost",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "catch_rare_chance",
				name = "Rare Seeker",
				description = "Increase rare+ ghost spawn rate by 2% per level",
				maxLevel = 5,
				baseBonus = 0.02,
			},
		},
	},
	Energy = {
		name = "Energy",
		skills = {
			{
				id = "energy_regen",
				name = "Energy Regen",
				description = "Increase energy regen rate by 0.5 per second per level",
				maxLevel = 5,
				baseBonus = 0.5,
			},
			{
				id = "energy_efficiency",
				name = "Efficiency",
				description = "Reduce energy cost of catches by 2% per level",
				maxLevel = 5,
				baseBonus = 0.02,
			},
			{
				id = "energy_capacity",
				name = "High Capacity",
				description = "Increase max energy by 20 per level",
				maxLevel = 5,
				baseBonus = 20,
			},
		},
	},
	Coins = {
		name = "Coins",
		skills = {
			{
				id = "coins_earn",
				name = "Coin Bonus",
				description = "Earn 5% more coins per level",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "coins_pickup",
				name = "Magnet",
				description = "Coins automatically collected within X distance",
				maxLevel = 5,
				baseBonus = 1,
			},
			{
				id = "coins_multiplier",
				name = "Fortune",
				description = "10% chance to double coins on catch per level",
				maxLevel = 5,
				baseBonus = 0.10,
			},
		},
	},
	Movement = {
		name = "Movement",
		skills = {
			{
				id = "move_speed",
				name = "Swift",
				description = "Increase movement speed by 5% per level",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "move_dash",
				name = "Dash",
				description = "Unlock dash ability (speed boost for 2 seconds)",
				maxLevel = 3,
				baseBonus = 1,
			},
			{
				id = "move_teleport",
				name = "Phase Step",
				description = "Unlock short-range teleport (2 second cooldown)",
				maxLevel = 3,
				baseBonus = 1,
			},
		},
	},
	Misc = {
		name = "Miscellaneous",
		skills = {
			{
				id = "misc_xp_boost",
				name = "Experience",
				description = "Earn 5% more XP per level",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "misc_loot_rate",
				name = "Lucky",
				description = "5% increased item drop rate per level",
				maxLevel = 5,
				baseBonus = 0.05,
			},
			{
				id = "misc_cooldown_reduction",
				name = "Swift Reflexes",
				description = "Reduce ability cooldowns by 3% per level",
				maxLevel = 5,
				baseBonus = 0.03,
			},
		},
	},
}

-- Player skill data: [userId] = {category = {skillId = level}}
local playerSkills = {}

-- Initialize player skills on join
function SkillTree:initializePlayer(userId)
	if not playerSkills[userId] then
		playerSkills[userId] = {}

		-- Initialize all categories with empty skills
		for categoryName, categoryData in pairs(SKILLS) do
			playerSkills[userId][categoryName] = {}
			for _, skill in ipairs(categoryData.skills) do
				playerSkills[userId][categoryName][skill.id] = 0
			end
		end
	end

	return playerSkills[userId]
end

-- Get player skills
function SkillTree:getSkills(userId)
	if not playerSkills[userId] then
		self:initializePlayer(userId)
	end
	return playerSkills[userId]
end

-- Get skill info
local function getSkill(categoryName, skillId)
	if not SKILLS[categoryName] then
		return nil
	end

	for _, skill in ipairs(SKILLS[categoryName].skills) do
		if skill.id == skillId then
			return skill
		end
	end

	return nil
end

-- Allocate a skill point to a skill
function SkillTree:allocateSkill(userId, categoryName, skillId)
	local skills = self:getSkills(userId)
	local skill = getSkill(categoryName, skillId)

	if not skill then
		return {
			success = false,
			reason = "SKILL_NOT_FOUND",
		}
	end

	if not skills[categoryName] then
		return {
			success = false,
			reason = "CATEGORY_NOT_FOUND",
		}
	end

	local currentLevel = skills[categoryName][skillId] or 0

	if currentLevel >= skill.maxLevel then
		return {
			success = false,
			reason = "MAX_SKILL_LEVEL",
			skillId = skillId,
			currentLevel = currentLevel,
			maxLevel = skill.maxLevel,
		}
	end

	-- Skill point deduction is handled by LevelSystem
	skills[categoryName][skillId] = currentLevel + 1

	return {
		success = true,
		skillId = skillId,
		skillName = skill.name,
		newLevel = currentLevel + 1,
		maxLevel = skill.maxLevel,
		bonus = skill.baseBonus * (currentLevel + 1),
	}
end

-- Remove a skill point (refund)
function SkillTree:removeSkill(userId, categoryName, skillId)
	local skills = self:getSkills(userId)
	local skill = getSkill(categoryName, skillId)

	if not skill then
		return {
			success = false,
			reason = "SKILL_NOT_FOUND",
		}
	end

	if not skills[categoryName] then
		return {
			success = false,
			reason = "CATEGORY_NOT_FOUND",
		}
	end

	local currentLevel = skills[categoryName][skillId] or 0

	if currentLevel <= 0 then
		return {
			success = false,
			reason = "SKILL_NOT_INVESTED",
			skillId = skillId,
			currentLevel = currentLevel,
		}
	end

	skills[categoryName][skillId] = currentLevel - 1

	return {
		success = true,
		skillId = skillId,
		skillName = skill.name,
		newLevel = currentLevel - 1,
		refundedBonus = skill.baseBonus * currentLevel,
	}
end

-- Get skill level
function SkillTree:getSkillLevel(userId, categoryName, skillId)
	local skills = self:getSkills(userId)

	if not skills[categoryName] then
		return 0
	end

	return skills[categoryName][skillId] or 0
end

-- Get skill bonus (calculated based on level)
function SkillTree:getSkillBonus(userId, categoryName, skillId)
	local skill = getSkill(categoryName, skillId)
	if not skill then
		return 0
	end

	local level = self:getSkillLevel(userId, categoryName, skillId)
	return skill.baseBonus * level
end

-- Get total bonus for a skill category
function SkillTree:getCategoryBonus(userId, categoryName, bonusType)
	local skills = self:getSkills(userId)

	if not skills[categoryName] then
		return 0
	end

	local totalBonus = 0
	if SKILLS[categoryName] then
		for _, skill in ipairs(SKILLS[categoryName].skills) do
			totalBonus = totalBonus + self:getSkillBonus(userId, categoryName, skill.id)
		end
	end

	return totalBonus
end

-- Get all skill bonuses for a player
function SkillTree:getAllBonuses(userId)
	local bonuses = {}

	for categoryName, _ in pairs(SKILLS) do
		bonuses[categoryName] = self:getCategoryBonus(userId, categoryName)
	end

	return bonuses
end

-- Get detailed skill tree for UI display
function SkillTree:getSkillTreeInfo(userId)
	local skills = self:getSkills(userId)
	local treeInfo = {}

	for categoryName, categoryData in pairs(SKILLS) do
		treeInfo[categoryName] = {
			name = categoryData.name,
			skills = {},
		}

		for _, skill in ipairs(categoryData.skills) do
			local playerLevel = skills[categoryName][skill.id] or 0
			table.insert(treeInfo[categoryName].skills, {
				id = skill.id,
				name = skill.name,
				description = skill.description,
				level = playerLevel,
				maxLevel = skill.maxLevel,
				baseBonus = skill.baseBonus,
				currentBonus = skill.baseBonus * playerLevel,
				canUpgrade = playerLevel < skill.maxLevel,
			})
		end
	end

	return treeInfo
end

-- Get skill info by name
function SkillTree:getSkillInfo(categoryName, skillId)
	return getSkill(categoryName, skillId)
end

-- Get all categories
function SkillTree:getCategories()
	local categories = {}
	for categoryName, categoryData in pairs(SKILLS) do
		table.insert(categories, {
			name = categoryName,
			displayName = categoryData.name,
			skillCount = #categoryData.skills,
		})
	end
	return categories
end

-- Reset all skills (admin only)
function SkillTree:resetSkills(userId)
	playerSkills[userId] = nil
	self:initializePlayer(userId)

	return {
		success = true,
		message = "All skills reset",
	}
end

-- Clean up on player leave
function SkillTree:removePlayer(userId)
	playerSkills[userId] = nil
end

return SkillTree
