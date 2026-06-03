--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Generates ghost stats (catch speed, energy, training cost) based on rarity and personality.
--
local HttpService = game:GetService("HttpService")

local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))

local GhostStatGenerator = {}

-- Generate a random personality
local function getRandomPersonality()
	return GhostData.Personalities[math.random(1, #GhostData.Personalities)]
end

-- Generate stats for a ghost by name
function GhostStatGenerator:GenerateStatsForGhost(ghostName)
	if not ghostName then
		warn("[GhostStatGenerator] No ghost name provided")
		return nil
	end

	local rarity = GhostData.RarityMap[ghostName]
	if not rarity then
		warn("[GhostStatGenerator] Ghost not found in RarityMap: " .. tostring(ghostName))
		return nil
	end

	local rarityStats = GhostData.RarityStats[rarity]
	if not rarityStats then
		warn("[GhostStatGenerator] Rarity stats not found: " .. tostring(rarity))
		return nil
	end

	local personality = getRandomPersonality()

	local catchSpeedMin, catchSpeedMax = rarityStats.CatchSpeed[1], rarityStats.CatchSpeed[2]
	local energyPerMinMin, energyPerMinMax = rarityStats.EnergyPerMin[1], rarityStats.EnergyPerMin[2]
	local trainingCostMin, trainingCostMax = rarityStats.TrainingCost[1], rarityStats.TrainingCost[2]

	return {
		Name = ghostName,
		Rarity = rarity,
		Personality = personality,
		CatchSpeed = math.random(catchSpeedMin * 100, catchSpeedMax * 100) / 100,
		EnergyPerMin = math.random(energyPerMinMin * 100, energyPerMinMax * 100) / 100,
		TrainingCostMultiplier = math.random(trainingCostMin * 100, trainingCostMax * 100) / 100,
		Level = 1,
	}
end

-- Generate stats for a random ghost of a specific rarity
function GhostStatGenerator:GenerateRandomGhostOfRarity(rarity)
	if not rarity or not GhostData.RarityStats[rarity] then
		warn("[GhostStatGenerator] Invalid rarity: " .. tostring(rarity))
		return nil
	end

	local ghostsOfRarity = {}
	for ghostName, ghostRarity in pairs(GhostData.RarityMap) do
		if ghostRarity == rarity then
			table.insert(ghostsOfRarity, ghostName)
		end
	end

	if #ghostsOfRarity == 0 then
		warn("[GhostStatGenerator] No ghosts found for rarity: " .. rarity)
		return nil
	end

	local randomGhost = ghostsOfRarity[math.random(1, #ghostsOfRarity)]
	return self:GenerateStatsForGhost(randomGhost)
end

return GhostStatGenerator
-- Built with assistance from Claude Code by Anthropic.
