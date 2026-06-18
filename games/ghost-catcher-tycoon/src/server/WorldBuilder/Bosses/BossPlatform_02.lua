--==============================--
-- BOSS PLATFORM 02
--==============================--
-- Theme: Ice arena platform
-- Purpose: Second major boss encounter
-- Layout: Slippery ice terrain with obstacles
--==============================--

local Terrain = require(script.Parent.Parent.Systems.Terrain)

local BOSS_DATA = {
	name = "Boss Arena 02",
	position = Vector3.new(-500, 180, 150),
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
