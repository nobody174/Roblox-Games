<!-- 
  GHOST HABITAT SYSTEM DESIGN
  Collection-Based Ghost Management
  Author: Claude Code
  Date: 2026-06-06
-->

# 👻 Ghost Habitat System Design

## Overview

Instead of "Bring Ghosts Home" awarding coins and discarding ghosts, players build a **Ghost Habitat** where caught ghosts live, generate passive income, and can be displayed/customized.

---

## 🏠 Core Concept

```
OLD FLOW (Coins Model - Dies in 5-7 days):
Catch Ghost → Bring Home → Get Coins → Ghost Disappears
                          (Feels empty)

NEW FLOW (Collection Model - Retains for 30-60+ days):
Catch Ghost → Store in Habitat → Ghost Generates Income
                                 → Display in Collection
                                 → Customize/Cosmetics
                                 → Pride of Ownership
```

---

## 🎮 UI/UX Layout

### Habitat Tab (New Tab in Game UI)

**Location:** Add to tabs array in GameClient.lua
- Position: Between "HQ" and "Zones" tabs
- Icon: 🏠 Habitat

**Layout:**

```
┌─────────────────────────────────────────────────────┐
│  HABITAT  │  Ghost Count: 47/50  │  Income: 23.5/sec │
├─────────────────────────────────────────────────────┤
│                                                       │
│  [Filter: All] [Common] [Uncommon] [Rare] [Epic]    │
│                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │
│  │   Specter    │  │   Phantom    │  │   Wraith   │ │
│  │   Level 5    │  │   Level 8    │  │   Level 2  │ │
│  │  0.5 /sec    │  │  2.5 /sec    │  │  0.5 /sec  │ │
│  │  [▼ Release] │  │  [▼ Release] │  │[▼ Release] │ │
│  │  [✨ Skin]   │  │  [✨ Skin]   │  │ [✨ Skin]  │ │
│  └──────────────┘  └──────────────┘  └────────────┘ │
│                                                       │
│  [Upgrade Habitat →] [Release All] [Export Data]    │
└─────────────────────────────────────────────────────┘
```

### Habitat Details (Expandable Card per Ghost)

When clicking a ghost card:

```
┌──────────────────────────────────┐
│ 👻 Specter (Common)              │
├──────────────────────────────────┤
│ Level: 5/10                      │
│ Rarity: ⚪ Common                │
│ Energy Output: 0.5/sec           │
│ Caught: 2026-06-06 at 14:32      │
│                                  │
│ [Release Ghost] [Customize Skin] │
│ [View Stats] [Rename]            │
└──────────────────────────────────┘
```

---

## 💾 Data Structure

### Player Habitat Data

```lua
playerData[userId].habitat = {
  maxSlots = 50,           -- Upgradeable via room
  ghosts = {
    ["Specter_1234"] = {
      name = "Specter",
      rarity = "Common",
      level = 5,
      energyOutput = 0.5,
      caughtTime = 1717675920,  -- Unix timestamp
      cosmetics = {
        skin = "default",      -- Or: "neon", "glowing", custom
        color = Color3.new(),  -- Optional custom color
      }
    },
    ["Phantom_5678"] = { ... },
  }
}
```

### Migration from Old System

When "Bring Ghosts Home" is called:

```lua
OLD: data.coins += (data.ghosts * 10 * 0.1)
     data.ghosts = 0  -- LOST

NEW: for each ghost in ghostInventory:
       data.habitat.ghosts[ghostKey] = ghostData
       -- Ghost stays, generates income
```

---

## 📊 Income Calculation

### Energy Output per Ghost

Base formula:

```lua
energyOutput = RarityBase × LevelMultiplier × RoomBonus

RarityBase = {
  Common = 0.5,
  Uncommon = 1.0,
  Rare = 2.5,
  Epic = 5.0,
  Legendary = 10.0,
  Corrupted = 25.0,
}

LevelMultiplier = 1.0 + (level - 1) * 0.1
-- Level 1 = 1.0x
-- Level 5 = 1.4x
-- Level 10 = 1.9x

RoomBonus = EnergyReactor upgrade multiplier (default 1.0)
```

