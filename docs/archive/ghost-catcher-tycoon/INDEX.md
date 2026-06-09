<!--
  Ghost Catcher Tycoon - Complete Index
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Complete Index

## 🚀 START HERE

**New to the project?**
1. Read [START_HERE.md](START_HERE.md) - Quick start guide (5 min)
2. Skim [MASTER_PROMPT.md](MASTER_PROMPT.md) - Full project context (10 min)
3. Open in Roblox Studio and test (5 min)

**Ready to code?**
- Copy [MASTER_PROMPT.md](MASTER_PROMPT.md) into Claude Code
- Ask: "Build the Ghost System" or "Implement Production System"

---

## 📚 Documentation Index

### Game Design
- **[MASTER_PROMPT.md](MASTER_PROMPT.md)** - Complete project context for Claude Code
  - Game overview, design philosophy, monetization, technical architecture
  - Paste this into Claude Code for full context

- **[GAMEPLAY.md](docs/GAMEPLAY.md)** - Game rules & mechanics
  - Vacuum charging, ghost catching, training, HQ system
  - Zone progression, boss ghosts, monetization details
  - Balance notes and FAQ

### Technical Documentation
- **[SYSTEMS.md](docs/SYSTEMS.md)** - Technical architecture deep-dive
  - System overview, core systems, communication patterns
  - Initialization flow, game loop, security principles
  - Debugging tips

- **[FEATURES.md](docs/FEATURES.md)** - Feature tracking checklist
  - All 8 phases with status
  - Feature breakdown by system
  - Quality assurance checklist

### Project Status
- **[README.md](README.md)** - Game overview & features
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Implementation status (Phase 1 = 100%)
- **[START_HERE.md](START_HERE.md)** - Quick start guide

### Setup & Contributing
- **[SETUP.md](docs/SETUP.md)** - How to open in Studio and develop
- **[CONTRIBUTING.md](../docs/CONTRIBUTING.md)** - Git workflow & code standards

---

## 💻 Code Structure

### Server Systems (in `src/server/`)

**[MainServer.lua](src/server/MainServer.lua)**
- Initializes all systems
- Creates RemoteEvents
- Handles player join/leave
- Runs auto-save loop
- ~120 lines

**Data Persistence**
- **[DataManager.lua](src/server/data/DataManager.lua)** (~170 lines)
  - Load player data from DataStore
  - Save player data (with retry logic)
  - Cache management
  - Energy add/remove operations

**Core Systems**
- **[CurrencySystem.lua](src/server/systems/CurrencySystem.lua)** (~90 lines)
  - Add/remove energy
  - Affordability checks
  - Client notification
  
- **[VacuumSystem.lua](src/server/systems/VacuumSystem.lua)** (~85 lines)
  - Track vacuum charge per player
  - Calculate catch probability
  - Reset charge mechanism

### Shared Configuration (in `src/shared/`)

- **[config.lua](src/shared/config.lua)** - All game settings
  - Vacuum mechanics, ghost rarities, zones, rooms
  - GamePass/product definitions
  - Training costs, security limits
  - ~180 lines of configuration

- **[enums.lua](src/shared/enums.lua)** - Game enumerations
  - Rarities, zones, rooms, events
  - Request/response types
  - ~80 lines

- **[constants.lua](src/shared/constants.lua)** - Service/path constants
  - Service shortcuts
  - RemoteEvent names
  - DataStore names
  - ~70 lines

### Game File
- **[place.rbxl](place.rbxl)** - The actual Roblox game file

---

## 🎮 Game Systems Overview

### Implemented ✅
1. **DataManager** - Save/load player data
2. **CurrencySystem** - Energy tracking
3. **VacuumSystem** - Vacuum charging
4. **MainServer** - Initialization & routing
5. **Configuration** - All game settings
6. **Enumerations** - Game constants

### Next to Build (in order)
1. **GhostSystem** - Spawn, catch, store ghosts
2. **ProductionSystem** - Calculate passive income
3. **Client UI** - Energy display, buttons
4. **HQSystem** - Room upgrades
5. **TrainingSystem** - Ghost leveling
6. **ZoneSystem** - Zone unlocks
7. **MonetizationSystem** - Gamepasses/products
8. **AutoSystems** - Auto-catch/train

---

## 🔄 Development Workflow

### To Add New Code

1. **Identify the phase/system** (see [FEATURES.md](docs/FEATURES.md))
2. **Copy MASTER_PROMPT into Claude Code** (full context)
3. **Ask for specific task:** "Build the Ghost System" or "Implement Production"
4. **Receive:** Complete code, structure, explanations, tests
5. **Place code** in proper folder structure
6. **Test in Roblox Studio** (click Play, check Output console)
7. **Verify** with test checklist in [SETUP.md](docs/SETUP.md)

### To Balance Game

1. **Open [config.lua](src/shared/config.lua)**
2. **Change numbers** (energy costs, spawn rates, etc.)
3. **No code changes needed**
4. **Test in Studio** to see new balance

### To Debug

1. **Open Output console** in Roblox Studio (View → Output)
2. **Look for error messages** or warnings
3. **Check [SETUP.md](docs/SETUP.md)** troubleshooting section
4. **Use print() statements** to trace code flow

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Files Created | 12 |
| Server Code | 465 lines |
| Shared Code | 330 lines |
| Documentation | 3,000+ lines |
| Systems Implemented | 3/8 |
| Phase 1 Completion | 100% ✅ |
| Playable Yet | No (need GhostSystem + UI) |

