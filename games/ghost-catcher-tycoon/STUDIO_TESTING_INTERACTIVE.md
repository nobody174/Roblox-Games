# 🎮 Studio Testing — Interactive Checklist

**Date Started:** _______________
**Tester Name:** _______________

---

## ✅ Pre-Testing Setup (Do This First!)

- [ ] Copy `src/server/systems/*.lua` → Studio `ServerScriptService/systems/`
- [ ] Copy `src/server/*.lua` (except systems/) → Studio `ServerScriptService/`
- [ ] Copy `src/client/*.lua` → Studio `StarterPlayer/StarterCharacterScripts/`
- [ ] Copy `src/shared/EquipmentData.lua` → Studio `ReplicatedStorage/shared/`
- [ ] Copy updated `ZONE_AUTO_BUILDER.lua` → Studio `ServerScriptService/`
- [ ] Delete old `ZoneContainer` folder in Workspace (to regenerate)
- [ ] Open Output console (View → Output)
- [ ] Ready to test!

---

## 🚀 Test 1: Spawn & Initialization

**Goal:** Verify all systems load without errors

- [ ] Launch game, player spawns in Starting Area
- [ ] **Check console:** `[PHASE 4] Equipment systems loaded`
- [ ] **Check console:** `[PHASE 4] Progression systems loaded`
- [ ] **Check console:** `[PHASE 4] Zone unlock system loaded`
- [ ] **Check console:** `[PHASE 4] Quest system loaded`
- [ ] **Check console:** `[PHASE 4] Data persistence loaded`
- [ ] **Check console:** `[PHASE 4] Equipment inventory initialized for [PlayerName]`
- [ ] **Check console:** `[PHASE 4] Progression systems initialized for [PlayerName]`
- [ ] **Check console:** `[PHASE 4] Zone unlock manager initialized for [PlayerName]`
- [ ] **Check console:** `[PHASE 4] Quest manager initialized for [PlayerName]`
- [ ] **Check console:** `[PHASE 4] Data persistence initialized for [PlayerName]`
- [ ] No red errors in console

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any errors or issues here)



