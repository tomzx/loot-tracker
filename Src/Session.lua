Session = {}
Session.__index = Session
Session.States = {
	Stopped = 0,
	Running = 1,
	Paused = 2,
}
Session.State = Session.States.Stopped

function Session.new()
	local self = setmetatable({}, Session)
	self.Seen = {}
	self.Looted = {}
	return self
end

function Session:AddSeen(lootSlotInfo)
	-- We track item, count for now
	local icon = lootSlotInfo[1]
	local item = lootSlotInfo[2]
	local quantity = lootSlotInfo[3]
	itemData = self.Seen[item] or {
		Quantity = 0,
	}
	self.Seen[item] = {
		Icon = icon,
		Item = item,
		Quantity = itemData.Quantity + quantity,
	}
end

function Session:AddLooted(lootSlotInfo)
	-- We track item, count for now
	local icon = lootSlotInfo[1]
	local item = lootSlotInfo[2]
	local quantity = lootSlotInfo[3]
	self.Looted[item] = {
		Icon = icon,
		Item = item,
		Quantity = quantity,
	}
end