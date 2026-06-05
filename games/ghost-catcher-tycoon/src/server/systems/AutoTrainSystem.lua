--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (vartdal@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local AutoTrainSystem = {}
AutoTrainSystem.__index = AutoTrainSystem

local Config = nil
local Constants = nil

-- Safe require with fallback
local function safeRequire(path)
	local rs = game:GetService("ReplicatedStorage")
	local parts = {}
	for part in path:gmatch("[^:]+") do
		table.insert(parts, part)
	end

	local obj = rs
	for _, part in ipairs(parts) do
		part = part:match("^%s*(.-)%s*$") -- trim
		if obj then
			obj = obj:FindFirstChild(part)
		end
	end

	if obj then
		return require(obj)
	end
	return nil
end

Config = safeRequire("shared:config") or { Training = { MaxGhostLevel = 10 } }
Constants = safeRequire("shared:constants") or {}

function AutoTrainSystem:new()
	local self = setmetatable({}, AutoTrainSystem)
	self.autoTrainActive = {} -- UserId -> { active, targetLevel, ghostsList }
	self.trainingSystem = nil
	self.ghostSystem = nil
	self.monetizationSystem = nil
	self.currencySystem = nil
	return self
end

function AutoTrainSystem:setTrainingSystem(trainingSystem)
	self.trainingSystem = trainingSystem
end

function AutoTrainSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function AutoTrainSystem:setMonetizationSystem(monetizationSystem)
	self.monetizationSystem = monetizationSystem
end

function AutoTrainSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function AutoTrainSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.autoTrainActive then
		self.autoTrainActive = {}
	end
	self.autoTrainActive[userId] = {
		active = false,
		targetLevel = (Config and Config.Training and Config.Training.MaxGhostLevel) or 10,
		ghostsList = {}
	}
end

function AutoTrainSystem:isAutoTrainEnabled(player)
	local userId = player.UserId
	if not self.autoTrainActive[userId] then
		self:initializePlayer(player)
	end

	-- Check if player has AutoTrain GamePass
	if not self.monetizationSystem then
		return false
	end

	return self.monetizationSystem:hasGamePass(player, "AutoTrain")
end

function AutoTrainSystem:getAutoTrainSpeedMultiplier(player)
	local baseSpeed = 1.0

	-- Check for training boost product
	if self.monetizationSystem then
		local boostCount = self.monetizationSystem:getProductCount(player, "TrainingBoost")
		if boostCount > 0 then
			return baseSpeed * 2.0 -- 2x speed with boost
		end
	end

	return baseSpeed
end

function AutoTrainSystem:setAutoTrainTarget(player, targetLevel)
	local userId = player.UserId

	if not self.autoTrainActive[userId] then
		self:initializePlayer(player)
	end

	if targetLevel < 1 or targetLevel > (Config.Training.MaxGhostLevel or 10) then
		return false, "Invalid target level"
	end

	self.autoTrainActive[userId].targetLevel = targetLevel
	return true, targetLevel
end

function AutoTrainSystem:addGhostToAutoTrain(player, ghostId)
	local userId = player.UserId

	if not self.autoTrainActive[userId] then
		self:initializePlayer(player)
	end

	if not self.ghostSystem then
		return false, "Ghost system not initialized"
	end

	local ghost = self.ghostSystem:getGhost(player, ghostId)
	if not ghost then
		return false, "Ghost not found"
	end

	-- Check if already in queue
	for _, id in ipairs(self.autoTrainActive[userId].ghostsList) do
		if id == ghostId then
			return false, "Ghost already in queue"
		end
	end

	table.insert(self.autoTrainActive[userId].ghostsList, ghostId)
	return true, ghostId
end

function AutoTrainSystem:removeGhostFromAutoTrain(player, ghostId)
	local userId = player.UserId

	if not self.autoTrainActive[userId] then
		return false, "Not initialized"
	end

	for i, id in ipairs(self.autoTrainActive[userId].ghostsList) do
		if id == ghostId then
			table.remove(self.autoTrainActive[userId].ghostsList, i)
			return true, i
		end
	end

	return false, "Ghost not in queue"
end

function AutoTrainSystem:tick(player)
	local userId = player.UserId

	if not self.autoTrainActive[userId] then
		self:initializePlayer(player)
	end

	if not self:isAutoTrainEnabled(player) then
		return 0
	end

	if not self.trainingSystem or not self.ghostSystem then
		return 0
	end

	local targetLevel = self.autoTrainActive[userId].targetLevel
	local ghostsList = self.autoTrainActive[userId].ghostsList
	local trainedCount = 0

	for _, ghostId in ipairs(ghostsList) do
		local ghost = self.ghostSystem:getGhost(player, ghostId)
		if ghost then
			local currentLevel = ghost.level or 1

			-- Only train if below target level
			if currentLevel < targetLevel then
				local success, result = self.trainingSystem:startTraining(player, ghostId, targetLevel)
				if success then
					trainedCount = trainedCount + 1
				end
			end
		end
	end

	return trainedCount
end

function AutoTrainSystem:getAutoTrainQueue(player)
	local userId = player.UserId

	if not self.autoTrainActive[userId] then
		self:initializePlayer(player)
	end

	return {
		enabled = self:isAutoTrainEnabled(player),
		targetLevel = self.autoTrainActive[userId].targetLevel,
		ghostsList = self.autoTrainActive[userId].ghostsList,
		count = #self.autoTrainActive[userId].ghostsList,
	}
end

function AutoTrainSystem:removePlayer(userId)
	self.autoTrainActive[userId] = nil
end

return AutoTrainSystem
-- Built with assistance from Claude Code by Anthropic.

