# Agent Task Prompts — Parallel Development

Use these prompts in a separate Claude chat window to parallelize development.
Each agent works independently and reports when done.

---

## TASK 1: Level/XP System (Priority: HIGH)

**Open new chat and paste this prompt:**

```
You are building a Level/XP progression system for Ghost Catcher Tycoon (a Roblox game).

Context:
- Game: Ghost Catcher Tycoon, catch ghosts, progress through 100 levels
- Repository: https://github.com/nobody174/roblox-games (games/ghost-catcher-tycoon/)
- Related files already built:
  * src/shared/EquipmentData.lua - Equipment definitions
  * src/server/PlayerInventory.lua - Player stats management
  * src/server/CatchingSystem.lua - Catch attempt logic

Your task: Build the Level/XP system

Create these Lua files in src/server/:

1. **LevelSystem.lua** - Core level progression module
   - Track player XP and level (1-100)
   - XP requirements: 
     * Levels 1-10: 100 XP per level
     * Levels 11-25: 250 XP per level
     * Levels 26-50: 500 XP per level
     * Levels 51-75: 1,000 XP per level
     * Levels 76-100: 2,500 XP per level
   - Award 1 skill point per level
   - Notify when leveling up
   - Get player level, current XP, XP to next level, skill points
   - Add XP to player (called by CatchingSystem after catch)

2. **SkillTree.lua** - Skill point allocation system
   - 5 skill categories:
     * Catching Bonuses: Better Net (+2% catch, 5pts), Steady Aim (+3% accuracy, 4pts)
     * Energy & Stamina: Energy Pool (+5 max, 2pts), Energy Regen (+1/s, 3pts), Power Surge (+10% dmg 3 catches, 5pts)
     * Coins & Rewards: Greed (+5% coins, 3pts), Jackpot (+10% rare spawn, 4pts), Bonus XP (+10% xp, 3pts)
     * Movement: Speed Burst (+20% run 5s, 4pts), Ghost Sense (see ghosts 50 studs, 5pts), Lucky Find (+chance coins, 2pts)
   - Track which skills player has and their levels
   - Calculate bonus multipliers (catch rate, energy, coins, xp)
   - Allocate skill points
   - Get player's current skill bonuses

3. **PlayerProgression.lua** - Unified progression manager
   - Combine LevelSystem + SkillTree + PlayerInventory
   - Single interface for all progression (level, xp, skills, equipment)
   - Grant equipment unlocks when player levels up
   - Grant zone unlocks when player levels up
   - Calculate final catch/coin/energy bonuses from all skills

Design notes:
- Each file should be well-documented with function signatures
- Include helper functions for UI (get player stats, level progress bar %, etc)
- Support skill resets (player can unallocate points)
- All functions should work with userId or player object
- Return data structures suitable for client UI updates

Deliverables:
- Create the 3 files with complete implementations
- Create LEVEL_SYSTEM_SUMMARY.md documenting all functions and usage
- Commit to git with message: "feat: Implement level/XP and skill systems"
- Report when done with file locations and a 2-line summary

Repository: https://github.com/nobody174/roblox-games
Work in: games/ghost-catcher-tycoon/src/server/
```

---

## TASK 2: Client Equipment UI (Priority: HIGH)

**Open new chat and paste this prompt:**

