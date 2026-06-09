# Studio Update Guide - All Changes

This document lists every file that was modified or created, with instructions on how to update them in Roblox Studio.

## ✅ New Files (Create These in Studio)

### 1. **GhostAI.lua** (ModuleScript in ServerScriptService)
**Path in Studio:** `ServerScriptService > GhostAI`
**Source:** `src/server/GhostAI.lua`

This module handles ghost behavior based on rarity:
- Common: Stationary
- Uncommon: Wanders slowly
- Rare: Flees from players
- Epic: Aggressively flees
- Legendary: Teleports + flees
- Corrupted: Aggressively teleports

**Action:** 
- Create a new ModuleScript named `GhostAI` in ServerScriptService
- Copy entire contents of `src/server/GhostAI.lua` into it

---

### 2. **PhaseManager.lua** (ModuleScript in ServerScriptService)
**Path in Studio:** `ServerScriptService > PhaseManager`
**Source:** `src/server/PhaseManager.lua`

This module creates private instanced zones (phases) for each player's Starting Area:
- Creates a cloned "Hub" for each player when they join
- Teleports player to their private phase
- Cleans up empty phases when players leave
- Tracks which phase each player is in

**Action:**
- Create a new ModuleScript named `PhaseManager` in ServerScriptService
- Copy entire contents of `src/server/PhaseManager.lua` into it

---

## 📝 Modified Files (Update These in Studio)

### 3. **MainServer_Phase4_Extended.lua** (Script in ServerScriptService)
**Path in Studio:** `ServerScriptService > MainServer_Phase4_Extended`
**Source:** `src/server/MainServer_Phase4_Extended.lua`

**Changes Made:**
1. **Line ~111:** Added GhostAI require statement
   ```lua
   local GhostAI = require(game:GetService("ServerScriptService"):WaitForChild("GhostAI"))
   ```

2. **Line ~162:** Modified `spawnGhost()` function signature to accept optional `targetFolder` parameter
   ```lua
   local function spawnGhost(zoneName, targetFolder)
   ```

3. **Line ~165:** Updated zone lookup to use targetFolder if provided
   ```lua
   local searchContainer = targetFolder or workspace:FindFirstChild("ZoneContainer")
   ```

4. **Line ~327:** Added GhostAI initialization after ghost creation
   ```lua
   -- Initialize AI behavior based on rarity
   GhostAI:initializeGhost(ghostModel, rarity)
   ```

5. **Line ~343-397:** Completely replaced the ghost spawn loop with `startGhostSpawnLoop()` function that:
   - Waits for ZoneManager to initialize
   - Spawns ghosts in shared zones
   - Spawns ghosts in each player's private phase

6. **Line ~1250-1252:** Added spawn loop start call
   ```lua
   zoneManager:initialize()
   print("[PHASE 4] ZoneManager initialized, starting ghost spawn loop...")
   startGhostSpawnLoop()
   ```

**Action:**
- Open `MainServer_Phase4_Extended` script in Studio
- Replace the ENTIRE file with contents from `src/server/MainServer_Phase4_Extended.lua`

---

### 4. **ZoneManager.lua** (ModuleScript in ServerScriptService)
**Path in Studio:** `ServerScriptService > ZoneManager`
**Source:** `src/server/ZoneManager.lua`

**Changes Made:**
1. **Line ~10:** Added PhaseManager require
   ```lua
   local PhaseManager = require(game:GetService("ServerScriptService"):WaitForChild("PhaseManager"))
   ```

2. **Line ~39-58:** Modified `initialize()` function to create and initialize PhaseManager
   ```lua
   -- Initialize PhaseManager for private Starting Area instances
   local phaseManager = PhaseManager:new()
   phaseManager:initialize()
   self.phaseManager = phaseManager
   ```

3. **Line ~154-190:** Updated `startPlayerZoneDetection()` to check private phases first
   ```lua
   -- First check if player is in their private phase (Starting Area)
   local currentZone = nil
   if self.phaseManager and self.phaseManager:isZoneInPhase(player, "Hub") then
       -- Player is in their private Starting Area phase
       currentZone = "Starting Area"
   else
       -- Check shared zones
       currentZone = self:detectPlayerZone(hrp)
   end
   ```

