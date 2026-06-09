--[=[
  Ghost Catcher Tycoon - Game Enumerations
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local Enums = {}

-- Ghost Rarities
Enums.Rarity = {
	Common = "Common",
	Uncommon = "Uncommon",
	Rare = "Rare",
	Legendary = "Legendary",
	Mythic = "Mythic",
}

-- Game Zones
Enums.Zone = {
	Forest = "Forest",
	Graveyard = "Graveyard",
	Mansion = "Mansion",
	DarkDimension = "DarkDimension",
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
	BringGhostsHome = "BringGhostsHome",
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
