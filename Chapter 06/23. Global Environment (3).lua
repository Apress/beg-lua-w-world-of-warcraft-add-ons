local _G = _G -- save a reference to the old global environment
setfenv(1, setmetatable({}, {
   __index = function(t, k)
      local v = _G[k]
      _G.print("Accessing variable "..k.."; current value: ".._G.tostring(v))
      return v
   end,
   __newindex = function(t, k, v)
      local oldValue = _G[k]
      print("Setting variable "..k.." to ".._G.tostring(v).."; old value: ".._G.tostring(oldValue))
      _G[k] = v
   end
}))

x = 5
x = x + 5
print(x)