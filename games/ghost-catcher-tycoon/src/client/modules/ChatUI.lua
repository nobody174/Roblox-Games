--
-- Ghost Catcher Tycoon - Chat UI
-- Chat input box with command history
-- Place this in src/client/modules/ and initialize from GameClient.lua
--

local ChatUI = {}
ChatUI.__index = ChatUI

function ChatUI:new()
	local self = setmetatable({}, ChatUI)
	self.remotes = {}
	self.screenGui = nil
	self.inputBox = nil
	self.historyPanel = nil
	self.messageHistory = {}
	self.maxMessages = 20
	self.isHistoryOpen = false
	self.chatButton = nil
	return self
end

function ChatUI:initialize(gameClient, screenGui, chatTabContent)
	print("[ChatUI] Initializing...")
	print("[ChatUI] Chat tab content frame: " .. tostring(chatTabContent))

	self.remotes.AdminCommand = gameClient.remotes.AdminCommand
	self.screenGui = screenGui
	self.chatTabContent = chatTabContent

	if chatTabContent then
		print("[ChatUI] Chat tab found, creating UI inside it...")
		-- Create UI inside the Chat tab
		self:createInputBoxInTab()
		self:createHistoryPanelInTab()
		print("[ChatUI] Using Chat tab for UI")
	else
		print("[ChatUI] Chat tab NOT found, using fallback top-left UI")
		-- Fallback to top-left
		self:createInputBox()
		self:createHistoryPanel()
	end

	print("[ChatUI] Initialized!")
end

function ChatUI:createInputBoxInTab()
	-- Input container inside Chat tab (fills top 50px)
	local inputContainer = Instance.new("Frame")
	inputContainer.Name = "ChatInputContainer"
	inputContainer.Size = UDim2.new(1, 0, 0, 50)
	inputContainer.Position = UDim2.new(0, 0, 0, 0)
	inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	inputContainer.BorderColor3 = Color3.fromRGB(100, 150, 255)
	inputContainer.BorderSizePixel = 1
	inputContainer.Parent = self.chatTabContent

	-- Input box
	local inputBox = Instance.new("TextBox")
	inputBox.Name = "ChatInput"
	inputBox.Size = UDim2.new(1, -60, 0, 40)
	inputBox.Position = UDim2.new(0, 5, 0, 5)
	inputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	inputBox.BorderSizePixel = 0
	inputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	inputBox.TextSize = 14
	inputBox.Font = Enum.Font.GothamMono
	inputBox.PlaceholderText = "/command (e.g., /coin, /help)"
	inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	inputBox.ClearTextOnFocus = false
	inputBox.Parent = inputContainer

	self.inputBox = inputBox

	-- Submit button
	local submitBtn = Instance.new("TextButton")
	submitBtn.Name = "SubmitBtn"
	submitBtn.Size = UDim2.new(0, 50, 0, 40)
	submitBtn.Position = UDim2.new(1, -55, 0, 5)
	submitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
	submitBtn.BorderSizePixel = 0
	submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	submitBtn.TextSize = 12
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.Text = "Send"
	submitBtn.Parent = inputContainer

	-- Input events
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			self:onInputSubmitted()
		end
	end)

	submitBtn.MouseButton1Click:Connect(function()
		self:onInputSubmitted()
	end)

	print("[ChatUI] Input box created in tab")
end

function ChatUI:createHistoryPanelInTab()
	-- History container (fills remaining space in tab, below input)
	local historyContainer = Instance.new("Frame")
	historyContainer.Name = "ChatHistoryContainer"
	historyContainer.Size = UDim2.new(1, 0, 1, -55)
	historyContainer.Position = UDim2.new(0, 0, 0, 50)
	historyContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	historyContainer.BorderColor3 = Color3.fromRGB(80, 80, 90)
	historyContainer.BorderSizePixel = 0
	historyContainer.Parent = self.chatTabContent

	-- Scrolling frame for messages
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "MessageScroll"
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = historyContainer

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = scrollFrame

	self.historyPanel = historyContainer
	self.scrollFrame = scrollFrame
	self.listLayout = listLayout

	print("[ChatUI] History panel created in tab")
end

