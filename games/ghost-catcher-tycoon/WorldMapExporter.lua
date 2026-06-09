--
-- Ghost Catcher Tycoon - World Map Exporter
-- Run this in Studio's Command Bar or as a Script to export zone data as JSON
-- Output: world_map.json with all zones, bridges, boss arenas, and connections
--

local function tableToJson(tbl, indent)
	indent = indent or 0
	local indentStr = string.rep("  ", indent)
	local nextIndentStr = string.rep("  ", indent + 1)

	if type(tbl) ~= "table" then
		if type(tbl) == "string" then
			return '"' .. tbl:gsub('"', '\\"') .. '"'
		elseif type(tbl) == "boolean" then
			return tbl and "true" or "false"
		elseif tbl == nil then
			return "null"
		else
			return tostring(tbl)
		end
	end

	-- Check if array or object
	local isArray = true
	local maxIndex = 0
	for k, v in pairs(tbl) do
		if type(k) ~= "number" then
			isArray = false
			break
		end
		if k > maxIndex then maxIndex = k end
	end

	if isArray then
		-- Array format
		local items = {}
		for i = 1, maxIndex do
			if tbl[i] ~= nil then
				table.insert(items, nextIndentStr .. tableToJson(tbl[i], indent + 1))
			end
		end
		return "[\n" .. table.concat(items, ",\n") .. "\n" .. indentStr .. "]"
	else
		-- Object format
		local items = {}
		for k, v in pairs(tbl) do
			local key = '"' .. tostring(k) .. '"'
			local value = tableToJson(v, indent + 1)
			table.insert(items, nextIndentStr .. key .. ": " .. value)
		end
		return "{\n" .. table.concat(items, ",\n") .. "\n" .. indentStr .. "}"
	end
end

