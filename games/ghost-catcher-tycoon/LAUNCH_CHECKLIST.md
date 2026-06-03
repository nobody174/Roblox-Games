<!--
  Ghost Catcher Tycoon — Launch Checklist
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# 🚀 Ghost Catcher Tycoon — Launch Checklist

## Pre-Launch (This Week)

### Assets
- [ ] **Convert `assets/thumbnail.html` → `thumbnail.png`** (1024×1024)
  - See: ASSET_CONVERSION_GUIDE.md
  - Save to: `assets/thumbnail.png`
  
- [ ] **Convert `assets/icon.html` → `icon.png`** (512×512)
  - See: ASSET_CONVERSION_GUIDE.md
  - Save to: `assets/icon.png`

- [ ] **Verify PNG files**
  - [ ] Exact dimensions (1024×1024, 512×512)
  - [ ] PNG format (not JPG)
  - [ ] File size < 5MB each
  - [ ] Colors look good in Preview
  - [ ] No compression artifacts

### Code Review
- [ ] **Test in Studio**
  - [ ] Start game as test player
  - [ ] Hatch a ghost (check GhostService)
  - [ ] Catch ghosts (check VacuumSystem)
  - [ ] Unlock a zone (check ZoneSystem)
  - [ ] Check currency accumulation (check ProductionSystem)
  - [ ] Open inventory tab (check GameClient)
  - [ ] Check Output window for errors
  
- [ ] **Test GamePass UI** (if enabled)
  - [ ] Auto-Catch button visible?
  - [ ] Purchase dialog functional?
  
- [ ] **Final Build**
  - [ ] Run `mvn clean package` (if Java plugins)
  - [ ] No build errors
  - [ ] All systems loading correctly

### Game Configuration
- [ ] **Verify game name**
  - Name: "Ghost Catcher Tycoon"
  - Visibility: Public

- [ ] **Prepare description** (from PUBLISHING_GUIDE.md)
  ```
  👻 Catch ghosts. Build your collection. Earn eternal energy. 👻
  
  [Full description ready to copy-paste]
  ```

- [ ] **Prepare keywords**
  - Tycoon, Idle, Simulation, Ghost, Clicker, Prestige, Casual

- [ ] **Enable DataStore** (if not already)
  - Studio → File → Game Settings
  - API Access → Check "Enable Publishing API"

---

## Publishing to Roblox (Day 1)

### In Roblox Studio
- [ ] **Publish Game**
  - [ ] File → Publish to Roblox
  - [ ] Title: "Ghost Catcher Tycoon"
  - [ ] Description: (paste from above)
  - [ ] Visibility: Public
  - [ ] Genre: Tycoon / Simulation
  - [ ] Play Style: Single Player
  - [ ] Click "Publish"

### On Roblox.com
- [ ] **Navigate to Game**
  - Go to: https://www.roblox.com/my/games
  - Find: "Ghost Catcher Tycoon"

- [ ] **Configure Basic Settings**
  - [ ] Title: "Ghost Catcher Tycoon"
  - [ ] Description: (copy from PUBLISHING_GUIDE.md)
  - [ ] Genre: Tycoon / Simulation
  - [ ] Play Style: Single Player
  - [ ] Min Players: 1
  - [ ] Max Players: 1
  - [ ] Click "Save"

- [ ] **Upload Assets**
  - [ ] Thumbnail: Upload `assets/thumbnail.png`
  - [ ] Icon: Upload `assets/icon.png` (if available)
  - [ ] Click "Save"

- [ ] **Enable Comments** (optional)
  - [ ] Moderation → Comments (On/Off)
  - [ ] Recommend: OFF until you monitor player feedback

- [ ] **Create About Section** (optional)
  - [ ] Add: "Made with ❤️ using Roblox Studio"
  - [ ] Add: Social links if you have them

