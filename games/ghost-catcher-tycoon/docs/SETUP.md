<!--
  Ghost Catcher Tycoon - Setup Guide
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Setup & Development Guide

**Last Updated**: June 18, 2026

---

## 📋 Prerequisites

- **Roblox Studio** (free) - [Download](https://www.roblox.com/studio)
- **Git** (optional, for version control) - [Download](https://git-scm.com/)
- **GitHub Account** (optional, for contribution)
- **VS Code** (optional, for code editing)
- **2GB RAM minimum** (for Roblox Studio)

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/nobody174/roblox-games.git
cd roblox-games/games/ghost-catcher-tycoon
```

Or download as ZIP and extract.

### 2. Open in Roblox Studio

1. Open **Roblox Studio**
2. Click **File → Open Place**
3. Navigate to: `games/ghost-catcher-tycoon/place.rbxl`
4. Click **Open**

### 3. Wait for Scripts to Load

- First startup may take 30-60 seconds
- Check the **Output** window (View → Output) for status
- You should see: `[PHASE 4] ✅ Phase 4 extended testing server ready!`

### 4. Test the Game

1. Click **Play** (top toolbar)
2. You should spawn in the **Hub** (starting area)
3. Try the basic commands:
   - Click **CHARGE** button to charge vacuum
   - Click **CATCH** to catch nearby ghosts
   - Move around with WASD
   - Press **F** to toggle flight mode (for testing)

---

## 📁 Project Structure

```
ghost-catcher-tycoon/
├── src/
│   ├── client/
│   │   ├── GameClient.lua           # Main client controller
│   │   ├── ChargeIndicator.lua      # UI for vacuum charge
│   │   ├── CatchFeedback.lua        # Catch result messages
│   │   ├── GhostInfoPanel.lua       # Ghost info display
│   │   ├── EquipmentSlotUI.lua      # Equipment UI
│   │   ├── AdminChat.lua            # Admin console
│   │   └── modules/
│   │       ├── GhostCardBuilder.lua # Ghost card rendering
│   │       ├── HabitatUI.lua        # HQ room UI
│   │       └── ChatUI.lua           # Chat system
│   ├── server/
│   │   ├── MainServer_Phase4_Extended.lua  # Entry point
│   │   ├── SystemManager.lua        # System orchestration
│   │   ├── PhaseManager.lua         # Private Home islands
│   │   ├── ZoneManager.lua          # Zone detection
│   │   ├── GhostSpawner.lua         # Ghost spawning
│   │   ├── systems/                 # 22 core systems
│   │   ├── data/
│   │   │   └── DataManager.lua      # Data fallback
│   │   └── Tests/                   # Test suites
│   └── shared/
│       ├── GhostData.lua            # 120 ghosts + asset IDs
│       ├── ZoneData.lua             # 11 zones + spawn pools
│       ├── EquipmentData.lua        # Equipment catalog
│       ├── BossData.lua             # Boss specs
│       ├── EggData.lua              # Egg types
│       ├── constants.lua            # Game constants
│       ├── config.lua               # Settings
│       └── enums.lua                # Enumerations
├── docs/
│   ├── GAMEPLAY.md                  # How to play
│   ├── SYSTEMS.md                   # Technical architecture
│   ├── FEATURES.md                  # Feature tracking
│   ├── WORLD_MAP.md                 # Zone layout
│   ├── WORLD_STRUCTURE_GUIDE.md     # World building
│   ├── PROGRESSION_SYSTEMS.md       # Player progression
│   ├── EQUIPMENT_REFERENCE.md       # Equipment details
│   └── (other docs)
├── README.md                        # Main overview
├── CHANGELOG.md                     # Version history
├── place.rbxl                       # Roblox Studio file
└── .gitignore
```

---

## 🛠️ Development Workflow

### Making Code Changes

1. **Create a feature branch** (optional):
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Open the game in Roblox Studio**
   - Edit Lua scripts in the **Explorer** panel
   - Studio auto-saves as you type

3. **Test your changes**
   - Click **Play** to run the game
   - Check **Output** window for errors
   - Test the feature thoroughly

4. **Commit your work** (if using Git):
   ```bash
   git add .
   git commit -m "Describe your changes here"
   git push origin feature/my-feature
   ```

5. **Create Pull Request** (optional):
   - Go to GitHub
   - Describe your changes
   - Submit for review

### Testing Commands (In-Game)

While playing, use these admin commands in chat:

```
/coin         - Add 1000 coins
/energy       - Add 1000 energy
/ghost [name] - Spawn ghost in your inventory
/spawnworld [name] - Spawn ghost visible in world (to see its image)
/help         - List all admin commands
```

**Example**: `/coin` adds 1000 coins for quick testing

---

## 🐛 Debugging

### Checking Logs

1. Open **Output** window: **View → Output**
2. Look for error messages (red text)
3. Check for warnings (yellow text)

### Common Issues

| Issue | Fix |
|-------|-----|
| Scripts don't load | Wait 60+ seconds, check Output |
| Ghosts not spawning | Check if you're in Hub (they only spawn in exploration zones) |
| Images show as nil | Admin `/spawnworld [ghostname]` to test image rendering |
| Game crashes on startup | Delete place.rbxl, re-download from GitHub |

### Opening Script Files

1. Click **Explorer** (View → Explorer if hidden)
2. Navigate: **Workspace → GhostCatcher → Systems → [script name]**
3. Double-click to edit

---

## 🎮 Testing Checklist

### Core Loop
- [ ] Click CHARGE button (should increase bar)
- [ ] Catch a ghost (charge > 0, click CATCH)
- [ ] See "Ghost caught!" message
- [ ] Ghost appears in inventory

### Progression
- [ ] Earn coins from catching ghosts
- [ ] Unlock a new zone (costs coins)
- [ ] Upgrade a room (costs coins)
- [ ] Train a ghost (costs energy)

### Advanced
- [ ] Ghosts spawn in all zones except Hub
- [ ] Auto-catch works (if purchased)
- [ ] Prestige system works
- [ ] Leaderboard updates

### UI
- [ ] Coins/energy/level display updates
- [ ] Ghost card shows correct info
- [ ] Zone list shows unlocked zones
- [ ] No console errors

---

## 📚 Reading the Code

### Key Entry Points

**Server-side**:
- `MainServer_Phase4_Extended.lua` - Start here, orchestrates all systems

**Client-side**:
- `GameClient.lua` - UI and input handling

**Data**:
- `GhostData.lua` - All 120 ghosts
- `ZoneData.lua` - 11 zones with spawn pools

**Systems**:
- `systems/SystemManager.lua` - Manages 22 game systems
- `systems/GhostSpawner.lua` - Spawns ghosts every 3 seconds

### Code Style

- **Lua 5.1** (Roblox standard)
- **PascalCase** for class names, **camelCase** for functions
- **No external dependencies** (pure Roblox)
- Comments only for non-obvious logic

---

## 🤝 Contributing

1. **Read** [GAMEPLAY.md](GAMEPLAY.md) to understand the game
2. **Read** [SYSTEMS.md](SYSTEMS.md) to understand architecture
3. **Make your changes** in Roblox Studio
4. **Test thoroughly** before committing
5. **Write clear commit messages** explaining the why
6. **Create a pull request** on GitHub

---

## 📞 Getting Help

- Check **Output** window for error messages
- Read [GAMEPLAY.md](GAMEPLAY.md) for game mechanics
- Read [SYSTEMS.md](SYSTEMS.md) for technical details
- Open an issue on GitHub

---

**Status**: Ready for public testing  
**Current Build**: Phase 4 Extended (June 18, 2026)  
**Test Server**: Local Roblox Studio

Last Updated: June 18, 2026
