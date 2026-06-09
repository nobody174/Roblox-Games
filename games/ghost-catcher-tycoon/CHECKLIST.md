# ✅ Complete Setup Checklist

Print this out or check off as you go!

---

## 📋 PRE-SETUP

- [ ] You have Roblox Studio open with Ghost Catcher Tycoon game
- [ ] You have vscode open with the project folder
- [ ] You can see OUTPUT window in Studio (View → Output)
- [ ] Both windows are visible side-by-side (easier to copy/paste)

---

## 🔧 CREATING NEW FILES

### GhostAI Module
- [ ] In Studio, open ServerScriptService folder
- [ ] Click + icon next to ServerScriptService
- [ ] Select "ModuleScript"
- [ ] Name it exactly: `GhostAI`
- [ ] Open vscode, go to: `src/server/GhostAI.lua`
- [ ] Select all (Ctrl+A)
- [ ] Copy (Ctrl+C)
- [ ] Go to Studio, click in script editor
- [ ] Select all (Ctrl+A)
- [ ] Paste (Ctrl+V)
- [ ] Verify first line is: `local GhostAI = {}`
- [ ] Click Save (or Ctrl+S)

### PhaseManager Module
- [ ] In Studio, open ServerScriptService folder
- [ ] Click + icon next to ServerScriptService
- [ ] Select "ModuleScript"
- [ ] Name it exactly: `PhaseManager`
- [ ] Open vscode, go to: `src/server/PhaseManager.lua`
- [ ] Select all (Ctrl+A)
- [ ] Copy (Ctrl+C)
- [ ] Go to Studio, click in script editor
- [ ] Select all (Ctrl+A)
- [ ] Paste (Ctrl+V)
- [ ] Verify first line is: `local PhaseManager = {}`
- [ ] Click Save

---

## 🔄 REPLACING EXISTING FILES

### MainServer_Phase4_Extended
- [ ] In Studio, find ServerScriptService → MainServer_Phase4_Extended
- [ ] Open it (double-click)
- [ ] Select all (Ctrl+A)
- [ ] Open vscode, go to: `src/server/MainServer_Phase4_Extended.lua`
- [ ] Select all (Ctrl+A)
- [ ] Copy (Ctrl+C)
- [ ] Go back to Studio, in the script editor
- [ ] Paste (Ctrl+V)
- [ ] Verify it pasted the entire file (~1250+ lines)
- [ ] Click Save

### ZoneManager
- [ ] In Studio, find ServerScriptService → ZoneManager
- [ ] Open it (double-click)
- [ ] Select all (Ctrl+A)
- [ ] Open vscode, go to: `src/server/ZoneManager.lua`
- [ ] Select all (Ctrl+A)
- [ ] Copy (Ctrl+C)
- [ ] Go back to Studio, in the script editor
- [ ] Paste (Ctrl+V)
- [ ] Verify it pasted the entire file (~260 lines)
- [ ] Click Save

---

## 🎮 TESTING

### Before Playing
- [ ] Close all script editors in Studio
- [ ] ServerScriptService should now contain:
  - [ ] GhostAI (ModuleScript) ← NEW
  - [ ] PhaseManager (ModuleScript) ← NEW
  - [ ] MainServer_Phase4_Extended (Script) ← UPDATED
  - [ ] ZoneManager (ModuleScript) ← UPDATED
  - [ ] Other scripts (unchanged)

### Play Test
- [ ] Click PLAY button in Studio
- [ ] Open OUTPUT window (View → Output)
- [ ] Wait 3 seconds
- [ ] Look for these messages in order:
  - [ ] `[PhaseManager] Initializing...`
  - [ ] `[PhaseManager] Created private phase #1 for [YourName]`
  - [ ] `[PhaseManager] Teleported [YourName] to private phase`
  - [ ] `[PhaseManager] Initialized!`
  - [ ] `[ZoneManager] Initializing...`
  - [ ] `[ZoneManager] ZoneContainer found, proceeding...`
  - [ ] `[ZoneManager] Initialized!`
  - [ ] `[PHASE 4] ZoneManager initialized, starting ghost spawn loop...`
  - [ ] `[PHASE 4] Spawn cycle #1: Spawned X ghosts`

