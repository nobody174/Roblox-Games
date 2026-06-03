--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Client-side UI management: screen layout, button handlers, tab system, and real-time game state updates.
--
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local GhostCardBuilder = require(script.Parent:WaitForChild("modules"):WaitForChild("GhostCardBuilder"))

local GameClient = {}
GameClient.__index = GameClient

function GameClient:new()
	local self = setmetatable({}, GameClient)
	self.player = Players.LocalPlayer
	self.remotes = {}
	self.gameState = {}
	self.ui = {}
	self.tabExpanded = false
	self.notificationStack = 0
	self.populatedTabs = {}
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
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:WaitForChild("Remotes")

	-- Cache all remotes
	self.remotes.ChargeVacuum = remotesFolder:WaitForChild(Constants.Remotes.ChargeVacuum)
	self.remotes.CatchGhost = remotesFolder:WaitForChild(Constants.Remotes.CatchGhost)
	self.remotes.BringGhostsHome = remotesFolder:WaitForChild(Constants.Remotes.BringGhostsHome)
	self.remotes.UpdateUI = remotesFolder:WaitForChild(Constants.Remotes.UpdateUI)
	self.remotes.GetGameState = remotesFolder:WaitForChild(Constants.Remotes.GetGameState)
	self.remotes.ShowNotification = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
	self.remotes.UpgradeRoom = remotesFolder:WaitForChild(Constants.Remotes.UpgradeRoom)

	print("[Ghost Catcher Tycoon] Remotes connected")
end

