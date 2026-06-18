--==============================--
-- PROP FACTORIES
--==============================--
-- Reusable factory functions for creating terrain decorations and obstacles
-- Used by islands and boss platforms for consistent prop generation
--==============================--

--==============================--
-- TREE PROP
--==============================--

local function createTree(position)
	-- Create a simple tree: cylindrical trunk with brown wood material
	-- Parameters: position (Vector3)
	-- Returns: Part

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

--==============================--
-- CACTUS PROP
--==============================--

local function createCactus(position)
	-- Create a neon cactus obstacle (desert zones)
	-- Parameters: position (Vector3)
	-- Returns: Part

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

--==============================--
-- TOMBSTONE PROP
--==============================--

local function createTombstone(position)
	-- Create a gravestone obstacle (graveyard zones)
	-- Parameters: position (Vector3)
	-- Returns: Part

	local stone = Instance.new("Part")
	stone.Name = "Tombstone"
	stone.Size = Vector3.new(2, 5, 0.5)
	stone.Color = Color3.fromRGB(100, 100, 100)
	stone.Material = Enum.Material.Concrete
	stone.Position = position + Vector3.new(0, 2.5, 0)
	stone.CanCollide = true

	return stone
end

--==============================--
-- ICE BLOCK PROP
--==============================--

local function createIceBlock(position)
	-- Create a random-sized ice block obstacle (ice zones)
	-- Parameters: position (Vector3)
	-- Returns: Part

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

--==============================--
-- NEON PAD PROP
--==============================--

local function createNeonPad(position)
	-- Create a glowing neon platform (tech zones)
	-- Parameters: position (Vector3)
	-- Returns: Part

	local pad = Instance.new("Part")
	pad.Name = "NeonPad"
	pad.Size = Vector3.new(4, 0.5, 4)
	pad.Color = Color3.fromRGB(0, 255, 255)
	pad.Material = Enum.Material.Neon
	pad.CanCollide = true
	pad.Position = position

	return pad
end

--==============================--
-- WATER PROP
--==============================--

local function createWater(position, size)
	-- Create a water obstacle (water zones)
	-- Parameters: position (Vector3), size (optional, defaults to 30)
	-- Returns: Part

	local water = Instance.new("Part")
	water.Name = "Water"
	water.Size = Vector3.new(size or 30, 2, size or 30)
	water.Color = Color3.fromRGB(0, 100, 200)
	water.Material = Enum.Material.Water
	water.CanCollide = true
	water.Transparency = 0.3
	water.Position = position

	return water
end

--==============================--
-- ROCK PROP
--==============================--

local function createRock(position)
	-- Create a random-sized rock obstacle
	-- Parameters: position (Vector3)
	-- Returns: Part

	local rock = Instance.new("Part")
	rock.Name = "Rock"
	rock.Shape = Enum.PartType.Ball
	rock.Size = Vector3.new(math.random(5, 15), math.random(5, 15), math.random(5, 15))
	rock.Color = Color3.fromRGB(120, 120, 120)
	rock.Material = Enum.Material.Concrete
	rock.CanCollide = true
	rock.Position = position

	return rock
end

--==============================--
-- CLIFF PROP
--==============================--

local function createCliff(position, height)
	-- Create a tall cliff obstacle
	-- Parameters: position (Vector3), height (optional, defaults to 50)
	-- Returns: Part

	local cliff = Instance.new("Part")
	cliff.Name = "Cliff"
	cliff.Size = Vector3.new(40, height or 50, 40)
	cliff.Color = Color3.fromRGB(100, 100, 100)
	cliff.Material = Enum.Material.Concrete
	cliff.CanCollide = true
	cliff.Position = position

	return cliff
end

--==============================--
-- EXPORTS
--==============================--

return {
	createTree = createTree,
	createCactus = createCactus,
	createTombstone = createTombstone,
	createIceBlock = createIceBlock,
	createNeonPad = createNeonPad,
	createWater = createWater,
	createRock = createRock,
	createCliff = createCliff,
}
