SLASH_WHISPERTARGET1 = "/wtarget"
SLASH_WHISPERTARGET2 = "/wtar" -- alias /wtar <msg>
SlashCmdList["WHISPERTARGET"] = function(msg)
   if UnitName("target") then
      SendChatMessage(msg, "WHISPER", nil, UnitName("target"))
   end
end
