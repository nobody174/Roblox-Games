<!-- 
  HABITAT SYSTEM INTEGRATION GUIDE
  How to wire HabitatUI and HabitatSystem into MainServer
  Author: Claude Code
  Date: 2026-06-06
-->

# 🏠 Habitat System Integration Guide

## Overview

The Habitat System has been implemented in two files:

1. **src/client/modules/HabitatUI.lua** - Client-side UI (tabs, filtering, ghost cards, details)
2. **src/server/systems/HabitatSystem.lua** - Server-side logic (storage, income, cosmetics)

This guide shows how to integrate them into your existing MainServer and GameClient.

---

## 📋 Files to Update

### 1. MainServer_Phase4_Extended.lua

**Changes:**
- Load HabitatSystem
- Replace "Bring Ghosts Home" coins logic with habitat collection
- Update income loop to use HabitatSystem
- Add Habitat remote handlers

**Location:** Line ~35-45 (after SystemManager initialization)

**Add this code:**

```lua
-- Load HabitatSystem
local HabitatSystem = require(game:GetService("ServerScriptService"):WaitForChild("systems"):WaitForChild("HabitatSystem"))
local habitatSystem = HabitatSystem:new()
habitatSystem:initialize(remotesFolder)

print("[PHASE 4] HabitatSystem loaded")
```

---

### 2. Update Player Data Structure

**Current structure:**
```lua
playerData[userId] = {
	charge = 0,
	coins = 0,
	ghosts = 0,
	ghostInventory = {},
	rooms = { ... },
	unlockedZones = { ... },
}
```

**New structure (add):**
```lua
playerData[userId] = {
	charge = 0,
	coins = 0,
	ghosts = 0,
	ghostInventory = {},      -- Temp storage before bringing home
	rooms = { ... },
	unlockedZones = { ... },
	habitat = {                -- NEW: Ghost collection storage
		maxSlots = 5,
		ghosts = {}            -- { ghostKey: ghostData }
	}
}
```

**Update initPlayerData function (~Line 265):**

```lua
local function initPlayerData(userId)
	if not playerData[userId] then
		playerData[userId] = {
			charge = 0,
			coins = 0,
			ghosts = 0,
			ghostInventory = {},
			rooms = {
				GhostChamber = { level = 1 },
				TrainingFacility = { level = 1 },
				EnergyReactor = { level = 1 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = { ["Whisper Woods"] = true },
			habitat = {                            -- NEW
				maxSlots = 5,
				ghosts = {}
			}
		}
	end
	return playerData[userId]
end
```

---

### 3. Update Catch Handler

**Current (Line ~410-445):**
```lua
-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		-- ... catches ghost ...
		-- Add to ghost inventory
		local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = { name = ghostName, level = 1, rarity = rarity }
		data.ghosts = data.ghosts + 1
		-- ... rest of code ...
	end)
end
```

**NEW (Updated):**
```lua
-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		-- ... (keep existing charge/distance validation) ...
		
		-- Award coins based on rarity
		local coinReward = {
			Common = 1,
			Uncommon = 3,
			Rare = 10,
			Epic = 25,
			Legendary = 50,
			Corrupted = 75,
		}
		local coins = coinReward[rarity] or 1
		data.coins = data.coins + coins

		-- Add to habitat (NEW)
		local success, result = habitatSystem:addGhostToHabitat(player, {
			name = ghostName,
			rarity = rarity,
			level = 1,
		})

		if success then
			data.ghosts = data.ghosts + 1
			print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") - added to habitat")
		else
			-- Habitat full - give coins instead
			data.coins = data.coins + coins * 5
			print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " but habitat full")
		end

		-- Remove ghost from world
		closestGhost:Destroy()
		activeGhosts[closestGhost] = nil
	end)
	print("[PHASE 4] Catch handler connected")
end
```

---

### 4. Replace "Bring Ghosts Home" Handler

