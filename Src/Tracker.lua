local AceEvent = LibStub("AceEvent-3.0")
local AceSerializer = LibStub("AceSerializer-3.0") -- TODO(roctom@gmail.com): For debugging purpose only

Tracker = AceEvent:Embed(LootTracker)

function Tracker:Initialize()
	events = {
		"LOOT_OPENED",
		"LOOT_CLOSED",
	}

	for i, event in ipairs(events) do
		debug(event)
		self:RegisterEvent(event)
	end
end

function Tracker:LOOT_OPENED()
	debug("Loot opened!")
	local numberOfItems = GetNumLootItems()

	for lootSlot = 1, numberOfItems do
		local lootSourceInfo = {GetLootSourceInfo(lootSlot)}
		local lootSlotInfo = {GetLootSlotInfo(lootSlot)}
		for lootIndex = 1, #lootSourceInfo, 2 do
			local sourceGuid = lootSourceInfo[lootIndex]
			debug("Saw " .. AceSerializer:Serialize(lootSourceInfo))
			debug("Slot " .. AceSerializer:Serialize(lootSlotInfo))
			SessionManager:AddSeen(lootSlotInfo)
		end
	end

	MainWindow:Refresh()
end

function Tracker:LOOT_CLOSED()
	debug("Loot closed!")

	local numberOfItems = GetNumLootItems()

	for lootSlot = 1, numberOfItems do
		local lootSourceInfo = {GetLootSourceInfo(lootSlot)}
		local lootSlotInfo = {GetLootSlotInfo(lootSlot)}
		for lootIndex = 1, #lootSourceInfo, 2 do
			local sourceGuid = lootSourceInfo[lootIndex]
			debug("Saw " .. AceSerializer:Serialize(lootSourceInfo))
			debug("Slot " .. AceSerializer:Serialize(lootSlotInfo))
			SessionManager:AddSeen(lootSlotInfo)
		end
	end
	
	MainWindow:Refresh()
end

function Tracker:Save()
	-- TODO
end

function Tracker:Restore()
	-- TODO
end