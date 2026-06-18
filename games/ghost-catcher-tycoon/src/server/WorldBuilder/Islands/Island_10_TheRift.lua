--==============================--
-- ISLAND 10: THE RIFT
--==============================--
-- Theme: Glitch world with water and ice
-- Difficulty: Very Hard
-- Chaotic dimension with multiple hazard types
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "The Rift",
	position = Vector3.new(1000, 10, 1500),
	terrainMaterial = Enum.Material.Slate,
	size = 350,
	obstacleType = "water_ice",
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

	-- Mixed obstacles: water and ice
	local obstacleCount = math.ceil(ISLAND_DATA.size / 40)
	for i = 1, math.floor(obstacleCount / 2) do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local water = Props.createWater(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		water.Parent = obstaclesFolder
	end

	for i = 1, math.floor(obstacleCount / 2) do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local ice = Props.createIceBlock(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		ice.Parent = obstaclesFolder
	end

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with mixed water and ice obstacles")
	return islandFolder
end

return { createIsland = createIsland }
