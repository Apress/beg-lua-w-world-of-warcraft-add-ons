local t = setmetatable({}, {__mode = "v"})

local test1 = {}
local test2 = {}
test1[1] = test2
test2[1] = test2
t[1] = test1

test1 = nil -- drop the references
test2 = nil

print(t[1][1][1][1][1][1][1]) --> table: 00329470
collectgarbage("collect")
print(t[1]) --> nil