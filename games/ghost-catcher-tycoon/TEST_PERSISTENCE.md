# Persistence Testing Guide

This guide walks you through testing ghost persistence in Roblox Studio.

## Requirements

- Roblox Studio
- Ghost Catcher Tycoon game loaded
- Game is running locally (persistence uses in-memory cache in Studio)

## Testing Steps

### 1. Start Fresh Session
1. Open Ghost Catcher Tycoon in Studio
2. Run the game (press Play)
3. Open the Output window (View → Output)
4. Watch for `[DataManager]` and `[PHASE 4]` log messages

### 2. Catch a Ghost
1. Your character spawns in the private Starting Area
2. Wait for ghosts to spawn (every few seconds you should see spawn logs)
3. Walk around until you see a ghost (round glowing sphere with eyes)
4. Click the **CHARGE** button to charge your vacuum (do this 2-3 times)
5. Click the **CATCH** button when near a ghost

**Expected Output:**
```
[PHASE 4] Caught [GhostName] ([Rarity]) for X coins!
[PHASE 4] Player data updated: coins increased, ghost added to inventory
```

### 3. Verify Ghost is Stored
1. Check the GUI for caught ghost count and inventory
2. Watch the Output for `GhostInventory` entries being saved

**Expected:**
```
[PHASE 4] Auto-save: Updated player data for [PlayerName]
[DataManager] Successfully saved data for player [UserId]
```

### 4. Leave and Rejoin (Test Persistence)

**Option A: Using Test Mode**
1. Stop the game (press Stop in Studio)
2. Start a new session (press Play again)
3. Your character should rejoin with the same phased Starting Area
4. Check if caught ghosts still appear in your inventory

**Option B: Manual Player Leave Test**
1. While game is running, press Ctrl+Shift+F5 (or look in Players window)
2. Right-click your player and select "Remove"
3. The game will show you're leaving
4. Watch Output for save message:
```
[PHASE 4] Saved player data for [PlayerName] to DataStore
```
5. Rejoin by pressing Play again → Stop → Play

### 5. Verify Persistence

After rejoining, check:
- [ ] Your caught ghosts still appear in inventory
- [ ] Coins earned from catches are still there
- [ ] Room upgrades are preserved (if you did any)
- [ ] Unlocked zones are preserved

## What Should NOT Persist (Expected)

- Active ghosts in the world (they despawn after 60 seconds)
- Temporary buffs or effects
- Phase folder state (recreated fresh each session)

## Troubleshooting

### No ghosts spawning?
- Check that `ZONE_AUTO_BUILDER.lua` created zones correctly
- Look for `[PHASE 4] Spawn cycle #X: Spawned Y ghosts` in Output
- Make sure you're in the Starting Area (private phase)

### Ghosts not catching?
- Make sure you CHARGED first (click CHARGE button 2+ times)
- Move closer to the ghost (within `Config.GhostCatchDistance` studs, default 20)
- Check Output for error messages

### Data not saving?
- In Studio, DataStore is simulated using in-memory cache
- Check Output for `[DataManager]` save errors
- Auto-save runs every 30 seconds
- Manual save happens when you leave (PlayerRemoving event)

### Studio DataStore vs Live

**Studio (What We're Testing):**
- DataStore requests are simulated
- Data persists in memory during session
- Cache-based, not truly persistent to Roblox servers

**Live (After Publishing to Roblox):**
- Uses real Roblox DataStore service
- Data persists across server restarts
- Subject to Roblox DataStore limits (cooldowns, quotas)

## Expected Behavior

✅ **Session 1:**
- Catch 3 ghosts: Puffling (Common), Wobbler (Uncommon), Voltgeist (Rare)
- Earn coins: 1 + 3 + 10 = 14 coins
- Close game

✅ **Session 2 (After Rejoin):**
- Load with same 3 ghosts in inventory
- Still have 14 coins
- Start catching more ghosts (count goes 3 → 4, 5, 6...)

## Quick Debug Commands

In Studio's Command Bar, you can check player data:

```lua
print(_G.GhostCatcherPlayerData[game.Players:GetPlayers()[1].UserId])
```

This prints the in-memory playerData for the first player.

## Next Steps After Testing

Once persistence is verified:
1. Test catching different rarity ghosts to ensure variety saves
2. Test upgrading rooms to ensure config changes persist
3. Test unlocking new zones to ensure progression persists
4. Prepare for publishing to Roblox (which uses real DataStore)

