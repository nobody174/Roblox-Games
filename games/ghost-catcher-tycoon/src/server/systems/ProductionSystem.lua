--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local ProductionSystem = {}
ProductionSystem.__index = ProductionSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function ProductionSystem:new()
	local self = setmetatable({}, ProductionSystem)
	self.currencySystem = nil
	self.ghostSystem = nil
	self.hqSystem = nil
	self.eventSystem = nil
	self.prestigeSystem = nil
	self.lastProductionTick = {} -- UserId -> os.clock()
	self.accumulatedEnergy = {} -- UserId -> energy amount
	return self
end

function ProductionSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function ProductionSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function ProductionSystem:setHQSystem(hqSystem)
	self.hqSystem = hqSystem
end

function ProductionSystem:setEventSystem(eventSystem)
	self.eventSystem = eventSystem
end

function ProductionSystem:setPrestigeSystem(prestigeSystem)
	self.prestigeSystem = prestigeSystem
end

function ProductionSystem:initializePlayer(player)
	local userId = player.UserId
	self.lastProductionTick[userId] = os.clock()
	self.accumulatedEnergy[userId] = 0
end

function ProductionSystem:calculateEnergyPerSecond(player)
	local userId = player.UserId

	if not self.ghostSystem then return 0 end

	local ghosts = self.ghostSystem:getPlayerGhosts(player)
	local totalEnergy = 0

	for ghostId, ghost in pairs(ghosts) do
		if ghost and ghost.stats then
			local baseEnergy = ghost.stats.energyProduction or 1
			local rarity = ghost.rarity or "Common"
			local rarityMultiplier = Config.Rarities[rarity].BaseEnergyOutput

			totalEnergy = totalEnergy + (baseEnergy * (ghost.level or 1))
		end
	end

	-- Apply HQ room multipliers if HQ system exists
	if self.hqSystem then
		local hqMultiplier = self.hqSystem:getEnergyMultiplier(player)
		totalEnergy = totalEnergy * hqMultiplier
	end

	return totalEnergy
end

function ProductionSystem:tick(player)
	local userId = player.UserId

	if not self.lastProductionTick[userId] then
		self:initializePlayer(player)
	end

	local now = os.clock()
	local deltaTime = now - self.lastProductionTick[userId]

	if deltaTime < 1 then return 0 end -- Only tick once per second

	self.lastProductionTick[userId] = now

	local energyPerSecond = self:calculateEnergyPerSecond(player)
	local energyGenerated = energyPerSecond * deltaTime

	self.accumulatedEnergy[userId] = (self.accumulatedEnergy[userId] or 0) + energyGenerated

	-- Deposit accumulated energy if >= 1
	if self.accumulatedEnergy[userId] >= 1 then
		local toDeposit = math.floor(self.accumulatedEnergy[userId])
		if self.currencySystem and toDeposit > 0 then
			self.currencySystem:addEnergy(player, toDeposit)
			self.accumulatedEnergy[userId] = self.accumulatedEnergy[userId] - toDeposit
		end
	end

	return energyGenerated
end

function ProductionSystem:removePlayer(userId)
	self.lastProductionTick[userId] = nil
	self.accumulatedEnergy[userId] = nil
end

return ProductionSystem
-- Built with assistance from Claude Code by Anthropic.

