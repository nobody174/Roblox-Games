--==============================--
-- ISLAND: HUB (SPAWN AREA)
--==============================--
-- Central spawn hub for all players
-- Large green spawn platform with fresh grass terrain
-- No obstacles - safe zone for new players
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)

--==============================--
-- ISLAND CONFIGURATION
--==============================--

local ISLAND_DATA = {
	name = "Hub",
	position = Vector3.new(0, 10, 0),
	terrainMaterial = Enum.Material.Grass,
	size = 250,
}

--==============================--
-- RECOVERY LADDERS
--==============================--

local function createLadders(position, parent)
	-- Create 4 recovery ladders (north, south, east, west) for falling players
	-- Parameters:
	--   position: Vector3 island center
	--   parent: Folder to parent ladders to

	local laddersFolder = Instance.new("Folder")
	laddersFolder.Name = "Ladders"
	laddersFolder.Parent = parent

	local ladderConfigs = {
		{offsetX = 0, offsetY = 8, offsetZ = -135, rotX = 0, rotY = -90, rotZ = -30},   -- North (lean 30° toward island, rotate -90°)
		{offsetX = 0, offsetY = 8, offsetZ = 135, rotX = 0, rotY = -90, rotZ = 30},     -- South (lean 30° toward island, rotate -90°)
		{offsetX = 160, offsetY = 8, offsetZ = 0, rotX = 30, rotY = -90, rotZ = 0},     -- East (moved far right to avoid bridge)
		{offsetX = -160, offsetY = 8, offsetZ = 0, rotX = -30, rotY = -90, rotZ = 0},   -- West (moved far left to avoid bridge)
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
	-- Create the hub island with spawn point
	-- Parameters: parentFolder (Folder to parent island to)
	-- Returns: Folder (the island folder)

	-- Create island folder
	local islandFolder = Instance.new("Folder")
	islandFolder.Name = ISLAND_DATA.name
	islandFolder.Parent = parentFolder

	-- Create terrain base
	Terrain.createTerrainBase(ISLAND_DATA.position, ISLAND_DATA.size, ISLAND_DATA.terrainMaterial, ISLAND_DATA.name)

	-- Create spawn point
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnPoint"
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Color = Color3.fromRGB(0, 255, 0)
	spawn.Material = Enum.Material.Neon
	spawn.CanCollide = true
	spawn.Position = ISLAND_DATA.position + Vector3.new(0, 20, 0)
	spawn.Parent = islandFolder

	-- Create recovery ladders
	createLadders(ISLAND_DATA.position, islandFolder)

	print("[WorldBuilder] ✅ Island created: " .. ISLAND_DATA.name)
	return islandFolder
end

--==============================--
-- EXPORTS
--==============================--

return {
	createIsland = createIsland,
}