function GameClient:setupUI()
	-- Create main screen GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GameUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = self.player:WaitForChild("PlayerGui")

	-- ===== TOP STAT PANEL (80px) =====
	local topPanel = Instance.new("Frame")
	topPanel.Name = "TopPanel"
	topPanel.Size = UDim2.new(1, 0, 0, 80)
	topPanel.Position = UDim2.new(0, 0, 0, 0)
	topPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	topPanel.BorderSizePixel = 0
	topPanel.Parent = screenGui

	-- Energy display (large, left side, row 1)
	local energyLabel = Instance.new("TextLabel")
	energyLabel.Name = "EnergyDisplay"
	energyLabel.Size = UDim2.new(0, 280, 0, 35)
	energyLabel.Position = UDim2.new(0, 10, 0, 5)
	energyLabel.BackgroundTransparency = 1
	energyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	energyLabel.TextSize = 24
	energyLabel.Font = Enum.Font.GothamBold
	energyLabel.TextXAlignment = Enum.TextXAlignment.Left
	energyLabel.Parent = topPanel

	-- Ghost count display (right side, row 1)
	local ghostLabel = Instance.new("TextLabel")
	ghostLabel.Name = "GhostDisplay"
	ghostLabel.Size = UDim2.new(0, 200, 0, 35)
	ghostLabel.Position = UDim2.new(1, -210, 0, 5)
	ghostLabel.BackgroundTransparency = 1
	ghostLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
	ghostLabel.TextSize = 20
	ghostLabel.Font = Enum.Font.Gotham
	ghostLabel.TextXAlignment = Enum.TextXAlignment.Left
	ghostLabel.Parent = topPanel

	-- Production rate display (left side, row 2)
	local productionLabel = Instance.new("TextLabel")
	productionLabel.Name = "ProductionDisplay"
	productionLabel.Size = UDim2.new(0, 200, 0, 30)
	productionLabel.Position = UDim2.new(0, 10, 0, 45)
	productionLabel.BackgroundTransparency = 1
	productionLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
	productionLabel.TextSize = 14
	productionLabel.Font = Enum.Font.Gotham
	productionLabel.TextXAlignment = Enum.TextXAlignment.Left
	productionLabel.Parent = topPanel

	-- Zone label (right side, row 2)
	local zoneLabel = Instance.new("TextLabel")
	zoneLabel.Name = "ZoneDisplay"
	zoneLabel.Size = UDim2.new(0, 200, 0, 30)
	zoneLabel.Position = UDim2.new(1, -210, 0, 45)
	zoneLabel.BackgroundTransparency = 1
	zoneLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
	zoneLabel.TextSize = 14
	zoneLabel.Font = Enum.Font.Gotham
	zoneLabel.TextXAlignment = Enum.TextXAlignment.Left
	zoneLabel.Parent = topPanel

	-- ===== TAB BAR STRIP (52px, always visible at bottom) =====
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(1, 0, 0, 52)
	tabBar.Position = UDim2.new(0, 0, 1, -52)
	tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	tabBar.BorderSizePixel = 0
	tabBar.Parent = screenGui

	local tabBarLayout = Instance.new("UIListLayout")
	tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
	tabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabBarLayout.Padding = UDim.new(0, 0)
	tabBarLayout.Parent = tabBar

	-- ===== SLIDE PANEL (hidden by default, 260px tall) =====
	local slidePanel = Instance.new("Frame")
	slidePanel.Name = "SlidePanel"
	slidePanel.Size = UDim2.new(1, 0, 0, 260)
	slidePanel.Position = UDim2.new(0, 0, 1, 0)
	slidePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	slidePanel.BorderSizePixel = 0
	slidePanel.Parent = screenGui

	local slidePanelLayout = Instance.new("UIListLayout")
	slidePanelLayout.FillDirection = Enum.FillDirection.Vertical
	slidePanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	slidePanelLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	slidePanelLayout.Padding = UDim.new(0, 6)
	slidePanelLayout.Parent = slidePanel

	local slidePadding = Instance.new("UIPadding")
	slidePadding.PaddingLeft = UDim.new(0, 10)
	slidePadding.PaddingRight = UDim.new(0, 10)
	slidePadding.PaddingTop = UDim.new(0, 8)
	slidePadding.PaddingBottom = UDim.new(0, 8)
	slidePadding.Parent = slidePanel

	-- ===== TAB DEFINITIONS =====
	local tabs = {
		{ name = "Ghost", label = "👻\nGhosts" },
		{ name = "HQ", label = "🏠\nHQ" },
		{ name = "Zones", label = "🗺\nZones" },
		{ name = "Shop", label = "🛍\nShop" },
		{ name = "Info", label = "ℹ\nInfo" },
	}

	local tabButtons = {}
	local tabContents = {}

	for _, tab in ipairs(tabs) do
		-- Tab button in tab bar
		local tabButton = Instance.new("TextButton")
		tabButton.Name = tab.name .. "Tab"
		tabButton.Size = UDim2.new(0, 70, 0, 52)
		tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		tabButton.TextSize = 11
		tabButton.Font = Enum.Font.Gotham
		tabButton.Text = tab.label
		tabButton.BorderSizePixel = 0

		-- Tab content in slide panel
		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Name = tab.name .. "Content"
		tabContent.Size = UDim2.new(1, 0, 0, 200)
		tabContent.BackgroundTransparency = 1
		tabContent.ScrollBarThickness = 8
		tabContent.CanvasSize = UDim2.new(1, 0, 0, 400)
		tabContent.Visible = false
		tabContent.Parent = slidePanel

		tabButtons[tab.name] = tabButton
		tabContents[tab.name] = tabContent

		-- Tab click handler (connect BEFORE parenting)
		local tabName = tab.name
		tabButton.MouseButton1Click:Connect(function()
			print("[Ghost Catcher Tycoon] Tab clicked: " .. tabName)
			local isCurrentTabActive = tabContent.Visible and tabButton.BackgroundColor3 == Color3.fromRGB(50, 120, 200)

			if isCurrentTabActive and self.tabExpanded then
				print("[Ghost Catcher Tycoon] Collapsing " .. tabName)
				self:toggleSlidePanel(false)
			else
				print("[Ghost Catcher Tycoon] Showing " .. tabName)
				for _, content in pairs(tabContents) do
					content.Visible = false
				end
				tabContent.Visible = true

				for _, button in pairs(tabButtons) do
					button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
				end
				tabButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)

				if tabName == "Ghost" and not self.populatedTabs["Ghost"] then
					print("[Ghost Catcher Tycoon] Calling populateGhostTab...")
					self:populateGhostTab()
					self.populatedTabs["Ghost"] = true
				end

				if tabName == "HQ" and not self.populatedTabs["HQ"] then
					print("[Ghost Catcher Tycoon] Calling populateHQTab...")
					self:populateHQTab()
					self.populatedTabs["HQ"] = true
				end

				if not self.tabExpanded then
					self:toggleSlidePanel(true)
				end
			end
		end)

		-- Parent button to tab bar AFTER connecting handler
		tabButton.Parent = tabBar
	end

	-- Set Ghost tab visible & active by default (but panel collapsed)
	if tabContents["Ghost"] then
		tabContents["Ghost"].Visible = true
		tabButtons["Ghost"].BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	end

	-- ===== ACTION BUTTONS (bottom-right, moved up) =====
	-- Catch Ghost button
	local catchButton = Instance.new("TextButton")
	catchButton.Name = "CatchButton"
	catchButton.Size = UDim2.new(0, 90, 0, 90)
	catchButton.Position = UDim2.new(1, -145, 1, -90)
	catchButton.AnchorPoint = Vector2.new(1, 1)
	catchButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
	catchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	catchButton.TextSize = 16
	catchButton.Font = Enum.Font.GothamBold
	catchButton.Text = "👻\nCATCH"
	catchButton.Parent = screenGui

	local catchCorner = Instance.new("UICorner")
	catchCorner.CornerRadius = UDim.new(0, 45)
	catchCorner.Parent = catchButton

	-- Charge button (circular, bottom-right)
	local chargeButton = Instance.new("TextButton")
	chargeButton.Name = "ChargeButton"
	chargeButton.Size = UDim2.new(0, 110, 0, 110)
	chargeButton.Position = UDim2.new(1, -20, 1, -85)
	chargeButton.AnchorPoint = Vector2.new(1, 1)
	chargeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	chargeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	chargeButton.TextSize = 18
	chargeButton.Font = Enum.Font.GothamBold
	chargeButton.Text = "⚡\nCHARGE"
	chargeButton.Parent = screenGui

	local chargeCorner = Instance.new("UICorner")
	chargeCorner.CornerRadius = UDim.new(0, 55)
	chargeCorner.Parent = chargeButton

	-- ===== CHARGE PROGRESS BAR (below action buttons) =====
	local chargeBarBg = Instance.new("Frame")
	chargeBarBg.Name = "ChargeBarBg"
	chargeBarBg.Size = UDim2.new(0, 235, 0, 18)
	chargeBarBg.Position = UDim2.new(1, -7, 1, -55)
	chargeBarBg.AnchorPoint = Vector2.new(1, 1)
	chargeBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	chargeBarBg.BorderSizePixel = 0
	chargeBarBg.Parent = screenGui

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 9)
	barCorner.Parent = chargeBarBg

	local chargeFill = Instance.new("Frame")
	chargeFill.Name = "ChargeFill"
	chargeFill.Size = UDim2.new(0, 0, 1, 0)
	chargeFill.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	chargeFill.BorderSizePixel = 0
	chargeFill.Parent = chargeBarBg

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 9)
	fillCorner.Parent = chargeFill

	local chargeBarText = Instance.new("TextLabel")
	chargeBarText.Name = "ChargeText"
	chargeBarText.Size = UDim2.new(1, 0, 1, 0)
	chargeBarText.BackgroundTransparency = 1
	chargeBarText.TextColor3 = Color3.fromRGB(255, 255, 255)
	chargeBarText.TextSize = 12
	chargeBarText.Font = Enum.Font.GothamBold
	chargeBarText.Text = "0%"
	chargeBarText.Parent = chargeBarBg

	-- ===== BRING GHOSTS HOME BUTTON (middle bottom, centered) =====
	local bringButton = Instance.new("TextButton")
	bringButton.Name = "BringButton"
	bringButton.Size = UDim2.new(0, 200, 0, 44)
	bringButton.Position = UDim2.new(1, -350, 1, -60)
	bringButton.AnchorPoint = Vector2.new(0.5, 1)
	bringButton.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
	bringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	bringButton.TextSize = 14
	bringButton.Font = Enum.Font.GothamBold
	bringButton.Text = "🏠 Bring Ghosts Home"
	bringButton.Parent = screenGui

	local bringCorner = Instance.new("UICorner")
	bringCorner.CornerRadius = UDim.new(0, 8)
	bringCorner.Parent = bringButton

	-- Hover effects
	chargeButton.MouseEnter:Connect(function()
		chargeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
	end)
	chargeButton.MouseLeave:Connect(function()
		chargeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	end)

	catchButton.MouseEnter:Connect(function()
		catchButton.BackgroundColor3 = Color3.fromRGB(140, 70, 220)
	end)
	catchButton.MouseLeave:Connect(function()
		catchButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
	end)

	bringButton.MouseEnter:Connect(function()
		bringButton.BackgroundColor3 = Color3.fromRGB(70, 180, 100)
	end)
	bringButton.MouseLeave:Connect(function()
		bringButton.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
	end)

	-- Store references
	self.ui.screenGui = screenGui
	self.ui.topPanel = topPanel
	self.ui.slidePanel = slidePanel
	self.ui.tabBar = tabBar
	self.ui.energyLabel = energyLabel
	self.ui.ghostLabel = ghostLabel
	self.ui.productionLabel = productionLabel
	self.ui.zoneLabel = zoneLabel
	self.ui.chargeButton = chargeButton
	self.ui.catchButton = catchButton
	self.ui.bringButton = bringButton
	self.ui.chargeFill = chargeFill
	self.ui.chargeBarText = chargeBarText
	self.ui.chargeBarBg = chargeBarBg
	self.ui.tabButtons = tabButtons
	self.ui.tabContents = tabContents

	print("[Ghost Catcher Tycoon] UI created with polished layout")
