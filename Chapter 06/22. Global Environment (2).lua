setmetatable(_G, {__newindex = function(t, k,v)
   print("Created new global variable "..k.." = "..tostring(v))
   rawset(_G, k, v)
end})

x = 5  --> Created new global variable x = 5
test = {}  --> Created new global variable test = table: 003293C0
x = 7 --> nothing