If you see all these messages → Everything is working! ✅

### Gameplay Test
- [ ] You are in a zone (should be Starting Area)
- [ ] Wait 5 seconds
- [ ] Look around for a glowing ghost sphere
- [ ] You see at least 1 ghost
- [ ] Click CHARGE button (top-left area) 2-3 times
- [ ] Walk toward the ghost
- [ ] Click CATCH button when close
- [ ] Output shows: `Caught [GhostName] ([Rarity]) for X coins!`
- [ ] Your coin count increases
- [ ] Ghost disappears

If all these work → Ghost catching is working! ✅

### Persistence Test
- [ ] Your caught ghost is visible in inventory (top-right area)
- [ ] Your coin count matches catches (1 coin for Common, 3 for Uncommon, etc.)
- [ ] Click STOP (stop playing)
- [ ] Click PLAY again (new session)
- [ ] Open OUTPUT window
- [ ] Look for: `[PHASE 4] Saved player data for [YourName] to DataStore`
- [ ] Wait for startup messages again
- [ ] Check inventory: your caught ghost is STILL there!
- [ ] Your coins are STILL there!

If ghosts persist → Persistence is working! ✅

---

## ❌ TROUBLESHOOTING CHECKLIST

### If you see: "Module not found" error
- [ ] Check module name spelling: must be exactly `GhostAI` or `PhaseManager`
- [ ] Verify you created ModuleScript, not Script
- [ ] Verify modules are in ServerScriptService (not in a subfolder)

### If no ghosts spawn
- [ ] Check Output for `[PHASE 4] Spawn cycle` message
- [ ] If missing, make sure GhostAI and PhaseManager modules exist
- [ ] Check for red errors in Output
- [ ] Wait 10+ seconds after clicking PLAY (spawning takes time)

### If ghosts appear but don't move
- [ ] Verify GhostAI.lua was copied completely (should be ~195 lines)
- [ ] Check for red errors in Output about GhostAI
- [ ] Make sure BodyVelocity exists on ghost (it should be created by spawnGhost)

### If you can't catch ghosts
- [ ] Move closer to ghost (within 20 studs)
- [ ] Make sure you CHARGED the vacuum first (click CHARGE 2-3 times)
- [ ] Click CATCH when you're standing right next to the ghost
- [ ] Check Output for error messages about catching

### If game crashes on startup
- [ ] Check Output for red Lua errors
- [ ] Most likely: One of the modules has incorrect code
- [ ] Re-copy the file (make sure you got the ENTIRE contents)

---

## 📊 FINAL VERIFICATION

After testing, you should have:

**✅ In Studio ServerScriptService:**
```
✓ GhostAI (ModuleScript)
✓ PhaseManager (ModuleScript)
✓ MainServer_Phase4_Extended (Script)
✓ ZoneManager (ModuleScript)
✓ [other scripts unchanged]
```

**✅ In Output Window (all these messages):**
```
[PhaseManager] Initialized!
[ZoneManager] Initialized!
[PHASE 4] ZoneManager initialized, starting ghost spawn loop...
[PHASE 4] Spawn cycle #1: Spawned X ghosts
```

**✅ In Gameplay:**
```
You can see ghosts spawning
You can catch ghosts
Coins increase
Inventory shows caught ghosts
Data persists on rejoin
```

---

## 🎉 SUCCESS!

If you've checked all boxes above, you have successfully:

✅ Created 2 new modules (GhostAI, PhaseManager)
✅ Updated 2 existing scripts (MainServer, ZoneManager)
✅ Implemented ghost AI behavior
✅ Implemented private player phases
✅ Tested ghost spawning in private zones
✅ Tested ghost catching and inventory
✅ Tested persistence

**Congratulations!** All 6 tasks are complete and working! 🚀

---

## 📝 NOTES

Write any issues/observations here:

```
[Space for your notes]
Date: ________________
Issues encountered: ________________________________________________
How I fixed it: ________________________________________________
Other observations: ________________________________________________
```

---

**Last Updated:** 2026-06-09
**Status:** Ready for Testing ✅
