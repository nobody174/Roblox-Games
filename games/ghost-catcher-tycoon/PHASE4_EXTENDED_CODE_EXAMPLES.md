<!--
  Ghost Catcher Tycoon - Phase 4 Extended Code Examples
  Copy-paste ready handler implementations
-->

# Phase 4 Extended — Code Examples & Copy-Paste Templates

## Handler 1: UpgradeRoom

### Full Handler (Lines 257-291 in MainServer_Phase4_Extended.lua)

```lua
-- UpgradeRoom remote handler
local upgradeRoomRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpgradeRoom)
if upgradeRoomRemote then
	upgradeRoomRemote.OnServerEvent:Connect(function(player, roomName)
		local data = initPlayerData(player.UserId)

		-- Validate room
		if not roomConfig[roomName] or not data.rooms[roomName] then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade invalid room: " .. roomName)
			return
		end

		local room = data.rooms[roomName]
		local config = roomConfig[roomName]

		-- Check max level
		if room.level >= config.maxLevel then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade " .. roomName .. " beyond max level")
			return
		end

		-- Calculate cost (cost scales with level)
		local cost = math.ceil(config.baseCost * (config.costMultiplier ^ (room.level - 1)))

		-- Check coins
		if data.coins < cost then
			print("[PHASE 4] " .. player.Name .. " tried to upgrade " .. roomName .. " but has insufficient coins (" .. data.coins .. " < " .. cost .. ")")
			return
		end

		-- Deduct coins and upgrade
		data.coins = data.coins - cost
		room.level = room.level + 1

		print("[PHASE 4] " .. player.Name .. " upgraded " .. roomName .. " to level " .. room.level .. " for " .. cost .. " coins!")
	end)
	print("[PHASE 4] UpgradeRoom handler connected")
end
```

### Client-Side Call Example

```lua
-- From GameClient.lua or any UI button
local upgradeButton = -- reference to your button
upgradeButton.Activated:Connect(function()
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:FindFirstChild("Remotes")
	if remotesFolder then
		local upgradeRemote = remotesFolder:FindFirstChild("UpgradeRoom")
		if upgradeRemote then
			upgradeRemote:FireServer("GhostChamber")  -- or any room name
			print("Upgrade request sent!")
		end
	end
end)
```

---

## Handler 2: TrainGhost

### Full Handler (Lines 293-327 in MainServer_Phase4_Extended.lua)

```lua
-- TrainGhost remote handler
local trainGhostRemote = remotesFolder:FindFirstChild(Constants.Remotes.TrainGhost)
if trainGhostRemote then
	trainGhostRemote.OnServerEvent:Connect(function(player, ghostKey)
		local data = initPlayerData(player.UserId)

		-- Validate ghost
		if not data.ghostInventory[ghostKey] then
			print("[PHASE 4] " .. player.Name .. " tried to train non-existent ghost: " .. ghostKey)
			return
		end

		local ghost = data.ghostInventory[ghostKey]

		-- Check max level
		if ghost.level >= 10 then
			print("[PHASE 4] " .. player.Name .. " tried to train " .. ghost.name .. " beyond max level 10")
			return
		end

		-- Calculate cost (scales with ghost level and rarity)
		local rarityMultiplier = { Common = 1, Uncommon = 1.5, Rare = 2, Epic = 3, Legendary = 5 }
		local multiplier = rarityMultiplier[ghost.rarity] or 1
		local baseCost = 50 * multiplier
		local cost = math.ceil(baseCost * (ghost.level))

		-- Check coins
		if data.coins < cost then
			print("[PHASE 4] " .. player.Name .. " tried to train " .. ghost.name .. " but has insufficient coins (" .. data.coins .. " < " .. cost .. ")")
			return
		end

		-- Deduct coins and train
		data.coins = data.coins - cost
		ghost.level = ghost.level + 1

		print("[PHASE 4] " .. player.Name .. " trained " .. ghost.name .. " to level " .. ghost.level .. " for " .. cost .. " coins!")
	end)
	print("[PHASE 4] TrainGhost handler connected")
end
```

### Client-Side Call Example

