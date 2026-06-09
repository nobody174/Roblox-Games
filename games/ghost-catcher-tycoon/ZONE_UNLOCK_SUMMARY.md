# Zone Unlock System — Ghost Catcher Tycoon

## Overview
The Zone Unlock Manager controls progressive zone access in Ghost Catcher Tycoon. Players unlock zones by meeting level and coin requirements, creating a natural progression system that gates content.

## Zone Unlock Requirements

| Zone | Level Req | Coin Req | Difficulty |
|------|-----------|----------|------------|
| Foggy Fields | 10 | 1,000 | Easy |
| Gloomy Graveyard | 20 | 5,000 | Easy-Medium |
| Electro Alley | 30 | 10,000 | Medium |
| Frostbite Caverns | 40 | 20,000 | Medium-Hard |
| Sunken Spirit Reef | 50 | 30,000 | Hard |
| Clocktower District | 60 | 40,000 | Hard |
| Astral Observatory | 70 | 50,000 | Very Hard |
| Phantom Fortress | 75 | 60,000 | Very Hard |
| The Rift | 85 | 75,000 | Extreme |
| Eternity Nexus | 95 | 100,000 | Extreme/Endgame |

**Free Zones (No Requirements):**
- Starting Area
- Whisper Woods

## Core Functions

### Access & Status
- **`canAccessZone(userId, zoneName)`** — Check if player can access a zone
- **`getUnlockedZones(userId)`** — Get list of player's unlocked zones
- **`getRemainingZones(userId)`** — Get remaining zones with requirements
- **`getZoneRequirements(zoneName)`** — Get level and coin requirements for any zone

### Unlocking
- **`requestZoneUnlock(userId, zoneName, playerLevel, playerCoins)`** — Player requests unlock (deducts coins)
  - Returns `{success, reason, coinsDeducted, ...}`
  - Validates level + coin requirements before unlocking
  
- **`checkAutoUnlocks(userId, newLevel, playerCoins)`** — Called on level up
  - Auto-unlocks zones when level + coins both sufficient
  - Returns newly unlocked zones list

### UI Support
- **`getZoneUnlockInfo(userId, playerLevel, playerCoins)`** — Full unlock state for UI display
  - Returns array with `{name, isUnlocked, requiredLevel, requiredCoins, meetsLevel, meetsCoins}`

### Admin Tools
- **`forceUnlock(userId, zoneName)`** — Unlock zone without cost
- **`forceLock(userId, zoneName)`** — Lock a previously unlocked zone

### Lifecycle
- **`initializePlayer(userId)`** — Set up unlock tracking on player join
- **`removePlayer(userId)`** — Clean up on player leave

## Integration Points

### With LevelSystem
```lua
-- In LevelSystem:levelUp() callback:
local unlockResult = ZoneUnlockManager:checkAutoUnlocks(userId, newLevel, playerCoins)
if unlockResult.count > 0 then
    -- Notify player of new unlocks
end
```

### With CurrencySystem
Coin deduction happens in `requestZoneUnlock()`. Integrate with your currency system to validate coins before calling.

### With ZoneSystem/HabitatSystem
Call `canAccessZone()` before allowing players to enter a zone.

## Response Objects

### requestZoneUnlock Success
```lua
{
    success = true,
    zoneName = "Foggy Fields",
    coinsDeducted = 1000,
    newCoins = 4000,
}
```

### requestZoneUnlock Failure
```lua
{
    success = false,
    reason = "INSUFFICIENT_COINS",  -- or "INSUFFICIENT_LEVEL", "ALREADY_UNLOCKED", "ZONE_NOT_FOUND"
    zoneName = "Foggy Fields",
    requiredLevel = 10,
    requiredCoins = 1000,
    currentLevel = 8,
    currentCoins = 500,
}
```

### checkAutoUnlocks Result
```lua
{
    newlyUnlocked = {"Foggy Fields", "Gloomy Graveyard"},
    count = 2,
}
```

## Features

✅ **Progressive Unlocking** — Zones unlock gradually as player progresses  
✅ **Dual Requirements** — Both level AND coins must be met  
✅ **Auto-Unlock on Level Up** — Zones auto-unlock when requirements are met  
✅ **Free Starting Zones** — Beginning zones always available  
✅ **Cost-Based Progression** — Coins spent create meaningful resource sinks  
✅ **Admin Commands** — Force unlock/lock for debugging and special cases  
✅ **UI-Ready Output** — Structured data for UI components  

## Design Notes

- **Persistence**: Unlocked state stored per-session; integrate with DataManager for persistence across sessions
- **No Rollback**: Zone unlocks are permanent once purchased; no refunds
- **Auto-Unlock Timing**: Happens immediately when both requirements met (no manual unlock needed)
- **Free Zones Always Available**: Cannot be locked, always accessible

## Future Enhancements

- Zone unlock events (RemoteEvents for client notification)
- Unlock animations/UI transitions
- Quest/achievement integration
- Season-based zone rotations
- Special limited-time zones
