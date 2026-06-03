--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Ghost roster: 120 ghosts across 6 rarity tiers with stat ranges and personality types.
--
local GhostData = {

	RarityStats = {
		Common = {
			CatchSpeed = {1, 2},
			EnergyPerMin = {1, 3},
			TrainingCost = {1, 1.2},
		},
		Uncommon = {
			CatchSpeed = {2, 3},
			EnergyPerMin = {3, 6},
			TrainingCost = {1.2, 1.5},
		},
		Rare = {
			CatchSpeed = {3, 4},
			EnergyPerMin = {6, 10},
			TrainingCost = {1.5, 2},
		},
		Epic = {
			CatchSpeed = {4, 6},
			EnergyPerMin = {10, 18},
			TrainingCost = {2, 3},
		},
		Legendary = {
			CatchSpeed = {6, 8},
			EnergyPerMin = {18, 30},
			TrainingCost = {3, 4},
		},
		Corrupted = {
			CatchSpeed = {8, 10},
			EnergyPerMin = {30, 50},
			TrainingCost = {4, 6},
		}
	},

	Personalities = {
		"Shy",       -- harder to catch, more energy
		"Angry",     -- faster catch speed
		"Playful",   -- random boosts
		"Lazy",      -- slow but cheap to train
		"Hyper",     -- fast but unstable
	},

	Ghosts = {
		-- COMMON (20)
		"Puffling","Wobbler","Peekaboo","Drifter","Blinklet",
		"Whispling","Bubblo","Snoozer","Flickerbit","Pufftail",
		"Glowmite","Squeakshade","Mistyboo","Hushling","Flitter",
		"Softshade","Pale Popper","Wanderwisp","Smolspirit","Faintling",

		-- UNCOMMON (20)
		"Sparkling Sprite","Shadowling","Giggler","Lantern Wisp","Dustwhirl",
		"Foghopper","Glimmerbug","Chirpgeist","Murkling","Breezeboo",
		"Twitchlet","Glowcap","Frostpuff","Zaplet","Leafwhirl",
		"Pebblegeist","Sootshade","Bellowboo","Gustling","Shimmerpod",

		-- RARE (20)
		"Voltgeist","Frostwhisper","Bloomshade","Geargrin","Tidebound",
		"Cinderwisp","Stormpetal","Ironwraith","Crystalshade","Moonpuff",
		"Rootgeist","Gloomtail","Slickshade","Brinewhisper","Glowvine",
		"Fangfrost","Stormling","Quartzgeist","Hollowpetal","Riftling",

		-- EPIC (20)
		"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
		"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
		"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
		"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",

		-- LEGENDARY (20)
		"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
		"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
		"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
		"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",

		-- CORRUPTED (20)
		"Glitchspawn","Void Maw","Redacted","Error Phantom","Fractured Echo",
		"404 Wraith","Null Serpent","Broken Herald","Corrupt Titan","Riftbreaker",
		"Data Leech","Memory Eater","Packet Phantom","Lagspawn","Crashling",
		"Hexshade","Corrupt Monarch","Glitch Tyrant","Null Archon","Forbidden Echo",
	},

	RarityMap = {
		-- Common
		Puffling="Common",Wobbler="Common",Peekaboo="Common",Drifter="Common",Blinklet="Common",
		Whispling="Common",Bubblo="Common",Snoozer="Common",Flickerbit="Common",Pufftail="Common",
		Glowmite="Common",Squeakshade="Common",Mistyboo="Common",Hushling="Common",Flitter="Common",
		Softshade="Common",["Pale Popper"]="Common",Wanderwisp="Common",Smolspirit="Common",Faintling="Common",

		-- Uncommon
		["Sparkling Sprite"]="Uncommon",Shadowling="Uncommon",Giggler="Uncommon",
		["Lantern Wisp"]="Uncommon",Dustwhirl="Uncommon",Foghopper="Uncommon",
		Glimmerbug="Uncommon",Chirpgeist="Uncommon",Murkling="Uncommon",Breezeboo="Uncommon",
		Twitchlet="Uncommon",Glowcap="Uncommon",Frostpuff="Uncommon",Zaplet="Uncommon",
		Leafwhirl="Uncommon",Pebblegeist="Uncommon",Sootshade="Uncommon",Bellowboo="Uncommon",
		Gustling="Uncommon",Shimmerpod="Uncommon",

		-- Rare
		Voltgeist="Rare",Frostwhisper="Rare",Bloomshade="Rare",Geargrin="Rare",Tidebound="Rare",
		Cinderwisp="Rare",Stormpetal="Rare",Ironwraith="Rare",Crystalshade="Rare",Moonpuff="Rare",
		Rootgeist="Rare",Gloomtail="Rare",Slickshade="Rare",Brinewhisper="Rare",Glowvine="Rare",
		Fangfrost="Rare",Stormling="Rare",Quartzgeist="Rare",Hollowpetal="Rare",Riftling="Rare",

		-- Epic
		["Phantom Knight"]="Epic",["Inferno Wraith"]="Epic",["Astral Drifter"]="Epic",
		["Cryo Reaper"]="Epic",["Thunder Jester"]="Epic",["Solar Herald"]="Epic",
		["Frost Monarch"]="Epic",["Storm Harbinger"]="Epic",["Abyss Diver"]="Epic",
		["Crystal Titan"]="Epic",Blazebound="Epic",Starweaver="Epic",["Chrono Juggler"]="Epic",
		Fangshade="Epic",["Gloom Reaver"]="Epic",["Tempest Warden"]="Epic",["Shard Serpent"]="Epic",
		["Ember Phantom"]="Epic",["Void Herald"]="Epic",["Astral Knight"]="Epic",

		-- Legendary
		["Eclipse Seraph"]="Legendary",["Omega Polterlord"]="Legendary",["Chrono Spirit"]="Legendary",
		["Nebula Sovereign"]="Legendary",["Aurora Herald"]="Legendary",["Solar Emperor"]="Legendary",
		["Frost Tyrant"]="Legendary",["Rift Monarch"]="Legendary",["Abyss King"]="Legendary",
		["Starborn Leviathan"]="Legendary",["Eternal Warden"]="Legendary",["Cosmic Oracle"]="Legendary",
		["Glacier Archon"]="Legendary",["Thunder Emperor"]="Legendary",["Solaris Phantom"]="Legendary",
		["Astral Sovereign"]="Legendary",["Eon Serpent"]="Legendary",["Void Archangel"]="Legendary",
		Timebreaker="Legendary",["Galactic Reaper"]="Legendary",

		-- Corrupted
		Glitchspawn="Corrupted",["Void Maw"]="Corrupted",Redacted="Corrupted",
		["Error Phantom"]="Corrupted",["Fractured Echo"]="Corrupted",["404 Wraith"]="Corrupted",
		["Null Serpent"]="Corrupted",["Broken Herald"]="Corrupted",["Corrupt Titan"]="Corrupted",
		Riftbreaker="Corrupted",["Data Leech"]="Corrupted",["Memory Eater"]="Corrupted",
		["Packet Phantom"]="Corrupted",Lagspawn="Corrupted",Crashling="Corrupted",
		Hexshade="Corrupted",["Corrupt Monarch"]="Corrupted",["Glitch Tyrant"]="Corrupted",
		["Null Archon"]="Corrupted",["Forbidden Echo"]="Corrupted",
	},
}

return GhostData
-- Built with assistance from Claude Code by Anthropic.

