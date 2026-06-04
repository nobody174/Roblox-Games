# @watcher Autonomous Scheduling

**Date Created:** 2026-06-04  
**Schedule Interval:** Every 10 minutes  
**Purpose:** Automatic task scanning and execution  

---

## How It Works

@watcher is scheduled to:
1. **Every 10 minutes:** Wake up and check WATCHER_TASKS.md
2. **Scan for new tasks:** Look for `[ ] TODO` items
3. **Execute work:** Complete tasks marked `[ ] TODO`
4. **Log progress:** Update WATCHER_LOG.md continuously
5. **Report status:** Mark tasks as `[x] IN PROGRESS` then `[✅] DONE`

**No manual command needed.** The scheduler handles everything.

---

## Scheduling Details

| Setting | Value |
|---------|-------|
| Check Interval | 10 minutes (600 seconds) |
| First Check | Immediately after Phase starts |
| Log File | WATCHER_LOG.md |
| Task Source | WATCHER_TASKS.md |
| Next Check | Every 10 min thereafter |

---

## For You (Main Chat)

✅ **Monitor @watcher's progress:**
- Check WATCHER_TASKS.md to see which tasks are `[✅] DONE`
- Check WATCHER_LOG.md to see detailed test results
- No need to send messages — he's working autonomously

✅ **Add new tasks:**
- Add `[ ] TODO:` items to WATCHER_TASKS.md
- @watcher will pick them up automatically within 10 minutes

✅ **Create new phases:**
- Create a PHASE_X_POLISH.md file
- Add tasks to WATCHER_TASKS.md
- @watcher will discover and work on them automatically

---

## Task Format @watcher Monitors

```markdown
- [ ] TODO: [Task description]
```

When @watcher picks it up:
```markdown
- [x] IN PROGRESS: [Task description]
```

When complete:
```markdown
- [✅] DONE: [Task description]
```

---

## Status

**Scheduled:** Yes ✅  
**Interval:** Every 10 minutes  
**Start Time:** 2026-06-04 ~13:50  
**Active:** Until manually stopped

---

## How to Modify Schedule

If you want to change the interval:
- Edit this file and change the interval
- The next scheduled check will use the new interval
- Current: 10 minutes (good for active development)
- Alternatives: 5 min (faster), 15 min (slower), 30 min (batch processing)

---

## What Happens During Each Check

1. **Read WATCHER_TASKS.md** — scan for new `[ ] TODO` tasks
2. **Check for new phase files** — detect PHASE_X_POLISH.md or PHASE_X.md
3. **Execute any pending work** — start `[ ] TODO` tasks
4. **Update status** — mark as `[x] IN PROGRESS` → `[✅] DONE`
5. **Log results** — append to WATCHER_LOG.md
6. **Sleep 10 minutes** — wake up and repeat

---

## Emergency Stop

If you need to pause @watcher:
- Add this to WATCHER_TASKS.md:
```markdown
- [ ] PAUSE: Maintenance pause requested
```
@watcher will see it and pause work until removed.

---

**Automated Scheduling Active** ✅
