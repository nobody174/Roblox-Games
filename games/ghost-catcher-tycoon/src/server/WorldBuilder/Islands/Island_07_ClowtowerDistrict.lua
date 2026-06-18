--==============================--
-- ISLAND 07: CLOCKTOWER DISTRICT
--==============================--
-- Theme: Urban tech zone with glowing pads
-- Difficulty: Hard
-- Time-themed zone with neon platforms
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
	name = "Clocktower District",
	position = Vector3.new(0, 10, 2500),
	terrainMaterial = Enum.Material.Concrete,
	size = 350,
	obstacleType = "neon_pads",
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
		local pad = Props.createNeonPad(Vector3.new(randomX, ISLAND_DATA.position.Y + 20, randomZ))
		pad.Parent = obstaclesFolder
	end

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name .. " with " .. obstacleCount .. " neon pads")
	return islandFolder
end

return { createIsland = createIsland }
