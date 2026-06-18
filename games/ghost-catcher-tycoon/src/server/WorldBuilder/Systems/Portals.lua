--==============================--
-- PORTALS SYSTEM
--==============================--
-- Creates glowing neon portals for zone transitions
-- Portals guide players between islands with visual feedback
--==============================--

--==============================--
-- PORTAL DATA
--==============================--

local PORTALS = {
	{pos = Vector3.new(500, 35, 150), name = "Meadow_to_Desert", target = "Desert"},
	{pos = Vector3.new(0, 35, 625), name = "Desert_to_Frost", target = "Frost"},
	{pos = Vector3.new(0, 35, 1250), name = "Frost_to_Tech", target = "Tech"},
	{pos = Vector3.new(-500, 35, 150), name = "Haunted_to_Boss", target = "Boss Arena"},
	{pos = Vector3.new(0, 35, 1650), name = "Tech_to_Boss", target = "Boss Arena"},
}

--==============================--
-- PORTAL CREATION
--==============================--

local function createPortal(position, name)
	-- Create a single glowing neon portal sphere
	-- Parameters:
	--   position: Vector3 where portal appears
	--   name: string identifier
	-- Returns: Part (the portal sphere)

	local portal = Instance.new("Part")
	portal.Name = "Portal_" .. name
	portal.Shape = Enum.PartType.Ball
	portal.Size = Vector3.new(5, 5, 5)
	portal.Color = Color3.fromRGB(0, 255, 255)
	portal.Material = Enum.Material.Neon
	portal.CanCollide = false
	portal.CFrame = CFrame.new(position)
	portal.TopSurface = Enum.SurfaceType.Smooth
	portal.BottomSurface = Enum.SurfaceType.Smooth

	-- Add atmospheric glow
	local light = Instance.new("PointLight")
	light.Brightness = 3
	light.Range = 20
	light.Color = Color3.fromRGB(0, 255, 255)
	light.Parent = portal

	return portal
end

--==============================--
-- ALL PORTALS CREATION
--==============================--

local function createAllPortals(parentFolder)
	-- Create all 5 portals and parent them to the provided folder
	-- Parameters: parentFolder (Folder to parent all portals to)

	local portalsFolder = Instance.new("Folder")
	portalsFolder.Name = "Portals"
	portalsFolder.Parent = parentFolder

	print("[WorldBuilder] DEBUG: Starting portal creation, parent: " .. parentFolder.Name)

	for _, portalData in ipairs(PORTALS) do
		local portal = createPortal(portalData.pos, portalData.name)
		print("[WorldBuilder] DEBUG: Portal created at " .. tostring(portalData.pos) .. ", before parenting")
		portal.Parent = portalsFolder
		print("[WorldBuilder] DEBUG: Portal parented to portalsFolder")

		print("[WorldBuilder] ✅ Portal created: " .. portalData.name)
	end

	print("[WorldBuilder] DEBUG: All portals created, portalsFolder children count: " .. #portalsFolder:GetChildren())
	return portalsFolder
end

--==============================--
-- EXPORTS
--==============================--

return {
	createPortal = createPortal,
	createAllPortals = createAllPortals,
}
