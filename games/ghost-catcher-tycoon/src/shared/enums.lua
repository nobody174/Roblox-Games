--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Enumeration tables for game states: rarities, zones, rooms, currencies, events, and request types.
--
local Enums = {}

-- Ghost Rarities
Enums.Rarity = {
	Common = "Common",
	Uncommon = "Uncommon",
	Rare = "Rare",
	Epic = "Epic",
	Legendary = "Legendary",
	Corrupted = "Corrupted",
}

-- Game Zones
Enums.Zone = {
	["Whisper Woods"] = "Whisper Woods",
	["Foggy Fields"] = "Foggy Fields",
	["Gloomy Graveyard"] = "Gloomy Graveyard",
	["Electro Alley"] = "Electro Alley",
	["Frostbite Caverns"] = "Frostbite Caverns",
	["Sunken Spirit Reef"] = "Sunken Spirit Reef",
	["Clocktower District"] = "Clocktower District",
	["Astral Observatory"] = "Astral Observatory",
	["Phantom Fortress"] = "Phantom Fortress",
	["The Rift"] = "The Rift",
	["Eternity Nexus"] = "Eternity Nexus",
}

-- HQ Rooms
Enums.Room = {
	GhostChamber = "GhostChamber",
	TrainingFacility = "TrainingFacility",
	EnergyReactor = "EnergyReactor",
	ResearchLab = "ResearchLab",
	BossArena = "BossArena",
}

-- Currency Types
Enums.Currency = {
	Energy = "Energy",
	Robux = "Robux", -- Real currency (read-only)
}

-- System Events
Enums.Event = {
	PlayerJoined = "PlayerJoined",
	PlayerLeft = "PlayerLeft",
	GhostCaught = "GhostCaught",
	GhostTrained = "GhostTrained",
	RoomUpgraded = "RoomUpgraded",
	ZoneUnlocked = "ZoneUnlocked",
	EnergyChanged = "EnergyChanged",
}

-- Purchase Types
Enums.PurchaseType = {
	GamePass = "GamePass",
	Product = "Product",
}

-- Ghost Status
Enums.GhostStatus = {
	Catching = "Catching",
	Caught = "Caught",
	Training = "Training",
	Ready = "Ready",
	Resting = "Resting",
}

-- Request Types (for RemoteEvents)
Enums.Request = {
	ChargeVacuum = "ChargeVacuum",
	CatchGhost = "CatchGhost",
	BringGhomesHome = "BringGhostsHome",
	TrainGhost = "TrainGhost",
	UpgradeRoom = "UpgradeRoom",
	UnlockZone = "UnlockZone",
	PurchaseGamePass = "PurchaseGamePass",
	PurchaseProduct = "PurchaseProduct",
}

-- Response Status
Enums.ResponseStatus = {
	Success = "Success",
	Failure = "Failure",
	InvalidRequest = "InvalidRequest",
	InsufficientFunds = "InsufficientFunds",
	AlreadyOwned = "AlreadyOwned",
	RateLimited = "RateLimited",
}

return Enums
-- Built with assistance from Claude Code by Anthropic.

