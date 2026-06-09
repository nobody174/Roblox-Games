# AGENT PROMPT: Build Ghost Catcher Tycoon Complete Checklist

**Task:** Generate a comprehensive, structured, interactive Markdown checklist that consolidates ALL project history, bugs, features, implementation roadmap, and next steps for Ghost Catcher Tycoon.

**Output Format:** Interactive Markdown file with clickable checkboxes `- [ ]` and `- [x]` that can be checked/unchecked by the user.

---

## CONTEXT YOU MUST READ BEFORE STARTING

### Project Overview
- **Game:** Ghost Catcher Tycoon (Roblox tycoon/idle game)
- **Status:** Phase 1 Complete (core gameplay 100%), Phase 2 debugging, Phase 5 systems integrated
- **Tech Stack:** Roblox/Lua, SystemManager architecture, DataStore persistence
- **Current Date:** 2026-06-07
- **Production Readiness:** 90% (waiting for Roblox image moderation + system bug fixes)

### Key Facts About the Project
1. **Core Gameplay Loop:** Charge vacuum → Catch ghosts → Train ghosts → Upgrade HQ rooms → Unlock zones
2. **Currency System:** Separate coins (from catching) and energy (passive generation from ghosts)
3. **Content:** 120 ghosts, 7 egg tiers, 5 HQ rooms, 11 zones, 5 bosses, 4 leaderboard categories
4. **Architecture:** MainServer_Phase4_Extended.lua + SystemManager + DataManager
5. **Integrated Systems (Phase 5):** Boss, Prestige, Quest, Leaderboard systems with DataStore persistence
6. **Pending Fixes:** Ghost card naming, energy cost display separation, image loading (Roblox moderation)
7. **Recent Changes (Last 24 Hours):**
   - Separate currency system implemented (coins vs energy)
   - Training cost formula updated to level × 75
   - Energy generation reduced (base 0.7 × rarity multiplier 6 max)
   - Room upgrade cost formula uses 100 × (nextLevel ^ 1.5)
   - All room starting levels set to 0

---

## CHECKLIST REQUIREMENTS

### Structure (Required)
The output file MUST contain these 7 sections in this exact order:

1. **🐛 BUGS & FIXES** — All known bugs, grouped by severity (critical/high/cosmetic)
   - Include file paths where bugs occur
   - Include current status (✅ Fixed / 🔴 Needs Investigation / 🟠 In Progress)

2. **✅ COMPLETED FEATURES** — Features that are fully implemented and tested
   - Mark as `- [x]` (checked)
   - Organized by system (Phase 1, Phase 5, etc.)

3. **🔧 FEATURES TO TEST** — Implemented but not fully tested end-to-end
   - Mark as `- [ ]` (unchecked)
   - Include test criteria and expected results

4. **📝 FEATURES TO IMPLEMENT** — Features that are designed but not coded yet
   - Mark as `- [ ]` (unchecked)
   - Include priority level (CRITICAL/HIGH/MEDIUM/LOW)
   - Include estimated effort (1 hour / 4 hours / 1 day / 3 days)

5. **🚀 NEXT STEPS & ROADMAP** — Phased implementation plan for upcoming work
   - Organized by phase (Phase 2, Phase 3, Phase 6, Phase 7)
   - Each phase should show:
     - What tasks are in that phase
     - Dependencies
     - Success criteria
     - Estimated timeline
   - Use sub-checkboxes for tasks within phases

6. **⚠️ RISKS & BLOCKERS** — Current obstacles, mitigations, and dependencies
   - Include impact assessment
   - Include mitigation strategy

7. **📊 METRICS & SUCCESS CRITERIA** — How to measure progress and success
   - Include testing metrics
   - Include production readiness checklist
   - Include key performance indicators

---

## DETAILED CONTENT TO INCLUDE

### 🐛 BUGS & FIXES Section
**Include these bugs (from TODO-LIST.md):**

**CRITICAL (Must fix before production):**
- Zone unlock system (button says "Unlock" after unlock)
- Energy and coin display persistence (energy disappears after 1 second admin command)

**HIGH PRIORITY:**
- Ghost card image IDs not displaying correctly (6 ghosts missing images due to Roblox moderation)
- Training cost multiplier calculation may need verification

