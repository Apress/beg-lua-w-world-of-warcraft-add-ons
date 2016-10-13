-- requires SimpleTimingLib!

local function runCmd(cmd)
   local old = ChatFrameEditBox:GetText()
   ChatFrameEditBox:SetText(cmd)
   ChatEdit_SendText(ChatFrameEditBox)
   ChatFrameEditBox:SetText(old)
end

SLASH_IN1 = "/in"
SlashCmdList["IN"] = function(msg)
   local time, cmd = msg:match("(%d+) (.+)")
   if cmd:sub(1, 1) ~= "/" then
      cmd = "/"..cmd
   end
   SimpleTimingLib_Schedule(time, runCmd, cmd)
end