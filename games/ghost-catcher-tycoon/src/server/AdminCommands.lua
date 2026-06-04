--
-- Ghost Catcher Tycoon - Admin Commands
-- Drop this in ServerScriptService to enable admin commands
-- NOTE: This script should run AFTER MainServer_Phase4_Extended.lua
--

local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for main server script to set up shared player data
local sharedDataWaitTime = 0
local playerData = nil
while not playerData and sharedDataWaitTime < 30 do
	playerData = _G.GhostCatcherPlayerData
	if not playerData then
		task.wait(0.1)
		sharedDataWaitTime = sharedDataWaitTime + 0.1
	end
end

-- If shared data not found, create local storage (fallback)
if not playerData then
	playerData = {}
	_G.GhostCatcherPlayerData = playerData
	print("[ADMIN COMMANDS] Created new player data storage (main server not running)")
else
	print("[ADMIN COMMANDS] Connected to main server player data")
end

-- Ensure Remotes folder exists
if not rs:FindFirstChild("Remotes") then
	local remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = rs
end

local remotesFolder = rs:FindFirstChild("Remotes")

-- Create AdminCommand remote if it doesn't exist
if not remotesFolder:FindFirstChild("AdminCommand") then
	local adminRemote = Instance.new("RemoteFunction")
	adminRemote.Name = "AdminCommand"
	adminRemote.Parent = remotesFolder
end

-- Admin list
local adminList = {
	["nobodylearn174"] = true,  -- Default admin (change to your username)
}

-- Initialize player data (matches main server structure)
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

-- Check if player is admin
local function isAdmin(playerName)
	return adminList[playerName] == true
end

-- Add player to admin list
local function makeAdmin(playerName)
	adminList[playerName] = true
	print("[ADMIN] " .. playerName .. " is now an admin")
end

-- Remove from admin list
local function removeAdmin(playerName)
	adminList[playerName] = nil
	print("[ADMIN] " .. playerName .. " is no longer an admin")
end

-- Admin command handler with permission checking
local adminRemote = remotesFolder:FindFirstChild("AdminCommand")
if adminRemote then
	adminRemote.OnServerInvoke = function(player, command, arg)
		-- Check admin permission
		if not isAdmin(player.Name) then
			print("[ADMIN] " .. player.Name .. " is not an admin (cannot use /" .. command .. ")")
			return false
		end

		local data = initPlayerData(player.UserId)
		local updateRemote = remotesFolder:FindFirstChild("UpdateUI")

		if command == "coin" or command == "gold" then
			data.coins = data.coins + 1000
			print("[ADMIN] " .. player.Name .. " gained 1000 coins (total: " .. data.coins .. ")")
			-- Send immediate broadcast to update UI with full payload
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
			return true

		elseif command == "energy" or command == "eng" then
			data.coins = data.coins + 1000
			print("[ADMIN] " .. player.Name .. " gained 1000 energy (total: " .. data.coins .. ")")
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
			return true

		elseif command == "ghost" or command == "gh" then
			local ghostName = arg or "Wraith"
			local inventoryKey = ghostName .. "_" .. math.random(1000, 9999)
			data.ghostInventory[inventoryKey] = {
				name = ghostName,
				rarity = "Rare",
				level = 1
			}
			data.ghosts = data.ghosts + 1
			print("[ADMIN] " .. player.Name .. " spawned ghost: " .. ghostName)
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
			return true

		elseif command == "admin" then
			if arg then
				makeAdmin(arg)
				return true
			end
			return false

		elseif command == "unadmin" then
			if arg then
				removeAdmin(arg)
				return true
			end
			return false
		end

		return false
	end
	print("[ADMIN COMMANDS] System ready!")
	print("[ADMIN COMMANDS] Type /help in output for command list")
end
