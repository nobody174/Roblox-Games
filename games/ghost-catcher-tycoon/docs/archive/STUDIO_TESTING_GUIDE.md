# Studio Testing Guide: Ghost Catcher Tycoon MVP

**Status:** Ready for testing  
**Last Updated:** 2026-06-04

---

## Files to Update in Roblox Studio

You need to copy **3 files** into Studio:

### **1. src/server/MainServer.lua** ⚠️ CRITICAL
**Location in Studio:** `ServerScriptService` → `MainServer` (LocalScript)

**What changed:**
- Added Phase 5: Production loop (runs every 1 second, adds energy to players)
- Added Phase 6-8: HQ upgrade, zone unlock, egg hatch remote handlers
- New functions: `setupProductionLoop()`, handlers for UpgradeRoom, UnlockZone, HatchEgg remotes

**How to update:**
1. Open your `place.rbxl` in Roblox Studio
2. Navigate to `ServerScriptService` → `MainServer`
3. Replace entire script with contents of: `src/server/MainServer.lua`
4. Save the place file

### **2. src/client/GameClient.lua** ⚠️ CRITICAL
**Location in Studio:** `StarterPlayer` → `StarterCharacterScripts` or `StarterPlayerScripts` → `GameClient` (LocalScript)

**What changed:**
- Phase 5: HQ tab populated (5 rooms with upgrade buttons)
- Phase 6: Zones tab populated (11 zones with unlock buttons)
- Phase 7: Ghost tab redesigned (ghost cards with train buttons)
- Phase 8: Shop tab populated (7 eggs with hatch buttons)
- Phase 9: Info tab with GamePass info

**How to update:**
1. Open your `place.rbxl`
2. Navigate to `StarterPlayer` → `StarterPlayerScripts` → `GameClient`
3. Replace entire script with contents of: `src/client/GameClient.lua`
4. Save the place file

### **3. src/shared/config.lua** (Optional but recommended)
**Location in Studio:** `ReplicatedStorage` → `shared` → `config`

**What changed:**
- Added comments explaining economy balancing
- Updated spawn rates and initial values
- Documented coin rewards

**How to update:**
1. Open your `place.rbxl`
2. Navigate to `ReplicatedStorage` → `shared` → `config`
3. Replace entire script with contents of: `src/shared/config.lua`
4. Save the place file

---

## NEW Files to Add to Studio

You don't need to add any new files! All gameplay systems already exist in the codebase:

✅ **Already in Studio:**
- GhostSpawner.lua (spawns ghosts)
- GhostStatGenerator.lua (generates stats)
- GhostInstanceBuilder.lua (creates ghost visuals)
- All 18 systems (GhostService, ProductionSystem, HQSystem, ZoneSystem, EggSystem, etc.)

✅ **No new modules needed** — Everything is wired together now

---

## Testing Checklist

### **Before You Start**
- [ ] Close Studio completely
- [ ] Copy new versions of 3 files into Studio
- [ ] Save the place file
- [ ] Close and reopen Studio to be safe

### **Initial Load**
- [ ] Press Play
- [ ] Check Output for "[Ghost Catcher Tycoon] Server started" message
- [ ] Check for any red error messages in Output

### **Phase 4 (Ghost Spawning & Catching)**
- [ ] Wait 5 seconds
- [ ] See colored ghost spheres appear in zones
- [ ] Press F to toggle Fly Tool
- [ ] Catch a ghost with Catch button
- [ ] Verify ghost disappears
- [ ] Verify coins increase in top panel
- [ ] Check Output: `[Ghost Catcher] [PlayerName] caught [GhostName]`

### **Phase 5 (Production System)**
- [ ] Catch 1-2 ghosts
- [ ] Watch top panel energy increase every 1 second
- [ ] Click HQ tab to expand
- [ ] See 5 rooms listed (Ghost Chamber, Training Facility, etc.)
- [ ] Click "Upgrade" on a room
- [ ] Energy should decrease, room level increases
- [ ] Production should increase (watch energy rise faster)

