<!--
  Ghost Catcher Tycoon — Zone Layout Guide (Phase 1)
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Zone Layout & Building Guide — Phase 1

## Overview

**5 main zones** (350×350 studs each) connected by **physical bridges**
**Central hub** with spawn area
**Boss arenas** (150×150) floating in sky (Phase 2)

---

## Layout Map (Top-Down View)

```
                    [Boss 5 - Sky]
                         ↑
     [Zone 4]←Bridge→[Hub]←Bridge→[Zone 1]
     Haunted           ↑              Meadow
                    Bridge
                       ↓
                    [Zone 2]
                    Desert
                       ↓
                    Bridge
                       ↓
                    [Zone 3]
                    Frost
                       ↓
                    Bridge
                       ↓
                    [Zone 5]
                    Tech
                       ↓
                    [Boss Area]
```

---

## Zone Specifications

### Hub (Central Spawn Area)
- **Size:** 250×250 studs
- **Position:** (0, 10, 0) — center of map
- **Terrain:** Neutral stone/grass mix
- **Bridges to:** Zone 1 (East), Zone 4 (West), Zone 2 (South)
- **Purpose:** Spawn point, player orientation
- **Lighting:** Neutral white

### Zone 1 — Meadow (Whisper Woods + Foggy Fields merged)
- **Size:** 350×350 studs
- **Position:** (500, 10, 0) — East of Hub
- **Terrain Type:** Grass with small hills
- **Color Palette:** Green (#64964F), light blue sky
- **Props:** Trees, flowers, small streams, boulders
- **Lighting:** Warm yellow-green
- **Bridge To:** Hub (West), Zone 2 (South)

### Zone 2 — Desert
- **Size:** 350×350 studs
- **Position:** (0, 10, 500) — South of Hub
- **Terrain Type:** Sand with dunes
- **Color Palette:** Yellow (#FFD700), orange (#FFA500), tan
- **Props:** Cacti, sand formations, ruins, heat shimmer particles
- **Lighting:** Warm orange-yellow
- **Bridge To:** Hub (North), Zone 3 (South)

### Zone 3 — Frost (Frostbite Caverns)
- **Size:** 350×350 studs
- **Position:** (0, 10, 1000) — Far South
- **Terrain Type:** Snow with ice formations
- **Color Palette:** White (#FFFFFF), cyan (#00FFFF), light blue
- **Props:** Ice blocks, snow drifts, frozen crystals, glaciers
- **Lighting:** Cool blue-white
- **Bridge To:** Zone 2 (North), Zone 5 (South)

### Zone 4 — Haunted (Graveyard + Phantom Fortress merged)
- **Size:** 350×350 studs
- **Position:** (-500, 10, 0) — West of Hub
- **Terrain Type:** Dark grass with rocky outcrops
- **Color Palette:** Purple (#800050), black, dark gray
- **Props:** Tombstones, gothic structures, lanterns, chains, misty particles
- **Lighting:** Dark purple glow
- **Bridge To:** Hub (East), Zone 5 (South-East diagonal)

### Zone 5 — Tech (Astral Observatory + The Rift merged)
- **Size:** 350×350 studs
- **Position:** (0, 10, 1500) — Far South (past Frost)
- **Terrain Type:** Metal grating with neon patterns
- **Color Palette:** Cyan (#00FFFF), magenta (#FF00FF), dark gray
- **Props:** Neon tubes, metal structures, energy fields, holographic panels
- **Lighting:** Bright cyan-magenta
- **Bridge To:** Zone 3 (North), Boss Portal (Below/Up)

---

## Bridge Specifications

**All bridges:**
- **Width:** 10 studs
- **Height:** 2 studs above terrain
- **Material:** Stone or metal
- **Railings:** Optional (for visual polish)
- **Collideable:** YES (players can walk on them)

### Bridge 1: Hub ↔ Zone 1 (Meadow)
- **Start:** (125, 12, 0)
- **End:** (375, 12, 0)
- **Length:** 250 studs East
- **Type:** Stone arch

### Bridge 2: Hub ↔ Zone 2 (Desert)
- **Start:** (0, 12, 125)
- **End:** (0, 12, 375)
- **Length:** 250 studs South
- **Type:** Stone ramp (slight incline)

### Bridge 3: Hub ↔ Zone 4 (Haunted)
- **Start:** (-125, 12, 0)
- **End:** (-375, 12, 0)
- **Length:** 250 studs West
- **Type:** Gothic stone arch

### Bridge 4: Zone 2 ↔ Zone 3 (Desert → Frost)
- **Start:** (0, 12, 625)
- **End:** (0, 12, 875)
- **Length:** 250 studs South
- **Type:** Icy stone ramp

### Bridge 5: Zone 3 ↔ Zone 5 (Frost → Tech)
- **Start:** (0, 12, 1250)
- **End:** (0, 12, 1500)
- **Length:** 250 studs South
- **Type:** Metal grating

### Bridge 6: Zone 4 → Zone 5 (Haunted → Tech diagonal)
- **Start:** (-250, 12, 250)
- **End:** (0, 12, 1250)
- **Length:** Diagonal (∼1118 studs)
- **Type:** Dark stone with torches

---

## Terrain Building Instructions

### For Each Zone:

1. **Create terrain base**
   - Use Terrain Editor → Region Fill
   - Select appropriate material (Grass, Sand, Snow, etc.)
   - Fill 350×350 area at zone position
   - Height: Y = 10 (consistent with bridges)

2. **Add height variation**
   - Use Terrain Editor → Add with "Grow" brush
   - Create small hills/dunes/formations
   - Keep max height difference ±15 studs
   - Don't make it flat and boring!

3. **Add water/special effects** (optional)
   - Desert: Use sand particles for heat shimmer
   - Frost: Use ice blue particles
   - Haunted: Use fog/mist particles
   - Tech: Use neon glow particles

4. **Test walkability**
   - Jump around in each zone
   - Make sure bridges connect properly
   - Verify no clipping/gaps

---

## Lighting Setup (Per Zone)

Use **Lighting** service properties:

### Meadow
- Ambient: (0.7, 0.8, 0.6) — warm green
- OutdoorAmbient: (0.8, 0.9, 0.7)
- ClockTime: 14 (afternoon)

### Desert
- Ambient: (1.0, 0.8, 0.4) — warm orange
- OutdoorAmbient: (1.0, 0.9, 0.5)
- ClockTime: 16 (late afternoon, hot)

### Frost
- Ambient: (0.7, 0.8, 1.0) — cool blue
- OutdoorAmbient: (0.8, 0.9, 1.0)
- ClockTime: 10 (morning, icy)

### Haunted
- Ambient: (0.5, 0.3, 0.6) — dark purple
- OutdoorAmbient: (0.6, 0.4, 0.7)
- ClockTime: 20 (evening, spooky)

### Tech
- Ambient: (0.4, 0.8, 1.0) — neon cyan
- OutdoorAmbient: (0.5, 0.9, 1.0)
- ClockTime: 12 (neutral, artificial)

---

## Next Steps (Phase 2)

- [ ] Add decorations per zone
- [ ] Create boss arenas in sky (150×150 each)
- [ ] Add portals to boss areas
- [ ] Setup ZoneTriggers for lighting changes
- [ ] Add sound/music per zone
- [ ] Polish and test

---

## Coordinates Summary (Quick Reference)

```
Hub:      (0, 10, 0)
Zone 1:   (500, 10, 0) — East
Zone 2:   (0, 10, 500) — South
Zone 3:   (0, 10, 1000) — Far South
Zone 4:   (-500, 10, 0) — West
Zone 5:   (0, 10, 1500) — Far South
```

---

**Built with assistance from Claude Code by Anthropic.**
