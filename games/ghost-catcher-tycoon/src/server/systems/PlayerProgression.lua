--
-- Player Progression Manager — Ghost Catcher Tycoon
-- Unified interface combining Level System + Skill Tree + Equipment + Zones
-- Handles auto-unlocking equipment and zones based on player level
--

local LevelSystem = require(script.Parent:WaitForChild("LevelSystem"))
local SkillTree = require(script.Parent:WaitForChild("SkillTree"))
local EquipmentData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("EquipmentData"))
local PlayerInventory = require(game:GetService("ServerScriptService"):WaitForChild("PlayerInventory"))

local PlayerProgression = {}

-- Auto-unlock configuration
local ZONE_UNLOCK_LEVELS = {
	["Whisper Woods"] = 1,
	["Foggy Fields"] = 5,
	["Gloomy Graveyard"] = 10,
	["Electro Alley"] = 15,
	["Frostbite Caverns"] = 20,
	["Sunken Spirit Reef"] = 30,
	["Clocktower District"] = 40,
	["Astral Observatory"] = 50,
	["Phantom Fortress"] = 75,
	["The Rift"] = 85,
	["Eternity Nexus"] = 100,
}

-- Player progression data: [userId] = {unlockedEquipment, unlockedZones}
local playerProgression = {}

-- Initialize player progression
function PlayerProgression:initializePlayer(userId)
	if not playerProgression[userId] then
		playerProgression[userId] = {
			unlockedEquipment = {},
			unlockedZones = {},
		}

		-- Initialize systems
		LevelSystem:initializePlayer(userId)
		SkillTree:initializePlayer(userId)
		PlayerInventory:initializePlayer(userId)

		-- Set up level up callback to auto-unlock equipment and zones
		LevelSystem:onLevelUp(userId, function(newLevel)
			self:_checkAutoUnlocks(userId, newLevel)
		end)

		-- Initial unlock check
		self:_checkAutoUnlocks(userId, 1)
	end

	return playerProgression[userId]
end

-- Check and auto-unlock equipment and zones when player levels up
function PlayerProgression:_checkAutoUnlocks(userId, newLevel)
	-- Auto-unlock equipment
	local equipment = EquipmentData:getAllEquipment()
	for equipmentName, equipmentData in pairs(equipment) do
		if newLevel >= equipmentData.unlockedAtLevel and not PlayerInventory:ownsEquipment(userId, equipmentName) then
			PlayerInventory:addEquipment(userId, equipmentName)
		end
	end

	-- Auto-unlock zones
	local prog = playerProgression[userId]
	if prog then
		for zoneName, requiredLevel in pairs(ZONE_UNLOCK_LEVELS) do
			if newLevel >= requiredLevel then
				prog.unlockedZones[zoneName] = true
			end
		end
	end
end