local function exportWorldMap()
	local ZoneData = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("ZoneData"))
	local zoneContainer = workspace:FindFirstChild("ZoneContainer")

	if not zoneContainer then
		print("[EXPORTER] ZoneContainer not found!")
		return nil
	end

	local worldData = {
		exportTime = os.date("%Y-%m-%d %H:%M:%S"),
		version = "1.0",
		zones = {},
		bridges = {},
		bossArenas = {},
		connections = {}
	}

	-- Extract zone data
	print("[EXPORTER] Extracting zones...")
	for _, zoneFolder in ipairs(zoneContainer:GetChildren()) do
		if zoneFolder:IsA("Folder") or zoneFolder:IsA("Model") then
			local zoneName = zoneFolder.Name

			-- Skip bridge and portal folders
			if not zoneName:match("Bridge") and not zoneName:match("Portal") and not zoneName:match("BossArena") then
				-- Find terrain part
				local terrainPart = nil
				for _, child in ipairs(zoneFolder:GetChildren()) do
					if child:IsA("BasePart") and (child.Name:match("Terrain") or child.Name == "Zone") then
						terrainPart = child
						break
					end
				end

				-- If no explicit terrain, find first part
				if not terrainPart then
					for _, child in ipairs(zoneFolder:GetChildren()) do
						if child:IsA("BasePart") and child.Name ~= "Barrier" then
							terrainPart = child
							break
						end
					end
				end

				if terrainPart then
					local zoneInfo = {
						name = zoneName,
						position = {
							x = math.round(terrainPart.Position.X),
							y = math.round(terrainPart.Position.Y),
							z = math.round(terrainPart.Position.Z)
						},
						size = {
							x = math.round(terrainPart.Size.X),
							y = math.round(terrainPart.Size.Y),
							z = math.round(terrainPart.Size.Z)
						}
					}

					-- Add ZoneData info if available
					if zoneName ~= "Hub" and ZoneData[zoneName] then
						local zd = ZoneData[zoneName]
						zoneInfo.unlockCost = zd.UnlockCost or 0
						zoneInfo.description = zd.Special or ""
						zoneInfo.minRarity = zd.MinRarity or "Common"
						zoneInfo.maxRarity = zd.MaxRarity or "Common"
					elseif zoneName == "Hub" then
						zoneInfo.unlockCost = 0
						zoneInfo.description = "Hub zone, no penalties."
						zoneInfo.minRarity = "Common"
						zoneInfo.maxRarity = "Uncommon"
					end

					table.insert(worldData.zones, zoneInfo)
					print("[EXPORTER] ✓ Zone: " .. zoneName)
				end
			end
		end
	end

	-- Extract boss arenas (look for any folder at high Y position or named BossArena)
	print("[EXPORTER] Extracting boss arenas...")
	local bossArenaCount = 0
	for _, zoneFolder in ipairs(zoneContainer:GetChildren()) do
		if zoneFolder.Name:match("BossArena") or zoneFolder.Name:match("boss") or zoneFolder.Name:match("Boss") then
			-- Look for any part in this folder
			for _, child in ipairs(zoneFolder:GetDescendants()) do
				if child:IsA("BasePart") and child.Parent == zoneFolder then
					local bossInfo = {
						name = zoneFolder.Name,
						position = {
							x = math.round(child.Position.X),
							y = math.round(child.Position.Y),
							z = math.round(child.Position.Z)
						},
						size = {
							x = math.round(child.Size.X),
							y = math.round(child.Size.Y),
							z = math.round(child.Size.Z)
						}
					}
					table.insert(worldData.bossArenas, bossInfo)
					print("[EXPORTER] ✓ Boss Arena: " .. zoneFolder.Name .. " at Y=" .. child.Position.Y)
					bossArenaCount = bossArenaCount + 1
					break
				end
			end
		end
	end

	-- Extract bridges (look for Bridge folders or any folder with Bridge in name)
	print("[EXPORTER] Extracting bridges...")
	local bridgeCount = 0
	for _, zoneFolder in ipairs(zoneContainer:GetChildren()) do
		if zoneFolder.Name:match("Bridge") or zoneFolder.Name:match("bridge") then
			-- Look for any part in this folder
			for _, child in ipairs(zoneFolder:GetChildren()) do
				if child:IsA("BasePart") then
					local bridgeInfo = {
						name = zoneFolder.Name,
						position = {
							x = math.round(child.Position.X),
							y = math.round(child.Position.Y),
							z = math.round(child.Position.Z)
						},
						size = {
							x = math.round(child.Size.X),
							y = math.round(child.Size.Y),
							z = math.round(child.Size.Z)
						},
						length = math.round((child.Size.X + child.Size.Y + child.Size.Z) / 3)
					}
					table.insert(worldData.bridges, bridgeInfo)
					print("[EXPORTER] ✓ Bridge: " .. zoneFolder.Name .. " at (" .. child.Position.X .. ", " .. child.Position.Y .. ", " .. child.Position.Z .. ")")
					bridgeCount = bridgeCount + 1
				end
			end
		end
	end

	return worldData
end

-- Main execution
print("[EXPORTER] Starting world map export...")
local worldData = exportWorldMap()

if worldData then
	local jsonString = tableToJson(worldData)

	-- Print to console (you can copy from here)
	print("\n" .. string.rep("=", 80))
	print("[EXPORTER] JSON OUTPUT (copy this to world_map.json):")
	print(string.rep("=", 80))
	print(jsonString)
	print(string.rep("=", 80))

	-- Also try to save to file if running as script
	if script and script.Parent then
		local success, err = pcall(function()
			-- This won't work in Studio sandbox, but we'll try
			writefile("world_map.json", jsonString)
			print("[EXPORTER] ✓ Saved to world_map.json")
		end)
		if not success then
			print("[EXPORTER] Cannot write files in Studio (expected). Copy the JSON above manually.")
		end
	end

	print("[EXPORTER] Export complete! Zones: " .. #worldData.zones .. ", Bridges: " .. #worldData.bridges .. ", Boss Arenas: " .. #worldData.bossArenas)
else
	print("[EXPORTER] Export failed!")
end
