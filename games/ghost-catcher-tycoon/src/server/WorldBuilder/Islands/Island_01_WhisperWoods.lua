--==============================--
-- ISLAND 01: WHISPER WOODS
--==============================--
-- Theme: Peaceful meadow with trees
-- Difficulty: Easy (entry exploration zone)
-- Forest obstacles to navigate around
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

--==============================--
-- ISLAND CONFIGURATION
--==============================--

local ISLAND_DATA = {
	name = "Whisper Woods",
	position = Vector3.new(500, 10, 0),
	terrainMaterial = Enum.Material.Grass,
	size = 350,
	obstacleType = "trees",
}

--==============================--
-- RECOVERY LADDERS
--==============================--

local function createLadders(position, parent)
	local laddersFolder = Instance.new("Folder")
	laddersFolder.Name = "Ladders"
	laddersFolder.Parent = parent

	local ladderConfigs = {
		{offsetX = 0, offsetY = 8, offsetZ = -185, rotX = 0, rotY = -90, rotZ = -30},  -- North (lean 30° toward island, rotate -90°)
		{offsetX = 0, offsetY = 8, offsetZ = 185, rotX = 0, rotY = -90, rotZ = 30},    -- South (lean 30° toward island, rotate -90°)
		{offsetX = 185, offsetY = 8, offsetZ = 0, rotX = 30, rotY = -90, rotZ = 0},    -- East (lean 30° toward island, rotate -90°)
		{offsetX = -220, offsetY = 8, offsetZ = 0, rotX = -30, rotY = -90, rotZ = 0},  -- West (moved far left to avoid bridge)
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

--==============================--
-- ISLAND CREATION
--==============================--

local function createIsland(parentFolder)
	-- Create Whisper Woods island with tree obstacles
	-- Parameters: parentFolder (Folder to parent island to)
	-- Returns: Folder (the island folder)

	-- Create island folder
	local islandFolder = Instance.new("Folder")
	islandFolder.Name = ISLAND_DATA.name
	islandFolder.Parent = parentFolder

	-- Create terrain base and variation
	Terrain.createTerrainBase(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial, ISLAND_DATA.name)
	Terrain.addTerrainVariation(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial)

	-- Create obstacles folder
	local obstaclesFolder = Instance.new("Folder")
	obstaclesFolder.Name = "Obstacles"
	obstaclesFolder.Parent = islandFolder

	-- Create tree obstacles scattered across island
	local obstacleCount = math.ceil(ISLAND_DATA.size / 40)
	for i = 1, obstacleCount do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local tree = Props.createTree(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		tree.Parent = obstaclesFolder
	end

	-- Create recovery ladders
	createLadders(ISLAND_DATA.position, islandFolder)

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with " .. obstacleCount .. " trees")
	return islandFolder
end

--==============================--
-- EXPORTS
--==============================--

return {
	createIsland = createIsland,
}
