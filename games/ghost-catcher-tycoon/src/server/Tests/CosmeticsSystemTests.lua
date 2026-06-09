--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved Â© 2025 nobody174
-- "It's never too late to give up!"
--
local CosmeticsSystemTests = {}

local function createMockDataManager()
	local mock = {}
	function mock:getPlayerData(player)
		return {
			Cosmetics = {
				OwnedSkins = { Default = true },
				EquippedSkin = "Default",
			},
		}
	end
	function mock:updatePlayerData(player, data)
		-- Mock save
	end
	return mock
end

local function createMockCurrencySystem()
	local mock = {}
	function mock:canAfford(player, amount)
		return true
	end
	function mock:removeEnergy(player, amount)
		-- Mock deduction
	end
	return mock
end

local function createMockPlayer(userId)
	return {
		UserId = userId or 1,
		Name = "TestPlayer",
	}
end

function CosmeticsSystemTests:testInitializePlayer()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	assert(cosmeticsSystem.cosmeticsData[1] ~= nil, "Cosmetics data should be initialized")
	assert(cosmeticsSystem.cosmeticsData[1].EquippedSkin == "Default", "Default skin should be equipped")
	assert(cosmeticsSystem.cosmeticsData[1].OwnedSkins["Default"] == true, "Default skin should be owned")
	print("[PASS] testInitializePlayer")
end

function CosmeticsSystemTests:testRemovePlayer()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)
	cosmeticsSystem:removePlayer(1)

	assert(cosmeticsSystem.cosmeticsData[1] == nil, "Cosmetics data should be removed")
	print("[PASS] testRemovePlayer")
end

function CosmeticsSystemTests:testPurchaseSkinWithEnergy()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, message = cosmeticsSystem:purchaseSkin(player, "Neon")
	assert(success == true, "Purchase should succeed")
	assert(cosmeticsSystem.cosmeticsData[1].OwnedSkins["Neon"] == true, "Skin should be owned after purchase")
	print("[PASS] testPurchaseSkinWithEnergy")
end

function CosmeticsSystemTests:testPurchaseSkinAlreadyOwned()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, reason = cosmeticsSystem:purchaseSkin(player, "Default")
	assert(success == false, "Cannot purchase owned skin")
	assert(reason == "Skin already owned", "Should indicate already owned")
	print("[PASS] testPurchaseSkinAlreadyOwned")
end

function CosmeticsSystemTests:testPurchaseSkinInvalidName()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, reason = cosmeticsSystem:purchaseSkin(player, "InvalidSkin")
	assert(success == false, "Invalid skin should fail")
	assert(reason == "Skin not found", "Should indicate not found")
	print("[PASS] testPurchaseSkinInvalidName")
end

function CosmeticsSystemTests:testPurchaseSkinInsufficientFunds()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())

	local mockCurrency = createMockCurrencySystem()
	function mockCurrency:canAfford(player, amount)
		return false
	end
	cosmeticsSystem:setCurrencySystem(mockCurrency)

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, reason = cosmeticsSystem:purchaseSkin(player, "GhostKing")
	assert(success == false, "Should fail without funds")
	assert(reason == "Not enough energy", "Should indicate insufficient funds")
	print("[PASS] testPurchaseSkinInsufficientFunds")
end

function CosmeticsSystemTests:testEquipSkin()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	-- Purchase skin first
	cosmeticsSystem:purchaseSkin(player, "Neon")

	-- Then equip
	local success, message = cosmeticsSystem:equipSkin(player, "Neon")
	assert(success == true, "Equip should succeed")
	assert(cosmeticsSystem.cosmeticsData[1].EquippedSkin == "Neon", "Equipped skin should be Neon")
	print("[PASS] testEquipSkin")
end

function CosmeticsSystemTests:testEquipSkinNotOwned()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, reason = cosmeticsSystem:equipSkin(player, "GhostKing")
	assert(success == false, "Cannot equip unowned skin")
	assert(reason == "Skin not owned", "Should indicate not owned")
	print("[PASS] testEquipSkinNotOwned")
