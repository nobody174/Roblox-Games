--
-- Ghost Catcher Tycoon - Habitat UI Module
-- Displays player's ghost collection with filtering, details, and customization
-- Author: Claude Code
-- Date: 2026-06-06
--

local HabitatUI = {}
HabitatUI.__index = HabitatUI

function HabitatUI:new()
	local self = setmetatable({}, HabitatUI)
	self.habitatFrame = nil
	self.ghostCards = {}
	self.activeFilter = "All"
	self.habitatRemote = nil
	self.updateUICallback = nil
	self.showNotificationCallback = nil
	return self
end

function HabitatUI:initialize(gameClient, screenGui)
	self.habitatRemote = gameClient.remotes.Habitat
	self.updateUICallback = function(msg, color)
		gameClient:showNotification(msg, color)
	end
	self.showNotificationCallback = self.updateUICallback

	-- Create main habitat frame
	self.habitatFrame = Instance.new("Frame")
	self.habitatFrame.Name = "HabitatUI"
	self.habitatFrame.Size = UDim2.new(1, 0, 1, 0)
	self.habitatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	self.habitatFrame.BorderSizePixel = 0
	self.habitatFrame.Parent = screenGui
	self.habitatFrame.Visible = false

	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	header.BorderSizePixel = 0
	header.Parent = self.habitatFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 24
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = "🏠 HABITAT"
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	-- Stats (right side of header)
	local statsFrame = Instance.new("Frame")
	statsFrame.Name = "Stats"
	statsFrame.Size = UDim2.new(0.6, -20, 1, 0)
	statsFrame.Position = UDim2.new(0.4, 10, 0, 0)
	statsFrame.BackgroundTransparency = 1
	statsFrame.Parent = header

	local ghostCountLabel = Instance.new("TextLabel")
	ghostCountLabel.Name = "GhostCount"
	ghostCountLabel.Size = UDim2.new(0.5, 0, 1, 0)
	ghostCountLabel.BackgroundTransparency = 1
	ghostCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	ghostCountLabel.TextSize = 12
	ghostCountLabel.Font = Enum.Font.Gotham
	ghostCountLabel.Text = "Ghosts: 0/50"
	ghostCountLabel.TextXAlignment = Enum.TextXAlignment.Left
	ghostCountLabel.Parent = statsFrame

	local incomeLabel = Instance.new("TextLabel")
	incomeLabel.Name = "Income"
	incomeLabel.Size = UDim2.new(0.5, 0, 1, 0)
	incomeLabel.Position = UDim2.new(0.5, 0, 0, 0)
	incomeLabel.BackgroundTransparency = 1
	incomeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	incomeLabel.TextSize = 12
	incomeLabel.Font = Enum.Font.Gotham
	incomeLabel.Text = "Income: 0.0/sec"
	incomeLabel.TextXAlignment = Enum.TextXAlignment.Right
	incomeLabel.Parent = statsFrame

	-- Filter bar
	local filterBar = Instance.new("Frame")
	filterBar.Name = "FilterBar"
	filterBar.Size = UDim2.new(1, 0, 0, 50)
	filterBar.Position = UDim2.new(0, 0, 0, 60)
	filterBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	filterBar.BorderSizePixel = 0
	filterBar.Parent = self.habitatFrame

	local filters = { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Corrupted" }
	for i, filterName in ipairs(filters) do
		local button = Instance.new("TextButton")
		button.Name = filterName .. "Filter"
		button.Size = UDim2.new(0, 100, 0, 35)
		button.Position = UDim2.new(0, 10 + (i - 1) * 110, 0.5, -17)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextSize = 11
		button.Font = Enum.Font.Gotham
		button.Text = filterName
		button.BorderSizePixel = 0
		button.Parent = filterBar

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = button

		button.MouseButton1Click:Connect(function()
			self:setFilter(filterName)
		end)
	end

	-- Scrolling ghost grid
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "GhostGrid"
	scrollFrame.Size = UDim2.new(1, 0, 1, -110)
	scrollFrame.Position = UDim2.new(0, 0, 0, 110)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 12
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = self.habitatFrame

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 120, 0, 140)
	gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	gridLayout.FillDirection = Enum.FillDirection.Horizontal
	gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	gridLayout.Parent = scrollFrame

	-- Store references
	self.titleLabel = titleLabel
	self.ghostCountLabel = ghostCountLabel
	self.incomeLabel = incomeLabel
	self.scrollFrame = scrollFrame
	self.gridLayout = gridLayout
	self.filterBar = filterBar

	print("[HabitatUI] Initialized successfully")