**Action:**
- Open `ZoneManager` ModuleScript in Studio
- Replace the ENTIRE file with contents from `src/server/ZoneManager.lua`

---

## 🧪 How to Test in Studio

### Test Flow (5-10 minutes):

**Step 1: Verify Files Are in Place**
```
ServerScriptService should have:
├── MainServer_Phase4_Extended (Script) ✓
├── ZoneManager (ModuleScript) ✓
├── PhaseManager (ModuleScript) ✓ [NEW]
├── GhostAI (ModuleScript) ✓ [NEW]
└── [other scripts...]
```

**Step 2: Start the Game**
1. Press **Play** in Studio
2. Open **Output** window (View → Output)
3. Look for these startup messages:
   ```
   [PhaseManager] Initializing...
   [PhaseManager] Created private phase #1 for [YourName]
   [PhaseManager] Teleported [YourName] to private phase
   [ZoneManager] Initialized!
   [PHASE 4] ZoneManager initialized, starting ghost spawn loop...
   [PHASE 4] Spawn cycle #1: Spawned X ghosts
   ```

**Step 3: Wait for Ghosts to Spawn**
- Should see: `[PHASE 4] Spawn cycle #X: Spawned Y ghosts` every few seconds
- Ghosts spawn in both:
  - Shared islands (Whisper Woods, Foggy Fields, etc.)
  - Your private Starting Area

**Step 4: Catch a Ghost in Starting Area**
1. Walk around until you see a glowing ghost sphere
2. Click **CHARGE** button (do this 2-3 times)
3. Move close to ghost (within 20 studs)
4. Click **CATCH** button
5. Watch Output for:
   ```
   [PHASE 4] Caught [GhostName] ([Rarity]) for X coins!
   ```

**Step 5: Test Persistence**
1. Stop the game (click **Stop**)
2. Start again (click **Play**)
3. Check if caught ghost is still in your inventory
4. Look for save messages:
   ```
   [PHASE 4] Saved player data for [YourName] to DataStore
   [PHASE 4] DataStore integration hooked
   ```

---

## 🐛 Troubleshooting

### "No ghosts spawning in Starting Area"
- Check Output for: `[PHASE 4] Spawn cycle #X: Spawned 0 ghosts`
- **Fix:** Make sure both `GhostAI.lua` and `PhaseManager.lua` are created in ServerScriptService
- Verify PhaseManager initialization message appears

### "Module not found" error
- Error will look like: `ServerScriptService.PhaseManager required but not found`
- **Fix:** Create the missing ModuleScript in ServerScriptService with exact name

### "Ghosts only spawn in shared zones, not Starting Area"
- **Fix:** Ensure `startGhostSpawnLoop()` is called after `zoneManager:initialize()`
- Check Output for: `ZoneManager initialized, starting ghost spawn loop...`

### "Ghost spawns but doesn't move/act strange"
- **Fix:** Make sure `GhostAI.lua` is correctly copied
- Check Output for any Lua errors

---

## 📊 What Each File Does

| File | Purpose | Type |
|------|---------|------|
| **GhostAI.lua** | Ghost behavior (stationary → teleport based on rarity) | NEW Module |
| **PhaseManager.lua** | Private zone instances per player | NEW Module |
| **MainServer_Phase4_Extended.lua** | Main server script (integrates both above) | UPDATED |
| **ZoneManager.lua** | Zone detection + phasing awareness | UPDATED |

---

## 🎯 Expected Results After Testing

✅ **Session 1:**
- Player joins
- Teleported to private Starting Area (Phase_1_PlayerName)
- Ghosts spawn every few seconds
- Can catch ghosts and earn coins
- Inventory shows caught ghosts

✅ **Session 2 (After Rejoin):**
- Same caught ghosts still in inventory
- Same coins earned
- Can catch more ghosts

---

## 📋 Copy/Paste Checklist

- [ ] Created `GhostAI` ModuleScript in ServerScriptService
- [ ] Created `PhaseManager` ModuleScript in ServerScriptService  
- [ ] Updated `MainServer_Phase4_Extended` with new version
- [ ] Updated `ZoneManager` with new version
- [ ] Tested ghost spawning (shared zones)
- [ ] Tested ghost spawning (private Starting Area)
- [ ] Tested catching a ghost
- [ ] Tested persistence (stop/play)

