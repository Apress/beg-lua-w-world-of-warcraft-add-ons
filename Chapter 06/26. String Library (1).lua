local text = "fancy <b>html</b> <i>here</i>"
for tag, text in text:gmatch("<(.-)>(.-)</.->") do
   print(tag, text)
end
