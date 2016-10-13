if not Rock then -- check if Rock is present
   return -- cancel loading the file
end

-- create the plugin
local HelloFuBar = Rock:NewAddon("HelloFu", "LibFuBarPlugin-3.0")

function HelloFuBar:OnUpdateFuBarText()
   local zone = GetRealZoneText() -- the current zone
   local x, y = GetPlayerMapPosition("player") -- returns a value between 0 and 1...
   -- ...but the coordinates are usually displayed as a value between 0 and 100
   x, y = x * 100, y * 100 -- so multiply them with 100
   self:SetFuBarText(string.format("%s: %.1f, %.1f", zone, x, y)) -- display it
end

local frame = CreateFrame("Frame")
local t = 0
frame:SetScript("OnUpdate", function(self, elapsed)
   t = t + elapsed
   if t >= 0.1 then
      t = 0
      HelloFuBar:UpdateFuBarPlugin()
   end
end)

function HelloFuBar:OnUpdateFuBarTooltip()
   local x, y = GetPlayerMapPosition("player")
   x, y = x * 100, y * 100
   GameTooltip:AddDoubleLine("Zone", GetRealZoneText())
   GameTooltip:AddDoubleLine("Subzone", GetSubZoneText())
   GameTooltip:AddDoubleLine("X", string.format("%.4f", x))
   GameTooltip:AddDoubleLine("Y", string.format("%.4f", y))
end