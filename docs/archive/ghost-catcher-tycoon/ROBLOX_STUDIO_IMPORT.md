<!--
  Ghost Catcher Tycoon - Roblox Studio Import Guide
  Follow this step-by-step to set up the game
-->

# Roblox Studio Import Guide

## What You Have
- ✅ `place.rbxl` - Your blank game file (already created)
- ✅ All source code files in `src/` folder
- ✅ This guide to import everything

## Import Steps (15-20 minutes)

### Step 1: Open place.rbxl in Roblox Studio (2 min)

1. **Open Roblox Studio**
2. **File → Open**
3. Navigate to: `C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\`
4. **Select `place.rbxl`**
5. **Click Open**

Studio should load with your blank place.

---

### Step 2: Create Shared Modules (5 min)

In Roblox Studio **Explorer** panel:

1. **Find `ReplicatedStorage`** (right side panel)
2. **Right-click ReplicatedStorage** → **Insert Object** → **Folder**
3. **Name it: `shared`**

Now inside the `shared` folder, create 3 ModuleScripts:

#### **2.1 Create config module:**
1. **Right-click `shared` folder** → **Insert Object** → **ModuleScript**
2. **Name it: `config`**
3. **Open the script** (double-click it)
4. **Delete all default text**
5. **Copy from:** `src/shared/config.lua`
6. **Paste entire file into the script**
7. **Done!**

#### **2.2 Create enums module:**
1. **Right-click `shared` folder** → **Insert Object** → **ModuleScript**
2. **Name it: `enums`**
3. **Open the script**
4. **Delete all default text**
5. **Copy from:** `src/shared/enums.lua`
6. **Paste entire file**

#### **2.3 Create constants module:**
1. **Right-click `shared` folder** → **Insert Object** → **ModuleScript**
2. **Name it: `constants`**
3. **Open the script**
4. **Delete all default text**
5. **Copy from:** `src/shared/constants.lua`
6. **Paste entire file**

**Check:** In Explorer, you should see:
```
ReplicatedStorage
└── shared
    ├── config
    ├── enums
    └── constants
```

---

### Step 3: Create Server Scripts Folders (2 min)

1. **Find `ServerScriptService`** in Explorer
2. **Right-click ServerScriptService** → **Insert Object** → **Folder**
3. **Name it: `data`**
4. **Right-click ServerScriptService** → **Insert Object** → **Folder**
5. **Name it: `systems`**

**Check:** You should see:
```
ServerScriptService
├── data
└── systems
```

---

### Step 4: Add DataManager (3 min)

1. **Right-click `ServerScriptService/data`** → **Insert Object** → **ModuleScript**
2. **Name it: `DataManager`**
3. **Open the script**
4. **Delete all default text**
5. **Copy from:** `src/server/data/DataManager.lua`
6. **Paste entire file**

---

### Step 5: Add All 17 Systems (7 min)

For each system file, repeat this process:

1. **Right-click `ServerScriptService/systems`** → **Insert Object** → **ModuleScript**
2. **Name it exactly as the file** (without .lua extension)
3. **Open the script**
4. **Delete all default text**
5. **Copy from:** `src/server/systems/[SystemName].lua`
6. **Paste entire file**

**Copy these 17 systems:**
1. CurrencySystem
2. VacuumSystem
3. GhostSystem
4. ProductionSystem
5. HQSystem
6. TrainingSystem
7. ZoneSystem
8. MonetizationSystem
9. AutoCatchSystem
10. AutoTrainSystem
11. QuestSystem
12. LeaderboardSystem
13. GachaSystem
14. CosmeticsSystem
15. PvPSystem
16. PrestigeSystem
17. EventSystem

---

### Step 6: Add MainServer (2 min)

1. **Right-click `ServerScriptService`** → **Insert Object** → **Script**
2. **Name it: `MainServer`**
3. **Open the script**
4. **Delete all default text**
5. **Copy from:** `TO_COPY_MainServer.lua` (in your project root)
6. **Paste entire file**

---

### Step 7: Add GameClient (2 min)

1. **Find `StarterPlayer`** in Explorer
2. **Expand it** and find **`StarterCharacterScripts`**
3. **Right-click `StarterCharacterScripts`** → **Insert Object** → **LocalScript**
4. **Name it: `GameClient`**
5. **Open the script**
6. **Delete all default text**
7. **Copy from:** `src/client/GameClient.lua`
8. **Paste entire file**

---

### Step 8: Verify Everything (2 min)

Your Explorer should now look like:

```
ServerScriptService
├── MainServer (Script)
├── data
│   └── DataManager (ModuleScript)
└── systems (Folder with 17 ModuleScripts)
    ├── CurrencySystem
    ├── VacuumSystem
    ├── GhostSystem
    ├── ProductionSystem
    ├── HQSystem
    ├── TrainingSystem
    ├── ZoneSystem
    ├── MonetizationSystem
    ├── AutoCatchSystem
    ├── AutoTrainSystem
    ├── QuestSystem
    ├── LeaderboardSystem
    ├── GachaSystem
    ├── CosmeticsSystem
    ├── PvPSystem
    ├── PrestigeSystem
    └── EventSystem

