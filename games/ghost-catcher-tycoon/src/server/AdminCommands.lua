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

-- Muted players list
local mutedPlayers = {}

-- Island spawn points for teleport command
local islandSpawns = {
	["Whisper Woods"] = Vector3.new(0, 20, 0),
	["Foggy Fields"] = Vector3.new(100, 20, 0),
	["Gloomy Graveyard"] = Vector3.new(-100, 20, 0),
	["Electro Alley"] = Vector3.new(150, 20, 100),
	["Frostbite Caverns"] = Vector3.new(-150, 20, -100),
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
			unlockedZones = { ["Whisper Woods"] = true },
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

-- Mute a player
local function mutePlayer(playerName)
	mutedPlayers[playerName] = true
	print("[ADMIN] " .. playerName .. " has been muted")
end

-- Unmute a player
local function unmutePlayer(playerName)
	mutedPlayers[playerName] = nil
	print("[ADMIN] " .. playerName .. " has been unmuted")
end

-- Check if player is muted
local function isMuted(playerName)
	return mutedPlayers[playerName] == true
end

-- Find player by name (partial match)
local function findPlayerByName(nameToFind)
	if not nameToFind then return nil end
	nameToFind = nameToFind:lower()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name:lower():match(nameToFind) then
			return player
		end
	end
	return nil
end

-- Admin command handler with permission checking
local adminRemote = remotesFolder:FindFirstChild("AdminCommand")
if adminRemote then
	adminRemote.OnServerInvoke = function(player, command, arg)
		-- Check admin permission
		if not isAdmin(player.Name) then
			print("[ADMIN] " .. player.Name .. " is not an admin (cannot use !" .. command .. ")")
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

		elseif command == "mute" then
			if not arg then
				print("[ADMIN] Usage: /mute @player")
				return false
			end
			local targetPlayer = findPlayerByName(arg)
			if targetPlayer then
				mutePlayer(targetPlayer.Name)
				print("[ADMIN] " .. player.Name .. " muted " .. targetPlayer.Name)
				return true
			else
				print("[ADMIN] Player not found: " .. arg)
				return false
			end

		elseif command == "unmute" then
			if not arg then
				print("[ADMIN] Usage: /unmute @player")
				return false
			end
			local targetPlayer = findPlayerByName(arg)
			if targetPlayer then
				unmutePlayer(targetPlayer.Name)
				print("[ADMIN] " .. player.Name .. " unmuted " .. targetPlayer.Name)
				return true
			else
				print("[ADMIN] Player not found: " .. arg)
				return false
			end

		elseif command == "kick" then
			if not arg then
				print("[ADMIN] Usage: /kick @player [reason]")
				return false
			end
			local targetPlayer = findPlayerByName(arg)
			if targetPlayer then
				local reason = "Kicked by admin"
				targetPlayer:Kick(reason)
				print("[ADMIN] " .. player.Name .. " kicked " .. targetPlayer.Name)
				return true
			else
				print("[ADMIN] Player not found: " .. arg)
				return false
			end

		elseif command == "heal" then
			local targetPlayer = player
			local healAmount = 1000
			local isMax = arg and arg:lower() == "max"

			-- Check if second arg is player
			if arg and not isMax and arg:sub(1, 1) == "@" then
				targetPlayer = findPlayerByName(arg:sub(2))
				if not targetPlayer then
					print("[ADMIN] Player not found: " .. arg)
					return false
				end
			end

			local targetData = initPlayerData(targetPlayer.UserId)
			if isMax then
				targetData.coins = 9999
			else
				targetData.coins = math.min(targetData.coins + healAmount, 9999)
			end

			print("[ADMIN] " .. player.Name .. " healed " .. targetPlayer.Name .. " (coins: " .. targetData.coins .. ")")
			if updateRemote then
				updateRemote:FireClient(targetPlayer, {
					VacuumCharge = targetData.charge,
					Energy = targetData.coins,
					GhostCount = targetData.ghosts,
					GhostInventory = targetData.ghostInventory,
					Rooms = targetData.rooms,
					UnlockedZones = targetData.unlockedZones,
				})
			end
			return true

		elseif command == "tp" then
			if not arg then
				print("[ADMIN] Usage: /tp @player @player2 or /tp @player ISLAND")
				return false
			end

			local sourcePlayer = findPlayerByName(arg)
			if not sourcePlayer then
				print("[ADMIN] Player not found: " .. arg)
				return false
			end

			if not sourcePlayer.Character then
				print("[ADMIN] Character not found for " .. sourcePlayer.Name)
				return false
			end

			-- Check if second argument is another player or an island
			local destPos = nil
			if arg2 then
				local destPlayer = findPlayerByName(arg2)
				if destPlayer and destPlayer.Character then
					destPos = destPlayer.Character:FindFirstChild("HumanoidRootPart").Position
				else
					-- Try as island name
					destPos = islandSpawns[arg2]
				end
			else
				-- No arg2, teleport to self (admin)
				if player.Character then
					destPos = player.Character:FindFirstChild("HumanoidRootPart").Position
				end
			end

			if destPos then
				sourcePlayer.Character:MoveTo(destPos)
				print("[ADMIN] " .. player.Name .. " teleported " .. sourcePlayer.Name)
				return true
			else
				print("[ADMIN] Destination not found")
				return false
			end

		elseif command == "help" then
			print("[ADMIN COMMANDS HELP]")
			print("  /coin - Add 1000 coins to yourself")
			print("  /energy - Add 1000 energy to yourself")
			print("  /ghost [name] - Spawn a ghost in inventory")
			print("  /heal - Add 1000 coins to yourself")
			print("  /heal max - Restore coins to maximum (9999)")
			print("  /heal @player - Add 1000 coins to a player")
			print("  /heal @player max - Restore player's coins to max")
			print("  /mute @player - Mute a player")
			print("  /unmute @player - Unmute a player")
			print("  /kick @player - Kick a player from the game")
			print("  /tp @player [@player2|ISLAND] - Teleport to player or island")
			print("  /admin @player - Make a player admin")
			print("  /unadmin @player - Remove admin status")
			return true
		end

		return false
	end
	print("[ADMIN COMMANDS] System ready!")
	print("[ADMIN COMMANDS] Type /help in output for command list")
end
