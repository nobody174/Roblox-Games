--[=[
  Ghost Catcher Tycoon - Training System
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local TrainingSystem = {}
TrainingSystem.__index = TrainingSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function TrainingSystem:new()
	local self = setmetatable({}, TrainingSystem)
	self.trainingQueue = {} -- UserId -> { ghostId: { startTime, targetLevel } }
	self.currencySystem = nil
	self.ghostSystem = nil
	return self
end

function TrainingSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function TrainingSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function TrainingSystem:initializePlayer(player)
	local userId = player.UserId
	self.trainingQueue[userId] = {}
end

function TrainingSystem:startTraining(player, ghostId, targetLevel)
	local userId = player.UserId

	if not self.trainingQueue[userId] then
		self:initializePlayer(player)
	end

	if not self.ghostSystem then
		return false, "Ghost system not initialized"
	end

	local ghost = self.ghostSystem:getGhost(player, ghostId)
	if not ghost then
		return false, "Ghost not found"
	end

	-- Check if already training
	if self.trainingQueue[userId][ghostId] then
		return false, "Ghost already training"
	end

	local currentLevel = ghost.level or 1
	if currentLevel >= (Config.Training.MaxGhostLevel or 10) then
		return false, "Ghost at max level"
	end

	-- Validate target level
	if targetLevel <= currentLevel or targetLevel > (Config.Training.MaxGhostLevel or 10) then
		return false, "Invalid target level"
	end

	-- Calculate total cost for level range
	local totalCost = 0
	for level = currentLevel, targetLevel - 1 do
		totalCost = totalCost + self:calculateTrainingCost(ghost, level)
	end

	-- Check energy
	if not self.currencySystem then
		return false, "Currency system not initialized"
	end

	local playerEnergy = self.currencySystem:getEnergy(player)
	if playerEnergy < totalCost then
		return false, "Not enough energy. Need: " .. totalCost .. ", Have: " .. playerEnergy
	end

	-- Deduct cost
	self.currencySystem:subtractEnergy(player, totalCost)

	-- Add to training queue
	self.trainingQueue[userId][ghostId] = {
		startTime = os.time(),
		targetLevel = targetLevel,
		currentLevel = currentLevel,
		totalCost = totalCost,
	}

	return true, {
		ghostId = ghostId,
		startLevel = currentLevel,
		targetLevel = targetLevel,
		totalCost = totalCost,
		estimatedTime = self:calculateTotalTrainingTime(ghost, currentLevel, targetLevel),
	}
end

function TrainingSystem:calculateTrainingCost(ghost, level)
	local baseConfig = Config.Training
	local baseCost = baseConfig.BaseTrainingCost or 50
	local multiplier = baseConfig.TrainingCostMultiplier or 2

	-- Apply personality modifier
	local personalityMod = 1.0
	if ghost.personality == "Lazy" then
		personalityMod = 0.7
	elseif ghost.personality == "Hyper" then
		personalityMod = 1.3
	end

	return math.ceil(baseCost * (multiplier ^ (level - 1)) * personalityMod)
end

function TrainingSystem:calculateTrainingTime(ghost, level)
	local baseConfig = Config.Training
	local baseTime = baseConfig.BaseTrainingTime or 300
	local multiplier = baseConfig.TrainingTimeMultiplier or 2

	-- Apply personality modifier
	local personalityMod = 1.0
	if ghost.personality == "Lazy" then
		personalityMod = 1.5
	elseif ghost.personality == "Hyper" then
		personalityMod = 0.5
	end

	return math.ceil(baseTime * (multiplier ^ (level - 1)) * personalityMod)
end

function TrainingSystem:calculateTotalTrainingTime(ghost, startLevel, targetLevel)
	local totalTime = 0
	for level = startLevel, targetLevel - 1 do
		totalTime = totalTime + self:calculateTrainingTime(ghost, level)
	end
	return totalTime
end

function TrainingSystem:tick(player)
	local userId = player.UserId

	if not self.trainingQueue[userId] then return end

	local now = os.time()
	local completed = {}

	for ghostId, training in pairs(self.trainingQueue[userId]) do
		local ghost = self.ghostSystem:getGhost(player, ghostId)
		if not ghost then
			table.insert(completed, ghostId)
		else
			local elapsedTime = now - training.startTime
			local targetTime = self:calculateTotalTrainingTime(ghost, training.currentLevel, training.targetLevel)

			if elapsedTime >= targetTime then
				-- Complete training
				ghost.level = training.targetLevel
				table.insert(completed, ghostId)

				-- Notify client
				local remote = Constants.Paths.ReplicatedStorage:FindChild("Remotes"):FindChild(Constants.Remotes.ShowNotification)
				if remote then
					remote:FireClient(player, "Ghost trained to level " .. training.targetLevel .. "!")
				end
			end
		end
	end

	-- Remove completed trainings
	for _, ghostId in ipairs(completed) do
		self.trainingQueue[userId][ghostId] = nil
	end
end

function TrainingSystem:getTrainingStatus(player, ghostId)
	local userId = player.UserId

	if not self.trainingQueue[userId] or not self.trainingQueue[userId][ghostId] then
		return nil
	end

	local training = self.trainingQueue[userId][ghostId]
	local now = os.time()
	local elapsedTime = now - training.startTime

	return {
		ghostId = ghostId,
		startLevel = training.currentLevel,
		targetLevel = training.targetLevel,
		elapsedTime = elapsedTime,
		totalTime = self:calculateTotalTrainingTime(self.ghostSystem:getGhost(player, ghostId), training.currentLevel, training.targetLevel),
	}
end

function TrainingSystem:cancelTraining(player, ghostId)
	local userId = player.UserId

	if not self.trainingQueue[userId] or not self.trainingQueue[userId][ghostId] then
		return false, "Not training"
	end

	-- Refund 50% of cost
	local training = self.trainingQueue[userId][ghostId]
	local refund = math.floor(training.totalCost * 0.5)

	if self.currencySystem then
		self.currencySystem:addEnergy(player, refund)
	end

	self.trainingQueue[userId][ghostId] = nil
	return true, refund
end

function TrainingSystem:removePlayer(userId)
	self.trainingQueue[userId] = nil
end

return TrainingSystem
