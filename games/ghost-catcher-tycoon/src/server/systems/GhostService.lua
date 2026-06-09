--
-- Ghost Catcher Tycoon — Ghost Service
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Ghost inventory management: add/remove ghosts, track player collections, handle lifecycle events.
--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local GhostInstanceBuilder = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("GhostInstanceBuilder"))
local GhostStatGenerator = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("GhostStatGenerator"))

local GhostService = {}
GhostService.__index = GhostService

local INVENTORY_FOLDER_NAME = "GhostInventory"

function GhostService:new()
	local self = setmetatable({}, GhostService)
	return self
end

---------------------------------------------------------------------
-- INTERNAL HELPERS
---------------------------------------------------------------------

local function getInventoryFolder(player)
	local folder = player:FindFirstChild(INVENTORY_FOLDER_NAME)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = INVENTORY_FOLDER_NAME
		folder.Parent = player
	end
	return folder
end

local function createGhostEntry(parent, stats)
	local ghost = Instance.new("Folder")
	ghost.Name = stats.Name
	ghost.Parent = parent

	ghost:SetAttribute("GhostId", HttpService:GenerateGUID(false))
	ghost:SetAttribute("GhostName", stats.Name)
	ghost:SetAttribute("Rarity", stats.Rarity)
	ghost:SetAttribute("CatchSpeed", stats.CatchSpeed)
	ghost:SetAttribute("EnergyPerMin", stats.EnergyPerMin)
	ghost:SetAttribute("TrainingCostMultiplier", stats.TrainingCostMultiplier)
	ghost:SetAttribute("Personality", stats.Personality)
	ghost:SetAttribute("Level", 1)

	return ghost
end

---------------------------------------------------------------------
-- PUBLIC API
---------------------------------------------------------------------

function GhostService:getInventory(player)
	return getInventoryFolder(player):GetChildren()
end

function GhostService:givePlayerGhost(player, stats)
	if not player or not stats or not stats.Name then
		warn("[GhostService] Invalid player or stats")
		return nil
	end

	local folder = getInventoryFolder(player)
	local ghost = createGhostEntry(folder, stats)
	print("[GhostService] " .. player.Name .. " received ghost: " .. stats.Name)
	return ghost
end

function GhostService:givePlayerRandomGhost(player, ghostName)
	local stats = GhostStatGenerator:GenerateStatsForGhost(ghostName)
	if not stats then
		warn("[GhostService] Failed to generate stats for ghost: " .. tostring(ghostName))
		return nil
	end
	return self:givePlayerGhost(player, stats)
end

function GhostService:removeGhost(player, ghostId)
	if not player or not ghostId then
		return false
	end

	local folder = getInventoryFolder(player)
	for _, ghost in ipairs(folder:GetChildren()) do
		if ghost:GetAttribute("GhostId") == ghostId then
			ghost:Destroy()
			print("[GhostService] Removed ghost " .. ghostId .. " from " .. player.Name)
			return true
		end
	end
	return false
end

function GhostService:spawnGhostInWorld(stats, parent)
	if not stats or not stats.Name then
		warn("[GhostService] Invalid stats for spawning ghost")
		return nil
	end

	return GhostInstanceBuilder:CreateGhostInstance(stats, parent or workspace)
end

function GhostService:getGhostById(player, ghostId)
	local folder = getInventoryFolder(player)
	for _, ghost in ipairs(folder:GetChildren()) do
		if ghost:GetAttribute("GhostId") == ghostId then
			return ghost
		end
	end
	return nil
end

function GhostService:getGhostsByRarity(player, rarity)
	local folder = getInventoryFolder(player)
	local ghosts = {}
	for _, ghost in ipairs(folder:GetChildren()) do
		if ghost:GetAttribute("Rarity") == rarity then
			table.insert(ghosts, ghost)
		end
	end
	return ghosts
end

function GhostService:getInventoryCount(player)
	return #getInventoryFolder(player):GetChildren()
end

---------------------------------------------------------------------
-- PLAYER LIFECYCLE
---------------------------------------------------------------------

Players.PlayerAdded:Connect(function(player)
	-- Ensure inventory folder exists on join
	getInventoryFolder(player)
	print("[GhostService] Initialized inventory for " .. player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
	-- TODO: Save inventory to DataStore on player leave
	print("[GhostService] Saving inventory for " .. player.Name)
end)

return GhostService

-- Built with assistance from Claude Code by Anthropic.
