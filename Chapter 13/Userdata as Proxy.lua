local myTable = {}
local p = newproxy(true)
getmetatable(p).__index = function(self, k)
   print("Accessing "..tostring(k))
   return myTable[k]
end

getmetatable(p).__newindex = function(self, k, v)
   print("Setting "..tostring(k).." to "..tostring(v))
   myTable[k] = v
end

p.test = "123"
p.foo = 1
p.foo = p.foo + 1
print(myTable.test)