```lua
-- From Ghost tab inventory list
local trainButton = -- reference to your button (for specific ghost)
local ghostKey = "Specter_1234"  -- from ghostInventory table

trainButton.Activated:Connect(function()
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:FindFirstChild("Remotes")
	if remotesFolder then
		local trainRemote = remotesFolder:FindFirstChild("TrainGhost")
		if trainRemote then
			trainRemote:FireServer(ghostKey)
			print("Training " .. ghostKey .. "...")
		end
	end
end)
```

---

## Handler 3: HatchEgg

### Full Handler (Lines 329-361 in MainServer_Phase4_Extended.lua)

```lua
-- HatchEgg remote handler (gacha)
local hatchEggRemote = remotesFolder:FindFirstChild(Constants.Remotes.HatchEgg)
if hatchEggRemote then
	hatchEggRemote.OnServerEvent:Connect(function(player, eggName)
		local data = initPlayerData(player.UserId)

		-- Validate egg
		if not eggConfig[eggName] then
			print("[PHASE 4] " .. player.Name .. " tried to hatch invalid egg: " .. eggName)
			return
		end

		local eggData = eggConfig[eggName]

		-- Check coins
		if data.coins < eggData.cost then
			print("[PHASE 4] " .. player.Name .. " tried to hatch " .. eggName .. " but has insufficient coins (" .. data.coins .. " < " .. eggData.cost .. ")")
			return
		end

		-- Deduct coins
		data.coins = data.coins - eggData.cost

		-- Roll for rarity (simplified: use egg's base rarity)
		local rarity = eggData.rarity

		-- Get random ghost from that rarity pool
		local ghostPool = availableGhosts[rarity] or availableGhosts["Common"]
		local hatchedName = ghostPool[math.random(1, #ghostPool)]

		-- Add to inventory
		local inventoryKey = hatchedName .. "_" .. math.random(1000, 9999)
		data.ghostInventory[inventoryKey] = { name = hatchedName, level = 1, rarity = rarity }
		data.ghosts = data.ghosts + 1

		print("[PHASE 4] " .. player.Name .. " hatched " .. eggName .. " and received " .. hatchedName .. " (" .. rarity .. ")!")
	end)
	print("[PHASE 4] HatchEgg handler connected")
end
```

### Client-Side Call Example

```lua
-- From Shop tab egg list
local hatchButton = -- reference to your button
local selectedEgg = "Common Egg"  -- user selection

hatchButton.Activated:Connect(function()
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:FindFirstChild("Remotes")
	if remotesFolder then
		local hatchRemote = remotesFolder:FindFirstChild("HatchEgg")
		if hatchRemote then
			hatchRemote:FireServer(selectedEgg)
			print("Hatching " .. selectedEgg .. "...")
		end
	end
end)
```

---

## Handler 4: UnlockZone

### Full Handler (Lines 363-394 in MainServer_Phase4_Extended.lua)

```lua
-- UnlockZone remote handler
local unlockZoneRemote = remotesFolder:FindFirstChild(Constants.Remotes.UnlockZone)
if unlockZoneRemote then
	unlockZoneRemote.OnServerEvent:Connect(function(player, zoneName)
		local data = initPlayerData(player.UserId)

		-- Validate zone
		if not zoneConfig[zoneName] then
			print("[PHASE 4] " .. player.Name .. " tried to unlock invalid zone: " .. zoneName)
			return
		end

		local zoneData = zoneConfig[zoneName]

		-- Check if already unlocked
		local isUnlocked = false
		for _, unlocked in ipairs(data.unlockedZones) do
			if unlocked == zoneName then
				isUnlocked = true
				break
			end
		end

		if isUnlocked then
			print("[PHASE 4] " .. player.Name .. " tried to unlock already-unlocked zone: " .. zoneName)
			return
		end

		-- Check coins
		if data.coins < zoneData.cost then
			print("[PHASE 4] " .. player.Name .. " tried to unlock " .. zoneName .. " but has insufficient coins (" .. data.coins .. " < " .. zoneData.cost .. ")")
			return
		end

		-- Deduct coins and unlock
		data.coins = data.coins - zoneData.cost
		table.insert(data.unlockedZones, zoneName)

		print("[PHASE 4] " .. player.Name .. " unlocked " .. zoneName .. " for " .. zoneData.cost .. " coins!")
	end)
	print("[PHASE 4] UnlockZone handler connected")
end
```

### Client-Side Call Example

