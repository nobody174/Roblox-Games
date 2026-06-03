# Phase 4: Ghost Spawning & Catching Loop (Implemented 2026-06-03)

## What Was Built

### 1. **GhostStatGenerator.lua** (New)
**Location:** `src/shared/GhostStatGenerator.lua`

Generates randomized ghost stats based on rarity and personality:
- Takes ghost name → looks up rarity from GhostData
- Generates random personality from pool
- Calculates stats within rarity range:
  - CatchSpeed (difficulty)
  - EnergyPerMin (passive income)
  - TrainingCostMultiplier (cost to level up)
- Returns complete stat object

**Key methods:**
- `GenerateStatsForGhost(ghostName)` — Generate stats by name
- `GenerateRandomGhostOfRarity(rarity)` — Generate random ghost of specific rarity

### 2. **GhostInstanceBuilder.lua** (New)
**Location:** `src/shared/GhostInstanceBuilder.lua`

Creates visual ghost instances in the world:
- **Visual:** Neon sphere (2×2×2 studs) colored by rarity
  - Common: Gray
  - Uncommon: Green
  - Rare: Blue
  - Epic: Purple
  - Legendary: Gold
  - Corrupted: Red
- **Label:** BillboardGui showing ghost name + rarity (visible within 200 studs)
- **Glow:** PointLight with rarity color (range 15, brightness 2)
- **Data:** Ghost stats stored as attributes for retrieval
- **Physics:** CanCollide = false (ghosts pass through terrain)

**Key methods:**
- `CreateGhostInstance(stats, parent)` — Create clickable ghost in world

### 3. **GhostSpawner.lua** (New)
**Location:** `src/server/systems/GhostSpawner.lua`

Spawns ghosts in zones and manages their lifecycle:
- **Spawn rate:** Every 3 seconds, attempts to spawn 1 ghost per zone
- **Zone pool:** Uses ZoneData weighted spawn tables
  - Each zone has different ghost rarities
  - Example: "Whisper Woods" spawns 95% Common/Uncommon, 5% higher
- **Spawn limit:** Max 5 ghosts per zone at once
- **Despawn:** Ghosts auto-despawn after 60 seconds if not caught
- **Spawn radius:** Random position within 50 studs of zone marker

**Key methods:**
- `spawnGhostInZone(zoneName)` — Spawn one ghost in a zone
- `startSpawning()` — Start background spawning loop
- `removeGhost(ghostInstance)` — Remove ghost (on catch)
- `getGhostsInZone(zoneName)` — Get active ghosts in zone
- `getActiveGhostCount()` — Total ghosts in world

### 4. **VacuumSystem Enhancement**
**Location:** `src/server/systems/VacuumSystem.lua`

Added:
- `deductCharge(player, amount)` — Deduct charge on catch (returns bool)

### 5. **MainServer.lua Wiring**
**Location:** `src/server/MainServer.lua`

Added:
- `require GhostSpawner` — Load spawner module
- `ghostSpawner:new()` — Initialize spawner instance
- `ghostSpawner:startSpawning()` — Start background spawning (after all systems initialized)
- `setupCatchRemote()` — Handle CatchGhost remote event

**CatchGhost Logic:**
1. Player clicks Catch button
2. Server checks vacuum charge ≥ 10
3. Find nearest ghost to player (within world)
4. Deduct 10 charge from player
5. Add ghost to player inventory (via GhostService)
6. Award coins based on rarity:
   - Common: 1 coin
   - Uncommon: 3 coins
   - Rare: 10 coins
   - Epic: 25 coins
   - Legendary: 50 coins
   - Corrupted: 75 coins
7. Remove ghost from world
8. Notify player with success message

---

## How It Works (Full Flow)

```
Server starts
  ↓
GhostSpawner initialized
  ↓
ghostSpawner:startSpawning() called
  ↓
Every 3 seconds:
  For each zone in ZoneData:
    Check if zone has < 5 ghosts
    Pick random ghost from zone pool
    Generate stats (rarity, personality, energy)
    Create visual sphere (GhostInstanceBuilder)
    Track ghost in ghostSpawner.activeGhosts
    Schedule despawn after 60 seconds
  ↓
Player clicks Catch button (GameClient.lua)
  ↓
Client sends CatchGhost remote to server
  ↓
Server:
  - Checks vacuum charge ≥ 10
  - Finds nearest ghost to player
  - Deducts charge
  - Adds to inventory (GhostService)
  - Awards coins (CurrencySystem)
  - Removes ghost from world
  - Sends notification to client
```

---

## Data Integration

**ZoneData.lua used for:**
- Ghost pool per zone (weighted spawning)
- Rarity range per zone (min/max rarity)
- Energy multiplier per zone

**GhostData.lua used for:**
- Ghost rarity lookup
- Stat ranges per rarity
- Personality pool

**Constants used for:**
- Remote names (CatchGhost, UpdateUI, ShowNotification)
- ReplicatedStorage paths

---

## Testing Checklist (Ready to Test in Studio)

- [ ] Open `place.rbxl` in Roblox Studio
- [ ] Press Play
- [ ] Fly to a zone using FLY_TOOL (Press F to toggle)
- [ ] Wait 3-5 seconds — colored spheres should appear
- [ ] Click Catch button — nearest ghost should disappear
- [ ] Check Output log — "Caught X (Rarity)" should print
- [ ] Check top panel — coins should increase
- [ ] Check charge bar — should decrease by 10%
- [ ] Try catching another ghost — new ones should spawn
- [ ] Try with no charge — should show "Not enough charge!" notification
- [ ] Wait 60+ seconds at same spot — ghosts should despawn

---

## Known Limitations (MVP)

- Ghosts don't move or flee (static floaters)
- No click detection on ghosts (always catch nearest)
- No visual feedback during catch (instant removal)
- No animation or particles
- No sound effects

---

## Next Steps

After testing in Studio:

1. **Polish UI tabs** — Populate HQ, Zones, Shop, Info with real data
2. **Add visual feedback** — Particles, sounds, animations on catch
3. **Train ghosts** — Wire TrainingSystem to train caught ghosts
4. **Passive income** — Wire ProductionSystem for energy generation from caught ghosts
5. **Zone unlocking** — Wire ZoneSystem to let players unlock new zones with coins

---

## Files Summary

| File | Status | Purpose |
|------|--------|---------|
| GhostStatGenerator.lua | ✅ New | Generate ghost stats |
| GhostInstanceBuilder.lua | ✅ New | Create ghost visuals |
| GhostSpawner.lua | ✅ New | Spawn ghosts in zones |
| VacuumSystem.lua | ✅ Modified | Added deductCharge() |
| MainServer.lua | ✅ Modified | Wire spawner + catch remote |

---

**Ready to test in Studio!** 🎮👻
