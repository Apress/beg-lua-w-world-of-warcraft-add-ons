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

Poker_TableBrowser = {}
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
		print(string.format("Joining %s's table %s", selection[2], selection[1]))
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
	print("Creating game...")
	print(...)
end

do
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("CHAT_MSG_ADDON")
	frame:SetScript("OnEvent", function(self, event, ...)
		return Poker_TableBrowser[event](...)
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
end

-- dummy entries
for i = 1, MAX_TABLES * 2 do
	table.insert(Poker_TableBrowser.Tables, {
		"Test Table "..i,
		"Host "..(MAX_TABLES * 2 - i),
		i % 3 + 1, -- just dummy values
		10,
		i * 10,
		i * 20
	})
end

Poker_TableBrowser.Update()
