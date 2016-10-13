local mod = DBM:NewMod("MyFirstBossMod", "DBM-HelloWorld")

mod:SetZone()

mod:RegisterEvents(
	"CHAT_MSG_WHISPER", -- standard event
	"SPELL_CAST_FAILED" -- combat log pseudo-event
)

local warnHelloWorld = mod:NewAnnounce("WarnHelloWorld", 1, 42921)
local specWarnHelloWorld = mod:NewSpecialWarning("SpecWarnHelloWorld")

local timerHelloWorld = mod:NewTimer(60, "TimerHelloWorld", 42921)

function mod:CHAT_MSG_WHISPER(msg, sender)
	if msg:lower() == "hello" then
		warnHelloWorld:Show(sender)
		specWarnHelloWorld:Schedule(5)
	end
end

function mod:SPELL_CAST_FAILED(args)
	timerHelloWorld:Start()
end