StarterPlayer
└── StarterCharacterScripts
    └── GameClient (LocalScript)

ReplicatedStorage
└── shared
    ├── config
    ├── enums
    └── constants
```

---

### Step 9: Save Your Game (1 min)

**File → Save** (or Ctrl+S)

---

### Step 10: Test! (2 min)

1. **Click the PLAY button** (top center in Studio)
2. **Open Output console:** View → Output
3. **Look for messages like:**
   ```
   [Ghost Catcher Tycoon] Server started
   [Ghost Catcher Tycoon] Initializing...
   [Ghost Catcher Tycoon] Remotes created
   [Ghost Catcher Tycoon] Player joined: [YourName]
   [Ghost Catcher Tycoon] Data loaded for [YourName]
   [Ghost Catcher Tycoon] Vacuum remote setup complete
   [Ghost Catcher Tycoon] Training remote setup complete
   [Ghost Catcher Tycoon] Zone remote setup complete
   [Ghost Catcher Tycoon] Monetization remotes setup complete
   [Ghost Catcher Tycoon] Server initialization complete!
   [Ghost Catcher Tycoon] Client initializing...
   [Ghost Catcher Tycoon] Remotes connected
   [Ghost Catcher Tycoon] UI created with tabs
   [Ghost Catcher Tycoon] Input handlers connected
   [Ghost Catcher Tycoon] Client initialized!
   ```

4. **If you see all these messages: ✅ SUCCESS!**

5. **Try clicking the big blue CHARGE button in the middle of the screen**

6. **Watch the Energy number increase in the top-left**

7. **Try switching tabs at the bottom** (Ghosts, HQ, Zones, Shop, Info)

---

## If Something Goes Wrong

### Error: "Module not found"
- Check that all 17 systems are in ServerScriptService/systems
- Check that DataManager is in ServerScriptService/data
- Check that config, enums, constants are in ReplicatedStorage/shared

### Error: "function expected, got nil"
- Check that all ModuleScripts use correct names
- Verify you copied the ENTIRE file content (not partial)
- Make sure you didn't paste into wrong module

### Error: "attempt to index nil"
- A system is trying to access another system that isn't loaded
- Check all 17 systems are imported
- Verify MainServer can find them

### No UI appears / Button doesn't work
- Check GameClient is a LocalScript in StarterCharacterScripts
- Check Output for errors
- Verify you copied complete GameClient.lua

---

## Quick File Reference

All files are in your project folder. Copy from:

- **src/shared/config.lua** → ReplicatedStorage/shared/config
- **src/shared/enums.lua** → ReplicatedStorage/shared/enums
- **src/shared/constants.lua** → ReplicatedStorage/shared/constants
- **src/server/data/DataManager.lua** → ServerScriptService/data/DataManager
- **src/server/systems/*.lua** → ServerScriptService/systems/*
- **TO_COPY_MainServer.lua** → ServerScriptService/MainServer
- **src/client/GameClient.lua** → StarterPlayer/StarterCharacterScripts/GameClient

---

## Success!

If you see the Output messages and can click CHARGE to earn energy:
✅ **The entire game engine is running!**

You're ready to:
1. Test more features
2. Balance the game
3. Add more UI content
4. Play-test with friends

---

**Questions?** Check:
- COMPLETION_STATUS.md for detailed info
- START_HERE.md for quick reference
- MASTER_PROMPT.md for full design context

**Let's play!** 🎮👻
