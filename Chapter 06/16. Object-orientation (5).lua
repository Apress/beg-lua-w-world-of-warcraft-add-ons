local stack = {}
function stack:Push(v)
   self[#self + 1] = v
end

function stack:Pop()
   return table.remove(self)
end

do
   local stackMt = {__index = stack}
   function stack:New(...)
      return setmetatable({...}, stackMt)
   end
end

local s1 = stack:New("a", "b", "c")
print(s1:Pop()) --> c
s1:Push("x")
print(s1:Pop()) --> x