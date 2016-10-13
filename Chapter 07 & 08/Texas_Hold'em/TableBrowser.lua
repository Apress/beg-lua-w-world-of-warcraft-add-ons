local defaultSavedVars = {
	Name = "My Table",
	Players = 6,
	SmallBlind = 10,
	BigBlind = 20,
	AllowEveryone = false,
	AllowGuild = true,
	AllowGroup = true,
	AllowFriends = true
}
Poker_TableBrowserSavedVars = {}

local function tobool(var)
	return not not var
end

local MAX_TABLES = 8

do
	local entry = CreateFrame("Button", "$parentEntry1", Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
	entry:SetID(1)
	entry:SetPoint("TOPLEFT", 4, -28)
	for i = 2, MAX_TABLES do
		local entry = CreateFrame("Button", "$parentEntry"..i, Poker_TableBrowserTableList, "Poker_TableBrowserEntry")
		entry:SetID(i)
		entry:SetPoint("TOP", "$parentEntry"..(i - 1), "BOTTOM")
	end
end

Poker_TableBrowser.Tables = {}

function Poker_TableBrowser.Update()
	FauxScrollFrame_Update(Poker_TableBrowserTableListScrollFrame, #Poker_TableBrowser.Tables, MAX_TABLES, 24, "Poker_TableBrowserTableListEntry", 328, 344, Poker_TableBrowserTableListHeaderBlinds, 60, 76)
	for i = 1, MAX_TABLES do
		local entry = Poker_TableBrowser.Tables[i + Poker_TableBrowserTableListScrollFrame.offset]
		local frame = getglobal("Poker_TableBrowserTableListEntry"..i)
		if entry then
			frame:Show()
			getglobal(frame:GetName().."Name"):SetText(entry[1])
			getglobal(frame:GetName().."Host"):SetText(entry[2])
			getglobal(frame:GetName().."Players"):SetText(entry[3].."/"..entry[4])
			getglobal(frame:GetName().."Blinds"):SetText(entry[5].."-"..entry[6])
			if entry.isSelected then
				getglobal(frame:GetName().."BG"):Show()
			else
				getglobal(frame:GetName().."BG"):Hide()
			end
		else
			frame:Hide()
		end
	end
end

do
	local currSort = 1
	local currOrder = "asc"
	function Poker_TableBrowser.SortTables(id)
		if currSort == id then
			if currOrder == "desc" then
				currOrder = "asc"
			else
				currOrder = "desc"
			end
		elseif id then
			currSort = id
			currOrder = "asc"
		end
		table.sort(Poker_TableBrowser.Tables, function(v1, v2)
			if currOrder == "desc" then
				return v1[currSort] > v2[currSort]
			else
				return v1[currSort] < v2[currSort]
			end
		end)
		Poker_TableBrowser.Update()
	end
end

do
	local selection = nil
	function Poker_TableBrowser.SelectEntry(id)
		if selection then
			for i = 1, MAX_TABLES do
				getglobal("Poker_TableBrowserTableListEntry"..i.."BG"):Hide()
			end
			selection.isSelected = nil
		end
		selection = Poker_TableBrowser.Tables[id + Poker_TableBrowserTableListScrollFrame.offset]
		selection.isSelected = true
	end

	function Poker_TableBrowser.IsSelected(id)
	   return Poker_TableBrowser.Tables[id + Poker_TableBrowserTableListScrollFrame.offset] == selection
	end

	function Poker_TableBrowser.JoinSelectedTable()
		if not selection then
			return
		end
		PokerClient:JoinTable(selection[2], selection[1])
	end
end

StaticPopupDialogs["POKER_JOIN_TABLE"] = {
	text = POKER_ENTER_NAME_DIALOG,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 12,
	OnAccept = function(self)
		Poker_TableBrowser.JoinTableByName(self.editBox:GetText())
	end,
	OnShow = function(self)
		self.editBox:SetFocus()
	end,
	OnHide = function(self)
		if (ChatFrameEditBox:IsShown()) then
			ChatFrameEditBox:SetFocus()
		end
		self.editBox:SetText("")
	end,
	EditBoxOnEnterPressed = function(self)
		Poker_TableBrowser.JoinTableByName(self:GetText())
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

function Poker_TableBrowser.ShowEnterNameDialog()
	StaticPopup_Show("POKER_JOIN_TABLE")
end

function Poker_TableBrowser.JoinTableByName(name)
	print(string.format("Trying to join %s's table.", name))
end

function Poker_TableBrowser.ShowCreateTableDialog()
	Poker_CreateTable:Show()
end

function Poker_TableBrowser.CreateGame(...)
	Poker_TableBrowserSavedVars.Name = select(1, ...)
	Poker_TableBrowserSavedVars.Players = select(2, ...)
	Poker_TableBrowserSavedVars.SmallBlind = select(3, ...)
	Poker_TableBrowserSavedVars.BigBlind = select(4, ...)
	Poker_TableBrowserSavedVars.AllowEveryone = tobool(select(5, ...))
	Poker_TableBrowserSavedVars.AllowGuild = tobool(select(6, ...))
	Poker_TableBrowserSavedVars.AllowGroup = tobool(select(7, ...))
	Poker_TableBrowserSavedVars.AllowFriends = tobool(select(8, ...))
	Poker_CreateServer(...)
end

do
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("CHAT_MSG_ADDON")
	frame:SetScript("OnEvent", function(self, event, ...)
		return Poker_TableBrowser[event](...)
	end)
	
	local elapsed = 0
	frame:SetScript("OnUpdate", function(self, e)
		elapsed = elapsed + e
		if elapsed >= 5 then
			elapsed = 0
			local time = GetTime()
			-- remove outdated entries
			for i = #Poker_TableBrowser.Tables, 1, -1 do
				if time - Poker_TableBrowser.Tables[i].lastUpdate > 5 then
					table.remove(Poker_TableBrowser.Tables, i)
				end
			end
			Poker_TableBrowser.Update() -- update the GUI
		end
	end)
end

do
	local function addOptionMt(options, defaults)
		setmetatable(options, {__index = defaults})
		for i, v in pairs(options) do
			if type(v) == "table" and not getmetatable(v) then
				addOptionMt(v, defaults[i])
			end
		end
	end

	function Poker_TableBrowser.ADDON_LOADED(addon)
		if addon == "Texas_Hold'em" then
			addOptionMt(Poker_TableBrowserSavedVars, defaultSavedVars)
		end
	end
	
	function Poker_TableBrowser.CHAT_MSG_ADDON(prefix, msg, channel, sender)
		if prefix == "Poker-GA" and (channel == "GUILD" or channel == "RAID" or channel == "PARTY") then
			local players, maxplayers, smallBlind, bigBlind, tableName = string.split("\t", msg)
			players = math.floor(tonumber(players or ""))
			maxplayers = math.floor(tonumber(maxplayers or ""))
			smallBlind = math.floor(tonumber(smallBlind or ""))
			bigBlind = math.floor(tonumber(bigBlind or ""))
			if not (players and maxplayers and smallBlind and bigBlind and tableName) then
				return -- message is malformed, reject it
			end
			-- sanity check
			if players > 10 or players < 0 or maxplayers > 10 or maxplayers < 0
			or smallBlind > 1000 or smallBlind < 0 or bigBlind > 1000 or bigBlind < 0
			or smallBlind > math.floor(bigBlind / 2) or #tableName > 26 then
				return
			end
			local key = #Poker_TableBrowser.Tables + 1
			-- check if we already have the server in our list
			for i, v in ipairs(Poker_TableBrowser.Tables) do
				if v[1] == tableName and v[2] == sender then
					-- found it, return
					key = i
					break
				end
			end
			-- key is now either ne first free slot in the array
			-- Poker_TableBrowser.Tables that holds all open servers
			-- or it is the old entry that will be updated
			Poker_TableBrowser.Tables[key] = Poker_TableBrowser.Tables[key] or {}
			local entry = Poker_TableBrowser.Tables[key]
			entry[1] = tableName
			entry[2] = sender
			entry[3] = players
			entry[4] = maxplayers
			entry[5] = smallBlind
			entry[6] = bigBlind
			entry.lastUpdate = GetTime()
			Poker_TableBrowser.Update() -- update the GUI
		end
	end
end

-- a simple slash command to show the frame
SLASH_POKER1 = "/poker"
SlashCmdList["POKER"] = function(msg)
	Poker_TableBrowser:Show()
end
