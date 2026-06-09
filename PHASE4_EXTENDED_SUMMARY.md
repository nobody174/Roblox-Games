<!--
  Ghost Catcher Tycoon - Phase 4 Extended Implementation
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
-->

# Phase 4 Extended — Remote Handlers Implementation

## Summary

Successfully added **4 optional remote handlers** to the minimal Phase 4 testing server. The new file `MainServer_Phase4_Extended.lua` extends the existing Phase 4 MVP with:

1. ✅ **UpgradeRoom** — Upgrade HQ rooms (GhostChamber, TrainingFacility, EnergyReactor, ResearchLab, BossArena)
2. ✅ **TrainGhost** — Level up caught ghosts (1-10), scales by rarity
3. ✅ **HatchEgg** — Gacha system (Common, Uncommon, Rare, Epic, Legendary eggs)
4. ✅ **UnlockZone** — Unlock new zones (Whisper Woods → Foggy Fields → Gloomy Graveyard, etc.)

---

## File Changes

### New File
- **`src/server/MainServer_Phase4_Extended.lua`** (358 lines)
  - Extends `MainServer_Phase4_NoSpawner.lua` with optional handlers
  - Backward compatible (old Phase 4 remotes still work)
  - All new handlers follow same pattern as Charge/Catch handlers

### File Locations
- Original: `src/server/MainServer_Phase4_NoSpawner.lua` (238 lines, reference)
- **Extended:** `src/server/MainServer_Phase4_Extended.lua` (358 lines, USE THIS)

---

## Handler Specifications

### 1. UpgradeRoom Handler

**Remote Call:**
```lua
remotesFolder:FindFirstChild("UpgradeRoom"):FireServer(roomName)
```

**Parameters:**
- `roomName` (string) — Room to upgrade: "GhostChamber", "TrainingFacility", "EnergyReactor", "ResearchLab", "BossArena"

**Behavior:**
- Calculates cost: `baseCost * (multiplier ^ (currentLevel - 1))`
  - GhostChamber: 100 coins base (×1.5 per level)
  - TrainingFacility: 150 coins base (×1.5 per level)
  - EnergyReactor: 200 coins base (×1.5 per level)
  - ResearchLab: 300 coins base (×1.5 per level)
  - BossArena: 500 coins base (×1.5 per level)
- All rooms max at level 10
- Deducts coins, increments room level
- Returns error if: insufficient coins, room doesn't exist, max level reached

**Example:**
```lua
-- Upgrade GhostChamber from level 1 to 2: costs 100 coins
-- Upgrade GhostChamber from level 2 to 3: costs 150 coins
-- Upgrade GhostChamber from level 10: fails (max level)
```

---

### 2. TrainGhost Handler

**Remote Call:**
```lua
remotesFolder:FindFirstChild("TrainGhost"):FireServer(ghostKey)
```

**Parameters:**
- `ghostKey` (string) — Unique ghost identifier in inventory (format: "GhostName_1234")

**Behavior:**
- Calculates cost: `baseCost * ghostLevel` where `baseCost = 50 * rarityMultiplier`
  - Common: 50 coins × level
  - Uncommon: 75 coins × level
  - Rare: 100 coins × level
  - Epic: 150 coins × level
  - Legendary: 250 coins × level
- All ghosts max at level 10
- Deducts coins, increments ghost level
- Returns error if: ghost doesn't exist, insufficient coins, max level reached

**Example:**
```lua
-- Train Common ghost level 1→2: costs 50 coins
-- Train Common ghost level 5→6: costs 250 coins
-- Train Legendary ghost level 1→2: costs 250 coins
```

---

### 3. HatchEgg Handler (Gacha)

**Remote Call:**
```lua
remotesFolder:FindFirstChild("HatchEgg"):FireServer(eggName)
```

**Parameters:**
- `eggName` (string) — Egg type: "Common Egg", "Uncommon Egg", "Rare Egg", "Epic Egg", "Legendary Egg"

**Behavior:**
- Costs vary by egg tier:
  - Common Egg: 250 coins
  - Uncommon Egg: 1,200 coins
  - Rare Egg: 5,000 coins
  - Epic Egg: 15,000 coins
  - Legendary Egg: 45,000 coins
