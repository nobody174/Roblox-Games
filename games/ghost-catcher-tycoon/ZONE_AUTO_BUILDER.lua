--
-- Ghost Catcher Tycoon — Zone Auto Builder (Phase 1)
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Procedural world generation: creates 11 biome zones with terrain, props, bridges, portals, ladders, and boss arenas.
--
local workspace = game:GetService("Workspace")
local terrain = workspace.Terrain

print("[ZoneAutoBuilder] Starting Phase 1 zone construction...")

local existingZones = workspace:FindFirstChild("ZoneContainer")
if existingZones then
	print("[ZoneAutoBuilder] ✅ Zones already built - skipping")
	return
end

local zoneContainer = Instance.new("Folder")
zoneContainer.Name = "ZoneContainer"
zoneContainer.Parent = workspace

print("[ZoneAutoBuilder] ✅ Created ZoneContainer")

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

local function createTerrainBase(position, size, material, name)
	print("[ZoneAutoBuilder] Creating terrain: " .. name)
	terrain:FillRegion(
		Region3.new(position - Vector3.new(size/2, 10, size/2), position + Vector3.new(size/2, 5, size/2)):ExpandToGrid(4),
		4,
		material
	)
end

local function addTerrainVariation(position, size, material)
	for i = 1, 8 do
		local randomX = position.X + math.random(-size/3, size/3)
		local randomZ = position.Z + math.random(-size/3, size/3)
		local bumpPos = Vector3.new(randomX, position.Y, randomZ)
		terrain:FillBall(bumpPos, 20, material)
	end
end

local function createTree(position)
	local trunk = Instance.new("Part")
	trunk.Name = "Tree"
	trunk.Shape = Enum.PartType.Cylinder
	trunk.Size = Vector3.new(3, 15, 3)
	trunk.Color = Color3.fromRGB(100, 70, 40)
	trunk.Material = Enum.Material.Wood
	trunk.TopSurface = Enum.SurfaceType.Smooth
	trunk.BottomSurface = Enum.SurfaceType.Smooth
	trunk.Position = position + Vector3.new(0, 8, 0)
	trunk.CanCollide = true
	return trunk
end

local function createCactus(position)
	local cactus = Instance.new("Part")
	cactus.Name = "Cactus"
	cactus.Shape = Enum.PartType.Cylinder
	cactus.Size = Vector3.new(2, 8, 2)
	cactus.Color = Color3.fromRGB(100, 180, 50)
	cactus.Material = Enum.Material.Neon
	cactus.Position = position + Vector3.new(0, 4, 0)
	cactus.CanCollide = true
	return cactus
end

local function createTombstone(position)
	local stone = Instance.new("Part")
	stone.Name = "Tombstone"
	stone.Size = Vector3.new(2, 5, 0.5)
	stone.Color = Color3.fromRGB(100, 100, 100)
	stone.Material = Enum.Material.Concrete
	stone.Position = position + Vector3.new(0, 2.5, 0)
	stone.CanCollide = true
	return stone
end

local function createIceBlock(position)
	local ice = Instance.new("Part")
	ice.Name = "IceBlock"
	ice.Shape = Enum.PartType.Ball
	ice.Size = Vector3.new(math.random(4, 10), math.random(4, 10), math.random(4, 10))
	ice.Color = Color3.fromRGB(200, 230, 255)
	ice.Material = Enum.Material.Ice
	ice.Transparency = 0.2
	ice.Position = position
	ice.CanCollide = true
	return ice
end

local function createNeonPad(position)
	local pad = Instance.new("Part")
	pad.Name = "NeonPad"
	pad.Size = Vector3.new(4, 0.5, 4)
	pad.Color = Color3.fromRGB(0, 255, 255)
	pad.Material = Enum.Material.Neon
	pad.CanCollide = true
	pad.Position = position
	return pad
end

