--
-- Ghost Catcher Tycoon - Admin Log UI
-- Displays admin command feedback in top-right corner
-- Only visible to admins
--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create admin log UI (top-right corner)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminLog"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local logFrame = Instance.new("Frame")
logFrame.Name = "LogFrame"
logFrame.Size = UDim2.new(0, 250, 0, 140)
logFrame.Position = UDim2.new(1, -260, 0, 85)
logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
logFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
logFrame.BorderSizePixel = 1
logFrame.Parent = screenGui

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleLabel.BorderSizePixel = 0
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Admin Log"
titleLabel.Parent = logFrame

-- Message list
local messageList = Instance.new("ScrollingFrame")
messageList.Name = "Messages"
messageList.Size = UDim2.new(1, 0, 1, -30)
messageList.Position = UDim2.new(0, 0, 0, 25)
messageList.BackgroundTransparency = 1
messageList.BorderSizePixel = 0
messageList.ScrollBarThickness = 6
messageList.CanvasSize = UDim2.new(0, 0, 0, 0)
messageList.Parent = logFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 2)
layout.Parent = messageList

local messageHistory = {}
local maxMessages = 10

-- Listen for admin log messages from server
local adminLogRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AdminLog", 5)

if adminLogRemote then
	adminLogRemote.OnClientEvent:Connect(function(message)
		-- Add message to list
		local msgLabel = Instance.new("TextLabel")
		msgLabel.Name = "Message"
		msgLabel.Size = UDim2.new(1, -5, 0, 20)
		msgLabel.BackgroundTransparency = 1
		msgLabel.TextColor3 = message:sub(1, 1) == "✓" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
		msgLabel.TextSize = 11
		msgLabel.Font = Enum.Font.Gotham
		msgLabel.Text = message
		msgLabel.TextXAlignment = Enum.TextXAlignment.Left
		msgLabel.TextWrapped = true
		msgLabel.Parent = messageList

		table.insert(messageHistory, msgLabel)

		-- Remove oldest if over max
		if #messageHistory > maxMessages then
			local old = table.remove(messageHistory, 1)
			old:Destroy()
		end

		-- Update canvas size
		task.wait(0.01)
		local contentSize = layout.AbsoluteContentSize.Y
		messageList.CanvasSize = UDim2.new(0, 0, 0, contentSize)
		messageList.CanvasPosition = Vector2.new(0, messageList.CanvasSize.Y.Offset)
	end)
else
	print("[AdminLog] AdminLog remote not found - admin feedback disabled")
end

print("[AdminLog] Admin log UI loaded (top-right corner)")
