# Level & Progression System — Integration Guide

**Created:** 2026-06-09  
**Status:** ✅ Ready to integrate with existing systems  
**Estimated Integration Time:** 2-3 hours

---

## 🚀 Quick Start

Three files have been created and committed:

1. **LevelSystem.lua** (320 lines) — Core level progression
2. **SkillTree.lua** (340 lines) — Skill point management
3. **PlayerProgression.lua** (400 lines) — Unified manager
4. **LEVEL_SYSTEM_SUMMARY.md** — Full documentation

All files are in `src/server/systems/` and ready to use.

---

## 📋 Integration Checklist

### Step 1: Update MainServer_Phase4_Extended.lua

**Location:** `src/server/MainServer_Phase4_Extended.lua`

**Add at top:**
```lua
local PlayerProgression = require(script.Parent.systems.PlayerProgression)
```

**In player join handler:**
```lua
Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId
	
	-- Initialize progression system
	PlayerProgression:initializePlayer(userId)
	
	-- ... existing player initialization code ...
end)
```

**In stats broadcast loop:**
```lua
while player.Parent do
	-- Get complete player stats
	local stats = PlayerProgression:getPlayerStats(player.UserId)
	
	-- Broadcast to client (add to existing RemoteEvent)
	UpdatePlayerStatsEvent:FireClient(player, {
		level = stats.level,
		currentXP = stats.currentXP,
		nextLevelXP = stats.nextLevelXP,
		skillPoints = stats.skillPoints,
		bonuses = stats.bonuses,
		unlockedZones = stats.unlockedZones,
		-- ... other existing stats ...
	})
	
	wait(1)
end
```

**In player leave handler:**
```lua
Players.PlayerRemoving:Connect(function(player)
	PlayerProgression:removePlayer(player.UserId)
	-- ... existing cleanup ...
end)
```

### Step 2: Update CatchingSystem.lua

**Location:** `src/server/CatchingSystem.lua`

**Add at top:**
```lua
local PlayerProgression = require(script.Parent.systems.PlayerProgression)
```

**In attemptCatch function:**
```lua
function CatchingSystem:attemptCatch(player, ghost, currentZone)
	-- ... existing code ...
	
	if success then
		local baseXP = RARITY_XP_MULTIPLIER[ghostRarity] or 25
		local baseCoins = RARITY_COIN_MULTIPLIER[ghostRarity] or 50
		local zoneMultiplier = ZONE_MULTIPLIER[currentZone] or 1.0

		local totalXP = math.floor(baseXP * zoneMultiplier)
		local totalCoins = math.floor(baseCoins * zoneMultiplier)

		-- Add XP (PlayerProgression applies XP bonus from skills)
		local xpResult = PlayerProgression:addXP(userId, totalXP)
		
		-- Add coins (PlayerProgression applies coin bonus from skills)
		PlayerProgression:addCoins(userId, totalCoins)

		-- Destroy ghost
		ghost:Destroy()

		return {
			success = true,
			ghostRarity = ghostRarity,
			xpGained = xpResult.xpAdded,
			coinsGained = totalCoins,
			leveledUp = xpResult.leveledUp,
			newLevel = xpResult.level,
			equipment = equippedEquipment,
			zone = currentZone,
		}
	else
		-- ... existing code ...
	end
end
```

**In purchaseEquipment function (update level check):**
```lua
-- OLD:
-- local playerLevel = PlayerInventory:getLevel(userId)

-- NEW:
local playerLevel = PlayerProgression:getPlayerStats(userId).level
```

### Step 3: Create Client-Side UI (New File)

**Create:** `src/client/modules/ProgressionUI.lua`

