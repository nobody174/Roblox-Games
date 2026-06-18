<!-- 
  Ghost Catcher Tycoon - Execution Plan
  For: @watcher autonomous agent
  Updated: 2026-06-04
  Phase: 4+ Testing & Iteration
-->

# Ghost Catcher Tycoon — Phase 4+ Execution Plan

## Current Status
- **Phase:** 4 (Ghost Spawning & Catching Loop) — ✅ COMPLETE & TESTED
- **Last Update:** 2026-06-04
- **Server:** MainServer_Phase4_Extended.lua (production-ready, all 6 handlers working)
- **Client:** GameClient.lua (3 fixes applied: coins display, room level sync, ghost training)
- **World:** ZONE_AUTO_BUILDER.lua (11 zones + HQ + boss arenas complete)

## Next Phases (Phase 4+)

### Phase 4.1: UI Polish & Data Sync ⚠️ IN PROGRESS
**Goal:** Ensure all UI elements update in real-time from server broadcasts
**Tasks:**
- [ ] Verify coins display updates every 1 second
- [ ] Verify room level display syncs when upgraded
- [ ] Verify ghost training button sends correct inventory key
- [ ] Test Zone unlock flow (1500 coin cost)
- [ ] Test Egg hatching flow (250-45000 coin costs)
- [ ] Verify all handlers log success messages to Output

**Acceptance Criteria:**
- All UI updates match server state within 1 second
- No errors in Output console
- All 6 handlers (Charge, Catch, UpgradeRoom, TrainGhost, GachaPull, UnlockZone) respond correctly
- Player can perform full gameplay loop: Catch → Earn → Upgrade → Train → Unlock

**Files to Monitor:**
- `MainServer_Phase4_Extended.lua` — Server handlers
- `GameClient.lua` — UI updates and remotes
- Studio Output — Success/error messages

---

### Phase 5: Production System Integration ⏳ QUEUED
**Goal:** Wire passive income generation from caught ghosts
**Tasks:**
- [ ] Implement ProductionSystem.lua wiring
- [ ] Connect room upgrade multipliers to energy output
- [ ] Test energy accumulation over time
- [ ] Verify data persistence on restart

---

### Phase 6: HQ System Completion ⏳ QUEUED
**Goal:** Full HQ building and room mechanics
**Tasks:**
- [ ] Verify all 5 room types functional
- [ ] Test multiplier stacking (GhostChamber + EnergyReactor)
- [ ] Display room effects on energy production

---

## @watcher's Role

### Responsibilities
1. **Monitor WATCHER_TASKS.md** — Read new tasks automatically
2. **Execute assigned work** — Fix bugs, implement features, run tests
3. **Log progress** — Write detailed logs to WATCHER_LOG.md
4. **Escalate blockers** — Report human-blocking issues in WATCHER_LOG.md

### Operating Guidelines
- **No confirmation needed** — Work autonomously
- **Follow project conventions** — Existing code style, naming, structure
- **Test your work** — Verify in Studio before reporting done
- **Document everything** — Clear commit messages, detailed logs
- **Prioritize Phase 4.1** — Complete UI Polish before moving to Phase 5

---

## Task Queue System

**How tasks flow:**
1. I (Claude Code) write tasks to `WATCHER_TASKS.md`
2. @watcher continuously scans `WATCHER_TASKS.md`
3. He picks up new tasks marked `[ ] TODO` 
4. Updates task to `[x] IN PROGRESS` when starting
5. Completes work and marks `[✅] DONE` when finished
6. Logs all work in `WATCHER_LOG.md`

**Task Format in WATCHER_TASKS.md:**
```markdown
## Phase 4.1: UI Polish & Data Sync

- [ ] TODO: Fix coins display not updating (test in Studio, verify broadcast)
- [x] IN PROGRESS: Verify room level sync
- [✅] DONE: Add coins label to top panel
```

---

## Success Metrics

**Phase 4.1 Complete when:**
- ✅ All UI elements update in real-time
- ✅ All 6 handlers execute without errors
- ✅ Full gameplay loop testable in Studio
- ✅ No console errors or warnings
- ✅ WATCHER_LOG.md documents all fixes and tests

---

## Quick Reference

**Key Files:**
- `PLAN.md` — This file (your roadmap)
- `WATCHER_TASKS.md` — Task queue (automated pickup)
- `WATCHER_LOG.md` — Execution log (your reference)
- `MASTER_PROMPT.md` — Project context
- `HANDOFF.md` — Current phase details

**Key Project Files:**
- `src/server/MainServer_Phase4_Extended.lua` — Main server logic
- `src/client/GameClient.lua` — Client UI and remotes
- `place.rbxl` — Roblox Studio game file

---

**Ready to start Phase 4.1. @watcher, begin monitoring WATCHER_TASKS.md for instructions.**
