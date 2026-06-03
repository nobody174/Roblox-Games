--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Global game constants: services, remotes, time limits, notifications, and data limits.
--
local Constants = {}

-- Paths (lazy-loaded to avoid initialization issues)
Constants.Paths = setmetatable({}, {
	__index = function(_, key)
		if key == "ReplicatedStorage" then return game:GetService("ReplicatedStorage") end
		if key == "ServerStorage" then return game:GetService("ServerStorage") end
		if key == "StarterPlayer" then return game:GetService("StarterPlayer") end
		if key == "ServerScriptService" then return game:GetService("ServerScriptService") end
	end
})

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
	Leaderboard = "Leaderboard_v1",
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
	Prestige = "Prestige",
	GetPrestigeInfo = "GetPrestigeInfo",
	GetQuests = "GetQuests",
	ClaimQuestReward = "ClaimQuestReward",
	GetLeaderboard = "GetLeaderboard",
	GetEventInfo = "GetEventInfo",
	GachaPull = "GachaPull",
	UnlockSkin = "UnlockSkin",
	ApplySkin = "ApplySkin",
	GetSkins = "GetSkins",
	ChallengePlayer = "ChallengePlayer",
	RespondToChallenge = "RespondToChallenge",
	BattleResult = "BattleResult",
	SpawnBoss = "SpawnBoss",
	PurchaseGamePass = "PurchaseGamePass",
	PurchaseProduct = "PurchaseProduct",
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
	PrestigeSuccess = "Prestige successful! Permanent bonuses increased.",
	QuestComplete = "Quest complete! Claim your reward.",
	BattleWon = "You won the ghost battle!",
	BattleLost = "You lost the ghost battle.",
	GachaPull = "You pulled a ghost!",
}

return Constants
-- Built with assistance from Claude Code by Anthropic.

