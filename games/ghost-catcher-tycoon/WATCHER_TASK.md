# Watcher Task: Phase 5-10 Expansion (Ghost Catcher Tycoon)

**Status:** Ready for autonomous work  
**Target:** Expand core gameplay with new systems, progression, and content  
**Scope:** Continue from Phase 4 (Ghost Spawning & Catching Loop) through Phase 10 (Polish)

---

## Project Context

**Game:** Ghost Catcher Tycoon (Roblox Tycoon)  
**Vision:** Addictive tycoon where players catch ghosts, earn energy (coins), unlock zones, train ghosts, and build an HQ base  
**Current State:**
- ✅ 11 biome zones with terrain, bridges, portals, ladders, boss arenas
- ✅ 120 ghosts across 6 rarities with personalities
- ✅ Ghost spawning system (ghosts appear in zones every 3 seconds)
- ✅ Catch mechanics (click button → deduct charge → get ghost + coins)
- ✅ Polished UI with tabs (Ghost, HQ, Zones, Shop, Info)
- ✅ 18 game systems coded (GhostService, BossSystem, TrainingSystem, ProductionSystem, etc.)
- ❌ Most systems wired but not connected to gameplay

**Philosophy:** Build with systems that already exist. Don't reinvent. Wire systems together. Test frequently. Keep it simple until it works, then polish.

---

## What to Build (Phases 5-10)

### **Phase 5: Production System & Passive Income** ⏳

**Goal:** Ghosts generate energy while in HQ (passive income/tycoon feel)

**What exists:**
- `ProductionSystem.lua` — Calculates energy per second from caught ghosts
- `HQSystem.lua` — Manages room upgrades (multipliers for income)

**Your work:**
1. **Wire ProductionSystem to MainServer.lua**
   - Create production loop that runs every 1 second
   - Calculate total energy from all player ghosts: `productionSystem:calculateEnergyPerSecond(player)`
   - Add energy to player: `currencySystem:addEnergy(player, amount, "production")`
   - Send UI update to client with new energy total

2. **Wire HQSystem tabs to GameClient.lua**
   - Populate "HQ" tab with 5 rooms: GhostChamber, TrainingFacility, EnergyReactor, ResearchLab, BossArena
   - Show room level + upgrade cost
   - Create "Upgrade" button → call `UpgradeRoom` remote
   - Wire remote in MainServer to: `hqSystem:upgradeRoom(player, roomName)` → deduct energy → increase level → notify client

3. **Test:** Catch ghost → it generates energy passively → top panel energy rises every second

**Files to modify:**
- `src/server/MainServer.lua` — Add production loop + UpgradeRoom handler
- `src/client/GameClient.lua` — Populate HQ tab content

**Reference:** `GAMEPLAY_PLAN.md`, `SYSTEM_ARCHITECTURE.md`

---

### **Phase 6: Zone Unlocking System** ⏳

**Goal:** Players unlock zones with coins (progression, replayability)

**What exists:**
- `ZoneData.lua` — 11 zones with unlock costs (0 to 1.5M energy)
- `ZoneSystem.lua` — Handles zone unlocking logic

**Your work:**
1. **Wire ZoneSystem to MainServer.lua**
   - Create handler for `UnlockZone` remote (already created in MainServer)
   - Call `zoneSystem:unlockZone(player, zoneName)` → deduct coins → unlock zone → notify client

2. **Populate Zones tab in GameClient.lua**
   - Get player's unlocked zones from DataManager
   - Show all 11 zones with:
     - Zone name + biome description
     - Unlock cost (show "Unlocked ✓" if already owned)
     - Lock indicator if not unlocked
     - "Unlock" button → fire UnlockZone remote

3. **Test:** Catch ghosts → earn coins → unlock new zone → fly there, see different ghosts

**Files to modify:**
- `src/client/GameClient.lua` — Populate Zones tab
- (MainServer handler should already be wired from Phase 4)

**Reference:** `ZoneData.lua` (spawn pools per zone), `GAMEPLAY_PLAN.md`

---

### **Phase 7: Training System** ⏳

**Goal:** Level up caught ghosts to increase their stats (progression, replayability)

**What exists:**
- `TrainingSystem.lua` — Handles ghost training (costs coins, increases level 1-10)
- GhostService stores ghost level in attributes

