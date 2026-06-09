# Ghost Catcher Tycoon — World Map & Layout

## Top-Down Overview (XZ Plane)

```
                    Z-AXIS (North to South)
                         ↓
    
    -500                  0                500               1000
     ←──────────────────────────────────────────────────────→ (X-AXIS)

         🏰 PHANTOM FORTRESS              🔮 ETERNITY NEXUS
         (500, 10, 2500)                 (1000, 10, 2000)
              ▓▓▓                              ▓▓▓
              ▓▓▓                              ▓▓▓
              ▓▓▓                              ▓▓▓

    🕰️  CLOCKTOWER DISTRICT
    (0, 10, 2500)
         ▓▓▓

              🌊 SUNKEN SPIRIT REEF        🌌 THE RIFT
              (500, 10, 2000)              (1000, 10, 1500)
                   ▓▓▓                          ▓▓▓
                   ▓▓▓                          ▓▓▓

    ❄️  FROSTBITE CAVERNS
    (0, 10, 1500)
         ▓▓▓


         🪦 GLOOMY GRAVEYARD            🔭 ASTRAL OBSERVATORY
         (0, 10, 1000)                  (-500, 10, 2000)
              ▓▓▓                              ▓▓▓
              ▓▓▓                              ▓▓▓


              🌲 WHISPER WOODS             ⚡ ELECTRO ALLEY
              (500, 10, 0)                 (-500, 10, 0)
                   ▓▓▓                         ▓▓▓
                   ▓▓▓                         ▓▓▓

                    🌫️ FOGGY FIELDS
                    (0, 10, 500)
                         ▓▓▓


              🏠 STARTING AREA / HUB
              (0, 10, 0)
                   ◉◉◉
              [SPAWN POINT]
```

---

## Island Details & Coordinates

| # | Island Name | Position | Terrain | Biome | Status |
|---|---|---|---|---|---|
| 1 | Starting Area / Hub | (0, 10, 0) | Grass | Spawn | ✅ Ready |
| 2 | Whisper Woods | (500, 10, 0) | Grass | Meadow | ⚠️ Trees as logs (polish) |
| 3 | Foggy Fields | (0, 10, 500) | Sand | Desert | ✅ Ready |
| 4 | Gloomy Graveyard | (0, 10, 1000) | Slate | Graveyard | ⚠️ No tombstones (polish) |
| 5 | Electro Alley | (-500, 10, 0) | Concrete | Tech | ✅ Neon pads + ground fixed |
| 6 | Frostbite Caverns | (0, 10, 1500) | Ice | Ice | ✅ Ready, cave obj pending |
| 7 | Sunken Spirit Reef | (500, 10, 2000) | Sand | Underwater | ✅ Ready |
| 8 | Clocktower District | (0, 10, 2500) | Concrete | Urban | ✅ Ready |
| 9 | Astral Observatory | (-500, 10, 2000) | Sand | Desert | ✅ Ready, telescope pending |
| 10 | Phantom Fortress | (500, 10, 2500) | Slate | Haunted | ✅ Ground ok, castle pending |
| 11 | The Rift | (1000, 10, 1500) | Slate | Glitch | ✅ Ground fixed |
| 12 | Eternity Nexus | (1000, 10, 2000) | Ice | Crystal | ✅ Ground fixed |

---

## Bridge Connections

The world is connected via **5 wooden bridges**:

1. **B1:** Hub → Whisper Woods (East bridge)
2. **B2:** Hub → Foggy Fields (South bridge)  
3. **B3:** Hub → Electro Alley (West bridge)
4. **B4:** Foggy Fields → Gloomy Graveyard (extended south)
5. **B5:** Gloomy Graveyard → Frostbite Caverns (far south)

---

## Visual Polish Phase — Pending Assets

| Zone | Asset Needed | Current | Target |
|---|---|---|---|
| Whisper Woods | Tree models | Logs (unanchored cylinders) | Full trees with leaves/branches |
| Gloomy Graveyard | Tombstone models | None visible | 3D tombstone/grave objects |
| Frostbite Caverns | Cave entrance | None | 3D cave opening structure |
| Astral Observatory | Telescope/observatory | None | Functional-looking telescope model |
| Phantom Fortress | Castle building | None | Castle walls/towers structure |

---

## Boss Arenas (Sky Layer)

**5 floating boss arenas at Y=130** (high above world):

1. Boss Arena 1 @ (500, 130, 0)
2. Boss Arena 2 @ (0, 130, 500)
3. Boss Arena 3 @ (0, 130, 1000)
4. Boss Arena 4 @ (-500, 130, 0)
5. Boss Arena 5 @ (0, 130, 1500)

Each has a glowing crystal marker and neon arena platform.

---

## How to Use This Map

- **Spawn Testing:** You always spawn at (0, 10, 0) in the green Starting Area
- **Navigation:** Walk onto bridges to reach connected islands
- **Development:** Use coordinates to place new objects or adjust island positions
- **Asset Placement:** Reference the island coordinates when importing 3D models
- **Polish Phase:** When adding assets, use coordinates to anchor them to the right island

---

## Copy to Studio

To sync these coordinates with your Studio world:
1. Copy the vscode `ZONE_AUTO_BUILDER.lua` file
2. Paste it into Studio's `ServerScriptService > ZoneAutoBuilder` script
3. Delete the existing `ZoneContainer` folder in Workspace
4. Run the game — new world will generate with corrected terrain materials

---

*Created with Claude Code | Last updated: 2026-06-09*
