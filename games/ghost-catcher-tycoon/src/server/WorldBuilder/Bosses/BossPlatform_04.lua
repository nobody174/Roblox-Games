--==============================--
-- BOSS PLATFORM 04
--==============================--
-- Theme: Tech/Neon arena platform
-- Purpose: Fourth major boss encounter
-- Layout: Concrete terrain with neon accents
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local BOSS_DATA = {
	name = "Boss Arena 04",
	position = Vector3.new(0, 180, 1250),
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
