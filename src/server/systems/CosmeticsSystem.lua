--[=[
  Ghost Catcher Tycoon - Cosmetics System
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local CosmeticsSystem = {}
CosmeticsSystem.__index = CosmeticsSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function CosmeticsSystem:new()
	local self = setmetatable({}, CosmeticsSystem)
	self.cosmeticsData = {}
	self.currencySystem = nil
	self.dataManager = nil
	return self
end

function CosmeticsSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function CosmeticsSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

function CosmeticsSystem:initializePlayer(player)
	local userId = player.UserId
	local data = self.dataManager:getPlayerData(player)
	local cosmetics = data.Cosmetics or {
		OwnedSkins = { Default = true },
		EquippedSkin = "Default",
	}
	self.cosmeticsData[userId] = cosmetics
end

function CosmeticsSystem:removePlayer(userId)
	self.cosmeticsData[userId] = nil
end

function CosmeticsSystem:purchaseSkin(player, skinName)
	local userId = player.UserId
	local cosmetics = self.cosmeticsData[userId]

	if not Config.Cosmetics.Skins[skinName] then
		return false, "Skin not found"
	end

	if cosmetics.OwnedSkins[skinName] then
		return false, "Skin already owned"
	end

	local skinConfig = Config.Cosmetics.Skins[skinName]

	if skinConfig.CostType == "energy" then
		if not self.currencySystem:canAfford(player, skinConfig.Cost) then
			return false, "Not enough energy"
		end
		self.currencySystem:removeEnergy(player, skinConfig.Cost)
	elseif skinConfig.CostType == "robux" then
		-- Robux purchases handled by ProductReceiptCallback in MainServer
		return false, "Use Robux purchase system"
	elseif skinConfig.CostType == "free" then
		-- Free skins just get added
	end

	cosmetics.OwnedSkins[skinName] = true
	self.dataManager:updatePlayerData(player, { Cosmetics = cosmetics })
	return true, "Skin purchased"
end

function CosmeticsSystem:equipSkin(player, skinName)
	local userId = player.UserId
	local cosmetics = self.cosmeticsData[userId]

	if not Config.Cosmetics.Skins[skinName] then
		return false, "Skin not found"
	end

	if not cosmetics.OwnedSkins[skinName] then
		return false, "Skin not owned"
	end

	cosmetics.EquippedSkin = skinName
	self.dataManager:updatePlayerData(player, { Cosmetics = cosmetics })
	return true, "Skin equipped"
end

function CosmeticsSystem:getOwnedSkins(player)
	local userId = player.UserId
	local cosmetics = self.cosmeticsData[userId]
	local owned = {}

	for skinName, _ in pairs(cosmetics.OwnedSkins) do
		table.insert(owned, skinName)
	end

	return owned
end

function CosmeticsSystem:getEquippedSkin(player)
	local userId = player.UserId
	return self.cosmeticsData[userId].EquippedSkin or "Default"
end

function CosmeticsSystem:hasSkin(player, skinName)
	local userId = player.UserId
	return self.cosmeticsData[userId].OwnedSkins[skinName] == true
end

function CosmeticsSystem:getAllSkins()
	local skins = {}
	for skinName, config in pairs(Config.Cosmetics.Skins) do
		table.insert(skins, {
			Name = skinName,
			DisplayName = config.DisplayName,
			Cost = config.Cost,
			CostType = config.CostType,
		})
	end
	return skins
end

function CosmeticsSystem:getSkinInfo(skinName)
	return Config.Cosmetics.Skins[skinName]
end

return CosmeticsSystem
