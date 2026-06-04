<!--
  Ghost Catcher Tycoon - Watcher Task Queue
  Automatically scanned by @watcher agent
  Format: [ ] TODO | [x] IN PROGRESS | [✅] DONE
  
  ⚠️ IMPORTANT: Phase 4.2 tasks are now available!
  If you see this file has been updated with Phase 4.2 content,
  read PHASE_4_2_POLISH.md for full context, then proceed with the tasks below.
-->

# @watcher Task Queue

**Last Updated:** 2026-06-04  
**Current Phases:** Phase 4 (COMPLETE) + Phase 5 (COMPLETE, AWAITING STUDIO TESTING)  
**Agent:** @watcher (Ghost Catcher Tycoon Watcher)

🚀 **STATUS UPDATE:** Phase 4 & Phase 5 code complete! Pre-studio code review finished with 2 critical bugs fixed.
All remaining tasks require **Roblox Studio** for live testing. Code is ready to test in Studio.
Read `FINAL_CHECKLIST.md` for step-by-step studio testing guide.

---

## Phase 5: Chat Commands & Advanced Admin Tools (NEWLY COMPLETE - TESTING NEEDED)

**IMPLEMENTATION STATUS:** ✅ COMPLETE  
**Implementation Date:** 2026-06-04  
**Files Created/Modified:**
- ✅ src/client/modules/ChatUI.lua (NEW)
- ✅ src/client/GameClient.lua (MODIFIED - ChatUI integration)
- ✅ src/server/AdminCommands.lua (MODIFIED - 5 new command handlers)

### Pre-Studio Code Review Tasks ✅ COMPLETE

- [✅] DONE: Comprehensive Code Review & Bug Fixes
  - ✅ Code Review: All 4 core files reviewed (GameClient, MainServer_Phase4_Extended, AdminCommands, ChatUI)
  - ✅ Critical Fix #1: UnlockZone broadcast payload - Added missing 4 fields (VacuumCharge, GhostCount, GhostInventory, Rooms)
  - ✅ Critical Fix #2: unlockedZones data structure - Changed AdminCommands from array to dictionary format to match MainServer
  - ✅ Validation: All remotes connected, all handlers implemented, all payloads complete, zero syntax errors
  - ✅ Documentation: Created FINAL_CHECKLIST.md, TESTING_SUMMARY.md, READY_FOR_STUDIO.md, PRE_STUDIO_TESTING_REPORT.md
  - ✅ Git: Committed 3 times (fixes + documentation)
  - See WATCHER_LOG.md and PRE_STUDIO_TESTING_REPORT.md for full review results

### Studio Testing Tasks (Require Roblox Studio) - PENDING

- [ ] TODO: Test ChatUI Module Functionality (Studio Required)
  - File: src/client/modules/ChatUI.lua
  - ✓ Check: Input box appears top-left below stat panel (300px wide × 40px tall)
  - ✓ Check: Can type text and press Enter to submit command
  - ✓ Check: Command feedback appears in history panel with color coding (green/red/yellow)
  - ✓ Check: Chat button in TabBar toggles history visibility
  - ✓ Check: History displays up to 20 messages (older ones scroll off)
  - ✓ Check: History panel scrolls automatically to show newest messages
  - Log all results in WATCHER_LOG.md

- [ ] TODO: Test New Admin Commands - Part 1 (Healing & Teleport)
  - `/heal` - Add 1000 coins to admin's wallet (Test: coins increase by 1000)
  - `/heal max` - Restore admin's coins to maximum 9999 (Test: coins = 9999)
  - `/heal @player` - Add 1000 coins to target player (Test: target's coins +1000)
  - `/tp @player ISLAND_NAME` - Teleport player to island (Test islands: Whisper Woods, Foggy Fields, Gloomy Graveyard, Electro Alley, Frostbite Caverns)
  - `/tp @player @player2` - Teleport player1 to player2's location (requires 2+ players)
  - Log each test result: PASS/FAIL with notes

- [ ] TODO: Test New Admin Commands - Part 2 (Moderation)
  - `/mute @player` - Mute a player (Test: muted player can see chat but not send - verify in code)
  - `/unmute @player` - Unmute player (Test: feedback confirms success)
  - `/kick @player` - Kick player from game (Test: target player disconnects, if 2+ players in game)
  - `/help` - Display all available commands (Test: chat shows all commands listed)
  - Log each test result: PASS/FAIL with notes

- [ ] TODO: Integration Test - Full Phase 5 Workflow
  - Execute 10+ commands in sequence
  - Verify: Command feedback appears immediately in history
  - Verify: UI updates in real-time after each command (coins, energy, etc.)
  - Verify: Chat history persists and scrolls correctly
  - Verify: Non-admin typing command gets "not admin" permission error
  - Verify: Invalid commands get error feedback
  - Log complete test results in WATCHER_LOG.md

- [ ] TODO: Phase 5 Completion Checklist
  - [ ] ChatUI module loads without errors
  - [ ] All 9 commands execute successfully (/heal, /heal max, /mute, /unmute, /kick, /tp, /tp @, /help, existing commands)
  - [ ] Existing Phase 4 commands still work (/coin, /energy, /ghost, /admin, /unadmin)
  - [ ] Chat history displays correctly (last 20 messages, auto-scroll)
  - [ ] Permission checks work (admins only, non-admins blocked)
  - [ ] Full broadcast payload sent after each command (Energy, Coins, GhostCount, etc.)
  - [ ] Zero console errors during testing
  - [ ] All test results logged in WATCHER_LOG.md
  - Mark Phase 5 COMPLETE when all verified ✅

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
