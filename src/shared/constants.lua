--[=[
  Ghost Catcher Tycoon - Game Constants
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local Constants = {}

-- Paths
Constants.Paths = {
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	ServerStorage = game:GetService("ServerStorage"),
	StarterPlayer = game:GetService("StarterPlayer"),
	ServerScriptService = game:GetService("ServerScriptService"),
}

-- Services
Constants.Services = {
	DataStoreService = game:GetService("DataStoreService"),
	MarketplaceService = game:GetService("MarketplaceService"),
	Players = game:GetService("Players"),
	RunService = game:GetService("RunService"),
	UserInputService = game:GetService("UserInputService"),
}

-- DataStore Names
Constants.DataStores = {
	PlayerData = "PlayerData_v1",
	Analytics = "Analytics_v1",
}

-- Remote Event/Function Names
Constants.Remotes = {
	ChargeVacuum = "ChargeVacuum",
	CatchGhost = "CatchGhost",
	BringGhostsHome = "BringGhostsHome",
	TrainGhost = "TrainGhost",
	UpgradeRoom = "UpgradeRoom",
	UnlockZone = "UnlockZone",
	GetGameState = "GetGameState",
	UpdateUI = "UpdateUI",
	ShowNotification = "ShowNotification",
}

-- Time Constants (in seconds)
Constants.Time = {
	SaveInterval = 30,
	ProductionTick = 1,
	UIUpdateInterval = 0.5,
	GhostDespawnTime = 60,
	CatchCooldown = 2,
}

-- Limits
Constants.Limits = {
	MaxGhostsPerPlayer = 100,
	MaxEnergyStorage = 9999999999, -- 10 billion cap
	MaxGhostLevel = 10,
	MaxRoomLevel = 10,
}

-- Notifications
Constants.Notifications = {
	GhostCaught = "You caught a ghost!",
	UpgradeFailed = "Insufficient energy!",
	UpgradeSuccess = "Room upgraded!",
	ZoneUnlocked = "New zone unlocked!",
	LevelUp = "Ghost leveled up!",
}

return Constants
