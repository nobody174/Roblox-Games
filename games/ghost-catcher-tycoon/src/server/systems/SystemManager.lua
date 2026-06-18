--
-- Ghost Catcher Tycoon - System Manager
-- Centralizes loading, initialization, and management of all server systems
-- Provides clean interface: SystemManager:initialize(), SystemManager:getSystem(name)
--
-- Pattern: Singleton managing 21 game systems
-- Benefits: Clean system dependency injection, easy enable/disable, single initialization point
--

local SystemManager = {}
SystemManager.__index = SystemManager

-- Internal state: all loaded systems
local systems = {}
local systemsInitialized = false

-- List of all systems to load (in order of dependency)
local systemNames = {
	-- Data layer (no dependencies)
	"DataManager",

	-- Core systems (base functionality)
	"CurrencySystem",
	"VacuumSystem",
	"GhostSystem",

	-- Mid-tier systems (depend on core)
	"ProductionSystem",
	"HQSystem",
	"TrainingSystem",
	"ZoneSystem",

	-- Feature systems
	"MonetizationSystem",
	"AutoCatchSystem",
	"AutoTrainSystem",
	"QuestSystem",
	"LeaderboardSystem",
	"GachaSystem",
	"CosmeticsSystem",
	"PvPSystem",
	"PrestigeSystem",
	"EventSystem",
	"EggSystem",
	"BossSystem",

	-- Services (standalone)
	"GhostService",
	"GhostSpawner",
}

