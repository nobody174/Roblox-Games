--
-- Ghost Card Builder — Reusable UI Component
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Builds individual ghost inventory cards with rarity-based styling, stats display, and action buttons.
--
local GhostCardBuilder = {}
GhostCardBuilder.__index = GhostCardBuilder

local TweenService = game:GetService("TweenService")
local GhostData = require(game.ReplicatedStorage.shared.GhostData)

local RARITY_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(80, 200, 120),
	Rare = Color3.fromRGB(80, 120, 255),
	Epic = Color3.fromRGB(180, 80, 255),
	Legendary = Color3.fromRGB(255, 200, 50),
	Corrupted = Color3.fromRGB(255, 60, 60),
}

function GhostCardBuilder:new()
	local self = setmetatable({}, GhostCardBuilder)
	return self
end

function GhostCardBuilder:createTemplate()
	local cardTemplate = Instance.new("Frame")
	cardTemplate.Name = "GhostCardTemplate"
	cardTemplate.Size = UDim2.new(0, 200, 0, 240)
	cardTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	cardTemplate.BorderSizePixel = 0
	cardTemplate.Visible = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = cardTemplate

	-- Ghost image display (top section)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "GhostImage"
	imageLabel.Size = UDim2.new(1, -8, 0, 100)
	imageLabel.Position = UDim2.new(0, 4, 0, 4)
	imageLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	imageLabel.BorderSizePixel = 0
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.Parent = cardTemplate

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 6)
	imageCorner.Parent = imageLabel

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -8, 0, 25)
	nameLabel.Position = UDim2.new(0, 4, 0, 108)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = cardTemplate

	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Name = "RarityLabel"
	rarityLabel.Size = UDim2.new(0, 80, 0, 16)
	rarityLabel.Position = UDim2.new(0, 4, 0, 132)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	rarityLabel.TextSize = 11
	rarityLabel.Font = Enum.Font.Gotham
	rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
	rarityLabel.Parent = cardTemplate

	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0, 50, 0, 16)
	levelLabel.Position = UDim2.new(1, -54, 0, 132)
	levelLabel.BackgroundTransparency = 1
	levelLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
	levelLabel.TextSize = 11
	levelLabel.Font = Enum.Font.Gotham
	levelLabel.TextXAlignment = Enum.TextXAlignment.Right
	levelLabel.Parent = cardTemplate

	local energyLabel = Instance.new("TextLabel")
	energyLabel.Name = "EnergyLabel"
	energyLabel.Size = UDim2.new(1, -8, 0, 14)
	energyLabel.Position = UDim2.new(0, 4, 0, 149)
	energyLabel.BackgroundTransparency = 1
	energyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	energyLabel.TextSize = 10
	energyLabel.Font = Enum.Font.Gotham
	energyLabel.TextXAlignment = Enum.TextXAlignment.Left
	energyLabel.Parent = cardTemplate

	local trainButton = Instance.new("TextButton")
	trainButton.Name = "TrainButton"
	trainButton.Size = UDim2.new(0, 90, 0, 24)
	trainButton.Position = UDim2.new(0, 4, 1, -28)
	trainButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
	trainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	trainButton.TextSize = 11
	trainButton.Font = Enum.Font.GothamBold
	trainButton.Text = "🎓 Train"
	trainButton.Parent = cardTemplate

	local trainCorner = Instance.new("UICorner")
	trainCorner.CornerRadius = UDim.new(0, 4)
	trainCorner.Parent = trainButton

	local releaseButton = Instance.new("TextButton")
	releaseButton.Name = "ReleaseButton"
	releaseButton.Size = UDim2.new(0, 90, 0, 24)
	releaseButton.Position = UDim2.new(1, -94, 1, -28)
	releaseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	releaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	releaseButton.TextSize = 11
	releaseButton.Font = Enum.Font.GothamBold
	releaseButton.Text = "❌ Release"
	releaseButton.Parent = cardTemplate

	local releaseCorner = Instance.new("UICorner")
	releaseCorner.CornerRadius = UDim.new(0, 4)
	releaseCorner.Parent = releaseButton

	return cardTemplate
end

