# Ghost Catching Equipment & Progression System

## Equipment Tiers & Progression

### Tier 1: Starter Equipment (Level 0-10)
**Basic Net** ✅ Default
- Cost: Free (starting item)
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 80%
  - Rare: 40%
  - Epic: 10%
  - Legendary: 0%
  - Corrupted: 0%
- Charge Time: 3 seconds
- Energy Cost: 10 per catch attempt
- Description: "A simple butterfly net. Works on weak ghosts."

**Reinforced Net** 🟢 Unlock at Level 5
- Cost: 500 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 95%
  - Rare: 70%
  - Epic: 30%
  - Legendary: 5%
  - Corrupted: 0%
- Charge Time: 2.5 seconds
- Energy Cost: 12 per catch attempt
- Description: "Stronger weave catches trickier ghosts."

---

### Tier 2: Intermediate Equipment (Level 11-25)
**Ghost Trap** 🔵 Unlock at Level 10
- Cost: 2,000 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 85%
  - Epic: 60%
  - Legendary: 20%
  - Corrupted: 5%
- Charge Time: 4 seconds
- Energy Cost: 20 per catch attempt
- Description: "Boxes with magnetic closure. Harder for ghosts to escape."

**Spectral Cage** 🔵 Unlock at Level 15
- Cost: 3,500 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 95%
  - Epic: 80%
  - Legendary: 40%
  - Corrupted: 15%
- Charge Time: 5 seconds
- Energy Cost: 25 per catch attempt
- Description: "Ethereal containment field. Ghosts struggle against it."

---

### Tier 3: Advanced Equipment (Level 26-50)
**Ectoplasm Blaster** 🟡 Unlock at Level 20
- Cost: 8,000 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 100% ✅
  - Epic: 90%
  - Legendary: 65%
  - Corrupted: 35%
- Charge Time: 3 seconds
- Energy Cost: 30 per catch attempt
- Description: "Blasts with ectoplasm to stun and contain ghosts."

**Quantum Containment Device** 🟡 Unlock at Level 30
- Cost: 15,000 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 100% ✅
  - Epic: 100% ✅
  - Legendary: 85%
  - Corrupted: 60%
- Charge Time: 6 seconds
- Energy Cost: 40 per catch attempt
- Description: "Uses quantum tech to lock ghosts in an inescapable state."

---

### Tier 4: Expert Equipment (Level 51-75)
**Proton Pack** 🟠 Unlock at Level 40
- Cost: 25,000 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 100% ✅
  - Epic: 100% ✅
  - Legendary: 95%
  - Corrupted: 80%
- Charge Time: 5 seconds
- Energy Cost: 50 per catch attempt
- Description: "Industrial-grade proton streams. Nearly unstoppable."

**Dimensional Siphon** 🟠 Unlock at Level 50
- Cost: 40,000 coins
- Catch Rate vs Rarity:
  - Common: 100% ✅
  - Uncommon: 100% ✅
  - Rare: 100% ✅
  - Epic: 100% ✅
  - Legendary: 100% ✅
  - Corrupted: 95%
- Charge Time: 7 seconds
- Energy Cost: 60 per catch attempt
- Description: "Tears open a dimensional rift to pull ghosts through."

---

### Tier 5: Legendary Equipment (Level 76-100)
**Ghost Buster's Ultimate Device** 🔴 Unlock at Level 75
- Cost: 100,000 coins
- Catch Rate vs Rarity:
  - All Rarities: 100% ✅ (except Corrupted at 99%)
- Charge Time: 4 seconds
- Energy Cost: 80 per catch attempt
- Description: "The ultimate ghost catching device. Almost never fails."

---

## Catch Mechanics: How It Works

### 1. Select Equipment
- Player chooses equipment from inventory
- Equipment slot shows current tool with stats
- Can swap equipment at any time

### 2. Target Ghost
- Aim at a ghost
- HUD shows:
  - Ghost rarity
  - Ghost name
  - Success rate with current equipment
  - Energy cost

### 3. Charge Up
- Hold button to charge (3-7 seconds depending on equipment)
- Visual feedback: charging bar or glowing effect
- Can't spam-catch — must wait for charge completion

### 4. Attempt Catch
- Release button to fire/throw
- Success roll: random(0, 100) <= catch_rate?
  - YES: Ghost captured, coins + XP awarded
  - NO: Ghost escapes, equipment takes 1 durability hit, no reward

### 5. Ghost Resistance
- **Poor equipment + high rarity ghost** = low success rate = multiple attempts needed
- **Good equipment + ghost evades** = temporary cooldown before re-attempt
- **Better equipment** = faster charge time, higher success rate

---

## Equipment Progression Strategy

