<!--
  Ghost Catcher Tycoon - Setup Guide
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Setup Guide

## Prerequisites

- **Roblox Studio** (free) - [Download](https://www.roblox.com/studio)
- **Git** - [Download](https://git-scm.com/)
- **GitHub Account** - For version control
- **VS Code** (optional but recommended)

## Getting Started

### 1. Clone the Repository

```bash
cd "New projects/roblox-games"
git clone https://github.com/nobody174/roblox-games.git
cd roblox-games/games/ghost-catcher-tycoon
```

### 2. Open in Roblox Studio

1. Open Roblox Studio
2. Click **File → Open**
3. Navigate to `games/ghost-catcher-tycoon/place.rbxl`
4. Click "Open"

### 3. Project Structure Overview

```
ghost-catcher-tycoon/
├── src/
│   ├── client/              # Client-side gameplay
│   ├── server/              # Server-side logic
│   └── shared/              # Shared utilities
├── tests/                   # Test files
├── docs/                    # Documentation
└── place.rbxl              # Game file
```

## Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/vacuum-mechanic
   ```

2. **Open in Roblox Studio**
   - Edit Lua scripts
   - Test in play mode
   - Iterate quickly

3. **Test your changes**
   - Run the game locally
   - Check console for errors
   - Test edge cases

4. **Commit your work**
   ```bash
   git add .
   git commit -m "Add: vacuum charging mechanic"
   git push origin feature/vacuum-mechanic
   ```

5. **Create Pull Request**
   - Go to GitHub
   - Describe your changes
   - Wait for review

### Testing Checklist

Before committing, verify:
- [ ] No console errors
- [ ] Core loop works (catch → home → train → upgrade)
- [ ] Data saves/loads correctly
- [ ] UI is responsive
- [ ] Performance is acceptable

## Roblox Studio Tips

### Script Locations

In Roblox Studio:
- **ServerScriptService** → Server scripts
- **StarterPlayer** → Client scripts (runs on player join)
- **ReplicatedStorage** → Shared modules & assets

### Testing in Studio

1. Click **Play** to start the game
2. Use the **Output** console to see errors
3. Use **Command Bar** to test functions:
   ```lua
   game.Players.LocalPlayer:WaitForDataLoaded() -- Wait for data
   ```

4. Click **Stop** to end testing

### Common Issues

**"Module not found"**
- Check the path in `require()`
- Ensure module is in correct location

**"Cannot save data"**
- DataStore might be disabled in Studio
- Check in **File → Game Settings → Enable Studio Access to API Services**

**"UI not showing"**
- Check ScreenGui parent is correct
- Verify GUI is visible (not transparent or off-screen)

## Running Tests

### Unit Tests (Future)

```bash
# Tests will run via GitHub Actions
# To run locally, you'll need TestEZ module
```

### Manual Testing

1. **Test Catching**
   - Click vacuum 10 times
   - Try to catch ghosts
   - Verify success/failure rates

2. **Test Data Saving**
   - Catch a ghost
   - Close the game
   - Reopen → Ghost should still be there

3. **Test Upgrades**
   - Earn energy
   - Buy an upgrade
   - Verify it works (more storage, faster production)

4. **Test with Live Players**
   - Invite testers to your game
   - Gather feedback
   - Report bugs as GitHub issues

## Development Environment

### Folder Structure in Studio

**ServerScriptService**
```
MainServer (main server startup)
DataManager (handles save/load)
Systems/
  ├── CurrencySystem
  ├── GhostSystem
  ├── VacuumSystem
  └── HQSystem
```

**ReplicatedStorage**
```
Modules/
  ├── Config (game constants)
  ├── Enums (game enumerations)
  └── Utils/
      ├── TableUtils
      └── NumberUtils
```

**StarterPlayer > StarterCharacterScripts**
```
(Character-specific scripts)
```

**StarterPlayer > StarterPlayerScripts**
```
UIManager (handles all UI)
InputManager (handles clicks/input)
GameClient (main client code)
```

## Debugging

### Console Output

```lua
-- Print to console (visible in Output window)
print("My debug message")

-- Print with warning color
warn("This is important")

-- Print with error color
error("Something broke!")
```

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `attempt to index nil value` | Variable is nil | Check initialization |
| `connection already bound` | Event connected twice | Disconnect first or check flow |
| `infinite yield` | WaitForChild timeout | Check folder structure |
| `attempt to call nil` | Function doesn't exist | Check require path |

## Version Control Tips

### Before Pushing

1. **Check git status**
   ```bash
   git status
   ```

2. **Review your changes**
   ```bash
   git diff
   ```

3. **Commit in logical chunks**
   ```bash
   git add src/server/VacuumSystem.lua
   git commit -m "Add: basic vacuum charging"
   ```

### Useful Git Commands

```bash
# See commit history
git log --oneline

# See changes since last commit
git diff HEAD

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Revert to last commit (discard changes)
git checkout -- file.lua
```

## Performance Considerations

### Optimization Tips

1. **Avoid infinite loops** - Use wait() statements
2. **Disconnect events** when done with them
3. **Unload UI** that's not visible
4. **Batch DataStore calls** - Don't save every frame
5. **Use coroutines** for long operations

### Monitoring Performance

In Roblox Studio:
- **Debug → Profiler** → See CPU usage
- **Debug → Performance Stats** → Monitor FPS

## Next Steps

1. Read [GAMEPLAY.md](GAMEPLAY.md) for game mechanics
2. Check [SYSTEMS.md](SYSTEMS.md) for architecture
3. Start coding with Phase 1 systems
4. Test frequently with studio play mode

## Troubleshooting

**Game won't load**
- Check console for errors
- Verify all modules are in correct location
- Try reopening place.rbxl

**Data not saving**
- Enable studio API access (see above)
- Check DataStore keys are unique
- Look for errors in console

**UI not working**
- Verify GUI hierarchy in Explorer
- Check ScreenGui is child of PlayerGui
- Test visibility and position

## Need Help?

- Check console output first
- Review similar code in existing systems
- Ask in comments with specific error
- Check Roblox API docs: https://developer.roblox.com

---

**Happy coding!** 🎮👻

Built with assistance from Claude Code by Anthropic
