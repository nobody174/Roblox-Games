# Detailed Line-by-Line Changes

This shows exactly what changed in each file.

---

## FILE 1: GhostAI.lua ✅ NEW FILE

**Location in Studio:** `ServerScriptService > GhostAI` (ModuleScript)
**Size:** ~195 lines
**Status:** COMPLETE - Copy entire file

**What it does:**
- Makes Common ghosts stationary
- Makes Uncommon ghosts wander slowly
- Makes Rare ghosts flee from players
- Makes Epic ghosts aggressively flee
- Makes Legendary ghosts teleport away
- Makes Corrupted ghosts aggressively teleport

**Key Functions:**
- `GhostAI:initializeGhost(ghostModel, ghostRarity)` - Called when ghost spawns
- `GhostAI:ghostBehaviorLoop(ghostModel, behavior)` - Runs ghost AI each tick
- `GhostAI:findNearbyPlayers(position, range)` - Finds players near ghost

---

## FILE 2: PhaseManager.lua ✅ NEW FILE

**Location in Studio:** `ServerScriptService > PhaseManager` (ModuleScript)
**Size:** ~165 lines
**Status:** COMPLETE - Copy entire file

**What it does:**
- Creates private "Phase_#_PlayerName" folders for each player
- Clones the Hub zone into each player's private phase
- Teleports player to their private phase on spawn
- Cleans up empty phases when players leave
- Tracks which player is in which phase

**Key Functions:**
- `PhaseManager:createPlayerPhase(player)` - Creates private zone instance
- `PhaseManager:teleportPlayerToPhase(player)` - Moves player to their phase
- `PhaseManager:isZoneInPhase(player, zoneName)` - Checks if zone is in player's phase
- `PhaseManager:cleanupPlayerPhase(player)` - Deletes empty phases
- `PhaseManager:initialize()` - Sets up events for all players

---

## FILE 3: MainServer_Phase4_Extended.lua 🔄 MODIFIED

**Location in Studio:** `ServerScriptService > MainServer_Phase4_Extended` (Script)
**Size:** ~1250+ lines
**Status:** REPLACE ENTIRE FILE

### Changes Made:

#### Change 1: Added GhostAI Require (Line ~111)
```lua
-- OLD:
local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))
local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))

-- NEW:
local GhostData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("GhostData"))
local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))
local GhostAI = require(game:GetService("ServerScriptService"):WaitForChild("GhostAI"))
```

#### Change 2: Modified spawnGhost() Signature (Line ~162)
```lua
-- OLD:
local function spawnGhost(zoneName)
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")
	if not zoneContainer then return nil end

	local zoneFolder = zoneContainer:FindFirstChild(zoneName)
	if not zoneFolder then return nil end

-- NEW:
local function spawnGhost(zoneName, targetFolder)
	-- Use targetFolder if provided (for private phases), otherwise use shared ZoneContainer
	local searchContainer = targetFolder or workspace:FindFirstChild("ZoneContainer")
	if not searchContainer then return nil end

	local zoneFolder = searchContainer:FindFirstChild(zoneName)
	if not zoneFolder then return nil end
```

#### Change 3: Added GhostAI Initialization (Line ~327)
```lua
-- OLD:
	-- Track by model (catch code checks Part, so also track body)
	activeGhosts[body] = { name = ghostName, rarity = rarity }
	local ghost = body  -- keep variable name for catch system compatibility

	-- Auto-despawn after 60 seconds

-- NEW:
	-- Track by model (catch code checks Part, so also track body)
	activeGhosts[body] = { name = ghostName, rarity = rarity }
	local ghost = body  -- keep variable name for catch system compatibility

	-- Initialize AI behavior based on rarity
	GhostAI:initializeGhost(ghostModel, rarity)

	-- Auto-despawn after 60 seconds
```

#### Change 4: Wrapped Spawn Loop (Lines ~343-397)
```lua
-- OLD:
-- Spawn ghosts every N seconds in all zones (mapped from ZoneData)
task.spawn(function()
	local spawnCount = 0
	while true do
		task.wait(Config.GhostSpawnRate)
		-- Zone names now match ZoneAutoBuilder output (theme names)
		local zoneMapping = {
			"Hub",  -- Starting Area
			... (zones list)
		}
		spawnCount = spawnCount + 1
		local spawnedThisRound = 0
		for _, zoneName in ipairs(zoneMapping) do
			if spawnGhost(zoneName) then
				spawnedThisRound = spawnedThisRound + 1
			end
		end
		if spawnedThisRound > 0 then
			print("[PHASE 4] Spawn cycle #" .. spawnCount .. ": Spawned " .. spawnedThisRound .. " ghosts")
		end
	end
end)

-- NEW:
-- Spawn ghosts every N seconds in all zones (mapped from ZoneData)
-- Spawning will start after ZoneManager is initialized (to ensure PhaseManager is ready)
local spawnLoopStarted = false

local function startGhostSpawnLoop()
	if spawnLoopStarted then return end
	spawnLoopStarted = true

	task.spawn(function()
		local spawnCount = 0
		while true do
			task.wait(Config.GhostSpawnRate)
			-- Zone names now match ZoneAutoBuilder output (theme names)
			local zoneMapping = {
				"Hub",  -- Starting Area
				... (zones list)
			}
			spawnCount = spawnCount + 1
			local spawnedThisRound = 0
			for _, zoneName in ipairs(zoneMapping) do
				if spawnGhost(zoneName) then
					spawnedThisRound = spawnedThisRound + 1
				end
			end

			-- Also spawn ghosts in each player's private phases (Starting Area)
			if zoneManager and zoneManager.phaseManager then
				local phaseManager = zoneManager.phaseManager
				for phaseId, phaseData in pairs(phaseManager.phaseInstances) do
					if phaseData and phaseData.folder then
						-- Spawn one ghost in each player's private Starting Area
						if spawnGhost("Hub", phaseData.folder) then
							spawnedThisRound = spawnedThisRound + 1
						end
					end
				end
			end

			if spawnedThisRound > 0 then
				print("[PHASE 4] Spawn cycle #" .. spawnCount .. ": Spawned " .. spawnedThisRound .. " ghosts")
			end
		end
	end)
end
```

