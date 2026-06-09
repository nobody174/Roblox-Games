--
-- Catch Feedback — Ghost Catcher Tycoon
-- Shows success/failure/error notifications
--

local CatchFeedback = {}
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local notificationQueue = {}
local isShowingNotification = false

-- Create notification UI
local function createNotificationUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CatchFeedback"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main notification frame
	local notifFrame = Instance.new("Frame")
	notifFrame.Name = "NotificationFrame"
	notifFrame.Size = UDim2.new(0, 0, 0, 0)
	notifFrame.Position = UDim2.new(0.5, 0, 0, 60)
	notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	notifFrame.BorderSizePixel = 1
	notifFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
	notifFrame.Visible = false
	notifFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notifFrame

	-- Icon/Emoji label
	local iconLabel = Instance.new("TextLabel")
	iconLabel.Name = "Icon"
	iconLabel.Size = UDim2.new(0, 40, 1, 0)
	iconLabel.Position = UDim2.new(0, 5, 0, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.TextSize = 24
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.Text = "✓"
	iconLabel.Parent = notifFrame

	-- Message label
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -50, 1, 0)
	messageLabel.Position = UDim2.new(0, 45, 0, 0)
	messageLabel.BackgroundTransparency = 1
	messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	messageLabel.TextSize = 14
	messageLabel.Font = Enum.Font.GothamBold
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.Text = "Message"
	messageLabel.Parent = notifFrame

	-- Details label (secondary text)
	local detailsLabel = Instance.new("TextLabel")
	detailsLabel.Name = "Details"
	detailsLabel.Size = UDim2.new(1, -50, 0, 16)
	detailsLabel.Position = UDim2.new(0, 45, 1, -20)
	detailsLabel.BackgroundTransparency = 1
	detailsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	detailsLabel.TextSize = 11
	detailsLabel.Font = Enum.Font.Gotham
	detailsLabel.TextXAlignment = Enum.TextXAlignment.Left
	detailsLabel.Text = ""
	detailsLabel.Parent = notifFrame

	return {
		screenGui = screenGui,
		frame = notifFrame,
		icon = iconLabel,
		message = messageLabel,
		details = detailsLabel
	}
end

local ui = createNotificationUI()

-- Show notification
local function showNotification(type, title, details, duration)
	table.insert(notificationQueue, {
		type = type,
		title = title,
		details = details,
		duration = duration or 3
	})
end

-- Process notification queue
local function processQueue()
	if isShowingNotification or #notificationQueue == 0 then return end

	isShowingNotification = true
	local notif = table.remove(notificationQueue, 1)

	-- Determine colors and icon
	local icon, borderColor, bgColor
	if notif.type == "success" then
		icon = "✅"
		borderColor = Color3.fromRGB(100, 255, 100)
		bgColor = Color3.fromRGB(25, 50, 25)
	elseif notif.type == "failure" then
		icon = "❌"
		borderColor = Color3.fromRGB(255, 100, 100)
		bgColor = Color3.fromRGB(50, 25, 25)
	elseif notif.type == "error" then
		icon = "⚠️"
		borderColor = Color3.fromRGB(255, 200, 100)
		bgColor = Color3.fromRGB(50, 40, 25)
	elseif notif.type == "info" then
		icon = "ℹ️"
		borderColor = Color3.fromRGB(100, 150, 255)
		bgColor = Color3.fromRGB(25, 35, 50)
	end

	-- Update UI
	ui.icon.Text = icon
	ui.message.Text = notif.title
	ui.details.Text = notif.details or ""
	ui.frame.BorderColor3 = borderColor
	ui.frame.BackgroundColor3 = bgColor
	ui.frame.Visible = true

	-- Calculate size based on content
	local messageHeight = 28
	local detailsHeight = (notif.details and notif.details ~= "") and 20 or 0
	local totalHeight = messageHeight + detailsHeight + 10

	-- Animate in
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = tweenService:Create(ui.frame, tweenInfo, {
		Size = UDim2.new(0, 380, 0, totalHeight)
	})
	tween:Play()

	-- Show for duration
	task.wait(notif.duration)

	-- Animate out
	tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	tween = tweenService:Create(ui.frame, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()
	tween.Completed:Connect(function()
		ui.frame.Visible = false
		isShowingNotification = false
		processQueue()
	end)
end

-- Public functions
function CatchFeedback:success(ghostName, xp, coins)
	local title = string.format("CAUGHT! +%d XP +%d Coins", xp or 100, coins or 250)
	local details = "Excellent catch with " .. ghostName .. "!"
	showNotification("success", title, details, 3)
end

function CatchFeedback:failure(reason)
	local title = "ESCAPED! " .. (reason or "Try stronger gear")
	showNotification("failure", title, "", 2.5)
end

function CatchFeedback:error(errorMsg, current, max)
	if errorMsg == "energy" then
		local title = string.format("Not enough energy! %d/%d", current or 0, max or 100)
		showNotification("error", title, "Recharge by catching common ghosts", 2.5)
	elseif errorMsg == "cooldown" then
		local title = "Still charging... wait for reset"
		showNotification("error", title, "", 2)
	else
		showNotification("error", errorMsg or "Error!", "", 2)
	end
end

function CatchFeedback:info(message, details)
	showNotification("info", message, details, 3)
end

-- Process queue on each frame
game:GetService("RunService").RenderStepped:Connect(function()
	if not isShowingNotification and #notificationQueue > 0 then
		processQueue()
	end
end)

-- Listen for catch events from server
local function setupNetworking()
	local signal = Instance.new("RemoteEvent")
	signal.Name = "CatchFeedbackSignal"
	signal.Parent = game.ReplicatedStorage

	signal.OnClientEvent:Connect(function(eventType, data)
		if eventType == "CatchSuccess" then
			CatchFeedback:success(data.ghostName, data.xp, data.coins)
		elseif eventType == "CatchFailure" then
			CatchFeedback:failure(data.reason)
		elseif eventType == "CatchError" then
			if data.type == "energy" then
				CatchFeedback:error("energy", data.current, data.max)
			elseif data.type == "cooldown" then
				CatchFeedback:error("cooldown")
			else
				CatchFeedback:error(data.message)
			end
		elseif eventType == "Info" then
			CatchFeedback:info(data.message, data.details)
		end
	end)
end

setupNetworking()

return CatchFeedback
