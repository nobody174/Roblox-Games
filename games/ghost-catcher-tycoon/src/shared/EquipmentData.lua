--
-- Equipment Data — Ghost Catcher Tycoon
-- Defines all catching equipment tiers, stats, and progression
--

local EquipmentData = {}

-- Equipment Tier 1: Starter
EquipmentData.EQUIPMENT = {
	-- ============================================================================
	-- TIER 1: STARTER (Free - Level 5)
	-- ============================================================================

	BasicNet = {
		name = "Basic Net",
		tier = 1,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 0,
		unlockedAtLevel = 0,
		chargeTime = 3,
		energyCost = 10,
		description = "A simple butterfly net. Works on weak ghosts.",
		catchRates = {
			Common = 100,
			Uncommon = 80,
			Rare = 40,
			Epic = 10,
			Legendary = 0,
			Corrupted = 0,
		},
	},

	ReinforcedNet = {
		name = "Reinforced Net",
		tier = 1,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 500,
		unlockedAtLevel = 5,
		chargeTime = 2.5,
		energyCost = 12,
		description = "Stronger weave catches trickier ghosts.",
		catchRates = {
			Common = 100,
			Uncommon = 95,
			Rare = 70,
			Epic = 30,
			Legendary = 5,
			Corrupted = 0,
		},
	},

	-- ============================================================================
	-- TIER 2: INTERMEDIATE (Level 10 - 15)
	-- ============================================================================

	GhostTrap = {
		name = "Ghost Trap",
		tier = 2,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 2000,
		unlockedAtLevel = 10,
		chargeTime = 4,
		energyCost = 20,
		description = "Boxes with magnetic closure. Harder for ghosts to escape.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 85,
			Epic = 60,
			Legendary = 20,
			Corrupted = 5,
		},
	},

	SpectralCage = {
		name = "Spectral Cage",
		tier = 2,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 3500,
		unlockedAtLevel = 15,
		chargeTime = 5,
		energyCost = 25,
		description = "Ethereal containment field. Ghosts struggle against it.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 95,
			Epic = 80,
			Legendary = 40,
			Corrupted = 15,
		},
	},

	-- ============================================================================
	-- TIER 3: ADVANCED (Level 20 - 30)
	-- ============================================================================

	EctoplasmBlaster = {
		name = "Ectoplasm Blaster",
		tier = 3,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 8000,
		unlockedAtLevel = 20,
		chargeTime = 3,
		energyCost = 30,
		description = "Blasts with ectoplasm to stun and contain ghosts.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 100,
			Epic = 90,
			Legendary = 65,
			Corrupted = 35,
		},
	},

	QuantumDevice = {
		name = "Quantum Containment Device",
		tier = 3,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 15000,
		unlockedAtLevel = 30,
		chargeTime = 6,
		energyCost = 40,
		description = "Uses quantum tech to lock ghosts in an inescapable state.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 100,
			Epic = 100,
			Legendary = 85,
			Corrupted = 60,
		},
	},

	-- ============================================================================
	-- TIER 4: EXPERT (Level 40 - 50)
	-- ============================================================================

	ProtonPack = {
		name = "Proton Pack",
		tier = 4,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 25000,
		unlockedAtLevel = 40,
		chargeTime = 5,
		energyCost = 50,
		description = "Industrial-grade proton streams. Nearly unstoppable.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 100,
			Epic = 100,
			Legendary = 95,
			Corrupted = 80,
		},
	},

	DimensionalSiphon = {
		name = "Dimensional Siphon",
		tier = 4,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 40000,
		unlockedAtLevel = 50,
		chargeTime = 7,
		energyCost = 60,
		description = "Tears open a dimensional rift to pull ghosts through.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 100,
			Epic = 100,
			Legendary = 100,
			Corrupted = 95,
		},
	},

	-- ============================================================================
	-- TIER 5: LEGENDARY (Level 75)
	-- ============================================================================

	UltimateDevice = {
		name = "Ghost Buster's Ultimate Device",
		tier = 5,
		icon = "rbxasset://textures/Cursors/MouseArrow.png",
		cost = 100000,
		unlockedAtLevel = 75,
		chargeTime = 4,
		energyCost = 80,
		description = "The ultimate ghost catching device. Almost never fails.",
		catchRates = {
			Common = 100,
			Uncommon = 100,
			Rare = 100,
			Epic = 100,
			Legendary = 100,
			Corrupted = 99,
		},
	},
}

-- Equipment tier colors for UI
EquipmentData.TIER_COLORS = {
	[1] = Color3.fromRGB(128, 128, 128), -- Gray
	[2] = Color3.fromRGB(0, 150, 255), -- Blue
	[3] = Color3.fromRGB(255, 200, 0), -- Gold
	[4] = Color3.fromRGB(255, 100, 0), -- Orange
	[5] = Color3.fromRGB(255, 50, 50), -- Red
}

-- Get equipment by name
function EquipmentData:getEquipment(equipmentName)
	return self.EQUIPMENT[equipmentName]
end

-- Get catch rate for equipment against ghost rarity
function EquipmentData:getCatchRate(equipmentName, ghostRarity)
	local equipment = self:getEquipment(equipmentName)
	if not equipment then
		return 0
	end
	return equipment.catchRates[ghostRarity] or 0
end

-- Get all equipment
function EquipmentData:getAllEquipment()
	return self.EQUIPMENT
end

-- Get equipment by tier
function EquipmentData:getEquipmentByTier(tier)
	local tierEquipment = {}
	for name, data in pairs(self.EQUIPMENT) do
		if data.tier == tier then
			table.insert(tierEquipment, {name = name, data = data})
		end
	end
	return tierEquipment
end

-- Get equipment unlock cost
function EquipmentData:getUnlockCost(equipmentName)
	local equipment = self:getEquipment(equipmentName)
	return equipment and equipment.cost or 0
end

-- Get equipment unlock level
function EquipmentData:getUnlockLevel(equipmentName)
	local equipment = self:getEquipment(equipmentName)
	return equipment and equipment.unlockedAtLevel or 0
end

-- Check if player can afford equipment
function EquipmentData:canAfford(equipmentName, playerCoins)
	local cost = self:getUnlockCost(equipmentName)
	return playerCoins >= cost
end

-- Check if player can unlock equipment
function EquipmentData:canUnlock(equipmentName, playerLevel)
	local requiredLevel = self:getUnlockLevel(equipmentName)
	return playerLevel >= requiredLevel
end

return EquipmentData
