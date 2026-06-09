--
-- Ghost Catcher Tycoon — Fly Tool for Testing
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Testing utility: camera-relative flight for exploring zones (Press F to toggle, WASD+Space/Ctrl to move).
--
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isFlying = false
local flySpeed = 125
local bodyVelocity
local bodyGyro
local speedDisplay
local screenGui
local flightConnection

print("[FlyTool] Ghost Catcher Tycoon Flight System loaded")
print("[FlyTool] Press F to toggle flight mode")
print("[FlyTool] Controls: WASD to move, Mouse to look around")
print("[FlyTool] Speed adjustment: Numpad + to increase, Numpad - to decrease")

local function updateSpeedDisplay()
	if speedDisplay then
		speedDisplay.Text = "✈️ Speed: " .. flySpeed .. " studs/sec"
	end
end

local function startFlying()
	if isFlying then return end
	isFlying = true

	print("[FlyTool] ✈️ Flight activated!")

	-- Create speed display GUI
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlySpeedGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	speedDisplay = Instance.new("TextLabel")
	speedDisplay.Name = "SpeedDisplay"
	speedDisplay.Size = UDim2.new(0, 250, 0, 50)
	speedDisplay.Position = UDim2.new(0, 20, 0, 20)
	speedDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	speedDisplay.BackgroundTransparency = 0.5
	speedDisplay.TextColor3 = Color3.fromRGB(0, 255, 255)
	speedDisplay.TextSize = 18
	speedDisplay.Font = Enum.Font.GothamBold
	speedDisplay.Text = "✈️ Speed: " .. flySpeed .. " studs/sec"
	speedDisplay.Parent = screenGui

	-- Create BodyVelocity for movement
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = humanoidRootPart

	-- Create BodyGyro for rotation
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 10000
	bodyGyro.Parent = humanoidRootPart

	-- Flight loop
	flightConnection = RunService.RenderStepped:Connect(function()
		if not isFlying or not character.Parent then
			flightConnection:Disconnect()
			return
		end

		-- Get camera direction
		local camera = workspace.CurrentCamera
		local moveDirection = Vector3.new(0, 0, 0)

		-- WASD movement
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + camera.CFrame.RightVector
		end

		-- Space = up, Ctrl = down
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection = moveDirection + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDirection = moveDirection - Vector3.new(0, 1, 0)
		end

		-- Normalize and apply speed
		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit
		end

		bodyVelocity.Velocity = moveDirection * flySpeed
		bodyGyro.CFrame = camera.CFrame
	end)
end

local function stopFlying()
	if not isFlying then return end
	isFlying = false

	print("[FlyTool] 🚶 Flight deactivated!")

	if flightConnection then
		flightConnection:Disconnect()
		flightConnection = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
		speedDisplay = nil
	end
end

-- Toggle flight with F key, adjust speed with numpad +/-
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.F then
		if isFlying then
			stopFlying()
		else
			startFlying()
		end
	elseif input.KeyCode == Enum.KeyCode.KeypadPlus then
		flySpeed = flySpeed + 25
		print("[FlyTool] ⚡ Speed increased: " .. flySpeed .. " studs/sec")
		updateSpeedDisplay()
	elseif input.KeyCode == Enum.KeyCode.KeypadMinus then
		flySpeed = math.max(10, flySpeed - 25)
		print("[FlyTool] 🐌 Speed decreased: " .. flySpeed .. " studs/sec")
		updateSpeedDisplay()
	end
end)

-- Stop flying when character dies
character.Humanoid.Died:Connect(function()
	stopFlying()
end)

print("[FlyTool] ✅ Flight tool ready!")

-- Built with assistance from Claude Code by Anthropic.
