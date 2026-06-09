--
-- Ghost Catcher Tycoon — Boss Data Configuration
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Boss roster: 5 bosses with HP, damage, cooldowns, and rarity-weighted loot tables.
--
local BossData = {
	Gravekeeper = {
		Zones = { 3 },
		MaxHP = 500,
		Damage = 10,
		AttackCooldown = 2,
		EnergyReward = 1500,
		GhostDrop = {
			Rare = 80,
			Epic = 18,
			Legendary = 2,
		},
	},

	["Frost Tyrant"] = {
		Zones = { 5 },
		MaxHP = 1200,
		Damage = 18,
		AttackCooldown = 1.8,
		EnergyReward = 4500,
		GhostDrop = {
			Rare = 40,
			Epic = 45,
			Legendary = 15,
		},
	},

	["Chrono Warden"] = {
		Zones = { 7 },
		MaxHP = 2500,
		Damage = 25,
		AttackCooldown = 1.5,
		EnergyReward = 9000,
		GhostDrop = {
			Epic = 60,
			Legendary = 40,
		},
	},

	["Phantom Emperor"] = {
		Zones = { 9 },
		MaxHP = 5000,
		Damage = 40,
		AttackCooldown = 1.2,
		EnergyReward = 20000,
		GhostDrop = {
			Epic = 30,
			Legendary = 50,
			Corrupted = 20,
		},
	},

	["Rift Titan"] = {
		Zones = { 10 },
		MaxHP = 9000,
		Damage = 55,
		AttackCooldown = 1,
		EnergyReward = 35000,
		GhostDrop = {
			Legendary = 40,
			Corrupted = 60,
		},
	},
}

return BossData

-- Built with assistance from Claude Code by Anthropic.
