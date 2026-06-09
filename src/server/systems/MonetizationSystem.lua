--[=[
  Ghost Catcher Tycoon - Monetization System
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local MonetizationSystem = {}
MonetizationSystem.__index = MonetizationSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))
local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("constants"))

function MonetizationSystem:new()
	local self = setmetatable({}, MonetizationSystem)
	self.playerGamePasses = {} -- UserId -> { PassName: true/false }
	self.playerProducts = {} -- UserId -> { ProductName: count }
	self.currencySystem = nil
	self.ghostSystem = nil
	return self
end

function MonetizationSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function MonetizationSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function MonetizationSystem:initializePlayer(player)
	local userId = player.UserId
	self.playerGamePasses[userId] = {}
	self.playerProducts[userId] = {}

	-- Initialize GamePass flags
	for passName, _ in pairs(Config.GamePasses) do
		self.playerGamePasses[userId][passName] = false
	end

	-- Initialize product counts
	for productName, _ in pairs(Config.Products) do
		self.playerProducts[userId][productName] = 0
	end
end

function MonetizationSystem:grantGamePass(player, passName)
	local userId = player.UserId

	if not self.playerGamePasses[userId] then
		self:initializePlayer(player)
	end

	if not Config.GamePasses[passName] then
		return false, "GamePass not found"
	end

	if self.playerGamePasses[userId][passName] then
		return false, "Already owns pass"
	end

	self.playerGamePasses[userId][passName] = true

	-- Apply pass benefits
	self:applyGamePassBenefit(player, passName)

	return true, Config.GamePasses[passName]
end

function MonetizationSystem:applyGamePassBenefit(player, passName)
	local passConfig = Config.GamePasses[passName]
	if not passConfig then return end

	-- Benefits are applied dynamically via system checks
	-- e.g., ProductionSystem checks for DoubleEnergy
end

function MonetizationSystem:hasGamePass(player, passName)
	local userId = player.UserId
	if not self.playerGamePasses[userId] then
		self:initializePlayer(player)
	end
	return self.playerGamePasses[userId][passName] or false
end

function MonetizationSystem:getGamePassBonus(player, passName)
	if not self:hasGamePass(player, passName) then
		return 1.0
	end

	-- Define bonuses for each pass
	if passName == "DoubleEnergy" then
		return 2.0
	elseif passName == "Faster Vacuum" then
		return 2.0
	elseif passName == "ExtraStorage" then
		return 2.0
	end

	return 1.0
end

function MonetizationSystem:purchaseProduct(player, productName, quantity)
	local userId = player.UserId

	if not self.playerProducts[userId] then
		self:initializePlayer(player)
	end

	local productConfig = Config.Products[productName]
	if not productConfig then
		return false, "Product not found"
	end

	if not self.currencySystem then
		return false, "Currency system not initialized"
	end

	-- Apply product effect
	if productName == "EnergyPack" then
		local amount = (productConfig.Amount or 1000) * quantity
		self.currencySystem:addEnergy(player, amount)
		return true, { product = productName, amount = amount }

	elseif productName == "GhostEgg" then
		-- Create random ghost for each egg
		if not self.ghostSystem then
			return false, "Ghost system not initialized"
		end

		local zone = "Forest" -- Default zone
		for i = 1, quantity do
			local ghost = self.ghostSystem:spawnGhost(zone)
			self.ghostSystem:addGhost(player, ghost)
		end
		return true, { product = productName, quantity = quantity }

	elseif productName == "BossTicket" then
		self.playerProducts[userId][productName] = (self.playerProducts[userId][productName] or 0) + quantity
		return true, { product = productName, quantity = quantity }

	elseif productName == "TrainingBoost" then
		self.playerProducts[userId][productName] = (self.playerProducts[userId][productName] or 0) + quantity
		return true, { product = productName, quantity = quantity }
	end

	return false, "Unknown product"
end

function MonetizationSystem:getProductCount(player, productName)
	local userId = player.UserId
	if not self.playerProducts[userId] then
		self:initializePlayer(player)
	end
	return self.playerProducts[userId][productName] or 0
end

function MonetizationSystem:consumeProduct(player, productName, quantity)
	local userId = player.UserId

	if not self.playerProducts[userId] then
		self:initializePlayer(player)
	end

	local current = self.playerProducts[userId][productName] or 0
	if current < quantity then
		return false, "Not enough of product"
	end

	self.playerProducts[userId][productName] = current - quantity
	return true, current - quantity
end

function MonetizationSystem:getPlayerMonetizationData(player)
	local userId = player.UserId

	if not self.playerGamePasses[userId] then
		self:initializePlayer(player)
	end

	local passes = {}
	for passName, owned in pairs(self.playerGamePasses[userId]) do
		if owned then
			table.insert(passes, passName)
		end
	end

	local products = {}
	for productName, count in pairs(self.playerProducts[userId]) do
		if count > 0 then
			products[productName] = count
		end
	end

	return {
		gamePasses = passes,
		products = products,
	}
end

function MonetizationSystem:removePlayer(userId)
	self.playerGamePasses[userId] = nil
	self.playerProducts[userId] = nil
end

return MonetizationSystem
