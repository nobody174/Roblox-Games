# Studio Testing Checklist — Full Integration

## 🚀 Ready to Test

All 5 systems are fully integrated into MainServer_Phase4_Extended.lua

**Files Involved:**
- MainServer_Phase4_Extended.lua (main entry point)
- EquipmentData.lua → Equipment definitions
- PlayerInventory.lua → Equipment inventory
- CatchingSystem.lua → Catch mechanics with rewards
- LevelSystem.lua → Level/XP progression
- SkillTree.lua → Skill allocation
- PlayerProgression.lua → Unified progression manager
- ZoneUnlockManager.lua → Zone progression
- QuestManager.lua → Daily/Challenge quests
- DataPersistence.lua → Save/load system
- Client UI components (Equipment, Ghost Info, Charge, Feedback)

---

## ✅ Pre-Testing Checklist

- [ ] Copy updated ZONE_AUTO_BUILDER.lua to Studio (terrain materials fixed)
- [ ] Copy MainServer_Phase4_Extended.lua to Studio ServerScriptService
- [ ] Copy all src/server/systems/*.lua to Studio ServerScriptService/systems/
- [ ] Copy all src/client/*.lua to StarterPlayer/StarterCharacterScripts/ or StarterGui
- [ ] Copy src/shared/EquipmentData.lua to ReplicatedStorage/shared/
- [ ] Verify all module paths match (check requires in MainServer)

---

## 🎮 Basic Gameplay Flow Test

### 1. **Spawn & Initialization**
- [ ] Player spawns in Starting Area
- [ ] No errors in output console
- [ ] Check console: Should see "[PHASE 4] Equipment systems loaded"
- [ ] Check console: Should see "[PHASE 4] Progression systems loaded"
- [ ] Check console: Should see "[PHASE 4] Data persistence loaded"
- [ ] Check console: Should see initialization messages for each system

### 2. **Equipment Test**
- [ ] Player starts with Basic Net (free)
- [ ] Can see equipment slot with tier info
- [ ] Equipment shows: Name, Charge time, Energy cost, Catch rates
- [ ] Catch rates show vs each rarity (Common, Uncommon, Rare, etc.)

### 3. **Ghost Spawning**
- [ ] Ghosts spawn in the zone you're in
- [ ] Can see ghost with correct rarity color
- [ ] Hover over ghost: Ghost Info Panel appears
- [ ] Ghost Info shows: Name, Rarity (star rating), Success rate
- [ ] Success rate matches current equipment

### 4. **Catch Attempt**
- [ ] Click ghost or press E to catch
- [ ] Charge indicator appears and fills up
- [ ] Bar shows percentage and time
- [ ] After charge completes, catch is attempted

### 5. **Success Path (Common ghost with Basic Net)**
- [ ] ✅ Ghost caught notification appears
- [ ] Shows: "+X coins, +Y XP"
- [ ] Ghost disappears
- [ ] UI updates with new coin/ghost count

### 6. **Failure Path (Try Rare ghost with Basic Net)**
- [ ] ❌ Ghost escaped notification
- [ ] Ghost stays alive
- [ ] Energy was still consumed
- [ ] Shows success rate and your roll

### 7. **Level Up**
- [ ] Catch ~10 ghosts in early zones
- [ ] Should level up after accumulating enough XP
- [ ] Level up notification appears
- [ ] Level displays in HUD
- [ ] Skill points become available

### 8. **Zone Unlock**
- [ ] At Level 10, unlock "Foggy Fields"
- [ ] Can now walk to that zone
- [ ] Ghosts spawn in new zone
- [ ] Different ghost types appear
- [ ] Zone reward multiplier applies (higher coins/XP)

### 9. **Quest System**
- [ ] At Level 25, daily quests unlock
- [ ] Quest log shows active quests
- [ ] Quests like "Catch 5 Common" track progress
- [ ] Complete quest → reward notification
- [ ] Streak bonus applies on next day

### 10. **Data Persistence**
- [ ] Catch ghosts, level up, unlock zones
- [ ] Close game (or leave)
- [ ] Rejoin game
- [ ] All data persisted: Level, coins, ghosts, zones, equipment

---

## 🔧 Debug Checks

If something breaks, check console for:

1. **Module Loading Errors**
   - Look for: `[PHASE 4] ... loaded` messages
   - If missing, module path is wrong in MainServer

2. **Player Initialization Errors**
   - Look for: `[PHASE 4] ... initialized for [PlayerName]`
   - If missing, initialization function has wrong signature

3. **Catch Attempt Errors**
   - Look for: `[PHASE 4] ... attempted to catch ...`
   - Check if CatchingSystem is being called
   - Check if LevelSystem:addXP is being called

4. **Data Persistence Errors**
   - Look for: `[PHASE 4] Saved player data...`
   - Check if DataPersistence functions exist
   - Verify save/load format matches expectations

---

## 🎯 Performance Checks

- [ ] No lag when catching ghosts
- [ ] No memory leaks (check players in game for hours)
- [ ] Level-up happens smoothly without stutters
- [ ] Quest tracking doesn't cause freezes
- [ ] Data saves happen without blocking game

---

## 📊 Balance Testing

### Early Game (Levels 1-10)
- [ ] Catching Common ghosts feels rewarding
- [ ] XP gain feels reasonable (level up ~10-15 ghosts)
- [ ] Equipment purchases feel achievable (~5-10 catches for Reinforced Net)

### Mid Game (Levels 11-25)
- [ ] Catching Rare ghosts is challenging but possible with right equipment
- [ ] Zone progression opens naturally
- [ ] Quest system feels engaged but not grindy
- [ ] Daily quests provide good incentive to log back in

### Late Game (Levels 26+)
- [ ] Equipment progression feels rewarding
- [ ] Zone difficulties scale appropriately
- [ ] Coin/XP multipliers make sense
- [ ] Skills provide meaningful bonuses

---

## 🐛 Known Issues / Todos

| Issue | Status | Notes |
|---|---|---|
| Neon/Glass terrain materials | ✅ Fixed | Changed to Concrete/Slate/Ice |
| Equipment catch rates | ✅ Ready | All 9 tiers defined |
| Zone unlocks | ✅ Ready | Auto-unlock on level-up |
| Quest tracking | ✅ Ready | Event system hooked |
| Data persistence | ✅ Ready | Auto-save every 30s |
| Client UI integration | ⚠️ Needs work | Wires to remotes needed |
| Energy regeneration | ❌ Not built | Deferred to Phase 2 |
| Skill bonuses application | ⚠️ Partial | Catch rate bonus implemented |
| Prestige system | ❌ Not built | Deferred to Phase 2 |

---

## 🎬 Next Steps After Testing

1. **If testing passes:**
   - [ ] Document any balance changes needed
   - [ ] Plan Phase 2 features (energy regen, prestige, cosmetics)
   - [ ] Create roadmap for next month

2. **If bugs found:**
   - [ ] Create issues in GitHub
   - [ ] Document exact reproduction steps
   - [ ] Note console errors
   - [ ] Assign to developers

3. **If performance issues:**
   - [ ] Profile with Roblox Profiler
   - [ ] Identify bottleneck systems
   - [ ] Optimize or defer features

---

## 📝 Testing Notes

**Tester:** _______________
**Date:** _______________
**Duration:** _______________

### What Worked Well:
- 
- 
- 

### What Needs Fixing:
- 
- 
- 

### Balance Feedback:
- 
- 
- 

### Performance Notes:
- 
- 
- 

---

*Testing checklist created: 2026-06-09*
*All 5 systems integrated and ready for QA*
