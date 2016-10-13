-- Abstract Unit
local unitPrototype = {}
unitPrototype.name = "unnamed"
unitPrototype.hp = 100
unitPrototype.dead = false -- actually not requried as it would start with nil...
-- ... and nil and false is the same for us in this example

function unitPrototype:Say(text)
   print(self.name..": "..text)
end

function unitPrototype:ReceiveHit(attacker)
   self:Say("I'm being attacked by "..attacker.name)
   self.hp = self.hp - attacker.damage
   if self.hp <= 0 then
      self:Say("I died :(")
      self.dead = true
   end
end


-- Abstract Attacking Unit
local attackingUnit = setmetatable({}, {__index = unitPrototype})
attackingUnit.damage = 5

function attackingUnit:Attack(target)
   if target.dead then
      self:Say("My target is already dead")
      return
   end
   self:Say("Attacking "..target.name)
   target:ReceiveHit(self)
end


-- Monster
local monsterPrototype = setmetatable({}, {__index = attackingUnit})
function monsterPrototype:GetType()
   return "Monster"
end
do
   local metatable = {
      __index = monsterPrototype
   }
 
   function CreateMonster()
      return setmetatable({}, metatable)
   end
end


-- Player
local playerPrototype = setmetatable({}, {__index = attackingUnit})
playerPrototype.hp = 1000
playerPrototype.damage = 60
function playerPrototype:GetType()
   return "Player"
end

do
   local metatable = {
      __index = playerPrototype
   }
 
   function CreatePlayer()
      return setmetatable({}, metatable)
   end
end


-- Test Code
local m1 = CreateMonster()
m1.name = "Orc"

local p1 = CreatePlayer()
p1.name = "Tandanu"

p1:Attack(m1)
p1:Attack(m1) 