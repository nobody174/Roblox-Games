# World Structure Guide — Ghost Catcher Tycoon

## Current State Summary

### ✅ Completed
- **Hub/Starting Area** — Green spawn platform, safe zone
- **11 Main Islands** — All 11 zones built with correct positions, terrain, and obstacles
- **Terrain Materials** — Fixed (Neon/Glass → Concrete/Slate/Ice)
- **Recovery Ladders** — 4 per zone for player safety
- **Bridges** — 5 bridges connecting zones
- **Boss Arenas** — 5 floating arenas in sky
- **Portals** — 5 warp portals for navigation

### ⚠️ Visual Polish Phase (Deferred)
- **Whisper Woods** — Tree models (currently just logs/cylinders)
- **Gloomy Graveyard** — Tombstone 3D models
- **Frostbite Caverns** — Cave entrance structure
- **Astral Observatory** — Telescope/building model
- **Phantom Fortress** — Castle structure

---

## File Structure

### vscode Files
```
ghost-catcher-tycoon/
├── ZONE_AUTO_BUILDER.lua          ← Defines all 12 zones with positions & terrain
├── WORLD_MAP.md                   ← This map (visual reference)
├── WORLD_STRUCTURE_GUIDE.md       ← You are here
├── ISLAND_REPORT_TEMPLATE.md      ← For tracking island status
├── PERFORMANCE_FIX.md             ← Ghost AI optimization notes
├── QUICK_FIX_UPDATE.md            ← Recent fixes applied
└── src/
    ├── server/
    │   ├── ZoneManager.lua        ← Detects which zone player is in
    │   ├── GhostAI.lua            ← Ghost behavior by rarity
    │   ├── MainServer_Phase4_Extended.lua
    │   └── ...
    └── shared/
        └── ZoneData.lua           ← Zone names, descriptions, ghost pools
```

### Studio Structure
```
ServerScriptService/
├── MainServer_Phase4_Extended
├── ZoneAutoBuilder                ← Generates the world
├── ZoneManager                    ← Tracks player location
├── GhostAI                        ← Controls ghost behavior
└── ...

Workspace/
├── Terrain                        ← Roblox terrain material layer
└── ZoneContainer/
    ├── Hub                        ← Starting Area folder
    ├── Whisper Woods              ← Island folders
    ├── Foggy Fields
    ├── Gloomy Graveyard
    ├── Electro Alley
    ├── Frostbite Caverns
    ├── Sunken Spirit Reef
    ├── Clocktower District
    ├── Astral Observatory
    ├── Phantom Fortress
    ├── The Rift
    ├── Eternity Nexus
    ├── Bridges
    ├── Ladders (per zone)
    ├── Portals
    └── BossArenas
```

---

## How Zones Are Built

### 1. **ZoneAutoBuilder.lua (Studio Script)**
- Runs when game starts
- Reads the ZONES table
- For each zone:
  - Creates terrain ground (350 studs diameter)
  - Adds terrain variation (random bumps)
  - Spawns biome-specific obstacles (trees, cacti, ice, etc.)
  - Places 4 recovery ladders at cardinal directions
  - Creates zones as Folder structure in ZoneContainer

### 2. **ZoneManager.lua (Server Module)**
- Continuously detects which zone each player is in
- Uses raycasting from player position to check terrain
- Updates player's "CurrentZone" attribute
- Triggers zone-specific ghost spawning

### 3. **MainServer_Phase4_Extended.lua (Main Server)**
- Orchestrates global ghost spawning
- References ZoneManager to spawn ghosts per zone
- Handles player progression and scoring

---

## Island Details Quick Reference

### Island 1: Starting Area / Hub
- **Coords:** (0, 0, 0)
- **Terrain:** Grass
- **Size:** 250 studs
- **Obstacles:** None (safe spawn zone)
- **Status:** ✅ Ready

### Island 2: Whisper Woods (Meadow)
- **Coords:** (500, 0, 0) — East of Hub
- **Terrain:** Grass
- **Obstacles:** Trees (currently unanchored cylinders — logs)
- **Status:** ⚠️ Needs tree 3D models
- **Polish:** Find or create tree assets with leaves/foliage

### Island 3: Foggy Fields (Desert)
- **Coords:** (0, 0, 500) — South of Hub
- **Terrain:** Sand
- **Obstacles:** Cacti
- **Status:** ✅ Ready

### Island 4: Gloomy Graveyard
- **Coords:** (0, 0, 1000) — South of Foggy Fields
- **Terrain:** Slate
- **Obstacles:** Tombstones (not visible currently)
- **Status:** ⚠️ Needs 3D tombstone models
- **Polish:** Import or create tombstone/grave objects

### Island 5: Electro Alley (Tech)
- **Coords:** (-500, 0, 0) — West of Hub
- **Terrain:** ~~Neon~~ **Concrete** (fixed — Neon not valid for terrain)
- **Obstacles:** Neon pads (Neon cylinders = ok for visual distinction)
- **Status:** ✅ Ready (ground material corrected)

### Island 6: Frostbite Caverns (Ice)
- **Coords:** (0, 0, 1500) — Far south
- **Terrain:** Ice
- **Obstacles:** None
- **Status:** ⚠️ Needs cave entrance structure
- **Polish:** Add 3D cave opening/entrance model