**Old (Line ~448-474):**
```lua
-- Bring Ghosts Home remote handler (OLD - coins model)
local bringRemote = remotesFolder:FindFirstChild(Constants.Remotes.BringGhostsHome)
if bringRemote then
	bringRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)
		-- Award bonus coins (10% of ghosts * 10 coins per ghost)
		local bonusCoins = math.ceil(data.ghosts * 10 * 0.1)
		data.coins = data.coins + bonusCoins
		-- ... rest ...
	end)
	print("[PHASE 4] BringGhostsHome handler connected")
end
```

**NEW (Collection-based model):**
```lua
-- Bring Ghosts Home remote handler (NEW - collection model)
local bringRemote = remotesFolder:FindFirstChild(Constants.Remotes.BringGhostsHome)
if bringRemote then
	bringRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)
		local userId = player.UserId

		-- Check if habitat is full
		local habitat = habitatSystem:getHabitatData(userId)
		if not habitat then
			print("[PHASE 4] " .. player.Name .. " habitat not found")
			return
		end

		local ghostCount = habitatSystem:getGhostCount(userId)
		if ghostCount >= habitat.maxSlots then
			-- Don't clear inventory, habitat is just full
			print("[PHASE 4] " .. player.Name .. " tried to bring home but habitat is full")
			return
		end

		-- Move all ghosts from temporary inventory to habitat
		local moved = 0
		for ghostKey, ghostData in pairs(data.ghostInventory) do
			local success = habitatSystem:addGhostToHabitat(player, ghostData)
			if success then
				moved = moved + 1
				data.ghostInventory[ghostKey] = nil
			end
		end

		-- Clear temp inventory
		data.ghostInventory = {}

		print("[PHASE 4] " .. player.Name .. " brought " .. moved .. " ghosts home!")

		-- Send immediate broadcast to update UI
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, {
				VacuumCharge = data.charge,
				Energy = data.coins,
				GhostCount = ghostCount + moved,
				Habitat = habitat,  -- NEW
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] BringGhostsHome handler connected")
end
```

---

### 5. Add Habitat Remotes

**Around Line ~75-90 (where remotes are created):**

```lua
-- Add these remote creations:
createRemote("Habitat", "RemoteFunction")  -- For habitat operations
createRemote("HabitatUpdate", "RemoteEvent")  -- For habitat data updates
```

---

### 6. Update UI Broadcast Loop

**Current (Line ~720-745):**
```lua
-- UI update loop (broadcast every second)
task.spawn(function()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data then
				local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
				if updateRemote then
					updateRemote:FireClient(player, {
						VacuumCharge = data.charge,
						Energy = data.coins,
						GhostCount = data.ghosts,
						GhostInventory = data.ghostInventory,
						Rooms = data.rooms,
						UnlockedZones = data.unlockedZones,
					})
				end
			end
		end
	end
end)
```

**NEW (with Habitat income):**
```lua
-- UI update loop (broadcast every second)
task.spawn(function()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data then
				-- Calculate habitat income
				local habitatIncome = habitatSystem:calculateTotalIncome(player.UserId)
				
				-- Apply habitat income
				data.coins = data.coins + habitatIncome

				-- Get updated habitat data
				local habitat = habitatSystem:getHabitatData(player.UserId)

				local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
				if updateRemote then
					updateRemote:FireClient(player, {
						VacuumCharge = data.charge,
						Energy = data.coins,
						GhostCount = habitatSystem:getGhostCount(player.UserId),
						Habitat = habitat,  -- NEW
						GhostInventory = data.ghostInventory,
						Rooms = data.rooms,
						UnlockedZones = data.unlockedZones,
					})
				end
			end
		end
	end
end)
```

---

### 7. Add Habitat Remote Handlers

**Add before startup section (Line ~650):**

```lua
-- Habitat remote handler
local habitatRemote = remotesFolder:FindFirstChild("Habitat")
if habitatRemote then
	habitatRemote.OnServerInvoke = function(player, action, arg)
		local userId = player.UserId
		
		if action == "ReleaseGhost" then
			local success, refund = habitatSystem:removeGhostFromHabitat(player, arg)
			if success then
				local data = playerData[userId]
				data.coins = data.coins + refund
				return true, refund
			else
				return false, refund
			end
		elseif action == "GetHabitat" then
			return habitatSystem:getHabitatData(userId)
		elseif action == "ApplyCosmetic" then
			local ghostKey, skinName = arg.ghostKey, arg.skinName
			return habitatSystem:applyCosmetic(player, ghostKey, skinName)
		end
		
		return false, "Unknown action"
	end
	print("[PHASE 4] Habitat handler connected")
end
```

