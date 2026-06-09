--
-- Equipment Slot UI — Ghost Catcher Tycoon
-- Displays current equipped equipment with stats and catch rates
--

local EquipmentSlotUI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local EquipmentData = require(game.ServerStorage:WaitForChild("EquipmentData"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local currentEquipment = nil
local equipmentList = {}
local panelOpen = false

-- Create UI Panel
local function createPanel()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EquipmentSlotUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main container (bottom-left)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "EquipmentPanel"
	mainFrame.Size = UDim2.new(0, 320, 0, 280)
	mainFrame.Position = UDim2.new(0, 15, 1, -300)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	mainFrame.BorderSizePixel = 1
	mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
	mainFrame.Parent = screenGui

	-- Corner radius effect (optional dark overlay)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = mainFrame

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -10, 0, 30)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = "⚙ Equipment"
	titleLabel.Parent = mainFrame

	-- Equipment display
	local equipmentDisplay = Instance.new("Frame")
	equipmentDisplay.Name = "EquipmentDisplay"
	equipmentDisplay.Size = UDim2.new(1, -10, 0, 70)
	equipmentDisplay.Position = UDim2.new(0, 5, 0, 40)
	equipmentDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	equipmentDisplay.BorderSizePixel = 0
	equipmentDisplay.Parent = mainFrame

	-- Equipment name
	local equipmentNameLabel = Instance.new("TextLabel")
	equipmentNameLabel.Name = "EquipmentName"
	equipmentNameLabel.Size = UDim2.new(1, -10, 0, 25)
	equipmentNameLabel.Position = UDim2.new(0, 5, 0, 5)
	equipmentNameLabel.BackgroundTransparency = 1
	equipmentNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	equipmentNameLabel.TextSize = 14
	equipmentNameLabel.Font = Enum.Font.GothamBold
	equipmentNameLabel.Text = "None"
	equipmentNameLabel.Parent = equipmentDisplay

	-- Equipment tier
	local tierLabel = Instance.new("TextLabel")
	tierLabel.Name = "TierLabel"
	tierLabel.Size = UDim2.new(0.5, -5, 0, 20)
	tierLabel.Position = UDim2.new(0, 5, 0, 32)
	tierLabel.BackgroundTransparency = 1
	tierLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	tierLabel.TextSize = 12
	tierLabel.Font = Enum.Font.Gotham
	tierLabel.Text = "Tier: —"
	tierLabel.Parent = equipmentDisplay

	-- Charge time & energy
	local statsLabel = Instance.new("TextLabel")
	statsLabel.Name = "StatsLabel"
	statsLabel.Size = UDim2.new(0.5, -5, 0, 20)
	statsLabel.Position = UDim2.new(0.5, 0, 0, 32)
	statsLabel.BackgroundTransparency = 1
	statsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	statsLabel.TextSize = 12
	statsLabel.Font = Enum.Font.Gotham
	statsLabel.Text = "Charge: — | Energy: —"
	statsLabel.TextXAlignment = Enum.TextXAlignment.Right
	statsLabel.Parent = equipmentDisplay

	-- Description
	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "Description"
	descLabel.Size = UDim2.new(1, -10, 0, 35)
	descLabel.Position = UDim2.new(0, 5, 0, 115)
	descLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	descLabel.BorderSizePixel = 0
	descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	descLabel.TextSize = 11
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextWrapped = true
	descLabel.Text = "Select equipment to view details"
	descLabel.Parent = mainFrame

	-- Catch rates label
	local catchRateTitle = Instance.new("TextLabel")
	catchRateTitle.Name = "CatchRateTitle"
	catchRateTitle.Size = UDim2.new(1, -10, 0, 15)
	catchRateTitle.Position = UDim2.new(0, 5, 0, 155)
	catchRateTitle.BackgroundTransparency = 1
	catchRateTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
	catchRateTitle.TextSize = 11
	catchRateTitle.Font = Enum.Font.GothamBold
	catchRateTitle.Text = "vs Ghost Rarity"
	catchRateTitle.Parent = mainFrame

	-- Catch rates container
	local catchRatesFrame = Instance.new("Frame")
	catchRatesFrame.Name = "CatchRates"
	catchRatesFrame.Size = UDim2.new(1, -10, 0, 95)
	catchRatesFrame.Position = UDim2.new(0, 5, 0, 170)
	catchRatesFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	catchRatesFrame.BorderSizePixel = 0
	catchRatesFrame.Parent = mainFrame

	local catchRatesLayout = Instance.new("UIGridLayout")
	catchRatesLayout.CellSize = UDim2.new(1, 0, 0, 13)
	catchRatesLayout.FillDirection = Enum.FillDirection.Vertical
	catchRatesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	catchRatesLayout.Parent = catchRatesFrame

	-- Create catch rate entries
	local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted"}
	for _, rarity in ipairs(rarities) do
		local rarityLabel = Instance.new("TextLabel")
		rarityLabel.Name = rarity
		rarityLabel.Size = UDim2.new(1, 0, 0, 13)
		rarityLabel.BackgroundTransparency = 1
		rarityLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		rarityLabel.TextSize = 10
		rarityLabel.Font = Enum.Font.Gotham
		rarityLabel.Text = rarity .. ": —%"
		rarityLabel.Parent = catchRatesFrame
	end

	-- Equipment list dropdown (toggle)
	local listButton = Instance.new("TextButton")
	listButton.Name = "ListButton"
	listButton.Size = UDim2.new(1, -10, 0, 20)
	listButton.Position = UDim2.new(0, 5, 1, -25)
	listButton.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
	listButton.BorderSizePixel = 0
	listButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	listButton.TextSize = 12
	listButton.Font = Enum.Font.GothamBold
	listButton.Text = "📋 Switch Equipment"
	listButton.Parent = mainFrame

	-- Dropdown list (hidden by default)
	local listFrame = Instance.new("Frame")
	listFrame.Name = "EquipmentList"
	listFrame.Size = UDim2.new(0, 320, 0, 150)
	listFrame.Position = UDim2.new(0, 15, 1, -460)
	listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	listFrame.BorderSizePixel = 1
	listFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
	listFrame.Visible = false
	listFrame.Parent = screenGui

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 8)
	listCorner.Parent = listFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = listFrame

	local listScroll = Instance.new("UIListLayout")
	listScroll.Padding = UDim.new(0, 2)
	listScroll.FillDirection = Enum.FillDirection.Vertical
	listScroll.Parent = listFrame

	-- Toggle list visibility
	listButton.MouseButton1Click:Connect(function()
		panelOpen = not panelOpen
		listFrame.Visible = panelOpen
	end)

	return {
		screenGui = screenGui,
		mainFrame = mainFrame,
		equipmentNameLabel = equipmentNameLabel,
		tierLabel = tierLabel,
		statsLabel = statsLabel,
		descLabel = descLabel,
		catchRatesFrame = catchRatesFrame,
		listFrame = listFrame,
		listButton = listButton
	}