local function createBridge(startPos, endPos, width)
	local distance = (endPos - startPos).Magnitude
	local midpoint = (startPos + endPos) / 2

	local bridge = Instance.new("Part")
	bridge.Name = "Bridge"
	bridge.Size = Vector3.new(width, 2, distance)
	bridge.Color = Color3.fromRGB(139, 69, 19)
	bridge.Material = Enum.Material.Wood
	bridge.TopSurface = Enum.SurfaceType.Smooth
	bridge.BottomSurface = Enum.SurfaceType.Smooth
	bridge.CanCollide = true
	bridge.Anchored = true
	bridge.Parent = workspace

	bridge.CFrame = CFrame.lookAlong(midpoint, (endPos - startPos).Unit)

	print("[ZoneAutoBuilder] Bridge created: " .. distance .. " studs")
	return bridge
end

local function createPortal(position, name, targetZone)
	local portal = Instance.new("Part")
	portal.Name = "Portal_" .. name
	portal.Shape = Enum.PartType.Ball
	portal.Size = Vector3.new(3, 3, 3)
	portal.Color = Color3.fromRGB(0, 255, 255)
	portal.Material = Enum.Material.Neon
	portal.CanCollide = false
	portal.Position = position

	local light = Instance.new("PointLight")
	light.Brightness = 2
	light.Range = 15
	light.Color = Color3.fromRGB(0, 255, 255)
	light.Parent = portal

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.MaxDistance = 50
	billboard.Parent = portal

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 0.5
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
	textLabel.TextSize = 12
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = "→ " .. targetZone
	textLabel.Parent = billboard

	return portal
end

local function createStructure(structureType, position, parent)
	local structureFolder = Instance.new("Folder")
	structureFolder.Name = structureType
	structureFolder.Parent = parent

	if structureType == "guard_tower" then
		local base = Instance.new("Part")
		base.Name = "TowerBase"
		base.Size = Vector3.new(15, 2, 15)
		base.Color = Color3.fromRGB(120, 80, 40)
		base.Material = Enum.Material.Concrete
		base.Position = position
		base.Anchored = true
		base.CanCollide = true
		base.Parent = structureFolder

		local tower = Instance.new("Part")
		tower.Name = "TowerPole"
		tower.Shape = Enum.PartType.Cylinder
		tower.Size = Vector3.new(4, 30, 4)
		tower.Color = Color3.fromRGB(100, 100, 100)
		tower.Material = Enum.Material.Concrete
		tower.Position = position + Vector3.new(0, 15, 0)
		tower.Anchored = true
		tower.CanCollide = true
		tower.Parent = structureFolder

		local platform = Instance.new("Part")
		platform.Name = "TowerPlatform"
		platform.Size = Vector3.new(12, 1, 12)
		platform.Color = Color3.fromRGB(80, 60, 40)
		platform.Material = Enum.Material.Wood
		platform.Position = position + Vector3.new(0, 30, 0)
		platform.Anchored = true
		platform.CanCollide = true
		platform.Parent = structureFolder

	elseif structureType == "watchtower" then
		local base = Instance.new("Part")
		base.Name = "WatchtowerBase"
		base.Size = Vector3.new(10, 2, 10)
		base.Color = Color3.fromRGB(150, 100, 50)
		base.Material = Enum.Material.Concrete
		base.Position = position
		base.Anchored = true
		base.CanCollide = true
		base.Parent = structureFolder

		for i = 1, 3 do
			local section = Instance.new("Part")
			section.Name = "TowerSection_" .. i
			section.Size = Vector3.new(10 - (i * 2), 3, 10 - (i * 2))
			section.Color = Color3.fromRGB(130 - (i * 10), 90 - (i * 5), 50)
			section.Material = Enum.Material.Concrete
			section.Position = position + Vector3.new(0, 2 + (i * 3), 0)
			section.Anchored = true
			section.CanCollide = true
			section.Parent = structureFolder
		end

	elseif structureType == "fountain" then
		local base = Instance.new("Part")
		base.Name = "FountainBase"
		base.Shape = Enum.PartType.Ball
		base.Size = Vector3.new(8, 8, 8)
		base.Color = Color3.fromRGB(150, 150, 150)
		base.Material = Enum.Material.Concrete
		base.Position = position
		base.Anchored = true
		base.CanCollide = true
		base.Parent = structureFolder

		local jet = Instance.new("Part")
		jet.Name = "WaterJet"
		jet.Shape = Enum.PartType.Cylinder
		jet.Size = Vector3.new(1, 10, 1)
		jet.Color = Color3.fromRGB(100, 150, 200)
		jet.Material = Enum.Material.Neon
		jet.Position = position + Vector3.new(0, 10, 0)
		jet.Anchored = true
		jet.CanCollide = false
		jet.Parent = structureFolder

	elseif structureType == "arch_entrance" then
		local leftPillar = Instance.new("Part")
		leftPillar.Name = "LeftPillar"
		leftPillar.Size = Vector3.new(4, 25, 4)
		leftPillar.Color = Color3.fromRGB(150, 150, 150)
		leftPillar.Material = Enum.Material.Concrete
		leftPillar.Position = position + Vector3.new(-8, 12, 0)
		leftPillar.Anchored = true
		leftPillar.CanCollide = true
		leftPillar.Parent = structureFolder

		local rightPillar = Instance.new("Part")
		rightPillar.Name = "RightPillar"
		rightPillar.Size = Vector3.new(4, 25, 4)
		rightPillar.Color = Color3.fromRGB(150, 150, 150)
		rightPillar.Material = Enum.Material.Concrete
		rightPillar.Position = position + Vector3.new(8, 12, 0)
		rightPillar.Anchored = true
		rightPillar.CanCollide = true
		rightPillar.Parent = structureFolder

		local archTop = Instance.new("Part")
		archTop.Name = "ArchTop"
		archTop.Size = Vector3.new(18, 3, 4)
		archTop.Color = Color3.fromRGB(140, 140, 140)
		archTop.Material = Enum.Material.Concrete
		archTop.Position = position + Vector3.new(0, 25, 0)
		archTop.Anchored = true
		archTop.CanCollide = true
		archTop.Parent = structureFolder
	end

	print("[ZoneAutoBuilder] ✅ Structure created: " .. structureType)
	return structureFolder