```
You are building client-side UI for the Equipment System in Ghost Catcher Tycoon (Roblox game).

Context:
- Game: Ghost Catcher Tycoon, catch ghosts with equipment progression
- Repository: https://github.com/nobody174/roblox-games (games/ghost-catcher-tycoon/)
- Equipment system already built on server side
- Server has these remotes:
  * PurchaseEquipment(equipmentName) - Buy equipment
  * EquipEquipment(equipmentName) - Equip item
  * GetEquipmentInfo(ghostRarity) - Get current equipment stats
  * GetPlayerEquipment() - Get all owned equipment

Your task: Build Client Equipment UI

Create these LocalScripts in StarterGui or as modules in StarterPlayer/StarterCharacterScripts:

1. **EquipmentSlotUI.lua** - Equipment selection panel
   - Display current equipped equipment with:
     * Equipment name & tier (color-coded: gray/blue/gold/orange/red)
     * Catch rate vs different rarities (Common, Uncommon, Rare, Epic, Legendary, Corrupted)
     * Charge time
     * Energy cost per attempt
     * Equipment description
   - Show list of owned equipment to switch between
   - Quick swap buttons
   - Show equipment rarity as colored borders
   - Update when equipment changes

2. **GhostInfoPanel.lua** - Show on targeting ghost
   - Popup when aiming at ghost shows:
     * Ghost name & rarity (color-coded star rating)
     * "With Current Equipment: 85% success rate ✅"
     * Rewards if caught: "+100 XP | +250 Coins"
     * Press E to catch button hint
   - Update success rate based on current equipment vs ghost rarity
   - Hide when not targeting ghost
   - Smooth fade in/out animations

3. **ChargeIndicator.lua** - Charge timer/visual
   - Show while holding charge button
   - Visual bar: ▓▓▓░░░░░░ 50% (3 seconds)
   - Color changes based on charge progress
   - Sound effect while charging
   - Text: "Charging..." then equipment name
   - Cancel if player releases button early

4. **CatchFeedback.lua** - Catch attempt result notifications
   - Show success popup (green):
     * ✅ CAUGHT!
     * +100 XP
     * +250 Coins
     * Rare Ghost
     * Auto-dismiss after 2 seconds
   - Show failure popup (orange):
     * ❌ ESCAPED!
     * Ghost dodged!
     * Equipment -1 Durability (future)
     * Try stronger gear
   - Show energy error popup (red):
     * Not enough energy!
     * 30/40 energy needed

Design requirements:
- Use ScreenGui with proper anchoring (responsive)
- All text should be Gotham font, size 12-16
- Color scheme: Dark background (50% opacity), bright text
- Smooth animations (fade in/out, slide)
- Works on mobile and desktop
- Must handle rapid consecutive catches smoothly
- No lag or memory leaks

Deliverables:
- Create 4 LocalScripts with complete implementations
- Create CLIENT_UI_SUMMARY.md with:
  * How to place each script in game
  * Server remote call examples
  * Customization notes (colors, sizes, etc)
  * Screenshot mockups (text descriptions)
- Commit to git with message: "feat: Implement client equipment UI"
- Report when done with file locations and summary

Repository: https://github.com/nobody174/roblox-games
Work in: games/ghost-catcher-tycoon/src/client/ or StarterGui (describe setup)
```

---

## TASK 3: Zone Unlock System (Priority: MEDIUM)

**Open new chat and paste this prompt:**

```
You are building a Zone Unlock system for Ghost Catcher Tycoon.

Context:
- Game: Ghost Catcher Tycoon, 12 zones to unlock progressively
- Current zones: Starting Area, Whisper Woods, Foggy Fields, Gloomy Graveyard, Electro Alley, 
  Frostbite Caverns, Sunken Spirit Reef, Clocktower District, Astral Observatory, 
  Phantom Fortress, The Rift, Eternity Nexus
- Server has LevelSystem.lua (being built in parallel)

Your task: Build Zone Unlock system

Create: src/server/ZoneUnlockManager.lua

Features:
1. Define unlock requirements per zone:
   - Foggy Fields: Level 10, 1,000 coins
   - Gloomy Graveyard: Level 20, 5,000 coins
   - Electro Alley: Level 30, 10,000 coins
   - Frostbite Caverns: Level 40, 20,000 coins
   - Sunken Spirit Reef: Level 50, 30,000 coins
   - Clocktower District: Level 60, 40,000 coins
   - Astral Observatory: Level 70, 50,000 coins
   - Phantom Fortress: Level 75, 60,000 coins
   - The Rift: Level 85, 75,000 coins
   - Eternity Nexus: Level 95, 100,000 coins
   - Starting Area & Whisper Woods: Free (start unlocked)

2. Functions:
   - canAccessZone(userId, zoneName) - Check if player can enter
   - getUnlockedZones(userId) - List all unlocked zones
   - getZoneRequirements(zoneName) - Get level & coin cost
   - requestZoneUnlock(userId, zoneName) - Attempt to unlock (pay coins, check level)
   - getZoneProgress(userId) - % complete towards next zone unlock
   - getNearestUnlockedZone(userId, currentZone) - For navigation hints

3. Integration:
   - Hook into LevelSystem to auto-unlock zones when leveling up
   - Hook into CatchingSystem to check zone access before spawning ghosts
   - Block ghosts from spawning in non-unlocked zones

Design notes:
- Support both coin-based and level-based unlocks
- Some zones can be "previewed" (visible but no ghosts spawn)
- Return data for UI (next zone unlock, progress bar)
- Error handling for invalid zones

Deliverables:
- Create ZoneUnlockManager.lua with complete implementation
- Create ZONE_UNLOCK_SUMMARY.md with:
  * All unlock requirements table
  * Function signatures & usage examples
  * Integration points with other systems
- Commit to git with message: "feat: Implement zone unlock system"
- Report when done with summary

Repository: https://github.com/nobody174/roblox-games
Work in: games/ghost-catcher-tycoon/src/server/
```

