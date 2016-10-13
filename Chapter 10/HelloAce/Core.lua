local HelloWorld = LibStub("AceAddon-3.0"):NewAddon("HelloWorld", "AceConsole-3.0")

HelloWorld:RegisterChatCommand("ahwadd", "AddText")
HelloWorld:RegisterChatCommand("ahwshow", "ShowText")


local defaults = {
   global = {
      channel = "SAY",
      texts = {}
   }
}

function HelloWorld:OnInitialize()
   self.db = LibStub("AceDB-3.0"):New("HelloWorldDB", defaults)
end

function HelloWorld:AddText(msg)
   local identifier, text = msg:match("(%S+)%s+(.+)")
   if identifier and text then
      self.db.global.texts[identifier] = text
      self:Print(string.format("Added \"%s\" as \"%s\"", text, identifier))
   else
      self:Print("Usage: /ahwadd <identifier> <text>")
   end
end

function HelloWorld:ShowText(msg)
   local identifier = msg:trim()
   if self.db.global.texts[identifier] then
      SendChatMessage(self.db.global.texts[identifier], self.db.global.channel)
   else
      self:Print(string.format("Identifier \"%s\" doesn't exist yet.", identifier))
   end
end

local options = {
   name = "Hello, World!",
   type = "group",
   args = {
      channel = {
         name = "Channel",
         desc = "The chat channel the messages are sent to",
         type = "select",
         values = {
            SAY = "say",
            YELL = "yell",
            PARTY = "party",
            RAID = "raid",
            GUILD = "guild",
            BATTLEGROUND = "battleground",
         },
         set = function(info, value)
            HelloWorld.db.global.channel = value
         end,
         get = function()
            return HelloWorld.db.global.channel
         end
      }
   }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("HelloWorld", options, "ahw")
LibStub("AceConfigDialog-3.0"):SetDefaultSize("HelloWorld", 400, 200)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelloWorld")

HelloWorld:RegisterChatCommand("ahwgui", function()
   LibStub("AceConfigDialog-3.0"):Open("HelloWorld")
end)
