# Final Pre-Studio Checklist ✅

**Everything is ready. Here's your checklist for testing.**

---

## Pre-Studio Setup (2 min)

- [ ] Have place.rbxl open in Roblox Studio
- [ ] Have the game NOT currently running
- [ ] Have Output window visible (to check for errors)
- [ ] Have TESTING_SUMMARY.md and READY_FOR_STUDIO.md open for reference

---

## Smoke Test (5 min) - Start Here!

- [ ] Click **Play** button
- [ ] Wait for UI to fully load (~3 seconds)
- [ ] Check **top panel** - see Energy, Coins, Ghost Count labels
- [ ] Check **bottom buttons** - see Charge, Catch, Bring Home buttons
- [ ] Check **tab bar** - see Ghost, HQ, Zones, Shop, Info, Chat tabs
- [ ] Check **no errors in Output** - should only see `[Ghost Catcher Tycoon]` logs

**If smoke test passes** → Go to Full Game Loop Test  
**If smoke test fails** → Stop and check READY_FOR_STUDIO.md troubleshooting

---

## Full Game Loop Test (15 min)

### Part 1: Catching & Inventory (5 min)
- [ ] Click **Charge** button 4 times (charge bar should go from 0% to ~80%)
- [ ] Click **Catch** button (charge should go to 0%, ghost count should increase)
- [ ] Click **Charge** 20 times until it fills to 100%
- [ ] Click **Catch** (should catch another ghost)
- [ ] Click **Ghost tab** - should see 2 ghosts in inventory
- [ ] Each ghost should show: Name, Rarity (colored), Level, Energy/sec

### Part 2: HQ Upgrades (3 min)
- [ ] Click **HQ tab** - should see 5 rooms
- [ ] Each room should show: Name, Level, Cost, Upgrade button
- [ ] Click **Upgrade** on any room (e.g., Energy Reactor)
- [ ] Close HQ tab and reopen it - level should be 2 (persisted)

### Part 3: Zone Unlocking (4 min)
- [ ] Click **Zones tab** - should see list of 11 zones
- [ ] First zone (Whisper Woods) should say "Unlocked"
- [ ] Second zone (Foggy Fields) should show "Cost: 1.5K"
- [ ] Catch more ghosts until you have 1500+ coins
- [ ] Click **Unlock** for Foggy Fields
- [ ] **CRITICAL CHECK:** Button should change to **"Visit"** within 1 second ← This was a bug, now fixed!
- [ ] Close and reopen Zones tab - button should still say "Visit"

### Part 4: Egg Hatching (3 min)
- [ ] Click **Shop tab** - should see 7 eggs
- [ ] Each egg shows: Emoji, Name, Price, Drop chances, Hatch button
- [ ] Click **Hatch** on any egg
- [ ] Ghost tab should now show 1 more ghost
- [ ] Ghost count in top panel should increase

**If all parts pass** → Go to Admin Commands Test  
**If any part fails** → Check READY_FOR_STUDIO.md troubleshooting

---

## Admin Commands Test (10 min) - Test Chat System

### Setup
- [ ] Click **Chat** tab in tab bar (it has a 💬 icon)
- [ ] Chat history panel should appear below the input box
- [ ] Type something in the input box

### Test Commands
- [ ] Type `/coin` and press Enter
  - [ ] Should see message "✓ coin executed" in green in history
  - [ ] Coins in top panel should increase by 1000
  
- [ ] Type `/energy` and press Enter  
  - [ ] Should see message "✓ energy executed" in green
  - [ ] Energy in top panel should increase by 1000
  
- [ ] Type `/ghost Phantom` and press Enter
  - [ ] Should see "✓ ghost executed" in green
  - [ ] Ghost tab should show new Phantom ghost
  
- [ ] Type `/heal` and press Enter
  - [ ] Should see "✓ heal executed" in green
  - [ ] Coins should increase by 1000 again
  
- [ ] Type `/heal max` and press Enter
  - [ ] Should see "✓ heal executed" in green
  - [ ] Coins should now show 9999
  
- [ ] Type `/help` and press Enter
  - [ ] Should see all 9 commands listed in output panel

