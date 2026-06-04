<!--
  Direct Instructions for @watcher
  Read this file immediately to understand your new workflow
-->

# @watcher — New Autonomous Workflow Instructions

**For:** @watcher Agent  
**Date:** 2026-06-04  
**Session:** "## Watcher for - Ghost Catcher tycoon ##"  
**From:** Claude Code (Main Chat)

---

## Your New Operating Mode

You are now operating in **AUTOMATED TASK QUEUE MODE**.

### How It Works

1. **Monitor WATCHER_TASKS.md** — This file in the project root contains all tasks assigned to you
2. **Pick up tasks** — Read tasks marked `[ ] TODO`
3. **Update status** — Change to `[x] IN PROGRESS` when starting work
4. **Execute work** — Follow the task instructions exactly
5. **Log everything** — Write all findings, results, fixes to WATCHER_LOG.md
6. **Mark complete** — Change to `[✅] DONE` when finished
7. **Repeat** — Continuously scan for new tasks

### Task Format

Tasks appear in WATCHER_TASKS.md like this:

```
- [ ] TODO: Test coins display in Studio — verify "💰 Coins: XXX" updates every 1 second
```

**When you pick it up, update it to:**

```
- [x] IN PROGRESS: Test coins display in Studio — verify "💰 Coins: XXX" updates every 1 second
```

**When done, update to:**

```
- [✅] DONE: Test coins display in Studio — verified, coins update in real-time
```

---

## Your Current Assignment

**Phase:** 4.1 — UI Polish & Data Sync Testing  
**Files to Use:**
- `WATCHER_TASKS.md` — Your task queue
- `WATCHER_LOG.md` — Your detailed log (rename WATCHER_LOG_INIT.md to WATCHER_LOG.md first)
- `PLAN.md` — Your roadmap
- `MASTER_PROMPT.md` — Project context
- `HANDOFF.md` — Current status

**Immediate Tasks (5 tests):**
1. Test coins display updates
2. Test room level sync on upgrade
3. Test ghost training with correct keys
4. Test zone unlock flow
5. Test egg hatching (gacha)

**Starting Point:** Open WATCHER_TASKS.md and begin with the first `[ ] TODO` task.

---

## Important Rules

✅ **DO:**
- Work autonomously without waiting for confirmation
- Log every test, result, and fix in WATCHER_LOG.md
- Follow existing code conventions and style
- Test in Studio before marking tasks done
- Escalate blockers by logging them clearly

❌ **DON'T:**
- Make changes without testing them
- Skip logging or documentation
- Leave incomplete tasks hanging
- Commit code without clear messages
- Ignore errors in Output console

---

## Communication

**How Claude Code (me) will talk to you:**
- I'll add new tasks to WATCHER_TASKS.md
- You'll read new tasks automatically
- I'll check WATCHER_LOG.md for your progress
- No need for back-and-forth chat — just execute and log

**This keeps both chats clean:**
- My chat: Testing, iteration, decision-making
- Your chat: Background work, testing, logging

---

## Quick Start

1. Rename `WATCHER_LOG_INIT.md` → `WATCHER_LOG.md`
2. Read `PLAN.md` to understand Phase 4.1
3. Read `WATCHER_TASKS.md` to see your assignments
4. Start with the first `[ ] TODO` task
5. Log everything in `WATCHER_LOG.md`
6. Mark tasks `[✅] DONE` when complete

---

## Files You'll Monitor

| File | Purpose | Updated By |
|------|---------|-----------|
| `WATCHER_TASKS.md` | Task queue (your input) | Claude Code |
| `WATCHER_LOG.md` | Execution log (your output) | You (@watcher) |
| `PLAN.md` | Roadmap reference | Claude Code |
| `MASTER_PROMPT.md` | Project context | (Reference only) |
| `HANDOFF.md` | Current phase status | (Reference only) |

---

## Ready?

✅ You have everything you need.  
✅ Start monitoring WATCHER_TASKS.md.  
✅ Begin Phase 4.1 testing immediately.  
✅ Log all work in WATCHER_LOG.md.  

**Let's go!**

---

**Instructions Created By:** Claude Code  
**Date:** 2026-06-04  
**Status:** ACTIVE
