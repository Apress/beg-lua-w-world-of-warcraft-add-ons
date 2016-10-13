local function sum(...)
   local result = 0
   for i = 1, select("#", ...) do
      result = result + select(i, ...)
   end
   return result
end

local function hash(k)
   k = tostring(k)
   return sum(k:byte(1, #k))
end

local function resize(self)
   self.size = self.size * 2
   self.usedSlots = 0
   local oldArray = self.kvPairs
   self.kvPairs = {}
   -- rehash the table by inserting all non-nil entries into the new re-sized array
   for i, v in pairs(oldArray) do
      local pair = v
      while pair do
         if pair.value ~= nil then
            self[pair.key] = pair.value
         end
         pair = pair.next
      end
   end
end

HashTableMT = {}
HashTableMT.__index = function(self, k)
   local pos = hash(k) % self.size + 1 -- calculate the position
   if not self.kvPairs[pos] then -- doesn't exist...
      return nil -- ...return nil
   else
      local pair = self.kvPairs[pos]
      while pair do -- traverse the list to find it
         if pair.key == k then -- found the key
            return pair.value -- return the associated value
         end
         pair = pair.next -- check next item in list
      end
      return nil -- requested key didn't exist in this bucket
   end
end

HashTableMT.__newindex = function(self, k, v)
   local pos = hash(k) % self.size + 1 -- calculate the position
   if not self.kvPairs[pos] then -- entry doesn't exist yet
      if v == nil then
         return -- inserting a new nil value is pointless
      end
      self.kvPairs[pos] = {key = k, value = v} -- just add a new key/value pair
      self.usedSlots = self.usedSlots + 1 -- increment the number of used slots
   else
      -- we either have a collision or we are trying to update an existing handler
      -- let's check if the key already exists in this bucket
      local pair = self.kvPairs[pos]
      while pair do
         if pair.key == k then -- found it, let's update it
            pair.value = v -- update...
            return -- ...and return, no need to update the size or resize the array
         end
         pair = pair.next
      end
      -- the entry does exist but our key is not in the bucket
      -- this means we've got a collision :(
      -- --> insert the new element at the beginning of the linked list
      self.kvPairs[pos] = {key = k, value = v, next = self.kvPairs[pos]}
      self.usedSlots = self.usedSlots + 1
   end
   -- check if we reached the limit
   if self.usedSlots > self.size then
      resize(self) -- double the size
   end
end

function CreateHashTable()
   return setmetatable({size = 1, usedSlots = 0, kvPairs = {}}, HashTableMT)
end


-- Tests

print("Test 1: Basic Functionality")
local t = CreateHashTable()
t.a = 1
t.b = 2
t.c = 3
t.d = 4
print(t.a, t.b, t.c, t.d) --> 1 2 3 4
print(rawget(t, "a"), rawget(t, "b")) --> nil nil
print(rawget(t, "c"), rawget(t, "d")) --> nil nil
print(t.kvPairs[1].key, t.kvPairs[1].value) --> d 4
print(t.kvPairs[2].key, t.kvPairs[2].value) --> a 1
print(t.kvPairs[3].key, t.kvPairs[3].value) --> b 2
print(t.kvPairs[4].key, t.kvPairs[4].value) --> c 3


print()
print("Test 2: Collisions")
local t = CreateHashTable()
t[1] = "number"
t["1"] = "string"
print(t[1], t["1"]) --> number string
print(t.kvPairs[2].key, t.kvPairs[2].value) --> 1 number
print(t.kvPairs[2].next.key, t.kvPairs[2].next.value) --> 1 string

print()
print("Test 3: Rehashing")
local t = CreateHashTable()
t.a = 1
t.c = 2
print(t.kvPairs[2].key, t.kvPairs[2].value) --> a 1
print(t.kvPairs[2].next.key, t.kvPairs[2].next.value) --> c 2
t.b = 3
print(t.kvPairs[2].key, t.kvPairs[2].value) --> a 1
print(t.kvPairs[3].key, t.kvPairs[3].value) --> b 3
print(t.kvPairs[4].key, t.kvPairs[4].value) --> c 2