**Your work:**
1. **Populate Ghost tab in GameClient.lua**
   - Show caught ghosts in a grid/list
   - Per ghost, show: Name + Rarity (colored) + Level
   - Add "Train" button per ghost → call `TrainGhost` remote
   - Show cost to train (scales with level)

2. **Wire TrainGhost remote in MainServer.lua**
   - Call `trainingSystem:startTraining(player, ghostId, targetLevel)`
   - Deduct energy, increase ghost level, notify client
   - Update Ghost tab to show new level

3. **Test:** Catch ghost → click Train → level increases, coins decrease, ghost stats improve

**Files to modify:**
- `src/client/GameClient.lua` — Populate Ghost tab with real ghost data
- `src/server/MainServer.lua` — Add TrainGhost handler (if not already there)

**Reference:** `TrainingSystem.lua`, `GhostCardBuilder.lua`

---

### **Phase 8: Shop & Eggs (Gacha)** ⏳

**Goal:** Players buy eggs with coins, hatch them for new ghosts (monetization, luck mechanic)

**What exists:**
- `EggData.lua` — 7 egg types with rarity drop tables
- `EggSystem.lua` — Handles hatching logic
- `GachaSystem.lua` — Manages gacha pulls

**Your work:**
1. **Populate Shop tab in GameClient.lua**
   - Show 7 egg types with:
     - Egg name + description
     - Price in coins
     - Rarity drop chances (Common 80%, Uncommon 18%, etc.)
     - "Hatch" button → fire HatchEgg remote

