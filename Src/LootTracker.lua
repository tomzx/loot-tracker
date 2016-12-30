local AceAddon = LibStub("AceAddon-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceLocale = LibStub("AceLocale-3.0")

LootTracker = AceAddon:NewAddon("LootTracker", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");
local LootTrackerDB

local getOpt, setOpt
do
	function getConfig(info)
		local key = info[#info]
		return LootTrackerDB.config[key]
	end

	function setConfig(info, value)
		local key = info[#info]
		LootTrackerDB.config[key] = value
	end
end

function LootTracker:OnInitialize()
	self:InitializeDB()

	self.L = AceLocale:GetLocale("LootTracker")

	local profiles = AceDBOptions:GetOptionsTable(self.db)

	local options = {
		name = "LootTracker",
		-- handler = LootTrackerDB.config,
		get = getConfig,
		set = setConfig,
		type = "group",
		args = {
			debug = {
				type = "toggle",
				name = self.L["Debug"],
				desc = self.L["DebugDescription"],
				-- get = function(info,val) return self.db.config.debug end,
				-- set = function(info,val) self.db.config.debug = val end,
				width = "full"
			}
			-- Ignore unlooted items
			-- Record all game sessions
			-- Record instances/dungeons sessions
			-- Reset data
		},
	}

	AceConfig:RegisterOptionsTable("LootTracker", options)
	AceConfigDialog:AddToBlizOptions("LootTracker", "LootTracker")

	AceConfig:RegisterOptionsTable("LootTracker.Profile", profiles)
	AceConfigDialog:AddToBlizOptions("LootTracker.Profile", "Profiles", "LootTracker")

	MainWindow:Initialize()
	Tracker:Initialize();
end

function LootTracker:InitializeDB()
	local defaults = {
		profile = {
			config = {
				debug = false,
			},
		},
	}

	self.db = AceDB:New("LootTrackerDB", defaults, true)
	LootTrackerDB = self.db.profile

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileUpdated")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileUpdated")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileUpdated")
end

function LootTracker:OnProfileUpdated()
	LootTrackerDB = self.db.profile
end

function debug(text)
	if LootTrackerDB.config.debug == true then
		print(text)
	end
end