end

function CosmeticsSystemTests:testEquipSkinInvalid()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local success, reason = cosmeticsSystem:equipSkin(player, "InvalidSkin")
	assert(success == false, "Invalid skin should fail")
	assert(reason == "Skin not found", "Should indicate not found")
	print("[PASS] testEquipSkinInvalid")
end

function CosmeticsSystemTests:testGetOwnedSkins()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	cosmeticsSystem:purchaseSkin(player, "Neon")
	cosmeticsSystem:purchaseSkin(player, "Sparkle")

	local owned = cosmeticsSystem:getOwnedSkins(player)
	assert(#owned >= 3, "Should own at least 3 skins")
	print("[PASS] testGetOwnedSkins")
end

function CosmeticsSystemTests:testGetEquippedSkin()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	local equipped = cosmeticsSystem:getEquippedSkin(player)
	assert(equipped == "Default", "Default skin should be equipped initially")

	cosmeticsSystem:purchaseSkin(player, "Neon")
	cosmeticsSystem:equipSkin(player, "Neon")

	equipped = cosmeticsSystem:getEquippedSkin(player)
	assert(equipped == "Neon", "Equipped skin should be Neon")
	print("[PASS] testGetEquippedSkin")
end

function CosmeticsSystemTests:testHasSkin()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()
	cosmeticsSystem:setDataManager(createMockDataManager())
	cosmeticsSystem:setCurrencySystem(createMockCurrencySystem())

	local player = createMockPlayer(1)
	cosmeticsSystem:initializePlayer(player)

	assert(cosmeticsSystem:hasSkin(player, "Default") == true, "Should have default skin")
	assert(cosmeticsSystem:hasSkin(player, "GhostKing") == false, "Should not have GhostKing")

	cosmeticsSystem:purchaseSkin(player, "GhostKing")
	assert(cosmeticsSystem:hasSkin(player, "GhostKing") == true, "Should have GhostKing after purchase")
	print("[PASS] testHasSkin")
end

function CosmeticsSystemTests:testGetAllSkins()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()

	local skins = cosmeticsSystem:getAllSkins()
	assert(#skins > 0, "Should return all skins")
	assert(skins[1].Name ~= nil, "Skin should have name")
	assert(skins[1].Cost ~= nil, "Skin should have cost")
	print("[PASS] testGetAllSkins")
end

function CosmeticsSystemTests:testGetSkinInfo()
	local CosmeticsSystem = require(game:GetService("ServerScriptService"):WaitForChild("CosmeticsSystem"))
	local cosmeticsSystem = CosmeticsSystem:new()

	local skinInfo = cosmeticsSystem:getSkinInfo("Default")
	assert(skinInfo ~= nil, "Should return skin info")
	assert(skinInfo.DisplayName == "Default", "DisplayName should match")

	local invalidInfo = cosmeticsSystem:getSkinInfo("InvalidSkin")
	assert(invalidInfo == nil, "Invalid skin should return nil")
	print("[PASS] testGetSkinInfo")
end

function CosmeticsSystemTests:runAll()
	print("\n[TEST SUITE] CosmeticsSystem Tests")
	self:testInitializePlayer()
	self:testRemovePlayer()
	self:testPurchaseSkinWithEnergy()
	self:testPurchaseSkinAlreadyOwned()
	self:testPurchaseSkinInvalidName()
	self:testPurchaseSkinInsufficientFunds()
	self:testEquipSkin()
	self:testEquipSkinNotOwned()
	self:testEquipSkinInvalid()
	self:testGetOwnedSkins()
	self:testGetEquippedSkin()
	self:testHasSkin()
	self:testGetAllSkins()
	self:testGetSkinInfo()
	print("[TEST SUITE] CosmeticsSystem Tests - All passed!\n")
end

return CosmeticsSystemTests
-- Built with assistance from Claude Code by Anthropic.

