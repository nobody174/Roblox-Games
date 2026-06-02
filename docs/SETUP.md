<!--
  Roblox Games - Setup Guide
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Setup Guide

## Prerequisites

- **Roblox Studio** (free) - [Download](https://www.roblox.com/studio)
- **Git** - [Download](https://git-scm.com/)
- **GitHub Account** - For pushing/pulling code
- **Text Editor** (VS Code recommended)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/nobody174/roblox-games.git
cd roblox-games
```

### 2. Open in Roblox Studio

1. Open Roblox Studio
2. Click **File → Open**
3. Navigate to the game folder you want to work on
4. Select the `.rbxl` file (Roblox place file)

### 3. Project Structure

Each game follows this structure:

```
games/[GameName]/
├── src/                    # Source code (Lua scripts)
│   ├── init.lua           # Game initialization
│   ├── config.lua         # Game configuration
│   └── modules/           # Reusable modules
├── tests/                 # Test files
│   ├── unit/
│   └── integration/
├── docs/                  # Game-specific documentation
│   ├── README.md
│   └── GAMEPLAY.md
└── place.rbxl             # Roblox place file
```

## Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Edit Lua scripts in your editor
   - Test in Roblox Studio

3. **Run tests** (if applicable)
   - Tests run automatically in CI/CD
   - Or run locally in Roblox Studio

4. **Commit & push**
   ```bash
   git add .
   git commit -m "Add: description of changes"
   git push origin feature/your-feature-name
   ```

5. **Create a Pull Request**
   - Go to GitHub
   - Create PR with description
   - Wait for CI/CD checks to pass

### Testing with Live Testers

1. **Deploy to testing build**
   - Tag version and release
   - Share link with testers

2. **Gather feedback**
   - Create GitHub issues for bugs
   - Create discussions for feature requests

3. **Iterate & improve**
   - Fix bugs on hotfix branches
   - Plan features in IDEAS.md

## CI/CD Pipeline

GitHub Actions automatically:
- ✓ Runs Lua linting on every push
- ✓ Runs unit & integration tests
- ✓ Validates code quality
- ✓ Builds release packages

**Status badge**: Check workflow results in GitHub Actions tab

## Troubleshooting

### Lua Scripts Not Loading

- Ensure scripts are in the correct folder
- Check `init.lua` paths are correct
- Look at Roblox Studio output console for errors

### Tests Failing

- Check test file syntax
- Verify TestEZ framework is installed
- Review error messages in Actions tab

### Git Conflicts

- Pull latest: `git pull origin main`
- Resolve conflicts in your editor
- Commit and push again

## Need Help?

- Check individual game READMEs
- Review CONTRIBUTING.md
- Check GitHub Issues/Discussions
