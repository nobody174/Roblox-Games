# Ghost Catcher Tycoon - Quick Reference

## 📂 New Files Created

```
src/shared/
├── EggData.lua       ← Egg system definitions (7 eggs)
├── GhostData.lua     ← Ghost catalog (120 ghosts)
└── ZoneData.lua      ← Zone progression (11 zones)

src/server/systems/
└── EggSystem.lua     ← Egg hatching mechanics
```

## 🟢 Files Updated

- `src/shared/config.lua` — Added Corrupted rarity, updated zones
- `src/shared/enums.lua` — Added Epic & Corrupted to Rarity enum, updated Zone enum
- `src/server/systems/GhostSystem.lua` — Complete rewrite to use GhostData & ZoneData
- `src/server/systems/ZoneSystem.lua` — Updated to use ZoneData

## 🎮 How to Use Each System

### **Spawn a Ghost** (GhostSystem)
```lua
local ghost = ghostSystem:spawnGhost("Whisper Woods")
print(ghost.name)    -- "Puffling", "Wobbler", etc.
print(ghost.rarity)  -- "Common", "Uncommon", etc.
```

### **Unlock a Zone** (ZoneSystem)
```lua
local success, zoneConfig = zoneSystem:unlockZone(player, "Foggy Fields")
print(zoneConfig.BaseEnergyMultiplier) -- 1.2
```

### **Hatch an Egg** (EggSystem)
```lua
local success, ghost, msg = eggSystem:hatchEgg(player, "Uncommon Egg")
if success then
  print(msg) -- "Egg hatched! You got Shadowling (Uncommon)"
end
```

## 📊 Data at a Glance

### **6 Rarities**
| Rarity | Common | Uncommon | Rare | Epic | Legendary | Corrupted |
|--------|--------|----------|------|------|-----------|-----------|
| Catch% | 80% | 60% | 40% | 25% | 15% | 5% |
| Energy | 1 | 2 | 5 | 10 | 20 | 50 |
| Count | 20 | 20 | 20 | 20 | 20 | 20 |

### **11 Zones**
| # | Zone | Cost | Mult | Ghosts |
|---|------|------|------|--------|
| 1 | Whisper Woods | 0 | 1.0× | Common |
| 2 | Foggy Fields | 1.5K | 1.2× | Com/Unc |
| 3 | Gloomy Graveyard | 6K | 1.5× | Unc/Rare |
| 4 | Electro Alley | 18K | 1.8× | Rare/Epic |
| 5 | Frostbite Caverns | 42K | 2.1× | Rare/Epic |
| 6 | Sunken Spirit Reef | 90K | 2.5× | Rare/Epic |
| 7 | Clocktower District | 180K | 3.0× | Rare/Epic/Leg |
| 8 | Astral Observatory | 350K | 3.8× | Epic/Leg |
| 9 | Phantom Fortress | 700K | 4.5× | Epic/Leg |
| 10 | The Rift | 1.5M | 5.5× | Leg/Cor |
| 11 | Eternity Nexus | 0 | 7.0× | Leg/Cor |

### **7 Eggs**
| Egg | Price | Type | Best For |
|-----|-------|------|----------|
| Common | 250 | Energy | Early game |
| Uncommon | 1,200 | Energy | Mid-early |
| Rare | 5,000 | Energy | Mid game |
| Epic | 15,000 | Energy | Mid-late |
| Legendary | 45,000 | Energy | Late game |
| Corrupted | 120,000 | Energy | End game |
| Premium Robux | 199R | Robux | **Revenue** |

## 🔗 System Integration Chain

```
GhostSystem
├── Uses: GhostData (ghost names, personalities, stats)
├── Uses: ZoneData (spawn tables per zone)
└── Returns: Named ghosts (e.g., "Puffling", "Eclipse Seraph")

ZoneSystem
├── Uses: ZoneData (zone definitions, unlock costs)
└── Returns: Zone info with energy multipliers

EggSystem
├── Uses: EggData (egg drop rates, ghost pools)
├── Uses: GhostData (ghost stats and personalities)
├── Calls: CurrencySystem:removeEnergy() (deduct cost)
├── Calls: GhostSystem:addGhost() (add to collection)
└── Returns: Hatched ghost
```

## ⚙️ System API Summary

### GhostSystem
```lua
ghost = ghostSystem:spawnGhost(zone)
chance = ghostSystem:calculateCatchChance(zone)
success = ghostSystem:addGhost(player, ghost)
```

### ZoneSystem
```lua
success, zoneConfig = zoneSystem:unlockZone(player, zoneName)
isUnlocked = zoneSystem:isZoneUnlocked(player, zoneName)
unlockedZones = zoneSystem:getUnlockedZones(player)
zoneInfo = zoneSystem:getZoneInfo(zoneName)
```

### EggSystem
```lua
success, ghost, msg = eggSystem:hatchEgg(player, eggType)
rarity = eggSystem:selectRarityFromEgg(eggType)
ghostName = eggSystem:selectGhostFromPool(eggType, rarity)
price, currency = eggSystem:getEggPrice(eggType)
```

## 🎯 Next: Wire EggSystem to MainServer

Add to `MainServer.lua` after line ~50 (after other system initialization):

```lua
-- Egg System
local EggSystem = require(script.Parent.systems.EggSystem)
local eggSystem = EggSystem.new()
eggSystem:setCurrencySystem(currencySystem)
eggSystem:setGhostSystem(ghostSystem)
```

Then add to RemoteEvent handlers:

```lua
remotes.HatchEgg.OnServerEvent:Connect(function(player, eggType)
  local success, ghost, message = eggSystem:hatchEgg(player, eggType)
  if success then
    remotes.UpdateUI:FireClient(player, {
      Ghost = ghost,
      Message = message,
    })
  else
    remotes.ShowNotification:FireClient(player, message)
  end
end)
```

## 📚 Example Gameplay Flow

1. **Player starts:** Spawns in Whisper Woods (free, unlocked)
2. **Early game:** Catches Common/Uncommon ghosts
3. **Mid game:** Earns energy, unlocks Foggy Fields → Gloomy Graveyard
4. **Monetization:** Buys eggs from egg shop (250-120K Ecto-Energy)
5. **Late game:** Reaches The Rift, catches Legendary/Corrupted ghosts
6. **Endgame:** Prestiges, unlocks Eternity Nexus (7.0× energy)

## 🐛 Troubleshooting

**Error: "ZoneData is nil"**
→ Make sure `ZoneData.lua` exists in `src/shared/`

**Ghost names showing generic?**
→ GhostSystem must use `ZoneData` (updated) and set `ghost.name`

**Eggs not deducting energy?**
→ Make sure EggSystem has currencySystem wired up

**Zone unlock not working?**
→ Check that ZoneData uses `BaseEnergyMultiplier` (not `EnergyMultiplier`)

## 📞 Common Lookups

**Find a ghost's rarity:**
```lua
local rarity = GhostData.RarityMap["Puffling"]  -- "Common"
```

**Find a zone's energy multiplier:**
```lua
local zone = ZoneData["Whisper Woods"]
print(zone.BaseEnergyMultiplier) -- 1.0
```

**Find egg drop rates:**
```lua
local eggConfig = EggData["Uncommon Egg"]
print(eggConfig.Chances.Common)   -- 40
print(eggConfig.Chances.Uncommon) -- 45
```

---

**Last Updated:** June 2, 2026  
**Status:** Ready to test!
