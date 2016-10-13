-- Abstract Unit
local unitPrototype = {}
unitPrototype.type = "abstract unit"
unitPrototype.name = "unnamed"
unitPrototype.hp = 100
unitPrototype.canTalk = false

function unitPrototype:ReceiveHit(attacker)
   self:Say("I'm being attacked by "..attacker.name)
   self.hp = self.hp - attacker.damage
   if self.hp <= 0 then
      self:Say("I died :(")
      self.dead = true
   end
end

function unitPrototype:Say(text)
   if self.canTalk then
      print("["..self.name.."]: "..text)
   end
end

function unitPrototype:GetType()
   return self.type
end


-- Abstract Attacking Unit
local attackingUnit = setmetatable({}, {__index = unitPrototype})
attackingUnit.type = "attacking unit"
attackingUnit.damage = 5

function attackingUnit:Attack(target)
   if target.dead then
      self:Say("My target is already dead")
      return
   end
   self:Say("Attacking "..target.name)
   target:ReceiveHit(self)
end


-- Abstract Talking Unit
local talkingUnit = setmetatable({}, {__index = unitPrototype})
talkingUnit.type = "talking unit"
talkingUnit.canTalk = true


-- Monster (Inherits from Attacking Unit and Talking Unit)
local monsterPrototype = setmetatable({}, {__index = function(t, k)
   return attackingUnit[k] or talkingUnit[k]
end})
monsterPrototype.type = "monster"

do
   local metatable = {
      __index = monsterPrototype
   }

   function CreateMonster()
      return setmetatable({}, metatable)
   end
end


-- Test Code
m1 = CreateMonster()
m1.name = "Orc"
m2 = CreateMonster()
m2.name = "Bear"

m1:Attack(m2)		--> normal attack texts
print(m1:GetType())	--> monster