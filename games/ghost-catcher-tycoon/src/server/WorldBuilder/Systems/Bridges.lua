--==============================--
-- BRIDGES SYSTEM
--==============================--
-- Creates wooden bridges connecting islands
-- All 5 bridges are built in sequence with consistent styling
--==============================--

--==============================--
-- BRIDGE DATA
--==============================--

local BRIDGES = {
	{name = "Bridge_1", startPos = Vector3.new(125, 12, 0), endPos = Vector3.new(325, 12, 0), width = 10},
	{name = "Bridge_2", startPos = Vector3.new(0, 12, 125), endPos = Vector3.new(0, 12, 375), width = 10},
	{name = "Bridge_3", startPos = Vector3.new(-100, 12, 0), endPos = Vector3.new(-400, 12, 0), width = 10},
	{name = "Bridge_4", startPos = Vector3.new(0, 12, 625), endPos = Vector3.new(0, 12, 875), width = 10},
	{name = "Bridge_5", startPos = Vector3.new(0, 12, 1125), endPos = Vector3.new(0, 12, 1375), width = 10},
}

--==============================--
-- BRIDGE CREATION
--==============================--

local function createBridge(startPos, endPos, width)
	-- Create a single wooden bridge between two positions
	-- Automatically orients the bridge to connect start and end positions
	-- Parameters:
	--   startPos: Vector3 starting position
	--   endPos: Vector3 ending position
	--   width: studs wide
	-- Returns: Part (the bridge)

	local distance = (endPos - startPos).Magnitude
	local midpoint = (startPos + endPos) / 2

	local bridge = Instance.new("Part")
	bridge.Name = "Bridge"
	bridge.Size = Vector3.new(width, 2, distance)
	bridge.Color = Color3.fromRGB(139, 69, 19)
	bridge.Material = Enum.Material.Wood
	bridge.TopSurface = Enum.SurfaceType.Smooth
	bridge.BottomSurface = Enum.SurfaceType.Smooth
	bridge.CanCollide = true
	bridge.Anchored = true

	-- Orient bridge to point from start to end
	bridge.CFrame = CFrame.lookAlong(midpoint, (endPos - startPos).Unit)

	return bridge
end

--==============================--
-- ALL BRIDGES CREATION
--==============================--

local function createAllBridges(parentFolder)
	-- Create all 5 bridges and parent them to the provided folder
	-- Parameters: parentFolder (Folder to parent all bridges to)

	local bridgesFolder = Instance.new("Folder")
	bridgesFolder.Name = "Bridges"
	bridgesFolder.Parent = parentFolder

	for _, bridgeData in ipairs(BRIDGES) do
		local bridge = createBridge(bridgeData.startPos, bridgeData.endPos, bridgeData.width)
		bridge.Name = bridgeData.name
		bridge.Parent = bridgesFolder

		print("[WorldBuilder] ✅ Bridge created: " .. bridgeData.name .. " (" .. math.floor((bridgeData.endPos - bridgeData.startPos).Magnitude) .. " studs)")
	end

	return bridgesFolder
end

--==============================--
-- EXPORTS
--==============================--

return {
	createBridge = createBridge,
	createAllBridges = createAllBridges,
}
