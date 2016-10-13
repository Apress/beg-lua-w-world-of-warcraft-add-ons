local function showTooltip(self, linkData)
	local linkType = string.split(":", linkData)
	if linkType == "item"
	or linkType == "spell"
	or linkType == "enchant"
	or linkType == "quest"
	or linkType == "talent"
	or linkType == "glyph"
	or linkType == "unit"
	or linkType == "achievement" then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(linkData)
		GameTooltip:Show()
	end
end
local function hideTooltip()
	GameTooltip:Hide()
end

local function setOrHookHandler(frame, script, func)
	if frame:GetScript(script) then -- check if it already has a script handler...
		frame:HookScript(script, func) -- ...and hook it
	else
		frame:SetScript(script, func) -- set our function as script handler otherwise
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = getglobal("ChatFrame"..i) -- copy a reference
	if frame then -- make sure that the frame exists
		setOrHookHandler(frame, "OnHyperLinkEnter",  showTooltip)
		setOrHookHandler(frame, "OnHyperLinkLeave",  hideTooltip)
	end
end
