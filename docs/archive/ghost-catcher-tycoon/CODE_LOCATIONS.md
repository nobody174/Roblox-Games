# Code Locations - Quick Reference

## 🎯 Find What You Need

### Ghost Stat Generator
- **EggSystem version:**
  - File: `src/server/systems/EggSystem.lua`
  - Lines: 141-158
  - Key line: `catchSpeed = math.random(rarityStats.CatchSpeed[1] * 10, rarityStats.CatchSpeed[2] * 10) / 10`
  
- **GhostSystem version:**
  - File: `src/server/systems/GhostSystem.lua`
  - Lines: 65-89
  - Key line: Same as above in spawnGhost function

### Egg Hatching System
- **Main function:**
  - File: `src/server/systems/EggSystem.lua`
  - Function: `EggSystem:hatchEgg(player, eggType)`
  - Lines: 100-170

- **Sub-functions:**
  - `selectRarityFromEgg` → Lines 65-86
  - `selectGhostFromPool` → Lines 88-98
  - Cost deduction → Lines 118-127
  - Ghost creation → Lines 141-158
  - Collection add → Lines 161-169

### Weighted Rarity Picker (Percentage-based)
- **File:** `src/server/systems/EggSystem.lua`
- **Function:** `EggSystem:selectRarityFromEgg(eggType)`
- **Lines:** 65-86
- **How it works:**
  ```lua
  local roll = math.random(1, 100)
  local accumulated = 0
  for rarity, chance in pairs(chances) do
    accumulated = accumulated + chance
    if roll <= accumulated then return rarity end
  end
  ```

### Weighted Ghost Picker (Weight-based)
- **File:** `src/server/systems/GhostSystem.lua`
- **Function:** `selectGhostFromZone(zone)` (local function)
- **Lines:** 37-57
- **How it works:**
  ```lua
  local roll = math.random() * totalWeight
  local accumulated = 0
  for _, entry in ipairs(spawns) do
    accumulated = accumulated + entry.Weight
    if roll <= accumulated then return entry end
  end
  ```

### Ghost Instance Builder
- **EggSystem version:**
  - File: `src/server/systems/EggSystem.lua`
  - Lines: 141-158
  - Creates complete ghost object from rarity, name, personality, stats

- **GhostSystem version:**
  - File: `src/server/systems/GhostSystem.lua`
  - Lines: 76-88 (inside spawnGhost function)
  - Same structure, used for zone spawns

---

## 📂 Data Files

### Ghost Data
- **File:** `src/shared/GhostData.lua`
- **Contains:**
  - RarityStats (line ~10-40): Stat ranges per rarity
  - Personalities (line ~42-48): 5 personality types
  - Ghosts (line ~50-120): All 120 ghost names
  - RarityMap (line ~122+): Ghost→Rarity lookup

### Egg Data
- **File:** `src/shared/EggData.lua`
- **Contains:** 7 egg types, each with:
  - Price and currency
  - Drop chances (percentage)
  - Ghost pools per rarity

### Zone Data
- **File:** `src/shared/ZoneData.lua`
- **Contains:** 11 zones, each with:
  - Spawn table (weighted entries)
  - Unlock cost
  - Energy multiplier

### Config
- **File:** `src/shared/config.lua`
- **Rarities section:** Lines 36-62
  - Color, CatchChance, BaseEnergyOutput per rarity

---

## 🔌 System Integration Points

### EggSystem Dependencies
- **Requires (at top):**
  - `Config` from config.lua
  - `Constants` from constants.lua
  - `EggData` from EggData.lua
  - `GhostData` from GhostData.lua

- **Needs (via setter):**
  - `currencySystem` (via `setCurrencySystem()`)
  - `ghostSystem` (via `setGhostSystem()`)

### GhostSystem Dependencies
- **Requires (at top):**
  - `Config` from config.lua
  - `Constants` from constants.lua
  - `GhostData` from GhostData.lua
  - `ZoneData` from ZoneData.lua

---

## 🎮 API Usage Examples