end

function HabitatUI:show()
	if self.habitatFrame then
		self.habitatFrame.Visible = true
		print("[HabitatUI] Shown")
	end
end

function HabitatUI:hide()
	if self.habitatFrame then
		self.habitatFrame.Visible = false
		print("[HabitatUI] Hidden")
	end
end

function HabitatUI:setFilter(filterName)
	self.activeFilter = filterName
	self:refreshGhostList()
	print("[HabitatUI] Filter set to: " .. filterName)
end

function HabitatUI:refreshGhostList(habitatData)
	if not self.scrollFrame then return end

	-- Clear existing cards
	for _, card in ipairs(self.ghostCards) do
		card:Destroy()
	end
	self.ghostCards = {}

	if not habitatData or not habitatData.ghosts then
		return
	end

	-- Convert table to array and filter
	local ghostArray = {}
	for ghostKey, ghostData in pairs(habitatData.ghosts) do
		table.insert(ghostArray, {
			key = ghostKey,
			name = ghostData.name,
			rarity = ghostData.rarity,
			level = ghostData.level,
			energyOutput = ghostData.energyOutput,
		})
	end

	-- Filter by rarity
	local filtered = ghostArray
	if self.activeFilter ~= "All" then
		filtered = {}
		for _, ghost in ipairs(ghostArray) do
			if ghost.rarity == self.activeFilter then
				table.insert(filtered, ghost)
			end
		end
	end

	-- Sort by rarity value
	local rarityOrder = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Corrupted = 6 }
	table.sort(filtered, function(a, b)
		return (rarityOrder[a.rarity] or 0) < (rarityOrder[b.rarity] or 0)
	end)

	-- Create cards
	for _, ghostData in ipairs(filtered) do
		self:createGhostCard(ghostData)
	end

	-- Update stats
	if habitatData then
		self.ghostCountLabel.Text = "Ghosts: " .. #ghostArray .. "/" .. (habitatData.maxSlots or 50)
		self.incomeLabel.Text = "Income: " .. string.format("%.1f", self:calculateTotalIncome(habitatData)) .. "/sec"
	end

	-- Update canvas size
	local cardCount = #self.ghostCards
	local rows = math.ceil(cardCount / 8)
	local canvasHeight = rows * 150 + 20
	self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

	print("[HabitatUI] Refreshed with " .. #filtered .. " ghosts")
end

function HabitatUI:createGhostCard(ghostData)
	local card = Instance.new("Frame")
	card.Name = ghostData.name
	card.Size = UDim2.new(0, 110, 0, 130)
	card.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	card.BorderSizePixel = 0
	card.Parent = self.scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = card

	-- Ghost name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(1, -10, 0, 25)
	nameLabel.Position = UDim2.new(0, 5, 0, 5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 10
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = ghostData.name
	nameLabel.TextWrapped = true
	nameLabel.Parent = card

	-- Ghost image placeholder
	local imagePlaceholder = Instance.new("Frame")
	imagePlaceholder.Name = "Image"
	imagePlaceholder.Size = UDim2.new(0, 60, 0, 60)
	imagePlaceholder.Position = UDim2.new(0.5, -30, 0, 30)
	imagePlaceholder.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
	imagePlaceholder.BorderSizePixel = 0
	imagePlaceholder.Parent = card

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 4)
	imageCorner.Parent = imagePlaceholder

	local ghostEmoji = Instance.new("TextLabel")
	ghostEmoji.Size = UDim2.new(1, 0, 1, 0)
	ghostEmoji.BackgroundTransparency = 1
	ghostEmoji.TextColor3 = Color3.fromRGB(255, 255, 255)
	ghostEmoji.TextSize = 30
	ghostEmoji.Font = Enum.Font.GothamBold
	ghostEmoji.Text = "👻"
	ghostEmoji.Parent = imagePlaceholder

	-- Level and energy
	local statsLabel = Instance.new("TextLabel")
	statsLabel.Name = "Stats"
	statsLabel.Size = UDim2.new(1, -10, 0, 18)
	statsLabel.Position = UDim2.new(0, 5, 0, 95)
	statsLabel.BackgroundTransparency = 1
	statsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	statsLabel.TextSize = 9
	statsLabel.Font = Enum.Font.Gotham
	statsLabel.Text = "Lv " .. ghostData.level .. " | " .. string.format("%.1f", ghostData.energyOutput) .. "/s"
	statsLabel.Parent = card

	-- Click handler
	card.MouseButton1Click = Instance.new("Signal")
	card.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:showGhostDetails(ghostData)
		end
	end)

	table.insert(self.ghostCards, card)
