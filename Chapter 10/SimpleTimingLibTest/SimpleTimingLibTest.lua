local timingLib = LibStub("SimpleTimingLib-1.0"):New()

SLASH_STL_TEST1 = "/stltest"
SlashCmdList["STL_TEST"] = function(msg)
	local time, code = msg:match("(%d+) (.*)")
	if time and code then
		local func, errorMsg = loadstring(code)
		if func then
			timingLib:Schedule(tonumber(time), func)
		else
			error(errorMsg)
		end
	end
end
