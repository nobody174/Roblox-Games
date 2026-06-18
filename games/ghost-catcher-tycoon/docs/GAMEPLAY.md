<!--
  Ghost Catcher Tycoon - Gameplay Guide
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Gameplay Guide

**Last Updated**: June 18, 2026

---

## 🎮 Core Game Loop

### Main Progression
1. **Click to Charge** → Increase vacuum power (0-100%)
2. **Catch Ghosts** → In exploration zones
3. **Return to HQ** → Ghosts generate passive energy
4. **Train Ghosts** → Level up caught ghosts (1-10)
5. **Upgrade HQ** → Build rooms for production multipliers
6. **Unlock Zones** → Progress to harder zones
7. **Repeat** → Infinite tycoon progression

---

## 🎯 Core Mechanics

### Vacuum Charging
- **How**: Click the vacuum button to charge power
- **Power Bar**: Shows charge level (0-100%)
- **Catch Rate**: By rarity:
  - Common: 80% base
  - Uncommon: 65% base
  - Rare: 50% base
  - Epic: 35% base
  - Legendary: 20% base
  - Corrupted: 10% base
- **Cost**: Free to charge (no energy cost)
- **Cooldown**: 10% deduction per catch attempt

### Ghost Catching
- **Location**: 11 exploration zones + Hub
- **Spawn Rate**: New ghosts spawn every 3 seconds per zone
- **Requirement**: Vacuum charged to 10%+
- **Success**: Roll against rarity catch rate
- **Failure**: Vacuum depletes, ghost remains spawned
- **Max per Zone**: 5 ghosts at a time
- **Auto-Catch**: Background catching if purchased

### Ghost Rarities (6 Tiers)

| Rarity | Color | Catch Rate | Energy/sec | Level Cap |
|--------|-------|-----------|-----------|-----------|
| Common | Gray | 80% | 1× | 10 |
| Uncommon | Green | 65% | 1.5× | 10 |
| Rare | Blue | 50% | 2× | 10 |
| Epic | Purple | 35% | 3× | 10 |
| Legendary | Gold | 20% | 6× | 10 |
| Corrupted | Red | 10% | 9× | 10 |

### Bringing Ghosts Home
- **Mechanic**: Click "Bring Home" button at HQ
- **Coins Earned**: 10% bonus coins per ghost × rarity multiplier
- **Storage**: Ghosts stored in HQ (limited by Ghost Chamber upgrades)
- **Energy Generation**: Ghosts immediately start producing energy
- **Auto-Bring**: Happens every time you return to Hub

### Passive Energy Generation
- **Base Formula**: `ghost_rarity_multiplier × ghost_level × room_multiplier`
- **Rarity Multiplier**: 1× (Common) to 9× (Corrupted)
- **Level Multiplier**: 1 + (level × 0.1) → max 2× at level 10
- **Room Multiplier**: Stacks across rooms (Ghost Chamber, Energy Reactor, etc.)

**Example**:
- 5 Common ghosts (level 1): 5 × 1 energy/sec
- With Ghost Chamber v2 (+50%): 7.5 energy/sec
- Level up to 10: 7.5 × 2 = 15 energy/sec

### Ghost Training
- **Purpose**: Level up caught ghosts (1-10)
- **Cost**: Energy (scales by level: 75 × level)
- **Rewards Per Level**:
  - +10% catch speed
  - +10% energy production
  - Stat improvement tracking
- **Auto-Train**: Background training if purchased

### HQ Room Upgrades (5 Rooms)

| Room | Purpose | Levels | Effect |
|------|---------|--------|--------|
| Ghost Chamber | Storage | 1-10 | +10 slots per level |
| Training Facility | Training | 1-10 | +50% training speed |
| Energy Reactor | Production | 1-10 | +50% energy multiplier per level |
| Research Lab | Skill unlocks | 1-10 | Unlock passive bonuses |
| Boss Arena | Boss battles | 1-10 | Unlock harder bosses |

**Upgrade Cost**: 100 × (next_level ^ 1.5) coins

### Zone Progression

**11 Exploration Zones** (Plus Hub & private Home):
1. **Hub** (Starting Area) - Public, no ghosts spawn here
2. **Whisper Woods** - Common/Uncommon ghosts, first zone
3. **Foggy Fields** - Common/Uncommon/Rare ghosts
4. **Gloomy Graveyard** - Uncommon/Rare ghosts, first boss zone
5. **Electro Alley** - Uncommon/Rare/Epic ghosts
6. **Frostbite Caverns** - Uncommon/Rare/Epic ghosts
7. **Sunken Spirit Reef** - Rare/Epic ghosts
8. **Clocktower District** - Rare/Epic/Legendary ghosts
9. **Astral Observatory** - Epic/Legendary ghosts
10. **Phantom Fortress** - Epic/Legendary ghosts
11. **The Rift** - Legendary/Corrupted ghosts (harder)
12. **Eternity Nexus** - Legendary/Corrupted ghosts (endgame)

