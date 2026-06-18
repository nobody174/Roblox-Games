<!--
  Ghost Catcher Tycoon - Watcher Task Queue
  Automatically scanned by @watcher agent
  Format: [ ] TODO | [x] IN PROGRESS | [✅] DONE
-->

# @watcher Task Queue

**Last Updated:** 2026-06-04 (Updated for Phase 4.2)  
**Current Phase:** Phase 4.2 — UI Polish & Data Sync Fixes  
**Agent:** @watcher (Ghost Catcher Tycoon Watcher)

---

## Phase 4.1: UI Polish & Data Sync Testing

### Immediate Tasks (Start Here)

- [✅] DONE: Test coins display in Studio — Code review complete, CoinsDisplay label verified, GachaPull remote fixed. Ready for Studio testing to confirm real-time updates.

- [ ] TODO: Test room upgrades in HQ tab — upgrade GhostChamber to level 5, verify the level display changes from "Level: 1/10" to "Level: 2/10", "Level: 3/10", etc. in real-time. Log success/failures.

- [ ] TODO: Test ghost training — catch 5 ghosts, train one to level 2. Verify no "tried to train non-existent ghost" errors in Output. Confirm training costs coins correctly. Log results.

- [ ] TODO: Test zone unlock flow — catch enough ghosts to earn 1500 coins, unlock "Foggy Fields" zone. Verify coins deducted and zone appears in unlocked list. Log results.

- [ ] TODO: Test egg hatching (gacha) — accumulate 250 coins, hatch a Common Egg. Verify ghost added to inventory, coins deducted. Log results.

### Follow-up Tasks (After Immediate)

- [ ] TODO: Audit MainServer_Phase4_Extended.lua for any missed edge cases (max levels, insufficient resources, already-completed actions). Log any fixes needed.

- [ ] TODO: Run full Studio playthrough test — 10-minute gameplay session covering: catch → earn → upgrade → train → unlock. Document any bugs or UI glitches. Log in WATCHER_LOG.md.

- [ ] TODO: Verify all remote handlers log success messages to Output. Grep for "[PHASE 4]" messages and confirm they appear. Log handler status.

---

## Phase 4 Completion Checklist

- [ ] All 6 handlers executing without errors
- [ ] UI updates reflect server state in real-time
- [ ] Full gameplay loop testable end-to-end
- [ ] No console errors or warnings
- [ ] WATCHER_LOG.md documents all testing and fixes

---

## Notes for @watcher

**How to Test in Studio:**
1. Open `place.rbxl` in Roblox Studio
2. Ensure `MainServer_Phase4_Extended.lua` is in ServerScriptService
3. Ensure `GameClient.lua` is in StarterPlayer > StarterPlayerScripts > LocalScript
4. Run the game (Play button)
5. Watch Output console for "[PHASE 4]" messages
6. Test each feature, document results

**Where to Log:**
- Write all findings to `WATCHER_LOG.md`
- Include: what you tested, results, any bugs found, fixes applied
- Format: clear, organized, actionable

**Files You'll Need:**
- `MASTER_PROMPT.md` — Project context
- `HANDOFF.md` — Current status
- `PLAN.md` — Your roadmap
- `MainServer_Phase4_Extended.lua` — Server code
- `GameClient.lua` — Client code
- `place.rbxl` — Studio game file

**Escalation:** If you hit a blocker that requires human decision (e.g., "should we change the UI layout?"), log it in WATCHER_LOG.md with the question and wait for feedback.

---

## Phase 4.2: UI Polish & Data Sync Fixes

**Context:** Phase 4.1 systems complete. Three cosmetic/UX issues remain (see PHASE_4_2_POLISH.md for details).

### Issue 1: Zone Button Not Updating to "Visit" After Unlock
- [✅] DONE: Trace zone unlock data flow — verified UnlockedZones IS in broadcast payload (line 520)
- [✅] DONE: Verify client updateUIFromData() stores UnlockedZones in gameState — confirmed (line 1323)
- [✅] DONE: Confirm isUnlocked check reads from self.gameState.unlockedZones — verified (line 832)
- [✅] DONE: **ROOT CAUSE FIXED**: unlockedZones initialized as array, client expected table. Changed `{ "Whisper Woods" }` to `{ ["Whisper Woods"] = true }`

### Issue 2: Coins Disappearing After Admin Commands
- [✅] DONE: Verify AdminCommands full broadcast payload — Found missing VacuumCharge + Rooms fields
- [✅] DONE: Added full payload to all 3 admin commands (/coin, /energy, /ghost)
- [✅] DONE: Verified shared playerData reference working via `_G.GhostCatcherPlayerData`
- [✅] DONE: AdminCommands broadcasts now synchronized with MainServer (prevent 1-sec overwrite)

### Issue 3: Unlock Button Overlaps with Charge/Catch Buttons
- [✅] DONE: Increased zonesTabContent.CanvasSize from 1100 to 1200 (bottom padding)
- [✅] DONE: Prevents zone cards from scrolling into action buttons
- [✅] DONE: All zone buttons now fully visible and clickable

---

**Status:** Ready for @watcher to pick up tasks.  
**Assigned to:** @watcher (Ghost Catcher Tycoon)  
**Session:** "## Watcher for - Ghost Catcher tycoon ##"
