HelloWorld_Text = {}
local channel = "SAY"

SLASH_HELLO_WORLD_ADD1 = "/hwadd"
SLASH_HELLO_WORLD_ADD2 = "/helloworldadd" -- an alias for /hwadd
SlashCmdList["HELLO_WORLD_ADD"] = function(msg)
	local id, text = msg:match("(%S+)%s+(.+)")
	if id and text then
		HelloWorld_Text[id:lower()] = text
	else
		print("Usage: /hwadd <id> <text>")
	end
end

SLASH_HELLO_WORLD_SHOW1 = "/hwshow"
SLASH_HELLO_WORLD_SHOW2 = "/helloworldshow" -- an alias for /hwshow
SlashCmdList["HELLO_WORLD_SHOW"] = function(msg)
	local text = HelloWorld_Text[msg:lower()]
	if text then
		SendChatMessage(text, channel)
	end
end
