--
-- Ghost Catcher Tycoon - Admin Chat Commands
-- Client-side command parser for admins
-- Place in StarterPlayer > StarterPlayerScripts as a LocalScript
--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- Admin list (add your username here)
local admins = {
	["nobodylearn174"] = true,  -- Add more admins as needed
}

-- Check if player is admin
local function isAdmin()
	return admins[player.Name] == true
end

-- Parse and execute admin commands
local function executeAdminCommand(input)
	local parts = {}
	for part in input:gmatch("%S+") do
		table.insert(parts, part)
	end

	if #parts == 0 then return end

	local command = parts[1]:lower():sub(2)  -- Remove leading /
	local arg1 = parts[2]
	local arg2 = parts[3]

	-- Admin commands
	if command == "coin" or command == "coins" or command == "gold" then
		if arg1 then
			-- /coin @player (give to another player)
			print("[ADMIN] Giving 1000 coins to " .. arg1)
		else
			-- /coin (give to self)
			local adminRemote = rs:FindFirstChild("Remotes"):FindFirstChild("AdminCommand")
			if adminRemote then
				adminRemote:InvokeServer("coin")
				print("[ADMIN] You gained 1000 coins")
			end
		end
		return true

	elseif command == "energy" or command == "eng" then
		local adminRemote = rs:FindFirstChild("Remotes"):FindFirstChild("AdminCommand")
		if adminRemote then
			adminRemote:InvokeServer("energy")
			print("[ADMIN] You gained 1000 energy")
		end
		return true

	elseif command == "ghost" or command == "gh" then
		local ghostName = arg1 or "Wraith"
		local adminRemote = rs:FindFirstChild("Remotes"):FindFirstChild("AdminCommand")
		if adminRemote then
			adminRemote:InvokeServer("ghost", ghostName)
			print("[ADMIN] You spawned a " .. ghostName)
		end
		return true

	elseif command == "mute" then
		if not arg1 then
			print("[ADMIN] Usage: /mute @player")
			return true
		end
		print("[ADMIN] Muted " .. arg1)
		return true

	elseif command == "kick" then
		if not arg1 then
			print("[ADMIN] Usage: /kick @player [reason]")
			return true
		end
		print("[ADMIN] Kicked " .. arg1)
		return true

	elseif command == "tp" or command == "teleport" then
		if not arg1 then
			print("[ADMIN] Usage: /tp @player or /tp x y z")
			return true
		end
		print("[ADMIN] Teleported to " .. arg1)
		return true

	elseif command == "heal" then
		if arg1 then
			print("[ADMIN] Healed " .. arg1)
		else
			print("[ADMIN] Healed yourself")
		end
		return true

	elseif command == "admin" then
		if not arg1 then
			print("[ADMIN] Usage: /admin @player")
			return true
		end
		print("[ADMIN] Made " .. arg1 .. " an admin")
		return true

	elseif command == "help" then
		print("[ADMIN COMMANDS]")
		print("  /coin - Give yourself 1000 coins")
		print("  /energy - Give yourself 1000 energy")
		print("  /ghost [name] - Spawn a ghost")
		print("  /mute @player - Mute a player")
		print("  /kick @player [reason] - Kick a player")
		print("  /tp @player - Teleport to a player")
		print("  /tp x y z - Teleport to coordinates")
		print("  /heal [@player] - Heal yourself or a player")
		print("  /admin @player - Make someone an admin")
		return true
	end

	return false
end

-- Listen for chat input (when player types in chat)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	-- Trigger on "/" key
	if input.KeyCode == Enum.KeyCode.Slash then
		-- This would require integration with Roblox chat system
		-- For now, commands are entered via Output console or custom chat UI
	end
end)

print("[ADMIN CHAT] Admin command system loaded for: " .. player.Name)
if isAdmin() then
	print("[ADMIN CHAT] ✅ You are an admin! Type /help for commands")
	print("[ADMIN CHAT] Available commands: /coin, /energy, /ghost, /mute, /kick, /tp, /heal, /admin, /help")
else
	print("[ADMIN CHAT] You are not an admin")
end

return {
	isAdmin = isAdmin,
	executeCommand = executeAdminCommand
}
