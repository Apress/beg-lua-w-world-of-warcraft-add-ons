function copyTable(tbl, copied)
   copied = copied or {}
   local copy = {}
   copied[tbl] = copy
   for i, v in pairs(tbl) do
      if type(v) == "table" then
         if copied[v] then
            copy[i] = copied[v]
         else
            copy[i] = copyTable(v, copied)
         end
      else
         copy[i] = v
      end
   end
   return copy
end

local t = {1, 2, {3}}
t[4] = t[3]
t[5] = t
local t2 = copyTable(t)

print(t2[4] == t2[3]) --> true
print(t2[5] == t2) --> true
print(t2[5][4][1]) --> 3