end

-- ============================================================================
-- ZONE CREATION
-- ============================================================================

local function createZone(zoneData)
	print("[ZoneAutoBuilder] Building zone: " .. zoneData.name)

	local zoneFolder = Instance.new("Folder")
	zoneFolder.Name = zoneData.name
	zoneFolder.Parent = zoneContainer

	createTerrainBase(zoneData.position, 350, zoneData.terrainMaterial, zoneData.name)
	addTerrainVariation(zoneData.position, 350, zoneData.terrainMaterial)

	if zoneData.biome == "meadow" then
		for i = 1, 5 do
			local tree = createTree(zoneData.position + Vector3.new(math.random(-80, 80), 20, math.random(-80, 80)))
			tree.Parent = zoneFolder
		end
	elseif zoneData.biome == "desert" then
		for i = 1, 4 do
			local cactus = createCactus(zoneData.position + Vector3.new(math.random(-80, 80), 20, math.random(-80, 80)))
			cactus.Parent = zoneFolder
		end
	elseif zoneData.biome == "frost" then
		for i = 1, 6 do
			local ice = createIceBlock(zoneData.position + Vector3.new(math.random(-80, 80), 20, math.random(-80, 80)))
			ice.Parent = zoneFolder
		end
	elseif zoneData.biome == "haunted" then
		for i = 1, 5 do
			local stone = createTombstone(zoneData.position + Vector3.new(math.random(-80, 80), 20, math.random(-80, 80)))
			stone.Parent = zoneFolder
		end
	elseif zoneData.biome == "tech" then
		for i = 1, 4 do
			local pad = createNeonPad(zoneData.position + Vector3.new(math.random(-60, 60), 20, math.random(-60, 60)))
			pad.Parent = zoneFolder
		end
	end

	local ladderConfigs = {
		-- North ladder
		{10, -1.134, -181.036, 30, 0, 0},
		-- South ladder
		{10, -1.134, 181.036, -30, 0, 0},
		-- East ladder
		{181.036, -1.134, 10, 0, 0, 30},
		-- West ladder
		{-181.036, -1.134, 10, 0, 0, -30},
	}

	local laddersFolder = Instance.new("Folder")
	laddersFolder.Name = "Ladders"
	laddersFolder.Parent = zoneFolder

	for _, config in ipairs(ladderConfigs) do
		local ladder = Instance.new("TrussPart")
		ladder.Name = "RecoveryLadder"
		ladder.Anchored = true
		ladder.CanCollide = true
		ladder.Size = Vector3.new(2, 20, 2)

		local offsetX, offsetY, offsetZ = config[1], config[2], config[3]
		local oriX, oriY, oriZ = config[4], config[5], config[6]

		ladder.Position = Vector3.new(zoneData.position.X + offsetX, zoneData.position.Y + offsetY, zoneData.position.Z + offsetZ)
		ladder.Orientation = Vector3.new(oriX, oriY, oriZ)

		ladder.Parent = laddersFolder
	end

	print("[ZoneAutoBuilder] ✅ " .. zoneData.name .. " complete (with ladders)")
