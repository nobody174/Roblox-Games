<!--
  Ghost Catcher Tycoon
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/Roblox-Games
  Sub-path: games/ghost-catcher-tycoon/
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon

A fun tycoon/simulator hybrid where players catch ghosts, manage their HQ, train their collection, and climb the leaderboards!

## Game Overview

**Genre**: Tycoon/Simulator  
**Players**: Single-player with multiplayer leaderboards  
**Core Loop**: Click to charge → Catch ghosts → Bring home → Train → Upgrade HQ → Repeat

### What Players Do

1. **Catch Ghosts** - Charge vacuum by clicking, catch ghosts across 11+ exploration zones
2. **Bring Home** - Transport ghosts back to HQ for passive energy production
3. **Train Ghosts** - Level up caught ghosts to improve stats and catch rates
4. **Upgrade HQ** - Build rooms and facilities to increase capacity and production
5. **Expand** - Unlock new zones and challenge increasingly difficult boss ghosts
6. **Collect** - Hunt for rare ghosts (120 unique ghosts across 6 rarity tiers)
7. **Compete** - Climb leaderboards, prestige to reset, and dominate PvP battles

## Game Features

### ✅ Core Mechanics (Fully Implemented)
- **Click-based Vacuum** - Charge by clicking, deplete by catching
- **Ghost Catching** - Rarity-based success rates (Common 80% → Corrupted 10%)
- **120 Unique Ghosts** - 6 rarity tiers with custom artwork & personalities
- **Passive Energy** - Caught ghosts generate energy per second (scales with rarity & level)
- **Ghost Training** - Level up caught ghosts (1-10) to boost stats
- **HQ Room Upgrades** - 5 upgradeable rooms (Ghost Chamber, Training Facility, Energy Reactor, Research Lab, Boss Arena)
- **Zone Progression** - Unlock zones by level or cost
- **Boss Encounters** - Special boss ghosts with higher rewards
- **Auto Systems** - Auto-catch and auto-train background features
- **Equipment System** - Gear to boost catch rates (rarity-specific)
- **Gacha/Egg Hatching** - Pull random ghosts from eggs (5 egg types)

### ✅ Advanced Systems (Fully Implemented)
- **Player Leveling** - XP-based progression with skill tree
- **Leaderboard** - Real-time player rankings
- **Quest System** - In-game quests with rewards
- **PvP Battles** - Player vs player ghost battles
- **Prestige** - Reset progression for prestige points
- **Data Persistence** - Auto-save to DataStore
- **Monetization** - GamePass & Developer Product integration
- **Admin Commands** - `/coin`, `/energy`, `/ghost`, `/spawnworld` for testing

### 🎨 World Design
- **11 Exploration Zones** - Themed islands from Whisper Woods to Eternity Nexus
- **1 Hub Island** - Central starting area (public)
- **1 Home Island** - Per-player private HQ (cloned per player)
- **5 Boss Platforms** - Boss encounter locations
- **Portals & Bridges** - Zone connections and navigation

## Project Status

**Overall Completion**: ~65%  
**Last Updated**: June 18, 2026

### ✅ Complete (22/22 Systems)
All core systems are implemented and integrated:
- SystemManager, CurrencySystem, VacuumSystem, GhostSystem
- GhostSpawner, GhostService, ProductionSystem, HQSystem
- TrainingSystem, ZoneSystem, LevelSystem, SkillTree
- QuestSystem, LeaderboardSystem, GachaSystem, EggSystem
- AutoCatchSystem, AutoTrainSystem, BossSystem, PvPSystem
- PrestigeSystem, EventSystem, CosmeticsSystem, MonetizationSystem

### ⏳ In Progress (Testing & Polish)
- Ghost image rendering on cards (120 images uploaded)
- End-to-end catch system testing
- Home island template & cloning
- Zone unlock progression testing
- Ghost training verification
- Equipment system testing
- Boss battle mechanics
- PvP battle system
- Auto-catch/auto-train background tasks
- Sound effects & animations
- UI polish & balance tuning

### 📈 Remaining Work
- **Critical**: 5-10 hours (testing, catch system, Home islands, ghost images)
- **Polish**: 8-10 hours (SFX, animations, UI, balance)
- **Estimated Total**: ~65% complete, ~11-19 hours remaining

## Project Structure

