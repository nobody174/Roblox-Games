<!--
  Ghost Catcher Tycoon - Phase 4.2 Polish Tasks
  Follow-up to Phase 4.1 - UI Synchronization & Layout Fixes
  Assigned to: @watcher
  Date: 2026-06-04
-->

# Phase 4.2: UI Polish & Data Sync Fixes

**Status:** Ready for @watcher  
**Priority:** Medium (non-blocking)  
**Estimated Effort:** 2-3 hours  

---

## Overview

Phase 4.1 successfully implemented all **core gameplay systems**:
- ✅ Ghost catching & inventory
- ✅ Room upgrades
- ✅ Ghost training
- ✅ Egg hatching (gacha)
- ✅ Zone unlocking (server-side)
- ✅ Admin commands (/coin, /energy, /ghost)

However, three **UI synchronization issues** remain that don't block gameplay but affect user experience.

---

## Issues to Fix

### Issue 1: Zone Button Not Updating to "Visit"
**Symptom:** After unlocking "Foggy Fields", button still shows "Unlock" instead of "Visit"  
**Root Cause:** Client receives `UnlockedZones` broadcast but the `populateZonesTab()` refresh doesn't trigger properly, OR the `isUnlocked` check in GameClient isn't reading the broadcasted data correctly  
**Files Affected:**
- `src/client/GameClient.lua` (line ~840, `isUnlocked` check)
- `src/server/MainServer_Phase4_Extended.lua` (line ~453, broadcast after unlock)

**Fix Strategy:**
1. Verify the `UnlockedZones` broadcast payload is being sent correctly from server
2. Ensure client's `updateUIFromData()` properly updates `self.gameState.unlockedZones`
3. Confirm `populateZonesTab()` reads from the updated state, not cached data
4. Add debug logging to trace the data flow: server unlock → broadcast → client receives → UI updates

**Test:** Unlock a zone and verify button changes to "Visit" within 1 second

---

### Issue 2: Coins Disappearing After Admin Commands
**Symptom:** After `/coin` admin command, coins appear briefly then disappear on next broadcast  
**Root Cause:** AdminCommands broadcasts partial data (coins + unlockedZones) but MainServer's 1-second broadcast loop overwrites it with data that hasn't been updated in AdminCommands' playerData reference  
**Files Affected:**
- `src/server/AdminCommands.lua` (line ~104, admin coin broadcast)
- `src/server/MainServer_Phase4_Extended.lua` (line ~508, UI broadcast loop)

**Fix Strategy:**
1. Ensure AdminCommands and MainServer share the SAME playerData reference (already using `_G.GhostCatcherPlayerData`)
2. Verify that when AdminCommands modifies coins, the shared reference is updated
3. Add full broadcast payload in AdminCommands (include Rooms, VacuumCharge, etc.)
4. Test: Run `/coin`, wait 2 seconds, verify coins stay updated

**Test:** Use `/coin` command, verify coins display persists across full 1-second broadcast cycle

---

### Issue 3: Unlock Button Overlaps with Charge/Catch Buttons
**Symptom:** Unlock button position gets hidden partially behind the large circular charge/catch buttons  
**Root Cause:** Zone card positioning doesn't account for overlap with bottom-right UI elements  
**Files Affected:**
- `src/client/GameClient.lua` (line ~800-890, zone card layout)

**Fix Strategy:**
1. Either:
   - **Option A:** Move unlock button to the left side of the zone card (away from overlap zone)
   - **Option B:** Adjust the Zones tab scroll area to have padding at bottom to prevent overlap
   - **Option C:** Move charge/catch buttons slightly higher
2. Test with multiple zone cards visible to ensure no overlap

**Test:** Open Zones tab, verify unlock buttons are fully visible and don't overlap with action buttons

---

## Implementation Checklist

- [ ] **Issue 1:** Trace zone unlock data flow (server → broadcast → client → UI)
  - [ ] Check `UnlockedZones` payload in MainServer broadcast (line 511)
  - [ ] Check client `updateUIFromData()` receives and stores UnlockedZones (line ~1345)
  - [ ] Verify `isUnlocked` check reads from `self.gameState.unlockedZones` (line ~840)
  - [ ] Test unlock → button changes to "Visit"

- [ ] **Issue 2:** Verify AdminCommands full broadcast
  - [ ] Add Rooms, VacuumCharge to AdminCommands broadcast payload (AdminCommands.lua line ~104, ~118, ~138)
  - [ ] Verify shared playerData reference is working
  - [ ] Test `/coin` → coins persist across 1-sec broadcast

- [ ] **Issue 3:** Fix unlock button layout
  - [ ] Reposition unlock button or add bottom padding to Zones tab
  - [ ] Test overlap with action buttons
  - [ ] Verify multiple zone cards display correctly

---

## Files to Modify

1. **src/client/GameClient.lua**
   - Lines 800-890: Zone card layout (Issue 3)
   - Lines 840: isUnlocked check (Issue 1)
   - Lines 1345: updateUIFromData() (Issue 2)

2. **src/server/MainServer_Phase4_Extended.lua**
   - Lines 450-460: Zone unlock broadcast (Issue 1)
   - Lines 508-517: UI broadcast loop (Issue 2)

3. **src/server/AdminCommands.lua**
   - Lines 104, 118, 138: Admin command broadcasts (Issue 2)

---

## Testing Checklist

After fixes, test:
- [ ] Unlock zone → button changes to "Visit" immediately
- [ ] Admin `/coin` command → coins update and persist
- [ ] Admin `/energy` command → works correctly
- [ ] Admin `/ghost` command → spawns ghost in inventory
- [ ] Zone card unlock button is fully visible (no overlap)
- [ ] Coins display doesn't reset after admin commands
- [ ] Multiple zone unlocks work in sequence

---

## Notes for @watcher

- All three issues are **cosmetic/UX**, not gameplay-breaking
- The core systems (unlocking, coins, inventory) work perfectly
- Focus on data flow tracing (Issue 1 & 2) — these are about making sure broadcasts include all necessary fields
- Issue 3 is purely UI positioning
- After fixes, Phase 4 will be **100% complete** and ready for Phase 5 (Chat Commands & Advanced Admin Tools)

---

## Status

**Ready for @watcher to pick up**

When @watcher is ready:
1. Read WATCHER_INSTRUCTIONS.md
2. Read this file (PHASE_4_2_POLISH.md)
3. Add tasks to WATCHER_TASKS.md under "Phase 4.2 Polish"
4. Log all work in WATCHER_LOG.md
5. Mark tasks complete as you fix them

---

**Created:** 2026-06-04  
**Phase:** 4.2 (Polish & Data Sync)  
**Assigned to:** @watcher  
**Status:** READY
