<!--
  Ghost Catcher Tycoon - Technical Architecture
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Ghost Catcher Tycoon - Technical Architecture

## System Overview

Ghost Catcher Tycoon uses a modular, server-authoritative architecture with clear separation of concerns.

```
┌─────────────────────────────────────────────┐
│           CLIENT (Player Device)             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ UIManager│  │InputMngr │  │GameClient│  │
│  └──────────┘  └──────────┘  └──────────┘  │
└────────────┬────────────────────────────────┘
             │ RemoteEvents / RemoteFunctions
┌────────────▼────────────────────────────────┐
│           SERVER (Roblox Servers)            │
│  ┌────────────────────────────────────────┐ │
│  │ MainServer (Initialization & Routing)  │ │
│  └────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────┐ │
│  │              Systems                    │ │
│  │ ┌──────────┐ ┌──────────┐ ┌──────────┐│ │
│  │ │DataMngr  │ │Currency  │ │Vacuum    ││ │
│  │ ├──────────┤ ├──────────┤ ├──────────┤│ │
│  │ │Ghost     │ │HQ/Tycoon │ │Spawning  ││ │
│  │ └──────────┘ └──────────┘ └──────────┘│ │
│  └────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────┐ │
│  │        DataStore (Persistence)          │ │
│  └────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

## Core Systems

### 1. Data Management System

**Responsibility**: Save and load player data

**Location**: `ServerScriptService.DataManager`

**Core Concepts**:
- Uses Roblox DataStore
- Auto-saves at intervals
- Handles player join/leave
- Validates data integrity

**Key Data Structure**:
```lua
PlayerData = {
  UserId = 12345,
  Energy = 1000,
  Ghosts = {
    {
      Id = "ghost_001",
      Rarity = "Rare",
      Level = 5,
      EnergyOutput = 10
    }
  },
  HQ = {
    GhostChamber = { Level = 2, Slots = 10 },
    TrainingFacility = { Level = 1 }
  },
  Settings = { VolumeLevel = 0.8 }
}
```

**Public Methods**:
```lua
DataManager:SavePlayerData(player)
DataManager:LoadPlayerData(player)
DataManager:GetPlayerData(player) -- Returns current data
DataManager:UpdatePlayerData(player, updates) -- Partial update
```

### 2. Currency System

**Responsibility**: Track and manage Ecto-Energy

**Location**: `ServerScriptService.Systems.CurrencySystem`

**Core Concepts**:
- Server controls all currency
- Client requests changes
- Validates transactions
- Prevents exploits

**Public Methods**:
```lua
CurrencySystem:AddEnergy(player, amount, source)
CurrencySystem:RemoveEnergy(player, amount, source)
CurrencySystem:GetEnergy(player)
CurrencySystem:CanAfford(player, cost)
```

**Example Usage**:
```lua
if CurrencySystem:CanAfford(player, 100) then
  CurrencySystem:RemoveEnergy(player, 100, "room_upgrade")
  HQSystem:UpgradeRoom(player, "GhostChamber")
end
```

### 3. Vacuum System

**Responsibility**: Handle clicking and charge mechanics

**Location**: `ServerScriptService.Systems.VacuumSystem`

**Core Concepts**:
- Tracks vacuum charge per player
- Calculates catch probability
- Handles cooldowns
- Prevents spam clicking

**Public Methods**:
```lua
VacuumSystem:ChargeVacuum(player)
VacuumSystem:GetCharge(player)
VacuumSystem:GetCatchChance(player)
VacuumSystem:ResetCharge(player)
```

**Charge Formula**:
```lua
charge_level = 0-100
catch_chance = charge_level * 0.95 -- 100% charge = 95% catch
```

### 4. Ghost System

**Responsibility**: Spawn, catch, train, and manage ghosts

**Location**: `ServerScriptService.Systems.GhostSystem`

**Core Concepts**:
- Manages ghost spawning in zones
- Handles catch mechanics
- Tracks ghost stats
- Manages storage limits

**Ghost Data Structure**:
```lua
Ghost = {
  Id = "ghost_12345",
  Type = "Forest Specter",
  Rarity = "Uncommon",
  Level = 1,
  EnergyOutput = 2,
  CatchSpeed = 1.0,
  Happiness = 0.5
}
```

**Rarities**:
```lua
Rarities = {
  Common = { EnergyOutput = 1, CatchChance = 0.80 },
  Uncommon = { EnergyOutput = 2, CatchChance = 0.60 },
  Rare = { EnergyOutput = 5, CatchChance = 0.40 },
  Legendary = { EnergyOutput = 10, CatchChance = 0.20 },
  Mythic = { EnergyOutput = 25, CatchChance = 0.05 }
}
```

**Public Methods**:
```lua
GhostSystem:SpawnGhost(zone)
GhostSystem:CatchGhost(player, ghostId, chargeLevel)
GhostSystem:GetPlayerGhosts(player)
GhostSystem:GetGhostStats(ghostId)
GhostSystem:TrainGhost(player, ghostId, amount)
```

### 5. HQ (Tycoon) System

**Responsibility**: Manage HQ rooms and upgrades

**Location**: `ServerScriptService.Systems.HQSystem`

**Core Concepts**:
- Tracks room levels
- Calculates multipliers
- Handles room upgrades
- Unlocks new features

**Room Data Structure**:
```lua
Rooms = {
  GhostChamber = {
    Level = 1,
    SlotsPerLevel = 5,
    EnergyMultiplier = 1.0
  },
  TrainingFacility = {
    Level = 1,
    SpeedMultiplier = 1.0
  }
}
```

**Upgrade Costs**:
```lua
-- Cost increases exponentially
GetUpgradeCost(room, level) = 100 * (2 ^ (level - 1))
```

**Public Methods**:
```lua
HQSystem:UpgradeRoom(player, roomName)
HQSystem:GetRoomLevel(player, roomName)
HQSystem:GetStorageSlots(player)
HQSystem:GetEnergyMultiplier(player)
HQSystem:CanUpgradeRoom(player, roomName)
```

### 6. Production System

**Responsibility**: Calculate passive energy generation

**Location**: `ServerScriptService.Systems.ProductionSystem`

**Core Concepts**:
- Runs on background loop
- Calculates per-player energy per second
- Applies multipliers
- Handles edge cases (full storage, offline)

**Production Formula**:
```lua
TotalEnergy/sec = SUM(ghost_output for each ghost)
                × room_multiplier
                × gamepass_multiplier

