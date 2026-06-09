--
-- Ghost Catcher Tycoon - Habitat System
-- Manages player ghost collection, storage, passive income, and customization
-- Author: Claude Code
-- Date: 2026-06-06
--

local HabitatSystem = {}
HabitatSystem.__index = HabitatSystem

-- Configuration
local HABITAT_CONFIG = {
	DefaultMaxSlots = 5,
	SlotsPerUpgrade = 5,
	MaxUpgrades = 10,
	IncomeTickRate = 1, -- Update income every N seconds
}

-- Rarity-based energy output (base values)
local RARITY_ENERGY_OUTPUT = {
	Common = 0.5,
	Uncommon = 1.0,
	Rare = 2.5,
	Epic = 5.0,
	Legendary = 10.0,
	Corrupted = 25.0,
}

function HabitatSystem:new()
	local self = setmetatable({}, HabitatSystem)
	self.playerHabitats = {} -- playerUserId -> habitat data
	self.remotes = nil
	return self
end

function HabitatSystem:initialize(remotes)
	self.remotes = remotes
	print("[HabitatSystem] Initialized")

	-- Start income tick loop
	task.spawn(function()
		self:incomeTick()
	end)
end

function HabitatSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.playerHabitats[userId] then
		self.playerHabitats[userId] = {
			maxSlots = HABITAT_CONFIG.DefaultMaxSlots,
			ghosts = {}, -- { ghostKey: ghostData }
		}
		print("[HabitatSystem] Initialized habitat for " .. player.Name)
	end
end

function HabitatSystem:addGhostToHabitat(player, ghostData)
	local userId = player.UserId
	local habitat = self.playerHabitats[userId]

	if not habitat then
		return false, "Habitat not initialized"
	end

	-- Check if habitat is full
	local ghostCount = self:getGhostCount(userId)
	if ghostCount >= habitat.maxSlots then
		return false, "Habitat is full!"
	end

	-- Generate unique key
	local ghostKey = ghostData.name .. "_" .. math.random(1000, 9999)

	-- Calculate energy output
	local energyOutput = self:calculateEnergyOutput(ghostData)

	-- Add ghost to habitat
	habitat.ghosts[ghostKey] = {
		name = ghostData.name,
		rarity = ghostData.rarity,
		level = ghostData.level or 1,
		energyOutput = energyOutput,
		caughtTime = os.time(),
		cosmetics = {
			skin = "default",
		},
	}

	print("[HabitatSystem] Added " .. ghostData.name .. " to " .. player.Name .. "'s habitat")
	return true, ghostKey
end

function HabitatSystem:removeGhostFromHabitat(player, ghostKey)
	local userId = player.UserId
	local habitat = self.playerHabitats[userId]

	if not habitat or not habitat.ghosts[ghostKey] then
		return false, "Ghost not found"
	end

	local ghost = habitat.ghosts[ghostKey]
	habitat.ghosts[ghostKey] = nil

	-- Calculate refund (based on rarity and level)
	local refund = self:calculateReleaseRefund(ghost)

	print("[HabitatSystem] Removed " .. ghost.name .. " from " .. player.Name .. "'s habitat (refund: " .. refund .. ")")
	return true, refund
end

function HabitatSystem:getHabitatData(userId)
	if not self.playerHabitats[userId] then
		return nil
	end

	return self.playerHabitats[userId]
end

function HabitatSystem:getGhostCount(userId)
	local habitat = self.playerHabitats[userId]
	if not habitat then
		return 0
	end

	local count = 0
	for _ in pairs(habitat.ghosts) do
		count = count + 1
	end
	return count
end

function HabitatSystem:calculateEnergyOutput(ghostData)
	local baseOutput = RARITY_ENERGY_OUTPUT[ghostData.rarity] or 0.5
	local level = ghostData.level or 1

	-- Level multiplier: Level 1 = 1.0x, Level 5 = 1.4x, Level 10 = 1.9x
	local levelMultiplier = 1.0 + (level - 1) * 0.1

	return baseOutput * levelMultiplier
end

function HabitatSystem:calculateTotalIncome(userId, roomBonus)
	local habitat = self.playerHabitats[userId]
	if not habitat then
		return 0
	end

	local totalIncome = 0
	for _, ghost in pairs(habitat.ghosts) do
		totalIncome = totalIncome + (ghost.energyOutput or 0)
	end

	-- Apply room bonus (Energy Reactor upgrade)
	if roomBonus and roomBonus > 1 then
		totalIncome = totalIncome * roomBonus
	end

	return totalIncome
end

function HabitatSystem:calculateReleaseRefund(ghost)
	local rarityValues = {
		Common = 5,
		Uncommon = 15,
		Rare = 50,
		Epic = 150,
		Legendary = 500,
		Corrupted = 1500,
	}

	local baseRefund = rarityValues[ghost.rarity] or 5
	local levelBonus = (ghost.level - 1) * 10

	return baseRefund + levelBonus
end

function HabitatSystem:upgradeHabitatStorage(player, currentLevel)
	local userId = player.UserId
	local habitat = self.playerHabitats[userId]

	if not habitat then
		return false, "Habitat not initialized"
	end

	-- Check max level
	if currentLevel >= HABITAT_CONFIG.MaxUpgrades then
		return false, "Habitat storage is at max level"
	end

	-- Next level storage
	local newSlots = HABITAT_CONFIG.DefaultMaxSlots + (currentLevel * HABITAT_CONFIG.SlotsPerUpgrade)
	habitat.maxSlots = newSlots

	print("[HabitatSystem] " .. player.Name .. " upgraded habitat to " .. newSlots .. " slots")
	return true, newSlots
end

function HabitatSystem:applyCosmetic(player, ghostKey, skinName)
	local userId = player.UserId
	local habitat = self.playerHabitats[userId]

	if not habitat or not habitat.ghosts[ghostKey] then
		return false, "Ghost not found"
	end

	local ghost = habitat.ghosts[ghostKey]
	ghost.cosmetics.skin = skinName

	print("[HabitatSystem] Applied skin '" .. skinName .. "' to " .. ghost.name)
	return true
end

function HabitatSystem:incomeTick()
	local Players = game:GetService("Players")

	while true do
		task.wait(HABITAT_CONFIG.IncomeTickRate)

		for _, player in pairs(Players:GetPlayers()) do
			local userId = player.UserId
			local totalIncome = self:calculateTotalIncome(userId)

			if totalIncome > 0 then
				-- This will be handled by MainServer update loop
				-- Just make sure data is ready when MainServer queries it
			end
		end
	end
end

function HabitatSystem:bringSummaryToString(userId)
	local habitat = self.playerHabitats[userId]
	if not habitat then
		return "No habitat"
	end

	local ghostCount = self:getGhostCount(userId)
	local totalIncome = self:calculateTotalIncome(userId)

	return string.format(
		"Habitat: %d/%d ghosts | Income: %.1f/sec",
		ghostCount,
		habitat.maxSlots,
		totalIncome
	)
end

return HabitatSystem
-- Built with assistance from Claude Code by Anthropic.
