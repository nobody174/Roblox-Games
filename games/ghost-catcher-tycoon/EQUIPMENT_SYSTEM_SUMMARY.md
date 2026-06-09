# Equipment System Implementation — Summary

## What's Built

### 1. EquipmentData.lua (Shared Module)
**File:** `src/shared/EquipmentData.lua`

Defines all 9 equipment tiers:

**Tier 1 (Starter)** — Free & Level 5
- Basic Net (free, start with)
- Reinforced Net (500 coins, Lvl 5)

**Tier 2 (Intermediate)** — Level 10-15
- Ghost Trap (2,000 coins, Lvl 10)
- Spectral Cage (3,500 coins, Lvl 15)

**Tier 3 (Advanced)** — Level 20-30
- Ectoplasm Blaster (8,000 coins, Lvl 20)
- Quantum Containment Device (15,000 coins, Lvl 30)

**Tier 4 (Expert)** — Level 40-50
- Proton Pack (25,000 coins, Lvl 40)
- Dimensional Siphon (40,000 coins, Lvl 50)

**Tier 5 (Legendary)** — Level 75
- Ghost Buster's Ultimate Device (100,000 coins, Lvl 75)

**Each equipment has:**
- Name, tier, cost, unlock level
- Charge time (3-7 seconds)
- Energy cost per use (10-80)
- Catch rates for each ghost rarity (Common 0-100%, Corrupted 0-99%)
- Description

**Functions Available:**
```lua
EquipmentData:getEquipment(name) -- Get equipment stats
EquipmentData:getCatchRate(equipName, rarity) -- Get success rate
EquipmentData:canAfford(equipName, coins) -- Check if player can buy
EquipmentData:canUnlock(equipName, level) -- Check if player can unlock
EquipmentData:getEquipmentByTier(tier) -- List all equipment in tier
```

---

### 2. PlayerInventory.lua (Server Module)
**File:** `src/server/PlayerInventory.lua`

Manages all player stats:

**Per-Player Data:**
- Current equipped equipment
- Owned equipment list
- Level (1-100)
- Coins (for purchasing)
- Energy (for catching)
- Max energy

**Functions Available:**
```lua
PlayerInventory:initializePlayer(userId) -- Create new inventory
PlayerInventory:getEquipped(userId) -- Get current equipment
PlayerInventory:setEquipped(userId, equipName) -- Change equipment
PlayerInventory:ownsEquipment(userId, equipName) -- Check ownership
PlayerInventory:addEquipment(userId, equipName) -- Add to inventory

PlayerInventory:getCoins(userId) -- Get coins
PlayerInventory:addCoins(userId, amount) -- Award coins
PlayerInventory:removeCoins(userId, amount) -- Deduct for purchase

PlayerInventory:getEnergy(userId) -- Get energy
PlayerInventory:removeEnergy(userId, amount) -- Deduct for catch
PlayerInventory:getMaxEnergy(userId) -- Get energy cap
PlayerInventory:increaseMaxEnergy(userId, amount) -- Skill bonus

PlayerInventory:getLevel(userId) -- Get player level
PlayerInventory:setLevel(userId, level) -- Level up
```

---

### 3. CatchingSystem.lua (Server Module)
**File:** `src/server/CatchingSystem.lua`

Core catch attempt logic with rewards:

**Main Function:**
```lua
CatchingSystem:attemptCatch(player, ghost, currentZone)
```

**What It Does:**
1. Check if player has enough energy
2. Deduct energy
3. Get equipment catch rate for ghost rarity
4. Roll success/failure (0-100 vs catch rate)
5. If success:
   - Calculate XP reward (base × zone multiplier)
   - Calculate coin reward (base × zone multiplier)
   - Add coins to player
   - Destroy ghost
   - Return success info
6. If failure:
   - Ghost escapes
   - Return escape info (roll vs rate)

**Reward Formulas:**

Base XP by rarity:
- Common: 25 XP
- Uncommon: 50 XP
- Rare: 100 XP
- Epic: 200 XP
- Legendary: 500 XP
- Corrupted: 1,000 XP

Base Coins by rarity:
- Common: 50 coins
- Uncommon: 100 coins
- Rare: 250 coins
- Epic: 500 coins
- Legendary: 1,500 coins
- Corrupted: 5,000 coins

Zone Multiplier (harder zones = more rewards):
- Starting Area: 1.0×
- Whisper Woods: 1.0×
- Foggy Fields: 1.2×
- Gloomy Graveyard: 1.5×
- Electro Alley: 1.5×
- Frostbite Caverns: 2.0×
- Sunken Spirit Reef: 1.8×
- Clocktower District: 1.7×
- Astral Observatory: 1.9×
- Phantom Fortress: 2.2×
- The Rift: 2.5×
- Eternity Nexus: 2.5×