### Early Game (Levels 0-15)
- **Start:** Basic Net (free)
- **Unlock:** Reinforced Net (Lvl 5) → Ghost Trap (Lvl 10) → Spectral Cage (Lvl 15)
- **Focus:** Catch Common/Uncommon ghosts in early zones
- **Earnings:** ~100-500 coins per ghost
- **XP:** ~25-75 XP per ghost

### Mid Game (Levels 16-40)
- **Unlock:** Ectoplasm Blaster (Lvl 20) → Quantum Containment (Lvl 30) → Proton Pack (Lvl 40)
- **Focus:** Now can catch Rare/Epic ghosts reliably
- **Earnings:** ~500-2,000 coins per ghost
- **XP:** ~100-300 XP per ghost
- **New zones open:** Access mid-tier islands (Gloomy Graveyard, Electro Alley, etc.)

### Late Game (Levels 41-75)
- **Unlock:** Dimensional Siphon (Lvl 50)
- **Focus:** Farm Legendary ghosts with high success rate
- **Earnings:** ~2,000-5,000 coins per ghost
- **XP:** ~500-1,000 XP per ghost
- **New zones:** Unlock hardest islands (The Rift, Eternity Nexus, etc.)

### Endgame (Levels 76-100)
- **Unlock:** Ghost Buster's Ultimate Device (Lvl 75)
- **Focus:** 100% catch rate (almost) on all ghosts
- **Earnings:** ~5,000-10,000 coins per ghost
- **XP:** ~1,000-2,000 XP per ghost
- **Challenge:** Race for high scores, Prestige modes

---

## Equipment Stats Summary Table

| Equipment | Tier | Level | Cost | Charge | Energy | Common | Uncommon | Rare | Epic | Legendary | Corrupted |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Basic Net | 1 | 0 | Free | 3s | 10 | 100% | 80% | 40% | 10% | 0% | 0% |
| Reinforced Net | 1 | 5 | 500 | 2.5s | 12 | 100% | 95% | 70% | 30% | 5% | 0% |
| Ghost Trap | 2 | 10 | 2K | 4s | 20 | 100% | 100% | 85% | 60% | 20% | 5% |
| Spectral Cage | 2 | 15 | 3.5K | 5s | 25 | 100% | 100% | 95% | 80% | 40% | 15% |
| Ectoplasm Blaster | 3 | 20 | 8K | 3s | 30 | 100% | 100% | 100% | 90% | 65% | 35% |
| Quantum Device | 3 | 30 | 15K | 6s | 40 | 100% | 100% | 100% | 100% | 85% | 60% |
| Proton Pack | 4 | 40 | 25K | 5s | 50 | 100% | 100% | 100% | 100% | 95% | 80% |
| Dimensional Siphon | 4 | 50 | 40K | 7s | 60 | 100% | 100% | 100% | 100% | 100% | 95% |
| Ultimate Device | 5 | 75 | 100K | 4s | 80 | 100% | 100% | 100% | 100% | 100% | 99% |

---

## Catch Attempt Flow (Pseudocode)

```lua
function attemptCatch(player, ghost, equipment)
    -- 1. Check if player has enough energy
    if player.energy < equipment.energyCost then
        return "NOT_ENOUGH_ENERGY"
    end
    
    -- 2. Get ghost rarity and equipment's catch rate for that rarity
    local ghostRarity = ghost:GetAttribute("Rarity")
    local catchRate = equipment.catchRates[ghostRarity]
    
    -- 3. Roll success (0-100 vs catch rate)
    local roll = math.random(0, 100)
    
    if roll <= catchRate then
        -- SUCCESS
        player.energy -= equipment.energyCost
        player.coins += rewardCoins(ghostRarity)
        player.xp += rewardXP(ghostRarity)
        ghost:Destroy()
        return "CAUGHT"
    else
        -- FAILED
        player.energy -= equipment.energyCost
        equipment.durability -= 1
        ghost:playEscapeAnimation()
        return "ESCAPED"
    end
end
```

---

## Future Features (Phase 2)

- **Equipment Durability** — Tools wear down, need repair (costs coins)
- **Elemental Equipment** — Specific tools work better on specific ghost types
- **Legendary Variants** — Gold/silver/ultra versions of each tier
- **Equipment Perks** — +10% catch rate, -1s charge time, -5 energy cost
- **Crafting System** — Combine materials to create better equipment

---

## Implementation Files to Create/Update

1. **EquipmentData.lua** — Define all equipment stats
2. **CatchingSystem.lua** — Handle catch attempt logic
3. **PlayerInventory.lua** — Track equipment ownership & equipped item
4. **EquipmentUI.lua** — Equipment slot selector in HUD
5. **Update MainServer** — Wire catching system into ghost spawning

---

*Created: 2026-06-09*
*For: Ghost Catcher Tycoon Progression System*
