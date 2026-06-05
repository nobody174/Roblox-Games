--
-- Ghost Catcher Tycoon - Chat UI Module
-- Provides in-game chat input box for admin commands
-- Features: Command parsing, history display, real-time feedback
--

local ChatUI = {}
ChatUI.__index = ChatUI

local TweenService = game:GetService("TweenService")

function ChatUI:new()
	local self = setmetatable({}, ChatUI)
	self.inputBox = nil
	self.historyPanel = nil
	self.historyMessages = {} -- Stores last 20 messages
	self.adminRemote = nil
	self.showNotificationCallback = nil
	self.isAdmin = false
	return self
end

function ChatUI:initialize(gameClient, screenGui, chatTabContent)
	self.adminRemote = gameClient.remotes.AdminCommand
	self.showNotificationCallback = function(msg, color)
		gameClient:showNotification(msg, color)
	end

	-- Create input box (at top-left, below stat panel)
	local inputBox = Instance.new("TextBox")
	inputBox.Name = "ChatInputBox"
	inputBox.Size = UDim2.new(0, 300, 0, 35)
	inputBox.Position = UDim2.new(0, 10, 0, 100)
	inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.TextSize = 12
	inputBox.Font = Enum.Font.Gotham
	inputBox.PlaceholderText = "Type / commands here..."
	inputBox.BorderSizePixel = 1
	inputBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
	inputBox.Parent = screenGui

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 6)
	inputCorner.Parent = inputBox

	self.inputBox = inputBox

	-- Create history panel (below input, toggled via Chat tab)
	local historyPanel = Instance.new("ScrollingFrame")
	historyPanel.Name = "ChatHistoryPanel"
	historyPanel.Size = UDim2.new(0, 300, 0, 200)
	historyPanel.Position = UDim2.new(0, 10, 0, 140)
	historyPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	historyPanel.ScrollBarThickness = 6
	historyPanel.CanvasSize = UDim2.new(1, 0, 0, 400)
	historyPanel.Visible = false
	historyPanel.Parent = screenGui

	local historyCorner = Instance.new("UICorner")
	historyCorner.CornerRadius = UDim.new(0, 6)
	historyCorner.Parent = historyPanel

	local historyLayout = Instance.new("UIListLayout")
	historyLayout.FillDirection = Enum.FillDirection.Vertical
	historyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	historyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	historyLayout.Padding = UDim.new(0, 4)
	historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	historyLayout.Parent = historyPanel

	self.historyPanel = historyPanel

	-- Setup input handler
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local commandText = inputBox.Text:match("^%s*(.-)%s*$") -- Trim whitespace

			if commandText and commandText ~= "" then
				self:executeCommand(commandText)
				inputBox.Text = ""
			end
		end
	end)

	-- Display initial help message
	self:addMessage("Type / commands. /help for list.", Color3.fromRGB(150, 150, 150))
end

function ChatUI:executeCommand(commandText)
	if not self.adminRemote then
		self:addMessage("Admin system not ready", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Parse command: "/coin" or "/coin arg"
	local parts = {}
	for part in commandText:gmatch("%S+") do
		table.insert(parts, part)
	end

	if #parts == 0 then return end

	local command = parts[1]:lower():sub(2) -- Remove leading /
	local arg = parts[2] or ""

	-- Validate permission (admin check)
	if command ~= "help" then
		-- For now, assume player is admin if sending command
		-- In production, check against server admin list
	end

	-- Execute command via remote
	local success, result = pcall(function()
		return self.adminRemote:InvokeServer(command, arg)
	end)

	if success and result then
		self:addMessage("✓ " .. command .. " executed", Color3.fromRGB(100, 255, 100))
		if self.showNotificationCallback then
			self.showNotificationCallback("Command: " .. command, Color3.fromRGB(100, 200, 100))
		end
	else
		local errorMsg = result or "Unknown error"
		self:addMessage("✗ " .. command .. " failed: " .. tostring(errorMsg), Color3.fromRGB(255, 100, 100))
		if self.showNotificationCallback then
			self.showNotificationCallback("Error: " .. errorMsg, Color3.fromRGB(255, 150, 100))
		end
	end
end

function ChatUI:addMessage(text, color)
	color = color or Color3.fromRGB(200, 200, 200)

	-- Remove oldest message if we have 20
	if #self.historyMessages >= 20 then
		local oldestLabel = self.historyPanel:FindFirstChild("Message_1")
		if oldestLabel then
			oldestLabel:Destroy()
		end
		table.remove(self.historyMessages, 1)
	end

	-- Create new message label
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message_" .. (#self.historyMessages + 1)
	messageLabel.Size = UDim2.new(1, -10, 0, 25)
	messageLabel.BackgroundTransparency = 1
	messageLabel.TextColor3 = color
	messageLabel.TextSize = 11
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextWrapped = true
	messageLabel.Text = text
	messageLabel.Parent = self.historyPanel

	table.insert(self.historyMessages, messageLabel)

	-- Auto-scroll to bottom
	self.historyPanel.CanvasPosition = Vector2.new(0, self.historyPanel.CanvasSize.Y.Offset)
end

function ChatUI:toggleHistory(visible)
	if visible then
		-- Show with animation
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(self.historyPanel, tweenInfo, { Position = UDim2.new(0, 10, 0, 140) })
		tween:Play()
		self.historyPanel.Visible = true
	else
		-- Hide with animation
		self.historyPanel.Visible = false
	end
end

return ChatUI
-- Built with assistance from Claude Code by Anthropic.
