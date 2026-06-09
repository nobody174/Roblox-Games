--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Manages vacuum charge system: accumulation, cap limits, and catch probability calculations.
--
local VacuumSystem = {}
VacuumSystem.__index = VacuumSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function VacuumSystem:new()
	local self = setmetatable({}, VacuumSystem)
	self.playerCharges = {} -- UserId -> charge level (0-100)
	self.lastChargeTime = {} -- UserId -> last charge timestamp
	return self
end

function VacuumSystem:initializePlayer(player)
	local userId = player.UserId
	if not self.playerCharges then
		self.playerCharges = {}
	end
	if not self.lastChargeTime then
		self.lastChargeTime = {}
	end
	self.playerCharges[userId] = 0
	self.lastChargeTime[userId] = 0
end

function VacuumSystem:chargeVacuum(player)
	local userId = player.UserId

	-- Check if player exists
	if not player or not self.playerCharges[userId] then
		return false
	end

	-- Apply charge
	local newCharge = math.min(
		self.playerCharges[userId] + Config.VacuumChargePerClick,
		Config.VacuumMaxCharge
	)

	self.playerCharges[userId] = newCharge
	self.lastChargeTime[userId] = os.clock()

	-- Notify client
	self:notifyChargeUpdate(player, newCharge)

	return true
end

function VacuumSystem:getCharge(player)
	local userId = player.UserId
	if self.playerCharges[userId] then
		return self.playerCharges[userId]
	end
	return 0
end

function VacuumSystem:getCatchChance(player)
	local chargeLevel = self:getCharge(player)
	-- Formula: charge * 0.95 = 100% charge = 95% catch chance
	return math.min(chargeLevel * 0.95, 100) / 100
end

function VacuumSystem:deductCharge(player, amount)
	local userId = player.UserId
	if not self.playerCharges[userId] then
		return false
	end

	local currentCharge = self.playerCharges[userId]
	if currentCharge < amount then
		return false
	end

	local newCharge = math.max(currentCharge - amount, 0)
	self.playerCharges[userId] = newCharge
	self:notifyChargeUpdate(player, newCharge)
	return true
end

function VacuumSystem:resetCharge(player)
	local userId = player.UserId
	self.playerCharges[userId] = 0
	self:notifyChargeUpdate(player, 0)
end

function VacuumSystem:notifyChargeUpdate(player, newCharge)
	-- Fire remote event to update client UI
	local remotesFolder = Constants.Paths.ReplicatedStorage:FindFirstChild("Remotes")
	local remote = remotesFolder and remotesFolder:FindFirstChild(Constants.Remotes.UpdateUI)
	if remote then
		remote:FireClient(player, { VacuumCharge = newCharge })
	end
end

function VacuumSystem:removePlayer(userId)
	self.playerCharges[userId] = nil
	self.lastChargeTime[userId] = nil
end

return VacuumSystem
-- Built with assistance from Claude Code by Anthropic.

