--==============================--
-- TERRAIN SYSTEM
--==============================--
-- Shared terrain creation helpers used across all islands and boss platforms
-- Provides consistent terrain generation with material filling and variation
--==============================--

local workspace = game:GetService("Workspace")
local terrain = workspace.Terrain

--==============================--
-- TERRAIN BASE CREATION
--==============================--

local function createTerrainBase(position, size, material, name)
	-- Fill a rectangular region with terrain material
	-- Parameters:
	--   position: Vector3 center of terrain
	--   size: studs per side (creates square base)
	--   material: Enum.Material (Grass, Sand, Slate, etc.)
	--   name: string for logging

	terrain:FillRegion(
		Region3.new(
			position - Vector3.new(size/2, 10, size/2),
			position + Vector3.new(size/2, 5, size/2)
		):ExpandToGrid(4),
		4,
		material
	)
end

--==============================--
-- TERRAIN VARIATION
--==============================--

local function addTerrainVariation(position, size, material)
	-- Add bumpy variation to terrain for visual interest
	-- Creates 8 random terrain balls across the zone
	-- Parameters:
	--   position: Vector3 center of zone
	--   size: studs per side
	--   material: Enum.Material to use for bumps

	for i = 1, 8 do
		local randomX = position.X + math.random(-size/3, size/3)
		local randomZ = position.Z + math.random(-size/3, size/3)
		local bumpPos = Vector3.new(randomX, position.Y, randomZ)
		terrain:FillBall(bumpPos, 20, material)
	end
end

--==============================--
-- BOSS PLATFORM TERRAIN
--==============================--

local function createBossPlatform(position, size, material)
	-- Create floating boss arena terrain platform
	-- Consistent method ensures all boss platforms use same generation
	-- Parameters:
	--   position: Vector3 center of platform
	--   size: studs per side (half-size for FillRegion calculation)
	--   material: Enum.Material (typically Rock)

	terrain:FillRegion(
		Region3.new(
			position - Vector3.new(size, 5, size),
			position + Vector3.new(size, 1, size)
		):ExpandToGrid(4),
		4,
		material
	)
end

--==============================--
-- EXPORTS
--==============================--

return {
	createTerrainBase = createTerrainBase,
	addTerrainVariation = addTerrainVariation,
	createBossPlatform = createBossPlatform,
}
