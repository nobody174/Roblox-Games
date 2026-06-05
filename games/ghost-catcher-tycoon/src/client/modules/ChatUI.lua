--
-- Ghost Catcher Tycoon - Chat UI Module
-- Provides in-game chat input box for admin commands
-- Feedback via notification popups (not history panel)
--

local ChatUI = {}
ChatUI.__index = ChatUI

function ChatUI:new()
	local self = setmetatable({}, ChatUI)
	self.inputBox = nil
	self.adminRemote = nil
	self.showNotificationCallback = nil
	return self
end

function ChatUI:initialize(gameClient, screenGui, chatTabContent)
	self.adminRemote = gameClient.remotes.AdminCommand
	self.showNotificationCallback = function(msg, color)
		gameClient:showNotification(msg, color)
	end

	-- Create input box (always visible at top-left, below stat panel)
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

	-- Setup input handler
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local commandText = inputBox.Text:match("^%s*(.-)%s*$")

			if commandText and commandText ~= "" then
				self:executeCommand(commandText)
				inputBox.Text = ""
			end
		end
	end)
end

function ChatUI:executeCommand(commandText)
	if not self.adminRemote then
		if self.showNotificationCallback then
			self.showNotificationCallback("Admin system not ready", Color3.fromRGB(255, 100, 100))
		end
		return
	end

	-- Parse command: "/coin" or "/coin arg"
	local parts = {}
	for part in commandText:gmatch("%S+") do
		table.insert(parts, part)
	end

	if #parts == 0 then return end

	local command = parts[1]:lower():sub(2)
	local arg = parts[2] or ""

	-- Execute command via remote
	local success, result = pcall(function()
		return self.adminRemote:InvokeServer(command, arg)
	end)

	if success and result then
		if self.showNotificationCallback then
			self.showNotificationCallback("✓ " .. command, Color3.fromRGB(100, 255, 100))
		end
	else
		local errorMsg = result or "Unknown error"
		if self.showNotificationCallback then
			self.showNotificationCallback("✗ " .. command .. ": " .. tostring(errorMsg), Color3.fromRGB(255, 100, 100))
		end
	end
end

return ChatUI
-- Built with assistance from Claude Code by Anthropic.
