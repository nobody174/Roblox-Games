--==============================--
-- WORLD INITIALIZER
--==============================--
-- Orchestrator for building the entire game world
-- Loads all islands, boss platforms, bridges, and portals
-- Uses dependency injection for clean module separation
-- Executes in deterministic order using ipairs
--==============================--

local Bridges = require(script.Parent.Systems.Bridges)
local Portals = require(script.Parent.Systems.Portals)

local Islands = {
	require(script.Parent.Islands.Island_Hub),
	require(script.Parent.Islands.Island_01_WhisperWoods),
	require(script.Parent.Islands.Island_02_FoggyFields),
	require(script.Parent.Islands.Island_03_GloomyGraveyard),
	require(script.Parent.Islands.Island_04_ElectroAlley),
	require(script.Parent.Islands.Island_05_FrostbiteCaverns),
	require(script.Parent.Islands.Island_06_SunkenSpiritReef),
	require(script.Parent.Islands.Island_07_ClowtowerDistrict),
	require(script.Parent.Islands.Island_08_AstralObservatory),
	require(script.Parent.Islands.Island_09_PhantomFortress),
	require(script.Parent.Islands.Island_10_TheRift),
	require(script.Parent.Islands.Island_11_EternityNexus),
}

local BossPlatforms = {
	require(script.Parent.Bosses.BossPlatform_01),
	require(script.Parent.Bosses.BossPlatform_02),
	require(script.Parent.Bosses.BossPlatform_03),
	require(script.Parent.Bosses.BossPlatform_04),
	require(script.Parent.Bosses.BossPlatform_05),
}

local function initializeWorld()
	print("[WorldBuilder] 🌍 Initializing Ghost Catcher Tycoon world...")

	local zoneContainer = Instance.new("Folder")
	zoneContainer.Name = "ZoneContainer"
	zoneContainer.Parent = workspace

	local islandsFolder = Instance.new("Folder")
	islandsFolder.Name = "Islands"
	islandsFolder.Parent = zoneContainer

	local bossesFolder = Instance.new("Folder")
	bossesFolder.Name = "BossPlatforms"
	bossesFolder.Parent = zoneContainer

	local structuresFolder = Instance.new("Folder")
	structuresFolder.Name = "Structures"
	structuresFolder.Parent = zoneContainer

	print("[WorldBuilder] 📍 Creating islands...")
	local islandReferences = {}
	for index, islandModule in ipairs(Islands) do
		local islandFolder = islandModule.createIsland(islandsFolder)
		table.insert(islandReferences, islandFolder)
	end

	print("[WorldBuilder] 👹 Creating boss platforms...")
	local bossReferences = {}
	for index, bossModule in ipairs(BossPlatforms) do
		local bossFolder = bossModule.createBossPlatform(bossesFolder)
		table.insert(bossReferences, bossFolder)
	end

	print("[WorldBuilder] 🌉 Creating bridges...")
	Bridges.createAllBridges(structuresFolder)

	print("[WorldBuilder] 🌀 Creating portals...")
	Portals.createAllPortals(structuresFolder)

	print("\n" .. string.rep("=", 60))
	print("[WorldBuilder] ✅ WORLD INITIALIZATION COMPLETE")
	print(string.rep("=", 60))
	print("📊 Summary:")
	print("  • Islands created: " .. #islandReferences)
	print("  • Boss platforms created: " .. #bossReferences)
	print("  • Bridges created: 5")
	print("  • Portals created: 5")
	print("  • Total zones: " .. (#islandReferences + #bossReferences))
	print(string.rep("=", 60) .. "\n")

	return {
		zoneContainer = zoneContainer,
		islands = islandReferences,
		bosses = bossReferences,
	}
end

return { initializeWorld = initializeWorld }