function ChatUI:createInputBox()
	-- Input container (top-left, below TopPanel - always accessible)
	local inputContainer = Instance.new("Frame")
	inputContainer.Name = "ChatInputContainer"
	inputContainer.Size = UDim2.new(0, 320, 0, 50)
	inputContainer.Position = UDim2.new(0, 10, 0, 95)
	inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	inputContainer.BorderColor3 = Color3.fromRGB(100, 150, 255)
	inputContainer.BorderSizePixel = 2
	inputContainer.Parent = self.screenGui

	-- Input box
	local inputBox = Instance.new("TextBox")
	inputBox.Name = "ChatInput"
	inputBox.Size = UDim2.new(1, -10, 0, 35)
	inputBox.Position = UDim2.new(0, 5, 0, 5)
	inputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	inputBox.BorderSizePixel = 0
	inputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	inputBox.TextSize = 14
	inputBox.Font = Enum.Font.GothamMono
	inputBox.PlaceholderText = "Type /command (e.g., /coin, /help)"
	inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	inputBox.ClearTextOnFocus = false
	inputBox.Parent = inputContainer

	self.inputBox = inputBox

	-- Submit button
	local submitBtn = Instance.new("TextButton")
	submitBtn.Name = "SubmitBtn"
	submitBtn.Size = UDim2.new(0, 50, 0, 35)
	submitBtn.Position = UDim2.new(1, -55, 0, 5)
	submitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
	submitBtn.BorderSizePixel = 0
	submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	submitBtn.TextSize = 12
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.Text = "Send"
	submitBtn.Parent = inputContainer

	-- Input events
	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			self:onInputSubmitted()
		end
	end)

	submitBtn.MouseButton1Click:Connect(function()
		self:onInputSubmitted()
	end)

	print("[ChatUI] Input box created")
end

function ChatUI:createHistoryPanel()
	-- History container (top-left, below input box)
	local historyContainer = Instance.new("Frame")
	historyContainer.Name = "ChatHistoryContainer"
	historyContainer.Size = UDim2.new(0, 320, 0, 260)
	historyContainer.Position = UDim2.new(0, 10, 0, 150)
	historyContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	historyContainer.BorderColor3 = Color3.fromRGB(80, 80, 90)
	historyContainer.BorderSizePixel = 1
	historyContainer.Visible = true
	historyContainer.Parent = self.screenGui

	-- Scrolling frame for messages
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "MessageScroll"
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = historyContainer

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = scrollFrame

	self.historyPanel = historyContainer
	self.scrollFrame = scrollFrame
	self.listLayout = listLayout

	print("[ChatUI] History panel created")
end

function ChatUI:onInputSubmitted()
	local inputText = self.inputBox.Text:match("^%s*(.-)%s*$") -- Trim whitespace
	if inputText == "" then
		return
	end

	-- Check if it's a command
	if inputText:sub(1, 1) ~= "/" then
		self:displayMessage("Commands start with /", Color3.fromRGB(255, 200, 50))
		return
	end

	-- Parse command
	local parts = {}
	for part in inputText:gmatch("%S+") do
		table.insert(parts, part)
	end

	if #parts == 0 then
		return
	end

	local command = parts[1]:lower():sub(2) -- Remove leading /
	local arg1 = parts[2]
	local arg2 = parts[3]

	-- Display command in history
	self:displayMessage("> " .. inputText, Color3.fromRGB(150, 150, 150))

	-- Execute command
	if self.remotes.AdminCommand then
		local success, result = pcall(function()
			return self.remotes.AdminCommand:InvokeServer(command, arg1, arg2)
		end)

		if success then
			if result then
				self:displayMessage("✓ " .. command .. " executed", Color3.fromRGB(0, 255, 100))
			else
				self:displayMessage("✗ Command failed or not admin", Color3.fromRGB(255, 100, 100))
			end
		else
			self:displayMessage("✗ Error: " .. tostring(result), Color3.fromRGB(255, 100, 100))
		end
	else
		self:displayMessage("✗ AdminCommand remote not found", Color3.fromRGB(255, 100, 100))
	end

	-- Clear input
	self.inputBox.Text = ""
end

function ChatUI:displayMessage(text, color)
	-- Create message label
	local msgLabel = Instance.new("TextLabel")
	msgLabel.Name = "Message"
	msgLabel.Size = UDim2.new(0, 300, 0, 20)
	msgLabel.BackgroundTransparency = 1
	msgLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
	msgLabel.TextSize = 12
	msgLabel.Font = Enum.Font.GothamMono
	msgLabel.Text = text
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.TextWrapped = true
	msgLabel.Parent = self.scrollFrame

	-- Add to history
	table.insert(self.messageHistory, msgLabel)

	-- Remove oldest if over max
	if #self.messageHistory > self.maxMessages then
		local oldMsg = table.remove(self.messageHistory, 1)
		oldMsg:Destroy()
	end

	-- Update canvas size
	local listLayout = self.listLayout
	task.wait(0.01) -- Let UIListLayout update
	local contentSize = listLayout.AbsoluteContentSize.Y
	self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize)

	-- Auto-scroll to bottom
	self.scrollFrame.CanvasPosition = Vector2.new(0, self.scrollFrame.CanvasSize.Y.Offset)
end

return ChatUI