---

## 🎯 Quick Links

**For Game Designers:**
- [GAMEPLAY.md](docs/GAMEPLAY.md) - Game mechanics
- [MASTER_PROMPT.md](MASTER_PROMPT.md) - Design philosophy

**For Developers:**
- [SYSTEMS.md](docs/SYSTEMS.md) - Architecture
- [MASTER_PROMPT.md](MASTER_PROMPT.md) - Technical context

**For Balancing:**
- [config.lua](src/shared/config.lua) - All numbers
- [GAMEPLAY.md](docs/GAMEPLAY.md) - Balance notes

**For Testing:**
- [SETUP.md](docs/SETUP.md) - How to test
- [FEATURES.md](docs/FEATURES.md) - Test checklist

**For Contributing:**
- [MASTER_PROMPT.md](MASTER_PROMPT.md) - Full context
- [../docs/CONTRIBUTING.md](../docs/CONTRIBUTING.md) - Workflow

---

## 🚦 Project Phases

**Phase 1: Core Systems** ✅ COMPLETE
- Data, Currency, Vacuum, Server

**Phase 2: Ghost System & Gameplay**
- Ghost spawning, catching, storage, UI

**Phase 3: Production & HQ**
- Passive income, room upgrades, multipliers

**Phase 4: Training & Progression**
- Ghost leveling, stat progression

**Phase 5: Zones & Content**
- Zone unlocks, boss fights

**Phase 6: Auto Systems & QoL**
- Auto-catch, auto-train, notifications

**Phase 7: Monetization**
- GamePass detection, products

**Phase 8: Polish**
- Animations, effects, sound, balance

---

## 💡 Key Concepts

### Compulsion Loop
```
Click → Catch → Earn → Build → Unlock → [REPEAT]
```

### Server-Authoritative
- All logic on server
- Client sends requests only
- Server validates everything
- Security-first design

### Configuration-Driven
- Change game balance without code
- All numbers in config.lua
- Easy tuning for monetization

### Modular Systems
- Each system independent
- Clear interfaces (public methods)
- Easy to test and debug
- Easy to extend

---

## ❓ FAQ

**Q: Where do I start coding?**
A: Copy [MASTER_PROMPT.md](MASTER_PROMPT.md) into Claude Code, ask to "Build the Ghost System"

**Q: How do I test the game?**
A: See [SETUP.md](docs/SETUP.md) - Open place.rbxl in Studio, click Play

**Q: How do I balance the game?**
A: Edit [config.lua](src/shared/config.lua) - Change numbers, test

**Q: Is the game playable yet?**
A: Not fully. Phase 1 is foundation. Need Ghost System + UI to play.

**Q: How do I add a new system?**
A: See [SYSTEMS.md](docs/SYSTEMS.md) - Create module in systems/, implement public API, register in MainServer

**Q: Where are the assets?**
A: Placeholder mode. Just code, no 3D models/particles yet. Will add in Phase 8 (Polish)

---

## 🎓 Learning Resources

**Understanding the Game Loop:**
- Read [GAMEPLAY.md](docs/GAMEPLAY.md) sections on "Main Loop" and "Game Flow"

**Understanding the Code:**
- Start with [START_HERE.md](START_HERE.md)
- Deep dive: [SYSTEMS.md](docs/SYSTEMS.md)

**Roblox Lua:**
- [Roblox API Docs](https://developer.roblox.com)
- [Roblox Lua Learning Guide](https://developer.roblox.com/en-us/articles/Using-Lua-in-Roblox)

**Game Design:**
- [MASTER_PROMPT.md](MASTER_PROMPT.md) - Design philosophy section
- [GAMEPLAY.md](docs/GAMEPLAY.md) - Monetization details

---

## 📞 Getting Help

**Code Help:**
- Copy [MASTER_PROMPT.md](MASTER_PROMPT.md) into Claude Code
- Ask specific question + what you're building

**Design Help:**
- Read [MASTER_PROMPT.md](MASTER_PROMPT.md) design philosophy
- Check [GAMEPLAY.md](docs/GAMEPLAY.md) mechanics

**Setup Help:**
- See [SETUP.md](docs/SETUP.md)

**Debugging Help:**
- See [SETUP.md](docs/SETUP.md) troubleshooting section
- Check [SYSTEMS.md](docs/SYSTEMS.md) debugging tips

---

## ✅ Checklist for First Development Session

- [ ] Read START_HERE.md (5 min)
- [ ] Skim MASTER_PROMPT.md (10 min)
- [ ] Open place.rbxl in Roblox Studio
- [ ] Set up server scripts (see SETUP.md)
- [ ] Click Play and verify server starts (check Output)
- [ ] See success messages in console
- [ ] Decide: What to build next?
  - [ ] Ghost System (recommend)
  - [ ] Production System
  - [ ] Basic UI
  - [ ] HQ System

---

## 🎉 You're Ready!

You have:
- ✅ Complete game design
- ✅ Working foundation
- ✅ Clear architecture
- ✅ Full documentation
- ✅ Master prompt for Claude Code

**Next step:** Ask Claude Code to build the next phase.

**Recommended:** "Build the Ghost System - implement spawning, catching, and ghost storage."

---

**Status:** Phase 1 Complete ✅ | Ready for Phase 2 Development 🚀

Built with assistance from Claude Code by Anthropic
