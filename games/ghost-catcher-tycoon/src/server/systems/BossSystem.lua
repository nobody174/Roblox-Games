--
-- Ghost Catcher Tycoon — Boss System
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--

local BossSystem = {}
BossSystem.__index = BossSystem

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BossData = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("BossData"))
local Config = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("config"))

local BOSS_SPAWN_CHANCE = 0.15
local BOSS_FOLDER = "Bosses"

function BossSystem:new()
	local self = setmetatable({}, BossSystem)
	self.activeBosses = {}
	self.currencySystem = nil
	self.ghostSystem = nil
	self.zoneSystem = nil
	self.dataManager = nil
	return self
end

function BossSystem:setCurrencySystem(currencySystem)
	self.currencySystem = currencySystem
end

function BossSystem:setGhostSystem(ghostSystem)
	self.ghostSystem = ghostSystem
end

function BossSystem:setZoneSystem(zoneSystem)
	self.zoneSystem = zoneSystem
end

function BossSystem:setDataManager(dataManager)
	self.dataManager = dataManager
end

local function getBossForZone(zoneId)
	local candidates = {}

	for bossName, data in pairs(BossData) do
		for _, z in ipairs(data.Zones) do
			if z == zoneId then
				table.insert(candidates, bossName)
			end
		end
	end

	if #candidates == 0 then
		return nil
	end

	return candidates[math.random(1, #candidates)]
end

local function getClosestPlayer(bossModel)
	local closest = nil
	local dist = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local d = (player.Character.HumanoidRootPart.Position - bossModel.PrimaryPart.Position).Magnitude
			if d < dist then
				dist = d
				closest = player
			end
		end
	end

	return closest
end

function BossSystem:trySpawnBoss(player, zoneId)
	if math.random() > BOSS_SPAWN_CHANCE then
		return nil
	end

	local bossName = getBossForZone(zoneId)
	if not bossName then
		return nil
	end

	local bossConfig = BossData[bossName]
	if not bossConfig then
		warn("[BossSystem] Invalid boss config for: " .. bossName)
		return nil
	end

	local bossFolder = workspace:FindFirstChild(BOSS_FOLDER)
	if not bossFolder then
		bossFolder = Instance.new("Folder")
		bossFolder.Name = BOSS_FOLDER
		bossFolder.Parent = workspace
	end

	local bossModel = Instance.new("Part")
	bossModel.Name = bossName
	bossModel.Shape = Enum.PartType.Ball
	bossModel.Size = Vector3.new(2, 2, 2)
	bossModel.CanCollide = true
	bossModel.TopSurface = Enum.SurfaceType.Smooth
	bossModel.BottomSurface = Enum.SurfaceType.Smooth
	bossModel.BrickColor = BrickColor.new("Really red")
	bossModel.Position = Vector3.new(0, 50, 0)
	bossModel.Parent = bossFolder

	bossModel:SetAttribute("BossName", bossName)
	bossModel:SetAttribute("MaxHP", bossConfig.MaxHP)
	bossModel:SetAttribute("HP", bossConfig.MaxHP)
	bossModel:SetAttribute("Damage", bossConfig.Damage)
	bossModel:SetAttribute("AttackCooldown", bossConfig.AttackCooldown)
	bossModel:SetAttribute("EnergyReward", bossConfig.EnergyReward)
	bossModel:SetAttribute("OwnerUserId", player.UserId)

	self:startBossAI(bossModel, player)

	print("[BossSystem] Boss spawned: " .. bossName .. " for zone " .. tostring(zoneId))

	return bossModel
end

function BossSystem:startBossAI(bossModel, owner)
	task.spawn(function()
		local attackCooldown = 0

		while bossModel.Parent do
			local hp = bossModel:GetAttribute("HP")
			if hp <= 0 then
				break
			end

			attackCooldown = attackCooldown - 0.1
			if attackCooldown <= 0 then
				local target = getClosestPlayer(bossModel)
				if target and target.Character and target.Character:FindFirstChild("Humanoid") then
					local humanoid = target.Character.Humanoid
					humanoid:TakeDamage(bossModel:GetAttribute("Damage"))
					attackCooldown = bossModel:GetAttribute("AttackCooldown")
				end
			end

			task.wait(0.1)
		end

		if bossModel.Parent then
			self:onBossDefeated(bossModel, owner)
		end
	end)
end

function BossSystem:takeDamage(bossModel, amount, attacker)
	if not bossModel or not bossModel.Parent then
		return
	end

	local currentHP = bossModel:GetAttribute("HP") or 0
	currentHP = math.max(0, currentHP - amount)
	bossModel:SetAttribute("HP", currentHP)

	if currentHP <= 0 then
		self:onBossDefeated(bossModel, attacker)
	end
end

function BossSystem:onBossDefeated(bossModel, player)
	if not bossModel or not bossModel.Parent then
		return
	end

	local bossName = bossModel:GetAttribute("BossName")
	local config = BossData[bossName]

	if not config then
		warn("[BossSystem] Could not find config for defeated boss: " .. tostring(bossName))
		bossModel:Destroy()
		return
	end

	if self.currencySystem then
		self.currencySystem:addCurrency(player, config.EnergyReward)
		print("[BossSystem] " .. player.Name .. " defeated " .. bossName .. " and earned " .. config.EnergyReward .. " energy")
	end

	-- Track boss kill in DataStore
	if self.dataManager then
		local playerData = self.dataManager:getPlayerData(player)
		if not playerData.BossKills then
			playerData.BossKills = {}
		end
		if not playerData.BossKills[bossName] then
			playerData.BossKills[bossName] = 0
		end
		playerData.BossKills[bossName] = playerData.BossKills[bossName] + 1
		self.dataManager:updatePlayerData(player, { BossKills = playerData.BossKills })
	end

	bossModel:Destroy()
end

return BossSystem

-- Built with assistance from Claude Code by Anthropic.
