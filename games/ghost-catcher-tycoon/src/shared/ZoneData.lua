--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Zone progression: 11 zones with unlock costs, biome types, rarity ranges, and weighted ghost pools.
--
local ZoneData = {

	["Whisper Woods"] = {
		Id = 1,
		UnlockCost = 0,
		BaseEnergyMultiplier = 1.0,
		MinRarity = "Common",
		MaxRarity = "Uncommon",
		Special = "Starter zone, no penalties.",
		Spawns = {
			{ Ghost = "Puffling",       Rarity = "Common",   Weight = 25 },
			{ Ghost = "Wobbler",        Rarity = "Common",   Weight = 25 },
			{ Ghost = "Peekaboo",       Rarity = "Common",   Weight = 20 },
			{ Ghost = "Drifter",        Rarity = "Common",   Weight = 15 },
			{ Ghost = "Smolspirit",     Rarity = "Common",   Weight = 15 },
			{ Ghost = "Sparkling Sprite", Rarity = "Uncommon", Weight = 3 },
			{ Ghost = "Shadowling",       Rarity = "Uncommon", Weight = 2 },
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
			{ Ghost = "Puffling",     Rarity = "Common",   Weight = 15 },
			{ Ghost = "Wobbler",      Rarity = "Common",   Weight = 15 },
			{ Ghost = "Blinklet",     Rarity = "Common",   Weight = 15 },
			{ Ghost = "Mistyboo",     Rarity = "Common",   Weight = 15 },
			{ Ghost = "Faintling",    Rarity = "Common",   Weight = 10 },
			{ Ghost = "Sparkling Sprite", Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Giggler",          Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Lantern Wisp",     Rarity = "Uncommon", Weight = 6 },
			{ Ghost = "Dustwhirl",        Rarity = "Uncommon", Weight = 5 },
			{ Ghost = "Frostwhisper", Rarity = "Rare", Weight = 3 },
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
			{ Ghost = "Drifter",      Rarity = "Common",   Weight = 10 },
			{ Ghost = "Softshade",    Rarity = "Common",   Weight = 10 },
			{ Ghost = "Hushling",     Rarity = "Common",   Weight = 8 },
			{ Ghost = "Shadowling",   Rarity = "Uncommon", Weight = 15 },
			{ Ghost = "Murkling",     Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Sootshade",    Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Bloomshade",   Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Gloomtail",    Rarity = "Rare",     Weight = 8 },
			{ Ghost = "Rootgeist",    Rarity = "Rare",     Weight = 7 },
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
			{ Ghost = "Zaplet",       Rarity = "Uncommon", Weight = 15 },
			{ Ghost = "Glowcap",      Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Twitchlet",    Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Voltgeist",    Rarity = "Rare",     Weight = 18 },
			{ Ghost = "Stormling",    Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Geargrin",     Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Thunder Jester", Rarity = "Epic",   Weight = 5 },
			{ Ghost = "Storm Harbinger", Rarity = "Epic",  Weight = 3 },
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
			{ Ghost = "Frostpuff",    Rarity = "Uncommon", Weight = 12 },
			{ Ghost = "Glimmerbug",   Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Frostwhisper", Rarity = "Rare",     Weight = 18 },
			{ Ghost = "Crystalshade", Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Quartzgeist",  Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Fangfrost",    Rarity = "Rare",     Weight = 8 },
			{ Ghost = "Frost Monarch", Rarity = "Epic",    Weight = 7 },
			{ Ghost = "Cryo Reaper",   Rarity = "Epic",    Weight = 5 },
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
			{ Ghost = "Bubblo",       Rarity = "Uncommon", Weight = 10 },
			{ Ghost = "Breezeboo",    Rarity = "Uncommon", Weight = 8 },
			{ Ghost = "Tidebound",    Rarity = "Rare",     Weight = 18 },
			{ Ghost = "Brinewhisper", Rarity = "Rare",     Weight = 12 },
			{ Ghost = "Glowvine",     Rarity = "Rare",     Weight = 10 },
			{ Ghost = "Abyss Diver",  Rarity = "Epic",     Weight = 8 },
			{ Ghost = "Crystal Titan", Rarity = "Epic",    Weight = 5 },
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
			{ Ghost = "Geargrin",       Rarity = "Rare",   Weight = 15 },
			{ Ghost = "Riftling",       Rarity = "Rare",   Weight = 10 },
			{ Ghost = "Chrono Juggler", Rarity = "Epic",   Weight = 10 },
			{ Ghost = "Tempest Warden", Rarity = "Epic",   Weight = 8 },
			{ Ghost = "Starweaver",     Rarity = "Epic",   Weight = 6 },
			{ Ghost = "Chrono Spirit",  Rarity = "Legendary", Weight = 4 },
			{ Ghost = "Timebreaker",    Rarity = "Legendary", Weight = 2 },
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
			{ Ghost = "Astral Drifter",   Rarity = "Epic",      Weight = 15 },
			{ Ghost = "Astral Knight",    Rarity = "Epic",      Weight = 10 },
			{ Ghost = "Ember Phantom",    Rarity = "Epic",      Weight = 8 },
			{ Ghost = "Nebula Sovereign", Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Aurora Herald",    Rarity = "Legendary", Weight = 6 },
			{ Ghost = "Cosmic Oracle",    Rarity = "Legendary", Weight = 4 },
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
			{ Ghost = "Phantom Knight",   Rarity = "Epic",      Weight = 15 },
			{ Ghost = "Gloom Reaver",     Rarity = "Epic",      Weight = 10 },
			{ Ghost = "Shard Serpent",    Rarity = "Epic",      Weight = 8 },
			{ Ghost = "Eclipse Seraph",   Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Omega Polterlord", Rarity = "Legendary", Weight = 6 },
			{ Ghost = "Eternal Warden",   Rarity = "Legendary", Weight = 4 },
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
			{ Ghost = "Rift Monarch",     Rarity = "Legendary", Weight = 10 },
			{ Ghost = "Galactic Reaper",  Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Glitchspawn",      Rarity = "Corrupted", Weight = 10 },
			{ Ghost = "Void Maw",         Rarity = "Corrupted", Weight = 8 },
			{ Ghost = "Redacted",         Rarity = "Corrupted", Weight = 6 },
			{ Ghost = "Error Phantom",    Rarity = "Corrupted", Weight = 6 },
			{ Ghost = "Fractured Echo",   Rarity = "Corrupted", Weight = 5 },
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
			{ Ghost = "Nebula Sovereign", Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Aurora Herald",    Rarity = "Legendary", Weight = 8 },
			{ Ghost = "Eon Serpent",      Rarity = "Legendary", Weight = 6 },
			{ Ghost = "Void Archangel",   Rarity = "Legendary", Weight = 6 },
			{ Ghost = "Glitch Tyrant",    Rarity = "Corrupted", Weight = 6 },
			{ Ghost = "Corrupt Monarch",  Rarity = "Corrupted", Weight = 6 },
			{ Ghost = "Null Archon",      Rarity = "Corrupted", Weight = 5 },
			{ Ghost = "Forbidden Echo",   Rarity = "Corrupted", Weight = 5 },
		}
	},
}

return ZoneData
-- Built with assistance from Claude Code by Anthropic.

