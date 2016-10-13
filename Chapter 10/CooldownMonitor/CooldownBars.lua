local bars = DBT:New()
bars.defaultOptions.HugeBarsEnabled = false

function CooldownMonitor.StartTimer(timer, player, spell, texture)
	local bar = bars:CreateBar(timer, player..": "..spell, texture, nil, true)
	local class = CooldownMonitor.GetClassByName(player) -- the class of player
	if RAID_CLASS_COLORS[class] then
		-- we can use the table that is stored in RAID_CLASS_COLORS here directly
		-- as it uses the same format as DBT does
		bar:SetColor(RAID_CLASS_COLORS[class])
	end
end

function CooldownMonitor.Unlock()
	bars:ShowMovableBar(true, false)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon == "CooldownMonitor" then
		bars:LoadOptions("CooldownMonitor")
	end
end)


local function createSetter(option)
	return function(info, value)
		bars:SetOption(option, value)
	end
end

local function createGetter(option)
	return function()
		return bars:GetOption(option)
	end
end

local options = {
	type = "group",
	args = {
		unlock = {
			name = "Show movable bars",
			type = "execute",
			func = CooldownMonitor.Unlock,
		},
		test = {
			name = "Show test bars",
			type = "execute",
			func = function() bars:ShowTestBars() end,
		},
		gui = {
			name = "Show the GUI",
			type = "execute",
			func = function()
				LibStub("AceConfigDialog-3.0"):Open("CooldownMonitor")
			end,
			guiHidden = true, -- don't show this in the GUI
		},
		icon = {
			type = "select",
			name = "Icon position",
			values = {
				none = "Don't show icon",
				left = "Show icon on the left side",
				right = "Show icon on the right side",
				both = "Show icon on both sides",
			},
			get = function()
				if bars:GetOption("IconLeft") and bars:GetOption("IconRight") then
					return "both"
				elseif bars:GetOption("IconLeft") then
					return "left"
				elseif bars:GetOption("IconRight") then
					return "right"
				else
					return "none"
				end
			end,
			set = function(info, value)
				if value == "none" then
					bars:SetOption("IconLeft", false)
					bars:SetOption("IconRight", false)
				elseif value == "left" then
					bars:SetOption("IconLeft", true)
					bars:SetOption("IconRight", false)
				elseif value == "right" then
					bars:SetOption("IconLeft", false)
					bars:SetOption("IconRight", true)
				elseif value == "both" then
					bars:SetOption("IconLeft", true)
					bars:SetOption("IconRight", true)
				end
			end
		},
		expandUpwards = {
			name = "Expand bars upwards",
			type = "toggle",
			get = createGetter("ExpandUpwards"),
			set = createSetter("ExpandUpwards")
		},
		width = {
			name = "Bar width",
			type = "range",
			min = 100,
			max = 300,
			get = createGetter("Width"),
			set = createSetter("Width")
		},
		scale = {
			name = "Bar scale",
			type = "range",
			min = 0.2,
			max = 2.0,
			get = createGetter("Scale"),
			set = createSetter("Scale")
		},
	}
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("CooldownMonitor", options, {"cm", "cooldownmonitor"})
