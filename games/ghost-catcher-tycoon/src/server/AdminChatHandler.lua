--
-- Ghost Catcher Tycoon - Admin Chat Handler
-- Intercepts chat messages and routes admin commands
-- Prefix: ! (e.g., !coin, !help, !heal)
-- Place in ServerScriptService
--

local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")

-- Configuration
local Prefix = "!"

-- Reference to shared player data (set by MainServer)
local playerData = nil

-- Admin list (copy of AdminCommands list)
local adminList = {}

-- Wait for playerData to be available
local function waitForPlayerData()
	local attempts = 0
	while not playerData and attempts < 100 do
		playerData = _G.GhostCatcherPlayerData
		if not playerData then
			task.wait(0.05)
			attempts = attempts + 1
		end
	end
	if playerData then
		print("[ADMIN CHAT] ✓ Connected to MainServer playerData after " .. attempts .. " attempts")
	end
	return playerData ~= nil
end

-- Check if player is admin
local function isAdmin(playerName)
	return adminList[playerName] == true
end

-- Make player admin
local function makeAdmin(playerName)
	adminList[playerName] = true
end

-- Remove admin status
local function removeAdmin(playerName)
	adminList[playerName] = nil
end

-- Initialize player data
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

-- Parse command string into command name and arguments
local function parseCommand(message)
	-- Remove prefix
	local withoutPrefix = message:sub(#Prefix + 1)

	-- Split by spaces
	local parts = {}
	for part in withoutPrefix:gmatch("%S+") do
		table.insert(parts, part)
	end

	if #parts == 0 then return nil, {} end

	local commandName = parts[1]:lower()
	local args = {}
	for i = 2, #parts do
		table.insert(args, parts[i])
	end

	return commandName, args
end

-- Execute admin command
local function executeCommand(player, commandName, args)
	-- Check admin permission
	if not isAdmin(player.Name) then
		print("[ADMIN] " .. player.Name .. " is not an admin (cannot use !" .. commandName .. ")")
		return false
	end

	local data = initPlayerData(player.UserId)
	local updateRemote = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("UpdateUI")

	if commandName == "coin" or commandName == "gold" then
		data.coins = data.coins + 1000
		print("[ADMIN] " .. player.Name .. " gained 1000 coins (total: " .. data.coins .. ")")
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

	elseif commandName == "energy" or commandName == "eng" then
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

	elseif commandName == "ghost" or commandName == "gh" then
		local ghostName = args[1] or "Wraith"
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

	elseif commandName == "heal" then
		local targetPlayer = player
		local healAmount = 1000
		local isMax = args[1] and args[1]:lower() == "max"

		if args[1] and not isMax then
			targetPlayer = findPlayerByName(args[1])
			if not targetPlayer then
				print("[ADMIN] Player not found: " .. args[1])
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

	elseif commandName == "admin" then
		if args[1] then
			makeAdmin(args[1])
			return true
		end
		return false

	elseif commandName == "unadmin" then
		if args[1] then
			removeAdmin(args[1])
			return true
		end
		return false

	elseif commandName == "help" then
		print("[ADMIN COMMANDS HELP]")
		print("  !coin - Add 1000 coins to yourself")
		print("  !energy - Add 1000 energy to yourself")
		print("  !ghost [name] - Spawn a ghost in inventory")
		print("  !heal - Add 1000 coins to yourself")
		print("  !heal max - Restore coins to maximum (9999)")
		print("  !heal @player - Add 1000 coins to a player")
		print("  !admin @player - Make a player admin")
		print("  !unadmin @player - Remove admin status")
		return true
	end

	return false
end

-- Initialize admin list with default admin
adminList["nobodylearn174"] = true

-- Wait for playerData to be available
if not waitForPlayerData() then
	print("[ADMIN CHAT] WARNING: Player data not available, some features may not work")
	playerData = _G.GhostCatcherPlayerData or {}
	_G.GhostCatcherPlayerData = playerData
end

-- Create admin log UI remote for client feedback
local adminLogRemote = nil
if rs:FindFirstChild("Remotes") then
	if not rs.Remotes:FindFirstChild("AdminLog") then
		adminLogRemote = Instance.new("RemoteEvent")
		adminLogRemote.Name = "AdminLog"
		adminLogRemote.Parent = rs.Remotes
	else
		adminLogRemote = rs.Remotes:FindFirstChild("AdminLog")
	end
end

-- Listen for chat messages from all players
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		-- Check if message starts with prefix
		if not message:match("^" .. Prefix:gsub("([%^%$()%[%].%*+%-?])", "%%%1")) then
			return
		end

		-- Parse command
		local commandName, args = parseCommand(message)
		if not commandName then
			return
		end

		-- Execute command
		local success = executeCommand(player, commandName, args)

		-- Log to admin feedback (not public chat)
		if adminLogRemote then
			if success then
				adminLogRemote:FireClient(player, "✓ " .. commandName .. " executed successfully")
				print("[ADMIN CHAT] " .. player.Name .. " executed: " .. message)
			else
				adminLogRemote:FireClient(player, "✗ " .. commandName .. " failed or permission denied")
				print("[ADMIN CHAT] Command failed or permission denied: " .. player.Name .. " -> " .. message)
			end
		end
	end)
end)

print("[ADMIN CHAT] System ready! Prefix: " .. Prefix)
print("[ADMIN CHAT] Type " .. Prefix .. "help in chat for command list")
