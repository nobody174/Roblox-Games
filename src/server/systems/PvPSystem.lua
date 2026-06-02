--[=[
  Ghost Catcher Tycoon - PvP System
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local PvPSystem = {}
PvPSystem.__index = PvPSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function PvPSystem:new()
	local self = setmetatable({}, PvPSystem)
	self.pvpData = {}
	self.ghostSystem = nil
	self.currencySystem = nil
	self.dataManager = nil
	return self
end

function PvPSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function PvPSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function PvPSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function PvPSystem:initializePlayer(player)
	local userId = player.UserId
	local data = self.dataManager:getPlayerData(player)
	local pvpData = data.PvP or {
		LastBattleTime = 0,
		Wins = 0,
		Losses = 0,
		Rating = 1000,
	}
	self.pvpData[userId] = pvpData
end

function PvPSystem:removePlayer(userId)
	self.pvpData[userId] = nil
end

function PvPSystem:_calculateGhostPower(ghost)
	if not ghost then
		return 0
	end
	local rarity = ghost.Rarity or "Common"
	local basePower = Config.PvP.RarityPowerWeights[rarity] or 1
	local levelBonus = (ghost.Level or 1) * 10
	return basePower + levelBonus
end

function PvPSystem:_calculateTeamPower(ghosts)
	local totalPower = 0
	for _, ghost in ipairs(ghosts or {}) do
		totalPower = totalPower + self:_calculateGhostPower(ghost)
	end
	return totalPower
end

function PvPSystem:canBattle(player)
	local userId = player.UserId
	local now = os.time()
	local lastBattle = self.pvpData[userId].LastBattleTime or 0
	local timeSinceLastBattle = now - lastBattle

	if timeSinceLastBattle < Config.PvP.BattleCooldown then
		return false, "Battle on cooldown"
	end

	local ghosts = self.ghostSystem:getPlayerGhosts(player)
	if not ghosts or #ghosts == 0 then
		return false, "No ghosts to battle with"
	end

	return true, "ok"
end

function PvPSystem:startBattle(attacker, defender)
	local canAttack, reason = self:canBattle(attacker)
	if not canAttack then
		return false, reason
	end

	local canDefend, defenseReason = self:canBattle(defender)
	if not canDefend then
		return false, "Defender: " .. defenseReason
	end

	local attackerGhosts = self.ghostSystem:getPlayerGhosts(attacker)
	local defenderGhosts = self.ghostSystem:getPlayerGhosts(defender)

	local attackerPower = self:_calculateTeamPower(attackerGhosts)
	local defenderPower = self:_calculateTeamPower(defenderGhosts)

	local attacker_UserId = attacker.UserId
	local defender_UserId = defender.UserId

	-- Determine winner based on power with some randomness
	local powerDiff = attackerPower - defenderPower
	local winChance = 0.5 + (powerDiff / (attackerPower + defenderPower + 1)) * 0.3

	local attackerWins = math.random() < winChance

	-- Process rewards
	if attackerWins then
		self:_processVictory(attacker, defender, attackerPower, defenderPower)
		self.pvpData[attacker_UserId].Wins = self.pvpData[attacker_UserId].Wins + 1
		self.pvpData[defender_UserId].Losses = self.pvpData[defender_UserId].Losses + 1
	else
		self:_processVictory(defender, attacker, defenderPower, attackerPower)
		self.pvpData[defender_UserId].Wins = self.pvpData[defender_UserId].Wins + 1
		self.pvpData[attacker_UserId].Losses = self.pvpData[attacker_UserId].Losses + 1
	end

	-- Set cooldown
	local now = os.time()
	self.pvpData[attacker_UserId].LastBattleTime = now
	self.pvpData[defender_UserId].LastBattleTime = now

	-- Persist
	self.dataManager:updatePlayerData(attacker, { PvP = self.pvpData[attacker_UserId] })
	self.dataManager:updatePlayerData(defender, { PvP = self.pvpData[defender_UserId] })

	return true, {
		Winner = attackerWins and attacker.UserId or defender.UserId,
		AttackerPower = attackerPower,
		DefenderPower = defenderPower,
		Reward = math.floor(defenderPower * Config.PvP.WinnerEnergyPercent),
	}
end

function PvPSystem:_processVictory(winner, loser, winnerPower, loserPower)
	-- Winner gains energy equal to loser's power * percentage
	local energyGain = math.floor(loserPower * Config.PvP.WinnerEnergyPercent)
	self.currencySystem:addEnergy(winner, energyGain)
end

function PvPSystem:getPlayerStats(player)
	return self.pvpData[player.UserId]
end

function PvPSystem:getPlayerRating(player)
	return self.pvpData[player.UserId].Rating or 1000
end

function PvPSystem:getPlayerWins(player)
	return self.pvpData[player.UserId].Wins or 0
end

function PvPSystem:getPlayerLosses(player)
	return self.pvpData[player.UserId].Losses or 0
end

function PvPSystem:getWinRate(player)
	local wins = self:getPlayerWins(player)
	local losses = self:getPlayerLosses(player)
	local total = wins + losses

	if total == 0 then
		return 0
	end

	return wins / total
end

function PvPSystem:getTimeSinceLastBattle(player)
	local now = os.time()
	local lastBattle = self.pvpData[player.UserId].LastBattleTime or 0
	return now - lastBattle
end

return PvPSystem
