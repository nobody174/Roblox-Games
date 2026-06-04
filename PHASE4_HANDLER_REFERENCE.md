<!--
  Ghost Catcher Tycoon - Phase 4 Handler Reference
  Quick lookup for remote calls and expected behavior
-->

# Phase 4 Handler Reference — Quick Lookup

## Handler Quick Map

| Handler | Remote | Parameter | Cost | Effect |
|---------|--------|-----------|------|--------|
| **Charge** | `ChargeVacuum` | — | — | `+25%` charge (0-100 cap) |
| **Catch** | `CatchGhost` | — | `10%` charge | Catch nearest ghost, `+coins` |
| **UpgradeRoom** | `UpgradeRoom` | `roomName` | `baseCost * (1.5^level)` | Room level `+1` (max 10) |
| **TrainGhost** | `TrainGhost` | `ghostKey` | `50 * rarity * level` | Ghost level `+1` (max 10) |
| **HatchEgg** | `HatchEgg` | `eggName` | Fixed (see below) | Random ghost + `ghost count +1` |
| **UnlockZone** | `UnlockZone` | `zoneName` | Fixed (see below) | Zone unlocked |

---

## Handler Costs

### Room Upgrade Costs

```
GhostChamber        → Level 1: 100, 2: 150, 3: 225, 4: 337, 5: 506, ...
TrainingFacility    → Level 1: 150, 2: 225, 3: 337, 4: 506, 5: 759, ...
EnergyReactor       → Level 1: 200, 2: 300, 3: 450, 4: 675, 5: 1012, ...
ResearchLab         → Level 1: 300, 2: 450, 3: 675, 4: 1012, 5: 1518, ...
BossArena           → Level 1: 500, 2: 750, 3: 1125, 4: 1687, 5: 2530, ...

Formula: baseCost × (1.5 ^ (currentLevel - 1))
Max level: 10
```

### Ghost Training Costs

```
Common      → Level 1→2: 50,  2→3: 100,  3→4: 150,  4→5: 200, ...
Uncommon    → Level 1→2: 75,  2→3: 150,  3→4: 225,  4→5: 300, ...
Rare        → Level 1→2: 100, 2→3: 200,  3→4: 300,  4→5: 400, ...
Epic        → Level 1→2: 150, 2→3: 300,  3→4: 450,  4→5: 600, ...
Legendary   → Level 1→2: 250, 2→3: 500,  3→4: 750,  4→5: 1000, ...

Formula: baseCost × level (baseCost = 50 × rarityMultiplier)
Max level: 10
```

### Egg Hatching Costs

```
Common Egg      → 250 coins     → Common ghost
Uncommon Egg    → 1,200 coins   → Uncommon ghost
Rare Egg        → 5,000 coins   → Rare ghost
Epic Egg        → 15,000 coins  → Epic ghost
Legendary Egg   → 45,000 coins  → Legendary ghost
```

### Zone Unlock Costs

```
Whisper Woods         → FREE (starter zone)
Foggy Fields          → 1,500 coins
Gloomy Graveyard      → 6,000 coins
Electro Alley         → 18,000 coins
Frostbite Caverns     → 42,000 coins
```

---

## Client-Side Wiring (Already in GameClient.lua)

### Button Examples

```lua
-- UPGRADE ROOM button
upgradeButton.Activated:Connect(function()
	local upgradeRemote = remotesFolder:FindFirstChild("UpgradeRoom")
	if upgradeRemote then
		upgradeRemote:FireServer("GhostChamber")
	end
end)

-- TRAIN GHOST button
trainButton.Activated:Connect(function()
	local trainRemote = remotesFolder:FindFirstChild("TrainGhost")
	if trainRemote then
		trainRemote:FireServer("Specter_1234")  -- ghost inventory key
	end
end)

-- HATCH EGG button
hatchButton.Activated:Connect(function()
	local hatchRemote = remotesFolder:FindFirstChild("HatchEgg")
	if hatchRemote then
		hatchRemote:FireServer("Common Egg")
	end
end)

-- UNLOCK ZONE button
unlockButton.Activated:Connect(function()
	local unlockRemote = remotesFolder:FindFirstChild("UnlockZone")
	if unlockRemote then
		unlockRemote:FireServer("Foggy Fields")
	end
end)
```

---

## Server-Side Validation

Each handler checks:

1. ✅ **Resource availability** — Do they have enough coins?
2. ✅ **Input validity** — Does the room/ghost/egg/zone exist?
3. ✅ **State constraints** — Are they at max level? Already unlocked?
4. ✅ **Economy** — Calculate cost correctly

Failures return error message to Output (non-blocking).

---

## Testing Progression

### Early Game (0-500 coins)
- Catch Common ghosts (1 coin each, 80% success)
- Can't afford any upgrades or eggs yet
- First zone free (Whisper Woods)

### Mid Game (500-10,000 coins)
- Catch Uncommon ghosts (3 coins)
- Afford: 1-2 room upgrades, Common eggs, Foggy Fields unlock
- Start training ghosts to level 2-3

### Late Game (10,000+ coins)
- Catch Rare/Epic ghosts (10-25 coins)
- Afford: Uncommon/Rare eggs, multiple room upgrades
- Train ghosts to level 5-10
- Unlock Gloomy Graveyard (6,000) → Electro Alley (18,000)

---

## Debug Commands (Lua Console in Studio)

```lua
-- Check player data
local player = game.Players:FindFirstChildOfClass("Player")
if player then
	-- Can't access playerData directly (server-side), but UI updates show it
	print("Player coins:", GetPlayerCoinsDirect)  -- Not exposed
end

-- Trigger handler manually (from client)
local rs = game:GetService("ReplicatedStorage")
rs.Remotes.UpgradeRoom:FireServer("GhostChamber")
rs.Remotes.TrainGhost:FireServer("Specter_1234")
rs.Remotes.HatchEgg:FireServer("Common Egg")
rs.Remotes.UnlockZone:FireServer("Foggy Fields")

-- Watch Output for [PHASE 4] messages
```

---

## Known Limitations (Phase 4)

❌ **No persistence** — Data lost on server restart  
❌ **Simplified gacha** — No weighted probability tables yet  
❌ **No ghost storage limit** — Can catch infinite ghosts  
❌ **No multiplier syncing** — Room upgrades don't affect passive income yet  
❌ **No UI feedback** — Handlers work but UI may not update perfectly  

These are planned for Phase 5 integration with full MainServer.lua.

---

## Next Phase Hooks

When integrating into MainServer.lua, add:

1. **DataManager integration** — Save room levels, ghost inventory, unlocked zones to DataStore
2. **ProductionSystem wiring** — Room multipliers affect passive income
3. **Full gacha tables** — Use EggData.lua weighted probabilities
4. **Ghost storage caps** — Add max slots check in catch/hatch handlers
5. **Notifications** — Use ShowNotification remote for visual feedback
6. **ZoneSystem sync** — Validate unlocked zones match ZoneData.lua

---

**Quick Start:** Copy `MainServer_Phase4_Extended.lua` to your ServerScriptService in Studio, load GameClient.lua as usual. All remotes auto-create.
