local function index(self, k)
   return getmetatable(self)[k]
end

local function newindex(self, k, v)
   local mt = getmetatable(self)
   local old = mt[k]
   mt[k] = v
   if old and v == nil then -- deleting an existing entry
      mt.__size = mt.__size - 1
   elseif not old and v ~= nil then
      mt.__size = mt.__size + 1 -- adding a new entry
   end
end

local function len(self)
   return getmetatable(self).__size
end

function NewHashTable()
   local obj = newproxy(true)
   getmetatable(obj).__index = index
   getmetatable(obj).__newindex = newindex
   getmetatable(obj).__len = len
   getmetatable(obj).__size = 0
   return obj
end

local t = NewHashTable()
print(#t) --> 0
t.foo = "bar"
print(#t) --> 1
t.x = 1
t.y = 2
t.z = 3
print(#t) --> 4
t.foo = nil
print(#t) --> 3
t[1] = 4 -- also counts entries in the array part
print(#t) --> 4
