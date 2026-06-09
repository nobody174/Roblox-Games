--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local GachaSystem = {}
GachaSystem.__index = GachaSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function GachaSystem:new()
	local self = setmetatable({}, GachaSystem)
	self.gachaData = {}
	self.ghostSystem = nil
	self.currencySystem = nil
	self.dataManager = nil
	return self
end

function GachaSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function GachaSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function GachaSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function GachaSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.gachaData then
		self.gachaData = {}
	end

	local gachaData = {
		StandardPity = 0,
		PremiumPity = 0,
	}

	if self.dataManager then
		local data = self.dataManager:getPlayerData(player)
		if data and data.Gacha then
			gachaData = data.Gacha
		end
	end

	self.gachaData[userId] = gachaData
end

function GachaSystem:removePlayer(userId)
	self.gachaData[userId] = nil
end

function GachaSystem:_selectRarity(weights)
	local roll = math.random()
	local cumulative = 0

	for rarity, weight in pairs(weights) do
		cumulative = cumulative + weight
		if roll <= cumulative then
			return rarity
		end
	end

	-- Fallback to last entry
	return "Common"
end

function GachaSystem:_getGhostList()
	if not self.ghostSystem then
		return {}
	end
	return self.ghostSystem:getAvailableGhosts() or {}
end

function GachaSystem:_selectRandomGhost(rarity)
	local ghosts = self._getGhostList()
	local matching = {}

	for _, ghost in ipairs(ghosts) do
		if ghost.Rarity == rarity then
			table.insert(matching, ghost)
		end
	end

	if #matching == 0 then
		-- Fallback: return any ghost
		return ghosts[1] or { Id = "common_ghost", Rarity = "Common" }
	end

	return matching[math.random(1, #matching)]
end

function GachaSystem:pullStandard(player, count)
	local userId = player.UserId
	count = count or 1

	if count ~= 1 and count ~= 10 then
		return false, "Invalid pull count"
	end

	local cost = count == 1 and Config.Gacha.StandardPullCost or Config.Gacha.TenPullCostStandard

	if not self.currencySystem:canAfford(player, cost) then
		return false, "Not enough energy"
	end

	self.currencySystem:removeEnergy(player, cost)

	local results = {}
	for i = 1, count do
		local rarity = self:_selectRarity(Config.Gacha.StandardWeights)

		-- Pity system: guarantee Rare at 10 pulls
		if count == 10 and i == 10 then
			if self.gachaData[userId].StandardPity >= 9 then
				rarity = "Rare"
				self.gachaData[userId].StandardPity = 0
			else
				self.gachaData[userId].StandardPity = self.gachaData[userId].StandardPity + 1
			end
		else
			if rarity ~= "Mythic" and rarity ~= "Legendary" then
				self.gachaData[userId].StandardPity = self.gachaData[userId].StandardPity + 1
			else
				self.gachaData[userId].StandardPity = 0
			end
		end

		local ghost = self:_selectRandomGhost(rarity)
		table.insert(results, { Id = ghost.Id, Rarity = rarity })

		-- Add ghost to player inventory
		if self.ghostSystem then
			self.ghostSystem:addGhost(player, ghost)
		end
	end

	self.dataManager:updatePlayerData(player, { Gacha = self.gachaData[userId] })
	return true, results
end

function GachaSystem:pullPremium(player, count)
	local userId = player.UserId
	count = count or 1

	if count ~= 1 and count ~= 10 then
		return false, "Invalid pull count"
	end

	local cost = count == 1 and Config.Gacha.PremiumPullCost or Config.Gacha.TenPullCostPremium

	if not self.currencySystem:canAfford(player, cost) then
		return false, "Not enough energy"
	end

	self.currencySystem:removeEnergy(player, cost)

	local results = {}
	for i = 1, count do
		local rarity = self:_selectRarity(Config.Gacha.PremiumWeights)

		-- Pity system: guarantee Legendary at 50 pulls
		if count == 10 and i == 10 then
			if self.gachaData[userId].PremiumPity >= 49 then
				rarity = "Legendary"
				self.gachaData[userId].PremiumPity = 0
			else
				self.gachaData[userId].PremiumPity = self.gachaData[userId].PremiumPity + 1
			end
		else
			if rarity ~= "Mythic" and rarity ~= "Legendary" then
				self.gachaData[userId].PremiumPity = self.gachaData[userId].PremiumPity + 1
			else
				self.gachaData[userId].PremiumPity = 0
			end
		end

		local ghost = self:_selectRandomGhost(rarity)
		table.insert(results, { Id = ghost.Id, Rarity = rarity })

		-- Add ghost to player inventory
		if self.ghostSystem then
			self.ghostSystem:addGhost(player, ghost)
		end
	end

	self.dataManager:updatePlayerData(player, { Gacha = self.gachaData[userId] })
	return true, results
end

function GachaSystem:getStandardPity(player)
	return self.gachaData[player.UserId].StandardPity
end

function GachaSystem:getPremiumPity(player)
	return self.gachaData[player.UserId].PremiumPity
end

return GachaSystem
-- Built with assistance from Claude Code by Anthropic.

