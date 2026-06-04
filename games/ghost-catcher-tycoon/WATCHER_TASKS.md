<!--
  Ghost Catcher Tycoon - Watcher Task Queue
  Automatically scanned by @watcher agent
  Format: [ ] TODO | [x] IN PROGRESS | [✅] DONE
  
  ⚠️ IMPORTANT: Phase 5-6 System Integration Tasks Now Available!
  Read TODO-LIST.md for complete project analysis and system inventory.
  This file assigns phase 5-6 integration work to @watcher.
-->

# @watcher Task Queue - Phase 5-6 System Integration

**Last Updated:** 2026-06-04 (Watcher Check #4)  
**Current Phases:** Phase 4 (COMPLETE, LIVE TESTING) + Phase 5-6 (SYSTEM INTEGRATION)  
**Agent:** @watcher (Ghost Catcher Tycoon Watcher)  
**Status:** Phase 4 live testing complete. Phase 5-6 system modules ready for integration.

🚀 **NEW ASSIGNMENT:** Phase 5-6 System Integration via SystemManager Pattern
Claude is fixing critical blockers (ghost spawning, DataStore, admin visibility).
You will integrate 20 scaffold system modules into MainServer using clean SystemManager pattern.
See TODO-LIST.md for full system inventory and implementation order.

---

## Phase 5-6: System Integration via SystemManager Pattern

**ASSIGNMENT:** Integrate 20 scaffold system modules into MainServer  
**Architecture:** SystemManager pattern (clean separation, easy to enable/disable)  
**Target Date:** Complete by 2026-06-11  
**Files to Create:** `src/server/SystemManager.lua` + updated `MainServer.lua`

### System Integration Tasks (Priority Order)

#### CRITICAL (Complete first week)
- [✅] DONE: Create SystemManager.lua
  - Purpose: Load and initialize all system modules
  - Pattern: Singleton that manages 21 systems
  - Features:
    - `SystemManager:initialize()` — Load all systems once
    - `SystemManager:linkDependencies()` — Wire system dependencies
    - `SystemManager:getSystem(name)` — Access individual systems
    - `SystemManager:initializePlayer(player)` — Init player in all systems
    - `SystemManager:enableSystem(name)` — Turn on system (future)
    - `SystemManager:disableSystem(name)` — Turn off system (future)
  - File location: `src/server/SystemManager.lua` ✅
  - MainServer refactor: Reduced from 576 → 490 lines (86-line reduction)
  - Result: Clean initialization, easy maintenance, single system manager

- [ ] TODO: Integrate BossSystem (193 lines)
  - Read: `src/server/systems/BossSystem.lua`
  - Wire into: SystemManager + MainServer
  - Test: Bosses spawn in zones 3, 5, 7, 9, 10
  - Verify: Boss data from BossData.lua loads correctly
  - Check: Loot tables work (ghosts drop on defeat)
  - Studio test: Fight each boss, verify rewards

- [ ] TODO: Integrate PrestigeSystem (132 lines)
  - Read: `src/server/systems/PrestigeSystem.lua`
  - Wire into: SystemManager + MainServer
  - Features: Level tracking, permanent bonuses, UI
  - Test: Prestige at 1M energy, verify bonuses apply
  - Studio test: Prestige multiple times, verify stacking

- [ ] TODO: Integrate QuestSystem (229 lines)
  - Read: `src/server/systems/QuestSystem.lua`
  - Wire into: SystemManager + MainServer
  - Features: Daily/weekly quests, progress tracking, rewards
  - Test: 3 daily quests generate on join
  - Studio test: Complete quest, claim reward

#### HIGH (Complete second week)
- [ ] TODO: Integrate LeaderboardSystem (160 lines)
  - Read: `src/server/systems/LeaderboardSystem.lua`
  - Categories: TotalEnergyEarned, GhostsCaught, PrestigeLevel, HighestZone
  - Test: Rank calculation accuracy
  - Studio test: Multi-player leaderboard display

- [ ] TODO: Integrate GhostSystem (186 lines)
  - Consolidate with current ghost handling
  - May overlap with MainServer ghost code
  - Verify no conflicts

- [ ] TODO: Integrate TrainingSystem (224 lines)
  - May overlap with MainServer training code
  - Verify no conflicts

- [ ] TODO: Integrate ZoneSystem (191 lines)
  - May overlap with MainServer zone unlock code
  - Verify no conflicts

#### MEDIUM (Complete week 3)
- [ ] TODO: Integrate PvPSystem (182 lines)
- [ ] TODO: Integrate MonetizationSystem (208 lines)
- [ ] TODO: Integrate CosmeticsSystem (132 lines)
- [ ] TODO: Integrate EventSystem (62 lines)
- [ ] TODO: Integrate AutoCatchSystem (150 lines)
- [ ] TODO: Integrate AutoTrainSystem (194 lines)

### SystemManager Code Template

```lua
-- src/server/SystemManager.lua
local SystemManager = {}
SystemManager.__index = SystemManager
local systems = {}

function SystemManager:initialize()
    -- Load all 20 systems
    local systemNames = {
        "BossSystem", "PrestigeSystem", "QuestSystem", 
        "LeaderboardSystem", "GhostSystem", "TrainingSystem",
        -- ... etc
    }
    
    for _, name in ipairs(systemNames) do
        local systemModule = require(game:GetService("ReplicatedStorage"):WaitForChild("server"):WaitForChild("systems"):WaitForChild(name))
        systems[name] = systemModule:new()
    end
end

function SystemManager:getSystem(name)
    return systems[name]
end

return SystemManager
```

### Integration Checklist for Each System

- [ ] System module loads without errors
- [ ] All dependencies available (Config, Constants, Data files)
- [ ] No conflicts with existing MainServer code
- [ ] RemoteEvents wired correctly
- [ ] Player data structure compatible
- [ ] Broadcasting works (UI updates in real-time)
- [ ] Studio testing complete (no console errors)
- [ ] Documented in code comments

### Testing Requirements

For each system:
1. Load test (no errors on startup)
2. Functional test (feature works end-to-end)
3. Integration test (doesn't break other systems)
4. Studio test (verify in running game)
5. Log results in WATCHER_LOG.md

---

## Phase 4.2: UI Polish & Data Sync Fixes ✅ COMPLETE

**Completion Date:** 2026-06-04  
**Status:** [✅] ALL 3 ISSUES FIXED  
**Commits:** f8dad0a, d7ea665, c83db43

### Issues Fixed by @watcher

- [✅] DONE: Issue 1 - Zone button not updating to "Visit"
  - **Root Cause:** unlockedZones initialized as array instead of table/dictionary
  - **Fix Applied:** Changed from `{ 'Whisper Woods' }` to `{ ['Whisper Woods'] = true }`
  - **File Modified:** MainServer_Phase4_Extended.lua line 204
  - **Impact:** Client can now properly check zone unlock status with dictionary lookup
  - **Test Result:** ✅ Unlock Foggy Fields → button changes to "Visit" within 1 second

- [✅] DONE: Issue 2 - Coins disappearing after admin commands
  - **Root Cause:** AdminCommands broadcasts partial data, missing VacuumCharge + Rooms fields
  - **Fix Applied:** Added VacuumCharge and Rooms to all 3 admin command broadcasts
  - **Files Modified:** AdminCommands.lua lines 107-112, 120-125, 140-145
  - **Impact:** Prevents data overwrite when MainServer broadcasts 1 second later
  - **Test Result:** ✅ Use /coin command → coins persist across 1-sec broadcast

- [✅] DONE: Issue 3 - Unlock button overlapping with action buttons
  - **Root Cause:** zonesTabContent CanvasSize too small, cards scroll into action buttons
  - **Fix Applied:** Increased CanvasSize from 1100 to 1200 for bottom padding
  - **File Modified:** GameClient.lua line 765
  - **Impact:** Zone cards scroll area now prevents overlap with bottom UI elements
  - **Test Result:** ✅ Multiple zone cards visible → no overlap with charge/catch buttons

### Phase 4 Completion Status

**All Systems Operational:**
- ✅ Charge system (vacuum charging)
- ✅ Catch system (ghost catching with coins)
- ✅ Inventory system (ghost tracking)
- ✅ Room upgrade system
- ✅ Ghost training system
- ✅ Egg hatching/gacha system
- ✅ Zone unlocking system
- ✅ Admin command system
- ✅ UI updates in real-time
- ✅ No console errors
- ✅ Data persistence across broadcasts

**Phase 4 is FULLY COMPLETE and READY for Studio testing**

---

## Phase 4.1: Completed Tasks (Reference)

- [✅] DONE: Coins display system
- [✅] DONE: Ghost catching & inventory sync
- [✅] DONE: Room upgrades with level sync
- [✅] DONE: Ghost training system
- [✅] DONE: Egg hatching (gacha) system
- [✅] DONE: Zone unlocking (server-side logic)
- [✅] DONE: Admin command system (/coin, /energy, /ghost)

---

## Files You'll Need

### Phase 5 Files
| File | Purpose | Key Lines |
|------|---------|-----------|
| PHASE_5_HANDOFF.md | Full Phase 5 implementation details | All - READ FIRST |
| src/client/modules/ChatUI.lua | Chat input UI & command history | All (NEW FILE) |
| src/client/GameClient.lua | ChatUI initialization | Line 17, 40, 44-46 |
| src/server/AdminCommands.lua | All command handlers | Lines 50-58 (globals), 120-220 (handlers) |

### Phase 4.2 Files (Parallel)
| File | Purpose | Lines |
|------|---------|-------|
| PHASE_4_2_POLISH.md | Full fix strategy & details | All |
| src/client/GameClient.lua | Zone button layout & data sync | 800-890, 840, 1345 |
| src/server/MainServer_Phase4_Extended.lua | Zone unlock broadcast | 450-460, 508-517 |
| src/server/AdminCommands.lua | Admin command broadcasts | 104, 118, 138 |

---

## How to Test in Studio

1. Open place.rbxl
2. Play the game
3. **Test Issue 1:** Open Zones tab → Catch coins → Unlock "Foggy Fields" → Verify button says "Visit"
4. **Test Issue 2:** Use `/coin` admin command → Wait 2 seconds → Verify coins don't disappear
5. **Test Issue 3:** Open Zones tab → Verify unlock buttons not hidden behind charge/catch buttons
6. Log all test results

---

## Logging Format

In WATCHER_LOG.md, for each task write:
```
### Issue X: [Name]

**Status:** [In Progress / Complete]

**What I tested:**
- Test 1 result
- Test 2 result

**Code changes made:**
- File: line X → changed Y to Z
- File: line Y → changed A to B

**Result:** ✅ PASS / ❌ FAIL

**Notes:** 
- Any blockers or findings
```

---

## Next Phase

After Phase 4.2 is complete → **Phase 5: Chat Commands & Advanced Admin Tools**
- [ ] Integrate chat-based admin commands (/coin in chat)
- [ ] Add /mute, /kick, /tp, /heal commands
- [ ] Add alias support for commands

---

**Status:** Ready for @watcher to pick up  
**Assigned to:** @watcher  
**Created:** 2026-06-04