```

---

## 🎒 Test 2: Equipment Inventory

**Goal:** Verify player starts with Basic Net and can see equipment UI

- [ ] Player starts with "Basic Net" equipment
- [ ] Equipment slot UI appears on screen (bottom-left or accessible)
- [ ] Equipment shows: Name, Tier color, Charge time, Energy cost
- [ ] Catch rates display: Common 100%, Uncommon 80%, Rare 40%, Epic 10%, Legendary 0%, Corrupted 0%
- [ ] Can see owned equipment list (should have only Basic Net at start)
- [ ] UI is readable and not broken

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 👻 Test 3: Ghost Spawning

**Goal:** Verify ghosts spawn in zones with correct rarities

- [ ] Walk to any zone (Whisper Woods, Foggy Fields, etc.)
- [ ] Ghosts appear (should see 1-2 ghosts in zone)
- [ ] Ghosts have correct rarity colors:
  - [ ] Common = Gray
  - [ ] Uncommon = Green
  - [ ] Rare = Blue
  - [ ] Epic = Purple
  - [ ] Legendary = Gold
  - [ ] Corrupted = Dark Red
- [ ] Hover over ghost → Ghost Info Panel appears
- [ ] Ghost Info shows:
  - [ ] Ghost name
  - [ ] Rarity with star rating (⭐⭐⭐ = Rare)
  - [ ] Success rate with current equipment (e.g., "85% ✅")
  - [ ] Reward preview: "+X XP | +Y Coins"
  - [ ] "Press [E] to catch" hint
- [ ] Ghost Info colors match rarity

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 💥 Test 4: Catch Attempt - SUCCESS Path

**Goal:** Catch a Common ghost with Basic Net (should always succeed)

- [ ] Target Common ghost (gray color)
- [ ] Press E to start charge
- [ ] Charge indicator appears at bottom center
- [ ] Bar fills: ▓▓▓░░░░░░ with percentage display
- [ ] Timer counts down (e.g., "3 seconds")
- [ ] Bar fills completely, charge finishes
- [ ] ✅ Success notification appears:
  - [ ] Shows "Caught [GhostName]!"
  - [ ] Shows "+X XP"
  - [ ] Shows "+Y Coins"
  - [ ] Green color theme
- [ ] Ghost disappears from world
- [ ] HUD updates: Coin count increases, Ghost count increases
- [ ] **Check console:** `[PHASE 4] [PlayerName] caught [GhostName] (Common) for X coins!`

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## ❌ Test 5: Catch Attempt - FAILURE Path

**Goal:** Try to catch Rare ghost with Basic Net (should fail most times)

- [ ] Find a Rare ghost (blue color)
- [ ] Press E to charge
- [ ] Charge indicator appears and fills
- [ ] After charge completes:
  - [ ] 50% chance: ❌ Ghost escaped notification
    - Shows success rate and your roll
    - Shows "Try stronger equipment"
    - Orange color theme
  - [ ] 50% chance: ✅ Caught (if lucky!)
- [ ] If failed: Ghost stays alive, energy was consumed
- [ ] **Check console:** Attempt logged

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## ⚡ Test 6: Energy System

**Goal:** Verify energy is consumed on catch attempts

- [ ] Current energy shows on HUD
- [ ] Attempt a catch:
  - [ ] Energy decreases (by 10 for Basic Net)
  - [ ] Can still attempt if energy ≥ cost
- [ ] If energy too low:
  - [ ] Try to catch with not enough energy
  - [ ] Warning: "Not enough energy! (X/10)"
  - [ ] Catch is blocked
- [ ] Energy regenerates over time (slow, watch for ~30 seconds)

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 📈 Test 7: Level Up - Basic

**Goal:** Catch ghosts, accumulate XP, trigger level-up

- [ ] Catch 10-15 Common ghosts (each gives ~25 XP base)
- [ ] Watch XP counter on HUD
- [ ] After enough XP, level-up notification appears:
  - [ ] Shows "LEVEL UP! Level X → X+1"
  - [ ] Shows "+1 Skill Point Available"
  - [ ] Shows new unlock (if applicable)
- [ ] **Check console:** `[PHASE 4] [PlayerName] leveled up to X!`
- [ ] Level number updates on HUD
- [ ] Skill points counter increases

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🗺️ Test 8: Zone Unlock on Level-Up

**Goal:** Verify zones unlock automatically when leveling to required level

- [ ] Continue leveling until you reach **Level 10**
- [ ] Zone unlock notification appears:
  - [ ] "Zone Unlocked: Foggy Fields"
  - [ ] Shows zone details
- [ ] Walk towards Foggy Fields zone
- [ ] Can enter zone (no invisible wall)
- [ ] Ghosts spawn in new zone
- [ ] Ghost pool changes (different ghost types)
- [ ] Rewards in this zone are higher (check coins for same rarity ghost)
- [ ] **Check console:** `[PHASE 4] Zone unlock check...`

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🎯 Test 9: Zone Multipliers

**Goal:** Verify harder zones give more XP/coins for same ghost rarity

- [ ] Catch Common ghost in **Whisper Woods** (starting zone)
  - [ ] Note coins earned (base 50 × 1.0 multiplier = 50 coins)
  - [ ] Note XP earned (base 25 × 1.0 multiplier = 25 XP)
- [ ] Walk to **Foggy Fields** (zone multiplier 1.2×)
- [ ] Catch Common ghost there
  - [ ] Should earn ~60 coins (50 × 1.2)
  - [ ] Should earn ~30 XP (25 × 1.2)
- [ ] Difference is visible

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 📜 Test 10: Quest System (Daily Quests)

**Goal:** Verify quests unlock at Level 25 and track properly

- [ ] Continue leveling to **Level 25**
- [ ] Quest log/panel becomes available
- [ ] See active daily quests (should show 3-5 quests):
  - [ ] "Catch 5 Common ghosts" (progress tracker)
  - [ ] "Catch a ghost in each zone" 
  - [ ] "Earn 10,000 coins"
  - [ ] etc.
- [ ] Catch ghosts and watch progress update in real-time
- [ ] When quest completes:
  - [ ] Notification: "Quest Complete! [Name]"
  - [ ] Shows rewards: Coins + XP
  - [ ] Progress bar fills 100%
- [ ] Can claim rewards and move to next quest
- [ ] **Check console:** Quest completion logged

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🔥 Test 11: Quest Streak System

**Goal:** Verify streak bonuses apply

- [ ] Complete a daily quest (any one)
- [ ] Next day: Streak counter shows "1 day"
- [ ] Complete another quest
- [ ] Streak shows "2 days"
- [ ] Complete quest day 3:
  - [ ] Notification: "+50% quest reward bonus!"
  - [ ] Verify next quest rewards are 50% higher
- [ ] Note: This may take multiple days IRL or require time manipulation in Studio

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL / ⏭️ SKIP (time-dependent)

**Notes:**
```
(Write any issues or observations)