**Zone Unlock**: Click unlock button, pay coins, gain access

### Equipment System (9 Tiers)

Equipment boosts catch rates for specific rarities:
- Tier 1: Basic Net (free), Reinforced Net (500 coins)
- Tier 2: Ghost Trap (2000 coins), Spectral Cage (3500 coins)
- Tier 3: Ectoplasm Blaster (8000 coins), Quantum Device (15000 coins)
- Tier 4: Proton Pack (25000 coins), Dimensional Siphon (40000 coins)
- Tier 5: Ghost Buster's Ultimate (100000 coins)

**Note**: Equipment purchased but not yet implemented in GUI.

### Player Leveling
- **XP Source**: Catching ghosts (25 XP per ghost caught)
- **Level Rewards**: Unlock zones, skills, abilities
- **Max Level**: Unlimited (prestige system available)
- **Skill Tree**: Unlock passive bonuses per level

### Collections & Personalities

**120 Unique Ghosts** across rarities with:
- Unique names & artwork
- Personality traits (Shy, Angry, Playful, Lazy, Hyper)
- Statistical variation (catch speed, energy production)
- Special animation

### Gacha/Egg System

**5 Egg Types** (by rarity):
- Common Egg: 250 coins
- Uncommon Egg: 1200 coins
- Rare Egg: 5000 coins
- Epic Egg: 15000 coins
- Legendary Egg: 45000 coins

**Result**: Random ghost of that rarity tier

### Prestige System
- **Mechanic**: Reset progress for prestige points
- **Reward**: Permanent multiplier (+10% per prestige level)
- **Cost**: Unlock at specific level
- **Bonus**: Keeps equipment & cosmetics

### PvP Battles (Optional)
- **Challenge**: Battle another player with your ghosts
- **Energy Requirement**: 1000 energy per battle
- **Win Reward**: 500 coins + 100 XP
- **Loss Penalty**: -250 coins
- **Leaderboard**: Track wins/losses/rating

### Auto Systems (GamePass Features)

**Auto-Catch** (background catching):
- Automatically catches ghosts every 2 seconds in current zone
- Runs in background even if afk
- Respects inventory limits
- Stops when full

**Auto-Train** (background training):
- Automatically trains lowest-level ghosts
- Runs in background
- Prioritizes ghosts by level (trains lowest first)
- Requires energy

### Admin Commands (Testing)
```
/coin         - Add 1000 coins
/energy       - Add 1000 energy
/ghost [name] - Spawn ghost in inventory
/spawnworld [name] - Spawn ghost visible in world
```

---

## 📈 Progression Timeline

### Early Game (0-1 hour)
- Catch Common/Uncommon ghosts
- Unlock first 2-3 zones
- Upgrade Ghost Chamber once
- Reach Level 10

### Mid Game (1-5 hours)
- Catch Rare/Epic ghosts
- Unlock zones 5-8
- Train ghosts to level 5-7
- Upgrade 3+ rooms
- Reach Level 30-50

### Late Game (5+ hours)
- Hunt Legendary/Corrupted ghosts
- Unlock zones 9-12
- Prestige system becomes viable
- Min-max equipment & skills
- Compete on leaderboards

---

## 💰 Economy

### Income Sources
- Ghost catching (coins reward by rarity)
- Zone completion bonuses
- Level-up rewards
- PvP victories
- Leaderboard ranking bonuses

### Expenses
- Ghost training (energy)
- HQ room upgrades (coins)
- Zone unlocks (coins)
- Equipment purchases (coins)
- Gacha pulls (coins)

### Balance
- Game is free-to-play
- GamePasses optional (no pay-to-win)
- Early progression fast, late progression slower
- Monetization focuses on convenience, not power

---

## 🎯 Endgame Goals

1. **Collect All Ghosts** (120 unique ghosts)
2. **Max All Rooms** (Level 10 each room)
3. **Level 100+** (Prestige multiple times)
4. **Leaderboard Rank** (Top 10)
5. **Special Achievements** (Coming post-launch)

---

**Next Update**: July 2026 (seasonal event content)

Last Updated: June 18, 2026