### Total Habitat Income

```lua
totalIncome = sum(ghost.energyOutput for each ghost)
              × EnergyReactor.multiplier
```

**Example:**
- 5 Common ghosts (level 1) = 0.5 × 5 = 2.5/sec
- 3 Rare ghosts (level 5) = 2.5 × 1.4 × 3 = 10.5/sec
- 1 Legendary (level 10) = 10 × 1.9 = 19.0/sec
- **Total = 32/sec**

---

## 🎨 Habitat Features

### 1. Release Ghost

Reverse catch process - remove ghost from habitat, get refund:

```lua
OnReleaseGhost:
  refund = (ghost.rarity.value * ghost.level)
  playerCoins += refund
  habitat.ghosts[key] = nil
```

### 2. Customize Ghost Skin

Access cosmetics (requires skin purchase):

```lua
Ghost Skins (cosmetics shop):
- Default (free)
- Neon Glow (+$3)
- Crystal Form (+$5)
- Shadow Form (+$5)
- Golden Aura (+$8)
- Corrupted Echo (+$10, Legendary only)
```

### 3. Habitat Upgrades

Room: **Ghost Chamber** (existing)

```lua
Level 1: 5 slots
Level 2: 10 slots
Level 3: 15 slots
...
Level 10: 50 slots
```

**New: Habitat Sanctuary Room** (optional Phase 2)

```lua
Sanctuary = {
  DisplayName = "Habitat Sanctuary",
  Description = "Unlock ghost customization, breeding, evolution",
  BaseCost = 2000,
  MaxLevel = 5,
}
```

---

## 🔄 Bringing Ghosts Home (New Flow)

### Old Button: "Bring Ghosts Home"

**New Behavior:**

```lua
OnBringGhostsHome:
  if habitatFull then
    showNotification("Habitat full! Upgrade Ghost Chamber")
    return
  end
  
  for each ghost in ghostInventory:
    habitat.ghosts[ghostKey] = {
      name, rarity, level, energyOutput
      caughtTime = now()
      cosmetics = { skin = "default" }
    }
  
  ghostInventory = {}  -- Clear temp inventory
  showNotification("✓ " .. count .. " ghosts brought home!")
```

### Income Ticking

**Server-side income loop:**

```lua
task.spawn(function()
  while true do
    task.wait(1)
    for _, player in pairs(Players:GetPlayers()) do
      local data = playerData[player.UserId]
      local totalIncome = 0
      
      for _, ghost in pairs(data.habitat.ghosts) do
        totalIncome += ghost.energyOutput
      end
      
      data.coins += totalIncome
      -- Broadcast UI update every 5 ticks (less network spam)
    end
  end
end)
```

---

## 🎯 UI Interactions

### Ghost Card Actions

| Action | Effect | Cost |
|--------|--------|------|
| Click | Expand details | Free |
| Release | Remove from habitat | None (get refund) |
| Customize Skin | Change appearance | Robux (cosmetic) |
| Rename | Personalize ghost | Free |
| View Stats | See level, income | Free |

### Filters

```lua
Filters = {
  "All",
  "Common",
  "Uncommon", 
  "Rare",
  "Epic",
  "Legendary",
  "Corrupted",
  "Trained" (level > 1),
  "Favorites" (starred)
}
```

---

## 📱 Client Implementation

### New Module: HabitatUI.lua

```lua
HabitatUI:new()
HabitatUI:initialize(gameClient)
HabitatUI:refreshGhostList(filterType)
HabitatUI:showGhostDetails(ghostKey)
HabitatUI:onReleaseClicked(ghostKey)
HabitatUI:onCustomizeClicked(ghostKey)
HabitatUI:calculateTotalIncome()
HabitatUI:updateIncomeDisplay()
```

### Server Handler: HabitatSystem.lua

