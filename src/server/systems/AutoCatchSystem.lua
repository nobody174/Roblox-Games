--[=[
  Ghost Catcher Tycoon - Auto-Catch System
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local AutoCatchSystem = {}
AutoCatchSystem.__index = AutoCatchSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function AutoCatchSystem:new()
	local self = setmetatable({}, AutoCatchSystem)
	self.autoCatchActive = {} -- UserId -> { active, lastCatchTime, catchRate }
	self.ghostSystem = nil
	self.vacuumSystem = nil
	self.monetizationSystem = nil
	return self
end

function AutoCatchSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function AutoCatchSystem:setVacuumSystem(vacuumSystem)
	self.vacuumSystem = vacuumSystem
end

function AutoCatchSystem:setMonetizationSystem(monetizationSystem)
	self.monetizationSystem = monetizationSystem
end

function AutoCatchSystem:initializePlayer(player)
	local userId = player.UserId
	self.autoCatchActive[userId] = {
		active = false,
		lastCatchTime = 0,
		catchRate = 1, -- catches per second
	}
end

function AutoCatchSystem:isAutoCatchEnabled(player)
	local userId = player.UserId
	if not self.autoCatchActive[userId] then
		self:initializePlayer(player)
	end

	-- Check if player has AutoCatch GamePass
	if not self.monetizationSystem then
		return false
	end

	return self.monetizationSystem:hasGamePass(player, "AutoCatch")
end

function AutoCatchSystem:getAutoCatchRate(player)
	local baseRate = Config.AutoCatch and Config.AutoCatch.BaseRate or 1

	-- Check for speed boost
	local boostMultiplier = 1.0
	if self.monetizationSystem then
		boostMultiplier = self.monetizationSystem:getGamePassBonus(player, "Faster Vacuum")
	end

	return baseRate * boostMultiplier
end

function AutoCatchSystem:performAutoCatch(player, zone)
	local userId = player.UserId

	if not self:isAutoCatchEnabled(player) then
		return false, "AutoCatch not enabled"
	end

	if not self.ghostSystem then
		return false, "Ghost system not initialized"
	end

	-- Try to catch a ghost in the specified zone
	local ghost = self.ghostSystem:spawnGhost(zone)
	local success = self.ghostSystem:addGhost(player, ghost)

	if success then
		-- Update last catch time
		self.autoCatchActive[userId].lastCatchTime = os.time()
		return true, ghost
	else
		return false, "Storage full"
	end
end

function AutoCatchSystem:tick(player, zone)
	local userId = player.UserId

	if not self.autoCatchActive[userId] then
		self:initializePlayer(player)
	end

	if not self:isAutoCatchEnabled(player) then
		return 0
	end

	local now = os.time()
	local timeSinceLastCatch = now - self.autoCatchActive[userId].lastCatchTime
	local catchRate = self:getAutoCatchRate(player)
	local timeBetweenCatches = 1 / catchRate

	-- Check if enough time has passed for next catch
	if timeSinceLastCatch >= timeBetweenCatches then
		local success, ghost = self:performAutoCatch(player, zone or "Forest")
		if success then
			return 1
		end
	end

	return 0
end

function AutoCatchSystem:setAutoCatchZone(player, zone)
	local userId = player.UserId
	if not self.autoCatchActive[userId] then
		self:initializePlayer(player)
	end

	if not Config.Zones[zone] then
		return false, "Invalid zone"
	end

	self.autoCatchActive[userId].zone = zone
	return true, zone
end

function AutoCatchSystem:getAutoCatchZone(player)
	local userId = player.UserId
	if not self.autoCatchActive[userId] then
		self:initializePlayer(player)
	end

	return self.autoCatchActive[userId].zone or "Forest"
end

function AutoCatchSystem:removePlayer(userId)
	self.autoCatchActive[userId] = nil
end

return AutoCatchSystem
