	--
	-- Ghost Catcher Tycoon
	-- Author:  nobody174 (vartdal@gmail.com)
	-- Repo:    https://github.com/nobody174/roblox-games
	-- License: All rights reserved © 2025 nobody174
	-- "It's never too late to give up!"
	--
	-- Client-side UI management: screen layout, button handlers, tab system, and real-time game state updates.
	--
	pcall(function() print("[GameClient] Script loaded!") end)

	-- Prevent re-initialization on character respawn
	if _G.GameClientInitialized then return end
	_G.GameClientInitialized = true

	print("[Ghost Catcher Tycoon] GameClient script starting...")

	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")

	-- Wait for player to be available
	local player = Players.LocalPlayer
	if not player then
		print("[Ghost Catcher Tycoon] Waiting for LocalPlayer...")
		player = Players:WaitForChild("LocalPlayer")
	end
	print("[Ghost Catcher Tycoon] Player found: " .. player.Name)

	local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
	local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

	print("[GameClient] AdminLog will load separately as LocalScript")

	-- Load modules from StarterPlayerScripts
	local modulesFolder = game.StarterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("modules")
	local GhostCardBuilder = require(modulesFolder:WaitForChild("GhostCardBuilder"))

	local ChatUI = nil
	local success, chatModule = pcall(function()
		return require(modulesFolder:WaitForChild("ChatUI"))
	end)
	if success and chatModule then
		ChatUI = chatModule
		print("[Ghost Catcher Tycoon] ChatUI loaded successfully")
	else
		print("[Ghost Catcher Tycoon] ChatUI not found - system disabled")
	end

	local GameClient = {}
	GameClient.__index = GameClient

	function GameClient:new()
		local self = setmetatable({}, GameClient)
		self.player = player
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
		self:initializeChatUI()
		self:setupInputHandlers()
		self:startUpdateLoop()

		print("[Ghost Catcher Tycoon] Client initialized!")
	end

	function GameClient:initializeChatUI()
		if ChatUI then
			local success, err = pcall(function()
				local chatUI = ChatUI:new()
				chatUI:initialize(self, self.ui.screenGui)
			end)
			if success then
				print("[ChatUI] Initialized successfully")
			else
				print("[ChatUI] Error during initialization: " .. tostring(err))
			end
		else
			print("[ChatUI] Module not found - chat system disabled")
		end
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
		self.remotes.UpgradeRoom = remotesFolder:FindFirstChild(Constants.Remotes.UpgradeRoom)
		self.remotes.UnlockZone = remotesFolder:FindFirstChild(Constants.Remotes.UnlockZone)
		self.remotes.TrainGhost = remotesFolder:FindFirstChild(Constants.Remotes.TrainGhost)
		self.remotes.GachaPull = remotesFolder:FindFirstChild(Constants.Remotes.GachaPull)
		self.remotes.ReleaseGhost = remotesFolder:FindFirstChild("ReleaseGhost")
		self.remotes.AdminCommand = remotesFolder:FindFirstChild("AdminCommand")

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
		energyLabel.Text = "⚡ Energy: 0"
		energyLabel.Parent = topPanel

		-- Coins display (new label, left side row 1, after energy)
		local coinsLabel = Instance.new("TextLabel")
		coinsLabel.Name = "CoinsDisplay"
		coinsLabel.Size = UDim2.new(0, 200, 0, 35)
		coinsLabel.Position = UDim2.new(0, 300, 0, 5)
		coinsLabel.BackgroundTransparency = 1
		coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		coinsLabel.TextSize = 20
		coinsLabel.Font = Enum.Font.GothamBold
		coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
		coinsLabel.Text = "💰 Coins: 0"
		coinsLabel.Parent = topPanel

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
		ghostLabel.Text = "👻 Ghosts: 0"
		ghostLabel.Parent = topPanel

		-- Level display (left side, row 2)
		local levelLabel = Instance.new("TextLabel")
		levelLabel.Name = "LevelDisplay"
		levelLabel.Size = UDim2.new(0, 150, 0, 30)
		levelLabel.Position = UDim2.new(0, 10, 0, 45)
		levelLabel.BackgroundTransparency = 1
		levelLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
		levelLabel.TextSize = 14
		levelLabel.Font = Enum.Font.GothamBold
		levelLabel.TextXAlignment = Enum.TextXAlignment.Left
		levelLabel.Text = "📊 Level: 1"
		levelLabel.Parent = topPanel

		-- XP/Progress display (left side, row 2, next to level)
		local xpLabel = Instance.new("TextLabel")
		xpLabel.Name = "XPDisplay"
		xpLabel.Size = UDim2.new(0, 150, 0, 30)
		xpLabel.Position = UDim2.new(0, 170, 0, 45)
		xpLabel.BackgroundTransparency = 1
		xpLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
		xpLabel.TextSize = 12
		xpLabel.Font = Enum.Font.Gotham
		xpLabel.TextXAlignment = Enum.TextXAlignment.Left
		xpLabel.Text = "⭐ XP: 0%"
		xpLabel.Parent = topPanel

		-- Production rate display (left side, row 2, further right)
		local productionLabel = Instance.new("TextLabel")
		productionLabel.Name = "ProductionDisplay"
		productionLabel.Size = UDim2.new(0, 200, 0, 30)
		productionLabel.Position = UDim2.new(0, 330, 0, 45)
		productionLabel.BackgroundTransparency = 1
		productionLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
		productionLabel.TextSize = 14
		productionLabel.Font = Enum.Font.Gotham
		productionLabel.TextXAlignment = Enum.TextXAlignment.Left
		productionLabel.Text = "🏭 +0/sec"
		productionLabel.Parent = topPanel

		-- Zone container (right side, row 2)
		local zoneContainer = Instance.new("Frame")
		zoneContainer.Name = "ZoneContainer"
		zoneContainer.Size = UDim2.new(0, 210, 0, 30)
		zoneContainer.Position = UDim2.new(1, -210, 0, 45)
		zoneContainer.BackgroundTransparency = 1
		zoneContainer.Parent = topPanel

		-- Zone name label
		local zoneLabel = Instance.new("TextLabel")
		zoneLabel.Name = "ZoneDisplay"
		zoneLabel.Size = UDim2.new(1, 0, 0, 15)
		zoneLabel.Position = UDim2.new(0, 0, 0, 0)
		zoneLabel.BackgroundTransparency = 1
		zoneLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
		zoneLabel.TextSize = 14
		zoneLabel.Font = Enum.Font.GothamBold
		zoneLabel.TextXAlignment = Enum.TextXAlignment.Left
		zoneLabel.Text = "🗺 Whisper Woods"
		zoneLabel.Parent = zoneContainer

		-- Zone description label
		local zoneDescLabel = Instance.new("TextLabel")
		zoneDescLabel.Name = "ZoneDesc"
		zoneDescLabel.Size = UDim2.new(1, 0, 0, 15)
		zoneDescLabel.Position = UDim2.new(0, 0, 0, 15)
		zoneDescLabel.BackgroundTransparency = 1
		zoneDescLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
		zoneDescLabel.TextSize = 11
		zoneDescLabel.Font = Enum.Font.Gotham
		zoneDescLabel.TextXAlignment = Enum.TextXAlignment.Left
		zoneDescLabel.Text = "Starter zone"
		zoneDescLabel.Parent = zoneContainer

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
			{ name = "PvP", label = "⚔\nPvP" },
			{ name = "Quests", label = "📜\nQuests" },
			{ name = "Bosses", label = "👹\nBosses" },
			{ name = "Leaderboard", label = "🏆\nRanks" },
			{ name = "Prestige", label = "⭐\nPrestige" },
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

					if tabName == "Zones" and not self.populatedTabs["Zones"] then
						print("[Ghost Catcher Tycoon] Calling populateZonesTab...")
						self:populateZonesTab()
						self.populatedTabs["Zones"] = true
					end

					if tabName == "Shop" and not self.populatedTabs["Shop"] then
						print("[Ghost Catcher Tycoon] Calling populateShopTab...")
						self:populateShopTab()
						self.populatedTabs["Shop"] = true
					end

					if tabName == "Info" and not self.populatedTabs["Info"] then
						print("[Ghost Catcher Tycoon] Calling populateInfoTab...")
						self:populateInfoTab()
						self.populatedTabs["Info"] = true
					end

					if tabName == "Quests" and not self.populatedTabs["Quests"] then
						print("[Ghost Catcher Tycoon] Calling populateQuestsTab...")
						self:populateQuestsTab()
						self.populatedTabs["Quests"] = true
					end

					if tabName == "Bosses" and not self.populatedTabs["Bosses"] then
						print("[Ghost Catcher Tycoon] Calling populateBossesTab...")
						self:populateBossesTab()
						self.populatedTabs["Bosses"] = true
					end

					if tabName == "Leaderboard" and not self.populatedTabs["Leaderboard"] then
						print("[Ghost Catcher Tycoon] Calling populateLeaderboardTab...")
						self:populateLeaderboardTab()
						self.populatedTabs["Leaderboard"] = true
					end

					if tabName == "Prestige" and not self.populatedTabs["Prestige"] then
						print("[Ghost Catcher Tycoon] Calling populatePrestigeTab...")
						self:populatePrestigeTab()
						self.populatedTabs["Prestige"] = true
					end

					if tabName == "PvP" and not self.populatedTabs["PvP"] then
						print("[Ghost Catcher Tycoon] Calling populatePvPTab...")
						self:populatePvPTab()
						self.populatedTabs["PvP"] = true
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
		self.ui.coinsLabel = coinsLabel
		self.ui.levelLabel = levelLabel
		self.ui.xpLabel = xpLabel
		self.ui.ghostLabel = ghostLabel
		self.ui.productionLabel = productionLabel
		self.ui.zoneLabel = zoneLabel
		self.ui.zoneDescLabel = zoneDescLabel
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
			-- Show catch animation feedback
			self:playCatchAnimation()
		end)

		-- Handle bring home button click
		self.ui.bringButton.MouseButton1Click:Connect(function()
			self.remotes.BringGhostsHome:FireServer()
			self:showButtonFeedback(self.ui.bringButton)
		end)

		-- Update UI when server sends updates (listen to broadcast)
		if self.remotes.UpdateUI then
			self.remotes.UpdateUI.OnClientEvent:Connect(function(data)
				self:updateUIFromData(data)
			end)
		end

		-- Server notifications
		if self.remotes.ShowNotification then
			self.remotes.ShowNotification.OnClientEvent:Connect(function(message, color)
				self:showNotification(message, color)
			end)
		end

		print("[Ghost Catcher Tycoon] Input handlers connected")
	end

	function GameClient:getMaxGhostSlots(chamberLevel)
		return 5 + (chamberLevel * 10)
	end

	function GameClient:populateGhostTab()
		local ghostTabContent = self.ui.tabContents["Ghost"]
		if not ghostTabContent then return end

		-- Clear existing content
		for _, child in ipairs(ghostTabContent:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("GhostCard_") then
				child:Destroy()
			end
			if child:IsA("UIGridLayout") then
				child:Destroy()
			end
			if child:IsA("TextLabel") and (child.Name == "EmptyMessage" or child.Name == "InventoryLimit") then
				child:Destroy()
			end
		end

		-- Calculate and display inventory limit
		local chamberLevel = (self.gameState.rooms and self.gameState.rooms.GhostChamber and self.gameState.rooms.GhostChamber.level) or 0
		local maxSlots = self:getMaxGhostSlots(chamberLevel)
		local currentCount = 0
		if self.gameState.ghostInventory then
			for _ in pairs(self.gameState.ghostInventory) do
				currentCount = currentCount + 1
			end
		end

		-- Calculate canvas size dynamically (6 ghosts per row, 148px per row including padding)
		local rowsNeeded = math.ceil(maxSlots / 6)
		local canvasHeight = (rowsNeeded * 148) + 50
		ghostTabContent.CanvasSize = UDim2.new(1, 0, 0, canvasHeight)

		local limitLabel = Instance.new("TextLabel")
		limitLabel.Name = "InventoryLimit"
		limitLabel.Size = UDim2.new(1, 0, 0, 25)
		limitLabel.Position = UDim2.new(0, 0, 0, 0)
		limitLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		limitLabel.TextColor3 = Color3.fromRGB(150, 200, 100)
		limitLabel.TextSize = 12
		limitLabel.Font = Enum.Font.GothamBold
		limitLabel.TextXAlignment = Enum.TextXAlignment.Center
		limitLabel.Text = "👻 Inventory: " .. currentCount .. " / " .. maxSlots
		limitLabel.Parent = ghostTabContent

		local ghostGridLayout = Instance.new("UIGridLayout")
		ghostGridLayout.CellSize = UDim2.new(0, 230, 0, 140)
		ghostGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
		ghostGridLayout.FillDirection = Enum.FillDirection.Horizontal
		ghostGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		ghostGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		ghostGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ghostGridLayout.Parent = ghostTabContent

		print("[Ghost Catcher Tycoon] Populating Ghost tab...")

		-- Define rarity colors for display
		local rarityColors = {
			Common = Color3.fromRGB(128, 128, 128),
			Uncommon = Color3.fromRGB(0, 255, 0),
			Rare = Color3.fromRGB(0, 0, 255),
			Epic = Color3.fromRGB(255, 140, 0),
			Legendary = Color3.fromRGB(128, 0, 128),
			Corrupted = Color3.fromRGB(139, 0, 139),
		}

		-- Fetch ghost inventory from game state
		local ghostsToDisplay = {}
		if self.gameState.ghostInventory then
			for inventoryKey, ghostData in pairs(self.gameState.ghostInventory) do
				table.insert(ghostsToDisplay, {
					inventoryKey = inventoryKey,
					name = ghostData.name,
					rarity = ghostData.rarity,
					level = ghostData.level,
					energyPerSec = 1 * ghostData.level
				})
			end
		end

		-- Sort by rarity (descending) then by name (ascending)
		local rarityOrder = {
			Legendary = 6,
			Epic = 5,
			Rare = 4,
			Uncommon = 3,
			Common = 2,
			Corrupted = 7,
		}
		table.sort(ghostsToDisplay, function(a, b)
			local rarityA = rarityOrder[a.rarity] or 0
			local rarityB = rarityOrder[b.rarity] or 0
			if rarityA ~= rarityB then
				return rarityA > rarityB
			end
			return a.name < b.name
		end)

		-- If no ghosts in inventory, show message
		if next(self.gameState.ghostInventory or {}) == nil then
			local emptyLabel = Instance.new("TextLabel")
			emptyLabel.Name = "EmptyMessage"
			emptyLabel.Size = UDim2.new(1, 0, 1, 0)
			emptyLabel.BackgroundTransparency = 1
			emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			emptyLabel.TextSize = 14
			emptyLabel.Font = Enum.Font.Gotham
			emptyLabel.Text = "No ghosts caught yet!\nCatch some ghosts to see them here."
			emptyLabel.Parent = ghostTabContent
			return
		end

		for _, ghostData in ipairs(ghostsToDisplay) do
			local callbacks = {
				onTrain = function()
					print("[Ghost Catcher Tycoon] Train button clicked for " .. ghostData.name .. " (key: " .. ghostData.inventoryKey .. ")")
					self.remotes.TrainGhost:FireServer(ghostData.inventoryKey)
				end,
				onRelease = function()
					print("[Ghost Catcher Tycoon] Release button clicked for " .. ghostData.name .. " (key: " .. ghostData.inventoryKey .. ")")
					if self.remotes.ReleaseGhost then
						self.remotes.ReleaseGhost:FireServer(ghostData.inventoryKey)
					else
						print("[Ghost Catcher Tycoon] ReleaseGhost remote not found")
					end
				end
			}
			GhostCardBuilder:buildCard(ghostData, ghostTabContent, callbacks)
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
			costLabel.Text = "Cost: " .. self:formatNumber(math.floor(100 * (1 ^ 1.5))) .. " coins"
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

	function GameClient:populateZonesTab()
		local zonesTabContent = self.ui.tabContents["Zones"]
		if not zonesTabContent then return end

		-- Clear existing content
		for _, child in ipairs(zonesTabContent:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("ZoneCard_") then
				child:Destroy()
			end
			if child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		zonesTabContent.CanvasSize = UDim2.new(1, 0, 0, 1200)  -- Extra padding at bottom to prevent overlap with action buttons

		local zoneListLayout = Instance.new("UIListLayout")
		zoneListLayout.FillDirection = Enum.FillDirection.Vertical
		zoneListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		zoneListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		zoneListLayout.Padding = UDim.new(0, 8)
		zoneListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		zoneListLayout.Parent = zonesTabContent

		print("[Ghost Catcher Tycoon] Populating Zones tab...")

		-- Define zones (from config)
		local zones = {
			{ name = "Whisper Woods", emoji = "🌲", cost = 0, description = "Starter zone" },
			{ name = "Foggy Fields", emoji = "🌫", cost = 1500, description = "Slightly thicker fog" },
			{ name = "Gloomy Graveyard", emoji = "⚰", cost = 6000, description = "First real challenge" },
			{ name = "Electro Alley", emoji = "⚡", cost = 18000, description = "Electric theme" },
			{ name = "Frostbite Caverns", emoji = "❄", cost = 42000, description = "Icy crystals" },
			{ name = "Sunken Spirit Reef", emoji = "🌊", cost = 90000, description = "Underwater ruins" },
			{ name = "Clocktower District", emoji = "🕰", cost = 180000, description = "Steampunk city" },
			{ name = "Astral Observatory", emoji = "🔭", cost = 350000, description = "Cosmic vibe" },
			{ name = "Phantom Fortress", emoji = "🏰", cost = 700000, description = "Dark castle" },
			{ name = "The Rift", emoji = "🌀", cost = 1500000, description = "Chaotic realm" },
			{ name = "Eternity Nexus", emoji = "♾", cost = 0, description = "Final zone" },
		}

		for _, zoneData in ipairs(zones) do
			-- Create zone card frame
			local zoneCard = Instance.new("Frame")
			zoneCard.Name = "ZoneCard_" .. zoneData.name
			zoneCard.Size = UDim2.new(1, 0, 0, 90)
			zoneCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
			zoneCard.BorderSizePixel = 0
			zoneCard.Parent = zonesTabContent

			local zoneCardCorner = Instance.new("UICorner")
			zoneCardCorner.CornerRadius = UDim.new(0, 8)
			zoneCardCorner.Parent = zoneCard

			-- Zone name label
			local zoneNameLabel = Instance.new("TextLabel")
			zoneNameLabel.Name = "ZoneName"
			zoneNameLabel.Size = UDim2.new(0, 200, 0, 30)
			zoneNameLabel.Position = UDim2.new(0, 10, 0, 5)
			zoneNameLabel.BackgroundTransparency = 1
			zoneNameLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
			zoneNameLabel.TextSize = 16
			zoneNameLabel.Font = Enum.Font.GothamBold
			zoneNameLabel.TextXAlignment = Enum.TextXAlignment.Left
			zoneNameLabel.Text = zoneData.emoji .. " " .. zoneData.name
			zoneNameLabel.Parent = zoneCard

			-- Description
			local descLabel = Instance.new("TextLabel")
			descLabel.Name = "Description"
			descLabel.Size = UDim2.new(0, 250, 0, 20)
			descLabel.Position = UDim2.new(0, 10, 0, 35)
			descLabel.BackgroundTransparency = 1
			descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			descLabel.TextSize = 11
			descLabel.Font = Enum.Font.Gotham
			descLabel.TextXAlignment = Enum.TextXAlignment.Left
			descLabel.Text = zoneData.description
			descLabel.Parent = zoneCard

			-- Check if zone is unlocked
			local isUnlocked = zoneData.cost == 0 or (self.gameState.unlockedZones and self.gameState.unlockedZones[zoneData.name])

			-- Cost/Unlocked label
			local costLabel = Instance.new("TextLabel")
			costLabel.Name = "CostLabel"
			costLabel.Size = UDim2.new(0, 150, 0, 30)
			costLabel.Position = UDim2.new(1, -250, 0, 5)
			costLabel.BackgroundTransparency = 1
			costLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			costLabel.TextSize = 12
			costLabel.Font = Enum.Font.GothamBold
			costLabel.TextXAlignment = Enum.TextXAlignment.Right
			if isUnlocked then
				costLabel.Text = "Unlocked"
				costLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
			else
				costLabel.Text = "Cost: " .. self:formatNumber(zoneData.cost)
			end
			costLabel.Parent = zoneCard

			-- Unlock button
			local unlockButton = Instance.new("TextButton")
			unlockButton.Name = "UnlockButton"
			unlockButton.Size = UDim2.new(0, 80, 0, 30)
			unlockButton.Position = UDim2.new(1, -90, 0, 35)
			unlockButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
			unlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			unlockButton.TextSize = 12
			unlockButton.Font = Enum.Font.GothamBold
			unlockButton.Text = isUnlocked and "Visit" or "Unlock"
			unlockButton.Parent = zoneCard

			local unlockCorner = Instance.new("UICorner")
			unlockCorner.CornerRadius = UDim.new(0, 6)
			unlockCorner.Parent = unlockButton

			-- Button click handler
			local zoneName = zoneData.name
			unlockButton.MouseButton1Click:Connect(function()
				print("[Ghost Catcher Tycoon] Unlock button clicked for " .. zoneName)
				if zoneData.cost > 0 then
					self.remotes.UnlockZone:FireServer(zoneName)
				end
				self:showButtonFeedback(unlockButton)
			end)

			-- Hover effects
			unlockButton.MouseEnter:Connect(function()
				unlockButton.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
			end)
			unlockButton.MouseLeave:Connect(function()
				unlockButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
			end)
		end
	end

	function GameClient:populateShopTab()
		local shopTabContent = self.ui.tabContents["Shop"]
		if not shopTabContent then return end

		-- Clear existing content
		for _, child in ipairs(shopTabContent:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("EggCard_") then
				child:Destroy()
			end
			if child:IsA("UIGridLayout") then
				child:Destroy()
			end
		end

		shopTabContent.CanvasSize = UDim2.new(1, 0, 0, 700)

		local eggGridLayout = Instance.new("UIGridLayout")
		eggGridLayout.CellSize = UDim2.new(0, 250, 0, 180)
		eggGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
		eggGridLayout.FillDirection = Enum.FillDirection.Horizontal
		eggGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		eggGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		eggGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		eggGridLayout.Parent = shopTabContent

		print("[Ghost Catcher Tycoon] Populating Shop tab...")

		-- Define eggs
		local eggs = {
			{ name = "Common Egg", emoji = "🥚", price = 250, rarity = "Common", description = "80% Common, 18% Uncommon, 2% Rare" },
			{ name = "Uncommon Egg", emoji = "🥚", price = 1200, rarity = "Uncommon", description = "40% Common, 45% Uncommon, 12% Rare, 3% Epic" },
			{ name = "Rare Egg", emoji = "🥚", price = 5000, rarity = "Rare", description = "20% Uncommon, 50% Rare, 25% Epic, 5% Legendary" },
			{ name = "Epic Egg", emoji = "🥚", price = 20000, rarity = "Epic", description = "40% Rare, 45% Epic, 12% Legendary, 3% Corrupted" },
			{ name = "Legendary Egg", emoji = "🥚", price = 80000, rarity = "Legendary", description = "50% Epic, 40% Legendary, 10% Corrupted" },
			{ name = "Corrupted Egg", emoji = "🥚", price = 250000, rarity = "Corrupted", description = "80% Legendary, 20% Corrupted (Robux only)" },
			{ name = "Premium Egg", emoji = "💎", price = 4999, rarity = "Premium", description = "All rarities! (Robux only)" },
		}

		-- Rarity colors
		local rarityColors = {
			Common = Color3.fromRGB(128, 128, 128),
			Uncommon = Color3.fromRGB(0, 255, 0),
			Rare = Color3.fromRGB(0, 0, 255),
			Epic = Color3.fromRGB(255, 140, 0),
			Legendary = Color3.fromRGB(128, 0, 128),
			Corrupted = Color3.fromRGB(139, 0, 139),
			Premium = Color3.fromRGB(255, 215, 0),
		}

		for _, eggData in ipairs(eggs) do
			-- Create egg card frame
			local eggCard = Instance.new("Frame")
			eggCard.Name = "EggCard_" .. eggData.name
			eggCard.Size = UDim2.new(0, 250, 0, 180)
			eggCard.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
			eggCard.BorderSizePixel = 0
			eggCard.Parent = shopTabContent

			local eggCardCorner = Instance.new("UICorner")
			eggCardCorner.CornerRadius = UDim.new(0, 8)
			eggCardCorner.Parent = eggCard

			-- Egg emoji display
			local eggEmoji = Instance.new("TextLabel")
			eggEmoji.Name = "Emoji"
			eggEmoji.Size = UDim2.new(1, 0, 0, 40)
			eggEmoji.Position = UDim2.new(0, 0, 0, 5)
			eggEmoji.BackgroundTransparency = 1
			eggEmoji.TextColor3 = rarityColors[eggData.rarity] or Color3.fromRGB(200, 200, 200)
			eggEmoji.TextSize = 32
			eggEmoji.Font = Enum.Font.GothamBold
			eggEmoji.Text = eggData.emoji
			eggEmoji.Parent = eggCard

			-- Egg name label
			local eggNameLabel = Instance.new("TextLabel")
			eggNameLabel.Name = "EggName"
			eggNameLabel.Size = UDim2.new(1, -10, 0, 25)
			eggNameLabel.Position = UDim2.new(0, 5, 0, 45)
			eggNameLabel.BackgroundTransparency = 1
			eggNameLabel.TextColor3 = rarityColors[eggData.rarity] or Color3.fromRGB(200, 200, 200)
			eggNameLabel.TextSize = 14
			eggNameLabel.Font = Enum.Font.GothamBold
			eggNameLabel.TextXAlignment = Enum.TextXAlignment.Center
			eggNameLabel.Text = eggData.name
			eggNameLabel.Parent = eggCard

			-- Price label
			local priceLabel = Instance.new("TextLabel")
			priceLabel.Name = "Price"
			priceLabel.Size = UDim2.new(1, -10, 0, 20)
			priceLabel.Position = UDim2.new(0, 5, 0, 70)
			priceLabel.BackgroundTransparency = 1
			priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			priceLabel.TextSize = 12
			priceLabel.Font = Enum.Font.GothamBold
			priceLabel.TextXAlignment = Enum.TextXAlignment.Center
			if eggData.price > 100 then
				priceLabel.Text = self:formatNumber(eggData.price) .. " coins"
			else
				priceLabel.Text = eggData.price .. " Robux"
			end
			priceLabel.Parent = eggCard

			-- Description (rarity chances)
			local descLabel = Instance.new("TextLabel")
			descLabel.Name = "Description"
			descLabel.Size = UDim2.new(1, -10, 0, 40)
			descLabel.Position = UDim2.new(0, 5, 0, 90)
			descLabel.BackgroundTransparency = 1
			descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			descLabel.TextSize = 9
			descLabel.Font = Enum.Font.Gotham
			descLabel.TextXAlignment = Enum.TextXAlignment.Center
			descLabel.TextWrapped = true
			descLabel.Text = eggData.description
			descLabel.Parent = eggCard

			-- Hatch button
			local hatchButton = Instance.new("TextButton")
			hatchButton.Name = "HatchButton"
			hatchButton.Size = UDim2.new(1, -10, 0, 30)
			hatchButton.Position = UDim2.new(0, 5, 0, 145)
			hatchButton.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
			hatchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			hatchButton.TextSize = 12
			hatchButton.Font = Enum.Font.GothamBold
			hatchButton.Text = "Hatch"
			hatchButton.Parent = eggCard

			local hatchCorner = Instance.new("UICorner")
			hatchCorner.CornerRadius = UDim.new(0, 6)
			hatchCorner.Parent = hatchButton

			-- Button click handler
			local eggName = eggData.name
			hatchButton.MouseButton1Click:Connect(function()
				print("[Ghost Catcher Tycoon] Hatch button clicked for " .. eggName)
				self.remotes.GachaPull:FireServer(eggName)
				self:showButtonFeedback(hatchButton)
			end)

			-- Hover effects
			hatchButton.MouseEnter:Connect(function()
				hatchButton.BackgroundColor3 = Color3.fromRGB(70, 180, 100)
			end)
			hatchButton.MouseLeave:Connect(function()
				hatchButton.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
			end)
		end
	end

	function GameClient:populateInfoTab()
		local infoTabContent = self.ui.tabContents["Info"]
		if not infoTabContent then return end

		-- Clear existing content
		for _, child in ipairs(infoTabContent:GetChildren()) do
			if child:IsA("Frame") and child.Name:match("GamePassCard_") then
				child:Destroy()
			end
			if child:IsA("TextLabel") and child.Name:match("InfoText_") then
				child:Destroy()
			end
			if child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		infoTabContent.CanvasSize = UDim2.new(1, 0, 0, 800)

		local infoListLayout = Instance.new("UIListLayout")
		infoListLayout.FillDirection = Enum.FillDirection.Vertical
		infoListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		infoListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		infoListLayout.Padding = UDim.new(0, 10)
		infoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		infoListLayout.Parent = infoTabContent

		print("[Ghost Catcher Tycoon] Populating Info tab...")

		-- Game info text
		local gameInfoLabel = Instance.new("TextLabel")
		gameInfoLabel.Name = "InfoText_GameInfo"
		gameInfoLabel.Size = UDim2.new(1, -20, 0, 80)
		gameInfoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		gameInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		gameInfoLabel.TextSize = 12
		gameInfoLabel.Font = Enum.Font.Gotham
		gameInfoLabel.TextWrapped = true
		gameInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
		gameInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
		gameInfoLabel.Text = "Ghost Catcher Tycoon\n\nCatch ghosts, earn energy, train your collection, and unlock new zones. Build your HQ to boost production!\n\nVersion: 0.1.0"
		gameInfoLabel.Parent = infoTabContent

		local infoCorner = Instance.new("UICorner")
		infoCorner.CornerRadius = UDim.new(0, 8)
		infoCorner.Parent = gameInfoLabel

		-- GamePass section header
		local gpHeaderLabel = Instance.new("TextLabel")
		gpHeaderLabel.Name = "InfoText_GPHeader"
		gpHeaderLabel.Size = UDim2.new(1, -20, 0, 30)
		gpHeaderLabel.BackgroundTransparency = 1
		gpHeaderLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
		gpHeaderLabel.TextSize = 16
		gpHeaderLabel.Font = Enum.Font.GothamBold
		gpHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
		gpHeaderLabel.Text = "GamePasses"
		gpHeaderLabel.Parent = infoTabContent

		-- Define GamePasses
		local gamePasses = {
			{ name = "Auto-Catch", price = 699, emoji = "⚙", description = "Automatically catch ghosts without clicking" },
			{ name = "Auto-Train", price = 499, emoji = "🎓", description = "Automatically train your ghosts" },
			{ name = "Double Energy", price = 399, emoji = "⚡", description = "Double all energy production" },
			{ name = "VIP Zone", price = 799, emoji = "👑", description = "Access exclusive VIP zone" },
			{ name = "Extra Storage", price = 299, emoji = "📦", description = "Double ghost storage slots" },
		}

		for _, gpData in ipairs(gamePasses) do
			-- Create GamePass card frame
			local gpCard = Instance.new("Frame")
			gpCard.Name = "GamePassCard_" .. gpData.name
			gpCard.Size = UDim2.new(1, -20, 0, 70)
			gpCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
			gpCard.BorderSizePixel = 0
			gpCard.Parent = infoTabContent

			local gpCardCorner = Instance.new("UICorner")
			gpCardCorner.CornerRadius = UDim.new(0, 8)
			gpCardCorner.Parent = gpCard

			-- GamePass name
			local gpNameLabel = Instance.new("TextLabel")
			gpNameLabel.Name = "GPName"
			gpNameLabel.Size = UDim2.new(0, 150, 0, 25)
			gpNameLabel.Position = UDim2.new(0, 10, 0, 8)
			gpNameLabel.BackgroundTransparency = 1
			gpNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			gpNameLabel.TextSize = 14
			gpNameLabel.Font = Enum.Font.GothamBold
			gpNameLabel.TextXAlignment = Enum.TextXAlignment.Left
			gpNameLabel.Text = gpData.emoji .. " " .. gpData.name
			gpNameLabel.Parent = gpCard

			-- Description
			local descLabel = Instance.new("TextLabel")
			descLabel.Name = "Description"
			descLabel.Size = UDim2.new(0, 250, 0, 35)
			descLabel.Position = UDim2.new(0, 10, 0, 33)
			descLabel.BackgroundTransparency = 1
			descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			descLabel.TextSize = 11
			descLabel.Font = Enum.Font.Gotham
			descLabel.TextWrapped = true
			descLabel.TextXAlignment = Enum.TextXAlignment.Left
			descLabel.TextYAlignment = Enum.TextYAlignment.Top
			descLabel.Text = gpData.description
			descLabel.Parent = gpCard

			-- Price label (Robux)
			local priceLabel = Instance.new("TextLabel")
			priceLabel.Name = "Price"
			priceLabel.Size = UDim2.new(0, 80, 0, 25)
			priceLabel.Position = UDim2.new(1, -150, 0, 8)
			priceLabel.BackgroundTransparency = 1
			priceLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
			priceLabel.TextSize = 12
			priceLabel.Font = Enum.Font.GothamBold
			priceLabel.TextXAlignment = Enum.TextXAlignment.Right
			priceLabel.Text = "R$" .. gpData.price
			priceLabel.Parent = gpCard

			-- Buy button
			local buyButton = Instance.new("TextButton")
			buyButton.Name = "BuyButton"
			buyButton.Size = UDim2.new(0, 60, 0, 25)
			buyButton.Position = UDim2.new(1, -60, 0, 8)
			buyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
			buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			buyButton.TextSize = 11
			buyButton.Font = Enum.Font.GothamBold
			buyButton.Text = "Buy"
			buyButton.Parent = gpCard

			local buyCorner = Instance.new("UICorner")
			buyCorner.CornerRadius = UDim.new(0, 6)
			buyCorner.Parent = buyButton

			-- Button click handler
			local gpName = gpData.name
			buyButton.MouseButton1Click:Connect(function()
				print("[Ghost Catcher Tycoon] Buy GamePass: " .. gpName)
				self:showNotification("GamePass purchase not yet implemented", Color3.fromRGB(255, 150, 100))
			end)

			-- Hover effects
			buyButton.MouseEnter:Connect(function()
				buyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
			end)
			buyButton.MouseLeave:Connect(function()
				buyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
			end)
		end
	end

	function GameClient:showButtonFeedback(button)
		local originalColor = button.BackgroundColor3
		button.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
		task.wait(0.15)
		button.BackgroundColor3 = originalColor
	end

	function GameClient:playCatchAnimation()
		-- Create a flash effect on catch button
		local catchButton = self.ui.catchButton
		local originalSize = catchButton.Size

		-- Pulse animation
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(catchButton, tweenInfo, { Size = UDim2.new(0, 100, 0, 100) })
		tween:Play()

		task.wait(0.1)

		-- Shrink back
		local tweenInfo2 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tween2 = TweenService:Create(catchButton, tweenInfo2, { Size = originalSize })
		tween2:Play()
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

		if data.Coins then
			self.gameState.coins = data.Coins
			self.ui.coinsLabel.Text = "💰 Coins: " .. self:formatNumber(data.Coins)
		end

		if data.Level then
			self.gameState.level = data.Level
			self.ui.levelLabel.Text = "📊 Level: " .. data.Level
		end

		if data.CurrentXP and data.NextLevelXP then
			local xpPercent = math.floor((data.CurrentXP / data.NextLevelXP) * 100)
			self.ui.xpLabel.Text = "⭐ XP: " .. xpPercent .. "%"
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

		if data.CurrentZoneDescription then
			self.ui.zoneDescLabel.Text = data.CurrentZoneDescription
		end

		-- Update room levels from broadcast data
		if data.Rooms then
			local ghostChamberLevelChanged = false
			if self.gameState.rooms and self.gameState.rooms.GhostChamber and
			   data.Rooms.GhostChamber and
			   self.gameState.rooms.GhostChamber.level ~= data.Rooms.GhostChamber.level then
				ghostChamberLevelChanged = true
			end

			self.gameState.rooms = data.Rooms
			-- Update all visible room cards
			for roomName, roomData in pairs(data.Rooms) do
				local hqContent = self.ui.tabContents["HQ"]
				if hqContent then
					local roomCard = hqContent:FindFirstChild("RoomCard_" .. roomName)
					if roomCard then
						local levelLabel = roomCard:FindFirstChild("LevelLabel")
						if levelLabel then
							levelLabel.Text = "Level: " .. roomData.level .. " (Max 10)"
						end
						-- Update cost based on new level
						local costLabel = roomCard:FindFirstChild("CostLabel")
						if costLabel then
							if roomData.level >= 10 then
								costLabel.Text = "Max level"
							else
								local nextLevel = roomData.level + 1
								local upgradeCost = math.floor(100 * (nextLevel ^ 1.5))
								costLabel.Text = "Cost: " .. self:formatNumber(upgradeCost) .. " coins"
							end
						end
					end
				end
			end

			-- If Ghost Chamber upgraded, refresh Ghost tab to update inventory limit display
			if ghostChamberLevelChanged then
				local ghostContent = self.ui.tabContents["Ghost"]
				if ghostContent and ghostContent.Visible then
					self:populateGhostTab()
					self.populatedTabs["Ghost"] = true
				else
					-- Mark for refresh when tab is opened
					self.populatedTabs["Ghost"] = nil
				end
			end
		end

		-- Update ghost inventory from broadcast data
		if data.GhostInventory then
			-- Track what actually changed
			local inventoryChanged = false
			local levelChanges = {}

			if not self.gameState.ghostInventory then
				inventoryChanged = true
			else
				-- Compare counts and keys to detect changes
				local oldCount = 0
				for _ in pairs(self.gameState.ghostInventory) do oldCount = oldCount + 1 end
				local newCount = 0
				for _ in pairs(data.GhostInventory) do newCount = newCount + 1 end
				if oldCount ~= newCount then
					inventoryChanged = true
				else
					-- Track level changes without full refresh
					for key, ghost in pairs(data.GhostInventory) do
						if self.gameState.ghostInventory[key] and self.gameState.ghostInventory[key].level ~= ghost.level then
							levelChanges[key] = ghost.level
						end
					end
				end
			end

			-- ALWAYS update game state (whether tab is visible or not)
			self.gameState.ghostInventory = data.GhostInventory

			-- If inventory changed (new ghost added), full refresh
			if inventoryChanged then
				self.populatedTabs["Ghost"] = nil
				local ghostContent = self.ui.tabContents["Ghost"]
				if ghostContent and ghostContent.Visible then
					self:populateGhostTab()
					self.populatedTabs["Ghost"] = true
				end
			elseif next(levelChanges) then
				-- Level changes: update in place if tab is visible, otherwise just mark for refresh
				if self.ui.tabContents["Ghost"].Visible then
					local ghostContent = self.ui.tabContents["Ghost"]
					for key, newLevel in pairs(levelChanges) do
						local card = ghostContent:FindFirstChild("GhostCard_" .. key)
						if card then
							local levelLabel = card:FindFirstChild("LevelLabel")
							if levelLabel then
								levelLabel.Text = "Lv. " .. newLevel
							end
							local energyLabel = card:FindFirstChild("EnergyLabel")
							if energyLabel then
								energyLabel.Text = "⚡ +" .. math.floor(newLevel * 1) .. "/sec"
							end
							-- Update training cost
							local costLabel = card:FindFirstChild("CostLabel")
							if costLabel then
								local newCost = math.floor(newLevel * 75)
								costLabel.Text = "💰 " .. newCost
							end
						end
					end
				else
					-- Tab not visible, mark for rebuild when reopened
					self.populatedTabs["Ghost"] = nil
				end
			end
		end

		-- Update unlocked zones from broadcast data
		if data.UnlockedZones then
			self.gameState.unlockedZones = data.UnlockedZones
			-- Refresh zones tab if it's currently visible
			local zonesContent = self.ui.tabContents["Zones"]
			if zonesContent and zonesContent.Visible then
				self:populateZonesTab()
			end
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
		-- Listen to UpdateUI remote (real-time broadcast from server)
		if self.remotes.UpdateUI then
			self.remotes.UpdateUI.OnClientEvent:Connect(function(data)
				self:updateUIFromData(data)
			end)
		end

		-- Periodically request game state as fallback
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

	function GameClient:populateQuestsTab()
		local content = self.ui.tabContents["Quests"]
		content:ClearAllChildren()
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 40)
		textLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 12
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "📜 Quests Tab (Phase 2 Testing)"
		textLabel.BorderSizePixel = 0
		textLabel.Parent = content

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, -10, 0, 100)
		infoLabel.Position = UDim2.new(0, 5, 0, 50)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		infoLabel.TextSize = 11
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextWrapped = true
		infoLabel.Text = "Quests system is loading...\n\nDaily and weekly quests will appear here."
		infoLabel.Parent = content
	end

	function GameClient:populateBossesTab()
		local content = self.ui.tabContents["Bosses"]
		content:ClearAllChildren()
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 40)
		textLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 12
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "👹 Bosses Tab (Phase 2 Testing)"
		textLabel.BorderSizePixel = 0
		textLabel.Parent = content

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, -10, 0, 100)
		infoLabel.Position = UDim2.new(0, 5, 0, 50)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		infoLabel.TextSize = 11
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextWrapped = true
		infoLabel.Text = "Boss system is loading...\n\nActive boss encounters will appear here."
		infoLabel.Parent = content
	end

	function GameClient:populateLeaderboardTab()
		local content = self.ui.tabContents["Leaderboard"]
		content:ClearAllChildren()
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 40)
		textLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 12
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "🏆 Leaderboard (Phase 2 Testing)"
		textLabel.BorderSizePixel = 0
		textLabel.Parent = content

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, -10, 0, 100)
		infoLabel.Position = UDim2.new(0, 5, 0, 50)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		infoLabel.TextSize = 11
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextWrapped = true
		infoLabel.Text = "Leaderboard is loading...\n\nTop players and rankings will appear here."
		infoLabel.Parent = content
	end

	function GameClient:populatePrestigeTab()
		local content = self.ui.tabContents["Prestige"]
		content:ClearAllChildren()
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 40)
		textLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 12
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "⭐ Prestige (Phase 2 Testing)"
		textLabel.BorderSizePixel = 0
		textLabel.Parent = content

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, -10, 0, 100)
		infoLabel.Position = UDim2.new(0, 5, 0, 50)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		infoLabel.TextSize = 11
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextWrapped = true
		infoLabel.Text = "Prestige system is loading...\n\nLevel up and reset to gain permanent bonuses!"
		infoLabel.Parent = content
	end

	function GameClient:populatePvPTab()
		local content = self.ui.tabContents["PvP"]
		content:ClearAllChildren()
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 40)
		textLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextSize = 12
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "⚔ PvP Battles (Phase 3)"
		textLabel.BorderSizePixel = 0
		textLabel.Parent = content

		local infoLabel = Instance.new("TextLabel")
		infoLabel.Size = UDim2.new(1, -10, 0, 100)
		infoLabel.Position = UDim2.new(0, 5, 0, 50)
		infoLabel.BackgroundTransparency = 1
		infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		infoLabel.TextSize = 11
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextWrapped = true
		infoLabel.Text = "PvP system is loading...\n\nChallenge other players and battle their ghosts!"
		infoLabel.Parent = content
	end

	-- Create and initialize client
	local client = GameClient:new()
	client:initialize()

	return client

	-- Built with assistance from Claude Code by Anthropic.
