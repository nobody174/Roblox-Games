--[=[
  Ghost Catcher Tycoon - Prestige System Tests
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TestRunner = require("testRunner")

local Config = {
	Prestige = {
		MaxLevel = 20,
		BaseThreshold = 1000000,
		ThresholdMultiplier = 2,
		EnergyProductionBonusPerLevel = 0.10,
		CatchRateBonusPerLevel = 0.05,
		StorageBonusPerFiveLevels = 1,
	},
}

local PrestigeSystem = {}
PrestigeSystem.__index = PrestigeSystem

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
	local userId = player.id
	self.prestigeData[userId] = { Level = 0, TotalPrestiges = 0 }
end

function PrestigeSystem:removePlayer(userId)
	self.prestigeData[userId] = nil
end

function PrestigeSystem:getPrestigeThreshold(level)
	return Config.Prestige.BaseThreshold * (2 ^ level)
end

function PrestigeSystem:canPrestige(player)
	local userId = player.id
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
	local userId = player.id

	local canDo, reason = self:canPrestige(player)
	if not canDo then
		return false, reason
	end

	local currentEnergy = self.currencySystem:getEnergy(player)
	self.currencySystem:removeEnergy(player, currentEnergy)

	local ghosts = self.ghostSystem:getPlayerGhosts(player)
	local ghostIds = {}
	for ghostId, _ in pairs(ghosts) do
		table.insert(ghostIds, ghostId)
	end
	for _, ghostId in ipairs(ghostIds) do
		self.ghostSystem:removeGhost(player, ghostId)
	end

	if self.hqSystem and self.hqSystem.playerRooms and self.hqSystem.playerRooms[userId] then
		for roomName, _ in pairs(self.hqSystem.playerRooms[userId]) do
			self.hqSystem.playerRooms[userId][roomName].level = 1
		end
	end

	self.prestigeData[userId].Level = self.prestigeData[userId].Level + 1
	self.prestigeData[userId].TotalPrestiges = self.prestigeData[userId].TotalPrestiges + 1

	return true, { newLevel = self.prestigeData[userId].Level, bonuses = self:getPrestigeBonuses(player) }
end

function PrestigeSystem:getPrestigeLevel(player)
	local userId = player.id
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

-- Mock CurrencySystem
local MockCurrencySystem = {}
MockCurrencySystem.__index = MockCurrencySystem

function MockCurrencySystem:new()
	local self = setmetatable({}, MockCurrencySystem)
	self.energy = {}
	return self
end

function MockCurrencySystem:getEnergy(player)
	return self.energy[player.id] or 0
end

function MockCurrencySystem:removeEnergy(player, amount)
	self.energy[player.id] = (self.energy[player.id] or 0) - amount
end

function MockCurrencySystem:addEnergy(player, amount)
	self.energy[player.id] = (self.energy[player.id] or 0) + amount
end

-- Mock GhostSystem
local MockGhostSystem = {}
MockGhostSystem.__index = MockGhostSystem

function MockGhostSystem:new()
	local self = setmetatable({}, MockGhostSystem)
	self.ghosts = {}
	return self
end

function MockGhostSystem:getPlayerGhosts(player)
	return self.ghosts[player.id] or {}
end

function MockGhostSystem:removeGhost(player, ghostId)
	if self.ghosts[player.id] then
		self.ghosts[player.id][ghostId] = nil
	end
end

-- Mock HQSystem
local MockHQSystem = {}
MockHQSystem.__index = MockHQSystem

function MockHQSystem:new()
	local self = setmetatable({}, MockHQSystem)
	self.playerRooms = {}
	return self
end

function MockHQSystem:initializePlayer(player)
	self.playerRooms[player.id] = {
		GhostChamber = { level = 1 },
		TrainingFacility = { level = 1 },
	}
end

-- Tests
TestRunner:register("PrestigeSystem: canPrestige returns false when energy insufficient", function()
	local system = PrestigeSystem:new()
	local currency = MockCurrencySystem:new()
	system:setCurrencySystem(currency)

	local player = { id = 1 }
	system:initializePlayer(player)
	currency.energy[1] = 0

	local canPrestige, reason = system:canPrestige(player)
	TestRunner:assertFalse(canPrestige, "Should not be able to prestige with 0 energy")
	TestRunner:assertEquals(reason, "Not enough energy", "Error message should match")
end)

TestRunner:register("PrestigeSystem: canPrestige returns true when energy meets threshold", function()
	local system = PrestigeSystem:new()
	local currency = MockCurrencySystem:new()
	system:setCurrencySystem(currency)

	local player = { id = 1 }
	system:initializePlayer(player)
	currency.energy[1] = 2000000

	local canPrestige, reason = system:canPrestige(player)
	TestRunner:assertTrue(canPrestige, "Should be able to prestige with sufficient energy")
	TestRunner:assertEquals(reason, "ok", "Reason should be ok")
end)

TestRunner:register("PrestigeSystem: performPrestige increments level and drains energy", function()
	local system = PrestigeSystem:new()
	local currency = MockCurrencySystem:new()
	local ghosts = MockGhostSystem:new()
	local hq = MockHQSystem:new()

	system:setCurrencySystem(currency)
	system:setGhostSystem(ghosts)
	system:setHQSystem(hq)

	local player = { id = 1 }
	system:initializePlayer(player)
	hq:initializePlayer(player)
	currency.energy[1] = 2000000

	local success, result = system:performPrestige(player)
	TestRunner:assertTrue(success, "Prestige should succeed")
	TestRunner:assertEquals(system:getPrestigeLevel(player), 1, "Level should be 1")
	TestRunner:assertEquals(currency:getEnergy(player), 0, "Energy should be drained to 0")
end)

TestRunner:register("PrestigeSystem: getPrestigeBonuses scales with level", function()
	local system = PrestigeSystem:new()
	local player = { id = 1 }
	system:initializePlayer(player)

	system.prestigeData[1].Level = 5
	local bonuses = system:getPrestigeBonuses(player)

	TestRunner:assertEquals(bonuses.EnergyProductionMultiplier, 1.5, "5 levels should give 1.5x multiplier")
	TestRunner:assertEquals(bonuses.ExtraStorage, 1, "5 levels should give 1 storage bonus")
end)

TestRunner:register("PrestigeSystem: canPrestige returns false at max level", function()
	local system = PrestigeSystem:new()
	local currency = MockCurrencySystem:new()
	system:setCurrencySystem(currency)

	local player = { id = 1 }
	system:initializePlayer(player)
	system.prestigeData[1].Level = Config.Prestige.MaxLevel
	currency.energy[1] = 10000000

	local canPrestige, reason = system:canPrestige(player)
	TestRunner:assertFalse(canPrestige, "Should not be able to prestige at max level")
	TestRunner:assertEquals(reason, "Max prestige reached", "Error message should match")
end)

TestRunner:run()
