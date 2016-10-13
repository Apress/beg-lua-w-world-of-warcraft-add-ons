-- replace these IDs with your favorite mounts' IDs
local groundMounts = {1, 16, 26}
local flyingMounts = {5, 10, 22}

SLASH_MOUNT1 = "/mount"
SlashCmdList["MOUNT"] = function(msg)
	local zone = GetRealZoneText()
	local subZone = GetSubZoneText()
	if IsMounted() then
		Dismount()
	elseif IsFlyableArea() and zone ~= "Wintergrasp" and (zone ~= "Dalaran" or subZone == "Krasus' Landing") then -- you have to localize the zone names if you aren't using an English client
		CallCompanion("MOUNT", flyingMounts[math.random(#flyingMounts)])
	else
		CallCompanion("MOUNT", groundMounts[math.random(#groundMounts)])
	end
end