```
ghost-catcher-tycoon/
├── src/
│   ├── client/                      # Client-side UI & input
│   │   ├── GameClient.lua           # Main client controller
│   │   ├── ChargeIndicator.lua      # Vacuum charge display
│   │   ├── CatchFeedback.lua        # Catch success/failure messages
│   │   ├── GhostInfoPanel.lua       # Ghost stats panel
│   │   ├── EquipmentSlotUI.lua      # Equipment UI
│   │   ├── AdminChat.lua            # Admin console
│   │   └── modules/                 # UI builders
│   │       ├── GhostCardBuilder.lua # Ghost card display
│   │       ├── HabitatUI.lua        # HQ room view
│   │       └── ChatUI.lua           # Chat system
│   ├── server/                      # Server logic & systems
│   │   ├── MainServer_Phase4_Extended.lua  # Main entry point
│   │   ├── SystemManager.lua        # Orchestrates all systems
│   │   ├── PhaseManager.lua         # Private Home island management
│   │   ├── ZoneManager.lua          # Zone detection & barriers
│   │   ├── GhostSpawner.lua         # Ghost spawning (3s intervals)
│   │   ├── CatchingSystem.lua       # Catch mechanics & equipment
│   │   ├── PlayerInventory.lua      # Inventory management
│   │   ├── QuestManager.lua         # Quest tracking
│   │   ├── DataPersistence.lua      # Auto-save system
│   │   ├── systems/                 # 22 core systems
│   │   │   ├── CurrencySystem.lua
│   │   │   ├── GhostSystem.lua
│   │   │   ├── ProductionSystem.lua
│   │   │   ├── HQSystem.lua
│   │   │   ├── TrainingSystem.lua
│   │   │   ├── LevelSystem.lua
│   │   │   ├── SkillTree.lua
│   │   │   ├── LeaderboardSystem.lua
│   │   │   ├── GachaSystem.lua
│   │   │   ├── EggSystem.lua
│   │   │   ├── AutoCatchSystem.lua
│   │   │   ├── AutoTrainSystem.lua
│   │   │   ├── BossSystem.lua
│   │   │   ├── PvPSystem.lua
│   │   │   ├── PrestigeSystem.lua
│   │   │   ├── EventSystem.lua
│   │   │   ├── CosmeticsSystem.lua
│   │   │   ├── MonetizationSystem.lua
│   │   │   └── (+ 4 more utility systems)
│   │   └── data/
│   │       └── DataManager.lua      # Fallback in-memory storage
│   └── shared/                      # Shared data & config
│       ├── GhostData.lua            # 120 ghosts with asset IDs
│       ├── ZoneData.lua             # 11 zones + spawn pools
│       ├── EquipmentData.lua        # Equipment catalog
│       ├── BossData.lua             # Boss specs
│       ├── EggData.lua              # Egg types
│       ├── constants.lua            # Game constants
│       ├── config.lua               # Configurable settings
│       └── enums.lua                # Game enumerations
├── docs/
│   ├── WORLD_MAP.md                 # World layout & zones
│   ├── WORLD_STRUCTURE_GUIDE.md     # World architecture
│   ├── PROGRESSION_SYSTEMS.md       # Player progression mechanics
│   └── EQUIPMENT_REFERENCE.md       # Equipment details & tiers
├── assets/
│   └── (Game assets & artwork)
├── place.rbxl                       # Roblox Studio file
├── .gitignore
└── LICENSE
```

## Getting Started

### Prerequisites
- Roblox Studio (latest version)
- This repository cloned locally
- Roblox developer account

### Installation
1. Open `place.rbxl` in Roblox Studio
2. Wait for scripts to load
3. Click **Play** to test

### Testing
Use admin commands in-game:
- `/coin` - Add 1000 coins
- `/energy` - Add 1000 energy
- `/ghost [name]` - Spawn a ghost into inventory
- `/spawnworld [name]` - Spawn a ghost in the world to see its image

## Documentation

See the [docs/](docs/) folder for detailed guides:
- **[WORLD_MAP.md](docs/WORLD_MAP.md)** — Zone layout and world geography
- **[WORLD_STRUCTURE_GUIDE.md](docs/WORLD_STRUCTURE_GUIDE.md)** — How islands and zones are built
- **[PROGRESSION_SYSTEMS.md](docs/PROGRESSION_SYSTEMS.md)** — Player leveling, zones, and prestige
- **[EQUIPMENT_REFERENCE.md](docs/EQUIPMENT_REFERENCE.md)** — Equipment tiers and stats

## Architecture Overview

### Data Flow
1. **Player Input** → Client UI (ChargeIndicator, CatchFeedback)
2. **RemoteEvents** → Server handlers (MainServer)
3. **Systems Process** → Logic & state updates (22 systems)
4. **DataPersistence** → Auto-save to DataStore every 30s
5. **UI Update** → Client receives state via RemoteEvents

### Key Design Patterns
- **System Manager**: Centralized orchestration of all game systems
- **Phase Manager**: Private per-player Home islands (cloned on join)
- **Zone Manager**: Automatic zone detection & barrier enforcement
- **Ghost Spawner**: Continuous spawning loop (every 3 seconds per zone)
- **Data Persistence**: Auto-save + fallback in-memory storage

### Multiplayer Architecture
- **Public Zones**: Shared exploration areas (all players see same ghosts)
- **Private Home**: Per-player island (cloned instance)
- **Leaderboard**: Central ranking system
- **PvP**: Player challenge system with battle mechanics

## Known Issues & Limitations

### High Priority (Blocking Gameplay)
- [ ] Ghost images don't render on cards yet (uploaded but not displaying)
- [ ] Home island template needs creation & cloning system
- [ ] Catch system needs end-to-end testing
- [ ] Teleport to Home needs UI button

### Medium Priority (Polish)
- [ ] No sound effects yet
- [ ] Minimal particle effects
- [ ] UI animations need smoothing
- [ ] Balance tuning (catch rates, costs, rewards)

### Low Priority (Post-Launch)
- [ ] Advanced cosmetics system
- [ ] Seasonal events
- [ ] More boss types
- [ ] Guilds/cooperative features

## Contributing

This is a closed-source project. For bugs or suggestions, check the issue tracker.

## Next Steps

1. **Testing Phase**: Run through critical path tests (see TODO-LIST.md)
2. **Bug Fixes**: Address high-priority issues
3. **Content**: Add SFX, animations, visual polish
4. **Balance**: Tune catch rates, costs, rewards
5. **Release**: Deploy to Roblox

---

**Current Phase**: Testing & Iteration  
**Status**: Playable (core loop functional, needs testing)  
**Target Completion**: ~1-2 weeks  
**Last Updated**: June 18, 2026

Built with assistance from Claude Code by Anthropic