--[[
	Initialize all systems
	Called once at server startup
	Returns: true on success, false on error
]]
function SystemManager:initialize()
	if systemsInitialized then
		warn("[SystemManager] Already initialized, skipping")
		return true
	end

	print("[SystemManager] Initializing " .. #systemNames .. " systems...")

	local serverFolder = script.Parent.Parent
	local systemsFolder = serverFolder:FindFirstChild("systems")
	local dataFolder = serverFolder:FindFirstChild("data")

	if not systemsFolder then
		warn("[SystemManager] systems folder not found in ServerScriptService")
		return false
	end

	-- Load all system modules
	for _, name in ipairs(systemNames) do
		local folder = systemsFolder
		if name == "DataManager" then
			folder = dataFolder
			if not folder then
				warn("[SystemManager] data folder not found, skipping DataManager")
			else
				local systemModule = folder:FindFirstChild(name)
				if systemModule then
					local loadedModule = require(systemModule)
					systems[name] = loadedModule
					print("[SystemManager] Loaded " .. name)
				else
					warn("[SystemManager] Failed to find DataManager module")
				end
			end
		else
			local systemModule = folder:FindFirstChild(name)
			if systemModule then
				local loadedModule = require(systemModule)
				systems[name] = loadedModule
				print("[SystemManager] Loaded " .. name)
			else
				warn("[SystemManager] Failed to find " .. name .. " module")
			end
		end
	end

	print("[SystemManager] All systems loaded. Creating instances...")

	-- Instantiate all systems
	for name, moduleClass in pairs(systems) do
		if moduleClass and moduleClass.new then
			systems[name] = moduleClass:new()
			print("[SystemManager] Instantiated " .. name)
		end
	end

	systemsInitialized = true

	-- Start GhostSpawner after all systems are initialized
	local ghostSpawner = systems["GhostSpawner"]
	if ghostSpawner and ghostSpawner.startSpawning then
		ghostSpawner:startSpawning()
	end

	print("[SystemManager] ✓ All systems initialized")
	return true
end

--[[
	Link system dependencies (inject dependencies between systems)
	Called after initialize()
	This allows systems to access each other
]]
function SystemManager:linkDependencies()
	if not systemsInitialized then
		error("[SystemManager] Must call initialize() before linkDependencies()")
		return false
	end

	print("[SystemManager] Linking system dependencies...")

	local dataManager = systems["DataManager"]
	local currencySystem = systems["CurrencySystem"]
	local vacuumSystem = systems["VacuumSystem"]
	local ghostSystem = systems["GhostSystem"]
	local productionSystem = systems["ProductionSystem"]
	local hqSystem = systems["HQSystem"]
	local trainingSystem = systems["TrainingSystem"]
	local zoneSystem = systems["ZoneSystem"]
	local monetizationSystem = systems["MonetizationSystem"]
	local autoCatchSystem = systems["AutoCatchSystem"]
	local autoTrainSystem = systems["AutoTrainSystem"]
	local questSystem = systems["QuestSystem"]
	local leaderboardSystem = systems["LeaderboardSystem"]
	local gachaSystem = systems["GachaSystem"]
	local cosmeticsSystem = systems["CosmeticsSystem"]
	local pvpSystem = systems["PvPSystem"]
	local prestigeSystem = systems["PrestigeSystem"]
	local eventSystem = systems["EventSystem"]
	local eggSystem = systems["EggSystem"]
	local bossSystem = systems["BossSystem"]

	-- Currency → Data
	if currencySystem and currencySystem.setDataManager then
		currencySystem:setDataManager(dataManager)
	end

	-- Production → Currency, Ghost, HQ, Event, Prestige
	if productionSystem then
		if productionSystem.setCurrencySystem then productionSystem:setCurrencySystem(currencySystem) end
		if productionSystem.setGhostSystem then productionSystem:setGhostSystem(ghostSystem) end
		if productionSystem.setHQSystem then productionSystem:setHQSystem(hqSystem) end
		if productionSystem.setEventSystem then productionSystem:setEventSystem(eventSystem) end
		if productionSystem.setPrestigeSystem then productionSystem:setPrestigeSystem(prestigeSystem) end
	end

	-- HQ → Currency
	if hqSystem and hqSystem.setCurrencySystem then
		hqSystem:setCurrencySystem(currencySystem)
	end

	-- Training → Currency, Ghost
	if trainingSystem then
		if trainingSystem.setCurrencySystem then trainingSystem:setCurrencySystem(currencySystem) end
		if trainingSystem.setGhostSystem then trainingSystem:setGhostSystem(ghostSystem) end
	end

	-- Zone → Currency, Ghost
	if zoneSystem then
		if zoneSystem.setCurrencySystem then zoneSystem:setCurrencySystem(currencySystem) end
		if zoneSystem.setGhostSystem then zoneSystem:setGhostSystem(ghostSystem) end
	end

	-- Monetization → Currency, Ghost
	if monetizationSystem then
		if monetizationSystem.setCurrencySystem then monetizationSystem:setCurrencySystem(currencySystem) end
		if monetizationSystem.setGhostSystem then monetizationSystem:setGhostSystem(ghostSystem) end
	end

	-- AutoCatch → Ghost, Vacuum, Monetization
	if autoCatchSystem then
		if autoCatchSystem.setGhostSystem then autoCatchSystem:setGhostSystem(ghostSystem) end
		if autoCatchSystem.setVacuumSystem then autoCatchSystem:setVacuumSystem(vacuumSystem) end
		if autoCatchSystem.setMonetizationSystem then autoCatchSystem:setMonetizationSystem(monetizationSystem) end
	end

	-- AutoTrain → Training, Ghost, Monetization, Currency
	if autoTrainSystem then
		if autoTrainSystem.setTrainingSystem then autoTrainSystem:setTrainingSystem(trainingSystem) end
		if autoTrainSystem.setGhostSystem then autoTrainSystem:setGhostSystem(ghostSystem) end
		if autoTrainSystem.setMonetizationSystem then autoTrainSystem:setMonetizationSystem(monetizationSystem) end
		if autoTrainSystem.setCurrencySystem then autoTrainSystem:setCurrencySystem(currencySystem) end
	end

	-- Quest → Data
	if questSystem and questSystem.setDataManager then
		questSystem:setDataManager(dataManager)
	end

	-- Leaderboard → Data
	if leaderboardSystem and leaderboardSystem.setDataManager then
		leaderboardSystem:setDataManager(dataManager)
	end

	-- Gacha → Ghost, Currency, Data
	if gachaSystem then
		if gachaSystem.setGhostSystem then gachaSystem:setGhostSystem(ghostSystem) end
		if gachaSystem.setCurrencySystem then gachaSystem:setCurrencySystem(currencySystem) end
		if gachaSystem.setDataManager then gachaSystem:setDataManager(dataManager) end
	end

	-- Cosmetics → Currency, Data
	if cosmeticsSystem then
		if cosmeticsSystem.setCurrencySystem then cosmeticsSystem:setCurrencySystem(currencySystem) end
		if cosmeticsSystem.setDataManager then cosmeticsSystem:setDataManager(dataManager) end
	end

	-- PvP → Ghost, Currency, Data
	if pvpSystem then
		if pvpSystem.setGhostSystem then pvpSystem:setGhostSystem(ghostSystem) end
		if pvpSystem.setCurrencySystem then pvpSystem:setCurrencySystem(currencySystem) end
		if pvpSystem.setDataManager then pvpSystem:setDataManager(dataManager) end
	end

	-- Prestige → Currency, Ghost, HQ, Zone, Data
	if prestigeSystem then
		if prestigeSystem.setCurrencySystem then prestigeSystem:setCurrencySystem(currencySystem) end
		if prestigeSystem.setGhostSystem then prestigeSystem:setGhostSystem(ghostSystem) end
		if prestigeSystem.setHQSystem then prestigeSystem:setHQSystem(hqSystem) end
		if prestigeSystem.setZoneSystem then prestigeSystem:setZoneSystem(zoneSystem) end
		if prestigeSystem.setDataManager then prestigeSystem:setDataManager(dataManager) end
	end

	-- Egg → Currency, Ghost
	if eggSystem then
		if eggSystem.setCurrencySystem then eggSystem:setCurrencySystem(currencySystem) end
		if eggSystem.setGhostSystem then eggSystem:setGhostSystem(ghostSystem) end
	end

	-- Boss → Currency, Ghost, Zone, Data
	if bossSystem then
		if bossSystem.setCurrencySystem then bossSystem:setCurrencySystem(currencySystem) end
		if bossSystem.setGhostSystem then bossSystem:setGhostSystem(ghostSystem) end
		if bossSystem.setZoneSystem then bossSystem:setZoneSystem(zoneSystem) end
		if bossSystem.setDataManager then bossSystem:setDataManager(dataManager) end
	end

	print("[SystemManager] ✓ All dependencies linked")
	return true
end

--[[
	Get a system instance by name
	Example: local currencySystem = SystemManager:getSystem("CurrencySystem")
]]
function SystemManager:getSystem(name)
	if not systems[name] then
		warn("[SystemManager] System not found: " .. name)
		return nil
	end
	return systems[name]
end

--[[
	Enable a system (for future use)
	Currently: all systems are always enabled
]]
function SystemManager:enableSystem(name)
	local system = self:getSystem(name)
	if system then
		if system.enable then
			system:enable()
			print("[SystemManager] Enabled " .. name)
		end
		return true
	end
	return false
end

--[[
	Disable a system (for future use)
]]
function SystemManager:disableSystem(name)
	local system = self:getSystem(name)
	if system then
		if system.disable then
			system:disable()
			print("[SystemManager] Disabled " .. name)
		end
		return true
	end
	return false
end

--[[
	Initialize player in all systems
	Called when a player joins the server
]]
function SystemManager:initializePlayer(player)
	for name, system in pairs(systems) do
		if system and system.initializePlayer then
			system:initializePlayer(player)
		end
	end
end

--[[
	Get all systems (for debugging)
]]
function SystemManager:getAllSystems()
	return systems
end

--[[
	Get count of initialized systems
]]
function SystemManager:getSystemCount()
	return #systemNames
end

--[[
	Print status of all systems
]]
function SystemManager:printStatus()
	print("[SystemManager] === System Status ===")
	print("[SystemManager] Initialized: " .. tostring(systemsInitialized))
	print("[SystemManager] System count: " .. self:getSystemCount())
	print("[SystemManager] Loaded systems:")
	for name, _ in pairs(systems) do
		print("[SystemManager]   - " .. name)
	end
end

return SystemManager
