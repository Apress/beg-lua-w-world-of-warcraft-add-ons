function CreateClass(...)
   local parents = {...} -- create a table that holds all parents of the new class
   local class = setmetatable({}, {
      __index = function(t, k)
         for i, v in ipairs(parents) do
            local attr = v[k] -- try to get the requested attribute from a parent...
            if attr ~= nil then
               return attr -- ...and return it if it exists
            end
         end
      end
   })
   local instanceMetatable = {__index = class} -- the metatable used by instances
   class.New = function(self) -- the default constructor
      return setmetatable({}, instanceMetatable)
   end
   return class
end

local unit = CreateClass()
unit.type = "abstract unit"
function unit:GetType(text)
   return self.type
end

local attackingUnit = CreateClass(unit)
attackingUnit.type = "attacking unit"

local talkingUnit = CreateClass(unit)
talkingUnit.type = "talking unit"

local monster = CreateClass(attackingUnit, talkingUnit)


m1 = monster:New()
m2 = talkingUnit:New()

print(m1:GetType()) --> attacking unit
print(m2:GetType()) --> talking unit