```

---

## 💾 Test 12: Data Persistence - Save

**Goal:** Verify data saves during gameplay

- [ ] Play for ~5 minutes:
  - [ ] Catch ghosts
  - [ ] Level up
  - [ ] Unlock zones
  - [ ] Complete quests
- [ ] **Check console:** Every 30 seconds, should see `[PHASE 4] Saved player data...`
- [ ] Or manually trigger save by walking away from game area briefly
- [ ] No errors in console during saves

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 💾 Test 13: Data Persistence - Load

**Goal:** Verify data loads correctly after rejoin

- [ ] Note your current stats:
  - [ ] Level: _______
  - [ ] Coins: _______
  - [ ] Ghosts caught: _______
  - [ ] Zones unlocked: _______
  - [ ] Current location: _______
- [ ] Close game / Disconnect / Leave
- [ ] Rejoin game / Reconnect
- [ ] **Check stats match exactly:**
  - [ ] Level is same
  - [ ] Coins are same
  - [ ] Ghost count is same
  - [ ] Unlocked zones are same
- [ ] Can continue from where you left off

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🏆 Test 14: Equipment Progression

**Goal:** Verify can purchase and equip new equipment

- [ ] Catch ghosts until you have 500+ coins
- [ ] Level up to **Level 5**
- [ ] Check equipment menu
- [ ] "Reinforced Net" should be available (500 coins, Level 5)
- [ ] Purchase it
  - [ ] Coins decrease by 500
  - [ ] Equipment appears in owned list
- [ ] Equip Reinforced Net
  - [ ] Equipment slot now shows "Reinforced Net"
  - [ ] Catch rates update (higher vs Uncommon/Rare)
- [ ] Go catch Uncommon ghost
  - [ ] Success rate is now 95% (vs 80% with Basic Net)
  - [ ] Can actually catch them reliably

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🎨 UI/UX Test

**Goal:** Verify all UI is readable and responsive

- [ ] Equipment slot UI:
  - [ ] Text is readable (not too small, good contrast)
  - [ ] Colors make sense (tier colors are distinct)
  - [ ] Layout is clean (no overlapping elements)
  - [ ] Works on different screen sizes/zoom levels
  
- [ ] Ghost Info Panel:
  - [ ] Appears when targeting ghost
  - [ ] Disappears when not targeting
  - [ ] Text is readable
  - [ ] Colors match ghost rarity
  
- [ ] Charge Indicator:
  - [ ] Smooth animation
  - [ ] Percentage updates smoothly
  - [ ] Color changes are visible
  
- [ ] Notifications (success/failure):
  - [ ] Appear at top center
  - [ ] Auto-dismiss after 2-3 seconds
  - [ ] Multiple notifications don't stack/overlap
  - [ ] Colors (green/red/orange) are clear

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## ⚡ Performance Test

**Goal:** Verify no lag or memory issues

- [ ] Play for 10+ minutes:
  - [ ] Catch 20+ ghosts
  - [ ] Level up multiple times
  - [ ] Open/close UI panels frequently
  
- [ ] Watch for:
  - [ ] No frame rate drops
  - [ ] No stutters or freezes
  - [ ] UI responds instantly
  - [ ] Notifications appear smoothly
  
- [ ] Check memory usage (Studio diagnostics):
  - [ ] Stable or slowly increasing
  - [ ] No sudden spikes
  - [ ] Not climbing indefinitely

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 🐛 Console Debug Check

**Goal:** Verify all systems are logging correctly

- [ ] Check console for errors (red text):
  - [ ] Module loading: Any `error loading` messages?
  - [ ] Remotes: Any `undefined remote` messages?
  - [ ] Systems: Any function calls on nil?
  
- [ ] Expected console messages should include:
  - [ ] `[PHASE 4]` prefixed messages (server logs)
  - [ ] Catch attempts logged
  - [ ] Level ups logged
  - [ ] Zone unlocks logged
  - [ ] Quest events logged
  - [ ] Save events logged
  
- [ ] No yellow warnings that look like errors

**Status:** ✅ PASS / ❌ FAIL / ⚠️ PARTIAL

**Notes:**
```
(Write any issues or observations)



```

---

## 📊 Final Results

### Overall Status

- [ ] All core systems working
- [ ] No critical bugs found
- [ ] Performance is acceptable
- [ ] Ready for Phase 2 development

### Tests Passed: _____ / 14
### Tests Failed: _____ / 14
### Tests Skipped: _____ / 14

---

## 🚨 Critical Issues Found

**If any tests failed, list them here:**

```
Issue #1: 
Description: 
Steps to reproduce: 
Expected: 
Actual: 

Issue #2:
Description:
Steps to reproduce:
Expected:
Actual:

(Continue for each issue...)
```

---

## ⚠️ Minor Issues / Polish Suggestions

```
Polish #1: 


Polish #2:


(Continue...)
```

---

## ✨ What Worked Great

```
- 


- 


(Continue...)
```

---

## 🎯 Balance Feedback

### Progression Speed
- [ ] Too slow (takes forever to level)
- [ ] Just right
- [ ] Too fast (levels too quickly)

**Notes:** 
```


```

### Equipment Progression
- [ ] Too expensive
- [ ] Just right
- [ ] Too cheap

**Notes:**
```


```

### Zone Difficulty
- [ ] Too easy
- [ ] Just right
- [ ] Too hard

**Notes:**
```


```

### Quest Rewards
- [ ] Too stingy
- [ ] Just right
- [ ] Too generous

**Notes:**
```


```

---

## 📝 Tester Sign-Off

**Testing Completed:** _______________

**Tester Signature:** _______________

**Recommended Next Steps:**

```
1. 

2. 

3. 

```

---

*Interactive Testing Checklist v1.0*
*Save this file and check off items as you test*
*All sections are editable - modify as needed*
