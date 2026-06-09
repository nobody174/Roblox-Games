--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Gacha eggs: 7 purchasable tiers with rarity drop chances and ghost pools.
--
local EggData = {

	["Common Egg"] = {
		Price = 250,
		Currency = "EctoEnergy",
		Chances = {
			Common = 80,
			Uncommon = 18,
			Rare = 2,
		},
		Pool = {
			Common = {
				"Puffling","Wobbler","Peekaboo","Drifter","Blinklet",
				"Whispling","Bubblo","Snoozer","Flickerbit","Pufftail",
				"Glowmite","Squeakshade","Mistyboo","Hushling","Flitter",
				"Softshade","Pale Popper","Wanderwisp","Smolspirit","Faintling",
			},
			Uncommon = {
				"Sparkling Sprite","Shadowling","Giggler","Lantern Wisp","Dustwhirl",
				"Foghopper","Glimmerbug","Chirpgeist","Murkling","Breezeboo",
				"Twitchlet","Glowcap","Frostpuff","Zaplet","Leafwhirl",
				"Pebblegeist","Sootshade","Bellowboo","Gustling","Shimmerpod",
			},
			Rare = {
				"Voltgeist","Frostwhisper","Bloomshade","Geargrin","Tidebound",
				"Cinderwisp","Stormpetal","Ironwraith","Crystalshade","Moonpuff",
				"Rootgeist","Gloomtail","Slickshade","Brinewhisper","Glowvine",
				"Fangfrost","Stormling","Quartzgeist","Hollowpetal","Riftling",
			}
		}
	},

	["Uncommon Egg"] = {
		Price = 1200,
		Currency = "EctoEnergy",
		Chances = {
			Common = 40,
			Uncommon = 45,
			Rare = 12,
			Epic = 3,
		},
		Pool = {
			Common = {
				"Puffling","Wobbler","Peekaboo","Drifter","Blinklet",
				"Whispling","Bubblo","Snoozer","Flickerbit","Pufftail",
				"Glowmite","Squeakshade","Mistyboo","Hushling","Flitter",
				"Softshade","Pale Popper","Wanderwisp","Smolspirit","Faintling",
			},
			Uncommon = {
				"Sparkling Sprite","Shadowling","Giggler","Lantern Wisp","Dustwhirl",
				"Foghopper","Glimmerbug","Chirpgeist","Murkling","Breezeboo",
				"Twitchlet","Glowcap","Frostpuff","Zaplet","Leafwhirl",
				"Pebblegeist","Sootshade","Bellowboo","Gustling","Shimmerpod",
			},
			Rare = {
				"Voltgeist","Frostwhisper","Bloomshade","Geargrin","Tidebound",
				"Cinderwisp","Stormpetal","Ironwraith","Crystalshade","Moonpuff",
				"Rootgeist","Gloomtail","Slickshade","Brinewhisper","Glowvine",
				"Fangfrost","Stormling","Quartzgeist","Hollowpetal","Riftling",
			},
			Epic = {
				"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
				"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
				"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
				"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",
			}
		}
	},

	["Rare Egg"] = {
		Price = 5000,
		Currency = "EctoEnergy",
		Chances = {
			Uncommon = 30,
			Rare = 50,
			Epic = 18,
			Legendary = 2,
		},
		Pool = {
			Uncommon = {
				"Sparkling Sprite","Shadowling","Giggler","Lantern Wisp","Dustwhirl",
				"Foghopper","Glimmerbug","Chirpgeist","Murkling","Breezeboo",
				"Twitchlet","Glowcap","Frostpuff","Zaplet","Leafwhirl",
				"Pebblegeist","Sootshade","Bellowboo","Gustling","Shimmerpod",
			},
			Rare = {
				"Voltgeist","Frostwhisper","Bloomshade","Geargrin","Tidebound",
				"Cinderwisp","Stormpetal","Ironwraith","Crystalshade","Moonpuff",
				"Rootgeist","Gloomtail","Slickshade","Brinewhisper","Glowvine",
				"Fangfrost","Stormling","Quartzgeist","Hollowpetal","Riftling",
			},
			Epic = {
				"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
				"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
				"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
				"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",
			},
			Legendary = {
				"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
				"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
				"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
				"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",
			}
		}
	},

	["Epic Egg"] = {
		Price = 15000,
		Currency = "EctoEnergy",
		Chances = {
			Rare = 30,
			Epic = 55,
			Legendary = 15,
		},
		Pool = {
			Rare = {
				"Voltgeist","Frostwhisper","Bloomshade","Geargrin","Tidebound",
				"Cinderwisp","Stormpetal","Ironwraith","Crystalshade","Moonpuff",
				"Rootgeist","Gloomtail","Slickshade","Brinewhisper","Glowvine",
				"Fangfrost","Stormling","Quartzgeist","Hollowpetal","Riftling",
			},
			Epic = {
				"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
				"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
				"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
				"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",
			},
			Legendary = {
				"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
				"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
				"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
				"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",
			}
		}
	},

	["Legendary Egg"] = {
		Price = 45000,
		Currency = "EctoEnergy",
		Chances = {
			Epic = 40,
			Legendary = 55,
			Corrupted = 5,
		},
		Pool = {
			Epic = {
				"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
				"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
				"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
				"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",
			},
			Legendary = {
				"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
				"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
				"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
				"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",
			},
			Corrupted = {
				"Glitchspawn","Void Maw","Redacted","Error Phantom","Fractured Echo",
				"404 Wraith","Null Serpent","Broken Herald","Corrupt Titan","Riftbreaker",
				"Data Leech","Memory Eater","Packet Phantom","Lagspawn","Crashling",
				"Hexshade","Corrupt Monarch","Glitch Tyrant","Null Archon","Forbidden Echo",
			}
		}
	},

	["Corrupted Egg"] = {
		Price = 120000,
		Currency = "EctoEnergy",
		Chances = {
			Legendary = 20,
			Corrupted = 80,
		},
		Pool = {
			Legendary = {
				"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
				"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
				"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
				"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",
			},
			Corrupted = {
				"Glitchspawn","Void Maw","Redacted","Error Phantom","Fractured Echo",
				"404 Wraith","Null Serpent","Broken Herald","Corrupt Titan","Riftbreaker",
				"Data Leech","Memory Eater","Packet Phantom","Lagspawn","Crashling",
				"Hexshade","Corrupt Monarch","Glitch Tyrant","Null Archon","Forbidden Echo",
			}
		}
	},

	["Premium Robux Egg"] = {
		Price = 199,
		Currency = "Robux",
		Chances = {
			Epic = 30,
			Legendary = 50,
			Corrupted = 20,
		},
		Pool = {
			Epic = {
				"Phantom Knight","Inferno Wraith","Astral Drifter","Cryo Reaper","Thunder Jester",
				"Solar Herald","Frost Monarch","Storm Harbinger","Abyss Diver","Crystal Titan",
				"Blazebound","Starweaver","Chrono Juggler","Fangshade","Gloom Reaver",
				"Tempest Warden","Shard Serpent","Ember Phantom","Void Herald","Astral Knight",
			},
			Legendary = {
				"Eclipse Seraph","Omega Polterlord","Chrono Spirit","Nebula Sovereign","Aurora Herald",
				"Solar Emperor","Frost Tyrant","Rift Monarch","Abyss King","Starborn Leviathan",
				"Eternal Warden","Cosmic Oracle","Glacier Archon","Thunder Emperor","Solaris Phantom",
				"Astral Sovereign","Eon Serpent","Void Archangel","Timebreaker","Galactic Reaper",
			},
			Corrupted = {
				"Glitchspawn","Void Maw","Redacted","Error Phantom","Fractured Echo",
				"404 Wraith","Null Serpent","Broken Herald","Corrupt Titan","Riftbreaker",
				"Data Leech","Memory Eater","Packet Phantom","Lagspawn","Crashling",
				"Hexshade","Corrupt Monarch","Glitch Tyrant","Null Archon","Forbidden Echo",
			}
		}
	},
}

return EggData
-- Built with assistance from Claude Code by Anthropic.