### Hatch an egg:
```lua
local success, ghost, message = eggSystem:hatchEgg(player, "Uncommon Egg")
```

### Spawn a ghost in a zone:
```lua
local ghost = ghostSystem:spawnGhost("Whisper Woods")
```

### Check rarity drop rate:
```lua
local rarity = eggSystem:selectRarityFromEgg("Common Egg")
```

### Check if can afford egg:
```lua
local canAfford, energy = eggSystem:canPurchaseEgg(player, "Rare Egg")
```

---

## ⚙️ Configuration Values

### Stat Ranges (GhostData.lua line ~14-30)
```lua
RarityStats = {
  Common = { CatchSpeed = {1, 2}, EnergyPerMin = {1, 3}, TrainingCost = {1, 1.2} },
  Uncommon = { CatchSpeed = {2, 3}, EnergyPerMin = {3, 6}, TrainingCost = {1.2, 1.5} },
  -- ...
}
```

### Base Energy Output (config.lua line ~36-62)
```lua
Rarities = {
  Common = { BaseEnergyOutput = 1 },
  Uncommon = { BaseEnergyOutput = 2 },
  Rare = { BaseEnergyOutput = 5 },
  Epic = { BaseEnergyOutput = 10 },
  Legendary = { BaseEnergyOutput = 20 },
  Corrupted = { BaseEnergyOutput = 50 },
}
```

### Egg Prices (EggData.lua line ~6+)
```lua
["Common Egg"] = { Price = 250, Currency = "EctoEnergy" },
["Uncommon Egg"] = { Price = 1200, Currency = "EctoEnergy" },
["Premium Robux Egg"] = { Price = 199, Currency = "Robux" },
```

---

## 📊 Data Flow Diagram

```
Player Action
    ↓
EggSystem:hatchEgg(player, eggType)
    ↓
    ├─→ Validate EggData[eggType] ✓
    ├─→ Deduct cost (CurrencySystem) ✓
    ├─→ selectRarityFromEgg(eggType)
    │   ├─→ Roll random(1, 100)
    │   ├─→ Compare with EggData chances
    │   └─→ Return rarity
    ├─→ selectGhostFromPool(eggType, rarity)
    │   ├─→ Get pool from EggData[eggType].Pool[rarity]
    │   ├─→ Random select from pool
    │   └─→ Return ghostName
    ├─→ Create ghost object
    │   ├─→ Generate ID
    │   ├─→ Set name from pool
    │   ├─→ Set rarity
    │   ├─→ Select personality
    │   └─→ Generate stats from GhostData.RarityStats
    ├─→ GhostSystem:addGhost(player, ghost)
    └─→ Return success, ghost, message
```

---

## 🧪 Testing Checklist

- [ ] `EggSystem:hatchEgg()` returns proper ghost object
- [ ] Ghost stats vary within rarity range
- [ ] Rarity selection matches egg drop rates
- [ ] Ghost pool selection is random
- [ ] Cost deducted from player
- [ ] Refund applied if storage full
- [ ] Ghost added to player collection
- [ ] Different egg types work correctly
- [ ] Robux eggs don't auto-deduct (awaiting Monetization)

---

## 🔗 Cross-References

| If you need... | Look in... | Line(s) |
|---|---|---|
| Stat generation logic | GhostSystem.lua | 74 |
| Egg hatch flow | EggSystem.lua | 100-170 |
| Rarity picking (percent) | EggSystem.lua | 65-86 |
| Ghost picking (weight) | GhostSystem.lua | 37-57 |
| Instance creation | EggSystem.lua | 141-158 |
| Personality list | GhostData.lua | ~42-48 |
| Stat ranges | GhostData.lua | ~14-30 |
| Ghost names | GhostData.lua | ~50-120 |
| Rarity→Ghost map | GhostData.lua | ~122+ |
| Egg definitions | EggData.lua | ~6-end |
| Zone definitions | ZoneData.lua | ~6-end |
| Base values | Config.lua | ~36-62 |

---

**Last Updated:** June 2, 2026  
**All systems verified and cross-referenced ✅**
