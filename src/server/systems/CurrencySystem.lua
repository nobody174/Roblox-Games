--[=[
  Ghost Catcher Tycoon - Currency System
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local CurrencySystem = {}
CurrencySystem.__index = CurrencySystem

local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))
local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function CurrencySystem:new()
	local self = setmetatable({}, CurrencySystem)
	self.lastTransactionTime = {} -- Track for rate limiting
	return self
end

function CurrencySystem:addEnergy(player, amount, source)
	-- Validate input
	if not player or amount <= 0 then
		return false
	end

	if amount > Constants.Limits.MaxEnergyStorage then
		warn("Energy addition exceeded limit: " .. player.Name)
		amount = Constants.Limits.MaxEnergyStorage
	end

	-- Update player data
	local success = self.dataManager:addEnergy(player, amount)

	if success then
		-- Notify client
		local data = self.dataManager:getPlayerData(player)
		if data then
			self:notifyEnergyChange(player, data.Energy)
		end
	end

	return success
end

function CurrencySystem:removeEnergy(player, amount, source)
	-- Validate input
	if not player or amount <= 0 then
		return false
	end

	-- Check if player has enough energy
	if not self:canAfford(player, amount) then
		return false
	end

	-- Remove energy
	local success = self.dataManager:removeEnergy(player, amount)

	if success then
		-- Notify client
		local data = self.dataManager:getPlayerData(player)
		if data then
			self:notifyEnergyChange(player, data.Energy)
		end
	end

	return success
end

function CurrencySystem:getEnergy(player)
	return self.dataManager:getEnergy(player)
end

function CurrencySystem:canAfford(player, cost)
	local currentEnergy = self:getEnergy(player)
	return currentEnergy >= cost
end

function CurrencySystem:notifyEnergyChange(player, newEnergy)
	-- Fire remote event to update client UI
	local remote = Constants.Paths.ReplicatedStorage:FindChild(Constants.Remotes.UpdateUI)
	if remote then
		remote:FireClient(player, { Energy = newEnergy })
	end
end

function CurrencySystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

return CurrencySystem
