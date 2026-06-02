# Contributing to Ghost Catcher Tycoon

## Development Setup

1. Clone the repository
2. All Lua code goes in `src/` directory
3. Tests go in `tests/` directory

## Code Standards

### Naming Conventions
- Variables: `camelCase` → `playerSpeed`, `energyAmount`
- Functions: `camelCase` → `getPlayerEnergy()`, `addGhost()`
- Modules: `PascalCase` → `DataManager`, `GhostSystem`
- Constants: `SCREAMING_SNAKE_CASE` → `MAX_PLAYERS`, `BASE_ENERGY`

### Formatting
- Indentation: 2 spaces (not tabs)
- Comments: Only "WHY", not "WHAT"
- Single responsibility principle per function
- Validate inputs, not outputs

## Testing

Run tests before pushing:
```bash
lua tests/GhostSystemTests.lua
lua tests/ProductionSystemTests.lua
lua tests/HQSystemTests.lua
```

All tests must pass before merge.

## File Headers

Every Lua file must start with:
```lua
--[=[
  Ghost Catcher Tycoon - [Component Name]
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]
```

## Pull Request Process

1. Create feature branch: `git checkout -b feature/your-feature`
2. Write tests for new code
3. Run full test suite
4. Commit with clear messages
5. Push and create PR with description

## Commit Message Format

```
<type>: <description>

<body (optional)>
```

Types: feat, fix, test, docs, refactor, chore

Example:
```
feat: Add ghost personality system

Implements personality attributes for ghosts with stat bonuses:
- Shy: +20% energy, harder to catch
- Angry: +30% catch speed
- Playful: Random boosts
```

## Questions?

Check the MASTER_PROMPT.md for project context and architecture.
