<!--
  Ghost Catcher Tycoon - Master Prompt for Claude Code
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Master Prompt

**Copy this entire section and paste it into a new Claude Code chat to give context for the entire project.**

---

## CURRENT PROJECT STATUS (As of 2026-06-03)

### What's Done ✅
- **18 complete game systems** (all coded, not yet fully wired)
- **World generation** — 11 zones with terrain, props, bridges, portals, ladders, boss arenas
- **Polished UI** — Top panel, tab system, charge bar, buttons, notifications
- **Ghost index** — 120 ghosts across 6 rarities with personalities
- **Zone progression** — 11 zones with costs, biomes, ghost pools
- **Boss system** — 5 bosses with HP, loot tables
- **Egg system** — 7 gacha tiers with drop rates
- **File documentation** — All files have purpose lines and section headers

### What's Missing (MVP Blocker) ⏳
1. **Ghost spawning in zones** — Need to spawn colored spheres (by rarity) during gameplay
2. **Wire Catch/Charge buttons** — Connect UI buttons to GhostService and VacuumSystem
3. **Populate remaining tabs** — HQ, Zones, Shop, Info tabs need real content binding
4. **Test in Studio** — Verify catching mechanics, currency flow, UI updates

### How to Resume This Project
In a new chat, paste this entire MASTER_PROMPT.md and say:

> "Read the MASTER_PROMPT.md file from the ghost-catcher-tycoon project and let's keep working. We completed zones and UI. Next: wire ghost spawning and test catching mechanics in Studio."

This will get me up to speed on:
- Full system architecture (18 systems)
- Design philosophy (tycoon loop, monetization)
- Current code organization
- What phase we're on (Phase 3/4)
- What to build next (MVP catching loop)

---

## PROJECT CONTEXT

You are my coding partner for building **Ghost Catcher Tycoon**, a Roblox tycoon game.

### Game Overview
Ghost Catcher Tycoon is a **click-based tycoon/simulator** where players:
1. **Click to charge** a vacuum
2. **Catch ghosts** in different difficulty zones
3. **Bring ghosts home** where they generate passive income (Ecto-Energy)
4. **Train ghosts** to improve their stats
5. **Upgrade HQ rooms** for multipliers and new features
6. **Unlock new zones** with harder ghosts but better rewards
7. **Fight boss ghosts** for rare rewards
8. **Collect ghosts** with different rarities and personalities

### Core Loop (Compulsion Loop)
```
Click → Catch Ghost → Bring Home → Train → Earn Energy → Build HQ → Unlock Zone → [REPEAT]
```

This loop is designed for **engagement and monetization**. Players stay in it because:
- Immediate feedback (click → catch)
- Multiple reward types (collecting, earning, building, unlocking)
- Clear progression (always next goal)
- Passive income (feel productive while idle)
- Exponential growth (progress feels faster over time)

---

## GAME DESIGN PHILOSOPHY

### Player Psychology
- **Compulsion Loop:** Simple repeating actions create addiction
- **Dopamine Hits:** Catches, level-ups, unlocks trigger reward response
- **Progression Feel:** Exponential growth makes players feel powerful
- **Variety:** Personalities, zones, bosses prevent boredom
- **FOMO:** Limited-time events, rare spawns, leaderboards drive urgency

### Monetization Model (No Pay-to-Win)
Players buy for **convenience**, not power:
- **GamePasses (one-time):** Auto-Catch, Auto-Train, Double Energy, VIP Zone, Extra Storage
- **Developer Products (repeatable):** Energy packs, ghost eggs, boss tickets, training boosts
- **Premium Payouts:** Revenue from Premium member playtime

Free players can beat the game. Paid players beat it faster.