end

function GameClient:toggleSlidePanel(expand)
	local targetPos = expand and UDim2.new(0, 0, 1, -312) or UDim2.new(0, 0, 1, 0)
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(self.ui.slidePanel, tweenInfo, { Position = targetPos })
	tween:Play()
	self.tabExpanded = expand
end

function GameClient:setupInputHandlers()
	-- Handle charge button click
	self.ui.chargeButton.MouseButton1Click:Connect(function()
		self.remotes.ChargeVacuum:FireServer()
		self:showButtonFeedback(self.ui.chargeButton)
	end)

	-- Handle catch button click
	self.ui.catchButton.MouseButton1Click:Connect(function()
		self.remotes.CatchGhost:FireServer()
		self:showButtonFeedback(self.ui.catchButton)
	end)

	-- Handle bring home button click
	self.ui.bringButton.MouseButton1Click:Connect(function()
		self.remotes.BringGhostsHome:FireServer()
		self:showButtonFeedback(self.ui.bringButton)
	end)

	-- Update UI when server sends updates
	self.remotes.UpdateUI.OnClientEvent:Connect(function(data)
		self:updateUIFromData(data)
	end)

	-- Server notifications
	if self.remotes.ShowNotification then
		self.remotes.ShowNotification.OnClientEvent:Connect(function(message, color)
			self:showNotification(message, color)
		end)
	end

	print("[Ghost Catcher Tycoon] Input handlers connected")