### Island 7: Sunken Spirit Reef
- **Coords:** (500, 0, 2000) — Southeast corner
- **Terrain:** Sand
- **Obstacles:** Water theme
- **Status:** ✅ Ready

### Island 8: Clocktower District
- **Coords:** (0, 0, 2500) — South edge
- **Terrain:** Concrete
- **Obstacles:** Neon pads
- **Status:** ✅ Ready

### Island 9: Astral Observatory
- **Coords:** (-500, 0, 2000) — Southwest corner
- **Terrain:** Sand
- **Obstacles:** Rocks
- **Status:** ⚠️ Needs telescope/observatory building model
- **Polish:** Add functioning-looking telescope structure

### Island 10: Phantom Fortress
- **Coords:** (500, 0, 2500) — Southeast corner
- **Terrain:** Slate
- **Obstacles:** Tombstones
- **Status:** ⚠️ Needs castle building structure
- **Polish:** Add castle walls, towers, fortifications

### Island 11: The Rift (Glitch Theme)
- **Coords:** (1000, 0, 1500) — East edge
- **Terrain:** ~~Neon~~ **Slate** (fixed)
- **Obstacles:** Water + Ice blocks
- **Status:** ✅ Ready (ground material corrected)

### Island 12: Eternity Nexus (Crystal)
- **Coords:** (1000, 0, 2000) — Far southeast
- **Terrain:** ~~Glass~~ **Ice** (fixed — Glass not valid for terrain)
- **Obstacles:** Ice blocks
- **Status:** ✅ Ready (ground material corrected)

---

## Terrain Materials Reference

### Valid Roblox Terrain Materials

| Material | Use Case | Island(s) |
|---|---|---|
| **Grass** | Meadow/natural | Whisper Woods, Starting Area |
| **Sand** | Desert/beach | Foggy Fields, Sunken Spirit Reef, Astral Observatory |
| **Slate** | Rocky/ancient | Gloomy Graveyard, Phantom Fortress, The Rift |
| **Concrete** | Urban/tech | Electro Alley, Clocktower District |
| **Ice** | Frozen/crystal | Frostbite Caverns, Eternity Nexus |
| **Snow** | Arctic | (Not currently used) |
| **Water** | Underwater | (Not used as base, only obstacles) |

### ❌ Invalid for Terrain (Only for Parts)
- **Neon** — Can't be terrain, but used for obstacle parts
- **Glass** — Can't be terrain, Ice is better for crystal theme
- **Wood, Metal, Plastic, etc.** — Only for parts, not terrain

---

## Adding 3D Models (Polish Phase)

When you're ready to add 3D assets, place them at the island coordinates:

1. **Find or create** the asset (tree, tombstone, etc.)
2. **Import to Studio** as a model
3. **Position** it at the island's center coordinates
4. **Anchor** it if it should be stationary
5. **Parent** it to the island's folder in ZoneContainer

**Example:** To add trees to Whisper Woods
- Island center: (500, 0, 0)
- Tree model should spawn within ±80 studs of center
- Parent tree to: `ZoneContainer > Whisper Woods` folder

---

## Connection & Navigation

### Bridges
Five bridges connect the islands, allowing players to walk between them:
- **Bridge 1:** Hub ↔ Whisper Woods (east)
- **Bridge 2:** Hub ↔ Foggy Fields (south)
- **Bridge 3:** Hub ↔ Electro Alley (west)
- **Bridge 4:** Foggy Fields ↔ Gloomy Graveyard (extended south)
- **Bridge 5:** Gloomy Graveyard ↔ Frostbite Caverns (far south)

### Recovery Ladders
Each island has **4 recovery ladders** at cardinal positions:
- North, South, East, West edges
- Allows players to get back on island if they fall

### Portals
5 portals provide fast travel between zones (optional shortcut).

---

## Testing the World

### 1. Verify Terrain Materials
- Spawn at Hub (green grass)
- Walk east → Whisper Woods should be grass ✅
- Walk south → Foggy Fields should be sand ✅
- Walk west → Electro Alley should be **concrete** (not green) ✅
- Walk far south → The Rift should be **slate** (not green) ✅
- Walk far southeast → Eternity Nexus should be **ice** (not green) ✅

### 2. Verify Ladders
- Walk to island edge
- Try climbing ladder — should be pullable back to safety

### 3. Verify Ghost Spawning
- Navigate to different islands
- Check server logs: should show zone name changing
- Ghosts should spawn in each zone (not in Starting Area)

### 4. Verify Bridges
- Walk from Hub onto bridge
- Should be walkable wooden path
- Cross to connected island

---

## Next Steps

1. **Sync vscode → Studio:** Copy updated ZONE_AUTO_BUILDER.lua to Studio script
2. **Regenerate world:** Delete ZoneContainer, restart server
3. **Test terrain:** Walk to each island, verify ground materials are correct
4. **Plan polish:** Decide which assets to import/create first
5. **Add models:** Follow the "Adding 3D Models" section above

---

*Reference guide for Ghost Catcher Tycoon world structure*
*Last updated: 2026-06-09*