```lua
--
-- Progression UI — Displays level bar, XP, skill points
--

local ProgressionUI = {}

function ProgressionUI:createLevelDisplay(parentFrame, stats)
	-- Level label
	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0, 100, 0, 30)
	levelLabel.Position = UDim2.new(0, 10, 0, 10)
	levelLabel.BackgroundTransparency = 1
	levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	levelLabel.TextSize = 16
	levelLabel.Font = Enum.Font.GothamBold
	levelLabel.Text = "Level " .. stats.level
	levelLabel.Parent = parentFrame

	-- XP bar background
	local xpBarBg = Instance.new("Frame")
	xpBarBg.Name = "XPBarBG"
	xpBarBg.Size = UDim2.new(0, 200, 0, 15)
	xpBarBg.Position = UDim2.new(0, 10, 0, 45)
	xpBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	xpBarBg.BorderSizePixel = 0
	xpBarBg.Parent = parentFrame

	-- XP bar fill
	local xpBarFill = Instance.new("Frame")
	xpBarFill.Name = "XPBarFill"
	xpBarFill.Size = UDim2.new(stats.progressPercent, 0, 1, 0)
	xpBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
	xpBarFill.BorderSizePixel = 0
	xpBarFill.Parent = xpBarBg

	-- XP text
	local xpLabel = Instance.new("TextLabel")
	xpLabel.Name = "XPLabel"
	xpLabel.Size = UDim2.new(0, 200, 0, 15)
	xpLabel.Position = UDim2.new(0, 10, 0, 45)
	xpLabel.BackgroundTransparency = 1
	xpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	xpLabel.TextSize = 10
	xpLabel.Font = Enum.Font.Gotham
	xpLabel.Text = stats.currentXP .. " / " .. stats.nextLevelXP
	xpLabel.Parent = parentFrame

	-- Skill points label
	local skillPointsLabel = Instance.new("TextLabel")
	skillPointsLabel.Name = "SkillPointsLabel"
	skillPointsLabel.Size = UDim2.new(0, 150, 0, 20)
	skillPointsLabel.Position = UDim2.new(0, 10, 0, 65)
	skillPointsLabel.BackgroundTransparency = 1
	skillPointsLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	skillPointsLabel.TextSize = 12
	skillPointsLabel.Font = Enum.Font.GothamBold
	skillPointsLabel.Text = "Skill Points: " .. stats.skillPoints
	skillPointsLabel.Parent = parentFrame
end

function ProgressionUI:createSkillTree(parentFrame, skillTree)
	local yPosition = 0
	
	for categoryName, categoryData in pairs(skillTree) do
		-- Category header
		local categoryLabel = Instance.new("TextLabel")
		categoryLabel.Name = categoryName
		categoryLabel.Size = UDim2.new(0, 200, 0, 25)
		categoryLabel.Position = UDim2.new(0, 10, 0, yPosition)
		categoryLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
		categoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		categoryLabel.TextSize = 13
		categoryLabel.Font = Enum.Font.GothamBold
		categoryLabel.Text = categoryData.name
		categoryLabel.Parent = parentFrame
		
		yPosition = yPosition + 30
		
		-- Skills
		for _, skill in ipairs(categoryData.skills) do
			local skillButton = Instance.new("TextButton")
			skillButton.Name = skill.id
			skillButton.Size = UDim2.new(0, 200, 0, 20)
			skillButton.Position = UDim2.new(0, 20, 0, yPosition)
			skillButton.BackgroundColor3 = skill.canUpgrade and 
				Color3.fromRGB(100, 150, 100) or 
				Color3.fromRGB(80, 80, 80)
			skillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			skillButton.TextSize = 11
			skillButton.Font = Enum.Font.Gotham
			skillButton.Text = skill.name .. " (" .. skill.level .. "/" .. skill.maxLevel .. ")"
			skillButton.Parent = parentFrame
			
			yPosition = yPosition + 25
		end
	end
end

return ProgressionUI
```

### Step 4: Update GameClient.lua

**Location:** `src/client/GameClient.lua`

**Add at top:**
```lua
local ProgressionUI = require(script.Parent.modules.ProgressionUI)
```

**In UI creation section (add Progression tab):**
```lua
-- Create Progression tab
local progressionTab = TabSystem:createTab("Progression")

-- Update on stats change
UpdatePlayerStatsEvent.OnClientEvent:Connect(function(stats)
	progressionTab:ClearAllChildren()
	ProgressionUI:createLevelDisplay(progressionTab, stats)
	ProgressionUI:createSkillTree(progressionTab, stats.skillTree)
end)
```

**Add skill point allocation handler:**
```lua
-- Listen for skill allocation requests
local AllocateSkillEvent = Instance.new("RemoteEvent")
AllocateSkillEvent.Name = "AllocateSkillEvent"
AllocateSkillEvent.Parent = ReplicatedStorage

-- In skill button click handler:
skillButton.MouseButton1Click:Connect(function()
	AllocateSkillEvent:FireServer(categoryName, skill.id)
end)
```