end

function GameClient:populateGhostTab()
	local ghostTabContent = self.ui.tabContents["Ghost"]
	if not ghostTabContent then return end

	local cardBuilder = GhostCardBuilder:new()

	for _, child in ipairs(ghostTabContent:GetChildren()) do
		if child:IsA("Frame") and child.Name:match("GhostCard_") then
			child:Destroy()
		end
		if child:IsA("UIGridLayout") then
			child:Destroy()
		end
	end

	ghostTabContent.CanvasSize = UDim2.new(1, 0, 0, 500)

	local ghostGridLayout = Instance.new("UIGridLayout")
	ghostGridLayout.CellSize = UDim2.new(0, 200, 0, 120)
	ghostGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	ghostGridLayout.FillDirection = Enum.FillDirection.Horizontal
	ghostGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ghostGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	ghostGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ghostGridLayout.Parent = ghostTabContent

	print("[Ghost Catcher Tycoon] Populating Ghost tab...")

	local testGhosts = {
		{ id = 1, name = "Specter", rarity = "Common", level = 5, energyPerSec = 1 },
		{ id = 2, name = "Phantom", rarity = "Uncommon", level = 8, energyPerSec = 2 },
		{ id = 3, name = "Wraith", rarity = "Rare", level = 12, energyPerSec = 5 },
		{ id = 4, name = "Banshee", rarity = "Epic", level = 15, energyPerSec = 10 },
	}

	for _, ghostData in ipairs(testGhosts) do
		cardBuilder:buildCard(ghostData, ghostTabContent, {
			onTrain = function(ghost)
				self:showNotification("🎓 Training: " .. ghost.name, Color3.fromRGB(120, 50, 200))
			end,
			onRelease = function(ghost)
				self:showNotification("❌ Released: " .. ghost.name, Color3.fromRGB(200, 50, 50))
			end,
		})
	end