end

local function createHub()
	print("[ZoneAutoBuilder] Building HUB")

	local hubFolder = Instance.new("Folder")
	hubFolder.Name = "Hub"
	hubFolder.Parent = zoneContainer

	createTerrainBase(Vector3.new(0, 10, 0), 250, Enum.Material.Grass, "Hub")

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnPoint"
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Color = Color3.fromRGB(0, 255, 0)
	spawn.Material = Enum.Material.Neon
	spawn.CanCollide = true
	spawn.Position = Vector3.new(0, 30, 0)
	spawn.Parent = hubFolder

	print("[ZoneAutoBuilder] ✅ HUB complete")
end

-- ============================================================================
-- BRIDGES
-- ============================================================================

local function createAllBridges()
	print("[ZoneAutoBuilder] Building bridges...")

	local bridgesFolder = Instance.new("Folder")
	bridgesFolder.Name = "Bridges"
	bridgesFolder.Parent = zoneContainer

	local b1 = createBridge(Vector3.new(125, 12, 0), Vector3.new(325, 12, 0), 10)
	b1.Parent = bridgesFolder

	local b2 = createBridge(Vector3.new(0, 12, 125), Vector3.new(0, 12, 375), 10)
	b2.Parent = bridgesFolder

	local b3 = createBridge(Vector3.new(-100, 12, 0), Vector3.new(-400, 12, 0), 10)
	b3.Parent = bridgesFolder

	local b4 = createBridge(Vector3.new(0, 12, 625), Vector3.new(0, 12, 875), 10)
	b4.Parent = bridgesFolder

	local b5 = createBridge(Vector3.new(0, 12, 1125), Vector3.new(0, 12, 1375), 10)
	b5.Parent = bridgesFolder

	print("[ZoneAutoBuilder] ✅ All bridges created")
end

-- ============================================================================
-- BOSS ARENAS IN SKY
-- ============================================================================

local function createBossArenas()
	print("[ZoneAutoBuilder] Building boss arenas in sky...")

	local bossFolder = Instance.new("Folder")
	bossFolder.Name = "BossArenas"
	bossFolder.Parent = zoneContainer

	-- 5 Boss arenas floating high in the sky
	local bossArenas = {
		{name = "BossArena_1", position = Vector3.new(500, 130, 0)},
		{name = "BossArena_2", position = Vector3.new(0, 130, 500)},
		{name = "BossArena_3", position = Vector3.new(0, 130, 1000)},
		{name = "BossArena_4", position = Vector3.new(-500, 130, 0)},
		{name = "BossArena_5", position = Vector3.new(0, 130, 1500)},
	}

	for _, arena in ipairs(bossArenas) do
		terrain:FillRegion(
			Region3.new(arena.position - Vector3.new(75, 5, 75), arena.position + Vector3.new(75, 1, 75)):ExpandToGrid(4),
			4,
			Enum.Material.Rock
		)

		local arenaFolder = Instance.new("Folder")
		arenaFolder.Name = arena.name
		arenaFolder.Parent = bossFolder

		local crystal = Instance.new("Part")
		crystal.Name = "BossMarker"
		crystal.Shape = Enum.PartType.Ball
		crystal.Size = Vector3.new(5, 5, 5)
		crystal.Color = Color3.fromRGB(255, 100, 255)
		crystal.Material = Enum.Material.Neon
		crystal.CanCollide = false
		crystal.Position = arena.position + Vector3.new(0, 10, 0)
		crystal.Parent = arenaFolder

		local light = Instance.new("PointLight")
		light.Brightness = 3
		light.Range = 30
		light.Color = Color3.fromRGB(255, 100, 255)
		light.Parent = crystal

		print("[ZoneAutoBuilder] ✅ " .. arena.name .. " created at Y=" .. arena.position.Y)
	end

	print("[ZoneAutoBuilder] ✅ All boss arenas created")
