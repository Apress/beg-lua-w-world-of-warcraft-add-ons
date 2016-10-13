function HelloWorld_Initialize()
	EA_ChatWindow.Print(L"Hello, World from OnInitialize!")
end

function HelloWorld_OnChat()
	local name = GameData.ChatData.name
	local msg = GameData.ChatData.text
	EA_ChatWindow.Print(L"<"..name..L"> "..msg)
end

RegisterEventHandler(SystemData.Events.CHAT_TEXT_ARRIVED, "HelloWorld_OnChat")