<!--
  Ghost Catcher Tycoon
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/Roblox-Games
  Sub-path: games/ghost-catcher-tycoon/
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon

A fun tycoon/simulator hybrid where players catch ghosts, manage their HQ, and climb the ranks!

## Game Overview

**Genre**: Tycoon/Simulator  
**Players**: Single-player (with leaderboards)  
**Core Loop**: Click to charge → Catch ghosts → Bring home → Train → Upgrade HQ → Repeat

### What Players Do

1. **Catch Ghosts** - Charge vacuum by clicking, catch ghosts in different zones
2. **Bring Home** - Transport ghosts back to HQ for energy production
3. **Train Ghosts** - Improve stats to catch faster, earn more energy
4. **Upgrade HQ** - Unlock rooms and facilities for better production
5. **Expand** - Unlock new zones and fight boss ghosts
6. **Collect** - Find rare ghosts with unique personalities

## Game Features

### Core Mechanics
- ✅ Click-based vacuum charging
- ✅ Ghost catching with difficulty/rarity
- ✅ Passive energy generation
- ✅ Ghost training system
- ✅ HQ room upgrades (tycoon)
- ✅ Auto-catch/Auto-train systems
- ✅ Zone progression
- ✅ Boss ghost battles
- ✅ Ghost rarity system (Common, Uncommon, Rare, Legendary)

### Systems
- **Data System**: Persistent player data with DataStore
- **Currency**: Ecto-Energy (main currency)
- **Storage**: Ghost inventory with limits (upgradeable)
- **Monetization**: GamePasses & Developer Products

## Getting Started

See [SETUP.md](docs/SETUP.md) for installation and testing instructions.

## Project Structure

```
ghost-catcher-tycoon/
├── src/
│   ├── client/                      # Client-side scripts
│   │   ├── input/                   # Input handling (clicking, UI)
│   │   ├── ui/                      # UI windows and controllers
│   │   └── systems/                 # Client systems
│   ├── server/                      # Server-side scripts
│   │   ├── systems/                 # Core game systems
│   │   ├── events/                  # Server events
│   │   └── data/                    # DataStore management
│   └── shared/                      # Shared modules
│       ├── config.lua               # Game configuration
│       ├── enums.lua                # Game enumerations
│       ├── constants.lua            # Game constants
│       └── utils/                   # Utility modules
├── tests/
│   ├── unit/                        # Unit tests
│   └── integration/                 # Integration tests
├── docs/
│   ├── SETUP.md                     # Setup guide
│   ├── GAMEPLAY.md                  # Game rules & mechanics
│   ├── FEATURES.md                  # Feature tracking
│   ├── SYSTEMS.md                   # Technical architecture
│   └── API.md                       # Module documentation
├── place.rbxl                       # Roblox place file
└── .gitignore
```

## Development Roadmap

### Phase 1: Core Systems (Current)
- [x] Project setup
- [ ] Data system foundation
- [ ] Currency system
- [ ] Vacuum clicking
- [ ] Basic ghost catching

### Phase 2: Gameplay Loop
- [ ] Ghost storage
- [ ] Ghost training
- [ ] HQ room upgrades
- [ ] Zone progression

### Phase 3: Content & Polish
- [ ] Boss ghosts
- [ ] Auto systems
- [ ] UI refinement
- [ ] Sound effects & effects

### Phase 4: Monetization
- [ ] GamePass implementation
- [ ] Developer Product handling
- [ ] Premium features

## Testing

### Local Testing
1. Run the game in Roblox Studio
2. Use the testing commands (see SETUP.md)
3. Verify core loops work

### Community Testing
- Share with testers (family/friends)
- Collect feedback on balance
- Report bugs as GitHub issues

## Known Issues

None yet! (This is a fresh start!)

## Next Steps

1. Read [GAMEPLAY.md](docs/GAMEPLAY.md) for game flow details
2. Check [SYSTEMS.md](docs/SYSTEMS.md) for technical architecture
3. Start with Phase 1 implementation

## Questions?

See [SETUP.md](docs/SETUP.md) or check code comments for clarification.

---

**Status**: Early Development 🚀  
**Last Updated**: June 2, 2025

Built with assistance from Claude Code by Anthropic