---

### 8. GameClient.lua Integration

**Add Habitat tab to tabs array (Line ~70-85):**

```lua
local tabs = {
	{ name = "Ghost", label = "👻\nGhost" },
	{ name = "HQ", label = "🏠\nHQ" },
	{ name = "Habitat", label = "🏠\nHabitat" },  -- NEW
	{ name = "Zones", label = "🌍\nZones" },
	-- ... rest of tabs ...
}
```

**Initialize HabitatUI (Line ~45-50):**

```lua
local HabitatUI = require(script.Parent.modules.HabitatUI)
local habitatUI = HabitatUI:new()

-- In initialize function (around line 85):
habitatUI:initialize(self, self.ui.screenGui)
self.habitatUI = habitatUI
```

**Handle Habitat tab content (in setupTabContent):**

```lua
function GameClient:setupTabContent(tabName, tabContent)
	if tabName == "Habitat" then
		self.habitatUI:show()
	else
		self.habitatUI:hide()
	end
end
```

---

## 🔄 Data Flow

**Catching a Ghost:**
```
1. Player catches ghost in zone
2. Server validates (charge, range)
3. habitatSystem:addGhostToHabitat() is called
4. Ghost added to player.habitat.ghosts
5. UI updates with new ghost count
6. Player sees ghost in Habitat tab
```

**Passive Income:**
```
1. Every 1 second, MainServer income loop runs
2. For each ghost in habitat:
   - Calculate: rarity × level_multiplier × room_bonus
3. Add total income to player.coins
4. Broadcast update to client
5. Energy counter increases
```

**Releasing a Ghost:**
```
1. Player clicks "Release" button in Habitat
2. Client calls: habitatRemote:InvokeServer("ReleaseGhost", ghostKey)
3. Server removes ghost from habitat.ghosts
4. Server calculates refund based on rarity + level
5. Player receives coins as refund
6. Habitat count updates
```

---

## 📊 Testing Checklist

- [ ] HabitatSystem loads without errors
- [ ] Player starts with 5-slot habitat
- [ ] Catching ghost adds to habitat (not coins)
- [ ] Habitat shows correct ghost count
- [ ] Ghost income calculates correctly (0.5/sec per Common)
- [ ] Coins increase each second from habitat income
- [ ] Releasing ghost gives refund
- [ ] Habitat UI shows all ghosts
- [ ] Filter by rarity works
- [ ] Ghost details panel shows correctly
- [ ] Upgrade room increases habitat slots

---

## 🐛 Common Issues

**Issue:** Ghosts not appearing in habitat
- Check: habitatSystem:addGhostToHabitat() is called in catch handler
- Check: player.habitat.ghosts is populated

**Issue:** Coins not increasing automatically
- Check: habitatSystem:calculateTotalIncome() is called in UI loop
- Check: income tick is running (check logs for "incomeTick")
- Check: ghosts have energyOutput values

**Issue:** Habitat UI not showing
- Check: HabitatUI initialized in GameClient
- Check: Habitat tab added to tabs array
- Check: habitatUI:show()/hide() called on tab switch

---

## 🚀 Rollout Steps

1. **Backup** current MainServer code
2. **Add** HabitatSystem require statement
3. **Update** playerData structure with habitat field
4. **Replace** Bring Ghosts Home handler
5. **Update** Catch handler to use habitatSystem
6. **Update** UI broadcast loop for income
7. **Add** Habitat remotes and handlers
8. **Update** GameClient with HabitatUI
9. **Test** in Studio:
   - Catch a ghost → appears in Habitat ✅
   - Coins increase automatically ✅
   - Release ghost → get refund ✅
10. **Deploy** to live

---

**Status:** Ready for integration ✅

This implementation changes the game from a coins-only progression to a **collection-based system** that will dramatically improve player retention.

