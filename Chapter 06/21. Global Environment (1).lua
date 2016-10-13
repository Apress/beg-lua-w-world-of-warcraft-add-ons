setmetatable(_G, {__index = function(t, k) return k end})
print(x)  --> x
print(some_global_variable)  --> some_global_variable