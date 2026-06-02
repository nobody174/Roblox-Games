<!--
  Ghost Catcher Tycoon - Start Here
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Project Setup Complete! 🎮👻

## What's Ready

✅ **Project structure created**  
✅ **Complete documentation**  
✅ **Phase 1 systems implemented:**
- Data Manager (save/load)
- Currency System (Ecto-Energy)
- Vacuum System (charging mechanics)
- Main Server (initialization & routing)

## Quick Start

### 1. Open in Roblox Studio

1. Navigate to: `New projects/roblox-games/games/ghost-catcher-tycoon/`
2. Open `place.rbxl` with Roblox Studio
3. Wait for it to load

### 2. Set Up Server Scripts

In Roblox Studio Explorer:

1. Go to **ServerScriptService**
2. Create a new **Script** (not LocalScript)
3. Copy the code from: `src/server/MainServer.lua`
4. Paste it into the new script
5. Make sure it's named something clear like "GameServer"

### 3. Set Up Shared Modules

In Roblox Studio:

1. Go to **ReplicatedStorage**
2. Create a **Folder** called "shared"
3. Create **ModuleScripts** inside:
   - `config` (copy from `src/shared/config.lua`)
   - `enums` (copy from `src/shared/enums.lua`)
   - `constants` (copy from `src/shared/constants.lua`)

### 4. Test It!

1. Click **Play** in Roblox Studio
2. Open **Output** console (View → Output)
3. You should see:
   ```
   [Ghost Catcher Tycoon] Server started
   [Ghost Catcher Tycoon] Initializing...
   [Ghost Catcher Tycoon] Remotes created
   [Ghost Catcher Tycoon] Vacuum remote setup complete
   [Ghost Catcher Tycoon] Player joined: [YourUsername]
   [Ghost Catcher Tycoon] Data loaded for [YourUsername]
   ```

If you see these messages, **the server is working!** ✅

## File Structure Overview

```
ghost-catcher-tycoon/
├── src/
│   ├── server/
│   │   ├── MainServer.lua          ← Main server script
│   │   ├── data/
│   │   │   └── DataManager.lua     ← Handles data saving/loading
│   │   └── systems/
│   │       ├── CurrencySystem.lua  ← Energy management
│   │       └── VacuumSystem.lua    ← Vacuum charging
│   └── shared/
│       ├── config.lua              ← Game settings
│       ├── enums.lua               ← Game constants
│       └── constants.lua           ← Service/path constants
├── docs/
│   ├── README.md                   ← Game overview
│   ├── GAMEPLAY.md                 ← Game rules & mechanics
│   ├── SETUP.md                    ← Detailed setup guide
│   ├── SYSTEMS.md                  ← Technical architecture
│   └── FEATURES.md                 ← Feature tracking
└── place.rbxl                      ← Game file
```

## What's Implemented

### Data Manager ✅
- Loads/saves player data from DataStore
- Handles multiple retries
- Caches player data for performance
- Methods: `loadPlayerData()`, `savePlayerData()`, `getPlayerData()`, `updatePlayerData()`

### Currency System ✅
- Add/remove energy
- Check if player can afford costs
- Validate all transactions
- Notify clients of energy changes
- Methods: `addEnergy()`, `removeEnergy()`, `getEnergy()`, `canAfford()`

### Vacuum System ✅
- Charge tracking per player
- Calculate catch probability from charge level
- Reset charge after catch
- Methods: `chargeVacuum()`, `getCharge()`, `getCatchChance()`, `resetCharge()`

### Main Server ✅
- Initialize all systems
- Create RemoteEvents for client communication
- Handle player join/leave
- Auto-save data every 30 seconds
- Route RemoteEvent calls to systems

## Next Steps (What to Build)

### Phase 1 Remaining:
1. **Ghost System** - Spawn, catch, manage ghosts
2. **Production System** - Calculate passive energy generation
3. **Client UI** - Display energy, charge bar, ghost inventory
4. **Ghost catching mechanic** - Actual catch logic

### Want to Start Building?

Ask me to create:
- **"Build the Ghost System"** - Spawning, catching, storage
- **"Create the Production System"** - Passive energy generation
- **"Build basic UI"** - Energy display, charge button, notifications
- **"Add ghost catching mechanic"** - Full catch flow

## Architecture Overview

```
Client                      Server
┌──────────┐               ┌──────────────┐
│ Player   │               │ MainServer   │
│ clicks   │──FireServer──→│ (routing)    │
│ button   │               └──────────────┘
└──────────┘                  │
                   ┌──────────┴──────────┐
                   ↓                     ↓
              ┌─────────────┐   ┌──────────────┐
              │ Systems:    │   │ Data Manager │
              │ Vacuum      │   │ (persistence)│
              │ Currency    │   └──────────────┘
              │ Ghost       │
              │ Production  │
              └─────────────┘
                   │
            ┌──────┴──────┐
            ↓             ↓
         ┌─────┐    ┌──────────┐
         │ UI  │    │DataStore │
         └─────┘    └──────────┘
```

## Key Concepts

### Server Authority
Everything happens on the server. Client sends requests, server validates and executes.

### RemoteEvents
Communication between client and server:
- `ChargeVacuum` - Player clicks vacuum
- `CatchGhost` - Player attempts to catch
- `UpdateUI` - Server tells client to update display

### Data Flow
1. Player action (click)
2. Client fires RemoteEvent
3. Server processes (validate → execute)
4. Server updates player data
5. Server sends result back to client
6. Client updates UI

## Debugging Tips

**Check console output:**
- Open Output window in Roblox Studio
- Look for `[Ghost Catcher Tycoon]` messages
- Errors will show in red

**Test data saving:**
- In Studio command bar: `print(game.Players.LocalPlayer.UserId)`
- Check DataStore Studio API access is enabled

**Monitor network:**
- Look for FireServer/FireClient calls
- Check RemoteEvent names match Constants

## Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| "Module not found" error | Check require() path and folder structure |
| RemoteEvents not working | Ensure they're created in ReplicatedStorage.Remotes |
| Data not saving | Enable DataStore in Game Settings |
| Scripts not running | Check they're placed in correct service |
| Compile errors | Check Lua syntax (missing commas, brackets) |

## Ready to Code?

You have a solid foundation! The Phase 1 foundation is complete with:
- ✅ Clean modular architecture
- ✅ Data persistence working
- ✅ Core systems initialized
- ✅ RemoteEvent routing ready

**Next recommended task:**
Build the Ghost System and Ghost catching mechanic. This will complete the core gameplay loop (click → catch → earn energy).

---

**Questions?** Check:
- [SETUP.md](docs/SETUP.md) for detailed setup
- [SYSTEMS.md](docs/SYSTEMS.md) for architecture
- [GAMEPLAY.md](docs/GAMEPLAY.md) for game rules

Built with assistance from Claude Code by Anthropic
