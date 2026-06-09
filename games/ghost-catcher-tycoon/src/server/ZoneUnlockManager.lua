--
-- Zone Unlock Manager — Ghost Catcher Tycoon
-- Manages zone progression unlocks based on player level and coin requirements
--

local ZoneUnlockManager = {}

-- Zone unlock requirements: {requiredLevel, requiredCoins}
local ZONE_REQUIREMENTS = {
	["Foggy Fields"] = { level = 10, coins = 1000 },
	["Gloomy Graveyard"] = { level = 20, coins = 5000 },
	["Electro Alley"] = { level = 30, coins = 10000 },
	["Frostbite Caverns"] = { level = 40, coins = 20000 },
	["Sunken Spirit Reef"] = { level = 50, coins = 30000 },
	["Clocktower District"] = { level = 60, coins = 40000 },
	["Astral Observatory"] = { level = 70, coins = 50000 },
	["Phantom Fortress"] = { level = 75, coins = 60000 },
	["The Rift"] = { level = 85, coins = 75000 },
	["Eternity Nexus"] = { level = 95, coins = 100000 },
}

-- Free zones that don't require unlock
local FREE_ZONES = {
	["Starting Area"] = true,
	["Whisper Woods"] = true,
}

-- Player unlock state: [userId] = {[zoneName] = true, ...}
local playerUnlocks = {}

-- Initialize player unlocks on join
function ZoneUnlockManager:initializePlayer(userId)
	if not playerUnlocks[userId] then
		playerUnlocks[userId] = {}
		-- Auto-unlock free zones
		for zoneName, _ in pairs(FREE_ZONES) do
			playerUnlocks[userId][zoneName] = true
		end
	end
	return playerUnlocks[userId]
end

-- Check if player can access a zone
function ZoneUnlockManager:canAccessZone(userId, zoneName)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	if FREE_ZONES[zoneName] then
		return true
	end

	return playerUnlocks[userId][zoneName] == true
end

-- Get list of unlocked zones for player
function ZoneUnlockManager:getUnlockedZones(userId)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	local unlocked = {}
	for zoneName, isUnlocked in pairs(playerUnlocks[userId]) do
		if isUnlocked then
			table.insert(unlocked, zoneName)
		end
	end

	table.sort(unlocked)
	return unlocked
end

-- Get zone unlock requirements
function ZoneUnlockManager:getZoneRequirements(zoneName)
	if FREE_ZONES[zoneName] then
		return { level = 0, coins = 0, isFree = true }
	end

	local reqs = ZONE_REQUIREMENTS[zoneName]
	if not reqs then
		return nil
	end

	return reqs
end

-- Check if player meets requirements for a zone
function ZoneUnlockManager:meetsRequirements(userId, zoneName, playerLevel, playerCoins)
	local reqs = self:getZoneRequirements(zoneName)
	if not reqs then
		return false, "ZONE_NOT_FOUND"
	end

	if reqs.isFree then
		return true, "FREE_ZONE"
	end

	if playerLevel < reqs.level then
		return false, "INSUFFICIENT_LEVEL"
	end

	if playerCoins < reqs.coins then
		return false, "INSUFFICIENT_COINS"
	end

	return true, "REQUIREMENTS_MET"
end

-- Request to unlock a zone (with coin deduction)
function ZoneUnlockManager:requestZoneUnlock(userId, zoneName, playerLevel, playerCoins)
	-- Check if already unlocked
	if self:canAccessZone(userId, zoneName) then
		return {
			success = false,
			reason = "ALREADY_UNLOCKED",
			zoneName = zoneName,
		}
	end

	-- Check requirements
	local meetsReqs, reason = self:meetsRequirements(userId, zoneName, playerLevel, playerCoins)
	if not meetsReqs then
		return {
			success = false,
			reason = reason,
			zoneName = zoneName,
			requiredLevel = ZONE_REQUIREMENTS[zoneName] and ZONE_REQUIREMENTS[zoneName].level,
			requiredCoins = ZONE_REQUIREMENTS[zoneName] and ZONE_REQUIREMENTS[zoneName].coins,
			currentLevel = playerLevel,
			currentCoins = playerCoins,
		}
	end

	-- Unlock zone
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	playerUnlocks[userId][zoneName] = true

	return {
		success = true,
		zoneName = zoneName,
		coinsDeducted = ZONE_REQUIREMENTS[zoneName].coins,
		newCoins = playerCoins - ZONE_REQUIREMENTS[zoneName].coins,
	}