---

## TASK 4: Quest System (Priority: MEDIUM)

**Open new chat and paste this prompt:**

```
You are building a Quest system for Ghost Catcher Tycoon.

Context:
- Game: Ghost Catcher Tycoon, progression-based game with quests
- Player level system is being built in parallel
- Quests unlock at Level 25

Your task: Build Quest system (Daily + Challenge)

Create: src/server/QuestManager.lua

Features:

1. Quest Types:
   A) DAILY QUESTS (reset every 24 hours, unlock at Level 25):
      - "Catch 5 Common ghosts" → 500 coins + 100 XP
      - "Catch 2 Rare ghosts" → 2,000 coins + 300 XP
      - "Catch a ghost in each zone" → 1,000 coins + 250 XP
      - "Earn 10,000 coins" → Bonus 2,000 coins + 200 XP
      - "Catch 1 Legendary ghost" → 5,000 coins + 500 XP
      
   B) CHALLENGE QUESTS (one-time, permanent unlock at Level 35):
      - "Catch 10 Corrupted ghosts without dying" → 50,000 coins + 5,000 XP + Rare cosmetic
      - "Catch ghosts in all 12 zones in one session" → 30,000 coins + 3,000 XP + Weapon skin
      - "Beat personal record: most catches in 1 hour" → Leaderboard ranking + Season cosmetic

2. Functions:
   - getActiveQuests(userId) - Get current quests + progress
   - completeQuest(userId, questId) - Finish quest, award rewards
   - getQuestProgress(userId, questId) - % complete
   - trackQuestEvent(userId, eventType, data) - Log catch, zone visit, coin earn, etc
   - resetDailyQuests() - Called once per day (auto-reset)
   - getQuestReward(questId) - Get coins + XP for quest
   - getCompletedQuestCount(userId) - Total completed all-time

3. Streak System:
   - Complete quest 3 days in a row → +50% reward next quest
   - Complete quest 7 days in a row → Unlock special cosmetic
   - Complete quest 30 days in a row → Title: "Dedication"
   - Track streak count, last completion date

4. Integration:
   - Hook into CatchingSystem.attemptCatch() to track "catch events"
   - Hook into ZoneManager to track "zone visits"
   - Hook into PlayerInventory to track "coins earned"
   - Automatically complete quests when conditions met
   - Award bonuses automatically

Design notes:
- Quest data persists (needs database eventually)
- Return UI-friendly data structures
- Support quest cancellation/skip
- Include helper for "hint" next quest
- Prevent quest spam/exploits (cooldown on quest completion)

Deliverables:
- Create QuestManager.lua with complete implementation
- Create QUEST_SYSTEM_SUMMARY.md with:
  * All 8 quests listed with rewards
  * Function signatures & usage
  * Integration points with CatchingSystem/ZoneManager
  * Streak bonus formula
- Commit to git with message: "feat: Implement quest system"
- Report when done with summary

Repository: https://github.com/nobody174/roblox-games
Work in: games/ghost-catcher-tycoon/src/server/
```

---

