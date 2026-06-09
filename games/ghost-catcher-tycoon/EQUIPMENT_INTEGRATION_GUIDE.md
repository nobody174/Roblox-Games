# Equipment System Integration Guide

## Overview

This guide shows how to integrate the new catching equipment system into MainServer_Phase4_Extended.lua

## New Modules Created

1. **EquipmentData.lua** (shared) — Equipment definitions (9 tiers)
2. **PlayerInventory.lua** (server) — Manage player equipment, coins, energy, level
3. **CatchingSystem.lua** (server) — Handle catch attempts with new mechanics

---

## Integration Steps

### Step 1: Load Modules at Top of MainServer

**Location:** After other requires (around line 50)

```lua
-- Load new systems
local EquipmentData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("EquipmentData"))
local PlayerInventory = require(script.Parent:WaitForChild("PlayerInventory"))
local CatchingSystem = require(script.Parent:WaitForChild("CatchingSystem"))

print("[PHASE 4] Equipment systems loaded")
```

---

### Step 2: Initialize Player on Join

**Location:** In Players.PlayerAdded event (add to existing initialization)

```lua
Players.PlayerAdded:Connect(function(player)
	-- Existing initialization...
	
	-- Initialize equipment inventory
	PlayerInventory:initializePlayer(player.UserId)
	print("[PHASE 4] Equipment inventory initialized for " .. player.Name)
end)
```

---

### Step 3: Replace Catch Handler (Lines 607-699)

**OLD CODE (Current catch handler):** Lines 607-699 in MainServer

**NEW CODE (Equipment-based catch handler):**

```lua
-- ============================================================================
-- CATCH REMOTE HANDLER (With Equipment System)
-- ============================================================================

local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		local userId = player.UserId
		local data = initPlayerData(userId)
		
		-- Find nearest ghost to player
		local character = player.Character
		if not character then return end

		local playerPos = character:FindFirstChild("HumanoidRootPart")
		if not playerPos then return end

		playerPos = playerPos.Position
		local closestGhost = nil
		local closestDist = Config.GhostCatchDistance

		for ghostInstance, ghostData in pairs(activeGhosts) do
			if ghostInstance and ghostInstance.Parent then
				local dist = (ghostInstance.Position - playerPos).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestGhost = ghostInstance
				end
			end
		end

		if not closestGhost then
			print("[PHASE 4] " .. player.Name .. " tried to catch but no ghosts nearby")
			return
		end

		-- Get ghost data
		local ghostName = closestGhost:GetAttribute("GhostName")
		local ghostRarity = closestGhost:GetAttribute("Rarity")
		
		-- Get current zone (if ZoneManager available)
		local currentZone = "Unknown Zone"
		if zoneManager then
			currentZone = zoneManager:detectPlayerZone(playerPos) or "Unknown Zone"
		end

		-- Check inventory limit
		local maxSlots = getMaxGhostSlots(data.rooms.GhostChamber.level)
		local currentCount = 0
		for _ in pairs(data.ghostInventory) do
			currentCount = currentCount + 1
		end

		if currentCount >= maxSlots then
			print("[PHASE 4] " .. player.Name .. " tried to catch but inventory is full (" .. currentCount .. "/" .. maxSlots .. ")")
			local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
			if notifyRemote then
				notifyRemote:FireClient(player, "Inventory full! Release ghosts or upgrade Ghost Chamber", Color3.fromRGB(255, 100, 100))
			end
			return
		end

		-- ================================================================
		-- NEW: Use CatchingSystem for attempt
		-- ================================================================
		
		local catchResult = CatchingSystem:attemptCatch(player, closestGhost, currentZone)
		
		if catchResult.success then
			-- CATCH SUCCESSFUL
			print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. ghostRarity .. ") for " .. catchResult.coinsGained .. " coins!")
			
			-- Add to ghost inventory
			local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
			data.ghostInventory[inventoryKey] = { 
				name = ghostName, 
				level = 1, 
				rarity = ghostRarity,
				xpGained = catchResult.xpGained,
				caughtWith = catchResult.equipment,
				zone = catchResult.zone,
			}
			
			-- Update player coins from inventory system
			data.coins = PlayerInventory:getCoins(userId)
			data.ghosts = data.ghosts + 1
			
			-- Notify player of success
			local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
			if notifyRemote then
				local msg = "✅ Caught " .. ghostName .. "! +" .. catchResult.coinsGained .. " coins"
				notifyRemote:FireClient(player, msg, Color3.fromRGB(0, 255, 0))
			end
			
		else
			-- CATCH FAILED
			if catchResult.reason == "NOT_ENOUGH_ENERGY" then
				print("[PHASE 4] " .. player.Name .. " tried to catch but not enough energy")
				local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
				if notifyRemote then
					notifyRemote:FireClient(player, "Not enough energy! (" .. catchResult.currentEnergy .. "/" .. catchResult.energyNeeded .. ")", Color3.fromRGB(255, 100, 100))
				end
				return
			else
				-- Ghost escaped
				print("[PHASE 4] " .. player.Name .. " attempted to catch " .. ghostName .. " but ghost escaped (roll: " .. catchResult.roll .. " vs " .. catchResult.catchRate .. "%)")
				
				-- Update energy from inventory
				data.energy = PlayerInventory:getEnergy(userId)
				
				local notifyRemote = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
				if notifyRemote then
					notifyRemote:FireClient(player, "❌ Ghost escaped! Try stronger equipment.", Color3.fromRGB(255, 150, 100))
				end
			end
		end
		
		-- Update UI with new energy/coins
		local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
		if updateRemote then
			updateRemote:FireClient(player, data)
		end
		
	end)
	print("[PHASE 4] Catch handler connected (with equipment system)")
end
```