end

function HabitatUI:showGhostDetails(ghostData)
	-- Create detail panel
	local detailPanel = Instance.new("Frame")
	detailPanel.Name = "GhostDetails"
	detailPanel.Size = UDim2.new(0, 300, 0, 400)
	detailPanel.Position = UDim2.new(0.5, -150, 0.5, -200)
	detailPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	detailPanel.BorderSizePixel = 0
	detailPanel.Parent = self.habitatFrame
	detailPanel.ZIndex = 10

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = detailPanel

	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	title.BorderSizePixel = 0
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.Font = Enum.Font.GothamBold
	title.Text = "👻 " .. ghostData.name
	title.Parent = detailPanel

	-- Content
	local contentLabel = Instance.new("TextLabel")
	contentLabel.Size = UDim2.new(1, -20, 1, -100)
	contentLabel.Position = UDim2.new(0, 10, 0, 50)
	contentLabel.BackgroundTransparency = 1
	contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	contentLabel.TextSize = 12
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextYAlignment = Enum.TextYAlignment.Top
	contentLabel.TextWrapped = true
	contentLabel.Text = string.format(
		"Level: %d/10\nRarity: %s\nEnergy Output: %.1f/sec\n\nThis ghost generates passive income while in your habitat.",
		ghostData.level,
		ghostData.rarity,
		ghostData.energyOutput
	)
	contentLabel.Parent = detailPanel

	-- Buttons
	local releaseBtn = Instance.new("TextButton")
	releaseBtn.Name = "ReleaseBtn"
	releaseBtn.Size = UDim2.new(0.45, 0, 0, 35)
	releaseBtn.Position = UDim2.new(0, 10, 1, -45)
	releaseBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
	releaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	releaseBtn.TextSize = 11
	releaseBtn.Font = Enum.Font.GothamBold
	releaseBtn.Text = "Release"
	releaseBtn.Parent = detailPanel

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseBtn"
	closeBtn.Size = UDim2.new(0.45, 0, 0, 35)
	closeBtn.Position = UDim2.new(0.55, 0, 1, -45)
	closeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize = 11
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Text = "Close"
	closeBtn.Parent = detailPanel

	releaseBtn.MouseButton1Click:Connect(function()
		self:onReleaseGhost(ghostData)
		detailPanel:Destroy()
	end)

	closeBtn.MouseButton1Click:Connect(function()
		detailPanel:Destroy()
	end)

	print("[HabitatUI] Showed details for: " .. ghostData.name)
end

function HabitatUI:onReleaseGhost(ghostData)
	if self.habitatRemote then
		local success, result = pcall(function()
			return self.habitatRemote:InvokeServer("ReleaseGhost", ghostData.key)
		end)

		if success and result then
			self:showNotificationCallback("✓ Released " .. ghostData.name, Color3.fromRGB(100, 255, 100))
			print("[HabitatUI] Released ghost: " .. ghostData.name)
		else
			self:showNotificationCallback("✗ Failed to release ghost", Color3.fromRGB(255, 100, 100))
		end
	end
end

function HabitatUI:calculateTotalIncome(habitatData)
	if not habitatData or not habitatData.ghosts then
		return 0
	end

	local totalIncome = 0
	for _, ghost in pairs(habitatData.ghosts) do
		totalIncome = totalIncome + (ghost.energyOutput or 0)
	end
	return totalIncome
end

return HabitatUI
-- Built with assistance from Claude Code by Anthropic.
