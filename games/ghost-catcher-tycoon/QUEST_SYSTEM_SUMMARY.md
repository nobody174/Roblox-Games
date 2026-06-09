# Quest System Summary

## Overview
The Quest System provides players with structured progression goals through Daily Quests, Challenge Quests, and a Streak System. This document outlines the architecture and features.

## Files
- **QuestManager.lua** — Main quest management system
- **QuestSystem.lua** — Legacy quest system (can be deprecated)
- **QuestSystemTests.lua** — Test suite

## Architecture

### Daily Quests (Level 25+)
Available to players at level 25 and above. Reset every 24 hours.

| Quest | Target | Coins | XP | Notes |
|-------|--------|-------|-----|-------|
| Catch 5 Common Ghosts | 5 | 500 | 100 | Easiest entry quest |
| Catch 2 Rare Ghosts | 2 | 2,000 | 300 | Medium difficulty |
| Catch Ghost in Each Zone | 12 zones | 1,000 | 250 | Encourages exploration |
| Earn 10,000 Coins | 10k coins | 2,000 | 200 | Passive earner quest |
| Catch 1 Legendary Ghost | 1 | 5,000 | 500 | Hardest daily quest |

**Daily Rewards:** 500–5,000 coins + 100–500 XP per quest

### Challenge Quests (Level 35+)
One-time permanent quests that unlock at level 35. Non-repeatable.

| Quest | Target | Coins | Reward | Notes |
|-------|--------|-------|--------|-------|
| Catch 10 Corrupted without Dying | 10 Corrupted | 50,000 | 5,000 XP | Session-based, death resets |
| Catch in All 12 Zones (1 session) | 12 zones | 30,000 | 3,000 XP | Session must not break |
| Personal Record: Most Catches/Hour | N/A | N/A | Cosmetic + Leaderboard | Repeatable for leaderboard |

**Challenge Rewards:** High coin/XP payouts + cosmetic unlocks

### Streak System
Tracks daily quest completions and rewards consistency.

| Milestone | Reward |
|-----------|--------|
| 3 days | +50% coins/XP on next quest |
| 7 days | Cosmetic: 7 Day Streak Particles |
| 30 days | Title: "Dedication" |

**How it Works:**
- Completing any daily quest increments the streak
- Streak breaks if player doesn't complete any quest for 24+ hours
- Milestones award cosmetics and gameplay bonuses
- Does not reset after claiming rewards

## QuestManager API

### Initialization
```lua
local questManager = QuestManager:new()
questManager:setDataManager(dataManager)
questManager:setEventSystem(eventSystem)
questManager:initializePlayer(player)
```

### Core Functions

#### `getActiveQuests(player)`
Returns all active daily and challenge quests.
```lua
local quests = questManager:getActiveQuests(player)
-- Returns: { daily = {...}, challenges = {...} }
```

#### `trackQuestEvent(player, eventType, value)`
Tracks in-game events to update quest progress. Event types:
- `GhostCaught` — Pass ghost rarity (e.g., "Common", "Rare")
- `CoinsEarned` — Pass coin amount
- `ZoneVisited` — Pass zone name
- `CorruptedCaught` — Pass true/false

```lua
questManager:trackQuestEvent(player, "GhostCaught", "Rare")
questManager:trackQuestEvent(player, "CoinsEarned", 5000)
questManager:trackQuestEvent(player, "ZoneVisited", "Whisper Woods")
```

#### `completeQuest(player, questId)`
Completes a quest and awards rewards when ready to claim.
```lua
local success, rewards = questManager:completeQuest(player, "daily_catch_5_common")
if success then
    -- Rewards: { coins = X, xp = Y }
end
```

#### `resetDailyQuests(player)`
Manually reset a player's daily quests (normally automatic).
```lua
questManager:resetDailyQuests(player)
```

#### `getStreakInfo(player)`
Returns current streak data.
```lua
local streak = questManager:getStreakInfo(player)
-- Returns: { currentStreak, totalCompletions, lastCompletionDate, nextQuestMultiplier }
```

#### `playerDied(player)`
Called when player dies; resets "no-death" challenge quests.
```lua
questManager:playerDied(player)
```

## Event Integration

Emits the following events via EventSystem:

```lua
-- When quest is completed
eventSystem:emit("QuestCompleted", {
    player = player,
    questId = questId,
    questType = questType,
    rewards = { coins = X, xp = Y }
})

-- When streak milestone reached
eventSystem:emit("StreakMilestone", {
    player = player,
    streak = 3/7/30,
    reward = "Description of reward"
})
```

## Data Structure

### Player Quest Data
```lua
{
    dailyQuests = {
        {
            id = "daily_catch_5_common",
            questType = "CatchCommon",
            title = "Catch 5 Common Ghosts",
            target = 5,
            progress = 2,
            completed = false,
            claimed = false,
            rewards = { coins = 500, xp = 100 }
        },
        -- ... more quests
    },
    challengeQuests = {
        {
            id = "challenge_catch_10_corrupted",
            questType = "Catch10Corrupted",
            title = "Catch 10 Corrupted Ghosts Without Dying",
            target = 10,
            progress = 3,
            completed = false,
            claimed = false,
            rewards = { coins = 50000, xp = 5000 },
            playerDied = false,
            sessionStartTime = 1718000000
        },
        -- ... more challenges
    },
    streakData = {
        currentStreak = 5,
        lastCompletionDate = 1718000000,
        totalCompletions = 23,
        nextQuestMultiplier = 1.0,
        rewarded3Day = true,
        rewarded7Day = false,
        rewarded30Day = false
    },
    lastDailyReset = 1718000000
}
```

## Integration Points

### With DataManager
Requires these methods:
- `getPlayerData(player)` — Load quest data
- `updatePlayerData(player, data)` — Save quest data
- `addPlayerResource(player, resourceType, amount)` — Award coins/XP
- `unlockedCosmetic(player, cosmeticId)` — Unlock cosmetic rewards
- `awardTitle(player, titleId)` — Award titles

### With EventSystem
Requires method:
- `emit(eventName, data)` — Fire events for UI/notifications

### With Game Events
Call from appropriate systems:
```lua
-- In CatchingSystem.lua
questManager:trackQuestEvent(player, "GhostCaught", ghostRarity)

-- In CurrencySystem.lua
questManager:trackQuestEvent(player, "CoinsEarned", coinAmount)

-- In ZoneSystem.lua
questManager:trackQuestEvent(player, "ZoneVisited", zoneName)

-- In PlayerService.lua (when player dies)
questManager:playerDied(player)
```

## Future Enhancements
- Seasonal quests that rotate monthly
- Group/guild quests for multiplayer cooperation
- Quest chains (complete Quest A to unlock Quest B)
- Difficulty tiers with scaling rewards
- Custom quest creation for events

## Testing
Run QuestSystemTests.lua to validate:
- Quest initialization and reset timing
- Progress tracking accuracy
- Reward calculation
- Streak milestone detection
- Data persistence

---
**Last Updated:** 2026-06-09
**Version:** 1.0
