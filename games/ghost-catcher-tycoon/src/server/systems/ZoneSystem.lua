--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local ZoneSystem = {}
ZoneSystem.__index = ZoneSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))

function ZoneSystem:new()
	local self = setmetatable({}, ZoneSystem)
	self.unlockedZones = {}
	self.currencySystem = nil
	self.ghostSystem = nil
	self.bossActive = {}
	return self
end

function ZoneSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function ZoneSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function ZoneSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.unlockedZones then
		self.unlockedZones = {}
	end
	if not self.bossActive then
		self.bossActive = {}
	end
	self.unlockedZones[userId] = {}

	-- Starting Area and Whisper Woods start unlocked
	self.unlockedZones[userId]["Starting Area"] = true
	self.unlockedZones[userId]["Whisper Woods"] = true

	-- All others locked
	if ZoneData then
		for zoneName, _ in pairs(ZoneData) do
			if zoneName ~= "Starting Area" and zoneName ~= "Whisper Woods" then
				self.unlockedZones[userId][zoneName] = false
			end
		end
	end

	self.bossActive[userId] = {}
end

function ZoneSystem:unlockZone(player, zoneName)
	local userId = player.UserId

	if not self.unlockedZones[userId] then
		self:initializePlayer(player)
	end

	local zoneConfig = ZoneData[zoneName]
	if not zoneConfig then
		return false, "Zone not found"
	end

	if self.unlockedZones[userId][zoneName] then
		return false, "Zone already unlocked"
	end

	local cost = zoneConfig.UnlockCost
	if not self.currencySystem then
		return false, "Currency system not initialized"
	end

	local playerEnergy = self.currencySystem:getEnergy(player)
	if playerEnergy < cost then
		return false, "Not enough energy. Need: " .. cost .. ", Have: " .. playerEnergy
	end

	self.currencySystem:removeEnergy(player, cost, "ZoneUnlock")
	self.unlockedZones[userId][zoneName] = true

	return true, zoneConfig
end

function ZoneSystem:isZoneUnlocked(player, zoneName)
	local userId = player.UserId
	if not self.unlockedZones[userId] then
		self:initializePlayer(player)
	end
	return self.unlockedZones[userId][zoneName] or false
end

function ZoneSystem:getUnlockedZones(player)
	local userId = player.UserId
	if not self.unlockedZones[userId] then
		self:initializePlayer(player)
	end

	local unlocked = {}
	for zoneName, isUnlocked in pairs(self.unlockedZones[userId]) do
		if isUnlocked then
			table.insert(unlocked, zoneName)
		end
	end
	return unlocked
end

function ZoneSystem:spawnBoss(player, zoneName)
	local userId = player.UserId

	if not self.unlockedZones[userId] then
		self:initializePlayer(player)
	end

	if not self:isZoneUnlocked(player, zoneName) then
		return false, "Zone not unlocked"
	end

	if self.bossActive[userId][zoneName] then
		return false, "Boss already active in this zone"
	end

	local bossGhost = {
		id = "boss_" .. zoneName .. "_" .. os.time(),
		name = "Boss " .. zoneName,
		rarity = "Legendary",
		personality = "Angry",
		level = 5,
		isBoss = true,
		stats = {
			catchSpeed = 0.3,
			energyProduction = 50,
			trainingEfficiency = 2.0,
		},
		spawnTime = os.time(),
	}

	self.bossActive[userId][zoneName] = {
		active = true,
		ghostId = bossGhost.id,
		startTime = os.time(),
	}

	return true, bossGhost
end

function ZoneSystem:defeatBoss(player, zoneName, ghostId)
	local userId = player.UserId

	if not self.bossActive[userId] or not self.bossActive[userId][zoneName] then
		return false, "No boss active"
	end

	if self.bossActive[userId][zoneName].ghostId ~= ghostId then
		return false, "Wrong ghost ID"
	end

	local bossReward = 5000
	local zoneConfig = ZoneData[zoneName]
	if zoneConfig then
		bossReward = math.ceil(bossReward * zoneConfig.BaseEnergyMultiplier)
	end

	if self.currencySystem then
		self.currencySystem:addEnergy(player, bossReward, "BossDef eat")
	end

	self.bossActive[userId][zoneName] = nil

	return true, {
		reward = bossReward,
		message = "Boss defeated! Earned " .. bossReward .. " Ecto-Energy",
	}
end

function ZoneSystem:isBossActive(player, zoneName)
	local userId = player.UserId
	if not self.bossActive[userId] then
		return false
	end
	return self.bossActive[userId][zoneName] ~= nil
end

function ZoneSystem:getZoneInfo(zoneName)
	return ZoneData[zoneName]
end

function ZoneSystem:removePlayer(userId)
	self.unlockedZones[userId] = nil
	self.bossActive[userId] = nil
end

return ZoneSystem
-- Built with assistance from Claude Code by Anthropic.

