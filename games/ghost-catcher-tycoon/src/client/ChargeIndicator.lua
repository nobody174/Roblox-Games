--
-- Charge Indicator — Ghost Catcher Tycoon
-- Shows progress bar while charging catch attempt
--

local ChargeIndicator = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isCharging = false
local chargeProgress = 0
local chargeTime = 0

-- Create UI
local function createUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ChargeIndicator"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main container (center-bottom)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "ChargeContainer"
	mainFrame.Size = UDim2.new(0, 350, 0, 80)
	mainFrame.Position = UDim2.new(0.5, -175, 1, -100)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	mainFrame.BorderSizePixel = 1
	mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
	mainFrame.Visible = false
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = mainFrame

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = "Charging..."
	titleLabel.Parent = mainFrame

	-- Progress percentage
	local percentLabel = Instance.new("TextLabel")
	percentLabel.Name = "Percent"
	percentLabel.Size = UDim2.new(0.3, -5, 0, 15)
	percentLabel.Position = UDim2.new(0.7, 0, 0, 7)
	percentLabel.BackgroundTransparency = 1
	percentLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	percentLabel.TextSize = 11
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.Text = "0%"
	percentLabel.Parent = mainFrame

	-- Progress bar background
	local barBackground = Instance.new("Frame")
	barBackground.Name = "BarBackground"
	barBackground.Size = UDim2.new(1, -10, 0, 12)
	barBackground.Position = UDim2.new(0, 5, 0, 28)
	barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	barBackground.BorderSizePixel = 0
	barBackground.Parent = mainFrame

	-- Progress bar fill
	local barFill = Instance.new("Frame")
	barFill.Name = "BarFill"
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	barFill.BorderSizePixel = 0
	barFill.Parent = barBackground

	-- Progress bar visual (char blocks)
	local blockLabel = Instance.new("TextLabel")
	blockLabel.Name = "BlockVisual"
	blockLabel.Size = UDim2.new(1, -10, 0, 15)
	blockLabel.Position = UDim2.new(0, 5, 0, 43)
	blockLabel.BackgroundTransparency = 1
	blockLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	blockLabel.TextSize = 12
	blockLabel.Font = Enum.Font.GothamMonospace
	blockLabel.Text = "░░░░░░░░░░"
	blockLabel.Parent = mainFrame

	-- Time remaining label
	local timeLabel = Instance.new("TextLabel")
	timeLabel.Name = "TimeLabel"
	timeLabel.Size = UDim2.new(1, -10, 0, 12)
	timeLabel.Position = UDim2.new(0, 5, 1, -17)
	timeLabel.BackgroundTransparency = 1
	timeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	timeLabel.TextSize = 10
	timeLabel.Font = Enum.Font.Gotham
	timeLabel.Text = "0.0 seconds"
	timeLabel.Parent = mainFrame

	return {
		screenGui = screenGui,
		mainFrame = mainFrame,
		barFill = barFill,
		percentLabel = percentLabel,
		blockLabel = blockLabel,
		timeLabel = timeLabel
	}
end

local ui = createUI()

-- Update progress bar visuals
local function updateProgressBar(percent, seconds)
	percent = math.clamp(percent, 0, 100)

	-- Update percentage text
	ui.percentLabel.Text = string.format("%d%%", math.floor(percent))

	-- Update bar fill
	ui.barFill.Size = UDim2.new(percent / 100, 0, 1, 0)

	-- Update color based on progress
	if percent < 33 then
		ui.barFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	elseif percent < 66 then
		ui.barFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
	else
		ui.barFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	end

	-- Update block visual
	local filledBlocks = math.floor((percent / 100) * 10)
	local emptyBlocks = 10 - filledBlocks
	ui.blockLabel.Text = string.rep("▓", filledBlocks) .. string.rep("░", emptyBlocks)

	-- Update time label
	ui.timeLabel.Text = string.format("%.1f seconds", seconds)
end

-- Start charging
function ChargeIndicator:startCharge(maxChargeTime)
	isCharging = true
	chargeProgress = 0
	chargeTime = maxChargeTime or 3
	ui.mainFrame.Visible = true
	updateProgressBar(0, chargeTime)
end

-- Stop charging and return progress
function ChargeIndicator:stopCharge()
	isCharging = false
	ui.mainFrame.Visible = false
	local result = chargeProgress
	chargeProgress = 0
	return result
end

-- Update charging on frame
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
	if isCharging then
		chargeProgress = chargeProgress + (deltaTime / chargeTime)
		chargeProgress = math.min(chargeProgress, 1)

		local percent = chargeProgress * 100
		local timeRemaining = chargeTime * (1 - chargeProgress)

		updateProgressBar(percent, timeRemaining)

		-- Auto-release at 100%
		if chargeProgress >= 1 then
			ChargeIndicator:stopCharge()
		end
	end
end)

-- Keyboard input for manual charge control
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	-- Start charge on E key (or other input method)
	if input.KeyCode == Enum.KeyCode.E then
		ChargeIndicator:startCharge(3)
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.E then
		if isCharging then
			ChargeIndicator:stopCharge()
		end
	end
end)

return ChargeIndicator