- Rolls rarity based on egg type (simplified: uses egg's base rarity)
- Selects random ghost from availability pool
- Adds ghost to inventory with level 1
- Increments ghost count
- Returns error if: egg doesn't exist, insufficient coins

**Example:**
```lua
-- Hatch Common Egg: costs 250 coins, get Common rarity ghost (Puffling, Wobbler, Peekaboo, Drifter, Blinklet)
-- Hatch Legendary Egg: costs 45,000 coins, get Legendary rarity ghost (Ancient One, Void King, Star Reaper, etc.)
```

**Available Ghosts by Rarity:**
- Common: Puffling, Wobbler, Peekaboo, Drifter, Blinklet
- Uncommon: Sparkling Sprite, Shadowling, Giggler, Lantern Wisp, Dustwhirl
- Rare: Voltgeist, Frostwhisper, Bloomshade, Geargrin, Tidebound
- Epic: Phantom Knight, Inferno Wraith, Astral Drifter, Cryo Reaper, Thunder Jester
- Legendary: Ancient One, Void King, Star Reaper, Eternal Shade, Primordial Ghost

---

### 4. UnlockZone Handler

**Remote Call:**
```lua
remotesFolder:FindFirstChild("UnlockZone"):FireServer(zoneName)
```

**Parameters:**
- `zoneName` (string) — Zone to unlock: "Whisper Woods", "Foggy Fields", "Gloomy Graveyard", "Electro Alley", "Frostbite Caverns"

**Behavior:**
- Unlock costs by zone:
  - Whisper Woods: 0 coins (free, always unlocked)
  - Foggy Fields: 1,500 coins
  - Gloomy Graveyard: 6,000 coins
  - Electro Alley: 18,000 coins
  - Frostbite Caverns: 42,000 coins
- Deducts coins, adds zone to unlockedZones list
- Returns error if: zone doesn't exist, already unlocked, insufficient coins

**Example:**
```lua
-- Unlock Foggy Fields: costs 1,500 coins
-- Unlock Gloomy Graveyard: costs 6,000 coins (only if not already unlocked)
-- Whisper Woods: already unlocked on game start
```

---

## Code Structure

### Handler Pattern (Consistent across all 4 handlers)

```lua
-- Create remote
createRemote(Constants.Remotes.HandlerName, "RemoteEvent")

-- Connect handler
local handlerRemote = remotesFolder:FindFirstChild(Constants.Remotes.HandlerName)
if handlerRemote then
	handlerRemote.OnServerEvent:Connect(function(player, param1, param2)
		local data = initPlayerData(player.UserId)

		-- Validate inputs
		if not isValid(param1) then
			print("[PHASE 4] Error: invalid param")
			return
		end

		-- Calculate cost
		local cost = calculateCost(...)

		-- Check resources
		if data.coins < cost then
			print("[PHASE 4] Error: insufficient coins")
			return
		end

		-- Perform action
		data.coins = data.coins - cost
		-- ... update player data ...

		print("[PHASE 4] " .. player.Name .. " action successful!")
	end)
	print("[PHASE 4] HandlerName handler connected")
end
```

---

## Player Data Structure

### Expanded playerData

```lua
playerData[userId] = {
	charge = 0,              -- Vacuum charge (0-100%)
	coins = 0,               -- Energy/currency
	ghosts = 0,              -- Total ghost count

	-- NEW: Ghost inventory
	ghostInventory = {
		["Specter_1234"] = { name = "Specter", level = 1, rarity = "Common" },
		["Phantom_5678"] = { name = "Phantom", level = 3, rarity = "Rare" },
	},

	-- NEW: Room levels
	rooms = {
		GhostChamber = { level = 1 },
		TrainingFacility = { level = 1 },
		EnergyReactor = { level = 1 },
		ResearchLab = { level = 0 },
		BossArena = { level = 0 },
	},

	-- NEW: Zone progression
	unlockedZones = { "Whisper Woods", "Foggy Fields" },
}
```

---

## Testing Checklist

### In Roblox Studio

**Test UpgradeRoom:**
- [ ] Start game, open HQ tab
- [ ] Click "Upgrade GhostChamber" with 100+ coins
- [ ] Check Output: "upgraded GhostChamber to level 2"
- [ ] Try with insufficient coins (should fail)
- [ ] Try to upgrade beyond level 10 (should fail)

**Test TrainGhost:**
- [ ] Catch 2+ ghosts (different rarities)
- [ ] Open Ghost tab, click "Train" on a ghost
- [ ] Check Output: "trained [GhostName] to level 2"
- [ ] Verify cost increases with level
- [ ] Try to train beyond level 10 (should fail)

**Test HatchEgg:**
- [ ] Open Shop tab, click "Hatch Common Egg"
- [ ] Check Output: "hatched Common Egg and received [GhostName]"
- [ ] Verify ghost appears in inventory
- [ ] Ghost count increments
- [ ] Try with insufficient coins (should fail)

**Test UnlockZone:**
- [ ] Open Zones tab, see "Whisper Woods" (unlocked) and others (locked)
- [ ] Click "Unlock Foggy Fields" with 1,500+ coins
- [ ] Check Output: "unlocked Foggy Fields"
- [ ] Try to unlock same zone again (should fail)
- [ ] Try with insufficient coins (should fail)

### Expected Output (Server)

```
[PHASE 4] Starting Phase 4 extended testing server...
[PHASE 4] Constants loaded
[PHASE 4] Remotes created (including optional handlers)
[PHASE 4] Ghost spawning started
[PHASE 4] Charge handler connected
[PHASE 4] Catch handler connected
[PHASE 4] UpgradeRoom handler connected
[PHASE 4] TrainGhost handler connected
[PHASE 4] HatchEgg handler connected
[PHASE 4] UnlockZone handler connected
[PHASE 4] ✅ Phase 4 extended testing server ready!
[PHASE 4] Ghosts spawning every 3 seconds in all zones
...
[PHASE 4] [PlayerName] upgraded GhostChamber to level 2 for 100 coins!
[PHASE 4] [PlayerName] trained Specter to level 2 for 50 coins!
[PHASE 4] [PlayerName] hatched Common Egg and received Puffling (Common)!
[PHASE 4] [PlayerName] unlocked Foggy Fields for 1500 coins!
```

---

## Implementation Notes

1. **Simplified Gacha:** Current implementation uses egg tier as rarity (not full probability tables)
   - Real version in EggData.lua has weighted probabilities
   - Can upgrade to full gacha in next phase

2. **Ghost Inventory:** Keys are unique per ghost to allow duplicates (Specter_1234 vs Specter_5678)
   - Current system: `name .. "_" .. math.random(1000, 9999)`
   - Production: Should use UUID or timestamp

3. **Cost Scaling:** Room upgrades scale exponentially (×1.5 multiplier per level)
   - Training costs scale with ghost level
   - Both are configurable in table definitions

4. **No Full Persistence:** Player data resets on server restart (in-memory only)
   - Next phase: Integrate with DataManager for saving

5. **No Validation:** Doesn't check max ghost storage (can catch infinite ghosts)
   - Add `if data.ghosts >= data.ghostStorage` check when needed

---

## Files to Replace in Studio

1. **Current:** `src/server/MainServer_Phase4_NoSpawner.lua` (243 lines)
2. **Replace with:** `src/server/MainServer_Phase4_Extended.lua` (358 lines)

**No changes needed to:**
- `src/client/GameClient.lua` (already has button wiring)
- `src/shared/constants.lua` (all remotes defined)
- `ZONE_AUTO_BUILDER.lua` (zones auto-spawn)
- `FLY_TOOL.lua` (flight system)

---

## Next Steps

After testing the 4 handlers:

1. **Phase 4 Polish** — Add animations, particles, sound effects for interactions
2. **Phase 5 Integration** — Merge into full MainServer.lua with all 17 systems
3. **Production Wiring** — HQ room multipliers → passive income calculations
4. **DataStore Integration** — Save/load player progress with failover

---

**Date:** 2026-06-04  
**Status:** Phase 4 Extended ready for Studio testing  
**Handler Count:** 6 total (Charge, Catch, UpgradeRoom, TrainGhost, HatchEgg, UnlockZone)
