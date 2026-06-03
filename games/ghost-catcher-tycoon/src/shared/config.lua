--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
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
Config.InitialEnergy = 5000 -- Starting energy helps players catch ghosts immediately
Config.EnergyPerSecondBase = 1 -- Base energy per second (multiplied by ghost stats)

-- Vacuum System
Config.VacuumChargePerClick = 5 -- +5% charge per click (20 clicks to full)
Config.VacuumMaxCharge = 100 -- 100% max charge
Config.VacuumChargeCooldown = 0 -- no cooldown (players can spam charge)

-- Ghost System
Config.DefaultGhostStorage = 5
Config.GhostStoragePerUpgrade = 5
Config.GhostSpawnRate = 3 -- spawn 1 ghost every 3 seconds per zone (balanced for catching)
Config.GhostDespawnTime = 60 -- seconds before ghost leaves (players have 60s to catch)

-- Ghost Rarities (Catch Chance, Energy Output)
Config.Rarities = {
	Common = {
		Color = Color3.fromRGB(128, 128, 128),
		CatchChance = 0.80,
		BaseEnergyOutput = 1,
		Weight = 0.50,
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
	Epic = {
		Color = Color3.fromRGB(255, 140, 0),
		CatchChance = 0.25,
		BaseEnergyOutput = 10,
		Weight = 0.03,
	},
	Legendary = {
		Color = Color3.fromRGB(128, 0, 128),
		CatchChance = 0.15,
		BaseEnergyOutput = 20,
		Weight = 0.015,
	},
	Corrupted = {
		Color = Color3.fromRGB(139, 0, 139),
		CatchChance = 0.05,
		BaseEnergyOutput = 50,
		Weight = 0.005,
	},
}

-- Zones (for backwards compatibility, reference ZoneData.lua for primary data)
Config.Zones = {
	["Whisper Woods"] = { UnlockCost = 0, EnergyMultiplier = 1.0 },
	["Foggy Fields"] = { UnlockCost = 1500, EnergyMultiplier = 1.2 },
	["Gloomy Graveyard"] = { UnlockCost = 6000, EnergyMultiplier = 1.5 },
	["Electro Alley"] = { UnlockCost = 18000, EnergyMultiplier = 1.8 },
	["Frostbite Caverns"] = { UnlockCost = 42000, EnergyMultiplier = 2.1 },
	["Sunken Spirit Reef"] = { UnlockCost = 90000, EnergyMultiplier = 2.5 },
	["Clocktower District"] = { UnlockCost = 180000, EnergyMultiplier = 3.0 },
	["Astral Observatory"] = { UnlockCost = 350000, EnergyMultiplier = 3.8 },
	["Phantom Fortress"] = { UnlockCost = 700000, EnergyMultiplier = 4.5 },
	["The Rift"] = { UnlockCost = 1500000, EnergyMultiplier = 5.5 },
	["Eternity Nexus"] = { UnlockCost = 0, EnergyMultiplier = 7.0 },
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
		Description = "2Ã— training speed for 1 hour",
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

-- Prestige System
Config.Prestige = {
	MaxLevel = 20,
	BaseThreshold = 1000000, -- 1M energy required for prestige 1
	ThresholdMultiplier = 2, -- Each level requires 2x more
	EnergyProductionBonusPerLevel = 0.10, -- +10% per prestige level
	CatchRateBonusPerLevel = 0.05, -- +5% per prestige level
	StorageBonusPerFiveLevels = 1, -- +1 ghost storage per 5 levels
}

-- Quest System
Config.Quests = {
	DailyQuestCount = 3,
	WeeklyQuestCount = 1,
	DailyResetHour = 0, -- UTC midnight
	WeeklyResetDay = 2, -- Monday (os.date %w: 2=Mon)
	Types = {
		CatchGhosts = {
			Description = "Catch %d ghosts",
			Targets = { 5, 10, 25, 50 },
			Rewards = { Energy = 500, XP = 10 },
		},
		EarnEnergy = {
			Description = "Earn %d energy",
			Targets = { 1000, 5000, 20000, 100000 },
			Rewards = { BonusCatches = 3, XP = 15 },
		},
		UpgradeRooms = {
			Description = "Upgrade %d rooms",
			Targets = { 1, 3, 5 },
			Rewards = { Energy = 2000, XP = 20 },
		},
		TrainGhosts = {
			Description = "Train a ghost to level %d",
			Targets = { 3, 5, 8, 10 },
			Rewards = { Energy = 1000, XP = 25 },
		},
	},
}

-- Leaderboard System
Config.Leaderboard = {
	UpdateInterval = 60, -- seconds
	TopCount = 10,
	Categories = { "TotalEnergyEarned", "GhostsCaught", "PrestigeLevel", "HighestZone" },
	ZoneRanks = {
		Forest = 1,
		Graveyard = 2,
		Mansion = 3,
		DarkDimension = 4,
	},
}

-- Event System
Config.Events = {
	Active = {}, -- Populated at runtime or by developer
	DefaultBonusMultiplier = 1.0,
}

-- Gacha System (replaced by Egg System in EggData.lua)
Config.Gacha = {
	StandardPullCost = 100,
	PremiumPullCost = 500,
	TenPullCostStandard = 900,
	TenPullCostPremium = 4500,
	PityRareAt = 10,
	PityLegendaryAt = 50,
	StandardWeights = {
		Common = 0.60,
		Uncommon = 0.25,
		Rare = 0.10,
		Epic = 0.03,
		Legendary = 0.015,
		Corrupted = 0.005,
	},
	PremiumWeights = {
		Common = 0.30,
		Uncommon = 0.35,
		Rare = 0.20,
		Epic = 0.10,
		Legendary = 0.04,
		Corrupted = 0.01,
	},
}

-- Cosmetics System
Config.Cosmetics = {
	Skins = {
		Default = {
			DisplayName = "Default",
			Cost = 0,
			CostType = "free",
		},
		GhostKing = {
			DisplayName = "Ghost King",
			Cost = 50000,
			CostType = "energy",
		},
		Neon = {
			DisplayName = "Neon",
			Cost = 25000,
			CostType = "energy",
		},
		Sparkle = {
			DisplayName = "Sparkle",
			Cost = 15000,
			CostType = "energy",
		},
		Phantom = {
			DisplayName = "Phantom",
			Cost = 999,
			CostType = "robux",
		},
	},
}

-- PvP System
Config.PvP = {
	BattleCooldown = 300, -- 5 minutes
	WinnerEnergyPercent = 0.10, -- 10% transfer
	RarityPowerWeights = {
		Common = 1,
		Uncommon = 2,
		Rare = 5,
		Epic = 10,
		Legendary = 20,
		Corrupted = 50,
	},
}

return Config
-- Built with assistance from Claude Code by Anthropic.