end

local ui = createPanel()

-- Update equipment display
local function updateEquipmentDisplay(equipmentName)
	if not equipmentName or equipmentName == "None" then
		ui.equipmentNameLabel.Text = "None"
		ui.tierLabel.Text = "Tier: —"
		ui.statsLabel.Text = "Charge: — | Energy: —"
		ui.descLabel.Text = "Select equipment to view details"

		for _, rarity in ipairs({"Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted"}) do
			local label = ui.catchRatesFrame:FindFirstChild(rarity)
			if label then
				label.Text = rarity .. ": —%"
			end
		end
		return
	end

	local equipment = EquipmentData:getEquipment(equipmentName)
	if not equipment then return end

	local tierColor = EquipmentData.TIER_COLORS[equipment.tier]
	ui.equipmentNameLabel.Text = equipment.name
	ui.equipmentNameLabel.TextColor3 = tierColor

	ui.tierLabel.Text = "Tier: " .. equipment.tier
	ui.tierLabel.TextColor3 = tierColor

	ui.statsLabel.Text = string.format("Charge: %.1fs | Energy: %d", equipment.chargeTime, equipment.energyCost)

	ui.descLabel.Text = equipment.description

	-- Update catch rates
	for _, rarity in ipairs({"Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted"}) do
		local rate = equipment.catchRates[rarity] or 0
		local label = ui.catchRatesFrame:FindFirstChild(rarity)
		if label then
			label.Text = rarity .. ": " .. rate .. "%"
		end
	end

	currentEquipment = equipmentName
end

-- Update equipment list
local function updateEquipmentList(ownedEquipment)
	-- Clear existing items
	for _, child in ipairs(ui.listFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	equipmentList = ownedEquipment or {}

	for i, equipName in ipairs(equipmentList) do
		local equipment = EquipmentData:getEquipment(equipName)
		if equipment then
			local button = Instance.new("TextButton")
			button.Name = equipName
			button.Size = UDim2.new(1, -10, 0, 24)
			button.Position = UDim2.new(0, 5, 0, 0)
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
			button.BorderSizePixel = 0
			button.TextColor3 = Color3.fromRGB(200, 200, 220)
			button.TextSize = 12
			button.Font = Enum.Font.Gotham

			local tierColor = EquipmentData.TIER_COLORS[equipment.tier]
			button.Text = "T" .. equipment.tier .. " | " .. equipment.name

			button.MouseButton1Click:Connect(function()
				updateEquipmentDisplay(equipName)
				panelOpen = false
				ui.listFrame.Visible = false
			end)

			button.Parent = ui.listFrame

			-- Hover effect
			button.MouseEnter:Connect(function()
				button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
			end)

			button.MouseLeave:Connect(function()
				button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
			end)
		end
	end
end

-- Listen for equipment updates from server
local function setupNetworking()
	local signal = Instance.new("RemoteFunction")
	signal.Name = "EquipmentUISignal"
	signal.Parent = game.ReplicatedStorage

	signal.OnClientInvoke = function(eventType, data)
		if eventType == "UpdateEquipment" then
			updateEquipmentList(data.owned or {})
			if data.equipped then
				updateEquipmentDisplay(data.equipped)
			end
		elseif eventType == "EquipmentChanged" then
			updateEquipmentDisplay(data.name)
		end
	end
end

-- Close panel on ESC
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Escape then
		panelOpen = false
		ui.listFrame.Visible = false
	end
end)

setupNetworking()

return EquipmentSlotUI
