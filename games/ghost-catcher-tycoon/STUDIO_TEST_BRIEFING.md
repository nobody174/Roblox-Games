# Studio Testing Briefing

**Date:** 2026-06-04  
**What Changed:** 2 critical bugs fixed since Phase 4.2 testing  
**Status:** Ready for live testing

---

## 📋 Testing Checklist

Use **FINAL_CHECKLIST.md** (in project root) for step-by-step instructions. Here's the structure:

### 1. Pre-Studio Setup (2 min)
- [ ] place.rbxl open in Studio
- [ ] Game NOT running yet
- [ ] Output window visible
- [ ] Reference docs open

### 2. Smoke Test (5 min) ⭐ START HERE
- [ ] Click Play
- [ ] Check UI loads (Energy, Coins, Ghost Count labels visible)
- [ ] Check all buttons visible (Charge, Catch, Bring Home)
- [ ] Check all tabs visible (Ghost, HQ, Zones, Shop, Info, Chat)
- [ ] Check NO errors in Output log

### 3. Full Game Loop (15 min)
**Part 1: Catching (5 min)**
- [ ] Charge 4 times → Catch ghost → repeat
- [ ] End with 2 ghosts in Ghost tab

**Part 2: HQ Upgrades (3 min)**
- [ ] Open HQ tab → Upgrade a room → Check level persists

**Part 3: Zone Unlocking (4 min)** ⭐⭐ CRITICAL
- [ ] Get 1500+ coins
- [ ] Click Unlock for Foggy Fields
- [ ] **Button changes to "Visit" within 1 second** ← TEST THIS FIRST
- [ ] Close/reopen tab → Still says "Visit"

**Part 4: Egg Hatching (3 min)**
- [ ] Hatch an egg → New ghost appears

### 4. Admin Commands (10 min)
- [ ] Click Chat tab (💬 icon)
- [ ] Type `/coin` → See success message, coins increase
- [ ] Type `/heal` → Coins increase by 1000
- [ ] Type `/heal max` → Coins set to 9999
- [ ] Type `/help` → See all commands listed

### 5. Data Sync Test (5 min) ⭐⭐ CRITICAL
- [ ] Use `/coin` command
- [ ] **Coins appear and DON'T disappear 1 second later** ← TEST THIS
- [ ] Scroll Zones tab → **No button overlap** ← TEST THIS

### 6. Final Verification (2 min)
- [ ] No ERROR in output log
- [ ] Tabs respond quickly
- [ ] All buttons clickable
- [ ] Invalid commands show error

---

## ⚠️ 3 Critical Bug Fixes - Check These First

### Fix #1: UnlockZone Broadcast Payload
**What was broken:** When unlocking a zone, coins/ghosts would disappear a second later  
**What was fixed:** Added missing 4 fields to broadcast (VacuumCharge, GhostCount, GhostInventory, Rooms)  
**File:** `src/server/MainServer_Phase4_Extended.lua` (lines 452-461)  
**How to test:** Unlock Foggy Fields → Coins should NOT disappear

### Fix #2: unlockedZones Data Structure  
**What was broken:** AdminCommands used array format, MainServer used dictionary - type mismatch  
**What was fixed:** Changed AdminCommands to use dictionary format `{ ["zone"] = true }`  
**File:** `src/server/AdminCommands.lua` (line 78)  
**How to test:** Unlock a zone → Button should change to "Visit" within 1 second

### Fix #3: Zones Tab Canvas Size (Already fixed in Phase 4.2)
**What was broken:** Unlock buttons hidden behind charge/catch buttons  
**What was fixed:** Increased CanvasSize from 1100 to 1200  
**File:** `src/client/GameClient.lua` (line 765)  
**How to test:** Scroll Zones tab → No overlap with action buttons

---

## 📝 Files Changed Since Phase 4.2 Testing

### Code Files (Actual Game Logic)
| File | Change | Type | Critical |
|------|--------|------|----------|
| `src/server/MainServer_Phase4_Extended.lua` | Added 4 fields to UnlockZone broadcast | Fix | ⭐⭐ |
| `src/server/AdminCommands.lua` | Changed unlockedZones to dictionary | Fix | ⭐⭐ |
| `src/client/modules/ChatUI.lua` | NEW - Chat command system | New Feature | ✅ |
| `src/client/GameClient.lua` | Added ChatUI integration | Enhancement | ✅ |

### Documentation Files (For Reference)
| File | Purpose |
|------|---------|
| `FINAL_CHECKLIST.md` | ← **Use this during testing** |
| `TESTING_SUMMARY.md` | Overview of all work done |
| `READY_FOR_STUDIO.md` | Quick reference & troubleshooting |
| `PRE_STUDIO_TESTING_REPORT.md` | Detailed code review findings |

---

## 🎯 Testing Strategy

### Red Flags - Stop Testing If You See These
- ❌ Values disappearing or resetting
- ❌ UI overlapping or hidden elements
- ❌ Buttons not responding
- ❌ Console ERROR messages
- ❌ Zones still showing "Unlock" after unlocking

### Green Lights - Everything Working If You See These
- ✅ Smooth, responsive gameplay
- ✅ Immediate data updates
- ✅ Clean console output
- ✅ All UI visible and accessible
- ✅ Zone button changes to "Visit" within 1 second

---

## 📊 Test Timeline

- **Smoke Test:** 5 min
- **Full Game Loop:** 15 min
- **Admin Commands:** 10 min
- **Data Sync:** 5 min
- **Final Check:** 2 min
- **Total:** ~40 minutes

---

## ✅ Success Criteria

**Phase 4 is READY FOR PRODUCTION if:**

1. ✅ Smoke test passes (UI loads, no errors)
2. ✅ Full game loop works (catch, upgrade, unlock, hatch all working)
3. ✅ Zone button changes to "Visit" within 1 second
4. ✅ Coins don't disappear after `/coin` command
5. ✅ Zone buttons don't overlap when scrolling
6. ✅ Zero ERROR messages in output log

---

## 🚀 What's Next

- **If tests pass:** Document results → Phase 4 is production-ready
- **If tests fail:** Check READY_FOR_STUDIO.md troubleshooting section
- **After Phase 4:** Consider Phase 5 work (advanced admin tools)

---

## 📚 Reference Documents

Open these while testing for quick reference:

1. **FINAL_CHECKLIST.md** - Step by step (THIS IS YOUR MAIN GUIDE)
2. **READY_FOR_STUDIO.md** - Troubleshooting if things break
3. **Testing tips** - What to watch for (above)

---

**You're all set! Follow FINAL_CHECKLIST.md and you'll be golden.** 🎮

Good luck! Let me know if you hit any issues.
