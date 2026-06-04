--
-- Ultra Minimal - Just test remotes and basic charge
--
local Players = game:GetService("Players")

print("[TEST] Ultra minimal server starting...")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

print("[TEST] Constants loaded")

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
createRemote(Constants.Remotes.GetGameState, "RemoteFunction")

print("[TEST] Remotes created")

-- Simple player charge handler
local playerCharges = {}

local chargeRemote = remotesFolder:FindFirstChild(Constants.Remotes.ChargeVacuum)
if chargeRemote then
	chargeRemote.OnServerEvent:Connect(function(player)
		print("[TEST] Charge remote fired for " .. player.Name)
		if not playerCharges[player.UserId] then
			playerCharges[player.UserId] = 0
		end
		playerCharges[player.UserId] = math.min(playerCharges[player.UserId] + 25, 100)
		print("[TEST] " .. player.Name .. " now has " .. playerCharges[player.UserId] .. "% charge")
	end)
	print("[TEST] Charge handler connected")
end

-- Simple update loop
task.spawn(function()
	while true do
		task.wait(1)
		for _, player in pairs(Players:GetPlayers()) do
			local updateRemote = remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				updateRemote:FireClient(player, {
					VacuumCharge = playerCharges[player.UserId] or 0,
					Energy = 0,
					GhostCount = 0,
				})
			end
		end
	end
end)

print("[TEST] ✅ Ultra minimal server ready - charge test mode")