2. **Wire HatchEgg remote in MainServer.lua**
   - Call `eggSystem:hatchEgg(player, eggType)`
   - Deduct coins, generate ghost (random rarity from egg's pool)
   - Add ghost to inventory via `ghostService:givePlayerRandomGhost()`
   - Notify client with hatched ghost name + rarity
   - Update Ghost tab

3. **Test:** Have coins → buy egg → hatch → new ghost appears in inventory

**Files to modify:**
- `src/client/GameClient.lua` — Populate Shop tab
- `src/server/MainServer.lua` — Add/wire HatchEgg handler

**Reference:** `EggData.lua`, `GachaSystem.lua`

---

### **Phase 9: Auto Systems & Quality of Life** ⏳

**Goal:** GamePass features (auto-catch, auto-train) for idle/AFK gameplay

**What exists:**
- `AutoCatchSystem.lua` — Auto-catch mechanic (catches ghosts without player input)
- `AutoTrainSystem.lua` — Auto-train mechanic (trains ghosts automatically)
- `MonetizationSystem.lua` — Handles GamePass grants

**Your work:**
1. **Create GamePass buttons in Info tab** (optional for MVP, but structure it)
   - Show available GamePasses: Auto-Catch, Auto-Train, Double Energy, etc.
   - Show price in Robux
   - Button → call `PurchaseGamePass` remote (already wired in MainServer)

2. **Wire auto systems to MainServer**
   - Add background loops for AutoCatchSystem and AutoTrainSystem
   - Run `autoCatchSystem:autoFetch(player)` every 2-3 seconds if player has GamePass
   - Run `autoTrainSystem:autoTrain(player)` every 5 seconds if player has GamePass

3. **Test:** Enable auto systems → ghosts catch and train without clicking

**Files to modify:**
- `src/server/MainServer.lua` — Add auto system loops
- `src/client/GameClient.lua` — Add Info tab content (GamePass info)

**Reference:** `AutoCatchSystem.lua`, `AutoTrainSystem.lua`, `MonetizationSystem.lua`

---

### **Phase 10: Polish & Content Expansion** ⏳

**Goal:** Visual feedback, sound, animations, balance tweaks, more content

**Your work:**

1. **Visual Feedback on Catches**
   - Add particles when ghost is caught (already exists in Studio assets)
   - Flash the catch button
   - Add "+X coins" floating text above player

2. **Notifications System**
   - Already built in GameClient.lua
   - Fire notifications for key events: ghost caught, zone unlocked, level up, room upgraded

3. **Balance Tweaks** (in config.lua)
   - Adjust ghost spawn rate (currently 3 seconds per zone)
   - Adjust coin rewards per rarity
   - Adjust unlock costs for zones (player flow feedback)
   - Adjust training costs

4. **Content Expansion**
   - Add more ghost variants (recolor/rename existing ghosts)
   - Add more zone descriptions
   - Add flavor text to rooms/eggs

5. **Test & Iterate**
   - Play through full game loop: catch → earn → train → unlock → repeat
   - Check for balance issues (too easy? too grindy?)
   - Fix any bugs found during testing

**Files to modify:**
- `src/shared/config.lua` — Balance numbers
- `src/client/GameClient.lua` — Add particles/animations
- Add flavor text to data files

**Reference:** `BALANCE_GUIDE.md`, existing particle effects in Studio

---

## Implementation Rules

### **Code Style**
- **Naming:** `camelCase` for variables/functions, `PascalCase` for modules, `SCREAMING_SNAKE_CASE` for constants
- **Comments:** Only "WHY", not "WHAT" — code should be self-documenting
- **Indentation:** 2 spaces (not tabs)
- **Structure:** One feature per commit, descriptive messages

### **Architecture**
- **Server-authoritative:** All logic runs on server, client only sends requests
- **RemoteEvents:** Use existing remotes in Constants.Remotes
- **Systems:** Call existing systems (CurrencySystem, GhostService, etc.) — don't duplicate
- **Data:** Store in DataManager, persist to DataStore

### **Testing**
- Test in Studio after each phase
- Verify Output logs for errors
- Check that UI updates match backend data
- Player flow: catch → earn → spend → progress (repeat)

### **Documentation**
- Update phase summary files as you complete phases
- Keep MASTER_PROMPT.md in sync with current status
- Document any new config values in config.lua comments

---

## Reference Materials

**Codebase Architecture:**
- `SYSTEM_ARCHITECTURE.md` — Full system diagram
- `MASTER_PROMPT.md` — Project vision, design philosophy, all systems overview

**Game Design:**
- `GAMEPLAY_PLAN.md` — MVP loop, phase breakdown
- `BALANCE_GUIDE.md` — Economy, ghost stats, unlock costs
- `ZONE_DATA.lua` — All zones with spawn pools

**Implementation Examples:**
- `PHASE_4_IMPLEMENTATION.md` — How Phase 4 was wired (reference pattern)
- `MainServer.lua` — How remotes are handled (follow same pattern)
- `GameClient.lua` — How UI tabs are structured

---

## How to Request Help

If you need clarification on any part:

1. **Code question?** → Check the relevant .lua file, read function signatures
2. **Design question?** → Check SYSTEM_ARCHITECTURE.md or MASTER_PROMPT.md
3. **Data question?** → Check src/shared/{GhostData, ZoneData, BossData, EggData, constants, enums}.lua
4. **Implementation blocked?** → Ask clearly: "I'm wiring Phase X. System Y needs input Z. What should I do?"

---

## Success Criteria

When complete, this phase set should deliver:
- ✅ Ghosts generate passive income in HQ
- ✅ Players unlock new zones with coins (progression)
- ✅ Players train ghosts to increase stats (long-term goal)
- ✅ Players buy eggs for new ghosts (monetization loop)
- ✅ Auto-catch/auto-train for idle gameplay (monetization)
- ✅ Full core loop functional: Catch → Earn → Train → Unlock → Repeat
- ✅ Game is balanced and fun to play
- ✅ All systems wired together and tested

---

## Starting Point

1. **Read:** PHASE_4_IMPLEMENTATION.md (understand how Phase 4 was wired)
2. **Read:** SYSTEM_ARCHITECTURE.md (understand how systems work together)
3. **Start Phase 5:** Open `src/server/MainServer.lua` → add production loop
4. **Test:** Play game → watch energy increase every second → confirm it works
5. **Commit:** `git commit -m "feat: Phase 5 - Production System wiring"`
6. **Move to Phase 6:** Continue with Zone Unlocking

---

## Notes for Watcher

- **You have all the systems already coded.** Your job is to **wire them together** and **populate UI tabs.**
- **Don't reinvent.** Use what exists. If GhostService.lua exists, call it — don't rewrite it.
- **Test frequently.** After each phase, verify in Studio that the feature works.
- **Keep commits small.** One phase = one commit (or one feature per commit if a phase is large).
- **Ask for help if blocked.** If a system doesn't behave as expected, ask Claude for clarification.

---

**You've got this! Build something awesome.** 🎮👻

---

*Last updated: 2026-06-03*  
*Phase 4 complete. Ready for Phases 5-10.*
