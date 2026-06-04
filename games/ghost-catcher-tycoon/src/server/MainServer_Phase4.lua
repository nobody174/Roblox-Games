--
-- Ghost Catcher Tycoon - Phase 4 Testing Server
-- Ghost spawning, catching, and charge mechanics
--
local Players = game:GetService("Players")

print("[PHASE 4] Starting Phase 4 testing server...")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

-- Load only essential systems for Phase 4
local GhostSpawner = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSpawner"))

print("[PHASE 4] GhostSpawner loaded")

local ghostSpawner = GhostSpawner:new()

-- Start ghost spawning
ghostSpawner:startSpawning()
print("[PHASE 4] Ghost spawning started")

-- Setup RemoteEvents
local rs = game:GetService("ReplicatedStorage")

if not rs:FindFirstChild("Remotes") then
	local remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = rs
end

local remotesFolder = rs:FindFirstChild("Remotes")

local function createRemote(name, className)
	if not remotesFolder:FindFirstChild(name) then
		local remote = Instance.new(className)
		remote.Name = name
		remote.Parent = remotesFolder
		return remote
	end
	return remotesFolder:FindFirstChild(name)
end

createRemote(Constants.Remotes.ChargeVacuum, "RemoteEvent")
createRemote(Constants.Remotes.CatchGhost, "RemoteEvent")
createRemote(Constants.Remotes.UpdateUI, "RemoteEvent")
createRemote(Constants.Remotes.ShowNotification, "RemoteEvent")
createRemote(Constants.Remotes.GetGameState, "RemoteFunction")

print("[PHASE 4] Remotes created")

-- Player data
local playerData = {}

-- Charge remote handler
local chargeRemote = remotesFolder:FindFirstChild(Constants.Remotes.ChargeVacuum)
if chargeRemote then
	chargeRemote.OnServerEvent:Connect(function(player)
		if not playerData[player.UserId] then
			playerData[player.UserId] = { charge = 0, coins = 0, ghosts = 0 }
		end
		playerData[player.UserId].charge = math.min(playerData[player.UserId].charge + 25, 100)
		print("[PHASE 4] " .. player.Name .. " charged. New charge: " .. playerData[player.UserId].charge .. "%")
	end)
	print("[PHASE 4] Charge handler connected")
end

-- Catch remote handler
local catchRemote = remotesFolder:FindFirstChild(Constants.Remotes.CatchGhost)
if catchRemote then
	catchRemote.OnServerEvent:Connect(function(player)
		if not playerData[player.UserId] then
			playerData[player.UserId] = { charge = 0, coins = 0, ghosts = 0 }
		end

		local charge = playerData[player.UserId].charge

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
		local closestDist = 100

		for ghostInstance, data in pairs(ghostSpawner.activeGhosts) do
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
		playerData[player.UserId].charge = math.max(playerData[player.UserId].charge - 10, 0)

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
		playerData[player.UserId].coins = playerData[player.UserId].coins + coins
		playerData[player.UserId].ghosts = playerData[player.UserId].ghosts + 1

		-- Remove ghost from world
		ghostSpawner:removeGhost(closestGhost)

		print("[PHASE 4] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ") for " .. coins .. " coins!")
	end)
	print("[PHASE 4] Catch handler connected")
end

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
					})
				end
			end
		end
	end
end)

print("[PHASE 4] ✅ Phase 4 testing server ready!")
print("[PHASE 4] Ghosts spawning every 3 seconds")
print("[PHASE 4] Click CHARGE to increase vacuum charge by 25%")
print("[PHASE 4] Click CATCH to catch nearby ghosts and earn coins")
