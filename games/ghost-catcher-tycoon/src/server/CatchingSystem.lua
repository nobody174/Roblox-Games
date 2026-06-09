--
-- Catching System — Ghost Catcher Tycoon
-- Handles catch attempts, success rates, and rewards
--

local EquipmentData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("EquipmentData"))
local PlayerInventory = require(script.Parent:WaitForChild("PlayerInventory"))

local CatchingSystem = {}

-- Reward multipliers by ghost rarity
local RARITY_XP_MULTIPLIER = {
	Common = 25,
	Uncommon = 50,
	Rare = 100,
	Epic = 200,
	Legendary = 500,
	Corrupted = 1000,
}

local RARITY_COIN_MULTIPLIER = {
	Common = 50,
	Uncommon = 100,
	Rare = 250,
	Epic = 500,
	Legendary = 1500,
	Corrupted = 5000,
}

-- Zone multiplier for rewards (harder zones = more rewards)
local ZONE_MULTIPLIER = {
	["Starting Area"] = 1.0,
	["Whisper Woods"] = 1.0,
	["Foggy Fields"] = 1.2,
	["Gloomy Graveyard"] = 1.5,
	["Electro Alley"] = 1.5,
	["Frostbite Caverns"] = 2.0,
	["Sunken Spirit Reef"] = 1.8,
	["Clocktower District"] = 1.7,
	["Astral Observatory"] = 1.9,
	["Phantom Fortress"] = 2.2,
	["The Rift"] = 2.5,
	["Eternity Nexus"] = 2.5,
}

-- Attempt to catch a ghost
function CatchingSystem:attemptCatch(player, ghost, currentZone)
	if not player or not ghost then
		return {
			success = false,
			reason = "INVALID_TARGET",
		}
	end

	local userId = player.UserId
	local ghostRarity = ghost:GetAttribute("Rarity") or "Common"
	local equippedEquipment = PlayerInventory:getEquipped(userId)
	local equipment = EquipmentData:getEquipment(equippedEquipment)

	-- Check energy
	if not PlayerInventory:canAttemptCatch(userId, equipment.energyCost) then
		return {
			success = false,
			reason = "NOT_ENOUGH_ENERGY",
			energyNeeded = equipment.energyCost,
			currentEnergy = PlayerInventory:getEnergy(userId),
		}
	end

	-- Deduct energy immediately
	PlayerInventory:removeEnergy(userId, equipment.energyCost)

	-- Get catch rate for this equipment and ghost rarity
	local catchRate = EquipmentData:getCatchRate(equippedEquipment, ghostRarity)

	-- Roll for success (0-100)
	local roll = math.random(0, 100)
	local success = roll <= catchRate

	if success then
		-- Calculate rewards
		local baseXP = RARITY_XP_MULTIPLIER[ghostRarity] or 25
		local baseCoins = RARITY_COIN_MULTIPLIER[ghostRarity] or 50
		local zoneMultiplier = ZONE_MULTIPLIER[currentZone] or 1.0

		local totalXP = math.floor(baseXP * zoneMultiplier)
		local totalCoins = math.floor(baseCoins * zoneMultiplier)

		-- Award rewards
		PlayerInventory:addCoins(userId, totalCoins)

		-- Destroy ghost
		ghost:Destroy()

		return {
			success = true,
			ghostRarity = ghostRarity,
			xpGained = totalXP,
			coinsGained = totalCoins,
			equipment = equippedEquipment,
			zone = currentZone,
		}
	else
		-- Ghost escaped
		return {
			success = false,
			reason = "GHOST_ESCAPED",
			ghostRarity = ghostRarity,
			catchRate = catchRate,
			roll = roll,
			equipment = equippedEquipment,
		}
	end
end

-- Purchase equipment
function CatchingSystem:purchaseEquipment(userId, equipmentName)
	local equipment = EquipmentData:getEquipment(equipmentName)

	if not equipment then
		return {
			success = false,
			reason = "EQUIPMENT_NOT_FOUND",
		}
	end

	-- Check if already owns
	if PlayerInventory:ownsEquipment(userId, equipmentName) then
		return {
			success = false,
			reason = "ALREADY_OWNS",
			equipment = equipmentName,
		}
	end

	-- Check level requirement
	local playerLevel = PlayerInventory:getLevel(userId)
	if playerLevel < equipment.unlockedAtLevel then
		return {
			success = false,
			reason = "LEVEL_REQUIRED",
			requiredLevel = equipment.unlockedAtLevel,
			currentLevel = playerLevel,
		}
	end

	-- Check cost
	local playerCoins = PlayerInventory:getCoins(userId)
	if playerCoins < equipment.cost then
		return {
			success = false,
			reason = "NOT_ENOUGH_COINS",
			costRequired = equipment.cost,
			coinsAvailable = playerCoins,
		}
	end

	-- Purchase
	PlayerInventory:removeCoins(userId, equipment.cost)
	PlayerInventory:addEquipment(userId, equipmentName)

	return {
		success = true,
		equipment = equipmentName,
		coinsSpent = equipment.cost,
		coinsRemaining = PlayerInventory:getCoins(userId),
	}
end

-- Equip equipment
function CatchingSystem:equipEquipment(userId, equipmentName)
	if not PlayerInventory:ownsEquipment(userId, equipmentName) then
		return {
			success = false,
			reason = "DOES_NOT_OWN",
			equipment = equipmentName,
		}
	end

	local success = PlayerInventory:setEquipped(userId, equipmentName)
	return {
		success = success,
		equipped = equipmentName,
	}
end

-- Get equipment info for UI
function CatchingSystem:getEquipmentInfo(userId, ghostRarity)
	local equipped = PlayerInventory:getEquipped(userId)
	local equipment = EquipmentData:getEquipment(equipped)
	local catchRate = EquipmentData:getCatchRate(equipped, ghostRarity)
	local energy = PlayerInventory:getEnergy(userId)

	return {
		name = equipment.name,
		tier = equipment.tier,
		chargeTime = equipment.chargeTime,
		energyCost = equipment.energyCost,
		catchRate = catchRate,
		currentEnergy = energy,
		maxEnergy = PlayerInventory:getMaxEnergy(userId),
		description = equipment.description,
	}
end

-- Get all equipment stats for a player
function CatchingSystem:getPlayerEquipmentStats(userId)
	local owned = PlayerInventory:getOwnedEquipment(userId)
	local equipped = PlayerInventory:getEquipped(userId)
	local stats = {}

	for _, equipmentName in ipairs(owned) do
		local equipment = EquipmentData:getEquipment(equipmentName)
		stats[equipmentName] = {
			name = equipment.name,
			tier = equipment.tier,
			cost = equipment.cost,
			level = equipment.unlockedAtLevel,
			chargeTime = equipment.chargeTime,
			energyCost = equipment.energyCost,
			isEquipped = (equipmentName == equipped),
			description = equipment.description,
		}
	end

	return stats
end

return CatchingSystem
