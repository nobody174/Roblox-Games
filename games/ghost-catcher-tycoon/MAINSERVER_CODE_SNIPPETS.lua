--
-- HABITAT SYSTEM - CODE SNIPPETS FOR MAINSERVER
-- Copy-paste ready code for integrating HabitatSystem
-- Author: Claude Code
-- Date: 2026-06-06
--
-- INSTRUCTIONS:
-- 1. Read HABITAT_INTEGRATION_GUIDE.md for context
-- 2. Find the matching section in MainServer_Phase4_Extended.lua
-- 3. Replace the OLD code with the NEW code below
-- 4. Test in Studio
--

-- ============================================================================
-- SNIPPET 1: Load HabitatSystem (after SystemManager, around line 35)
-- ============================================================================

print("[PHASE 4] Proceeding with MainServer initialization...")

-- Load HabitatSystem
local HabitatSystem = require(game:GetService("ServerScriptService"):WaitForChild("systems"):WaitForChild("HabitatSystem"))
local habitatSystem = HabitatSystem:new()
print("[PHASE 4] HabitatSystem loaded")

-- Load DataManager for DataStore persistence (optional for Phase 4 testing)
local dataManager = nil
local dataManagerModule = game:GetService("ServerScriptService"):FindFirstChild("Data")
if dataManagerModule then
	local DataManager = require(dataManagerModule:FindFirstChild("DataManager"))
	dataManager = DataManager:new()
	print("[PHASE 4] DataManager loaded")
else
	print("[PHASE 4] DataManager not found - running in memory-only mode for testing")
end

-- ============================================================================
-- SNIPPET 2: Update initPlayerData function (around line 265)
-- ============================================================================

local function initPlayerData(userId)
	if not playerData[userId] then
		playerData[userId] = {
			charge = 0,
			coins = 0,
			ghosts = 0,
			ghostInventory = {}, -- { ghostName: { level, rarity } }
			rooms = {
				GhostChamber = { level = 1 },
				TrainingFacility = { level = 1 },
				EnergyReactor = { level = 1 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = { ["Whisper Woods"] = true },
			habitat = {                            -- NEW: Ghost collection
				maxSlots = 5,
				ghosts = {}
			}
		}
	end
	return playerData[userId]
end

-- ============================================================================
-- SNIPPET 3: Update Catch Handler (around line 410-445)
-- ============================================================================

-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)

		local charge = data.charge

		-- Check if player has enough charge
		if charge < 10 then
			print("[PHASE 4] " .. player.Name .. " tried to catch but has insufficient charge (" .. charge .. "%)")
			return
		end

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
		local rarity = closestGhost:GetAttribute("Rarity")

		-- Deduct charge
		data.charge = math.max(data.charge - 10, 0)

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

		-- NEW: Add to habitat instead of temp inventory
		local success, result = habitatSystem:addGhostToHabitat(player, {
			name = ghostName,
			rarity = rarity,
			level = 1,
		})

		if success then
			data.ghosts = data.ghosts + 1
			print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") - added to habitat")
		else
			-- Habitat full - give bonus coins instead
			data.coins = data.coins + coins * 5
			print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " but habitat full - got bonus coins")
		end

		-- Remove ghost from world
		closestGhost:Destroy()
		activeGhosts[closestGhost] = nil
	end)
	print("[PHASE 4] Catch handler connected")
end

-- ============================================================================
-- SNIPPET 4: Replace Bring Ghosts Home Handler (around line 448-474)
-- ============================================================================

-- Bring Ghosts Home remote handler (NEW - collection model)
local bringRemote = remotesFolder:FindFirstChild(Constants.Remotes.BringGhostsHome)
if bringRemote then
	bringRemote.OnServerEvent:Connect(function(player)
		local data = initPlayerData(player.UserId)
		local userId = player.UserId

		-- Get habitat data
		local habitat = habitatSystem:getHabitatData(userId)
		if not habitat then
			print("[PHASE 4] " .. player.Name .. " habitat not found")
			return
		end

		local ghostCountBefore = habitatSystem:getGhostCount(userId)

		-- Check if habitat is full
		if ghostCountBefore >= habitat.maxSlots then
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
				GhostCount = ghostCountBefore + moved,
				Habitat = habitat,
				GhostInventory = data.ghostInventory,
				Rooms = data.rooms,
				UnlockedZones = data.unlockedZones,
			})
		end
	end)
	print("[PHASE 4] BringGhostsHome handler connected")
end

-- ============================================================================
-- SNIPPET 5: Add Habitat Remotes (around line 75-90)
-- ============================================================================

-- Add these two lines after other remote creations:
createRemote("Habitat", "RemoteFunction")
createRemote("HabitatUpdate", "RemoteEvent")

-- ============================================================================
-- SNIPPET 6: Update Income Loop (around line 720-745)
-- ============================================================================

-- UI update loop (broadcast every second)
task.spawn(function()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data then
				-- NEW: Calculate habitat income
				local habitatIncome = habitatSystem:calculateTotalIncome(player.UserId)

				-- NEW: Apply habitat income
				data.coins = data.coins + habitatIncome

				-- NEW: Get updated habitat data
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

-- ============================================================================
-- SNIPPET 7: Add Habitat Remote Handlers (around line 650, before startup)
-- ============================================================================

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
				print("[PHASE 4] " .. player.Name .. " released ghost, received " .. refund .. " coins")
				return true, refund
			else
				return false, refund
			end
		elseif action == "GetHabitat" then
			return habitatSystem:getHabitatData(userId)
		elseif action == "ApplyCosmetic" then
			local ghostKey, skinName = arg.ghostKey, arg.skinName
			local success = habitatSystem:applyCosmetic(player, ghostKey, skinName)
			return success
		end

		return false, "Unknown action"
	end
	print("[PHASE 4] Habitat handler connected")
end

-- Also initialize HabitatSystem with remotes (add after creating remotes):
habitatSystem:initialize(remotesFolder)

-- ============================================================================
-- SNIPPET 8: Update Player Initialization (around line 290)
-- ============================================================================

-- Hook player join to load data from DataStore
Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId

	-- Load from DataStore if available (or create new)
	local dmData = nil
	if dataManager then
		dmData = dataManager:loadPlayerData(player)
	end

	-- Initialize or load simple data structure for fast access
	if dmData and dmData.Coins then
		-- Restore from previous session
		playerData[userId] = {
			charge = 0, -- Charge always resets on join
			coins = dmData.Coins or 0,
			ghosts = (dmData.GhostCount or 0),
			ghostInventory = dmData.GhostInventory or {},
			rooms = dmData.Rooms or {
				GhostChamber = { level = 1 },
				TrainingFacility = { level = 1 },
				EnergyReactor = { level = 1 },
				ResearchLab = { level = 0 },
				BossArena = { level = 0 },
			},
			unlockedZones = dmData.UnlockedZones or { ["Whisper Woods"] = true },
			habitat = dmData.Habitat or {  -- NEW: Restore habitat
				maxSlots = 5,
				ghosts = {}
			}
		}
		print("[PHASE 4] Loaded player data for " .. player.Name .. " from DataStore")
	else
		-- New player
		initPlayerData(userId)
		print("[PHASE 4] Created new player data for " .. player.Name)
	end

	-- NEW: Initialize HabitatSystem for this player
	habitatSystem:initializePlayer(player)

	-- Initialize player in SystemManager systems (for Quests, Bosses, etc.)
	if SystemManager then
		task.spawn(function()
			SystemManager:initializePlayer(player)
		end)
	end
end)

-- ============================================================================
-- END OF SNIPPETS
-- ============================================================================
