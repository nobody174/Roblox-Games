--
-- Ghost Catcher Tycoon - Minimal Server (Phase 4 Testing)
-- Only loads essential systems for ghost spawning and catching
--
local Players = game:GetService("Players")

print("[DEBUG] Loading minimal systems...")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

local DataManager = require(script.Parent:WaitForChild("data"):WaitForChild("DataManager"))
local CurrencySystem = require(script.Parent:WaitForChild("systems"):WaitForChild("CurrencySystem"))
local VacuumSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("VacuumSystem"))
local GhostSystem = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSystem"))
local GhostService = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostService"))
local GhostSpawner = require(script.Parent:WaitForChild("systems"):WaitForChild("GhostSpawner"))

print("[DEBUG] All minimal systems loaded")

local dataManager = DataManager:new()
local currencySystem = CurrencySystem:new()
local vacuumSystem = VacuumSystem:new()
local ghostSystem = GhostSystem:new()
local ghostService = GhostService:new()
local ghostSpawner = GhostSpawner:new()

currencySystem:setDataManager(dataManager)

ghostSpawner:startSpawning()
print("[Ghost Catcher Tycoon] Server started (minimal mode - Phase 4 testing)")

-- Setup RemoteEvents
local function setupRemotes()
	print("[DEBUG] setupRemotes() starting...")
	local rs = game:GetService("ReplicatedStorage")

	if not rs:FindFirstChild("Remotes") then
		local remotesFolder = Instance.new("Folder")
		remotesFolder.Name = "Remotes"
		remotesFolder.Parent = rs
		print("[DEBUG] Created Remotes folder")
	end

	local remotesFolder = rs:FindFirstChild("Remotes")
	if not remotesFolder then
		error("[ERROR] Remotes folder not found!")
		return
	end

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

	print("[Ghost Catcher Tycoon] Remotes created")
end

-- Player join
local function onPlayerJoined(player)
	print("[Ghost Catcher Tycoon] Player joined: " .. player.Name)
	local playerData = dataManager:loadPlayerData(player)
	vacuumSystem:initializePlayer(player)
	ghostSystem:initializePlayer(player)

	local rs = Constants.Paths.ReplicatedStorage
	local getGameStateRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.GetGameState)
	getGameStateRemote.OnServerInvoke = function(player)
		local data = dataManager:getPlayerData(player)
		data.VacuumCharge = vacuumSystem:getCharge(player)
		data.GhostCount = ghostSystem:getPlayerGhostCount(player)
		return data
	end
end

-- Vacuum remote
local function setupVacuumRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local chargeVacuumRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.ChargeVacuum)

	chargeVacuumRemote.OnServerEvent:Connect(function(player)
		if vacuumSystem:chargeVacuum(player) then
			print("[Ghost Catcher] " .. player.Name .. " charged vacuum")
		end
	end)

	print("[Ghost Catcher Tycoon] Vacuum remote setup complete")
end

-- Catch remote
local function setupCatchRemote()
	local rs = Constants.Paths.ReplicatedStorage
	local catchRemote = rs:WaitForChild("Remotes"):WaitForChild(Constants.Remotes.CatchGhost)

	catchRemote.OnServerEvent:Connect(function(player)
		local vacuum = vacuumSystem:getCharge(player)

		if vacuum < 10 then
			return
		end

		local character = player.Character
		if not character then return end

		local playerPos = character:FindFirstChild("HumanoidRootPart").Position
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
			return
		end

		local ghostName = closestGhost:GetAttribute("GhostName")
		local rarity = closestGhost:GetAttribute("Rarity")

		vacuumSystem:deductCharge(player, 10)
		ghostService:givePlayerRandomGhost(player, ghostName)

		local coinReward = {
			Common = 1,
			Uncommon = 3,
			Rare = 10,
			Epic = 25,
			Legendary = 50,
			Corrupted = 75,
		}
		local coins = coinReward[rarity] or 1
		currencySystem:addEnergy(player, coins, "catch")

		ghostSpawner:removeGhost(closestGhost)

		print("[Ghost Catcher] " .. player.Name .. " caught " .. ghostName .. " (" .. rarity .. ")")
	end)

	print("[Ghost Catcher Tycoon] Catch remote setup complete")
end

-- UI update loop
local function setupUpdateLoop()
	while true do
		task.wait(1)

		for _, player in pairs(Players:GetPlayers()) do
			local updateRemote = Constants.Paths.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild(Constants.Remotes.UpdateUI)
			if updateRemote then
				local uiData = {
					Energy = currencySystem:getEnergy(player),
					VacuumCharge = vacuumSystem:getCharge(player),
					GhostCount = ghostSystem:getPlayerGhostCount(player),
				}
				updateRemote:FireClient(player, uiData)
			end
		end
	end
end

-- Main initialization
local function initialize()
	print("[Ghost Catcher Tycoon] Initializing (minimal)...")

	setupRemotes()

	Players.PlayerAdded:Connect(onPlayerJoined)

	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(onPlayerJoined, player)
	end

	local ok1, err1 = pcall(setupVacuumRemote)
	if not ok1 then print("[Error] Vacuum setup failed: " .. tostring(err1)) end

	local okCatch, errCatch = pcall(setupCatchRemote)
	if not okCatch then print("[Error] Catch setup failed: " .. tostring(errCatch)) end

	print("[CHECKPOINT] All remotes setup")

	task.spawn(setupUpdateLoop)

	print("[Ghost Catcher Tycoon] Server initialization complete!")
end

initialize()
