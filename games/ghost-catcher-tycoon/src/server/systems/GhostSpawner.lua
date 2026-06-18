--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Ghost spawner: spawns ghosts in zones, tracks active instances, handles cleanup and respawning.
--
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GhostData = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("GhostData"))
local ZoneData = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("ZoneData"))
local GhostStatGenerator = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("GhostStatGenerator"))
local GhostInstanceBuilder = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("GhostInstanceBuilder"))
local Constants = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("constants"))

local GhostSpawner = {}
GhostSpawner.__index = GhostSpawner

-- Configuration
local SPAWN_RADIUS = 50
local MAX_GHOSTS_PER_ZONE = 5
local GHOST_DESPAWN_TIME = 60
local SPAWN_CHECK_INTERVAL = 3

-- Map ZoneData keys to WorldBuilder island folder names (under ZoneContainer/Islands/)
local ZONE_FOLDER_MAPPING = {
	["Starting Area"] = "Hub",
	["Whisper Woods"] = "Whisper Woods",
	["Foggy Fields"] = "Foggy Fields",
	["Gloomy Graveyard"] = "Gloomy Graveyard",
	["Electro Alley"] = "Electro Alley",
	["Frostbite Caverns"] = "Frostbite Caverns",
	["Sunken Spirit Reef"] = "Sunken Spirit Reef",
	["Clocktower District"] = "Clocktower District",
	["Astral Observatory"] = "Astral Observatory",
	["Phantom Fortress"] = "Phantom Fortress",
	["The Rift"] = "The Rift",
	["Eternity Nexus"] = "Eternity Nexus",
}

function GhostSpawner:new()
	local self = setmetatable({}, GhostSpawner)
	self.activeGhosts = {} -- Track active ghost instances
	self.ghostsByZone = {} -- Track ghosts per zone
	self.respawnTimers = {} -- Track when ghosts should respawn
	return self
end

-- Get a random ghost from a zone's pool
local function getRandomGhostFromZone(zoneName)
	local zoneData = ZoneData[zoneName]
	if not zoneData or not zoneData.Spawns then
		return nil
	end

	local spawns = zoneData.Spawns
	local totalWeight = 0
	for _, spawn in ipairs(spawns) do
		totalWeight = totalWeight + spawn.Weight
	end

	local roll = math.random(1, totalWeight)
	local current = 0
	for _, spawn in ipairs(spawns) do
		current = current + spawn.Weight
		if roll <= current then
			return spawn.Ghost
		end
	end

	return spawns[1].Ghost
end

-- Spawn a ghost in a specific zone
function GhostSpawner:spawnGhostInZone(zoneName)
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then
		warn("[GhostSpawner] ZoneContainer not found in workspace")
		return nil
	end

	-- Map ZoneData key to actual folder name in ZoneContainer
	local zoneFolderName = ZONE_FOLDER_MAPPING[zoneName]
	if not zoneFolderName then
		warn("[GhostSpawner] No folder mapping found for zone: " .. zoneName)
		return nil
	end

	-- Navigate to ZoneContainer/Islands/IslandName
	local islandsFolder = zoneContainer:FindFirstChild("Islands")
	if not islandsFolder then
		warn("[GhostSpawner] Islands folder not found in ZoneContainer")
		return nil
	end

	local zoneFolder = islandsFolder:FindFirstChild(zoneFolderName)
	if not zoneFolder then
		warn("[GhostSpawner] Zone folder not found: " .. zoneFolderName .. " (ZoneData key: " .. zoneName .. ")")
		return nil
	end

	-- Check if zone already has max ghosts
	if not self.ghostsByZone[zoneName] then
		self.ghostsByZone[zoneName] = {}
	end

	-- Clean up dead ghost references
	local aliveGhosts = {}
	for _, ghost in ipairs(self.ghostsByZone[zoneName]) do
		if ghost and ghost.Parent then
			table.insert(aliveGhosts, ghost)
		end
	end
	self.ghostsByZone[zoneName] = aliveGhosts

	if #aliveGhosts >= MAX_GHOSTS_PER_ZONE then
		return nil -- Zone is full
	end

	-- Pick a random ghost from zone pool
	local ghostName = getRandomGhostFromZone(zoneName)
	if not ghostName then
		return nil
	end

	-- Generate stats
	local stats = GhostStatGenerator:GenerateStatsForGhost(ghostName)
	if not stats then
		return nil
	end

	-- Random position within zone (find any terrain part to use as center)
	local terrainPart = nil
	for _, child in ipairs(zoneFolder:GetChildren()) do
		if child:IsA("BasePart") then
			terrainPart = child
			break
		end
	end

	local spawnPos
	if terrainPart then
		spawnPos = terrainPart.Position + Vector3.new(
			math.random(-SPAWN_RADIUS, SPAWN_RADIUS),
			25,  -- Increased from 10 to 25 studs above terrain to spawn above ground
			math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
		)
	else
		-- Fallback if no terrain found
		spawnPos = Vector3.new(0, 50, 0)
	end

	-- Create ghost instance
	stats.Position = spawnPos
	local ghostInstance = GhostInstanceBuilder:CreateGhostInstance(stats, zoneFolder)
	if not ghostInstance then
		return nil
	end

	-- Position the ghost
	ghostInstance.Position = spawnPos

	-- Track the ghost
	table.insert(self.ghostsByZone[zoneName], ghostInstance)
	self.activeGhosts[ghostInstance] = {
		zoneName = zoneName,
		spawnTime = os.time(),
	}

	-- Schedule despawn
	task.delay(GHOST_DESPAWN_TIME, function()
		if ghostInstance and ghostInstance.Parent then
			self.activeGhosts[ghostInstance] = nil
			ghostInstance:Destroy()
		end
	end)

	print("[GhostSpawner] Spawned " .. ghostName .. " in " .. zoneName)
	return ghostInstance
end

-- Spawn ghosts in all zones periodically (shared zones only, not private Home)
function GhostSpawner:startSpawning()
	task.spawn(function()
		while true do
			task.wait(SPAWN_CHECK_INTERVAL)

			-- Spawn in shared exploration zones (Whisper Woods, Foggy Fields, etc.)
			-- Skip Starting Area/Hub (public but handled separately) and Home (private per-player)
			for zoneName, zoneInfo in pairs(ZoneData) do
				-- Skip public hub and private home zones
				if zoneName ~= "Starting Area" and not zoneInfo.IsPrivate then
					self:spawnGhostInZone(zoneName)
				end
			end
		end
	end)

	print("[GhostSpawner] Started spawning ghosts in shared exploration zones")
end

-- Get all active ghosts in a zone
function GhostSpawner:getGhostsInZone(zoneName)
	if not self.ghostsByZone[zoneName] then
		return {}
	end

	local aliveGhosts = {}
	for _, ghost in ipairs(self.ghostsByZone[zoneName]) do
		if ghost and ghost.Parent then
			table.insert(aliveGhosts, ghost)
		end
	end
	return aliveGhosts
end

-- Remove a ghost (on catch)
function GhostSpawner:removeGhost(ghostInstance)
	if ghostInstance and ghostInstance.Parent then
		self.activeGhosts[ghostInstance] = nil
		ghostInstance:Destroy()
		return true
	end
	return false
end

-- Get total active ghosts
function GhostSpawner:getActiveGhostCount()
	local count = 0
	for ghostInstance, _ in pairs(self.activeGhosts) do
		if ghostInstance and ghostInstance.Parent then
			count = count + 1
		end
	end
	return count
end

return GhostSpawner
-- Built with assistance from Claude Code by Anthropic.