### Initial Checks
- [ ] **Visit Game Page**
  - Go to: https://www.roblox.com/games/[GAME_ID]/Ghost-Catcher-Tycoon
  - [ ] Thumbnail displays correctly
  - [ ] Description shows without formatting errors
  - [ ] Rating system visible
  - [ ] "Play" button works

- [ ] **Test from Game Page**
  - [ ] Click "Play"
  - [ ] Game loads in Studio
  - [ ] Initial screen appears (splash/menu)
  - [ ] Can start playing

---

## Launch Week (Days 1-7)

### Daily Checks
- [ ] **Morning (Day 1-3)**
  - Check Roblox game page for critical bugs
  - Read first player feedback/comments
  - Monitor player count trend

- [ ] **Respond to Issues**
  - IF: Critical bug reported → Hot-fix and re-publish
  - IF: Balance issue → Document for post-launch patch
  - IF: UI problem → Add to improvement backlog

### Monitoring
- [ ] **Statistics**
  - [ ] Check daily: Players, session length, device type
  - [ ] Document: Day 1, Day 3, Day 7 retention

- [ ] **Player Feedback**
  - [ ] Read comments/reviews on game page
  - [ ] Check: Are they enjoying it?
  - [ ] Check: Any bugs mentioned?
  - [ ] Check: Balance complaints?

### Metrics to Track

**Baseline expectations:**
- Day 1: 10-50 players
- Day 7: 30-150 players (if marketing)
- Avg Session: 15-30 minutes
- Retention D1→D3: 40%+
- Retention D3→D7: 20%+

**If metrics are below baseline:**
- Check for bugs in Output (server logs)
- Review balance (are zones too grindy?)
- Check game description (is it clear what the game is?)

---

## First Month (Week 2-4)

### Iterate Based on Data
- [ ] **Balance Adjustments**
  - IF: Players stuck on Zone 3 (50%+ at zone X) → Reduce unlock cost or boost production
  - IF: Few players reach Zone 7 (< 10%) → Review pacing guide
  - IF: Monetization < 5% → Consider lowering egg prices slightly

- [ ] **Content Additions** (if needed)
  - IF: Players asking for "more ghosts" → Add seasonal ghost variants
  - IF: Engagement dropping after 3 hours → Add daily login bonus
  - IF: Leaderboard enabled → Run weekly "catch the most ghosts" event

- [ ] **Quality of Life**
  - IF: Players complain "UI is confusing" → Improve tabs/buttons
  - IF: Inventory lags at 100+ ghosts → Add caching/pagination
  - IF: "Saving takes too long" → Optimize DataStore calls

### Documentation
- [ ] **Update STATUS.md** with launch metrics
- [ ] **Create POST_LAUNCH_REPORT.md** with Day 7 data
- [ ] **Document any patches** applied post-launch

---

## Success Criteria (30 Days)

✅ **Soft Launch Success (Minimum):**
- [ ] Game loads without critical errors
- [ ] At least 50 unique players in first week
- [ ] Day 1→Day 3 retention ≥ 35%
- [ ] Average session length ≥ 10 minutes
- [ ] No game-breaking bugs reported

✅ **Good Launch (Target):**
- [ ] 100+ unique players in first week
- [ ] Day 1→Day 3 retention ≥ 45%
- [ ] Day 7 players ≥ 50
- [ ] Average session length ≥ 20 minutes
- [ ] Positive comment ratio (80%+ positive sentiment)
- [ ] ≥ 8-10% monetization conversion

✅ **Great Launch (Ideal):**
- [ ] 500+ unique players in first week
- [ ] Day 1→Day 3 retention ≥ 50%
- [ ] Day 7 players ≥ 200
- [ ] Average session length ≥ 30 minutes
- [ ] Positive comment ratio (90%+)
- [ ] ≥ 12-15% monetization conversion
- [ ] Players reaching Zone 10 (endgame)

---

## Post-Launch (Month 2+)