-- Get complete player stats (unified interface)
function PlayerProgression:getPlayerStats(userId)
	self:initializePlayer(userId)

	local levelInfo = LevelSystem:getLevelInfo(userId)
	local skillTree = SkillTree:getSkillTreeInfo(userId)
	local inventory = PlayerInventory:getInventory(userId)
	local prog = playerProgression[userId]

	-- Calculate total bonuses from all skills
	local allBonuses = SkillTree:getAllBonuses(userId)

	-- Calculate catch bonus (from Catching skills)
	local catchBonus = 0
	for categoryName, _ in pairs(skillTree) do
		if categoryName == "Catching" then
			for _, skill in ipairs(skillTree[categoryName].skills) do
				catchBonus = catchBonus + skill.currentBonus
			end
		end
	end

	-- Calculate energy bonus (from Energy skills)
	local energyBonus = 0
	for categoryName, _ in pairs(skillTree) do
		if categoryName == "Energy" then
			for _, skill in ipairs(skillTree[categoryName].skills) do
				energyBonus = energyBonus + skill.currentBonus
			end
		end
	end

	-- Calculate coin bonus (from Coins skills)
	local coinBonus = 0
	for categoryName, _ in pairs(skillTree) do
		if categoryName == "Coins" then
			for _, skill in ipairs(skillTree[categoryName].skills) do
				coinBonus = coinBonus + skill.currentBonus
			end
		end
	end

	-- Calculate XP bonus (from Misc skills)
	local xpBonus = 0
	for categoryName, _ in pairs(skillTree) do
		if categoryName == "Miscellaneous" then
			for _, skill in ipairs(skillTree[categoryName].skills) do
				xpBonus = xpBonus + skill.currentBonus
			end
		end
	end

	return {
		level = levelInfo.level,
		maxLevel = levelInfo.maxLevel,
		isMaxLevel = levelInfo.isMaxLevel,
		currentXP = levelInfo.currentXP,
		nextLevelXP = levelInfo.nextLevelXP,
		progressPercent = levelInfo.progressPercent,
		totalXP = levelInfo.totalXP,
		skillPoints = levelInfo.skillPoints,
		coins = inventory.coins,
		energy = inventory.energy,
		maxEnergy = inventory.maxEnergy,
		equippedEquipment = inventory.equipped,
		ownedEquipment = PlayerInventory:getOwnedEquipment(userId),
		unlockedZones = prog.unlockedZones,
		bonuses = {
			catch = catchBonus,
			energy = energyBonus,
			coins = coinBonus,
			xp = xpBonus,
			allBonuses = allBonuses,
		},
		skillTree = skillTree,
	}
end

-- Add XP to player (with multipliers from skills)
function PlayerProgression:addXP(userId, amount)
	self:initializePlayer(userId)

	-- Apply XP bonus from skills
	local xpBonus = SkillTree:getSkillBonus(userId, "Miscellaneous", "misc_xp_boost")
	local multipliedAmount = math.floor(amount * (1 + xpBonus))

	return LevelSystem:addXP(userId, multipliedAmount)
end

-- Add coins to player (with multipliers from skills)
function PlayerProgression:addCoins(userId, amount)
	self:initializePlayer(userId)

	-- Apply coin bonus from skills
	local coinBonus = SkillTree:getSkillBonus(userId, "Coins", "coins_earn")
	local multipliedAmount = math.floor(amount * (1 + coinBonus))

	PlayerInventory:addCoins(userId, multipliedAmount)

	return {
		success = true,
		baseAmount = amount,
		bonus = multipliedAmount - amount,
		totalCoins = PlayerInventory:getCoins(userId),
	}
end

-- Level up player manually (usually automatic via addXP)
function PlayerProgression:levelUp(userId)
	self:initializePlayer(userId)
	return LevelSystem:levelUp(userId)
end

-- Allocate skill point
function PlayerProgression:allocateSkill(userId, categoryName, skillId)
	self:initializePlayer(userId)

	-- Check if player has skill points
	local skillPoints = LevelSystem:getSkillPoints(userId)
	if skillPoints <= 0 then
		return {
			success = false,
			reason = "NO_SKILL_POINTS",
		}
	end

	-- Allocate skill
	local skillResult = SkillTree:allocateSkill(userId, categoryName, skillId)
	if not skillResult.success then
		return skillResult
	end

	-- Use skill point
	LevelSystem:useSkillPoint(userId)

	return {
		success = true,
		skillId = skillId,
		skillName = skillResult.skillName,
		newLevel = skillResult.newLevel,
		skillPointsRemaining = LevelSystem:getSkillPoints(userId),
	}
end

-- Remove skill point (refund)
function PlayerProgression:removeSkill(userId, categoryName, skillId)
	self:initializePlayer(userId)

	-- Remove skill
	local skillResult = SkillTree:removeSkill(userId, categoryName, skillId)
	if not skillResult.success then
		return skillResult
	end

	-- Refund skill point
	LevelSystem:refundSkillPoint(userId)

	return {
		success = true,
		skillId = skillId,
		skillName = skillResult.skillName,
		newLevel = skillResult.newLevel,
		skillPointsRemaining = LevelSystem:getSkillPoints(userId),
	}