function GhostCardBuilder:buildCard(ghostData, parentContainer, callbacks)
	callbacks = callbacks or {}

	local card = Instance.new("Frame")
	card.Name = "GhostCard_" .. (ghostData.inventoryKey or ghostData.id or "unknown")
	card.Size = UDim2.new(0, 220, 0, 120)
	card.BackgroundColor3 = RARITY_COLORS[ghostData.rarity] or Color3.fromRGB(100, 100, 100)
	card.BorderSizePixel = 0
	card.Parent = parentContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = card

	-- Ghost image (left side)
	local ghostImage = Instance.new("ImageLabel")
	ghostImage.Name = "GhostImage"
	ghostImage.Size = UDim2.new(0, 80, 0, 80)
	ghostImage.Position = UDim2.new(0, 8, 0, 8)
	ghostImage.BackgroundTransparency = 1
	ghostImage.ScaleType = Enum.ScaleType.Fit
	local assetId = GhostData.GhostImages[ghostData.name or ""]
	print("[GhostCardBuilder] Ghost: " .. (ghostData.name or "nil") .. " | AssetID: " .. tostring(assetId))
	if assetId and assetId ~= 0 then
		ghostImage.Image = "rbxassetid://" .. assetId
	else
		ghostImage.Image = GhostData.DEFAULT_IMAGE
	end
	ghostImage.Parent = card

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 6)
	imageCorner.Parent = ghostImage

	-- Dark background for text readability
	local textBg = Instance.new("Frame")
	textBg.Name = "TextBackground"
	textBg.Size = UDim2.new(1, -100, 0, 60)
	textBg.Position = UDim2.new(0, 96, 0, 4)
	textBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	textBg.BorderSizePixel = 0
	textBg.Parent = card

	local textBgCorner = Instance.new("UICorner")
	textBgCorner.CornerRadius = UDim.new(0, 4)
	textBgCorner.Parent = textBg

	-- Text content (right of image)
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -100, 0, 25)
	nameLabel.Position = UDim2.new(0, 96, 0, 4)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 15
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextWrapped = true
	nameLabel.Text = ghostData.name or "Unknown Ghost"
	nameLabel.Parent = card

	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Name = "RarityLabel"
	rarityLabel.Size = UDim2.new(1, -100, 0, 16)
	rarityLabel.Position = UDim2.new(0, 96, 0, 28)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	rarityLabel.TextSize = 13
	rarityLabel.Font = Enum.Font.Gotham
	rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
	rarityLabel.Text = ghostData.rarity or "Common"
	rarityLabel.Parent = card

	local levelLabel = Instance.new("TextLabel")
	levelLabel.Name = "LevelLabel"
	levelLabel.Size = UDim2.new(0, 50, 0, 16)
	levelLabel.Position = UDim2.new(1, -54, 0, 28)
	levelLabel.BackgroundTransparency = 1
	levelLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
	levelLabel.TextSize = 13
	levelLabel.Font = Enum.Font.Gotham
	levelLabel.TextXAlignment = Enum.TextXAlignment.Right
	levelLabel.Text = "Lv. " .. (ghostData.level or 1)
	levelLabel.Parent = card

	local energyLabel = Instance.new("TextLabel")
	energyLabel.Name = "EnergyLabel"
	energyLabel.Size = UDim2.new(1, -100, 0, 14)
	energyLabel.Position = UDim2.new(0, 96, 0, 45)
	energyLabel.BackgroundTransparency = 1
	energyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	energyLabel.TextSize = 12
	energyLabel.Font = Enum.Font.Gotham
	energyLabel.TextXAlignment = Enum.TextXAlignment.Left
	energyLabel.Text = "⚡ +" .. math.floor(ghostData.energyPerSec or 0) .. "/sec"
	energyLabel.Parent = card

	-- Calculate training cost based on current level
	local trainCost = math.floor((ghostData.level or 1) * 75)

	local trainButton = Instance.new("TextButton")
	trainButton.Name = "TrainButton"
	trainButton.Size = UDim2.new(0, 90, 0, 38)
	trainButton.Position = UDim2.new(0, 4, 1, -38)
	trainButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
	trainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	trainButton.TextSize = 10
	trainButton.Font = Enum.Font.GothamBold
	trainButton.Text = "🎓 Train"
	trainButton.Parent = card

	local trainCorner = Instance.new("UICorner")
	trainCorner.CornerRadius = UDim.new(0, 4)
	trainCorner.Parent = trainButton

	-- Cost label below train button
	local costLabel = Instance.new("TextLabel")
	costLabel.Name = "CostLabel"
	costLabel.Size = UDim2.new(0, 90, 0, 14)
	costLabel.Position = UDim2.new(0, 4, 1, -14)
	costLabel.BackgroundTransparency = 1
	costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	costLabel.TextSize = 8
	costLabel.Font = Enum.Font.Gotham
	costLabel.TextXAlignment = Enum.TextXAlignment.Center
	costLabel.Text = "💰 " .. trainCost
	costLabel.Parent = card

	trainButton.MouseEnter:Connect(function()
		trainButton.BackgroundColor3 = Color3.fromRGB(140, 70, 220)
	end)
	trainButton.MouseLeave:Connect(function()
		trainButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
	end)

	trainButton.MouseButton1Click:Connect(function()
		if callbacks.onTrain then
			callbacks.onTrain(ghostData)
		end
	end)

	local releaseButton = Instance.new("TextButton")
	releaseButton.Name = "ReleaseButton"
	releaseButton.Size = UDim2.new(0, 90, 0, 24)
	releaseButton.Position = UDim2.new(1, -94, 1, -28)
	releaseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	releaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	releaseButton.TextSize = 11
	releaseButton.Font = Enum.Font.GothamBold
	releaseButton.Text = "❌ Release"
	releaseButton.Parent = card

	local releaseCorner = Instance.new("UICorner")
	releaseCorner.CornerRadius = UDim.new(0, 4)
	releaseCorner.Parent = releaseButton

	releaseButton.MouseEnter:Connect(function()
		releaseButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
	end)
	releaseButton.MouseLeave:Connect(function()
		releaseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end)

	releaseButton.MouseButton1Click:Connect(function()
		if callbacks.onRelease then
			callbacks.onRelease(ghostData)
		end
	end)

	card.BackgroundTransparency = 1
	local fadeInTween = TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundTransparency = 0 })
	fadeInTween:Play()

	card.MouseEnter:Connect(function()
		local hoverTween = TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 230, 0, 130) })
		hoverTween:Play()
	end)

	card.MouseLeave:Connect(function()
		local resetTween = TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 220, 0, 120) })
		resetTween:Play()
	end)

	return card
end

return GhostCardBuilder

-- Built with assistance from Claude Code by Anthropic.