end

function GameClient:populateHQTab()
	local hqTabContent = self.ui.tabContents["HQ"]
	if not hqTabContent then return end

	-- Clear existing content
	for _, child in ipairs(hqTabContent:GetChildren()) do
		if child:IsA("Frame") and child.Name:match("RoomCard_") then
			child:Destroy()
		end
		if child:IsA("UIGridLayout") then
			child:Destroy()
		end
	end

	hqTabContent.CanvasSize = UDim2.new(1, 0, 0, 600)

	local roomGridLayout = Instance.new("UIGridLayout")
	roomGridLayout.CellSize = UDim2.new(0, 250, 0, 140)
	roomGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	roomGridLayout.FillDirection = Enum.FillDirection.Horizontal
	roomGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	roomGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	roomGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	roomGridLayout.Parent = hqTabContent

	print("[Ghost Catcher Tycoon] Populating HQ tab...")

	-- Define rooms (from config)
	local rooms = {
		{ name = "GhostChamber", displayName = "Ghost Chamber", emoji = "👻", description = "Stores ghosts" },
		{ name = "TrainingFacility", displayName = "Training Facility", emoji = "🎓", description = "Train ghosts" },
		{ name = "EnergyReactor", displayName = "Energy Reactor", emoji = "⚡", description = "Boost energy" },
		{ name = "ResearchLab", displayName = "Research Lab", emoji = "🔬", description = "Unlock content" },
		{ name = "BossArena", displayName = "Boss Arena", emoji = "⚔", description = "Boss fights" },
	}

	for _, roomData in ipairs(rooms) do
		-- Create room card frame
		local roomCard = Instance.new("Frame")
		roomCard.Name = "RoomCard_" .. roomData.name
		roomCard.Size = UDim2.new(0, 250, 0, 140)
		roomCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		roomCard.BorderSizePixel = 0
		roomCard.Parent = hqTabContent

		local roomCardCorner = Instance.new("UICorner")
		roomCardCorner.CornerRadius = UDim.new(0, 8)
		roomCardCorner.Parent = roomCard

		-- Room name label
		local roomNameLabel = Instance.new("TextLabel")
		roomNameLabel.Name = "RoomName"
		roomNameLabel.Size = UDim2.new(1, -10, 0, 30)
		roomNameLabel.Position = UDim2.new(0, 5, 0, 5)
		roomNameLabel.BackgroundTransparency = 1
		roomNameLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
		roomNameLabel.TextSize = 16
		roomNameLabel.Font = Enum.Font.GothamBold
		roomNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		roomNameLabel.Text = roomData.emoji .. " " .. roomData.displayName
		roomNameLabel.Parent = roomCard

		-- Level display
		local levelLabel = Instance.new("TextLabel")
		levelLabel.Name = "LevelLabel"
		levelLabel.Size = UDim2.new(1, -10, 0, 20)
		levelLabel.Position = UDim2.new(0, 5, 0, 35)
		levelLabel.BackgroundTransparency = 1
		levelLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		levelLabel.TextSize = 12
		levelLabel.Font = Enum.Font.Gotham
		levelLabel.TextXAlignment = Enum.TextXAlignment.Left
		levelLabel.Text = "Level: 1 (Max 10)"
		levelLabel.Parent = roomCard

		-- Cost display
		local costLabel = Instance.new("TextLabel")
		costLabel.Name = "CostLabel"
		costLabel.Size = UDim2.new(1, -10, 0, 20)
		costLabel.Position = UDim2.new(0, 5, 0, 55)
		costLabel.BackgroundTransparency = 1
		costLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		costLabel.TextSize = 12
		costLabel.Font = Enum.Font.Gotham
		costLabel.TextXAlignment = Enum.TextXAlignment.Left
		costLabel.Text = "Cost: 100 energy"
		costLabel.Parent = roomCard

		-- Upgrade button
		local upgradeButton = Instance.new("TextButton")
		upgradeButton.Name = "UpgradeButton"
		upgradeButton.Size = UDim2.new(1, -10, 0, 35)
		upgradeButton.Position = UDim2.new(0, 5, 0, 75)
		upgradeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
		upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		upgradeButton.TextSize = 14
		upgradeButton.Font = Enum.Font.GothamBold
		upgradeButton.Text = "Upgrade"
		upgradeButton.Parent = roomCard

		local upgradeCorner = Instance.new("UICorner")
		upgradeCorner.CornerRadius = UDim.new(0, 6)
		upgradeCorner.Parent = upgradeButton

		-- Button click handler
		local roomName = roomData.name
		upgradeButton.MouseButton1Click:Connect(function()
			print("[Ghost Catcher Tycoon] Upgrade button clicked for " .. roomName)
			self.remotes.UpgradeRoom:FireServer(roomName)
			self:showButtonFeedback(upgradeButton)
		end)

		-- Hover effects
		upgradeButton.MouseEnter:Connect(function()
			upgradeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
		end)
		upgradeButton.MouseLeave:Connect(function()
			upgradeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
		end)
	end
