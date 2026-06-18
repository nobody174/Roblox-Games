--==============================--
-- ISLAND 05: FROSTBITE CAVERNS
--==============================--
-- Theme: Ice zone with water obstacles
-- Difficulty: Medium-Hard
-- Slippery terrain with water hazards
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "Frostbite Caverns",
	position = Vector3.new(0, 10, 1500),
	terrainMaterial = Enum.Material.Ice,
	size = 350,
	obstacleType = "water",
}

local function createIsland(parentFolder)
	local islandFolder = Instance.new("Folder")
	islandFolder.Name = ISLAND_DATA.name
	islandFolder.Parent = parentFolder

	Terrain.createTerrainBase(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial, ISLAND_DATA.name)
	Terrain.addTerrainVariation(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial)

	local obstaclesFolder = Instance.new("Folder")
	obstaclesFolder.Name = "Obstacles"
	obstaclesFolder.Parent = islandFolder

	local obstacleCount = math.max(1, math.ceil(ISLAND_DATA.size / 40) - 3)
	for i = 1, obstacleCount do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/3, ISLAND_DATA.size/3)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/3, ISLAND_DATA.size/3)
		local water = Props.createWater(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		water.Parent = obstaclesFolder
	end

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with " .. obstacleCount .. " water obstacles")
	return islandFolder
end

return { createIsland = createIsland }
