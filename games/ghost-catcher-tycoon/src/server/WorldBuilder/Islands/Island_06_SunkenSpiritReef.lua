--==============================--
-- ISLAND 06: SUNKEN SPIRIT REEF
--==============================--
-- Theme: Underwater reef with multiple water hazards
-- Difficulty: Medium-Hard
-- Water-heavy zone with aquatic atmosphere
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "Sunken Spirit Reef",
	position = Vector3.new(500, 10, 2000),
	terrainMaterial = Enum.Material.Sand,
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

	-- Multiple water obstacles for underwater theme
	local obstacleCount = 3
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
