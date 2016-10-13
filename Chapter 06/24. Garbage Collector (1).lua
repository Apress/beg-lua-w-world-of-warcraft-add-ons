local t = setmetatable({}, {__mode = "v"})

t[1] = {}
print(t[1])  --> table: 00329450

for i = 1, 100 do
   t[i] = {}
end

for i,  v in pairs(t) do
   print(v)
end

t[1] = {}
collectgarbage("collect")
print(t[1])  --> nil