end

-- Auto-unlock zones when player levels up (called by LevelSystem)
function ZoneUnlockManager:checkAutoUnlocks(userId, newLevel, playerCoins)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	local unlockedZones = {}

	for zoneName, reqs in pairs(ZONE_REQUIREMENTS) do
		-- Skip if already unlocked
		if playerUnlocks[userId][zoneName] then
			continue
		end

		-- Check if level requirement is met
		if newLevel >= reqs.level then
			-- Check if coins requirement is met
			if playerCoins >= reqs.coins then
				playerUnlocks[userId][zoneName] = true
				table.insert(unlockedZones, zoneName)
			end
		end
	end

	return {
		newlyUnlocked = unlockedZones,
		count = #unlockedZones,
	}
end

-- Get all zone unlock information for UI
function ZoneUnlockManager:getZoneUnlockInfo(userId, playerLevel, playerCoins)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	local zones = {}

	-- Add free zones
	for zoneName, _ in pairs(FREE_ZONES) do
		table.insert(zones, {
			name = zoneName,
			isUnlocked = true,
			isFree = true,
			requiredLevel = 0,
			requiredCoins = 0,
			meetsLevel = true,
			meetsCoins = true,
		})
	end

	-- Add locked/unlockable zones
	for zoneName, reqs in pairs(ZONE_REQUIREMENTS) do
		local isUnlocked = playerUnlocks[userId][zoneName] == true
		local meetsLevel = playerLevel >= reqs.level
		local meetsCoins = playerCoins >= reqs.coins

		table.insert(zones, {
			name = zoneName,
			isUnlocked = isUnlocked,
			isFree = false,
			requiredLevel = reqs.level,
			requiredCoins = reqs.coins,
			meetsLevel = meetsLevel,
			meetsCoins = meetsCoins,
		})
	end

	table.sort(zones, function(a, b)
		return a.name < b.name
	end)

	return zones
end

-- Get remaining zones to unlock
function ZoneUnlockManager:getRemainingZones(userId)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	local remaining = {}

	for zoneName, reqs in pairs(ZONE_REQUIREMENTS) do
		if not playerUnlocks[userId][zoneName] then
			table.insert(remaining, {
				name = zoneName,
				requiredLevel = reqs.level,
				requiredCoins = reqs.coins,
			})
		end
	end

	table.sort(remaining, function(a, b)
		return a.requiredLevel < b.requiredLevel
	end)

	return remaining
end

-- Force unlock a zone (admin only)
function ZoneUnlockManager:forceUnlock(userId, zoneName)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	if not ZONE_REQUIREMENTS[zoneName] and not FREE_ZONES[zoneName] then
		return {
			success = false,
			reason = "ZONE_NOT_FOUND",
		}
	end

	playerUnlocks[userId][zoneName] = true

	return {
		success = true,
		zoneName = zoneName,
	}
end

-- Force lock a zone (admin only)
function ZoneUnlockManager:forceLock(userId, zoneName)
	if not playerUnlocks[userId] then
		self:initializePlayer(userId)
	end

	if FREE_ZONES[zoneName] then
		return {
			success = false,
			reason = "CANNOT_LOCK_FREE_ZONE",
		}
	end

	playerUnlocks[userId][zoneName] = nil

	return {
		success = true,
		zoneName = zoneName,
	}
end

-- Clean up on player leave
function ZoneUnlockManager:removePlayer(userId)
	playerUnlocks[userId] = nil
end

return ZoneUnlockManager