end

-- ============================================================================
-- PORTAL CREATION
-- ============================================================================

local function createAllPortals()
	print("[ZoneAutoBuilder] Building portals...")

	local portalsFolder = Instance.new("Folder")
	portalsFolder.Name = "Portals"
	portalsFolder.Parent = zoneContainer

	local portals = {
		{pos = Vector3.new(500, 15, 150), name = "Meadow_to_Desert", target = "Desert"},
		{pos = Vector3.new(0, 15, 625), name = "Desert_to_Frost", target = "Frost"},
		{pos = Vector3.new(0, 15, 1250), name = "Frost_to_Tech", target = "Tech"},
		{pos = Vector3.new(-500, 15, 150), name = "Haunted_to_Boss", target = "Boss Arena"},
		{pos = Vector3.new(0, 15, 1650), name = "Tech_to_Boss", target = "Boss Arena"},
	}

	for _, p in ipairs(portals) do
		local portal = createPortal(p.pos, p.name, p.target)
		portal.Parent = portalsFolder
	end

	print("[ZoneAutoBuilder] ✅ All portals created")
end

-- ============================================================================
-- ZONE DATA
-- ============================================================================

local ZONES = {
	{name = "Zone_1_Meadow", position = Vector3.new(500, 10, 0), biome = "meadow", terrainMaterial = Enum.Material.Grass},
	{name = "Zone_2_Desert", position = Vector3.new(0, 10, 500), biome = "desert", terrainMaterial = Enum.Material.Sand},
	{name = "Zone_3_Frost", position = Vector3.new(0, 10, 1000), biome = "frost", terrainMaterial = Enum.Material.Snow},
	{name = "Zone_4_Haunted", position = Vector3.new(-500, 10, 0), biome = "haunted", terrainMaterial = Enum.Material.Grass},
	{name = "Zone_5_Tech", position = Vector3.new(0, 10, 1500), biome = "tech", terrainMaterial = Enum.Material.Concrete},
	-- Additional zones for full progression (ZoneData: Sunken Spirit Reef onwards)
	{name = "Zone_6_Reef", position = Vector3.new(500, 10, 2000), biome = "meadow", terrainMaterial = Enum.Material.Sand},
	{name = "Zone_7_Clock", position = Vector3.new(0, 10, 2500), biome = "tech", terrainMaterial = Enum.Material.Concrete},
	{name = "Zone_8_Astral", position = Vector3.new(-500, 10, 2000), biome = "meadow", terrainMaterial = Enum.Material.Grass},
	{name = "Zone_9_Phantom", position = Vector3.new(500, 10, 2500), biome = "haunted", terrainMaterial = Enum.Material.Grass},
	{name = "Zone_10_Rift", position = Vector3.new(1000, 10, 1500), biome = "tech", terrainMaterial = Enum.Material.Neon},
	{name = "Zone_11_Eternity", position = Vector3.new(1000, 10, 2000), biome = "meadow", terrainMaterial = Enum.Material.Grass},
}

-- ============================================================================
-- MAIN BUILD SEQUENCE
-- ============================================================================

print("[ZoneAutoBuilder] Phase 1 construction starting...")

createHub()

for _, zoneData in ipairs(ZONES) do
	createZone(zoneData)
	task.wait(0.1)
end

createAllBridges()
createAllPortals()
createBossArenas()

print("[ZoneAutoBuilder] ✅ PHASE 1 COMPLETE!")
print("[ZoneAutoBuilder] Zones: Hub + 11 Main + 5 Boss Arenas")
print("[ZoneAutoBuilder] Bridges: 5 (connecting zones)")
print("[ZoneAutoBuilder] Ladders: 4 per zone (recovery)")
print("[ZoneAutoBuilder] Portals: 5 (zone progression)")
print("[ZoneAutoBuilder] Props: Trees, Cacti, Tombstones, Ice, Neon pads")

-- Built with assistance from Claude Code by Anthropic.
