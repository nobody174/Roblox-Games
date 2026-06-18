--==============================--
-- BOSS PLATFORM 03
--==============================--
-- Theme: Sand arena platform
-- Purpose: Third major boss encounter
-- Layout: Desert terrain with scattered rocks
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local BOSS_DATA = {
	name = "Boss Arena 03",
	position = Vector3.new(0, 180, 625),
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