---

### Step 4: Add Equipment Management Remote Handlers

**Add after the catch handler (around line 700):**

```lua
-- ============================================================================
-- EQUIPMENT MANAGEMENT REMOTES
-- ============================================================================

-- Purchase Equipment
local purchaseEquipmentRemote = createRemote("PurchaseEquipment", "RemoteFunction")
purchaseEquipmentRemote.OnServerInvoke = function(player, equipmentName)
	local userId = player.UserId
	local result = CatchingSystem:purchaseEquipment(userId, equipmentName)
	
	if result.success then
		print("[PHASE 4] " .. player.Name .. " purchased " .. equipmentName)
		local data = initPlayerData(userId)
		data.coins = PlayerInventory:getCoins(userId)
	else
		print("[PHASE 4] " .. player.Name .. " failed to purchase " .. equipmentName .. ": " .. result.reason)
	end
	
	return result
end

-- Equip Equipment
local equipEquipmentRemote = createRemote("EquipEquipment", "RemoteFunction")
equipEquipmentRemote.OnServerInvoke = function(player, equipmentName)
	local userId = player.UserId
	local result = CatchingSystem:equipEquipment(userId, equipmentName)
	
	if result.success then
		print("[PHASE 4] " .. player.Name .. " equipped " .. equipmentName)
	end
	
	return result
end

-- Get Equipment Info
local getEquipmentRemote = createRemote("GetEquipmentInfo", "RemoteFunction")
getEquipmentRemote.OnServerInvoke = function(player, ghostRarity)
	local userId = player.UserId
	return CatchingSystem:getEquipmentInfo(userId, ghostRarity)
end

-- Get All Player Equipment
local getPlayerEquipmentRemote = createRemote("GetPlayerEquipment", "RemoteFunction")
getPlayerEquipmentRemote.OnServerInvoke = function(player)
	local userId = player.UserId
	return CatchingSystem:getPlayerEquipmentStats(userId)
end

print("[PHASE 4] Equipment management remotes created")
```

---

### Step 5: Update Player Leave Handler

**Location:** Find Players.PlayerRemoving event and add:**

```lua
Players.PlayerRemoving:Connect(function(player)
	-- Existing cleanup...
	
	-- Clean up equipment inventory
	PlayerInventory:removePlayer(player.UserId)
	print("[PHASE 4] Cleaned up equipment for " .. player.Name)
end)
```

---

## Client-Side Integration

### New RemoteFunction Calls Available to Client

```lua
-- Get equipment info for ghost (before attempting catch)
local equipmentInfo = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetEquipmentInfo"):InvokeServer(ghostRarity)
-- Returns: {name, tier, chargeTime, energyCost, catchRate, currentEnergy, maxEnergy, description}

-- Get all equipment player owns
local allEquipment = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlayerEquipment"):InvokeServer()
-- Returns: {[equipmentName] = {name, tier, cost, level, chargeTime, energyCost, isEquipped, description}, ...}

-- Purchase equipment
local result = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PurchaseEquipment"):InvokeServer("QuantumDevice")
-- Returns: {success, reason/equipment, coinsSpent/coinsRemaining}

-- Equip equipment
local result = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipEquipment"):InvokeServer("QuantumDevice")
-- Returns: {success, equipped}
```

---

## Data Persistence

Currently, PlayerInventory stores data in memory (tables). To persist across server restarts:

1. **Hook into existing DataManager** if available
2. **Save on player leave** (PlayerRemoving event)
3. **Load on player join** (PlayerAdded event)

Example integration with DataManager:

```lua
-- On player join, load inventory
local savedData = dataManager:loadPlayerData(player.UserId)
if savedData and savedData.equipment then
	-- Restore equipment inventory
	PlayerInventory:initializePlayer(player.UserId)
	local inv = PlayerInventory:getInventory(player.UserId)
	inv.owned = savedData.equipment.owned
	inv.equipped = savedData.equipment.equipped
	inv.coins = savedData.equipment.coins
	inv.level = savedData.equipment.level
	inv.energy = savedData.equipment.energy
end

-- On player leave, save inventory
Players.PlayerRemoving:Connect(function(player)
	local inv = PlayerInventory:getInventory(player.UserId)
	dataManager:savePlayerData(player.UserId, {
		equipment = {
			owned = inv.owned,
			equipped = inv.equipped,
			coins = inv.coins,
			level = inv.level,
			energy = inv.energy,
		}
	})
end)
```

---

## Testing Checklist

- [ ] Load game and verify equipment inventory initialized
- [ ] Try catching ghost with Basic Net (should work on Common)
- [ ] Try catching Rare ghost with Basic Net (should have low success rate)
- [ ] Catch enough ghosts to earn coins
- [ ] Purchase Reinforced Net (costs 500 coins)
- [ ] Equip Reinforced Net
- [ ] Try catching Rare ghost with Reinforced Net (should have higher success rate)
- [ ] Check energy system (deplete energy, verify catch fails)
- [ ] Check that energy regenerates

---

## What's Next

1. **Client UI Integration** — Show equipment slot, success rates, charge timer
2. **Level/XP System** — Track player level, unlock equipment at milestones
3. **Skill Points** — Add passive bonuses to catch rates, energy, coins
4. **Data Persistence** — Hook into existing DataManager for saves

---

*Created: 2026-06-09*
