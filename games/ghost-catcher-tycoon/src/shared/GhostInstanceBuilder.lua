--
-- Ghost Catcher Tycoon
-- Author:  nobody174 (nobodylearn174@gmail.com)
-- Repo:    https://github.com/nobody174/roblox-games
-- License: All rights reserved © 2025 nobody174
-- "It's never too late to give up!"
--
-- Creates visible ghost instances in the world: colored spheres with labels and click detection.
--
local GhostInstanceBuilder = {}

-- Rarity colors for visual feedback
local RARITY_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),      -- Gray
	Uncommon = Color3.fromRGB(80, 200, 120),     -- Green
	Rare = Color3.fromRGB(80, 120, 255),         -- Blue
	Epic = Color3.fromRGB(180, 80, 255),         -- Purple
	Legendary = Color3.fromRGB(255, 200, 50),    -- Gold
	Corrupted = Color3.fromRGB(255, 60, 60),     -- Red
}

-- Create a ghost instance in the world
function GhostInstanceBuilder:CreateGhostInstance(stats, parent)
	if not stats or not stats.Name then
		warn("[GhostInstanceBuilder] Invalid stats for creating ghost")
		return nil
	end

	parent = parent or workspace

	-- Create the ghost sphere
	local ghost = Instance.new("Part")
	ghost.Name = stats.Name
	ghost.Shape = Enum.PartType.Ball
	ghost.Size = Vector3.new(2, 2, 2)
	ghost.CanCollide = false
	ghost.Color = RARITY_COLORS[stats.Rarity] or RARITY_COLORS.Common
	ghost.Material = Enum.Material.Neon
	ghost.TopSurface = Enum.SurfaceType.Smooth
	ghost.BottomSurface = Enum.SurfaceType.Smooth
	ghost.Position = stats.Position or Vector3.new(0, 25, 0)  -- Use spawn position from stats
	ghost.Parent = parent

	-- Add BodyVelocity to prevent falling and allow gentle floating
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)  -- Only counteract gravity (Y-axis)
	bodyVelocity.Parent = ghost

	-- Store ghost data as attributes
	ghost:SetAttribute("GhostName", stats.Name)
	ghost:SetAttribute("Rarity", stats.Rarity)
	ghost:SetAttribute("Personality", stats.Personality)
	ghost:SetAttribute("CatchSpeed", stats.CatchSpeed)
	ghost:SetAttribute("EnergyPerMin", stats.EnergyPerMin)
	ghost:SetAttribute("TrainingCostMultiplier", stats.TrainingCostMultiplier)
	ghost:SetAttribute("Level", stats.Level or 1)

	-- Add a label above the ghost
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 150, 0, 50)
	billboardGui.MaxDistance = 200
	billboardGui.Parent = ghost

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = stats.Name
	nameLabel.Parent = billboardGui

	local rarityLabel = Instance.new("TextLabel")
	rarityLabel.Size = UDim2.new(1, 0, 0.5, 0)
	rarityLabel.Position = UDim2.new(0, 0, 0.5, 0)
	rarityLabel.BackgroundTransparency = 1
	rarityLabel.TextColor3 = RARITY_COLORS[stats.Rarity] or RARITY_COLORS.Common
	rarityLabel.TextSize = 12
	rarityLabel.Font = Enum.Font.Gotham
	rarityLabel.Text = stats.Rarity
	rarityLabel.Parent = billboardGui

	-- Add a subtle glow effect
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 2
	pointLight.Range = 15
	pointLight.Color = RARITY_COLORS[stats.Rarity] or RARITY_COLORS.Common
	pointLight.Parent = ghost

	return ghost
end

return GhostInstanceBuilder
-- Built with assistance from Claude Code by Anthropic.
