--[=[
  Ghost Catcher Tycoon - Prestige System
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local PrestigeSystem = {}
PrestigeSystem.__index = PrestigeSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function PrestigeSystem:new()
	local self = setmetatable({}, PrestigeSystem)
	self.prestigeData = {}
	self.currencySystem = nil
	self.ghostSystem = nil
	self.hqSystem = nil
	self.zoneSystem = nil
	self.dataManager = nil
	return self
end

function PrestigeSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function PrestigeSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function PrestigeSystem:setHQSystem(hqSystem)
	self.hqSystem = hqSystem
end

function PrestigeSystem:setZoneSystem(zoneSystem)
	self.zoneSystem = zoneSystem
end

function PrestigeSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function PrestigeSystem:initializePlayer(player)
	local userId = player.UserId
	local data = self.dataManager:getPlayerData(player)
	local prestigeData = data.Prestige or { Level = 0, TotalPrestiges = 0 }
	self.prestigeData[userId] = prestigeData
end

function PrestigeSystem:removePlayer(userId)
	self.prestigeData[userId] = nil
end

function PrestigeSystem:getPrestigeThreshold(level)
	return Config.Prestige.BaseThreshold * (2 ^ level)
end

function PrestigeSystem:canPrestige(player)
	local userId = player.UserId
	local currentLevel = self.prestigeData[userId].Level

	if currentLevel >= Config.Prestige.MaxLevel then
		return false, "Max prestige reached"
	end

	local currentEnergy = self.currencySystem:getEnergy(player)
	local threshold = self:getPrestigeThreshold(currentLevel)

	if currentEnergy < threshold then
		return false, "Not enough energy"
	end

	return true, "ok"
end

function PrestigeSystem:performPrestige(player)
	local userId = player.UserId

	local canDo, reason = self:canPrestige(player)
	if not canDo then
		return false, reason
	end

	-- Drain energy to 0
	local currentEnergy = self.currencySystem:getEnergy(player)
	self.currencySystem:removeEnergy(player, currentEnergy)

	-- Remove all ghosts (collect IDs first to avoid iteration issues)
	local ghosts = self.ghostSystem:getPlayerGhosts(player)
	local ghostIds = {}
	for ghostId, _ in pairs(ghosts) do
		table.insert(ghostIds, ghostId)
	end
	for _, ghostId in ipairs(ghostIds) do
		self.ghostSystem:removeGhost(player, ghostId)
	end

	-- Reset HQ room levels
	if self.hqSystem and self.hqSystem.playerRooms and self.hqSystem.playerRooms[userId] then
		for roomName, _ in pairs(self.hqSystem.playerRooms[userId]) do
			self.hqSystem.playerRooms[userId][roomName].level = 1
		end
	end

	-- Increment prestige level
	self.prestigeData[userId].Level = self.prestigeData[userId].Level + 1
	self.prestigeData[userId].TotalPrestiges = self.prestigeData[userId].TotalPrestiges + 1

	-- Persist
	self.dataManager:updatePlayerData(player, { Prestige = self.prestigeData[userId] })

	return true, { newLevel = self.prestigeData[userId].Level, bonuses = self:getPrestigeBonuses(player) }
end

function PrestigeSystem:getPrestigeLevel(player)
	local userId = player.UserId
	return self.prestigeData[userId] and self.prestigeData[userId].Level or 0
end

function PrestigeSystem:getPrestigeBonuses(player)
	local level = self:getPrestigeLevel(player)
	return {
		EnergyProductionMultiplier = 1.0 + (level * Config.Prestige.EnergyProductionBonusPerLevel),
		CatchRateBonus = level * Config.Prestige.CatchRateBonusPerLevel,
		ExtraStorage = math.floor(level / 5) * Config.Prestige.StorageBonusPerFiveLevels,
	}
end

return PrestigeSystem
