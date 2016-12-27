local AceEvent = LibStub("AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local AceTimer = LibStub("AceTimer-3.0")
local AceSerializer = LibStub("AceSerializer-3.0") -- TODO(roctom@gmail.com): For debugging purpose only


MainWindow = {
	startTime = nil,
	timer = nil,
	duration = 0,
	session = nil,

	toggleButton = nil,
	timerLabel = nil,
	scrollFrame = nil,
}

function MainWindow:Initialize()
	-- Create a container frame
	local f = AceGUI:Create("Window")
	-- f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
	f:SetTitle("Loot Tracker")
	-- f:SetStatusText("Status Bar")
	f:SetLayout("Flow")
	f:SetWidth(325)
	f:SetHeight(375)
	-- TODO(roctom@gmail.com): Disable resizing
	-- Create a button
	self.toggleButton = AceGUI:Create("Button")
	self.toggleButton:SetWidth(100)
	self.toggleButton:SetText("Start")
	self.toggleButton:SetCallback("OnClick", function() self:ToggleTimer() end)
	-- Add the button to the container
	f:AddChild(self.toggleButton)

	-- Create a button
	local btn = AceGUI:Create("Button")
	btn:SetWidth(100)
	btn:SetText("Reset")
	btn:SetCallback("OnClick", function() self:ResetTimer() end)
	-- Add the button to the container
	f:AddChild(btn)

	self.timerLabel = AceGUI:Create("Label")
	self.timerLabel:SetWidth(100)
	self.timerLabel:SetText(self:getFormattedTime(0))
	f:AddChild(self.timerLabel)

	local scrollContainer = AceGUI:Create("SimpleGroup")
	scrollContainer:SetFullWidth(true)
	scrollContainer:SetFullHeight(true) -- probably?
	scrollContainer:SetLayout("Fill") -- important!
	f:AddChild(scrollContainer)

	self.scrollFrame = AceGUI:Create("ScrollFrame")
	self.scrollFrame:SetLayout("List")
	scrollContainer:AddChild(self.scrollFrame)

	self:Refresh()

	-- TODO(roctom@gmail.com): Add status bar with estimated gold value?

	debug("LootTracker main window initialized!")
end

-- TODO(roctom@gmail.com): Replace this with messages
function MainWindow:Refresh()
	self:RenderSession(self.session)
end

function MainWindow:RenderSession(session)
	if not self.session then
		return
	end

	debug("Rendering session")
	debug(AceSerializer:Serialize(self.session))

	self.scrollFrame:ReleaseChildren()
	self:RenderSessionHeader()

	local duration = max(1, self.duration)
	for index, loot in pairs(self.session.Seen) do
		local g = AceGUI:Create("SimpleGroup")
		g:SetLayout("Flow")

		-- Item icon
		local i = AceGUI:Create("Icon")
		i:SetImage(loot.Icon)
		i:SetWidth(24)
		i:SetHeight(16)
		i:SetImageSize(16, 16)
		g:AddChild(i)
		-- TODO(roctom@gmail.com): Add item tooltip

		-- Item name
		local l = AceGUI:Create("Label")
		l:SetText(loot.Item)
		l:SetWidth(150)
		g:AddChild(l)

		-- Looted
		local l = AceGUI:Create("Label")
		l:SetText(loot.Quantity)
		l:SetWidth(50)
		g:AddChild(l)

		-- Expected/hour
		local perHour = floor(loot.Quantity * (3600/duration));
		local l = AceGUI:Create("Label")
		l:SetText(perHour)
		l:SetWidth(50)
		g:AddChild(l)

		self.scrollFrame:AddChild(g)
	end
end

function MainWindow:RenderSessionHeader()
	local g = AceGUI:Create("SimpleGroup")
	g:SetLayout("Flow")

	-- Item icon
	local i = AceGUI:Create("Icon")
	i:SetWidth(24)
	i:SetHeight(16)
	i:SetImageSize(16, 16)
	g:AddChild(i)

		-- Item name
	local l = AceGUI:Create("Label")
	l:SetText("Item")
	l:SetWidth(150)
	g:AddChild(l)

	-- Looted
	local l = AceGUI:Create("Label")
	l:SetText("Looted")
	l:SetWidth(50)
	g:AddChild(l)

	-- Expected/hour
	local l = AceGUI:Create("Label")
	l:SetText("Per hour")
	l:SetWidth(50)
	g:AddChild(l)

	self.scrollFrame:AddChild(g)
end

function MainWindow:ToggleTimer()
	if not self.startTime then
		self:StartTimer()
	else
		self:PauseTimer()
	end
end

function MainWindow:StartTimer()
	-- Only initialize the timer if it is reset
	if self.startTime == nil then
		self.startTime = time()
		self.session = Session.new()
		SessionManager:AddSession(self.session)
	end
	SessionManager:Start(self.session)
	debug("Start! " .. self.startTime)
	self.toggleButton:SetText("Pause")
	self.timer = AceTimer:ScheduleRepeatingTimer(function() self:UpdateTimeLabel() end, 1)
end

function MainWindow:PauseTimer()
	if not self.session then
		return
	end
	local currentTime = time()
	SessionManager:Pause(self.session)
	debug("Pause! " .. currentTime .. " Duration: " .. self.duration)
	self.toggleButton:SetText("Start")
	AceTimer:CancelTimer(self.timer)
	self.timer = nil
end

function MainWindow:ResetTimer()
	if not self.session then
		return
	end
	SessionManager:Stop(self.session)
	debug("Reset! " .. time())
	self.startTime = nil
	self.duration = 0
	self.toggleButton:SetText("Start")
	AceTimer:CancelTimer(self.timer)
	self.timer = nil
	self.timerLabel:SetText(self:getFormattedTime(self.duration))
end

function MainWindow:UpdateTimeLabel()
	self.duration = self.duration + 1
	self.timerLabel:SetText(self:getFormattedTime(self.duration))
end

function MainWindow:getFormattedTime(duration)
	local seconds = duration % 60
	local minutes = floor((duration - seconds) / 60) % 60
	local hours = floor((duration - minutes*60 - seconds) / 3600)
	return string.format("%02s:%02s:%02s", hours, minutes, seconds)
end