### **Phase 6 (Zone Unlocking)**
- [ ] Click Zones tab
- [ ] See all 11 zones listed
- [ ] First zone (Whisper Woods) should say "Unlocked ✓"
- [ ] Other zones show unlock cost (1500, 6000, 18000, etc.)
- [ ] Earn enough coins, click unlock
- [ ] Zone should show "Unlocked ✓"
- [ ] Fly to new zone, see different colored ghosts

### **Phase 7 (Ghost Training)**
- [ ] Click Ghost tab
- [ ] See cards for each caught ghost
- [ ] Ghost name, rarity (colored), level 1 shown
- [ ] Click Train button
- [ ] Energy decreases, ghost level increases to 2
- [ ] Check energy output per ghost (shown on card)

### **Phase 8 (Egg Gacha)**
- [ ] Click Shop tab
- [ ] See 7 egg types (Common, Uncommon, Rare, etc.)
- [ ] Each egg shows price and drop chances
- [ ] Earn coins, click Hatch on egg
- [ ] New ghost appears in Ghost tab with random rarity

### **Phase 9 (Auto Systems)**
- [ ] Click Info tab
- [ ] See GamePass info (Auto-Catch, Auto-Train, etc.)
- [ ] Verify auto systems are running in background (check ghost count increasing over time)

### **Phase 10 (Polish)**
- [ ] Catch button has visual feedback (pulse when clicked)
- [ ] Notifications appear when catching/upgrading/unlocking
- [ ] Game feels balanced pacing-wise

---

## Common Issues & Fixes

### **Scripts won't run / "Module not found" errors**
- Make sure all shared modules exist in ReplicatedStorage/shared:
  - config.lua ✓
  - constants.lua ✓
  - enums.lua ✓
  - GhostData.lua ✓
  - ZoneData.lua ✓
  - GhostStatGenerator.lua ✓
  - GhostInstanceBuilder.lua ✓
  - All others (.lua files in src/shared)

### **UI doesn't show / buttons don't work**
- Check that GameClient.lua is in correct location (StarterPlayerScripts)
- Make sure remotes are created in ReplicatedStorage/Remotes
- Check Output for any errors

### **Ghosts don't spawn**
- Make sure MainServer.lua is running (check for init messages in Output)
- Make sure ZONE_AUTO_BUILDER.lua has run (should see ZoneContainer in workspace)
- Check Output for spawn logs

### **Energy not increasing**
- Check that ProductionSystem loop is running (MainServer should show init message)
- Catch at least 1 ghost (can't produce without ghosts)
- Make sure HQ rooms haven't been downgraded

### **Tabs are blank**
- Make sure you're using the NEW GameClient.lua with UI population code
- Check that remotes are created
- Check Output for errors in tab population functions

---

## What to Test First (Priority Order)

1. **Ghost spawning** (Phase 4) — most basic
2. **Catching** (Phase 4) — core mechanic
3. **Production** (Phase 5) — passive income
4. **Zone unlocking** (Phase 6) — progression
5. **Training** (Phase 7) — long-term goal
6. **Eggs** (Phase 8) — gacha/randomness
7. **Auto systems** (Phase 9) — idle gameplay
8. **Polish** (Phase 10) — feel & feedback

---

## File Locations Reference

| What | Where in Studio |
|------|-----------------|
| MainServer | ServerScriptService → MainServer |
| GameClient | StarterPlayer → StarterPlayerScripts → GameClient |
| config.lua | ReplicatedStorage → shared → config |
| GhostData.lua | ReplicatedStorage → shared → GhostData |
| ZoneData.lua | ReplicatedStorage → shared → ZoneData |
| All other shared modules | ReplicatedStorage → shared → [module name] |
| Remotes folder | ReplicatedStorage → Remotes (auto-created) |
| Zones | Workspace → ZoneContainer → [zone name] |
| Ghosts | Workspace → ZoneContainer → [zone] → [ghost] |

---

## Next Steps After Testing

1. **Document balance feedback** — Is it too easy? Too grindy? Note what feels off
2. **Fix any bugs** found during testing (Claude will help)
3. **Polish visuals** — Add particles, sounds, animations
4. **Publish to Roblox** — Game is feature-complete

---

**Ready to test!** Let me know if you hit any issues. 🎮👻
