--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Zone progression: 11 zones with unlock costs, biome types, rarity ranges, and weighted ghost pools.
--
local ZoneData = {

	["Starting Area"] = {
		Id = 0,
		UnlockCost = 0,
		BaseEnergyMultiplier = 1.0,
		MinRarity = "Common",
		MaxRarity = "Uncommon",
		Special = "Public Hub zone, shared starting area, no penalties.",
		IsPublic = true,
		Spawns = {
			{ Ghost = "Captain Wisp",     Rarity = "Common",   Weight = 20 },
			{ Ghost = "Jolly Specter",    Rarity = "Common",   Weight = 20 },
			{ Ghost = "Treasure Puff",    Rarity = "Common",   Weight = 18 },
			{ Ghost = "Plank Walker",     Rarity = "Common",   Weight = 15 },
			{ Ghost = "Seafaring Glow",   Rarity = "Common",   Weight = 15 },
			{ Ghost = "Storm Streak",     Rarity = "Uncommon", Weight = 5 },
			{ Ghost = "Thunder Wisp",     Rarity = "Uncommon", Weight = 5 },
		}
	},

	["Home"] = {
		Id = 99,
		UnlockCost = 0,
		BaseEnergyMultiplier = 1.0,
		MinRarity = "Common",
		MaxRarity = "Corrupted",
		Special = "Private per-player HQ island (no ghost spawning).",
		IsPrivate = true,
		IsPhased = true,
		Spawns = {},
	},

	["Whisper Woods"] = {
		Id = 1,
		UnlockCost = 0,
		BaseEnergyMultiplier = 1.0,
		MinRarity = "Common",
		MaxRarity = "Uncommon",
		Special = "First exploration zone, easy difficulty.",
		Spawns = {
			{ Ghost = "Arcane Puff",      Rarity = "Common",   Weight = 18 },
			{ Ghost = "Mystic Whisper",   Rarity = "Common",   Weight = 18 },
			{ Ghost = "Spellbound Spirit",Rarity = "Common",   Weight = 16 },
			{ Ghost = "Enchanted Drift",  Rarity = "Common",   Weight = 14 },
			{ Ghost = "Potion Phantom",   Rarity = "Common",   Weight = 14 },
			{ Ghost = "Cyclone Puff",     Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Lightning Phantom",Rarity = "Uncommon", Weight = 6 },
		}
	},

	["Foggy Fields"] = {
		Id = 2,
		UnlockCost = 1500,
		BaseEnergyMultiplier = 1.2,
		MinRarity = "Common",
		MaxRarity = "Rare",
		Special = "Slightly thicker fog, slightly slower player speed.",
		Spawns = {
			{ Ghost = "Royal Gleam",      Rarity = "Common",   Weight = 14 },
			{ Ghost = "Regal Glow",       Rarity = "Common",   Weight = 14 },
			{ Ghost = "Majestic Wisp",    Rarity = "Common",   Weight = 12 },
			{ Ghost = "Noble Specter",    Rarity = "Common",   Weight = 12 },
			{ Ghost = "Throne Spirit",    Rarity = "Common",   Weight = 10 },
			{ Ghost = "Tempest Spirit",   Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Dragon Spirit",    Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Dragon's Breath",  Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Flame Drake",      Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Quantum Burst",    Rarity = "Rare",     Weight = 2 },
		}
	},

	["Gloomy Graveyard"] = {
		Id = 3,
		UnlockCost = 6000,
		BaseEnergyMultiplier = 1.5,
		MinRarity = "Common",
		MaxRarity = "Rare",
		Special = "First real challenge, first boss zone.",
		Spawns = {
			{ Ghost = "Circuit Boo",      Rarity = "Common",   Weight = 12 },
			{ Ghost = "Metal Phantom",    Rarity = "Common",   Weight = 12 },
			{ Ghost = "Cyber Glow",       Rarity = "Common",   Weight = 10 },
			{ Ghost = "Powered Wisp",     Rarity = "Common",   Weight = 10 },
			{ Ghost = "Spark Spirit",     Rarity = "Common",   Weight = 8 },
			{ Ghost = "Ember Drake",      Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Inferno Glow",     Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Fire Wisp",        Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Digital Phantom",  Rarity = "Rare",     Weight = 5 },
		}
	},

	["Electro Alley"] = {
		Id = 4,
		UnlockCost = 18000,
		BaseEnergyMultiplier = 1.8,
		MinRarity = "Uncommon",
		MaxRarity = "Epic",
		Special = "Electric theme, occasional stun effect (optional).",
		Spawns = {
			{ Ghost = "Blaze Spirit",     Rarity = "Uncommon", Weight = 15 },
			{ Ghost = "Spark Phantom",    Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Spark Drift",      Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Neon Wisp",        Rarity = "Rare",     Weight = 16 },
			{ Ghost = "Silicon Spirit",   Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Hologram Glow",    Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Star Spirit",      Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Cosmic Phantom",   Rarity = "Epic",     Weight = 5 },
		}
	},

	["Frostbite Caverns"] = {
		Id = 5,
		UnlockCost = 42000,
		BaseEnergyMultiplier = 2.1,
		MinRarity = "Uncommon",
		MaxRarity = "Epic",
		Special = "Slippery floor, slower turning (optional).",
		Spawns = {
			{ Ghost = "Crystal Wink",     Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Gem Spirit",       Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Sparkle Phantom",  Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Nebula Wisp",      Rarity = "Rare",     Weight = 15 },
			{ Ghost = "Galaxy Glow",      Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Pulsar Puff",      Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Aviator Ace",      Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Space Explorer",   Rarity = "Epic",     Weight = 6 },
		}
	},

	["Sunken Spirit Reef"] = {
		Id = 6,
		UnlockCost = 90000,
		BaseEnergyMultiplier = 2.5,
		MinRarity = "Uncommon",
		MaxRarity = "Epic",
		Special = "Underwater vibe, slightly slower movement.",
		Spawns = {
			{ Ghost = "Diamond Glow",     Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Luminous Puff",    Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Ocean Drift",      Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Wave Whisper",     Rarity = "Rare",     Weight = 15 },
			{ Ghost = "Deep Phantom",     Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Coral Spirit",     Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Lunar Phantom",    Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Starbound Spirit", Rarity = "Epic",     Weight = 6 },
		}
	},

	["Clocktower District"] = {
		Id = 7,
		UnlockCost = 180000,
		BaseEnergyMultiplier = 3.0,
		MinRarity = "Rare",
		MaxRarity = "Legendary",
		Special = "Time-themed, optional time-slow events.",
		Spawns = {
			{ Ghost = "Seafoam Glow",     Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Jungle Drift",     Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Maestro Phantom",  Rarity = "Rare",     Weight = 14 },
			{ Ghost = "Melody Wisp",      Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Harmony Spirit",   Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Crown Specter",    Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Eternal Phantom",  Rarity = "Legendary", Weight = 3 },
		}
	},

	["Astral Observatory"] = {
		Id = 8,
		UnlockCost = 350000,
		BaseEnergyMultiplier = 3.8,
		MinRarity = "Epic",
		MaxRarity = "Legendary",
		Special = "High-value energy zone.",
		Spawns = {
			{ Ghost = "Vine Spirit",      Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Tropical Puff",    Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Rhythm Glow",      Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Symphony Puff",    Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Sovereign Phantom",Rarity = "Epic",     Weight = 12 },
			{ Ghost = "Dynasty Spirit",   Rarity = "Epic",     Weight = 10 },
			{ Ghost = "Mythic Wisp",      Rarity = "Legendary", Weight = 5 },
		}
	},

	["Phantom Fortress"] = {
		Id = 9,
		UnlockCost = 700000,
		BaseEnergyMultiplier = 4.5,
		MinRarity = "Epic",
		MaxRarity = "Legendary",
		Special = "Boss-heavy castle zone.",
		Spawns = {
			{ Ghost = "Forest Phantom",   Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Emerald Glow",     Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Empress Wisp",     Rarity = "Epic",     Weight = 12 },
			{ Ghost = "Kingbright Glow",  Rarity = "Epic",     Weight = 10 },
			{ Ghost = "Celestial Phantom",Rarity = "Epic",     Weight = 10 },
			{ Ghost = "Divine Spirit",    Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Transcendent Spirit",Rarity = "Legendary", Weight = 4 },
		}
	},

	["The Rift"] = {
		Id = 10,
		UnlockCost = 1500000,
		BaseEnergyMultiplier = 5.5,
		MinRarity = "Legendary",
		MaxRarity = "Corrupted",
		Special = "Glitch world, corrupted ghosts.",
		Spawns = {
			{ Ghost = "Steampunk Gear",   Rarity = "Uncommon", Weight = 4 },
			{ Ghost = "Seraph Wisp",      Rarity = "Epic",     Weight = 10 },
			{ Ghost = "Halo Glow",        Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Omniscient Glow",  Rarity = "Legendary", Weight = 10 },
			{ Ghost = "Apex Phantom",     Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Infernal Crown",   Rarity = "Corrupted", Weight = 8 },
			{ Ghost = "Void Phantom",     Rarity = "Corrupted", Weight = 6 },
		}
	},

	["Eternity Nexus"] = {
		Id = 11,
		UnlockCost = 0,
		BaseEnergyMultiplier = 7.0,
		MinRarity = "Legendary",
		MaxRarity = "Corrupted",
		Special = "Prestige/endgame zone with boosted rates.",
		Spawns = {
			{ Ghost = "Blessed Puff",     Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Zenith Specter",   Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Timeless Specter", Rarity = "Legendary", Weight = 10 },
			{ Ghost = "Moonlit Echo",     Rarity = "Legendary", Weight = 9 },
			{ Ghost = "Starforge Wisp",   Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Abyssal Spirit",   Rarity = "Corrupted", Weight = 8 },
			{ Ghost = "Shadowed Wisp",    Rarity = "Corrupted", Weight = 7 },
			{ Ghost = "Corrupted Glow",   Rarity = "Corrupted", Weight = 6 },
		}
	},
}

return ZoneData
-- Built with assistance from Claude Code by Anthropic.

