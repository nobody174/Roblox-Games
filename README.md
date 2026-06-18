# Roblox Games Hub

A collection of Roblox games developed as personal projects. This repository serves as a central hub for all Roblox game developments.

**⚠️ Status:** All games under development (uncompleted)

## Games

### 1. Ghost Catcher Tycoon
A fun tycoon/simulator hybrid where players catch ghosts, manage their HQ, and climb the ranks!

**Status:** 🚧 In Development  
**Genre:** Tycoon/Simulator  
**Players:** Single-player (with leaderboards)  
**Documentation:** [Ghost Catcher Tycoon README](games/ghost-catcher-tycoon/README.md)

**Core Loop:**
- Click to charge vacuum
- Catch ghosts in different zones
- Bring home and train ghosts
- Upgrade HQ
- Expand to new zones
- Collect rare ghosts

**Key Features:**
- ✅ Click-based vacuum charging
- ✅ Ghost catching with difficulty/rarity
- ✅ Passive energy generation
- ✅ Ghost training system
- ✅ HQ room upgrades (tycoon mechanics)
- ✅ Auto-catch/Auto-train systems
- ✅ Zone progression
- ✅ Boss ghost battles
- ✅ Ghost rarity system (Common, Uncommon, Rare, Legendary)

## Project Structure

```
Roblox-Games/
├── README.md (this file - Hub overview)
├── games/
│   ├── ghost-catcher-tycoon/
│   │   ├── README.md (Game-specific documentation)
│   │   ├── src/
│   │   │   ├── client/
│   │   │   ├── server/
│   │   │   └── shared/
│   │   ├── tests/
│   │   ├── docs/
│   │   ├── place.rbxl (Roblox game file)
│   │   └── ...
│   │
│   └── [more games will be added here]
│
├── .github/workflows/ (CI/CD)
└── LICENSE
```

## Getting Started

For detailed setup and testing instructions for a specific game, see the game's individual README:
- [Ghost Catcher Tycoon Setup](games/ghost-catcher-tycoon/docs/SETUP.md)

## Development

Each game is contained in its own folder under `games/`. To add a new game:
1. Create a new folder: `games/[game-name]/`
2. Add game files and documentation
3. Create a README specific to that game
4. Update this hub README with game information

## Testing

Each game has its own test suite. See individual game documentation for testing procedures.

## License

All code in this repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Author

**Developer:** nobody174  
**Email:** nobodylearn174@gmail.com  
**Created:** 2026

## Important Note

⚠️ **All games in this repository are currently under development and are not completed.** They are shared for:
- Development progress tracking
- Community feedback and testing
- Portfolio purposes

Games may have bugs, incomplete features, or breaking changes. Use at your own risk.

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
