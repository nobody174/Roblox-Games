--
-- Player Inventory System — Ghost Catcher Tycoon
-- Manages player equipment ownership and equipped item
--

local PlayerInventory = {}

-- Store player inventories: [userId] = {equippedEquipment, ownedEquipment}
local inventories = {}

-- Initialize player inventory on join
function PlayerInventory:initializePlayer(userId)
	if not inventories[userId] then
		inventories[userId] = {
			equipped = "BasicNet", -- Start with basic net
			owned = {
				BasicNet = true,
			},
			level = 1,
			coins = 0,
			energy = 100,
			maxEnergy = 150,
		}
	end
	return inventories[userId]
end

-- Get player inventory
function PlayerInventory:getInventory(userId)
	if not inventories[userId] then
		self:initializePlayer(userId)
	end
	return inventories[userId]
end

-- Get equipped equipment name
function PlayerInventory:getEquipped(userId)
	local inv = self:getInventory(userId)
	return inv.equipped
end

-- Set equipped equipment
function PlayerInventory:setEquipped(userId, equipmentName)
	local inv = self:getInventory(userId)
	if inv.owned[equipmentName] then
		inv.equipped = equipmentName
		return true
	end
	return false
end

-- Check if player owns equipment
function PlayerInventory:ownsEquipment(userId, equipmentName)
	local inv = self:getInventory(userId)
	return inv.owned[equipmentName] or false
end

-- Add equipment to player inventory
function PlayerInventory:addEquipment(userId, equipmentName)
	local inv = self:getInventory(userId)
	inv.owned[equipmentName] = true
end

-- Get all owned equipment
function PlayerInventory:getOwnedEquipment(userId)
	local inv = self:getInventory(userId)
	local owned = {}
	for equipmentName, hasIt in pairs(inv.owned) do
		if hasIt then
			table.insert(owned, equipmentName)
		end
	end
	return owned
end

-- Get player level
function PlayerInventory:getLevel(userId)
	local inv = self:getInventory(userId)
	return inv.level
end

-- Set player level
function PlayerInventory:setLevel(userId, level)
	local inv = self:getInventory(userId)
	inv.level = level
end

-- Get player coins
function PlayerInventory:getCoins(userId)
	local inv = self:getInventory(userId)
	return inv.coins
end

-- Add coins to player
function PlayerInventory:addCoins(userId, amount)
	local inv = self:getInventory(userId)
	inv.coins = inv.coins + amount
	return inv.coins
end

-- Remove coins from player (for purchasing equipment)
function PlayerInventory:removeCoins(userId, amount)
	local inv = self:getInventory(userId)
	if inv.coins >= amount then
		inv.coins = inv.coins - amount
		return true
	end
	return false
end

-- Get player energy
function PlayerInventory:getEnergy(userId)
	local inv = self:getInventory(userId)
	return inv.energy
end

-- Set player energy
function PlayerInventory:setEnergy(userId, energy)
	local inv = self:getInventory(userId)
	inv.energy = math.min(energy, inv.maxEnergy)
	return inv.energy
end

-- Remove energy (for catch attempts)
function PlayerInventory:removeEnergy(userId, amount)
	local inv = self:getInventory(userId)
	if inv.energy >= amount then
		inv.energy = inv.energy - amount
		return true
	end
	return false
end

-- Get max energy
function PlayerInventory:getMaxEnergy(userId)
	local inv = self:getInventory(userId)
	return inv.maxEnergy
end

-- Increase max energy (skill bonus)
function PlayerInventory:increaseMaxEnergy(userId, amount)
	local inv = self:getInventory(userId)
	inv.maxEnergy = inv.maxEnergy + amount
	if inv.energy > inv.maxEnergy then
		inv.energy = inv.maxEnergy
	end
end

-- Check if player can attempt catch
function PlayerInventory:canAttemptCatch(userId, energyCost)
	local inv = self:getInventory(userId)
	return inv.energy >= energyCost
end

-- Clean up on player leave
function PlayerInventory:removePlayer(userId)
	inventories[userId] = nil
end

return PlayerInventory
