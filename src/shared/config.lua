--[=[
  Ghost Catcher Tycoon - Game Configuration
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local Config = {}

-- Game Metadata
Config.GameTitle = "Ghost Catcher Tycoon"
Config.Version = "0.1.0"
Config.Author = "nobody174"

-- Game Settings
Config.AutoSaveInterval = 30 -- seconds
Config.DataStoreRetries = 3
Config.DataStoreRetryDelay = 2 -- seconds

-- Currency
Config.InitialEnergy = 0
Config.EnergyPerSecondBase = 1

-- Vacuum System
Config.VacuumChargePerClick = 5
Config.VacuumMaxCharge = 100
Config.VacuumChargeCooldown = 0 -- no cooldown

-- Ghost System
Config.DefaultGhostStorage = 5
Config.GhostStoragePerUpgrade = 5
Config.GhostSpawnRate = 5 -- ghosts per second per zone
Config.GhostDespawnTime = 60 -- seconds before ghost leaves

-- Ghost Rarities (Catch Chance, Energy Output)
Config.Rarities = {
	Common = {
		Color = Color3.fromRGB(128, 128, 128),
		CatchChance = 0.80,
		BaseEnergyOutput = 1,
		Weight = 0.50, -- Spawn weight
	},
	Uncommon = {
		Color = Color3.fromRGB(0, 255, 0),
		CatchChance = 0.60,
		BaseEnergyOutput = 2,
		Weight = 0.30,
	},
	Rare = {
		Color = Color3.fromRGB(0, 0, 255),
		CatchChance = 0.40,
		BaseEnergyOutput = 5,
		Weight = 0.15,
	},
	Legendary = {
		Color = Color3.fromRGB(128, 0, 128),
		CatchChance = 0.20,
		BaseEnergyOutput = 10,
		Weight = 0.04,
	},
	Mythic = {
		Color = Color3.fromRGB(255, 255, 0),
		CatchChance = 0.05,
		BaseEnergyOutput = 25,
		Weight = 0.01,
	},
}

-- Zones
Config.Zones = {
	Forest = {
		DisplayName = "Enchanted Forest",
		UnlockCost = 0, -- Unlocked from start
		EnergyMultiplier = 1.0,
		DifficultyModifier = 0.8,
		RarityWeights = {
			Common = 0.70,
			Uncommon = 0.30,
		},
	},
	Graveyard = {
		DisplayName = "Haunted Graveyard",
		UnlockCost = 500,
		EnergyMultiplier = 1.2,
		DifficultyModifier = 1.0,
		RarityWeights = {
			Uncommon = 0.60,
			Rare = 0.40,
		},
	},
	Mansion = {
		DisplayName = "Haunted Mansion",
		UnlockCost = 5000,
		EnergyMultiplier = 1.5,
		DifficultyModifier = 1.2,
		RarityWeights = {
			Rare = 0.70,
			Legendary = 0.30,
		},
	},
	DarkDimension = {
		DisplayName = "Dark Dimension",
		UnlockCost = 50000,
		EnergyMultiplier = 2.0,
		DifficultyModifier = 1.5,
		RarityWeights = {
			Legendary = 0.70,
			Mythic = 0.30,
		},
	},
}

-- HQ Rooms
Config.Rooms = {
	GhostChamber = {
		DisplayName = "Ghost Chamber",
		Description = "Stores your ghosts. Upgrade for more storage.",
		BaseCost = 100,
		SlotsPerLevel = 5,
		BaseSlots = 5,
		EnergyMultiplierPerLevel = 1.2,
		MaxLevel = 10,
	},
	TrainingFacility = {
		DisplayName = "Training Facility",
		Description = "Train ghosts to improve their stats.",
		BaseCost = 200,
		SpeedMultiplierPerLevel = 1.5,
		BaseSpeedMultiplier = 1.0,
		MaxLevel = 10,
	},
	EnergyReactor = {
		DisplayName = "Energy Reactor",
		Description = "Boosts all energy production.",
		BaseCost = 500,
		EnergyMultiplierPerLevel = 1.5,
		BaseMultiplier = 1.0,
		MaxLevel = 10,
	},
	ResearchLab = {
		DisplayName = "Research Lab",
		Description = "Unlock new ghost types and zones.",
		BaseCost = 1000,
		MaxLevel = 5,
	},
	BossArena = {
		DisplayName = "Boss Arena",
		Description = "Fight boss ghosts for special rewards.",
		BaseCost = 2000,
		MaxLevel = 1,
	},
}

-- Training System
Config.Training = {
	BaseTrainingTime = 300, -- 5 minutes for level 1->2
	TrainingTimeMultiplier = 2, -- Each level takes 2x longer
	BaseTrainingCost = 50, -- Energy cost for level 1->2
	TrainingCostMultiplier = 2, -- Each level costs 2x more
	MaxGhostLevel = 10,
}

-- GamePasses (Robux prices)
Config.GamePasses = {
	AutoCatch = {
		Id = 0, -- Set this to real ID when published
		Price = 699,
		Description = "Automatically catch ghosts",
	},
	AutoTrain = {
		Id = 0,
		Price = 499,
		Description = "Automatically train ghosts",
	},
	DoubleEnergy = {
		Id = 0,
		Price = 399,
		Description = "Double all energy production",
	},
	VIPZone = {
		Id = 0,
		Price = 799,
		Description = "Access exclusive VIP zone",
	},
	ExtraStorage = {
		Id = 0,
		Price = 299,
		Description = "Double ghost storage slots",
	},
}

-- Developer Products (Robux prices)
Config.Products = {
	EnergyPack = {
		Id = 0,
		Price = 100,
		Amount = 1000,
		Description = "1,000 Ecto-Energy",
	},
	GhostEgg = {
		Id = 0,
		Price = 299,
		Description = "Random ghost (1-5 rarity)",
	},
	BossTicket = {
		Id = 0,
		Price = 199,
		Description = "Boss fight ticket",
	},
	TrainingBoost = {
		Id = 0,
		Price = 99,
		Duration = 3600, -- 1 hour in seconds
		Description = "2× training speed for 1 hour",
	},
}

-- UI Settings
Config.UI = {
	UpdateFrequency = 0.5, -- Update UI every 0.5 seconds
	AnimationDuration = 0.3, -- Tween animations
	NumberFormatThreshold = 1000000, -- Use K/M/B notation above 1M
}

-- Production Calculation
Config.Production = {
	UpdateFrequency = 1, -- Calculate production once per second
	OfflineProductionEnabled = false, -- No offline earnings (for now)
}

-- Exploit Prevention
Config.Security = {
	MaxEnergyPerRequest = 1000000, -- Cap single energy request
	MaxGhostsPerRequest = 100, -- Cap ghost operations
	RateLimitPerSecond = 10, -- Max requests per second
}

return Config
