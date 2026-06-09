--
-- Ghost Catcher Tycoon - Ghost AI Behavior
-- Scales ghost behavior based on rarity tier
--

local GhostAI = {}

-- Rarity tiers define how ghosts behave
local rarityBehavior = {
	Common = {
		speed = 0,           -- Stationary
		evasion = 0,         -- No evasion
		behavior = "stationary",
		description = "Stands still, easy to catch"
	},
	Uncommon = {
		speed = 5,           -- Slow movement
		evasion = 0.1,       -- 10% chance to dodge
		behavior = "wander",
		description = "Wanders slowly, occasionally dodges"
	},
	Rare = {
		speed = 12,          -- Medium movement
		evasion = 0.25,      -- 25% chance to dodge
		behavior = "flee",
		description = "Flees from player, frequently dodges"
	},
	Epic = {
		speed = 20,          -- Fast movement
		evasion = 0.4,       -- 40% chance to dodge
		behavior = "aggressive_flee",
		description = "Rapidly flees, very hard to catch"
	},
	Legendary = {
		speed = 18,          -- Fast
		evasion = 0.45,      -- 45% chance to dodge
		behavior = "teleport_flee",
		description = "Teleports and flees, very challenging"
	},
	Corrupted = {
		speed = 25,          -- Very fast
		evasion = 0.6,       -- 60% chance to dodge
		behavior = "aggressive_teleport",
		description = "Aggressively dodges and teleports, extremely challenging"
	}
}

-- Initialize ghost AI behavior
function GhostAI:initializeGhost(ghostModel, ghostRarity)
	if not ghostModel or not ghostModel:FindFirstChild("Body") then
		return
	end

	local body = ghostModel:FindFirstChild("Body")
	local behavior = rarityBehavior[ghostRarity] or rarityBehavior.Common

	-- Store AI data on the ghost
	body:SetAttribute("AISpeed", behavior.speed)
	body:SetAttribute("AIEvasion", behavior.evasion)
	body:SetAttribute("AIBehavior", behavior.behavior)
	body:SetAttribute("Rarity", ghostRarity)

	-- Start behavior loop if ghost has movement
	if behavior.speed > 0 then
		task.spawn(function()
			self:ghostBehaviorLoop(ghostModel, behavior)
		end)
	end
end

-- Main behavior loop for moving ghosts
function GhostAI:ghostBehaviorLoop(ghostModel, behavior)
	local body = ghostModel:FindFirstChild("Body")
	if not body then return end

	local bodyVelocity = body:FindFirstChild("BodyVelocity")
	if not bodyVelocity then return end

	local wanderCycle = 0
	local changeDirectionInterval = math.random(5, 10)  -- Change direction every 5-10 updates

	while ghostModel.Parent and body.Parent do
		task.wait(0.2)  -- Reduced frequency (0.1 -> 0.2) to reduce lag

		wanderCycle = wanderCycle + 1

		-- Change direction periodically
		if wanderCycle >= changeDirectionInterval then
			wanderCycle = 0
			changeDirectionInterval = math.random(30, 60)
		end

		if behavior.behavior == "stationary" then
			-- Do nothing, stay in place
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)

		elseif behavior.behavior == "wander" then
			-- Random wandering movement
			local randomDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
			bodyVelocity.Velocity = randomDir * behavior.speed

		elseif behavior.behavior == "flee" then
			-- Flee from nearby players
			local nearbyPlayers = self:findNearbyPlayers(body.Position, 50)
			if #nearbyPlayers > 0 then
				local closestPlayer = nearbyPlayers[1]
				local fleeDirection = (body.Position - closestPlayer.position).Unit
				bodyVelocity.Velocity = fleeDirection * behavior.speed
			else
				-- Wander if no players nearby
				local randomDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
				bodyVelocity.Velocity = randomDir * (behavior.speed * 0.5)
			end

		elseif behavior.behavior == "aggressive_flee" then
			-- Aggressively flee from players at greater distance
			local nearbyPlayers = self:findNearbyPlayers(body.Position, 80)
			if #nearbyPlayers > 0 then
				local closestPlayer = nearbyPlayers[1]
				local fleeDirection = (body.Position - closestPlayer.position).Unit
				bodyVelocity.Velocity = fleeDirection * behavior.speed
			else
				local randomDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
				bodyVelocity.Velocity = randomDir * (behavior.speed * 0.7)
			end

		elseif behavior.behavior == "teleport_flee" then
			-- Teleport away from players (less frequently to reduce lag)
			local nearbyPlayers = self:findNearbyPlayers(body.Position, 70)
			if #nearbyPlayers > 0 and math.random() < 0.05 then  -- 5% chance to teleport (reduced from 10%)
				local closestPlayer = nearbyPlayers[1]
				local teleportDir = (body.Position - closestPlayer.position).Unit
				local newPos = body.Position + teleportDir * math.random(20, 40)
				body.Position = newPos
			else
				local randomDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
				bodyVelocity.Velocity = randomDir * behavior.speed
			end

		elseif behavior.behavior == "aggressive_teleport" then
			-- Aggressively teleport away (less frequently to reduce lag)
			local nearbyPlayers = self:findNearbyPlayers(body.Position, 80)
			if #nearbyPlayers > 0 then
				if math.random() < 0.08 then  -- 8% chance to teleport (reduced from 15%)
					local closestPlayer = nearbyPlayers[1]
					local teleportDir = (body.Position - closestPlayer.position).Unit
					local newPos = body.Position + teleportDir * math.random(30, 50)
					body.Position = newPos
				else
					local closestPlayer = nearbyPlayers[1]
					local fleeDirection = (body.Position - closestPlayer.position).Unit
					bodyVelocity.Velocity = fleeDirection * behavior.speed
				end
			else
				local randomDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
				bodyVelocity.Velocity = randomDir * (behavior.speed * 0.7)
			end
		end
	end
end

-- Find players within range
function GhostAI:findNearbyPlayers(position, range)
	local Players = game:GetService("Players")
	local nearbyPlayers = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local distance = (position - hrp.Position).Magnitude
			if distance <= range then
				table.insert(nearbyPlayers, {
					player = player,
					position = hrp.Position,
					distance = distance
				})
			end
		end
	end

	-- Sort by distance (closest first)
	table.sort(nearbyPlayers, function(a, b)
		return a.distance < b.distance
	end)

	return nearbyPlayers
end

-- Get evasion chance for a ghost
function GhostAI:getEvasionChance(ghostBody)
	if not ghostBody then return 0 end
	return ghostBody:GetAttribute("AIEvasion") or 0
end

return GhostAI