**Other Functions:**
```lua
CatchingSystem:purchaseEquipment(userId, equipName) -- Buy equipment
CatchingSystem:equipEquipment(userId, equipName) -- Equip item
CatchingSystem:getEquipmentInfo(userId, ghostRarity) -- UI info
CatchingSystem:getPlayerEquipmentStats(userId) -- All equipment
```

---

## How It Works Together

### Catch Attempt Flow

1. **Client sends:** `CatchGhost` remote event
2. **Server finds:** Nearest ghost to player
3. **Server gets:** Current equipped equipment (from PlayerInventory)
4. **Server checks:** Player has enough energy
5. **Server calls:** `CatchingSystem:attemptCatch()`
   - Gets equipment catch rate
   - Rolls random(0, 100)
   - Success if roll ≤ catch rate
6. **If success:**
   - Deduct energy (from CatchingSystem)
   - Calculate rewards (XP × zone multiplier, coins × zone multiplier)
   - Add coins to PlayerInventory
   - Destroy ghost model
   - Return success info to client
7. **If failure:**
   - Deduct energy anyway
   - Ghost stays alive
   - Return failure info to client

### Equipment Progression Example

**New Player:**
- Level 1, 0 coins
- Has: Basic Net (free)
- Catch Common ghosts → earn 50 coins + 25 XP
- After ~10 catches: Have 500 coins

**Level 5 Player:**
- Can buy Reinforced Net (500 coins)
- Better catch rates on Uncommon/Rare ghosts
- Now earning 100+ coins per catch

**Level 10 Player:**
- Can buy Ghost Trap (2,000 coins)
- Can catch Rare ghosts reliably
- Earning 250+ coins per catch

**Level 30 Player:**
- Can buy Quantum Device (15,000 coins)
- Can catch Epic ghosts with 100% success
- Earning 500+ coins per catch

---

## Integration with MainServer

### What Needs to be Done

1. **Load modules at top:** Add require statements for the 3 new modules
2. **Initialize on join:** Call `PlayerInventory:initializePlayer(userId)`
3. **Replace catch handler:** Use `CatchingSystem:attemptCatch()` instead of old logic
4. **Add remote functions:**
   - PurchaseEquipment
   - EquipEquipment
   - GetEquipmentInfo
   - GetPlayerEquipment
5. **Update on leave:** Call `PlayerInventory:removePlayer(userId)`

**See:** EQUIPMENT_INTEGRATION_GUIDE.md for step-by-step code

---

## What's NOT Yet Built

- ✅ Equipment definitions
- ✅ Inventory management
- ✅ Catch system with rewards
- ❌ Level/XP system (needs separate module)
- ❌ Skill points system
- ❌ Client UI (equipment slot, catch rates, charge timer)
- ❌ Data persistence (save/load to database)
- ❌ Energy regeneration system

---

## Files Created

| File | Type | Purpose |
|---|---|---|
| src/shared/EquipmentData.lua | Module | Equipment definitions |
| src/server/PlayerInventory.lua | Module | Player stats & inventory |
| src/server/CatchingSystem.lua | Module | Catch attempt logic |
| EQUIPMENT_INTEGRATION_GUIDE.md | Guide | How to integrate into MainServer |
| EQUIPMENT_SYSTEM_SUMMARY.md | Doc | This file |

---

## Testing the Equipment System

### Manual Test Script

Create a LocalScript in ServerScriptService to test:

```lua
local EquipmentData = require(game.ReplicatedStorage.shared.EquipmentData)
local PlayerInventory = require(script.Parent.PlayerInventory)
local CatchingSystem = require(script.Parent.CatchingSystem)

-- Simulate a player
local testUserId = 12345

-- Initialize
PlayerInventory:initializePlayer(testUserId)
print("Initialized player")

-- Give coins
PlayerInventory:addCoins(testUserId, 1000)
print("Added 1000 coins: " .. PlayerInventory:getCoins(testUserId))

-- Purchase equipment
local result = CatchingSystem:purchaseEquipment(testUserId, "ReinforcedNet")
print("Purchase result: " .. (result.success and "SUCCESS" or "FAILED - " .. result.reason))

-- Equip
local equipResult = CatchingSystem:equipEquipment(testUserId, "ReinforcedNet")
print("Equipped: " .. PlayerInventory:getEquipped(testUserId))

-- Check catch rate
local equipped = PlayerInventory:getEquipped(testUserId)
local catchRate = EquipmentData:getCatchRate(equipped, "Rare")
print("Catch rate vs Rare with " .. equipped .. ": " .. catchRate .. "%")

print("✅ Equipment system test complete!")
```

---

## Next Steps

1. **Integrate into MainServer** — Follow EQUIPMENT_INTEGRATION_GUIDE.md
2. **Build Level/XP System** — Track player progression, unlock equipment
3. **Build Client UI** — Show equipment slot, success rates, charge timer
4. **Build Data Persistence** — Save/load player inventory
5. **Test in Studio** — Verify catching works with new system

---

*Created: 2026-06-09*