### Viral Design Elements
1. **Easy to learn, hard to master** - Click to catch on day 1, optimize builds by week 3
2. **Social proof** - Leaderboards, ghost collections, HQ showcases
3. **FOMO mechanics** - Limited-time bosses, seasonal ghosts, rare spawns
4. **Streamer appeal** - Visual satisfaction (particles), clear metrics, RNG hunts
5. **Mobile-friendly** - One-button gameplay, AFK-friendly, short sessions

---

## TECHNICAL ARCHITECTURE

### Server-Authoritative Design
- **All logic runs on server** - Client only sends requests
- **Server validates everything** - Prevents exploits
- **Client receives results** - Updates UI with server response
- **Security first** - No trusting client values

### System Structure (Modular)
```
MainServer (Router)
├── DataManager (Persistence)
├── CurrencySystem (Energy)
├── VacuumSystem (Charging)
├── GhostSystem (Catching/Storage)
├── HQSystem (Building/Upgrades)
├── ProductionSystem (Passive Income)
├── TrainingSystem (Ghost Leveling)
├── MonetizationSystem (Gamepasses/Products)
└── ZoneSystem (Unlocks/Spawning)
```

### RemoteEvent Communication
```
Client                  Server
  │                       │
  ├─ FireServer ────→ OnServerEvent ────→ System Handler
  │                       │
  └←─ FireClient ←─── Response ←───────┤
```

---

## CONFIGURATION-DRIVEN DESIGN

### All Game Balance in Config
**File:** `src/shared/config.lua`

Controls:
- Vacuum charge rates
- Ghost rarity spawn weights
- Zone unlock costs
- Room upgrade multipliers
- Training times & costs
- GamePass/Product prices
- Energy limits
- Security constraints

**Why:** Change game balance without touching code. Easy tuning for monetization.

---

## PHASE BREAKDOWN

### Phase 1: Core Systems ✅ COMPLETE
- [x] Data Manager (save/load with retry)
- [x] Currency System (energy tracking)
- [x] Vacuum System (charging)
- [x] Main Server (initialization/routing)
- [x] Config & Enums
- [x] All 18 game systems coded (GhostService, BossSystem, EggSystem, TrainingSystem, HQSystem, ZoneSystem, MonetizationSystem, etc.)
- [x] Full documentation + purpose lines added to all files
- [x] GhostData (120 ghosts), ZoneData (11 zones), BossData (5 bosses), EggData (7 eggs)

### Phase 2: World & Infrastructure ✅ COMPLETE
- [x] Procedural zone generation (ZONE_AUTO_BUILDER.lua)
  - 11 biome zones with terrain
  - Bridges connecting zones
  - Portals for teleportation
  - 5 boss arenas in sky
  - Ladders for climbing (with proper anchoring)
  - Props (towers, fountains, arches)
  - Proper lighting per biome
- [x] Fly Tool for testing (FLY_TOOL.lua) — camera-relative flight, WASD movement
- [x] Hub spawn location at Y=30

### Phase 3: UI & Client Wiring ⚠️ IN PROGRESS
- [x] GameClient.lua — Polished layout with charge button, catch button, bring home button
- [x] Top panel (80px) — Energy, ghosts, production rate, zone display
- [x] Bottom tab bar (52px) — Ghost, HQ, Zones, Shop, Info tabs
- [x] Sliding panel system — Expands/collapses with smooth tween
- [x] Charge progress bar — Visual feedback with percentage
- [x] Notification system — Slides in from top, fades out
- [x] GhostCardBuilder.lua — Reusable card component for ghost inventory
- [ ] Wire Catch button to GhostService.spawnGhostInWorld (spawn ghosts in zones)
- [ ] Wire Charge button to VacuumSystem (recharge mechanics)
- [ ] Populate HQ tab (show rooms, upgrade buttons)
- [ ] Populate Zones tab (show unlock costs, unlock buttons)
- [ ] Populate Shop tab (show eggs, hatch buttons)
- [ ] Populate Info tab (show stats, how to play)

