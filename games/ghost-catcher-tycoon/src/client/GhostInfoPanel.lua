--
-- Ghost Info Panel — Ghost Catcher Tycoon
-- Shows ghost details and catch success rate when targeting
--

local GhostInfoPanel = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local EquipmentData = require(game.ServerStorage:WaitForChild("EquipmentData"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local currentTargetGhost = nil
local currentEquipment = nil

-- Create UI Panel
local function createPanel()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GhostInfoPanel"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main container (top-center)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "InfoPanel"
	mainFrame.Size = UDim2.new(0, 400, 0, 180)
	mainFrame.Position = UDim2.new(0.5, -200, 0, 20)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	mainFrame.BorderSizePixel = 1
	mainFrame.BorderColor3 = Color3.fromRGB(100, 150, 255)
	mainFrame.Visible = false
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = mainFrame

	-- Ghost name and rarity
	local ghostNameLabel = Instance.new("TextLabel")
	ghostNameLabel.Name = "GhostName"
	ghostNameLabel.Size = UDim2.new(1, -10, 0, 28)
	ghostNameLabel.Position = UDim2.new(0, 5, 0, 5)
	ghostNameLabel.BackgroundTransparency = 1
	ghostNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ghostNameLabel.TextSize = 18
	ghostNameLabel.Font = Enum.Font.GothamBold
	ghostNameLabel.Text = "???"
	ghostNameLabel.Parent = mainFrame

	-- Rarity stars
	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Name = "Rarity"
	rarityLabel.Size = UDim2.new(1, -10, 0, 18)
	rarityLabel.Position = UDim2.new(0, 5, 0, 32)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
	rarityLabel.TextSize = 12
	rarityLabel.Font = Enum.Font.Gotham
	rarityLabel.Text = "★ Common"
	rarityLabel.Parent = mainFrame

	-- Success rate with current equipment
	local successRateLabel = Instance.new("TextLabel")
	successRateLabel.Name = "SuccessRate"
	successRateLabel.Size = UDim2.new(1, -10, 0, 20)
	successRateLabel.Position = UDim2.new(0, 5, 0, 52)
	successRateLabel.BackgroundTransparency = 1
	successRateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	successRateLabel.TextSize = 14
	successRateLabel.Font = Enum.Font.GothamBold
	successRateLabel.Text = "With Current Equipment: —%"
	successRateLabel.Parent = mainFrame

	-- Rewards preview
	local rewardsLabel = Instance.new("TextLabel")
	rewardsLabel.Name = "Rewards"
	rewardsLabel.Size = UDim2.new(1, -10, 0, 18)
	rewardsLabel.Position = UDim2.new(0, 5, 0, 75)
	rewardsLabel.BackgroundTransparency = 1
	rewardsLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	rewardsLabel.TextSize = 12
	rewardsLabel.Font = Enum.Font.Gotham
	rewardsLabel.Text = "Rewards if caught:"
	rewardsLabel.Parent = mainFrame

	-- Rewards details
	local rewardsDetailsLabel = Instance.new("TextLabel")
	rewardsDetailsLabel.Name = "RewardsDetails"
	rewardsDetailsLabel.Size = UDim2.new(1, -10, 0, 16)
	rewardsDetailsLabel.Position = UDim2.new(0, 5, 0, 95)
	rewardsDetailsLabel.BackgroundTransparency = 1
	rewardsDetailsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	rewardsDetailsLabel.TextSize = 11
	rewardsDetailsLabel.Font = Enum.Font.Gotham
	rewardsDetailsLabel.Text = "+ 100 XP | + 250 Coins"
	rewardsDetailsLabel.Parent = mainFrame

	-- Catch hint
	local catchHintLabel = Instance.new("TextLabel")
	catchHintLabel.Name = "CatchHint"
	catchHintLabel.Size = UDim2.new(1, -10, 0, 20)
	catchHintLabel.Position = UDim2.new(0, 5, 1, -25)
	catchHintLabel.BackgroundColor3 = Color3.fromRGB(30, 60, 100)
	catchHintLabel.BorderSizePixel = 0
	catchHintLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	catchHintLabel.TextSize = 12
	catchHintLabel.Font = Enum.Font.GothamBold
	catchHintLabel.Text = "Press [E] to catch"
	catchHintLabel.Parent = mainFrame

	return {
		screenGui = screenGui,
		mainFrame = mainFrame,
		ghostNameLabel = ghostNameLabel,
		rarityLabel = rarityLabel,
		successRateLabel = successRateLabel,
		rewardsLabel = rewardsLabel,
		rewardsDetailsLabel = rewardsDetailsLabel,
		catchHintLabel = catchHintLabel
	}
end

local ui = createPanel()

-- Get rarity stars
local function getRarityStars(rarity)
	local starMap = {
		Common = "★",
		Uncommon = "★★",
		Rare = "★★★",
		Epic = "★★★★",
		Legendary = "★★★★★",
		Corrupted = "★★★★★✦"
	}
	return starMap[rarity] or "★"
end

-- Get rarity color
local function getRarityColor(rarity)
	local colorMap = {
		Common = Color3.fromRGB(128, 128, 128),
		Uncommon = Color3.fromRGB(0, 150, 255),
		Rare = Color3.fromRGB(255, 200, 0),
		Epic = Color3.fromRGB(255, 100, 0),
		Legendary = Color3.fromRGB(255, 50, 50),
		Corrupted = Color3.fromRGB(200, 50, 255)
	}
	return colorMap[rarity] or Color3.fromRGB(200, 200, 200)
end

-- Update ghost info display
local function updateGhostInfo(ghostName, rarity, rewards)
	if not ghostName or ghostName == "" then
		ui.mainFrame.Visible = false
		return
	end

	ui.ghostNameLabel.Text = ghostName

	local stars = getRarityStars(rarity)
	local rarityColor = getRarityColor(rarity)
	ui.rarityLabel.Text = stars .. " " .. rarity
	ui.rarityLabel.TextColor3 = rarityColor
	ui.mainFrame.BorderColor3 = rarityColor

	-- Calculate success rate with current equipment
	if currentEquipment then
		local catchRate = EquipmentData:getCatchRate(currentEquipment, rarity)
		if catchRate and catchRate > 0 then
			ui.successRateLabel.Text = string.format("With Current Equipment: %d%% success rate", catchRate)

			-- Color based on success chance
			if catchRate >= 80 then
				ui.successRateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			elseif catchRate >= 50 then
				ui.successRateLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
			else
				ui.successRateLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
			end
		else
			ui.successRateLabel.Text = "With Current Equipment: Cannot catch"
			ui.successRateLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		end
	else
		ui.successRateLabel.Text = "With Current Equipment: —%"
		ui.successRateLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	end

	-- Update rewards
	if rewards then
		ui.rewardsDetailsLabel.Text = rewards
	else
		ui.rewardsDetailsLabel.Text = "+ 100 XP | + 250 Coins"
	end

	ui.mainFrame.Visible = true
	currentTargetGhost = ghostName
end

-- Raycasting to detect ghost targeting
local function updateTargeting()
	local camera = workspace.CurrentCamera
	local ray = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector * 1000)

	local part, hitPos = workspace:FindPartOnRay(ray, player.Character)

	if part and part.Parent then
		local ghostModel = part.Parent
		local body = ghostModel:FindFirstChild("Body")

		if body then
			local ghostRarity = body:GetAttribute("Rarity") or "Common"
			updateGhostInfo(ghostModel.Name, ghostRarity)
			return
		end
	end

	-- No ghost targeted
	ui.mainFrame.Visible = false
end

-- Update on every frame
RunService.RenderStepped:Connect(function()
	if player.Character then
		updateTargeting()
	end
end)

-- Listen for equipment changes
local function setupNetworking()
	local signal = Instance.new("RemoteFunction")
	signal.Name = "GhostInfoSignal"
	signal.Parent = game.ReplicatedStorage

	signal.OnClientInvoke = function(eventType, data)
		if eventType == "EquipmentChanged" then
			currentEquipment = data.name
		end
	end
end

setupNetworking()

return GhostInfoPanel
