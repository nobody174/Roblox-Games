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
- [x] Full documentation

### Phase 2: Ghost System & Gameplay Loop
- [ ] Ghost spawning system
- [ ] Ghost catching mechanics
- [ ] Ghost storage & inventory
- [ ] Basic UI (energy display, buttons)
- [ ] Ghost rarity system
- [ ] Basic catch success calculation

### Phase 3: Production & HQ
- [ ] Production System (passive income)
- [ ] HQ room system
- [ ] Room upgrade mechanics
- [ ] Multiplier calculations
- [ ] Room-specific benefits

### Phase 4: Training & Progression
- [ ] Ghost training system
- [ ] Stat progression (Catch Speed, Energy, Efficiency)
- [ ] Level cap system (Level 1-10)
- [ ] Training cost escalation

### Phase 5: Zones & Content
- [ ] Zone unlock system
- [ ] Zone-specific ghost spawning
- [ ] Zone difficulty scaling
- [ ] Boss ghost system
- [ ] Boss encounter mechanics

### Phase 6: Auto Systems & Quality of Life
- [ ] Auto-catch system
- [ ] Auto-train system
- [ ] UI improvements
- [ ] Notifications

### Phase 7: Monetization
- [ ] GamePass detection & benefits
- [ ] Developer product handling
- [ ] Premium payout tracking
- [ ] Revenue analytics

### Phase 8: Polish
- [ ] Animations & effects
- [ ] Sound design
- [ ] Visual feedback
- [ ] UI polish
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

## FINAL NOTE

This game is built to be **addictive, fair, and profitable**. The design philosophy is:
- **Fun first** - Game must be enjoyable
- **Fair second** - No forced spending
- **Money third** - Revenue from engaged players

Build it with this in mind. Every feature should ask: "Does this make the game more fun or more profitable?"

**Let's build something amazing.** 🎮👻

---

**Ready to code?** Ask me to build any phase. I'll handle the rest.