## TASK 5: Data Persistence (Priority: MEDIUM)

**Open new chat and paste this prompt:**

```
You are building a Data Persistence system for Ghost Catcher Tycoon.

Context:
- Game: Ghost Catcher Tycoon, Roblox game with player progression
- Many systems being built: EquipmentSystem, LevelSystem, SkillTree, QuestManager, ZoneUnlockManager
- Currently all data is in memory only (lost on server restart)
- Need to save player data to a persistent store

Your task: Build Data Persistence layer

Create: src/server/DataPersistence.lua

Features:

1. Support multiple backends (but implement JSON file first):
   - Local JSON files (for testing)
   - Roblox DataStoreService (for production)
   - Fallback to memory if save fails

2. Data to persist:
   - Player level, XP, skill points
   - Owned equipment, equipped equipment
   - Coins, energy
   - Unlocked zones
   - Completed quests, daily quest state, streak count
   - Ghost inventory (caught ghosts)
   - Custom cosmetics/skins owned

3. Functions:
   - savePlayerData(userId, playerData) - Save all player data
   - loadPlayerData(userId) - Load all player data
   - initializeNewPlayer(userId) - Create default profile
   - deletePlayerData(userId) - Wipe player (admin)
   - backupAllData() - Export all players to JSON
   - validateData(data) - Check data integrity
   - migrateData(oldVersion, newVersion) - Handle updates

4. Auto-save:
   - Save every 5 minutes (background)
   - Save on player leave (immediate)
   - Save on quest completion
   - Save on equipment purchase
   - Save on level up

5. Data Structure:
   ```
   {
     userId = 12345,
     createdAt = "2026-06-09T10:30:00Z",
     lastSaved = "2026-06-09T15:45:30Z",
     version = 1,
     
     progression = {
       level = 42,
       xp = 15000,
       skillPoints = 8,
     },
     
     equipment = {
       equipped = "QuantumDevice",
       owned = {"BasicNet", "ReinforcedNet", "QuantumDevice"},
     },
     
     resources = {
       coins = 125000,
       energy = 100,
       maxEnergy = 150,
     },
     
     zones = {
       unlockedZones = {"Starting Area", "Whisper Woods", "Foggy Fields", ...},
     },
     
     quests = {
       activeDaily = {quest1, quest2},
       completedToday = 1,
       streak = 5,
     },
     
     ghosts = {
       inventory = {...},
       totalCaught = 1250,
     },
   }
   ```

6. Error handling:
   - Retry failed saves
   - Corrupt data detection
   - Fallback to last known good save
   - Log all errors

Design notes:
- Use non-blocking async saves
- Prevent duplicate saves (debounce)
- Handle network failures gracefully
- Support data encryption (future)
- Validate all loaded data before use

Deliverables:
- Create DataPersistence.lua with complete implementation
- Support JSON files + stub for DataStoreService
- Create DATA_PERSISTENCE_SUMMARY.md with:
  * Function signatures & usage examples
  * Data structure schema
  * Auto-save events & timing
  * Error handling approach
  * Migration guide for updates
- Commit to git with message: "feat: Implement data persistence layer"
- Report when done with summary

Repository: https://github.com/nobody174/roblox-games
Work in: games/ghost-catcher-tycoon/src/server/
```

---

## How to Use These Prompts

1. **Open a new Claude chat window** (separate from this one)
2. **Copy one of the prompts above** (pick one task)
3. **Paste it into the new chat** and press Send
4. **The agent will work on it independently**
5. **They'll commit & push to GitHub when done**
6. **You can pull their changes when ready**

---

## Recommended Parallel Order

**Start these 3 in parallel immediately:**
1. Task 1: Level/XP System (HIGH priority, needed by many systems)
2. Task 2: Client Equipment UI (HIGH priority, needed for testing)
3. Task 3: Zone Unlock System (MEDIUM priority, blocks some gameplay)

**Start these 2 after those 3 are done:**
4. Task 4: Quest System (MEDIUM priority, nice-to-have for progression)
5. Task 5: Data Persistence (MEDIUM priority, essential before live)

---

*Created: 2026-06-09*