### Ongoing Maintenance
- [ ] **Monitor Daily**
  - Player trends (should grow or stabilize, not decline)
  - Bug reports (fix critical within 48h)
  - Balance feedback (adjust if >50% players stuck)

- [ ] **Weekly Updates**
  - Feature small improvements
  - Balance tweaks based on data
  - Respond to top player feedback

- [ ] **Monthly Events**
  - Seasonal ghost variants
  - Limited-time challenges
  - Double XP weekends (if applicable)

### Scaling Plans
- [ ] **If 5,000+ concurrent players**
  - Monitor server performance
  - May need multi-server load balancing
  - Contact Roblox support for scaling

- [ ] **If 10,000+ players**
  - Consider automated monetization (ads, premium cosmetics)
  - Plan expansion: New zones, ghost types, game modes

---

## Emergency Responses

### If Game Won't Start
1. Check Output window for errors
2. Verify all systems are instantiated in MainServer.lua
3. Check for DataStore errors (enable API Access)
4. Re-publish to Roblox

### If Players Report Infinite Loop
1. Check ProductionSystem tick rate (should be 0.1s, not 0.01s)
2. Check BossSystem for infinite loops in AI
3. Disable problematic system, re-publish

### If Monetization Broken
1. Check MonetizationSystem links
2. Verify RemoteEvents for purchases
3. Check game has "Game Products" enabled in settings

### If Data Not Saving
1. Enable DataStore in game settings
2. Check DataManager implementation
3. Add logging to PlayerRemoving event
4. Test in published game (DataStore doesn't work in Studio)

---

## Quick Reference

| Metric | Where to Check |
|--------|---|
| Player Count | Roblox.com → Game Page → Statistics |
| Session Length | Roblox.com → Game Page → Statistics |
| Retention | Roblox.com → Game Page → Analytics |
| Comments | Roblox.com → Game Page → Comments section |
| Errors | Roblox Studio → Output window (when testing) |
| DataStore | Roblox Creator Hub → Game → API Access |

---

## Files Ready for Launch

| File | Purpose | Status |
|------|---------|--------|
| `place.rbxl` | Main game file | ✅ Ready |
| `src/server/MainServer.lua` | Server initialization | ✅ Ready |
| `src/client/GameClient.lua` | Client UI | ✅ Ready |
| `assets/thumbnail.png` | Game thumbnail | ⏳ Needs conversion |
| `assets/icon.png` | Game icon | ⏳ Needs conversion |
| `PUBLISHING_GUIDE.md` | Publishing steps | ✅ Ready |
| `BALANCE_GUIDE.md` | Economy reference | ✅ Ready |

---

## Important Reminders

⚠️ **Before Publishing:**
- [ ] Test one complete game loop (catch → zone → hatch → train)
- [ ] Verify Output window has no errors
- [ ] Check that all systems are linked in MainServer
- [ ] Confirm DataStore API is enabled

⚠️ **After Publishing:**
- [ ] Game takes 5-10 minutes to appear in Roblox search
- [ ] Asset uploads take 15 minutes to process
- [ ] Don't panic if first metrics are low (ramp-up is normal)
- [ ] Monitor for 24 hours before declaring "success"

---

## Contact & Support

**Questions?** See:
- PUBLISHING_GUIDE.md — Step-by-step publishing instructions
- ASSET_CONVERSION_GUIDE.md — How to convert HTML → PNG
- ASSETS_PREVIEW.md — What the assets look like
- BALANCE_GUIDE.md — If balance feedback arrives early

**Repository:** https://github.com/nobody174/roblox-games

---

## Timeline Summary

```
Week 1:     Convert assets, final test, publish to Roblox
Day 1:      Monitor first players, watch for critical bugs
Week 2-4:   Iterate on feedback, balance adjustments
Month 2+:   Ongoing maintenance, feature additions, events
```

**Good luck! 👻⚡**

Built with Claude Code by Anthropic.
