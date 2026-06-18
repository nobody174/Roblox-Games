--==============================--
-- ISLAND 02: FOGGY FIELDS
--==============================--
-- Theme: Desert with cacti
-- Difficulty: Easy-Medium
-- Prickly cactus obstacles for navigation challenge
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "Foggy Fields",
	position = Vector3.new(0, 10, 500),
	terrainMaterial = Enum.Material.Sand,
	size = 350,
	obstacleType = "cacti",
}

local function createLadders(position, parent)
	local laddersFolder = Instance.new("Folder")
	laddersFolder.Name = "Ladders"
	laddersFolder.Parent = parent

	local ladderConfigs = {
		{offsetX = 0, offsetY = 8, offsetZ = -185, rotX = 0, rotY = -90, rotZ = -30},  -- North (lean 30° toward island, rotate -90°)
		{offsetX = 0, offsetY = 8, offsetZ = 220, rotX = 0, rotY = -90, rotZ = 30},    -- South (moved far away to avoid bridge)
		{offsetX = 185, offsetY = 8, offsetZ = 0, rotX = 30, rotY = -90, rotZ = 0},    -- East (lean 30° toward island, rotate -90°)
		{offsetX = -185, offsetY = 8, offsetZ = 0, rotX = -30, rotY = -90, rotZ = 0},  -- West (lean 30° toward island, rotate -90°)
	}

	for _, config in ipairs(ladderConfigs) do
		local ladder = Instance.new("TrussPart")
		ladder.Name = "RecoveryLadder"
		ladder.Anchored = true
		ladder.CanCollide = true
		ladder.Size = Vector3.new(2, 20, 2)
		ladder.Position = Vector3.new(position.X + config.offsetX, position.Y + config.offsetY, position.Z + config.offsetZ)
		ladder.Orientation = Vector3.new(config.rotX, config.rotY, config.rotZ)
		ladder.Parent = laddersFolder
	end
end

local function createIsland(parentFolder)
	local islandFolder = Instance.new("Folder")
	islandFolder.Name = ISLAND_DATA.name
	islandFolder.Parent = parentFolder

	Terrain.createTerrainBase(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial, ISLAND_DATA.name)
	Terrain.addTerrainVariation(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial)

	local obstaclesFolder = Instance.new("Folder")
	obstaclesFolder.Name = "Obstacles"
	obstaclesFolder.Parent = islandFolder

	local obstacleCount = math.ceil(ISLAND_DATA.size / 40)
	for i = 1, obstacleCount do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local cactus = Props.createCactus(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		cactus.Parent = obstaclesFolder
	end

	createLadders(ISLAND_DATA.position, islandFolder)

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with " .. obstacleCount .. " cacti")
	return islandFolder
end

return { createIsland = createIsland }
