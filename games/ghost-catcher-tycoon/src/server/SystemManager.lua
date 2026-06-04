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

	local serverFolder = script.Parent
	local systemsFolder = serverFolder:WaitForChild("systems")
	local dataFolder = serverFolder:WaitForChild("data")

	-- Load all system modules
	for _, name in ipairs(systemNames) do
		local folder = systemsFolder
		if name == "DataManager" then
			folder = dataFolder
		end

		local systemModule = folder:WaitForChild(name)
		if not systemModule then
			error("[SystemManager] Failed to find " .. name .. " module")
			return false
		end

		local loadedModule = require(systemModule)
		systems[name] = loadedModule
		print("[SystemManager] Loaded " .. name)
	end

	print("[SystemManager] All systems loaded. Creating instances...")

	-- Instantiate all systems
	for name, moduleClass in pairs(systems) do
		systems[name] = moduleClass:new()
		print("[SystemManager] Instantiated " .. name)
	end

	systemsInitialized = true
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
	currencySystem:setDataManager(dataManager)

	-- Production → Currency, Ghost, HQ, Event, Prestige
	productionSystem:setCurrencySystem(currencySystem)
	productionSystem:setGhostSystem(ghostSystem)
	productionSystem:setHQSystem(hqSystem)
	productionSystem:setEventSystem(eventSystem)
	productionSystem:setPrestigeSystem(prestigeSystem)

	-- HQ → Currency
	hqSystem:setCurrencySystem(currencySystem)

	-- Training → Currency, Ghost
	trainingSystem:setCurrencySystem(currencySystem)
	trainingSystem:setGhostSystem(ghostSystem)

	-- Zone → Currency, Ghost
	zoneSystem:setCurrencySystem(currencySystem)
	zoneSystem:setGhostSystem(ghostSystem)

	-- Monetization → Currency, Ghost
	monetizationSystem:setCurrencySystem(currencySystem)
	monetizationSystem:setGhostSystem(ghostSystem)

	-- AutoCatch → Ghost, Vacuum, Monetization
	autoCatchSystem:setGhostSystem(ghostSystem)
	autoCatchSystem:setVacuumSystem(vacuumSystem)
	autoCatchSystem:setMonetizationSystem(monetizationSystem)

	-- AutoTrain → Training, Ghost, Monetization, Currency
	autoTrainSystem:setTrainingSystem(trainingSystem)
	autoTrainSystem:setGhostSystem(ghostSystem)
	autoTrainSystem:setMonetizationSystem(monetizationSystem)
	autoTrainSystem:setCurrencySystem(currencySystem)

	-- Quest → Data
	questSystem:setDataManager(dataManager)

	-- Leaderboard → Data
	leaderboardSystem:setDataManager(dataManager)

	-- Gacha → Ghost, Currency, Data
	gachaSystem:setGhostSystem(ghostSystem)
	gachaSystem:setCurrencySystem(currencySystem)
	gachaSystem:setDataManager(dataManager)

	-- Cosmetics → Currency, Data
	cosmeticsSystem:setCurrencySystem(currencySystem)
	cosmeticsSystem:setDataManager(dataManager)

	-- PvP → Ghost, Currency, Data
	pvpSystem:setGhostSystem(ghostSystem)
	pvpSystem:setCurrencySystem(currencySystem)
	pvpSystem:setDataManager(dataManager)

	-- Prestige → Currency, Ghost, HQ, Zone, Data
	prestigeSystem:setCurrencySystem(currencySystem)
	prestigeSystem:setGhostSystem(ghostSystem)
	prestigeSystem:setHQSystem(hqSystem)
	prestigeSystem:setZoneSystem(zoneSystem)
	prestigeSystem:setDataManager(dataManager)

	-- Egg → Currency, Ghost
	eggSystem:setCurrencySystem(currencySystem)
	eggSystem:setGhostSystem(ghostSystem)

	-- Boss → Currency, Ghost, Zone
	bossSystem:setCurrencySystem(currencySystem)
	bossSystem:setGhostSystem(ghostSystem)
	bossSystem:setZoneSystem(zoneSystem)

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
		if system.initializePlayer then
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
