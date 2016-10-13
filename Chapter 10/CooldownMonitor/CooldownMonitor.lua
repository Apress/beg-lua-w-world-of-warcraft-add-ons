local chatPrefix = "|cffff7d0a<|r|cffffd200CooldownMonitor|r|cffff7d0a>|r "
local function print(...)
	DEFAULT_CHAT_FRAME:AddMessage(chatPrefix..string.join(" ", tostringall(...)), 0.41, 0.8, 0.11)
end

local spells = {
	SPELL_CAST_SUCCESS = {
		[29166] = 360,  -- Druid: Innervate
		[32182] = 600,  -- Shaman: Heroism (alliance)
		[2825] = 600,   -- Shaman: Bloodlust (horde)
		[22700] = 600,  -- Field Repair Bot 74A
		[44389] = 600,  -- Field Repair Bot 110G
	},
	SPELL_RESURRECT = {
		[20748] = 1200, -- Druid: Rebirth
	},
	SPELL_CREATE = {
		[53142] = 60, 	-- Portal: Dalaran (Alliance/Horde)
		[33691] = 60, 	-- Portal: Shattrath (Alliance)
		[35717] = 60, 	-- Portal: Shattrath (Horde)
		[11416] = 60, 	-- Portal: Ironforge
		[10059] = 60, 	-- Portal: Stormwind
		[49360] = 60, 	-- Portal: Theramore
		[11419] = 60, 	-- Portal: Darnassus
		[32266] = 60, 	-- Portal: Exodar
		[11417] = 60, 	-- Portal: Orgrimmar
		[11418] = 60, 	-- Portal: Undercity
		[11420] = 60, 	-- Portal: Thunder Bluff
		[32667] = 60, 	-- Portal: Silvermoon
		[49361] = 60, 	-- Portal: Stonard
	},
}

CooldownMonitor = {}

local onSpellCast, onEvent

function onEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local event = select(2, ...) -- get the sub-event
		local sourceName, sourceFlags = select(4, ...) -- caster's name and flags
		local spellId, spellName = select(9, ...) -- spell id and name
		-- check if we need the event and spell id
		-- and check if the outsider bit is not set, meaning the unit is in our group
		if spells[event] and spells[event][spellId]
		and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 then
			local cooldown = spells[event][spellId]
			onSpellCast(cooldown, sourceName, spellId, spellName)
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", onEvent)

local castInfo = "|Hplayer:%1$s|h[%1$s]|h cast |T%s:0|t|cFF71D5FF|Hspell:%d|h[%s]|h|r (Cooldown: %d |4minute:minutes;)"
function onSpellCast(timer, player, spellId, spellName)
	local texture = select(3, GetSpellInfo(spellId))
	print(castInfo:format(player, texture, spellId, spellName, timer / 60))
	CooldownMonitor.StartTimer(timer, player, spellName, texture)
end

-- gets a class of a player in your party or raid
function CooldownMonitor.GetClassByName(name)
	-- no need to work with the GUID here as the player's name is unique
	-- check if we are looking for ourselves
	if UnitName("player") == name then
		-- the first return value of UnitClass is localized, the second one not
		return select(2, UnitClass("player"))
	end
	-- iterate over the party
	for i = 1, GetNumPartyMembers() do
		if UnitName("party"..i) == name then
			return select(2, UnitClass("party"..i))
		end
	end
	-- still no match, iterate over the whole raid
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i) == name then
			return select(2, UnitClass("raid"..i))
		end
	end
	-- that player isn't part of our party/raid
	return "unknown"
end