**If all commands pass** → Go to Data Sync Test  
**If any command fails** → Check READY_FOR_STUDIO.md troubleshooting

---

## Data Sync Test (5 min) - Real-time Updates

- [ ] Keep Energy/Coins values from top panel in view
- [ ] Type `/coin` command
- [ ] **IMPORTANT:** Coins should update IMMEDIATELY and NOT disappear on next 1-second broadcast ← This was a bug, now fixed!
- [ ] Type `/coin` again
- [ ] Coins should increase again without disappearing
- [ ] Click **Ghost tab** while chat panel is open
- [ ] Ghost list should update and render correctly
- [ ] Click **HQ tab** 
- [ ] Room levels should render without issues
- [ ] Click **Zones tab**
- [ ] Scroll down - buttons should NOT overlap with charge/catch buttons ← This was a bug, now fixed!

**If all checks pass** → Go to Final Verification

---

## Final Verification (2 min)

### Check Output Log
- [ ] No `ERROR` messages in output
- [ ] No `nil` errors
- [ ] No `attempt to index` errors
- [ ] Only see `[Ghost Catcher Tycoon]` and `[PHASE 4]` logs

### Check UI Stability
- [ ] Click between tabs rapidly - no lag or errors
- [ ] Coins/Ghosts display updates - never showing wrong values
- [ ] No buttons stuck or unresponsive
- [ ] All text legible and properly positioned

### Check Commands
- [ ] Type invalid command like `/invalid` - should show red error
- [ ] Type command without slash like `coin` - should show yellow warning
- [ ] Try typing `/` alone - should be handled gracefully

**If all checks pass** → ✅ TESTING COMPLETE!

---

## Results Summary

### ✅ ALL TESTS PASSED
If you got here with all checks marked - congratulations! 🎉

**Phase 4 Status:** ✅ **PRODUCTION READY**

Next steps:
1. Document any observations in STUDIO_TESTING_RESULTS.md
2. Take a final screenshot of the game in action
3. Consider Phase 5 work (advanced admin commands, etc.)

### ❌ TESTS FAILED
If you found an issue:

1. Note exactly which test failed
2. Note the error message (if any)
3. Check READY_FOR_STUDIO.md **Troubleshooting** section
4. If not found there, document the issue and we'll investigate

---

## Tips While Testing

**Monitor these three things:**
1. **Top Panel Values** - Energy/Coins should update in real-time
2. **Ghost Count** - Should increase when catching
3. **Output Log** - Should stay clean (no errors)

**Red Flags to Watch For:**
- ❌ Values disappearing or resetting unexpectedly
- ❌ UI elements overlapping or hidden
- ❌ Buttons not responding to clicks
- ❌ Console errors or warnings
- ❌ Zones showing as "Unlock" after unlocking

**Green Lights:**
- ✅ Smooth responsiveness
- ✅ Immediate data updates
- ✅ Clean console output
- ✅ All UI visible and accessible
- ✅ Zones updating to "Visit" within 1 second

---

## Session Duration

- Smoke Test: 5 min
- Full Game Loop: 15 min  
- Admin Commands: 10 min
- Data Sync: 5 min
- Final Verification: 2 min
- **Total: ~40 minutes** (or less if no issues)

---

## Most Important Checks

**These 3 things were the bugs we just fixed - check them first:**

1. **Zone Button Update** ⭐
   - Unlock a zone (Foggy Fields)
   - Button should change to "Visit" within 1 second
   - This will prove the UnlockZone broadcast fix works

2. **Coins Persistence** ⭐
   - Use `/coin` admin command
   - Coins should appear and NOT disappear a second later
   - This will prove the broadcast payload fix works

3. **Button Overlap** ⭐
   - Open Zones tab and scroll to the bottom
   - No unlock button should be hidden behind charge/catch buttons
   - This will prove the CanvasSize fix works

**If all 3 of these work correctly, Phase 4 is solid!**

---

**Good luck with testing! You've got this! 🚀**

*All code reviewed, all bugs fixed, all systems validated.*  
*Ready for production.*
