--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local GhostSystem = {}
GhostSystem.__index = GhostSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))
local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))

function GhostSystem:new()
	local self = setmetatable({}, GhostSystem)
	self.playerGhosts = {}
	self.playerStorage = {}
	self.spawnedGhosts = {}
	return self
end

function GhostSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.playerGhosts then
		self.playerGhosts = {}
	end
	if not self.playerStorage then
		self.playerStorage = {}
	end
	self.playerGhosts[userId] = {}
	self.playerStorage[userId] = 0
end

local function generateGhostId()
	return tostring(os.time()) .. "_" .. math.random(1000, 9999)
end

local function selectPersonality()
	return GhostData.Personalities[math.random(1, #GhostData.Personalities)]
end

local function selectGhostFromZone(zone)
	local zoneConfig = ZoneData[zone]
	if not zoneConfig then return nil end

	local spawns = zoneConfig.Spawns
	local totalWeight = 0

	for _, entry in ipairs(spawns) do
		totalWeight = totalWeight + entry.Weight
	end

	if totalWeight == 0 then return nil end

	local roll = math.random() * totalWeight
	local accumulated = 0

	for _, entry in ipairs(spawns) do
		accumulated = accumulated + entry.Weight
		if roll <= accumulated then
			return entry
		end
	end

	return spawns[#spawns]
end

function GhostSystem:spawnGhost(zone)
	local ghostEntry = selectGhostFromZone(zone)
	if not ghostEntry then
		return nil, "No ghost in zone"
	end

	local rarity = ghostEntry.Rarity
	local personality = selectPersonality()
	local ghostId = generateGhostId()
	local rarityStats = GhostData.RarityStats[rarity]

	return {
		id = ghostId,
		name = ghostEntry.Ghost,
		rarity = rarity,
		personality = personality,
		level = 1,
		stats = {
			catchSpeed = math.random(rarityStats.CatchSpeed[1] * 10, rarityStats.CatchSpeed[2] * 10) / 10,
			energyProduction = Config.Rarities[rarity].BaseEnergyOutput,
			trainingEfficiency = 1.0,
		},
		spawnTime = os.time(),
	}
end

function GhostSystem:attemptCatch(player, ghostId, zone)
	local userId = player.UserId

	if not self.playerGhosts[userId] then
		return false, "Player not initialized"
	end

	local catchChance = self:calculateCatchChance(zone)
	local success = math.random() < catchChance

	if success then
		local ghost = self:spawnGhost(zone)
		if not ghost then
			return false, "Failed to spawn ghost"
		end

		ghost.id = ghostId

		if self:canAddGhost(userId) then
			self.playerGhosts[userId][ghostId] = ghost
			self.playerStorage[userId] = self.playerStorage[userId] + 1
			return true, ghost
		else
			return false, "Storage full"
		end
	end

	return false, "Failed catch (miss)"
end

function GhostSystem:calculateCatchChance(zone)
	local ghostEntry = selectGhostFromZone(zone)
	if not ghostEntry then return 0 end

	local rarity = ghostEntry.Rarity
	return Config.Rarities[rarity].CatchChance
end

function GhostSystem:canAddGhost(userId)
	if not self.playerStorage[userId] then return false end
	return self.playerStorage[userId] < self:getMaxStorage(userId)
end

function GhostSystem:getMaxStorage(userId)
	return Config.DefaultGhostStorage
end

function GhostSystem:addGhost(player, ghost)
	local userId = player.UserId

	if not self:canAddGhost(userId) then
		return false
	end

	self.playerGhosts[userId][ghost.id] = ghost
	self.playerStorage[userId] = self.playerStorage[userId] + 1
	return true
end

function GhostSystem:removeGhost(player, ghostId)
	local userId = player.UserId

	if self.playerGhosts[userId] and self.playerGhosts[userId][ghostId] then
		self.playerGhosts[userId][ghostId] = nil
		self.playerStorage[userId] = math.max(0, self.playerStorage[userId] - 1)
		return true
	end

	return false
end

function GhostSystem:getPlayerGhosts(player)
	local userId = player.UserId
	return self.playerGhosts[userId] or {}
end

function GhostSystem:getPlayerGhostCount(player)
	local userId = player.UserId
	return self.playerStorage[userId] or 0
end

function GhostSystem:getGhost(player, ghostId)
	local userId = player.UserId
	if self.playerGhosts[userId] then
		return self.playerGhosts[userId][ghostId]
	end
	return nil
end

function GhostSystem:removePlayer(userId)
	self.playerGhosts[userId] = nil
	self.playerStorage[userId] = nil
end

return GhostSystem
-- Built with assistance from Claude Code by Anthropic.

