--==============================--
-- ISLAND 08: ASTRAL OBSERVATORY
--==============================--
-- Theme: Desert with floating rocks
-- Difficulty: Hard
-- Cosmic energy with rock obstacles
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "Astral Observatory",
	position = Vector3.new(-500, 10, 2000),
	terrainMaterial = Enum.Material.Sand,
	size = 350,
	obstacleType = "rocks",
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

	local obstacleCount = math.ceil(ISLAND_DATA.size / 40)
	for i = 1, obstacleCount do
		local randomX = ISLAND_DATA.position.X + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local randomZ = ISLAND_DATA.position.Z + math.random(-ISLAND_DATA.size/2, ISLAND_DATA.size/2)
		local rock = Props.createRock(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		rock.Parent = obstaclesFolder
	end

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with " .. obstacleCount .. " rocks")
	return islandFolder
end

return { createIsland = createIsland }
