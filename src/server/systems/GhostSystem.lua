--[=[
  Ghost Catcher Tycoon - Ghost System
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local GhostSystem = {}
GhostSystem.__index = GhostSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function GhostSystem:new()
	local self = setmetatable({}, GhostSystem)
	self.playerGhosts = {} -- UserId -> { ghostId: { rarity, personality, level, stats, timestamp } }
	self.playerStorage = {} -- UserId -> current_count
	self.spawnedGhosts = {} -- zone -> { ghostId: { spawn_time, rarity } }
	self.ghostIdCounter = 0
	return self
end

function GhostSystem:initializePlayer(player)
	local userId = player.UserId
	self.playerGhosts[userId] = {}
	self.playerStorage[userId] = 0
end

local function generateGhostId()
	return tostring(os.time()) .. "_" .. math.random(1000, 9999)
end

local function selectRarityFromZone(zone)
	if not Config.Zones[zone] then return "Common" end

	local weights = Config.Zones[zone].RarityWeights
	local totalWeight = 0
	local rariities = {}

	for rarity, weight in pairs(weights) do
		totalWeight = totalWeight + weight
		table.insert(rariities, { rarity = rarity, weight = weight })
	end

	local roll = math.random() * totalWeight
	local accumulated = 0

	for _, entry in ipairs(rariities) do
		accumulated = accumulated + entry.weight
		if roll <= accumulated then
			return entry.rarity
		end
	end

	return rariities[#rariities].rarity
end

local function selectPersonality()
	local personalities = { "Shy", "Angry", "Playful", "Lazy", "Hyper" }
	return personalities[math.random(1, #personalities)]
end

function GhostSystem:spawnGhost(zone)
	local rarity = selectRarityFromZone(zone)
	local personality = selectPersonality()
	local ghostId = generateGhostId()

	return {
		id = ghostId,
		rarity = rarity,
		personality = personality,
		level = 1,
		stats = {
			catchSpeed = 1.0,
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

	local catchChance = self:calculateCatchChance(ghostId, zone)
	local success = math.random() < catchChance

	if success then
		local ghost = self:spawnGhost(zone)
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

function GhostSystem:calculateCatchChance(ghostId, zone)
	if not Config.Zones[zone] then return 0 end

	local rarity = selectRarityFromZone(zone)
	local baseChance = Config.Rarities[rarity].CatchChance
	local difficultyMod = Config.Zones[zone].DifficultyModifier

	return baseChance / difficultyMod
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
