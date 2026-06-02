--[=[
  Ghost Catcher Tycoon - Event System
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
]=]

local EventSystem = {}
EventSystem.__index = EventSystem

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("shared"):WaitForChild("config"))

function EventSystem:new()
	local self = setmetatable({}, EventSystem)
	self.currentEvent = nil
	self.lastCheckTime = 0
	return self
end

function EventSystem:initializePlayer(player)
end

function EventSystem:removePlayer(userId)
end

function EventSystem:_findActiveEvent()
	local now = os.time()
	for _, event in ipairs(Config.Events.Active) do
		if now >= event.StartTime and now <= event.EndTime then
			return event
		end
	end
	return nil
end

function EventSystem:getCurrentEvent()
	return self:_findActiveEvent()
end

function EventSystem:isEventActive()
	return self:getCurrentEvent() ~= nil
end

function EventSystem:getEventBonus(player)
	local event = self:getCurrentEvent()
	if not event then
		return Config.Events.DefaultBonusMultiplier
	end
	return event.BonusMultiplier or 1.0
end

function EventSystem:getEventGhosts()
	local event = self:getCurrentEvent()
	if not event then
		return {}
	end
	return event.SpecialGhosts or {}
end

return EventSystem
