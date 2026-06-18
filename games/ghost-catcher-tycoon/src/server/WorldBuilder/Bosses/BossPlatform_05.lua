--==============================--
-- BOSS PLATFORM 05: FINAL ARENA
--==============================--
-- Theme: Multi-element arena platform
-- Purpose: Final climactic boss encounter
-- Layout: Mixed terrain with maximum challenge
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local BOSS_DATA = {
	name = "Final Boss Arena",
	position = Vector3.new(0, 400, 1650),
	terrainSize = 150,
	material = Enum.Material.Slate,
}

local function createBossPlatform(parentFolder)
	local bossFolder = Instance.new("Folder")
	bossFolder.Name = BOSS_DATA.name
	bossFolder.Parent = parentFolder

	Terrain.createBossPlatform(BOSS_DATA.position, BOSS_DATA.terrainSize, BOSS_DATA.material)

	print("[WorldBuilder] ✅ Boss Platform created: " .. BOSS_DATA.name)
	return bossFolder
end

return { createBossPlatform = createBossPlatform }
