local text = "fancy <b>html</b> <i>here</i>"
print(text:gsub("<(.-)>(.-)<(.-)>", "[%1]%2[%3]"))


local text = "$player says: $text"
local repl = {player = "Tandanu", text = "Hello, World!"}
print(text:gsub("$(%S+)", repl)) --> Tandanu says: Hello, World! 2