### Step 5: Create Server-Side Handler for Skill Allocation

**Add to MainServer_Phase4_Extended.lua:**

```lua
-- Handle skill allocation requests from client
local AllocateSkillEvent = Instance.new("RemoteEvent")
AllocateSkillEvent.Name = "AllocateSkillEvent"
AllocateSkillEvent.Parent = ReplicatedStorage

AllocateSkillEvent.OnServerEvent:Connect(function(player, categoryName, skillId)
	local userId = player.UserId
	local result = PlayerProgression:allocateSkill(userId, categoryName, skillId)
	
	if result.success then
		print(player.Name .. " allocated " .. result.skillName)
	else
		print("Error allocating skill: " .. result.reason)
	end
end)
```

---

## 🧪 Testing the Integration

### Test 1: Player Join & Initialization

```lua
-- In Studio Output:
-- Expected: No errors during player initialization
-- Check that PlayerProgression:getPlayerStats(userId) returns valid data
```

### Test 2: Add XP & Level Up

```lua
-- Admin command (in MainServer):
-- !addxp 500 (player 1)
local userId = Players:GetPlayers()[1].UserId
local result = PlayerProgression:addXP(userId, 500)
print("Level: " .. result.level .. ", XP: " .. result.currentXP)

-- Expected: XP added, potential level up if threshold reached
```

### Test 3: Allocate Skill

```lua
-- In script:
local result = PlayerProgression:allocateSkill(userId, "Energy", "energy_regen")
print(result.skillPointsRemaining .. " skill points left")

-- Expected: Skill level increases, skill points decrease
```

### Test 4: Equipment Auto-Unlock

```lua
-- Check player inventory after level up
-- Expected: New equipment automatically added to owned list
```

### Test 5: Zone Auto-Unlock

```lua
-- Check unlockedZones after level up
-- Expected: New zone added to unlockedZones table
```

---

## 📊 Expected Results After Integration

### Level 1 State
```
Level: 1
XP: 0 / 100
Skill Points: 0
Equipment: BasicNet
Zones: Whisper Woods
```

### After 500 XP (Level 5)
```
Level: 5
XP: 0 / 250
Skill Points: 4
Equipment: BasicNet, ReinforcedNet (auto-unlocked)
Zones: Whisper Woods, Foggy Fields (auto-unlocked)
```

### After 4 More Levels (Level 10)
```
Level: 10
XP: 0 / 250
Skill Points: 9
Equipment: BasicNet, ReinforcedNet, GhostTrap (auto-unlocked)
Zones: First 3 zones unlocked
```

---

## 🐛 Troubleshooting

### Issue: PlayerProgression nil error

**Cause:** Module not initialized on player join  
**Fix:** Add `PlayerProgression:initializePlayer(userId)` in Players.PlayerAdded handler

### Issue: Skills not giving bonuses

**Cause:** CatchingSystem not using PlayerProgression multipliers  
**Fix:** Update CatchingSystem:attemptCatch to use `PlayerProgression:getCatchRateMultiplier(userId)`

### Issue: Equipment not auto-unlocking

**Cause:** Level up callback not firing  
**Fix:** Verify `LevelSystem:onLevelUp()` is being called in PlayerProgression initialization

### Issue: UI not updating after level up

**Cause:** Stats broadcast not including progression data  
**Fix:** Verify `PlayerProgression:getPlayerStats()` is being called in broadcast loop

---

## ✅ Integration Summary

After completing these steps:

- ✅ Players will gain XP from catching ghosts
- ✅ Players will automatically level up with proper XP thresholds
- ✅ Players will receive 1 skill point per level
- ✅ Players will be able to allocate skill points
- ✅ Equipment will auto-unlock at required levels
- ✅ Zones will auto-unlock as player levels up
- ✅ Skill bonuses will apply to catch rate, energy, coins, XP
- ✅ UI will display level bar, XP, skill points, and skill tree

**Total Integration Time:** 2-3 hours  
**Complexity:** Medium  
**Risk Level:** Low (non-breaking changes)

---

## 📞 Support

If you encounter issues:

1. Check **LEVEL_SYSTEM_SUMMARY.md** for API reference
2. Verify module paths are correct (all in `src/server/systems/`)
3. Check console for initialization errors
4. Use admin commands to test each system individually