### Phase 4: Ghost Spawning & Catching Loop ⏳ NEXT
- [ ] Spawn ghosts in zones (call GhostService in ZONE_AUTO_BUILDER or new spawner)
- [ ] Ghost catching mechanics (color-coded spheres by rarity)
- [ ] Catch success calculation (based on rarity + vacuum charge)
- [ ] Ghost inventory persistence (GhostService stores in player)
- [ ] Reward coins on catch (currency for zone unlocks and upgrades)

### Phase 5: Production & HQ
- [ ] Production System wiring (passive income from caught ghosts)
- [ ] HQ room system (GhostChamber, TrainingFacility, EnergyReactor, ResearchLab, BossArena)
- [ ] Room upgrade mechanics (costs coins, increases income multiplier)
- [ ] Multiplier calculations

### Phase 6: Training & Progression
- [ ] Ghost training system wiring
- [ ] Stat progression (Catch Speed, Energy, Efficiency)
- [ ] Level cap system (Level 1-10)
- [ ] Training cost escalation

### Phase 7: Zones & Bosses
- [ ] Zone unlock system wiring
- [ ] Zone-specific ghost spawning (use ZoneData weighted pools)
- [ ] Boss ghost system wiring
- [ ] Boss encounter mechanics

### Phase 8: Auto Systems & Quality of Life
- [ ] Auto-catch system
- [ ] Auto-train system
- [ ] UI improvements
- [ ] Notifications

### Phase 9: Monetization
- [ ] GamePass detection & benefits
- [ ] Developer product handling
- [ ] Premium payout tracking

### Phase 10: Polish
- [ ] Animations & effects
- [ ] Sound design
- [ ] Visual feedback
- [ ] Game balance tweaking

---

## GHOST SYSTEM DESIGN

### Ghost Attributes
Each ghost has:
- **Rarity** (Common, Uncommon, Rare, Legendary, Mythic)
- **Personality** (Shy, Angry, Playful, Lazy, Hyper, Corrupted)
- **Stats:** Catch Speed, Energy Production, Training Efficiency
- **Level** (1-10)
- **Unique ID** (for persistence)

### Personality Bonuses
| Personality | Bonus | Trade-off |
|-------------|-------|-----------|
| Shy | +20% energy | Harder to catch |
| Angry | +30% catch speed | Normal energy |
| Playful | Random boosts | Unpredictable |
| Lazy | Cheaper to train | Slow training |
| Hyper | Fast training | Loses stats over time |
| Corrupted | +100% energy | Cursed (late-game) |

### Rarity System
| Rarity | Catch % | Energy/sec | Spawn % | Challenge |
|--------|---------|------------|---------|-----------|
| Common | 80% | 1 | 50% | Easy |
| Uncommon | 60% | 2 | 30% | Normal |
| Rare | 40% | 5 | 15% | Hard |
| Legendary | 20% | 10 | 4% | Very Hard |
| Mythic | 5% | 25 | 1% | Extreme |

---

## ZONE SYSTEM DESIGN

### All Zones
| Zone | Unlock Cost | Multiplier | Ghosts | Challenge |
|------|-------------|------------|--------|-----------|
| Forest | 0 (start) | ×1.0 | Common/Uncommon | Easy |
| Graveyard | 500 energy | ×1.2 | Uncommon/Rare | Normal |
| Mansion | 5,000 energy | ×1.5 | Rare/Legendary | Hard |
| Dark Dimension | 50,000 energy | ×2.0 | Legendary/Mythic | Extreme |

**Spawn Rate:** 5 ghosts/second per zone (configurable)

---

## MONETIZATION DETAILS

### GamePass Prices
| Pass | Price | Benefit | Player Type |
|------|-------|---------|-------------|
| Extra Storage | 299R | Double ghost slots | Everyone |
| Auto-Catch | 699R | Passive catching | Casual |
| Auto-Train | 499R | Passive training | Casual |
| Double Energy | 399R | 2× income | Enthusiasts |
| VIP Zone | 799R | Best ghosts | Whales |
| Faster Vacuum | 349R | 2× click rate | Active |

