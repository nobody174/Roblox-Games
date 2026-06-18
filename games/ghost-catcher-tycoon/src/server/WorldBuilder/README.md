# WorldBuilder System

A clean, modular world-generation system for Ghost Catcher Tycoon. Replaces procedural generation with deterministic, easy-to-customize zone definitions.

## Architecture Overview

```
WorldBuilder/
├── Systems/              (Shared utilities)
│   ├── Terrain.lua       (Terrain creation helpers)
│   ├── Props.lua         (Obstacle factory functions)
│   ├── Bridges.lua       (Bridge system)
│   └── Portals.lua       (Portal system)
├── Islands/              (One file per island)
│   ├── Island_Hub.lua
│   ├── Island_01_WhisperWoods.lua
│   ├── Island_02_FoggyFields.lua
│   ├── Island_03_GloomyGraveyard.lua
│   ├── Island_04_ElectroAlley.lua
│   ├── Island_05_FrostbiteCaverns.lua
│   ├── Island_06_SunkenSpiritReef.lua
│   ├── Island_07_ClowtowerDistrict.lua
│   ├── Island_08_AstralObservatory.lua
│   ├── Island_09_PhantomFortress.lua
│   ├── Island_10_TheRift.lua
│   └── Island_11_EternityNexus.lua
├── Bosses/               (One file per boss platform)
│   ├── BossPlatform_01.lua
│   ├── BossPlatform_02.lua
│   ├── BossPlatform_03.lua
│   ├── BossPlatform_04.lua
│   └── BossPlatform_05.lua
├── WorldInit.lua         (Orchestrator - builds entire world)
└── README.md             (This file)
```

## Getting Started

### Initialize the World

Add this to ServerScriptService:
```lua
local worldData = require(game.ServerScriptService.initWorld).buildWorld()
```

This will:
1. Create a `ZoneContainer` folder in Workspace
2. Build all 12 islands with terrain, obstacles, and recovery ladders
3. Create all 5 boss platforms
4. Connect all islands with bridges and portals
5. Print a completion summary to console

### Island Structure

Each island file follows this pattern:

```lua
local ISLAND_DATA = {
    name = "Island Name",
    position = Vector3.new(x, y, z),
    terrainMaterial = Enum.Material.Type,
    size = 350,
    obstacleType = "trees", -- or "cacti", "tombstones", etc
}

local function createIsland(parentFolder)
    -- Create island folder
    -- Build terrain with Terrain.createTerrainBase()
    -- Add terrain variation with Terrain.addTerrainVariation()
    -- Scatter obstacles using Props factory functions
    -- Create recovery ladders at fixed offsets
    -- Return folder reference
end

return { createIsland = createIsland }
```

## Systems Reference

### Terrain.lua
- `createTerrainBase(position, size, material, name)` — Fills rectangular terrain region
- `addTerrainVariation(position, size, material)` — Creates 8 random bumpy terrain balls
- `createBossPlatform(position, size, material)` — Creates floating boss arena terrain

### Props.lua
- `createTree(position)` — Wood trunk, 3×15×3 studs
- `createCactus(position)` — Neon cylinder, 2×8×2 studs
- `createTombstone(position)` — Concrete part, 2×5×0.5 studs
- `createIceBlock(position)` — Random-sized ball with ice material
- `createNeonPad(position)` — Cyan neon platform, 4×0.5×4 studs
- `createWater(position, size)` — Water part, default 30×2×30 studs
- `createRock(position)` — Random-sized concrete ball

### Bridges.lua
5 connecting bridges with fixed start/end positions and widths.
Call `createAllBridges(parentFolder)` to build all bridges.

### Portals.lua
5 inter-island portals with labeled destination zones.
Call `createAllPortals(parentFolder)` to build all portals.

## Adding a New Island

1. Create a file in `Islands/` folder
2. Require Terrain and Props systems
3. Define ISLAND_DATA table with position, material, size
4. Implement `createIsland(parentFolder)` function
5. Add to Islands array in WorldInit.lua

Example:
```lua
local Terrain = require(script.Parent.Parent.Systems.Terrain)
local Props = require(script.Parent.Parent.Systems.Props)

local ISLAND_DATA = {
    name = "My New Island",
    position = Vector3.new(1000, 10, 0),
    terrainMaterial = Enum.Material.Grass,
    size = 350,
    obstacleType = "trees",
}

local function createIsland(parentFolder)
    -- Your implementation
end

return { createIsland = createIsland }
```

## Key Design Principles

### Dependency Injection
All modules accept a `parentFolder` parameter instead of using FindFirstChild. This keeps dependencies explicit and modules decoupled.

### Ordered Building
Islands are built using `ipairs` for deterministic, predictable execution order. No reliance on table iteration order.

### DRY (Don't Repeat Yourself)
Terrain creation (`createBossPlatform`) and obstacle factory functions (`createTree`, `createRock`, etc) are shared across all islands to maintain consistency.

### Modular Architecture
- Each island is self-contained and testable independently
- Systems folder holds shared utilities that multiple islands use
- Easy to extend: add new island files without modifying existing code

## Recovery Ladder Positions

All islands use consistent recovery ladder offsets (fixed at island center ± offsets):
- North: (10, -1.134, -181.036) — rotated 30° X
- South: (10, -1.134, 181.036) — rotated -30° X
- East: (181.036, -1.134, 10) — rotated 30° Z
- West: (-181.036, -1.134, 10) — rotated -30° Z

## Island Progression

1. **Hub** — Safe spawn zone (0, 10, 0)
2. **Whisper Woods** — Easy entry zone, trees (500, 10, 0)
3. **Foggy Fields** — Desert with cacti (0, 10, 500)
4. **Gloomy Graveyard** — Haunted zone, tombstones (0, 10, 1000)
5. **Electro Alley** — Tech zone, neon pads (-500, 10, 0)
6. **Frostbite Caverns** — Ice with water (0, 10, 1500)
7. **Sunken Spirit Reef** — Underwater theme (500, 10, 2000)
8. **Clocktower District** — Urban tech zone (0, 10, 2500)
9. **Astral Observatory** — Desert with rocks (-500, 10, 2000)
10. **Phantom Fortress** — Haunted fortress, tombstones (500, 10, 2500)
11. **The Rift** — Mixed water + ice hazards (1000, 10, 1500)
12. **Eternity Nexus** — Prestige ice zone (1000, 10, 2000)

## Boss Platforms

5 floating arenas for major encounters, each with unique challenge layouts:
- Arena 01: Slate cliffs
- Arena 02: Ice walls
- Arena 03: Sand with rocks
- Arena 04: Concrete with neon pads
- Arena 05: Final arena with mixed elements + central spire

## Future Expansion

To add more islands:
1. Create new Island_XX file with unique number
2. Define position, terrain, and obstacles
3. Add to Islands array in WorldInit.lua
4. Update island progression documentation

To customize obstacles:
1. Modify Props.lua factory functions OR
2. Add new factory functions and use in islands

To change terrain generation:
1. Edit Terrain.lua helper functions
2. Adjust island ISLAND_DATA material property
3. Rebuild with WorldInit.lua
