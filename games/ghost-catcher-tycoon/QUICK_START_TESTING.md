# 🚀 Quick Start — Testing in Studio (5 minutes)

## Setup Instructions

### Step 1: Prepare Files (3 minutes)
```
1. In vscode, copy these folders to Studio:
   src/server/systems/*        → ServerScriptService/systems/
   src/server/*.lua (all)      → ServerScriptService/
   src/client/*.lua (all)      → StarterPlayer/StarterCharacterScripts/
   src/shared/EquipmentData.lua → ReplicatedStorage/shared/

2. In Studio:
   - Delete ZoneContainer in Workspace (to regenerate zones)
   - Open Output console (View → Output)
   - Make sure ServerScriptService/MainServer_Phase4_Extended.lua is running
```

### Step 2: Launch Game (1 minute)
```
Press PLAY in Studio
Watch the console for module loading messages
```

### Step 3: Start Testing (1 minute)
```
Use STUDIO_TESTING_INTERACTIVE.md
Open on another screen/window
Check off items as you test each one
```

---

## 🎯 First 5 Minutes (Quick Smoke Test)

### Minute 1: Initialization
- [ ] Spawn in game
- [ ] Check console: Look for `[PHASE 4]` messages
- [ ] No red errors

### Minute 2: Equipment
- [ ] See equipment slot UI
- [ ] Equipment shows "Basic Net"
- [ ] Can see catch rates displayed

### Minute 3: Ghost Spawning
- [ ] Walk to any zone
- [ ] See 1-2 ghosts appear
- [ ] Hover over ghost → Ghost Info Panel appears

### Minute 4: Catch Attempt
- [ ] Target ghost, press E
- [ ] See charge progress bar
- [ ] After charge: Either caught or escaped
- [ ] HUD updates (coins/ghosts)

### Minute 5: Leveling
- [ ] Catch 5-10 ghosts quickly
- [ ] Watch XP accumulate
- [ ] Level up notification appears

---

## 📋 Full Testing (20-30 minutes)

Follow **STUDIO_TESTING_INTERACTIVE.md** in order:

1. Pre-Testing Setup ✅ (already done above)
2. Test 1: Spawn & Initialization
3. Test 2: Equipment Inventory
4. Test 3: Ghost Spawning
5. Test 4: Catch Success
6. Test 5: Catch Failure
7. Test 6: Energy System
8. Test 7: Level Up
9. Test 8: Zone Unlock
10. Test 9: Zone Multipliers
11. Test 10: Daily Quests
12. Test 11: Streak System
13. Test 12: Save Data
14. Test 13: Load Data
15. Test 14: Equipment Progression

---

## 🐛 If Something Breaks

### Check Console First
```
1. Open Output console (Ctrl+G or View → Output)
2. Look for red ERROR messages
3. Copy the error text
4. Paste in GitHub issue or to me
```

### Common Issues

**"Module not found" error**
→ File wasn't copied to correct folder
→ Check ServerScriptService for the required .lua file

**"attempt to index nil" error**
→ A system didn't initialize
→ Check console for `[PHASE 4] ... initialized` messages
→ If missing, that system failed to load

**No ghosts spawning**
→ ZONE_AUTO_BUILDER didn't run
→ Delete ZoneContainer and restart
→ Or manually spawn ghost with admin command

**Catch button doesn't work**
→ Energy too low
→ Or ghost too far away
→ Or equipment not loaded
→ Check console for errors

---

## 📱 Two-Screen Setup (Recommended)

### Screen 1: Studio
- Studio window with game running
- Output console visible at bottom
- Size: 60% of screen

### Screen 2: Markdown Reader
- Open STUDIO_TESTING_INTERACTIVE.md in:
  - VS Code (split view)
  - Notepad++
  - Any markdown reader
  - Even just a web browser
- Scroll through checklist
- Check off items as you test
- Size: 40% of screen

---

## 💾 Saving Your Checklist

After testing:

```
1. Save STUDIO_TESTING_INTERACTIVE.md with all checkmarks
2. git add STUDIO_TESTING_INTERACTIVE.md
3. git commit -m "test: completed studio testing with results"
4. git push
```

This creates a record of what was tested and what passed/failed.

---

## ✅ Definition of "Passing"

Each test PASSES if:
- ✅ All checkboxes in that section are checked
- ✅ No critical errors in console
- ✅ Behavior matches expected outcome
- ✅ Performance is smooth (no lag)

A test FAILS if:
- ❌ Expected behavior doesn't happen
- ❌ Red error in console related to that feature
- ❌ UI is broken or unreadable

A test is PARTIAL if:
- ⚠️ Some features work, others don't
- ⚠️ Works but has minor visual bugs
- ⚠️ Works but is very slow/laggy

---

## 📊 Success Criteria

### For this testing session to be successful:
- [ ] Tests 1-9 all PASS (core functionality)
- [ ] Tests 10-14 all PASS (progression systems)
- [ ] No critical bugs found (red console errors)
- [ ] Performance is acceptable (no lag)
- [ ] Data persists correctly

### If all above pass:
✅ **Ready to move forward!**
→ Next: Phase 2 features (energy regen, prestige, cosmetics)

### If something fails:
⚠️ **Note the issue, I'll fix it**
→ Use console error message as reference
→ Paste exact reproduction steps

---

## 🎬 After Testing

**When you're done:**

1. Fill out the "Final Results" section in STUDIO_TESTING_INTERACTIVE.md
2. List any bugs you found
3. Save the file
4. Push to GitHub
5. Let me know: "Testing complete! X tests passed, Y issues found"
6. I'll fix any bugs and we iterate

---

## 📞 Quick Reference

| Issue | Check |
|---|---|
| Module not loading | Is file in correct ServerScriptService folder? |
| System not initializing | Check console for `[PHASE 4]` messages |
| No ghosts | Did you delete ZoneContainer? |
| Catch not working | Check energy level and ghost distance |
| UI not showing | Did you copy client files to StarterPlayer? |
| Data not saving | Check console for save messages every 30s |
| Lag/stuttering | Check how many ghosts are active |
| Equipment not updating | Try equipping a different item |

---

**You're ready! 🚀 Go test in Studio!**

Questions? Let me know. Otherwise, start with the checklist and check off each item as you go.

---

*Quick Start v1.0 — 2026-06-09*