end

function GameClient:showButtonFeedback(button)
	local originalColor = button.BackgroundColor3
	button.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
	task.wait(0.15)
	button.BackgroundColor3 = originalColor
end

function GameClient:showNotification(message, color)
	color = color or Color3.fromRGB(50, 120, 200)

	local yOffset = 90 + (self.notificationStack * 65)

	local notification = Instance.new("TextLabel")
	notification.Name = "Notification"
	notification.Size = UDim2.new(0, 400, 0, 60)
	notification.Position = UDim2.new(0.5, -200, 0, -60)
	notification.AnchorPoint = Vector2.new(0.5, 0)
	notification.BackgroundColor3 = color
	notification.TextColor3 = Color3.fromRGB(255, 255, 255)
	notification.TextSize = 16
	notification.Font = Enum.Font.Gotham
	notification.Text = message
	notification.Parent = self.ui.screenGui

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notification

	self.notificationStack = self.notificationStack + 1

	-- Slide in
	local slideInTween = TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Position = UDim2.new(0.5, -200, 0, yOffset) })
	slideInTween:Play()
	slideInTween.Completed:Connect(function()
		task.wait(2.5)

		-- Fade out
		local fadeOutTween = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { BackgroundTransparency = 1, TextTransparency = 1 })
		fadeOutTween:Play()
		fadeOutTween.Completed:Connect(function()
			notification:Destroy()
			self.notificationStack = self.notificationStack - 1
		end)
	end)
end

function GameClient:updateUIFromData(data)
	if data.Energy then
		self.gameState.energy = data.Energy
		self.ui.energyLabel.Text = "⚡ Energy: " .. self:formatNumber(data.Energy)
	end

	if data.VacuumCharge then
		self.gameState.vacuumCharge = data.VacuumCharge
		local fillRatio = math.clamp(data.VacuumCharge / 100, 0, 1)
		self.ui.chargeFill.Size = UDim2.new(fillRatio, 0, 1, 0)
		self.ui.chargeBarText.Text = math.floor(data.VacuumCharge) .. "%"
	end

	if data.GhostCount then
		self.gameState.ghostCount = data.GhostCount
		self.ui.ghostLabel.Text = "👻 Ghosts: " .. data.GhostCount
	end

	if data.ProductionRate then
		self.gameState.productionRate = data.ProductionRate
		self.ui.productionLabel.Text = "🏭 +" .. self:formatNumber(data.ProductionRate) .. "/sec"
	end

	if data.CurrentZone then
		self.gameState.currentZone = data.CurrentZone
		self.ui.zoneLabel.Text = "🗺 " .. data.CurrentZone
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

-- Built with assistance from Claude Code by Anthropic.
