--[=[
  Ghost Catcher Tycoon - Game Client
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

local GameClient = {}
GameClient.__index = GameClient

function GameClient:new()
	local self = setmetatable({}, GameClient)
	self.player = Players.LocalPlayer
	self.remotes = {}
	self.gameState = {}
	self.ui = {}
	return self
end

function GameClient:initialize()
	print("[Ghost Catcher Tycoon] Client initializing...")

	self:waitForRemotes()
	self:setupUI()
	self:setupInputHandlers()
	self:startUpdateLoop()

	print("[Ghost Catcher Tycoon] Client initialized!")
end

function GameClient:waitForRemotes()
	local rs = Constants.Paths.ReplicatedStorage
	local remotesFolder = rs:WaitForChild("Remotes")

	-- Cache all remotes
	self.remotes.ChargeVacuum = remotesFolder:WaitForChild(Constants.Remotes.ChargeVacuum)
	self.remotes.CatchGhost = remotesFolder:WaitForChild(Constants.Remotes.CatchGhost)
	self.remotes.BringGhostsHome = remotesFolder:WaitForChild(Constants.Remotes.BringGhostsHome)
	self.remotes.UpdateUI = remotesFolder:WaitForChild(Constants.Remotes.UpdateUI)
	self.remotes.GetGameState = remotesFolder:WaitForChild(Constants.Remotes.GetGameState)

	print("[Ghost Catcher Tycoon] Remotes connected")
end

function GameClient:setupUI()
	-- Create main screen GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GameUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = self.player:WaitForChild("PlayerGui")

	-- Energy display
	local energyLabel = Instance.new("TextLabel")
	energyLabel.Name = "EnergyDisplay"
	energyLabel.Size = UDim2.new(0, 300, 0, 60)
	energyLabel.Position = UDim2.new(0, 20, 0, 20)
	energyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	energyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	energyLabel.TextSize = 32
	energyLabel.Font = Enum.Font.GothamBold
	energyLabel.TextXAlignment = Enum.TextXAlignment.Left
	energyLabel.Parent = screenGui

	-- Vacuum charge display
	local vacuumLabel = Instance.new("TextLabel")
	vacuumLabel.Name = "VacuumDisplay"
	vacuumLabel.Size = UDim2.new(0, 300, 0, 50)
	vacuumLabel.Position = UDim2.new(0, 20, 0, 90)
	vacuumLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	vacuumLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	vacuumLabel.TextSize = 18
	vacuumLabel.Font = Enum.Font.Gotham
	vacuumLabel.TextXAlignment = Enum.TextXAlignment.Left
	vacuumLabel.Parent = screenGui

	-- Ghost count display
	local ghostLabel = Instance.new("TextLabel")
	ghostLabel.Name = "GhostDisplay"
	ghostLabel.Size = UDim2.new(0, 300, 0, 50)
	ghostLabel.Position = UDim2.new(0, 20, 0, 150)
	ghostLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	ghostLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
	ghostLabel.TextSize = 18
	ghostLabel.Font = Enum.Font.Gotham
	ghostLabel.TextXAlignment = Enum.TextXAlignment.Left
	ghostLabel.Parent = screenGui

	-- Production rate display
	local productionLabel = Instance.new("TextLabel")
	productionLabel.Name = "ProductionDisplay"
	productionLabel.Size = UDim2.new(0, 300, 0, 50)
	productionLabel.Position = UDim2.new(0, 20, 0, 210)
	productionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	productionLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
	productionLabel.TextSize = 18
	productionLabel.Font = Enum.Font.Gotham
	productionLabel.TextXAlignment = Enum.TextXAlignment.Left
	productionLabel.Parent = screenGui

	-- Charge vacuum button
	local chargeButton = Instance.new("TextButton")
	chargeButton.Name = "ChargeButton"
	chargeButton.Size = UDim2.new(0, 200, 0, 80)
	chargeButton.Position = UDim2.new(0.5, -100, 0.5, -40)
	chargeButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
	chargeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	chargeButton.TextSize = 24
	chargeButton.Font = Enum.Font.GothamBold
	chargeButton.Text = "CHARGE ⚡"
	chargeButton.Parent = screenGui

	-- Store references
	self.ui.screenGui = screenGui
	self.ui.energyLabel = energyLabel
	self.ui.vacuumLabel = vacuumLabel
	self.ui.ghostLabel = ghostLabel
	self.ui.productionLabel = productionLabel
	self.ui.chargeButton = chargeButton

	print("[Ghost Catcher Tycoon] UI created")
end

function GameClient:setupInputHandlers()
	-- Handle charge button click
	self.ui.chargeButton.MouseButton1Click:Connect(function()
		self.remotes.ChargeVacuum:FireServer()
	end)

	-- Update UI when server sends updates
	self.remotes.UpdateUI.OnClientEvent:Connect(function(data)
		self:updateUIFromData(data)
	end)

	print("[Ghost Catcher Tycoon] Input handlers connected")
end

function GameClient:updateUIFromData(data)
	if data.Energy then
		self.gameState.energy = data.Energy
		self.ui.energyLabel.Text = "Energy: " .. self:formatNumber(data.Energy)
	end

	if data.VacuumCharge then
		self.gameState.vacuumCharge = data.VacuumCharge
		self.ui.vacuumLabel.Text = "Charge: " .. math.floor(data.VacuumCharge) .. "/100"
	end

	if data.GhostCount then
		self.gameState.ghostCount = data.GhostCount
		self.ui.ghostLabel.Text = "Ghosts: " .. data.GhostCount
	end

	if data.ProductionRate then
		self.gameState.productionRate = data.ProductionRate
		self.ui.productionLabel.Text = "Production: " .. self:formatNumber(data.ProductionRate) .. "/sec"
	end
end

function GameClient:formatNumber(num)
	if num >= 1000000 then
		return string.format("%.1f", num / 1000000) .. "M"
	elseif num >= 1000 then
		return string.format("%.1f", num / 1000) .. "K"
	else
		return tostring(math.floor(num))
	end
end

function GameClient:startUpdateLoop()
	-- Periodically request game state
	task.spawn(function()
		while true do
			task.wait(Config.UI.UpdateFrequency)

			-- Request state from server
			local success, result = pcall(function()
				return self.remotes.GetGameState:InvokeServer()
			end)

			if success and result then
				self:updateUIFromData(result)
			end
		end
	end)
end

-- Create and initialize client
local client = GameClient:new()
client:initialize()

return client