```lua
HabitatSystem:new()
HabitatSystem:addGhostToHabitat(player, ghostData)
HabitatSystem:removeGhostFromHabitat(player, ghostKey)
HabitatSystem:getReleaseRefund(ghost)
HabitatSystem:calculateIncome(player)
HabitatSystem:applyCosmetic(player, ghostKey, skinName)
HabitatSystem:upgradeHabitat(player)
```

---

## 🔗 Integration Points

### Existing Systems

**GameClient.lua:**
- Add Habitat tab to tabs array
- Connect to HabitatUI module
- Update UI refresh loop to include habitat income

**MainServer_Phase4_Extended.lua:**
- Add HabitatSystem initialization
- Move "Bring Ghosts Home" logic to habitat system
- Update income calculation loop

**DataManager.lua:**
- Save/load habitat data
- Persist ghost collection across sessions

**CosmeticsSystem.lua:**
- Link to ghost customization
- Apply skins to ghost visuals

---

## 🎨 Ghost Visuals (Linked to Graphics)

### Current State
- Spheres (Neon Part, no detail)
- Color by rarity only

### Proposed State
- **Base Model:** Custom mesh/image per ghost
- **Cosmetics Layer:** Skin overlay (glow, crystal, shadow effect)
- **Rarity Indicator:** Frame/halo around ghost
- **Level Indicator:** Badge or glow intensity

### Ghost Rendering

```lua
ghost.model = {
  base = importedMesh,        -- Ghost shape (PNG/image-based)
  rarity = rarityFrame,       -- Border/frame
  skin = activeSkin,          -- Cosmetic overlay
  level = levelBadge,         -- "Level 5" display
}
```

---

## 📈 Progression Gates

### When Unlocked

| Feature | Trigger |
|---------|---------|
| Habitat (5 slots) | Game start |
| Upgrade to 10 slots | After 1st catch |
| Customize skins | After 5 ghosts caught |
| Release ghosts | After 10 ghosts caught |
| Favorite/star ghosts | After 20 ghosts caught |
| Rename ghosts | After prestige 1 |

---

## 💰 Monetization

### Cosmetics
- Ghost skins: $3-10 USD equivalent per skin
- Aura effects: $2-4 per effect
- Seasonal cosmetics: $5-8 limited-time

### Passes
- *Cosmetics Pass:* Unlock 5 skins/month for $4.99
- Ghost Slot Pass: +10 storage for one-time $2.99

### Example Revenue
- 100 players, 20% spend on cosmetics
- 20 players × $5 avg = $100/month (healthy)

---

## 🐛 Edge Cases to Handle

1. **Habitat Full:** Show notification, don't discard new catches
2. **Release All:** Confirm before bulk action
3. **Data Loss:** Validate habitat on load, repair if corrupt
4. **Sync Issues:** If server/client desync, server is source of truth
5. **Prestige:** Does prestige reset habitat? (Recommend: NO, but cosmetics reset)

---

## ✅ Success Metrics

After launch:

- ✅ Players keep ghosts (collection grows)
- ✅ Passive income feels good (~5-10/sec at level 1)
- ✅ Cosmetics drive engagement (20%+ customize)
- ✅ Retention jumps (DAU increases day 7+)
- ✅ Monetization works (0.1 ARPPU → 0.5+ ARPPU)

---

## 📋 Implementation Checklist

**Phase 1 (This Week):**
- [ ] Design HabitatUI.lua (card layout, filters, details panel)
- [ ] Implement HabitatSystem server handlers
- [ ] Update MainServer to use habitat instead of coins
- [ ] Add Habitat tab to GameClient.lua
- [ ] Test basic habitat (add/remove ghosts)

**Phase 2 (Next Week):**
- [ ] Add ghost customization (skins)
- [ ] Implement cosmetics shop integration
- [ ] Add "Release Ghost" functionality
- [ ] Polish UI animations

**Phase 3 (Post-Launch):**
- [ ] Breeding system (combine 2 ghosts)
- [ ] Habitat themes (decorate sanctuary)
- [ ] Ghost adventures (quests with specific ghosts)

---

**Design Status:** ✅ Ready for Implementation

This gives you a complete vision for the Habitat system. Now you can work on ghost graphics while I start coding the UI/systems.

