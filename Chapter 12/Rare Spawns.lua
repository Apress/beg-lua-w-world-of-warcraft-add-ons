local rarespawns = {"Loque'nahak", "Hildana Deathstealer", "Fumblub Gearwind",
"Perobas the Bloodthirster", "King Ping", "Crazed Indu'le Survivor",
"Grocklar", "Syreian the Bonecarver", "Griegen", "Aotona", "Vyragosa",
"Putridus the Ancient", "High Thane Jorfus", "Old Crystalbark", "Icehorn",
"Vigdis the War Maiden", "Tukemuth", "Scarlet Highlord Daion", "Seething Hate",
"Zul'drak Sentinel", "Terror Spinner", "King Krush", "Dirkee"}
local targets = ""
for i, v in ipairs(rarespawns) do
   targets= targets.."/targetexact "..v.."\n"
end

local frame = CreateFrame("Button", "RareSpawns", nil, "SecureActionButtonTemplate")
frame:SetAttribute("type", "macro")
frame:SetAttribute("macrotext", targets..[[
/stopmacro [noexists]
/script ChatFrame1:AddMessage("Found a rare spawn: "..UnitName("target"))]])