end

-- Get all unlocked zones
function PlayerProgression:getUnlockedZones(userId)
	self:initializePlayer(userId)
	local prog = playerProgression[userId]
	return prog.unlockedZones
end

-- Check if zone is unlocked
function PlayerProgression:isZoneUnlocked(userId, zoneName)
	self:initializePlayer(userId)
	local prog = playerProgression[userId]
	return prog.unlockedZones[zoneName] or false
end

-- Get zones available at player level
function PlayerProgression:getAvailableZones(userId)
	self:initializePlayer(userId)
	local level = LevelSystem:getLevel(userId)
	local available = {}

	for zoneName, requiredLevel in pairs(ZONE_UNLOCK_LEVELS) do
		if level >= requiredLevel then
			table.insert(available, {
				name = zoneName,
				unlockedAtLevel = requiredLevel,
				isUnlocked = true,
			})
		else
			table.insert(available, {
				name = zoneName,
				unlockedAtLevel = requiredLevel,
				isUnlocked = false,
				levelsNeeded = requiredLevel - level,
			})
		end
	end

	return available
end

-- Get available equipment at player level
function PlayerProgression:getAvailableEquipment(userId)
	self:initializePlayer(userId)
	local level = LevelSystem:getLevel(userId)
	local equipment = EquipmentData:getAllEquipment()
	local available = {}

	for equipmentName, equipmentData in pairs(equipment) do
		local isOwned = PlayerInventory:ownsEquipment(userId, equipmentName)
		local isAvailable = level >= equipmentData.unlockedAtLevel

		table.insert(available, {
			name = equipmentName,
			tier = equipmentData.tier,
			cost = equipmentData.cost,
			unlockedAtLevel = equipmentData.unlockedAtLevel,
			isOwned = isOwned,
			isAvailable = isAvailable,
			levelsNeeded = isAvailable and 0 or (equipmentData.unlockedAtLevel - level),
		})
	end

	return available
end

-- Get skill bonus multiplier for catching (affects catch rate)
function PlayerProgression:getCatchRateMultiplier(userId)
	self:initializePlayer(userId)

	local accuracy = SkillTree:getSkillBonus(userId, "Catching", "catch_accuracy")
	local critical = SkillTree:getSkillBonus(userId, "Catching", "catch_critical")

	return 1.0 + accuracy + critical
end

-- Get energy cost multiplier
function PlayerProgression:getEnergyCostMultiplier(userId)
	self:initializePlayer(userId)

	local efficiency = SkillTree:getSkillBonus(userId, "Energy", "energy_efficiency")

	return math.max(1.0 - efficiency, 0.2) -- Min 20% of original cost
end

-- Get movement speed multiplier
function PlayerProgression:getMovementSpeedMultiplier(userId)
	self:initializePlayer(userId)

	local speed = SkillTree:getSkillBonus(userId, "Movement", "move_speed")

	return 1.0 + speed
end

-- Check if player has unlocked a specific ability
function PlayerProgression:hasAbility(userId, abilityId)
	self:initializePlayer(userId)

	local skillLevel = 0

	if abilityId == "dash" then
		skillLevel = SkillTree:getSkillLevel(userId, "Movement", "move_dash")
	elseif abilityId == "teleport" then
		skillLevel = SkillTree:getSkillLevel(userId, "Movement", "move_teleport")
	end

	return skillLevel > 0
end

-- Clean up on player leave
function PlayerProgression:removePlayer(userId)
	LevelSystem:removePlayer(userId)
	SkillTree:removePlayer(userId)
	PlayerInventory:removePlayer(userId)
	playerProgression[userId] = nil
end

return PlayerProgression
