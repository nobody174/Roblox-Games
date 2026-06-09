# Quick Copy/Paste Guide

## The 4 Files You Need to Update

### 1️⃣ CREATE: GhostAI Module
**In Studio:** ServerScriptService → + → ModuleScript → Name: `GhostAI`
**Copy From:** `src/server/GhostAI.lua` (entire file)

---

### 2️⃣ CREATE: PhaseManager Module  
**In Studio:** ServerScriptService → + → ModuleScript → Name: `PhaseManager`
**Copy From:** `src/server/PhaseManager.lua` (entire file)

---

### 3️⃣ REPLACE: MainServer_Phase4_Extended Script
**In Studio:** ServerScriptService → MainServer_Phase4_Extended → (select all, replace)
**Copy From:** `src/server/MainServer_Phase4_Extended.lua` (entire file)

---

### 4️⃣ REPLACE: ZoneManager Module
**In Studio:** ServerScriptService → ZoneManager → (select all, replace)
**Copy From:** `src/server/ZoneManager.lua` (entire file)

---

## That's It!

After updating all 4 files:
1. Press **PLAY** in Studio
2. Open **Output** window
3. Wait for: `[PHASE 4] Spawn cycle #1: Spawned X ghosts`
4. Look around for ghosts to catch!

---

## Expected Output Messages (Good Signs ✅)

```
[PhaseManager] Initializing...
[PhaseManager] Created private phase #1 for [YourName]
[PhaseManager] Teleported [YourName] to private phase
[PhaseManager] Initialized!
[ZoneManager] Initializing...
[ZoneManager] ZoneContainer found, proceeding...
[ZoneManager] Initialized!
[PHASE 4] ZoneManager initialized, starting ghost spawn loop...
[PHASE 4] Spawn cycle #1: Spawned 12 ghosts
```

If you see these = **Everything working!** 🎉

---

## Error You Might See (and How to Fix)

### Error: `ServerScriptService.PhaseManager required but not found`
**Fix:** You didn't create the PhaseManager module yet
- Create it: ServerScriptService → + → ModuleScript → Name: `PhaseManager`
- Copy entire `src/server/PhaseManager.lua` into it

### Error: `ServerScriptService.GhostAI required but not found`
**Fix:** You didn't create the GhostAI module yet
- Create it: ServerScriptService → + → ModuleScript → Name: `GhostAI`
- Copy entire `src/server/GhostAI.lua` into it

### No ghosts spawning
**Fix:** Make sure all 4 files are properly updated
- Check Output for the startup messages above
- If PhaseManager message is missing, it didn't load correctly

---

## Visual Walkthrough

### Step 1: Creating GhostAI
```
1. Open Studio, look at left side where ServerScriptService is shown
2. Click the + icon next to ServerScriptService
3. Choose "ModuleScript"
4. Name it: GhostAI
5. Open src/server/GhostAI.lua in vscode
6. Ctrl+A (select all)
7. Ctrl+C (copy)
8. Go back to Studio, click in the script editor
9. Ctrl+A (select all)
10. Ctrl+V (paste)
11. Script should now contain the GhostAI code
```

### Step 2: Creating PhaseManager
```
1. Repeat Step 1 but:
   - Name it: PhaseManager
   - Copy from: src/server/PhaseManager.lua
```

### Step 3: Replacing MainServer_Phase4_Extended
```
1. In Studio, find MainServer_Phase4_Extended script
2. Open it
3. Ctrl+A (select all)
4. Open src/server/MainServer_Phase4_Extended.lua in vscode
5. Ctrl+A (select all)
6. Ctrl+C (copy)
7. Back to Studio
8. Ctrl+V (paste)
9. Script now has the updated code
```

### Step 4: Replacing ZoneManager
```
1. In Studio, find ZoneManager module
2. Open it
3. Ctrl+A (select all)
4. Open src/server/ZoneManager.lua in vscode
5. Ctrl+A (select all)
6. Ctrl+C (copy)
7. Back to Studio
8. Ctrl+V (paste)
9. Module now has the updated code
```

### Step 5: Test
```
1. Close all script editors
2. Press PLAY
3. Open Output (View menu → Output)
4. Wait 5 seconds
5. Look for spawn messages
6. Walk around to find ghosts
7. Catch one!
```

---

## Summary Table

| File | Location | Action | Status |
|------|----------|--------|--------|
| GhostAI.lua | src/server/ | **CREATE** new ModuleScript | ⬜ TODO |
| PhaseManager.lua | src/server/ | **CREATE** new ModuleScript | ⬜ TODO |
| MainServer_Phase4_Extended.lua | src/server/ | **REPLACE** entire script | ⬜ TODO |
| ZoneManager.lua | src/server/ | **REPLACE** entire module | ⬜ TODO |

---

## Done! ✅

Once all 4 files are updated and you see the spawn messages in Output, you're ready to test:

✅ Ghosts spawn in **shared zones** (Whisper Woods, Foggy Fields, etc.)
✅ Ghosts spawn in **your private Starting Area** 
✅ Ghosts have **smart AI** (stationary → teleporting based on rarity)
✅ You can **catch ghosts** and earn coins
✅ Ghosts **persist** when you rejoin

**Now go test it!** 🚀