### Developer Products
| Product | Price | Gives | Use Case |
|---------|-------|-------|----------|
| Energy Pack | 100R | 1,000 energy | Impatient |
| Ghost Egg | 299R | Random ghost | Collectors |
| Boss Ticket | 199R | Boss fight | Hunters |
| Training Boost | 99R | 2× speed 1hr | Power users |
| Vacuum Overcharge | 149R | 2× catch 30min | Hunters |

---

## CODING STANDARDS

### Naming Conventions
- Variables: `camelCase` → `playerSpeed`, `energyAmount`
- Functions: `camelCase` → `getPlayerEnergy()`, `addGhost()`
- Modules: `PascalCase` → `DataManager`, `GhostSystem`
- Constants: `SCREAMING_SNAKE_CASE` → `MAX_PLAYERS`, `BASE_ENERGY`

### Code Structure
- **Indentation:** 2 spaces (not tabs)
- **Comments:** Only "WHY", not "WHAT" (code should be self-documenting)
- **Functions:** Single responsibility principle
- **Error handling:** Validate inputs, not outputs
- **Performance:** Batch operations, cache where possible

### File Organization
```
src/
├── server/
│   ├── MainServer.lua
│   ├── data/
│   │   └── DataManager.lua
│   └── systems/
│       ├── CurrencySystem.lua
│       ├── VacuumSystem.lua
│       ├── GhostSystem.lua
│       ├── HQSystem.lua
│       ├── ProductionSystem.lua
│       ├── TrainingSystem.lua
│       └── ZoneSystem.lua
├── client/
│   ├── GameClient.lua
│   ├── UIManager.lua
│   ├── InputManager.lua
│   └── systems/
│       └── [Client-side systems]
└── shared/
    ├── config.lua
    ├── enums.lua
    └── constants.lua
```

### RemoteEvent Names (from Constants)
- `ChargeVacuum` - Player clicks vacuum
- `CatchGhost` - Attempt to catch ghost
- `BringGhostsHome` - Return ghosts to HQ
- `TrainGhost` - Train a ghost
- `UpgradeRoom` - Upgrade HQ room
- `UnlockZone` - Unlock new zone
- `UpdateUI` - Server → Client (UI update)
- `ShowNotification` - Server → Client (notify player)
- `GetGameState` - Client requests initial state

---

## YOUR CONSTRAINTS

### Build Philosophy
1. **Clean Code:** Easy to debug and extend
2. **Modular Systems:** Each system independent
3. **Configuration-Driven:** Numbers in config.lua, not code
4. **Don't Over-Engineer:** Build what's needed, not hypothetical features
5. **Test Frequently:** Verify each system works before next phase

### What NOT to Build
- ❌ Trading system (future phase)
- ❌ Guilds/clans (future phase)
- ❌ User cosmetics UI (future phase)
- ❌ Offline progression (would break monetization)

### What IS Priority
1. **Catch → Home → Earn loop**
2. **Data persistence**
3. **Basic UI to see progress**
4. **HQ building mechanics**
5. **Monetization integration**

---

## GETTING HELP

When you ask for something, provide:
1. **What I'm building:** "Build Ghost System"
2. **What it should do:** Spawn, catch, store ghosts
3. **How it integrates:** Works with VacuumSystem + ProductionSystem

I will provide:
1. **Complete code** - Copy/paste ready
2. **File structure** - Where to place it
3. **How it works** - Explanation of mechanics
4. **How to test** - Verification steps
5. **What's next** - Natural next step

---

## QUICK REFERENCE

