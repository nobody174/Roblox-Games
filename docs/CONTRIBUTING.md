<!--
  Roblox Games - Contributing Guide
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Contributing Guide

Thank you for contributing to Roblox Games! This guide explains our workflow and standards.

## Getting Started

1. **Fork the repository** (if external contributor)
2. **Clone locally**
   ```bash
   git clone https://github.com/[YOUR-USERNAME]/roblox-games.git
   cd roblox-games
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/descriptive-branch-name
   ```

## Development Workflow

### Before You Code

- Check [IDEAS.md](../IDEAS.md) for planned features
- Review [GAMES.md](GAMES.md) for coding standards
- Look at existing games for examples

### Writing Code

1. **Follow the style guide** (see GAMES.md)
2. **Add tests** for new functionality
3. **Document your code** with clear function names
4. **Use meaningful commit messages**

### Commit Message Format

```
[Type]: Brief description

Longer explanation if needed.

- Bullet points for changes
- Organized by impact

Fixes #123 (if closing an issue)
```

**Types**: Add, Fix, Refactor, Docs, Test, Release

**Examples**:
- `Add: new parkour game with platform mechanics`
- `Fix: player collision detection issues`
- `Refactor: inventory system for code reuse`
- `Docs: update gameplay guide`
- `Test: add unit tests for PlayerManager`

### Testing Your Changes

#### Local Testing
1. Open the game in Roblox Studio
2. Test core features manually
3. Test with other players if possible

#### Automated Testing
- Push to a branch
- GitHub Actions runs automatically
- Check the Actions tab for results

### Code Review

- **All PRs require review** before merging
- Request review from code owners
- Address feedback constructively
- Respond to all comments

## Pull Request Process

1. **Update your branch** with latest main
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Push your changes**
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a PR on GitHub**
   - Describe what changed and WHY
   - Link related issues
   - Include before/after screenshots if UI changes

4. **PR Template** (fill out):
   ```markdown
   ## Description
   What does this PR do?
   
   ## Related Issues
   Fixes #123
   
   ## Testing
   How was this tested?
   
   ## Screenshots
   (if applicable)
   
   ## Checklist
   - [ ] Tests pass
   - [ ] Code follows style guide
   - [ ] Documentation updated
   - [ ] Tested with live players
   ```

5. **Address Review Comments**
   - Make requested changes
   - Commit with clear message
   - Re-request review

6. **Merge When Approved**
   - All checks pass
   - All reviews approved
   - Up-to-date with main

## Code Standards

### Naming Conventions
- Variables: `camelCase` → `playerSpeed`
- Functions: `camelCase` → `getPlayerHealth()`
- Classes: `PascalCase` → `PlayerManager`
- Constants: `SCREAMING_SNAKE_CASE` → `MAX_PLAYERS`

### Structure
- **Indentation**: 2 spaces (not tabs)
- **Line length**: Aim for under 100 chars
- **Comments**: Explain WHY, not WHAT
- **Functions**: Single responsibility
- **Error handling**: Fail gracefully

### Testing
- Write tests for new features
- Aim for >80% coverage
- Include unit + integration tests
- Test edge cases

## Documentation

When you add features, update:
- Code comments (if non-obvious)
- Game's FEATURES.md
- Game's API.md (if new functions)
- README (if user-facing)

## Reporting Issues

Found a bug? Create an issue:

**Title**: Brief description
**Description**: 
- What happened?
- What should happen?
- Steps to reproduce
- Screenshots if applicable

**Labels**: bug, enhancement, documentation, etc.

## Feature Requests

Have an idea? Suggest it:

1. Check [IDEAS.md](../IDEAS.md) first
2. Create discussion or issue
3. Describe the feature
4. Explain the benefit
5. Start a conversation

## Questions?

- Check existing issues/discussions
- Ask in comments
- Read GAMES.md for standards
- Look at example games

## Code of Conduct

- Be respectful and constructive
- Give helpful feedback
- Celebrate wins
- Learn from mistakes
- Have fun building games!

---

**Thanks for contributing!** 🎮

Built with assistance from Claude Code by Anthropic
