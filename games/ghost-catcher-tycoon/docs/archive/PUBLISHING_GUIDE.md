<!--
  Ghost Catcher Tycoon — Publishing Guide
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Publishing Ghost Catcher Tycoon to Roblox

## Pre-Launch Checklist

### 1. Game Configuration
- [ ] Title: "Ghost Catcher Tycoon"
- [ ] Description: See below
- [ ] Genre: Tycoon / Simulation
- [ ] Play Style: Single Player / Cooperative
- [ ] Creator: nobody174

### 2. Game Description

```
👻 Catch ghosts. Build your collection. Earn eternal energy. 👻

Ghost Catcher Tycoon is a relaxing idle/active tycoon where you:

🎮 CATCH GHOSTS
Click to charge your vacuum and catch rare ghosts from 11 haunted zones.
Rarer ghosts = Higher energy production!

⚡ BUILD YOUR EMPIRE  
Caught ghosts passively generate Ecto-Energy. Unlock new zones, upgrade your HQ, 
and expand your collection.

🏭 AUTOMATE EVERYTHING
Enable Auto-Catch and Auto-Train to let your ghosts work for you while you're away.
Come back to massive rewards!

🎁 HATCH SPECIAL EGGS
Pull from gacha eggs (7 types!) to hatch rare ghosts with random stats.
Will you find a Legendary? A Corrupted?

⚔️ DEFEAT LEGENDARY BOSSES
Face zone bosses for massive energy rewards and exclusive ghost drops.
Each victory brings you closer to endgame.

🌙 PRESTIGE & ASCEND
Reset your progress and gain permanent bonuses. Unlock new zones and mechanics
with each prestige cycle.

🔄 INFINITE PROGRESSION
11 zones. 120 unique ghosts. 7 egg types. Boss encounters. Prestige layers.
There's always something new to unlock.

Chill, strategic, and endlessly rewarding. 👻
```

### 3. Keywords (Roblox Search)
- Tycoon
- Idle
- Simulation
- Ghost
- Clicker
- Prestige
- Casual

### 4. Thumbnail Guidelines

**Recommended:**
- Large, colorful ghost emoji or character in center
- Bold "GHOST CATCHER" text
- Purple/blue dark theme to match game aesthetic
- High contrast for mobile visibility
- Size: 1024x1024px recommended

**Must-have:**
- Title readable at small size
- Bright colors (ghosts, energy effects)
- No text that gets cut off

### 5. Game Icon
- 512x512px minimum
- Feature the main ghost character or vacuum design
- Use game colors: Purple, Blue, Dark backgrounds

## Roblox Studio Setup

### Asset Management
1. **Place Configuration**
   - Name: `Ghost Catcher Tycoon`
   - ID: Generated on creation
   - Server-side scripts: MainServer.lua loaded in ServerScriptService
   - Client scripts: GameClient.lua in StarterPlayer > StarterCharacterScripts

2. **Monetization (if enabling)**
   - GamePass: Premium Features (Auto-Catch, Extended Inventory)
   - Developer Products: Energy Boosters, Cosmetics
   - See MonetizationSystem.lua for implementation

3. **Data Persistence**
   - DataStore enabled (required for cloud saves)
   - Auto-save every 30 seconds
   - Fallback to in-memory storage in Studio

### Testing Checklist
- [ ] Load in Studio as user
- [ ] Click vacuum to charge (UI should respond)
- [ ] Catch 5+ ghosts
- [ ] Unlock a new zone
- [ ] Check that energy production works
- [ ] Close and rejoin (data persists)
- [ ] Exit Studio, reopen, verify data still there

## Publishing Steps

### 1. In Roblox Studio
- Publish the place to your account
- Set visibility to Public

### 2. On Roblox.com
- Go to My Creations > Games
- Click "Ghost Catcher Tycoon"
- **Configure** → **Basic Settings**:
  - [ ] Title: Ghost Catcher Tycoon
  - [ ] Description: (paste from above)
  - [ ] Genre: Tycoon
  - [ ] Genre + Subcategory: Tycoon / Simulation
  - [ ] Play Style: Single Player

### 3. Upload Assets
- [ ] Thumbnail (1024x1024px PNG or JPG)
- [ ] Icon (512x512px PNG)
- [ ] Save

### 4. Social & Promotion
- [ ] Discord community server (optional)
- [ ] Twitter/X announcement
- [ ] Reddit post (r/roblox if rules allow)
- [ ] Creator portfolio or website link

## Post-Launch

### Monitoring (First Week)
- Check **Statistics** daily for:
  - Player count
  - Session duration
  - Device breakdown (mobile vs desktop)
  - Retention at Day 1, 3, 7

### Common Issues
- **Players stuck on splash screen**: Likely server error. Check MainServer.lua logs.
- **Data not saving**: DataStore disabled. Enable in game settings.
- **Ghost catches not counting**: Check GhostSystem.lua for remote event routing.
- **Game feels slow**: Use Developer Console (F9) to check for lag spikes.

### Updates
- Monitor feedback for balance issues
- Adjust ghost spawn rates if needed
- Add new cosmetics based on player requests
- Plan seasonal events via EventSystem

## Monetization (Optional)

If enabling GamePasses:
1. Create in Roblox Creator Hub
2. Reference them in MonetizationSystem.lua
3. Test purchases in Studio before launch
4. Announce in game description

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.0 | 2026-06-03 | Initial launch: 17 systems, 120 ghosts, 11 zones |

---

**Contact:** vartdal@gmail.com  
**Repository:** https://github.com/nobody174/roblox-games

Built with Claude Code by Anthropic.