#### Change 5: Call startGhostSpawnLoop After Init (Lines ~1250-1252)
```lua
-- OLD:
-- Initialize ZoneManager for zone detection and barriers
if zoneManager and zoneManager.initialize then
	zoneManager:initialize()
end

print("[PHASE 4] ✅ Phase 4 extended testing server ready!")

-- NEW:
-- Initialize ZoneManager for zone detection and barriers
if zoneManager and zoneManager.initialize then
	zoneManager:initialize()
	print("[PHASE 4] ZoneManager initialized, starting ghost spawn loop...")
	startGhostSpawnLoop()
end

print("[PHASE 4] ✅ Phase 4 extended testing server ready!")
```

---

## FILE 4: ZoneManager.lua 🔄 MODIFIED

**Location in Studio:** `ServerScriptService > ZoneManager` (ModuleScript)
**Size:** ~260 lines
**Status:** REPLACE ENTIRE FILE

### Changes Made:

#### Change 1: Added PhaseManager Require (Line ~10)
```lua
-- OLD:
local ZoneManager = {}
ZoneManager.__index = ZoneManager

local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))

-- NEW:
local ZoneManager = {}
ZoneManager.__index = ZoneManager

local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))
local PhaseManager = require(game:GetService("ServerScriptService"):WaitForChild("PhaseManager"))
```

#### Change 2: Initialize PhaseManager (Lines ~39-58)
```lua
-- OLD:
function ZoneManager:initialize()
	print("[ZoneManager] Initializing...")

	-- Wait for ZoneContainer to exist (ZoneAutoBuilder might still be building)
	local zoneContainer = workspace:WaitForChild("ZoneContainer", 30)
	if not zoneContainer then
		warn("[ZoneManager] ZoneContainer not found after 30 seconds - zone detection disabled!")
		return
	end

	print("[ZoneManager] ZoneContainer found, proceeding...")

	-- Rename workspace zones to match ZoneData
	self:renameZones()

	-- Create invisible barriers around locked zones
	self:createBarriers()

	-- Start zone detection loop for all players
	self:startZoneDetection()

	print("[ZoneManager] Initialized!")
end

-- NEW:
function ZoneManager:initialize()
	print("[ZoneManager] Initializing...")

	-- Wait for ZoneContainer to exist (ZoneAutoBuilder might still be building)
	local zoneContainer = workspace:WaitForChild("ZoneContainer", 30)
	if not zoneContainer then
		warn("[ZoneManager] ZoneContainer not found after 30 seconds - zone detection disabled!")
		return
	end

	print("[ZoneManager] ZoneContainer found, proceeding...")

	-- Rename workspace zones to match ZoneData
	self:renameZones()

	-- Create invisible barriers around locked zones
	self:createBarriers()

	-- Initialize PhaseManager for private Starting Area instances
	local phaseManager = PhaseManager:new()
	phaseManager:initialize()
	self.phaseManager = phaseManager

	-- Start zone detection loop for all players
	self:startZoneDetection()

	print("[ZoneManager] Initialized!")
end
```

#### Change 3: Zone Detection Checks Private Phases First (Lines ~154-190)
```lua
-- OLD:
function ZoneManager:startPlayerZoneDetection(player)
	task.spawn(function()
		while player and player.Parent do
			task.wait(0.5) -- Check zone every 0.5 seconds

			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart
				local currentZone = self:detectPlayerZone(hrp)

				if currentZone then
					... (rest of zone detection code)

-- NEW:
function ZoneManager:startPlayerZoneDetection(player)
	task.spawn(function()
		while player and player.Parent do
			task.wait(0.5) -- Check zone every 0.5 seconds

			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart

				-- First check if player is in their private phase (Starting Area)
				local currentZone = nil
				if self.phaseManager and self.phaseManager:isZoneInPhase(player, "Hub") then
					-- Player is in their private Starting Area phase
					currentZone = "Starting Area"
				else
					-- Check shared zones
					currentZone = self:detectPlayerZone(hrp)
				end

				if currentZone then
					... (rest of zone detection code)
```

---

## Summary of Changes

| File | Type | Action | New Lines |
|------|------|--------|-----------|
| GhostAI.lua | NEW | Create ModuleScript | 195 |
| PhaseManager.lua | NEW | Create ModuleScript | 165 |
| MainServer_Phase4_Extended.lua | MODIFIED | Replace entirely | 1250+ |
| ZoneManager.lua | MODIFIED | Replace entirely | 260 |

**Total New/Changed Lines:** ~360 lines of new code, 2 new modules

---

## Verification

After copying all files, you should see in Output:

```
[PhaseManager] Created private phase #1 for [PlayerName]
[ZoneManager] Initialized!
[PHASE 4] ZoneManager initialized, starting ghost spawn loop...
[PHASE 4] Spawn cycle #1: Spawned 12 ghosts
```

This confirms all 4 files are properly integrated! ✅