-- Example:
-- 5 ghosts × 2 energy = 10
-- × 1.5 (room multiplier) = 15
-- × 2 (double energy gamepass) = 30 energy/sec
```

**Public Methods**:
```lua
ProductionSystem:CalculateEnergyPerSecond(player)
ProductionSystem:GetProductionBreakdown(player) -- Returns details
ProductionSystem:DistributeEnergy(player, amount) -- Add earned energy
```

## Communication Pattern

### Client → Server Requests

**Pattern**: RemoteEvent/RemoteFunction in ReplicatedStorage

**Example: Client wants to catch a ghost**

```lua
-- Client (Input Manager)
local CatchGhostRemote = ReplicatedStorage:WaitForChild("CatchGhost")
CatchGhostRemote:FireServer(ghostId)

-- Server (Ghost System)
CatchGhostRemote.OnServerEvent:Connect(function(player, ghostId)
  local chargeLevel = VacuumSystem:GetCharge(player)
  local success = GhostSystem:CatchGhost(player, ghostId, chargeLevel)
  
  -- Tell client result
  if success then
    UIManager:ShowMessage(player, "Caught!")
  end
end)
```

### Server → Client Updates

**Pattern**: RemoteEvent fired from server to client

**Example: Server tells client to update UI**

```lua
-- Server (Production System)
local UpdateUIRemote = ReplicatedStorage:WaitForChild("UpdateUI")
UpdateUIRemote:FireClient(player, { Energy = newEnergy })

-- Client (UI Manager)
UpdateUIRemote.OnClientEvent:Connect(function(data)
  EnergyLabel.Text = tostring(data.Energy)
end)
```

## Initialization Flow

### Server Startup

```
1. MainServer runs
2. Initialize Systems:
   - DataManager
   - CurrencySystem
   - VacuumSystem
   - GhostSystem
   - HQSystem
   - ProductionSystem
3. Set up RemoteEvents
4. Wait for players
```

### Player Joins

```
1. MainServer detects player join
2. DataManager loads player data from DataStore
3. Systems initialize player-specific data
4. Client receives initial game state
5. Client UI initializes
6. Player can interact
```

### Game Loop (Per Second)

```
1. ProductionSystem calculates energy for all players
2. Distribute earned energy
3. Update client UI with new energy
4. Check for spawning conditions
5. Update ghost states
```

## Modularity & Expansion

### Adding a New System

1. **Create module** in `ServerScriptService.Systems.YourSystem`
2. **Implement public interface** (methods other systems call)
3. **Register in MainServer** initialization
4. **Create RemoteEvents** for client communication if needed

**Example: New Boss System**

```lua
-- ServerScriptService.Systems.BossSystem
local BossSystem = {}

function BossSystem:StartBossEncounter(player, bossType)
  -- Validate player can fight boss
  -- Create boss instance
  -- Handle battle logic
end

function BossSystem:GetActiveBoss(player)
  -- Return current boss or nil
end

return BossSystem
```

## Security Principles

1. **Server is authority** - Never trust client values
2. **Validate all inputs** - Check energy, ghost IDs, etc.
3. **Rate limiting** - Prevent spam clicking/requests
4. **Exploit prevention** - Checksums for critical data
5. **Logging** - Track suspicious activity

**Example Validation**:
```lua
function CurrencySystem:RemoveEnergy(player, amount)
  local currentEnergy = self:GetEnergy(player)
  
  if amount <= 0 then
    error("Cannot remove negative energy")
  end
  
  if amount > currentEnergy then
    error("Insufficient energy")
  end
  
  -- Safe to proceed
  self:UpdateEnergy(player, currentEnergy - amount)
end
```

## Performance Considerations

| System | Update Frequency | Impact |
|--------|------------------|--------|
| Production | 1 per second | High (affects all players) |
| UI | On demand | Medium |
| Ghost spawning | 5 per second | Low (per zone) |
| Saving | 30 seconds | Low (batched) |

## Debugging Tips

1. **Print player data**: `print(game:GetService("DataStoreService"):DebugData())`
2. **Monitor production**: Add logging to ProductionSystem
3. **Test with simulator**: Run multiple clients in studio
4. **Check RemoteEvents**: Monitor FireServer/FireClient calls

---

Last Updated: June 2, 2025