```lua
-- From Zones tab zone list
local unlockButton = -- reference to your button
local targetZone = "Foggy Fields"  -- user selection

unlockButton.Activated:Connect(function()
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:FindFirstChild("Remotes")
	if remotesFolder then
		local unlockRemote = remotesFolder:FindFirstChild("UnlockZone")
		if unlockRemote then
			unlockRemote:FireServer(targetZone)
			print("Unlocking " .. targetZone .. "...")
		end
	end
end)
```

---

## Configuration Tables (Lines 48-102)

### Room Configuration

```lua
local roomConfig = {
	GhostChamber = { baseCost = 100, costMultiplier = 1.5, maxLevel = 10 },
	TrainingFacility = { baseCost = 150, costMultiplier = 1.5, maxLevel = 10 },
	EnergyReactor = { baseCost = 200, costMultiplier = 1.5, maxLevel = 10 },
	ResearchLab = { baseCost = 300, costMultiplier = 1.5, maxLevel = 10 },
	BossArena = { baseCost = 500, costMultiplier = 1.5, maxLevel = 10 },
}
```

### Egg Configuration

```lua
local eggConfig = {
	["Common Egg"] = { cost = 250, rarity = "Common" },
	["Uncommon Egg"] = { cost = 1200, rarity = "Uncommon" },
	["Rare Egg"] = { cost = 5000, rarity = "Rare" },
	["Epic Egg"] = { cost = 15000, rarity = "Epic" },
	["Legendary Egg"] = { cost = 45000, rarity = "Legendary" },
}
```

### Zone Configuration

```lua
local zoneConfig = {
	["Whisper Woods"] = { unlocked = true, cost = 0 },
	["Foggy Fields"] = { unlocked = false, cost = 1500 },
	["Gloomy Graveyard"] = { unlocked = false, cost = 6000 },
	["Electro Alley"] = { unlocked = false, cost = 18000 },
	["Frostbite Caverns"] = { unlocked = false, cost = 42000 },
}
```

### Available Ghosts by Rarity

```lua
local availableGhosts = {
	Common = { "Puffling", "Wobbler", "Peekaboo", "Drifter", "Blinklet" },
	Uncommon = { "Sparkling Sprite", "Shadowling", "Giggler", "Lantern Wisp", "Dustwhirl" },
	Rare = { "Voltgeist", "Frostwhisper", "Bloomshade", "Geargrin", "Tidebound" },
	Epic = { "Phantom Knight", "Inferno Wraith", "Astral Drifter", "Cryo Reaper", "Thunder Jester" },
	Legendary = { "Ancient One", "Void King", "Star Reaper", "Eternal Shade", "Primordial Ghost" },
}
```

---

## Helper Functions (Lines 179-185)

### Initialize Player Data

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
			unlockedZones = { "Whisper Woods" },
		}
	end
	return playerData[userId]
end
```

---

## Testing Pattern

All handlers follow this pattern:

```lua
if <handler>Remote then
	<handler>Remote.OnServerEvent:Connect(function(player, param)
		local data = initPlayerData(player.UserId)
		
		-- Validation checks (3-5 per handler)
		if not isValid(param) then return end
		if data.coins < cost then return end
		if atMaxLevel() then return end
		
		-- Perform action
		data.coins = data.coins - cost
		-- update state
		
		-- Log success
		print("[PHASE 4] Success: " .. player.Name .. " action")
	end)
	print("[PHASE 4] <handler> handler connected")
end
```

---

## Common Errors & Fixes

### Error: "tried to [action] invalid [resource]"
**Cause:** Resource doesn't exist in config table  
**Fix:** Check spelling and add to config if needed

### Error: "insufficient coins"
**Cause:** Player doesn't have enough coins  
**Fix:** Client should show cost first, disable button if < cost

### Error: "max level reached"
**Cause:** Player trying to upgrade/train beyond level 10  
**Fix:** Client should show current level and max level caps

### Error: "Handler not connected"
**Cause:** Remote not found in Remotes folder  
**Fix:** Check Constants.Remotes names match, remotes auto-create

---

**File Location:** `games/ghost-catcher-tycoon/src/server/MainServer_Phase4_Extended.lua`  
**Total Lines:** 485  
**Handlers:** 6 (Charge, Catch, UpgradeRoom, TrainGhost, HatchEgg, UnlockZone)