**COSMETIC/LOW PRIORITY:**
- ZoneData infinite yield warning (doesn't break gameplay)
- Zone name not updating when moving between zones

**RECENTLY FIXED (Last 24 hours):**
- ✅ Ghost card naming (now uses inventoryKey instead of id)
- ✅ Text readability on ghost cards (dark background added)
- ✅ Training cost display (shows on card, updates with level)
- ✅ HQ room cost formula (now uses 100 × nextLevel^1.5)
- ✅ Room starting levels (all now start at 0)
- ✅ Separate currency system (coins from catching, energy from ghosts)

---

### ✅ COMPLETED FEATURES Section
**Include these (already verified working):**

**Phase 1 Core Gameplay:**
- Charge vacuum (25% per click, caps at 100%)
- Catch ghosts (coins + inventory)
- Ghost inventory management
- Ghost training (level up, cost scales)
- Room upgrades (5 rooms, levels 0-10)
- Egg hatching/gacha (7 tiers)
- Zone unlocking (11 zones)
- Ghost spawning (all 11 zones)
- Admin commands (!coin, !energy, !ghost, !help, !admin, !mute, !kick)

**Phase 5 Systems:**
- BossSystem (5 bosses, spawn, combat, rewards, DataStore)
- PrestigeSystem (level tracking, energy reset, bonuses, DataStore)
- QuestSystem (daily/weekly, progress, rewards, DataStore)
- LeaderboardSystem (4 categories, real-time, DataStore)
- SystemManager (dependency injection, loads 4 systems cleanly)
- DataStore integration (all player data persists)

**UI/UX:**
- Tab system (Ghost, HQ, Zones, Shop, Quests, Bosses, Info, PvP, Prestige, Leaderboard)
- Real-time UI sync (1-second broadcast)
- AdminLog (top-right feedback)
- Ghost card builder with rarity-based colors

---

### 🔧 FEATURES TO TEST Section
**Include these (implemented but need full end-to-end testing):**

- Boss system defeat mechanics and reward drops
- Prestige multiplier calculations (+10% per level)
- Quest progress persistence across server restarts
- Leaderboard ranking accuracy with 10+ players
- DataStore auto-save every 30 seconds
- Ghost spawning rate consistency across all 11 zones
- Room bonus calculations (e.g., GhostChamber +10% energy per level)
- Zone unlock progression (costs should prevent rushing)
- Admin command execution under load (multiple players)

---

### 📝 FEATURES TO IMPLEMENT Section
**Include these (from TODO-LIST.md and recent changes):**

**HIGH PRIORITY:**
- [ ] PvP System integration (player vs player battles, energy transfer, cool-down)
  - Priority: HIGH
  - Effort: 1 day
  - File: src/server/systems/PvPSystem.lua
  - Dependencies: DataStore, battle UI

- [ ] Fix system consolidation review (Ghost, Training, Zone systems for overlaps)
  - Priority: HIGH
  - Effort: 4 hours
  - Impact: Clean up code, prevent duplicate functionality

**MEDIUM PRIORITY:**
- [ ] Keybindings system (custom hotkeys for Charge/Catch buttons)
  - Priority: MEDIUM
  - Effort: 4 hours
  - Files: GameClient.lua, UserInputService integration

- [ ] Cosmetics System UI integration (5 skins, purchasable, displayable)
  - Priority: MEDIUM
  - Effort: 1 day
  - Files: CosmeticsSystem.lua (exists), GameClient.lua (new tab)

- [ ] Ghost "Bring Home" feature (return ghosts from zones to inventory)
  - Priority: MEDIUM
  - Effort: 4 hours
  - Files: GameClient.lua, MainServer_Phase4_Extended.lua

- [ ] Release button functionality (currently does nothing)
  - Priority: MEDIUM
  - Effort: 2 hours
  - Files: GhostCardBuilder.lua, MainServer_Phase4_Extended.lua

**LOW PRIORITY:**
- [ ] Admin-only flight system (F key to toggle, admin-only)
  - Priority: LOW
  - Effort: 2 hours
  - File: Create FlightSystem.lua or extend AdminCommands.lua

- [ ] Mayhem Event System (server-wide chaos events, 5-min survival, bonus rewards)
  - Priority: LOW (fun feature)
  - Effort: 3 days
  - Concept: Random disasters (meteor rain, frog rain, lasers), players survive for bonus energy/cosmetics

- [ ] Monetization System UI (GamePass/Products integration)
  - Priority: LOW
  - Effort: 1 day
  - Files: MonetizationSystem.lua (exists), GameClient.lua (new UI)

**BACKLOG (Phase 7+):**
- [ ] AutoCatchSystem UI (automatic ghost catching, GamePass feature)
- [ ] AutoTrainSystem UI (automatic ghost training, GamePass feature)
- [ ] ProductionSystem UI (offline energy calculation, display)
- [ ] EventSystem integration (time-limited events, bonus multipliers)
- [ ] Advanced cosmetics (pets, auras, particle effects)
- [ ] Clan/Guild system
- [ ] Trading system between players

---

### 🚀 NEXT STEPS & ROADMAP Section
**Structure by Phase:**

**PHASE 2 (Now - Next 3 days) — Bug Fixes & System Verification**
- [ ] Verify Roblox image moderation response (est. 24-48 hours)
- [ ] Test all 4 Phase 5 systems end-to-end
- [ ] Fix zone unlock display bug (button text)
- [ ] Consolidate Ghost/Training/Zone systems for overlaps
- [ ] Verify energy generation rates are balanced
- Success Criteria: All core systems working, no breaking bugs

**PHASE 3 (Days 4-5) — PvP Integration**
- [ ] Integrate PvPSystem from existing code
- [ ] Wire battle UI (challenge button, battle screen)
- [ ] Test 2-player battle scenario
- [ ] Verify energy transfer on win/loss
- Success Criteria: PvP system fully functional

**PHASE 4 (Days 6-7) — Cosmetics & Polish**
- [ ] Integrate CosmeticsSystem into GameClient
- [ ] Create cosmetics shop UI tab
- [ ] Test cosmetic purchase and apply flow
- [ ] Verify cosmetics display on player
- [ ] Add keybinding system for Charge/Catch buttons
- Success Criteria: Cosmetics purchasable and visually applied

**PHASE 5 (Week 2) — Remaining Systems**
- [ ] Integrate MonetizationSystem (GamePass/Products)
- [ ] Integrate AutoCatchSystem (GamePass feature)
- [ ] Integrate AutoTrainSystem (GamePass feature)
- [ ] Integrate ProductionSystem (offline calculations)
- [ ] Integrate EventSystem (time-limited events)
- [ ] Complete remaining 8 systems
- Success Criteria: All 20 systems running

**PHASE 6 (Week 3+) — Advanced Features**
- [ ] Implement "Bring Home" ghost feature
- [ ] Implement Release button functionality
- [ ] Implement admin flight system
- [ ] Load testing (10+ concurrent players)
- [ ] Live server deployment and validation
- Success Criteria: 100+ players online, no crashes

**PHASE 7 (Week 4+) — Community Features**
- [ ] Implement Mayhem Event System (server-wide events)
- [ ] Implement clan/guild system
- [ ] Implement trading system
- [ ] Implement advanced cosmetics (pets, auras)
- [ ] Regular content updates (new ghosts, bosses, events)
- Success Criteria: Active player community, daily engagement

---

### ⚠️ RISKS & BLOCKERS Section
**Include these:**

**CRITICAL BLOCKERS:**
- [ ] Roblox image moderation (6 ghosts missing images)
  - Status: Waiting for Roblox response (est. 24-48 hours)
  - Mitigation: Images have asset IDs, will load automatically once approved
  - Impact: Visual polish only, gameplay unaffected

**HIGH RISKS:**
- [ ] DataStore not actually working on live server
  - Mitigation: Full testing in Studio before deploying
  - Fallback: In-memory cache (limited but functional)

- [ ] PvP system is complex and may have bugs
  - Mitigation: Dedicated 2-day sprint with thorough testing
  - Fallback: Defer to Phase 5 if critical issues found

- [ ] System consolidation may reveal duplicate code
  - Mitigation: Careful code review of Ghost/Training/Zone systems
  - Fallback: Keep separate if consolidation breaks something

**MEDIUM RISKS:**
- [ ] Load testing may reveal performance issues
  - Mitigation: Profile with 10+ players before live deployment
  - Fallback: Optimize hot loops (UI updates, ghost spawning)

- [ ] Cosmetics system may have purchase flow bugs
  - Mitigation: Test thoroughly with test purchases
  - Fallback: Disable purchases until fixed

**DEPENDENCIES:**
- [ ] All systems depend on: SystemManager ✅ (ready)
- [ ] PvP depends on: DataStore ✅, battle UI (in progress)
- [ ] Cosmetics depends on: UI implementation (pending)
- [ ] Monetization depends on: Cosmetics ✅, MarketplaceService (Roblox)

---

### 📊 METRICS & SUCCESS CRITERIA Section
**Include these:**

**Phase 1 Success (ACHIEVED)**
- ✅ All core gameplay mechanics functional
- ✅ Ghost spawning in all 11 zones
- ✅ Admin system working without chat pollution
- ✅ No breaking changes to existing systems

**Phase 2 Success Criteria (IN PROGRESS)**
- [ ] Roblox moderation lifts, images display
- [ ] All 4 Phase 5 systems tested end-to-end
- [ ] DataStore persistence verified
- [ ] Zero critical bugs in console
- [ ] Code ready for live server

**Phase 3+ Success Criteria**
- [ ] PvP battles completed without errors
- [ ] Load test with 10+ players passes
- [ ] Leaderboards accurate across 4 categories
- [ ] Player retention rate > 70% (after first session)
- [ ] Average session duration > 20 minutes

**Production Readiness Checklist**
- [x] Phase 1 core gameplay (100%)
- [x] Phase 5 system integration (4/4 systems)
- [x] DataStore persistence (coded + tested)
- [x] Ghost spawning (all zones ready)
- [x] Admin system (complete)
- [ ] Image loading (awaiting Roblox)
- [ ] Live server testing
- [ ] PvP system (in progress)
- [ ] Load testing (pending)
- [ ] Cosmetics system (pending)

**Code Quality Metrics**
- Total Lua files: 56
- Total lines of code: 8000+
- Systems integrated: 4/4 (Phase 5)
- Breaking changes since launch: 0
- Test coverage: Manual (automated pending)

---

## ADDITIONAL FEATURES TO INCLUDE

### Interactive Checklist Features
- **Checkboxes:** Use `- [ ]` for unchecked and `- [x]` for checked items
- **Nesting:** Use sub-bullets for task dependencies (e.g., PvP depends on DataStore)
- **Date tracking:** Include "Last Updated: 2026-06-07" at top
- **Emoji indicators:** Use ✅ 🔴 🟠 🟢 🔵 🟣 ⏳ for visual status
- **File references:** Link to specific files (e.g., `src/server/MainServer_Phase4_Extended.lua`)
- **Effort estimates:** Show time to complete each feature
- **Linked sections:** Cross-references between bugs and implementation tasks

### Formatting Guidelines
- Use headers `#`, `##`, `###` for hierarchy
- Use bold `**text**` for emphasis
- Use code blocks for file paths and asset IDs
- Use tables for metrics and comparison
- Use bullet lists with dashes `-` for checkboxes
- Keep lines under 100 characters for readability
- Add blank lines between sections for clarity

---

## OUTPUT SPECIFICATION

**File Name:** `CHECKLIST_GHOST_CATCHER_TYCOON.md`

**File Location:** Root of project directory (same level as README.md)

**File Size:** 3000-4000 words (comprehensive but readable)

**Update Frequency:** After each phase completion or major milestone

**Version Control:** This file should be committed to git and updated regularly

**Last Updated Field:** MUST be at the top and updated whenever the checklist changes

---

## VALIDATION CHECKLIST (For Agent Completion)

Before returning the final checklist, verify:

- [ ] File is valid Markdown (no syntax errors)
- [ ] All 7 required sections are present and in order
- [ ] All bugs from TODO-LIST.md are included
- [ ] All features from TODO-LIST.md are included
- [ ] All phases from TODO-LIST.md are included
- [ ] Checkboxes use correct syntax (`- [ ]` and `- [x]`)
- [ ] File has "Last Updated" timestamp at top
- [ ] File has clear header identifying it as a checklist
- [ ] All file paths are relative to project root
- [ ] No duplicate items between sections
- [ ] Priority levels assigned to all pending features
- [ ] Effort estimates provided for all implementations
- [ ] Risk/blocker section includes mitigations
- [ ] Success criteria are measurable and testable
- [ ] Emoji indicators used consistently
- [ ] Formatting is clean and readable
- [ ] Cross-references work logically between sections

---

## AGENT SUCCESS CRITERIA

Your job is complete when:

1. ✅ You generate a single, comprehensive Markdown checklist file
2. ✅ The checklist consolidates ALL project history from TODO-LIST.md
3. ✅ The checklist includes ALL bugs, ALL features, ALL roadmap phases
4. ✅ The checklist is interactive (checkboxes can be clicked/checked)
5. ✅ The checklist is organized into exactly 7 sections
6. ✅ The checklist is formatted cleanly and professionally
7. ✅ The checklist is ready to be committed to git and updated ongoing
8. ✅ The checklist passes the validation checklist above

---

## TIMELINE & EXPECTATIONS

- **Estimated effort:** 3-4 hours to read, consolidate, and format
- **Deliverable:** Single Markdown file, ready to use immediately
- **Format:** 100% Markdown, no other file types
- **Usability:** Should be readable on GitHub, GitLab, and other platforms
- **Maintenance:** Should be easy to update as tasks progress

---

**End of Agent Prompt**
