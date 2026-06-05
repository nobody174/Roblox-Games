<!--
  Ghost Catcher Tycoon — GhostService Integration Guide
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# GhostService Integration Guide

## Overview

**GhostService** is the central inventory management system for player ghosts. It handles:
- Creating ghost entries when caught/hatched
- Storing ghost stats (rarity, energy output, personality, etc.)
- Removing ghosts (on release/training)
- Querying inventory (list all, filter by rarity, get by ID)
- Preparing for DataStore save/load

**File:** `src/server/systems/GhostService.lua`

---

## Architecture

### Ghost Entry Structure

When a ghost is added to inventory, it's stored as a **Folder** with attributes:

```lua
player.GhostInventory
├── Ghost_1 (Folder)
│   ├── GhostId = "uuid-1234"
│   ├── GhostName = "Puffling"
│   ├── Rarity = "Common"
│   ├── CatchSpeed = 1.5
│   ├── EnergyPerMin = 2.3
│   ├── TrainingCostMultiplier = 1.2
│   ├── Personality = "Shy"
│   └── Level = 1
├── Ghost_2 (Folder)
│   ├── GhostId = "uuid-5678"
│   ├── GhostName = "Shadowling"
│   ├── Rarity = "Uncommon"
│   └── ...
```

Each ghost is **server-authoritative** (attributes stored on server, not client). This prevents cheating.

---

## Public API

### `getInventory(player)`

Returns a table of all ghost Folders in the player's inventory.

```lua
local ghostService = GhostService:new()
local ghosts = ghostService:getInventory(player)

for _, ghost in ipairs(ghosts) do
    print(ghost:GetAttribute("GhostName"), ghost:GetAttribute("Rarity"))
end
```

**Returns:** `{Ghost_1, Ghost_2, ...}` (array of Folder instances)

---

### `givePlayerGhost(player, stats)`

Adds a ghost to the player's inventory. Stats should include:
- `Name` (string) — ghost name
- `Rarity` (string) — "Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted"
- `CatchSpeed` (number) — 1-10
- `EnergyPerMin` (number) — base energy output per minute
- `TrainingCostMultiplier` (number) — cost scaling for training
- `Personality` (string) — "Shy", "Angry", "Playful", "Lazy", "Hyper"

```lua
local stats = {
    Name = "Puffling",
    Rarity = "Common",
    CatchSpeed = 1.5,
    EnergyPerMin = 2.3,
    TrainingCostMultiplier = 1.0,
    Personality = "Playful"
}

local ghostEntry = ghostService:givePlayerGhost(player, stats)
print("Ghost added! ID:", ghostEntry:GetAttribute("GhostId"))
```

**Returns:** `Ghost` folder (Folder instance with attributes set)

---

### `givePlayerRandomGhost(player, ghostName)`

Convenience method: Takes a ghost name, auto-generates stats, adds to inventory.

```lua
local ghostEntry = ghostService:givePlayerRandomGhost(player, "Shadowling")
```

**Returns:** `Ghost` folder, or `nil` if ghost name invalid

**Requires:** `GhostStatGenerator:GenerateStatsForGhost(ghostName)` to exist in shared modules

---

### `removeGhost(player, ghostId)`

Removes a ghost by ID (e.g., on release or training consumption).

```lua
local success = ghostService:removeGhost(player, "uuid-1234")
if success then
    print("Ghost removed!")
else
    print("Ghost not found")
end
```

**Returns:** `true` if removed, `false` if not found

---

### `getGhostById(player, ghostId)`

Finds a ghost by GhostId.

```lua
local ghost = ghostService:getGhostById(player, "uuid-1234")
if ghost then
    print("Found:", ghost:GetAttribute("GhostName"))
end
```

**Returns:** `Ghost` folder, or `nil` if not found

---

### `getGhostsByRarity(player, rarity)`

Filters inventory by rarity.

```lua
local legendaryGhosts = ghostService:getGhostsByRarity(player, "Legendary")
print("You have " .. #legendaryGhosts .. " Legendary ghosts")
```

**Returns:** `{Ghost_1, Ghost_2, ...}` (filtered array)

---

### `getInventoryCount(player)`

Returns the total number of ghosts in inventory.

```lua
local count = ghostService:getInventoryCount(player)
print("Inventory: " .. count .. " / 50 ghosts")
```

**Returns:** `number` (ghost count)

---

### `spawnGhostInWorld(stats, parent)`

Spawns a 3D ghost model in the world (for boss drops, displays, etc.).

```lua
local ghostModel = ghostService:spawnGhostInWorld(stats, workspace.Zones.GhostlyGraveyard)
```

**Returns:** `Model` (3D ghost instance), or `nil` if creation failed

**Requires:** `GhostInstanceBuilder:CreateGhostInstance(stats, parent)` to exist

---

## Integration Points

### 1. Egg Hatching → GhostService

**File:** `EggSystem.lua`

When a player hatches an egg:

```lua
-- EggSystem.lua (pseudocode)
local function hatchEgg(player, eggName)
    local ghostStats = EggHatchingService.HatchEgg(eggName)  -- Returns stats table
    local ghostEntry = ghostService:givePlayerGhost(player, ghostStats)  -- Add to inventory
    player:FindFirstChild("leaderstats").GhostsCaught.Value += 1
end
```

---

### 2. Boss Drops → GhostService

**File:** `BossSystem.lua`

When a player defeats a boss:

```lua
-- BossSystem.lua (pseudocode)
function BossSystem:onBossDefeated(bossModel, player)
    local bossConfig = BossData[bossModel:GetAttribute("BossName")]
    
    -- Award energy
    self.currencySystem:addCurrency(player, bossConfig.EnergyReward)
    
    -- Award random ghost drop
    local ghostDrop = selectRandomGhostFromPool(bossConfig.GhostDrop)
    local ghostStats = GhostStatGenerator:GenerateStatsForGhost(ghostDrop)
    ghostService:givePlayerGhost(player, ghostStats)
    
    print(player.Name .. " defeated " .. bossModel.Name .. " and got " .. ghostDrop .. "!")
end
```

---

### 3. Inventory UI → GhostService

**File:** `GameClient.lua` (client-side display)

When the player opens the Inventory tab:

```lua
-- GameClient.lua (client code)
local function populateGhostTab()
    local ghosts = ghostService:getInventory(player)  -- Get all ghosts
    
    for _, ghostEntry in ipairs(ghosts) do
        local card = GhostCardBuilder:buildCard(
            {
                id = ghostEntry:GetAttribute("GhostId"),
                name = ghostEntry:GetAttribute("GhostName"),
                rarity = ghostEntry:GetAttribute("Rarity"),
                level = ghostEntry:GetAttribute("Level"),
                energy = ghostEntry:GetAttribute("EnergyPerMin")
            },
            tabPanel,
            { onTrain = trainGhost, onRelease = releaseGhost }
        )
    end
end
```

---

### 4. Training → GhostService

**File:** `TrainingSystem.lua`

When a player trains a ghost to next level:

```lua
-- TrainingSystem.lua (pseudocode)
function TrainingSystem:trainGhost(player, ghostId)
    local ghost = ghostService:getGhostById(player, ghostId)
    if not ghost then return false end
    
    local level = ghost:GetAttribute("Level")
    local cost = self:calculateTrainingCost(level)
    
    if currencySystem:subtractCurrency(player, cost) then
        ghost:SetAttribute("Level", level + 1)
        print("Ghost leveled up to " .. level + 1 .. "!")
        return true
    end
    
    return false
end
```

---

### 5. Release → GhostService

**File:** `GhostSystem.lua`

When a player releases a ghost:

```lua
-- GhostSystem.lua (pseudocode)
local function releaseGhost(player, ghostId)
    local ghost = ghostService:getGhostById(player, ghostId)
    if ghost then
        local energy = ghost:GetAttribute("EnergyPerMin") * 10  -- Reward for release
        currencySystem:addCurrency(player, energy)
        ghostService:removeGhost(player, ghostId)
        return true
    end
    return false
end
```

---

## Persistence (Future)

### Saving on PlayerRemoving

```lua
Players.PlayerRemoving:Connect(function(player)
    local ghostData = {}
    local ghosts = ghostService:getInventory(player)
    
    for _, ghost in ipairs(ghosts) do
        table.insert(ghostData, {
            GhostName = ghost:GetAttribute("GhostName"),
            Rarity = ghost:GetAttribute("Rarity"),
            Level = ghost:GetAttribute("Level"),
            Personality = ghost:GetAttribute("Personality"),
            -- ... other attributes
        })
    end
    
    dataStore:SetAsync(player.UserId .. ":ghosts", ghostData)
end)
```

### Loading on PlayerAdded

```lua
Players.PlayerAdded:Connect(function(player)
    local ghostData = dataStore:GetAsync(player.UserId .. ":ghosts")
    
    if ghostData then
        for _, data in ipairs(ghostData) do
            ghostService:givePlayerGhost(player, data)
        end
    end
end)
```

---

## Usage Example: Complete Flow

```lua
-- 1. Player hatches a Rare Egg
local eggStats = EggSystem:hatchEgg(player, "Rare Egg")

-- 2. System adds ghost to inventory
ghostService:givePlayerGhost(player, eggStats)

-- 3. Client fetches all ghosts for display
local allGhosts = ghostService:getInventory(player)

-- 4. Player trains the ghost
ghostService:getGhostById(player, ghostId):SetAttribute("Level", 2)

-- 5. Player releases the ghost
ghostService:removeGhost(player, ghostId)

-- 6. On logout, save all remaining ghosts to DataStore
-- (TODO: implement DataStore integration)
```

---

## Error Handling

GhostService includes error checks for:
- Invalid player or stats
- Missing ghost by ID
- Failed stat generation

```lua
-- Safe call pattern
local ghost = ghostService:givePlayerGhost(player, stats)
if not ghost then
    warn("Failed to add ghost to inventory")
    return
end
```

---

## Performance Considerations

- **Inventory lookup:** O(n) per search (iterates folder children)
- **Typical size:** 50-100 ghosts per player (negligible cost)
- **Recommendation:** If inventory grows >500 ghosts, add caching layer (dictionary by ID)

---

## Testing Checklist

- [ ] Start in Studio with test player
- [ ] Hatch an egg, verify ghost appears in inventory
- [ ] Open inventory tab, see ghost listed
- [ ] Train ghost to level 2
- [ ] Release ghost, verify it's removed
- [ ] Fight a boss, verify ghost drop appears
- [ ] Close and rejoin, verify ghosts persist (once DataStore integrated)

---

## Summary

**GhostService** is the backbone for managing player ghost inventory. It's:
- ✅ Server-authoritative (no cheating)
- ✅ Modular (works with any system that needs ghosts)
- ✅ Extensible (easy to add query methods)
- ✅ DataStore-ready (hooks in place for save/load)

All other systems (EggSystem, BossSystem, TrainingSystem) call GhostService methods to manage ghosts, ensuring consistency across the game.

---

**Contact:** vartdal@gmail.com  
**Repository:** https://github.com/nobody174/roblox-games

Built with Claude Code by Anthropic.