### Core Configuration (config.lua)
- Vacuum charge per click: `Config.VacuumChargePerClick`
- Max vacuum charge: `Config.VacuumMaxCharge`
- Initial energy: `Config.InitialEnergy`
- Default ghost storage: `Config.DefaultGhostStorage`
- Rarities table: `Config.Rarities`
- Zones table: `Config.Zones`
- Rooms table: `Config.Rooms`
- GamePass prices: `Config.GamePasses`
- Product definitions: `Config.Products`

### Key Services (from Constants)
- Players: `Constants.Services.Players`
- DataStore: `Constants.Services.DataStoreService`
- RunService: `Constants.Services.RunService`
- ReplicatedStorage: `Constants.Paths.ReplicatedStorage`

### Time Constants (seconds)
- Auto-save interval: 30 seconds
- Production tick: 1 second
- UI update: 0.5 seconds
- Ghost despawn: 60 seconds

---

## SUCCESS CRITERIA

When we're done:
- ✅ Game is fully playable (click → catch → earn → build)
- ✅ All systems tested and balanced
- ✅ Monetization integrated and functional
- ✅ Data saves/loads correctly
- ✅ Ready for live testing with testers
- ✅ Code is clean and documented
- ✅ Performance is optimized

---

## KEY FILE LOCATIONS (Updated 2026-06-03)

### Data Files (Shared)
- `src/shared/GhostData.lua` — 120 ghosts, rarities, personalities
- `src/shared/ZoneData.lua` — 11 zones, unlock costs, ghost pools
- `src/shared/BossData.lua` — 5 bosses, HP, loot tables
- `src/shared/EggData.lua` — 7 eggs, rarity chances, drop pools
- `src/shared/constants.lua` — Services, remotes, time limits
- `src/shared/enums.lua` — Rarities, zones, rooms, currency types

### Server Systems
- `src/server/MainServer.lua` — Entry point, system initialization
- `src/server/systems/GhostService.lua` — Ghost inventory management
- `src/server/systems/VacuumSystem.lua` — Charge accumulation
- `src/server/systems/GhostSystem.lua` — Catching mechanics
- `src/server/systems/CurrencySystem.lua` — Energy tracking
- `src/server/systems/ProductionSystem.lua` — Passive income
- `src/server/systems/HQSystem.lua` — Room upgrades
- `src/server/systems/ZoneSystem.lua` — Zone unlocking
- `src/server/systems/BossSystem.lua` — Boss encounters
- `src/server/systems/TrainingSystem.lua` — Ghost leveling
- `src/server/data/DataManager.lua` — Save/load persistence

### Client & UI
- `src/client/GameClient.lua` — Main UI: panels, tabs, buttons, notifications
- `src/client/modules/GhostCardBuilder.lua` — Reusable ghost card component

### World Generation & Testing
- `ZONE_AUTO_BUILDER.lua` — Procedural zone generation (11 zones, terrain, props, bridges, portals, ladders, boss arenas)
- `FLY_TOOL.lua` — Camera-relative flight tool for testing (Press F to toggle)

### Game File
- `place.rbxl` — **Your Roblox Studio game file** (open this in Studio to test)
- `place.rbxl.lock` — Auto-generated lock file (ignore)

### Documentation
- `GAMEPLAY_PLAN.md` — Game design, MVP features, implementation strategy
- `DOCUMENTATION_IMPROVEMENTS.md` — Record of docs added this session
- `README.md` — Project overview
- Status docs in root (can be archived or removed)

---

## FINAL NOTE

This game is built to be **addictive, fair, and profitable**. The design philosophy is:
- **Fun first** - Game must be enjoyable
- **Fair second** - No forced spending
- **Money third** - Revenue from engaged players

Build it with this in mind. Every feature should ask: "Does this make the game more fun or more profitable?"

**Current momentum:** Zones + UI done. Ready to wire catching mechanics and test in Studio.

**Let's build something amazing.** 🎮👻

---

**Ready to code?** Start with Phase 4 (Ghost Spawning & Catching Loop) or ask for a specific system. I'll handle the rest.
