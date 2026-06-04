-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Client-side UI management: screen layout, button handlers, tab system, and real-time game state updates.
--
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local GhostCardBuilder = require(script.Parent:WaitForChild("modules"):WaitForChild("GhostCardBuilder"))

local GameClient = {}
GameClient.__index = GameClient

function GameClient:new()
	local self = setmetatable({}, GameClient)
	self.player = Players.LocalPlayer
	self.remotes = {}
	self.gameState = {}
	self.ui = {}
	self.tabExpanded = false
	self.notificationStack = 0
	self.populatedTabs = {}
	return self
end

function GameClient:initialize()
	print("[Ghost Catcher Tycoon] Client initializing...")

	self:waitForRemotes()
	self:setupUI()
	self:setupInputHandlers()
	self:startUpdateLoop()

	print("[Ghost Catcher Tycoon] Client initialized!")
end

function GameClient:waitForRemotes()
	local rs = game:GetService("ReplicatedStorage")
	local remotesFolder = rs:WaitForChild("Remotes")

	-- Cache all remotes
	self.remotes.ChargeVacuum = remotesFolder:WaitForChild(Constants.Remotes.ChargeVacuum)
	self.remotes.CatchGhost = remotesFolder:WaitForChild(Constants.Remotes.CatchGhost)
	self.remotes.BringGhostsHome = remotesFolder:WaitForChild(Constants.Remotes.BringGhostsHome)
	self.remotes.UpdateUI = remotesFolder:WaitForChild(Constants.Remotes.UpdateUI)
	self.remotes.GetGameState = remotesFolder:WaitForChild(Constants.Remotes.GetGameState)
	self.remotes.ShowNotification = remotesFolder:FindFirstChild(Constants.Remotes.ShowNotification)
