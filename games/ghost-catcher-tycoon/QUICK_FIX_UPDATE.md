# Quick Fix Update - 3 Files to Update in Studio

Apply these 3 fixes right now to address:
- ✅ GhostAI error (line 107 crash)
- ✅ Zone names not changing (always "Starting Area")
- ✅ Starting Area spawning ghosts (shouldn't)
- ✅ Legendary/Corrupted too easy

**Time:** ~5 minutes

---

## Fix 1: Update GhostAI Module

**In Studio:** ServerScriptService → GhostAI → Open it

**Find this section (around line 28-38):**
```lua
Legendary = {
    speed = 30,          -- Very fast
    evasion = 0.8,       -- 80% chance to dodge
    behavior = "teleport_flee",
    description = "Teleports and flees, extremely challenging"
},
Corrupted = {
    speed = 35,          -- Extremely fast
    evasion = 1.0,       -- Always dodges first attempt
    behavior = "aggressive_teleport",
    description = "Aggressively dodges and teleports, nearly impossible"
}
```

**Replace with:**
```lua
Legendary = {
    speed = 40,          -- Very fast
    evasion = 0.85,      -- 85% chance to dodge
    behavior = "teleport_flee",
    description = "Teleports and flees, extremely challenging"
},
Corrupted = {
    speed = 50,          -- Extremely fast
    evasion = 0.95,      -- 95% chance to dodge
    behavior = "aggressive_teleport",
    description = "Aggressively dodges and teleports, nearly impossible"
}
```

**Also in GhostAI, find all `.Position` on closestPlayer and change to `.position`:**
- Search for: `closestPlayer.Position`
- Replace with: `closestPlayer.position`
- Should find ~8 occurrences

**Save**

---

## Fix 2: Update ZoneManager Module

**In Studio:** ServerScriptService → ZoneManager → Open it

**Find this section (around line 165-176):**
```lua
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
```

**Replace with:**
```lua
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    local hrp = player.Character.HumanoidRootPart

    -- Check if player character is inside a phase folder (private Starting Area)
    local currentZone = nil
    local isInPhase = false

    if self.phaseManager then
        local phaseFolder = self.phaseManager:getPlayerPhaseFolder(player)
        if phaseFolder and hrp.Parent:IsDescendantOf(phaseFolder) then
            -- Player is inside their private phase
            currentZone = "Starting Area"
            isInPhase = true
        end
    end

    -- If not in phase, check shared zones
    if not isInPhase then
        currentZone = self:detectPlayerZone(hrp)
    end
```

**Save**

---

## Fix 3: Update MainServer Script

**In Studio:** ServerScriptService → MainServer_Phase4_Extended → Open it

**Find this section (around line 379-390):**
```lua
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
```

**Replace with:**
```lua
            -- Don't spawn ghosts in Starting Area - it's a home/HQ zone
            -- (PhaseManager still creates private phases, but they're ghost-free)
```

**Save**

---

## Testing

After applying all 3 fixes:

1. **Close all editors** in Studio
2. **Click PLAY**
3. **Test zone names:**
   - You should be in "Starting Area"
   - Walk to a bridge: should show "Bridge"
   - Walk to Whisper Woods: should show "Whisper Woods"
   - Walk to other islands: should show their names
   
4. **Test ghost difficulty:**
   - Common ghosts: Easy (stand still)
   - Legendary ghosts: Hard (teleport at 40 speed)
   - Corrupted ghosts: Very hard (teleport at 50 speed, dodge 95%)

5. **Check Starting Area:**
   - NO ghosts should spawn there
   - It should be empty (safe home zone)

---

## What These Fixes Do

| Fix | Problem | Solution |
|-----|---------|----------|
| Fix 1 | GhostAI crashes + ghosts too easy | Increase speeds/evasion + fix `.Position` bug |
| Fix 2 | Zone names always "Starting Area" | Use `IsDescendantOf()` to detect if player is in phase |
| Fix 3 | Ghosts spawn in Starting Area | Remove the spawning loop for private phases |

---

## Done! ✅

After these 3 quick fixes, everything should work correctly. The game will be ready for testing!
