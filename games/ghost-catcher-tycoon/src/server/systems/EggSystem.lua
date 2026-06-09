--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local EggSystem = {}
EggSystem.__index = EggSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local EggData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("EggData"))
local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))

function EggSystem:new()
	local self = setmetatable({}, EggSystem)
	self.currencySystem = nil
	self.ghostSystem = nil
	return self
end

function EggSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function EggSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function EggSystem:initializePlayer(player)
	-- EggSystem doesn't need per-player initialization (stateless)
end

function EggSystem:removePlayer(userId)
	-- EggSystem doesn't need per-player cleanup (stateless)
end

function EggSystem:getEggPrice(eggType)
	local eggConfig = EggData[eggType]
	if not eggConfig then
		return nil, "Egg type not found"
	end
	return eggConfig.Price, eggConfig.Currency
end

function EggSystem:canPurchaseEgg(player, eggType)
	if not self.currencySystem then
		return false, "Currency system not initialized"
	end

	local eggConfig = EggData[eggType]
	if not eggConfig then
		return false, "Egg type not found"
	end

	local price = eggConfig.Price
	local currency = eggConfig.Currency

	if currency == "EctoEnergy" then
		local playerEnergy = self.currencySystem:getEnergy(player)
		return playerEnergy >= price, playerEnergy
	elseif currency == "Robux" then
		-- Robux check would happen via MarketplaceService
		-- For now, return true (actual check in monetization)
		return true, nil
	end

	return false, "Unknown currency"
end

function EggSystem:selectRarityFromEgg(eggType)
	local eggConfig = EggData[eggType]
	if not eggConfig then return nil end

	local chances = eggConfig.Chances
	local roll = math.random(1, 100)
	local accumulated = 0

	for rarity, chance in pairs(chances) do
		accumulated = accumulated + chance
		if roll <= accumulated then
			return rarity
		end
	end

	local rarities = {}
	for rarity, _ in pairs(chances) do
		table.insert(rarities, rarity)
	end

	return rarities[#rarities]
end

function EggSystem:selectGhostFromPool(eggType, rarity)
	local eggConfig = EggData[eggType]
	if not eggConfig then return nil end

	local pool = eggConfig.Pool[rarity]
	if not pool or #pool == 0 then
		return nil
	end

	return pool[math.random(1, #pool)]
end

function EggSystem:hatchEgg(player, eggType)
	if not player then
		return false, nil, "Player not found"
	end

	if not self.currencySystem or not self.ghostSystem then
		return false, nil, "Systems not initialized"
	end

	local eggConfig = EggData[eggType]
	if not eggConfig then
		return false, nil, "Egg type not found"
	end

	local price = eggConfig.Price
	local currency = eggConfig.Currency

	-- Charge player
	if currency == "EctoEnergy" then
		local playerEnergy = self.currencySystem:getEnergy(player)
		if playerEnergy < price then
			return false, nil, "Not enough Ecto-Energy. Need: " .. price .. ", Have: " .. playerEnergy
		end
		self.currencySystem:removeEnergy(player, price, "EggHatch")
	elseif currency == "Robux" then
		-- Robux handling would be in MonetizationSystem
		-- For now, assume valid purchase
	end

	-- Select rarity
	local rarity = self:selectRarityFromEgg(eggType)
	if not rarity then
		return false, nil, "Failed to select rarity"
	end

	-- Select ghost from pool
	local ghostName = self:selectGhostFromPool(eggType, rarity)
	if not ghostName then
		return false, nil, "Failed to select ghost"
	end

	-- Create ghost object
	local ghostId = tostring(os.time()) .. "_" .. math.random(1000, 9999)
	local personality = GhostData.Personalities[math.random(1, #GhostData.Personalities)]
	local rarityStats = GhostData.RarityStats[rarity]

	local ghost = {
		id = ghostId,
		name = ghostName,
		rarity = rarity,
		personality = personality,
		level = 1,
		stats = {
			catchSpeed = math.random(rarityStats.CatchSpeed[1] * 10, rarityStats.CatchSpeed[2] * 10) / 10,
			energyProduction = Config.Rarities[rarity].BaseEnergyOutput,
			trainingEfficiency = 1.0,
		},
		hatched = os.time(),
	}

	-- Add to player's collection
	if self.ghostSystem:addGhost(player, ghost) then
		return true, ghost, "Egg hatched! You got " .. ghostName .. " (" .. rarity .. ")"
	else
		-- Refund if no space
		if currency == "EctoEnergy" then
			self.currencySystem:addEnergy(player, price, "EggHatchRefund")
		end
		return false, nil, "Ghost storage full"
	end
end

return EggSystem
-- Built with assistance from Claude Code by Anthropic.

