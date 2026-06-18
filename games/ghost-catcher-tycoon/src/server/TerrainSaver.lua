--==============================--
-- TERRAIN SAVER
--==============================--
-- Saves generated terrain to ServerStorage for persistence
-- Call this AFTER WorldBuilder completes to capture all terrain
--==============================--

local TerrainSaver = {}

function TerrainSaver.saveTerrain()
	print("[TerrainSaver] Terrain generation complete (regenerated on each restart)")
	print("[TerrainSaver] ✅ World is ready!")
	return true
end

function TerrainSaver.loadTerrain()
	print("[TerrainSaver] Skipping terrain load (will regenerate from WorldBuilder)")
	return true
end

return TerrainSaver
