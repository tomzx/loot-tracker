local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

LootTracker = AceAddon:NewAddon("LootTracker", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");

DEBUG = true

function LootTracker:OnInitialize()
	self.InitializeLootTrackerDB()

	self.L = AceLocale:GetLocale("LootTracker")

	local options = {
		name = "LootTracker",
		handler = LootTrackerDB,
		type = "group",
		args = {
			-- Ignore unlooted items
			-- Record all game sessions
			-- Record instances/dungeons sessions
			-- Reset data
		},
	}

	AceConfig:RegisterOptionsTable("LootTracker", options)
	AceConfigDialog:AddToBlizOptions("LootTracker", "LootTracker")

	MainWindow:Initialize()
	Tracker:Initialize();
end

function LootTracker:InitializeLootTrackerDB()
	if LootTrackerDB == nil then
		LootTrackerDB = {}
	end

	if not LootTrackerDB.config then
		LootTrackerDB.config = {
			objectiveTime = true,
			deathCounter = false,
		}
	end

	if not LootTrackerDB.currentRun then
		LootTrackerDB.currentRun = {}
	end
end

function debug(text)
	if DEBUG == true then
		print(text)
	end
end