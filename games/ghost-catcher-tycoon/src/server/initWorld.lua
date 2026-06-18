--==============================--
-- WORLD INITIALIZATION ENTRY POINT
--==============================--
-- EDITOR_MODE = true: Generates world in Studio for baking
-- EDITOR_MODE = false: Loads pre-baked world from place file
--==============================--

local EDITOR_MODE = true  -- SET TO FALSE BEFORE PUBLISHING!

print("[initWorld] Script started, attempting to load modules...")

local WorldInit
local TerrainSaver

-- Load WorldInit module
do
	local success, result = pcall(function()
		return require(script.Parent:WaitForChild("WorldBuilder", 30):WaitForChild("WorldInit", 30))
	end)
	if not success then
		print("[initWorld] ❌ ERROR loading WorldInit: " .. tostring(result))
		error(result)
	end
	WorldInit = result
	print("[initWorld] ✅ WorldInit module loaded")
end

-- Load TerrainSaver module
do
	local success, result = pcall(function()
		return require(script.Parent:WaitForChild("TerrainSaver", 30))
	end)
	if not success then
		print("[initWorld] ❌ ERROR loading TerrainSaver: " .. tostring(result))
		error(result)
	end
	TerrainSaver = result
	print("[initWorld] ✅ TerrainSaver module loaded")
end

local function buildWorld()
	print("[initWorld] Building world...")

	-- Generate all islands, bosses, bridges, portals
	WorldInit.initializeWorld()

	-- Save the generated terrain to ServerStorage for persistence
	TerrainSaver.saveTerrain()

	print("[initWorld] ✅ World build complete! Terrain saved.")
end

local function loadWorld()
	print("[initWorld] Loading persistent world...")

	-- Load terrain from ServerStorage
	local terrainLoaded = TerrainSaver.loadTerrain()

	-- ZoneContainer should already be in place file
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if zoneContainer then
		print("[initWorld] ✅ ZoneContainer found and loaded")
	else
		print("[initWorld] ⚠️ ZoneContainer not found in workspace")
	end

	print("[initWorld] ✅ World loaded!")
end

-- Wait a moment for all modules to load before running
task.wait(1)

if EDITOR_MODE then
	print("[initWorld] EDITOR_MODE ON - Generating world for baking...")
	buildWorld()
	print("[initWorld] ✅ World generated! Now SAVE your place file (Ctrl+S) to bake it.")
	print("[initWorld] After saving, set EDITOR_MODE = false and disable this script.")
else
	print("[initWorld] EDITOR_MODE OFF - World is pre-baked in place file. Skipping generation.")
end

return { buildWorld = buildWorld, loadWorld = loadWorld }
