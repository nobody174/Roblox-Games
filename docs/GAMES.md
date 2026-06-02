<!--
  Roblox Games - Game Development Guidelines
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Game Development Guidelines

## Creating a New Game

### 1. Project Structure

```
games/[GameName]/
├── src/
│   ├── init.lua              # Main entry point
│   ├── config.lua            # Game configuration & constants
│   ├── client/               # Client-side scripts
│   │   ├── ui/
│   │   ├── input/
│   │   └── graphics/
│   ├── server/               # Server-side scripts
│   │   ├── gameplay/
│   │   ├── systems/
│   │   └── events/
│   └── shared/               # Shared modules
│       ├── utils/
│       ├── constants/
│       └── types/
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
│   ├── README.md             # Game overview
│   ├── GAMEPLAY.md           # Mechanics & rules
│   ├── API.md                # Module documentation
│   └── FEATURES.md           # Feature tracking
├── place.rbxl                # Roblox place file
└── .gitignore
```

### 2. Lua Code Standards

#### Header Format
```lua
--[=[
  Game Name - Module Name
  Author:   nobody174 (vartdal@gmail.com)
  Repo:     https://github.com/nobody174/roblox-games
  License:  All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]
```

#### Code Style
- **Naming**: `camelCase` for variables/functions, `PascalCase` for classes/modules
- **Indentation**: 2 spaces (NOT tabs)
- **Comments**: Only for WHY, not WHAT (code should be self-documenting)
- **Line Length**: Keep under 100 characters where practical

#### Example Module
```lua
--[=[
  Game Name - Player Manager
  Author:   nobody174 (vartdal@gmail.com)
]=]

local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new()
  local self = setmetatable({}, PlayerManager)
  self.players = {}
  return self
end

function PlayerManager:addPlayer(player)
  self.players[player.UserId] = player
end

return PlayerManager
```

### 3. Testing

#### Unit Tests
```lua
-- tests/unit/PlayerManager.test.lua
local TestEZ = require(path.to.TestEZ)
local PlayerManager = require(src.PlayerManager)

return function()
  describe("PlayerManager", function()
    it("should create a new instance", function()
      local manager = PlayerManager.new()
      assert(manager ~= nil)
    end)
  end)
end
```

#### Integration Tests
- Test game systems working together
- Test client/server communication
- Test with actual Roblox APIs

### 4. Configuration

Keep configuration in `config.lua`:

```lua
--[=[
  Game Name - Configuration
]=]

local Config = {
  -- Game Settings
  GameTitle = "My Awesome Game",
  Version = "1.0.0",
  
  -- Gameplay
  PlayerSpeed = 16,
  JumpPower = 50,
  Gravity = 196.2,
  
  -- Teams
  Teams = {
    { Name = "Red", Color = Color3.fromRGB(255, 0, 0) },
    { Name = "Blue", Color = Color3.fromRGB(0, 0, 255) },
  },
  
  -- Features
  Features = {
    EnableChat = true,
    EnableEmotes = true,
    EnableCustomization = false,
  },
}

return Config
```

### 5. Documentation Templates

#### README.md (Game Overview)
```markdown
# Game Name

Brief description of your game.

## Gameplay

- **Genre**: 
- **Players**: 
- **Objective**: 

## Features

- Feature 1
- Feature 2
- Feature 3

## Getting Started

[Instructions for testing the game]

## Known Issues

[List of known issues or limitations]
```

#### GAMEPLAY.md (Game Rules)
```markdown
# Game Rules & Mechanics

## Core Mechanics

### Mechanic 1
Description and how it works.

### Mechanic 2
Description and how it works.

## Winning/Losing

[Conditions for victory/defeat]

## Game Flow

[Describe the game progression]
```

#### FEATURES.md (Feature Tracking)
```markdown
# Features

## Current Release

### Feature Name
- **Description**: What it does
- **Status**: Complete
- **Notes**: Any special notes

## In Development

### Feature Name
- **Description**: What it does
- **Status**: In Progress
- **Target Version**: X.X.X

## Planned

### Feature Name
- **Purpose**: Why it's needed
- **Priority**: High/Medium/Low
```

### 6. Client/Server Architecture

#### Server Scripts (game logic)
```lua
-- Runs on Roblox servers
-- Handles: Game state, player data, validation
-- Cannot access player's UI
```

#### Client Scripts (player experience)
```lua
-- Runs on player's computer
-- Handles: UI, input, local graphics
-- Cannot modify game state directly
```

#### Communication
```lua
-- Server
local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("MyEvent")
RemoteEvent.OnServerEvent:Connect(function(player, data)
  -- Handle event from client
end)

-- Client
local RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("MyEvent")
RemoteEvent:FireServer(myData)
```

### 7. Release Process

1. **Increment Version** in `config.lua`
2. **Update FEATURES.md** with release notes
3. **Run All Tests** - Ensure they pass
4. **Commit & Tag**
   ```bash
   git commit -m "Release: v1.0.0"
   git tag v1.0.0
   git push origin main --tags
   ```
5. **Share with Testers**
   - Send game link
   - Share release notes
   - Collect feedback

### 8. Community Testing

- **Testers**: Family, friends, community members
- **Feedback Channels**: GitHub Issues, Discussions
- **Bug Reports**: Create issues for bugs found
- **Feature Requests**: Discuss in Ideas board

## Checklist: Before Submitting Code

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] No console errors or warnings
- [ ] Features are documented
- [ ] Tested with live testers
- [ ] Version number updated
- [ ] Changes committed with clear message

## Questions?

See [CONTRIBUTING.md](CONTRIBUTING.md) or check existing games for examples.
