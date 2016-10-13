local monsterPrototype = {}

monsterPrototype.name = "unnamed"
monsterPrototype.hp = 100
monsterPrototype.damage = 8
monsterPrototype.dead = false

function monsterPrototype:Attack(target)
   if target.dead then
      return self:Say("My target is already dead")

   end
   self:Say("Attacking "..target.name)
   target:ReceiveHit(self)
end

function monsterPrototype:Say(text)
   print("["..self.name.."]: "..text)
end

function monsterPrototype:ReceiveHit(attacker)
   self:Say("I'm being attacked by "..attacker.name)
   self.hp = self.hp - attacker.damage
   if self.hp <= 0 then
      self:Say("I died :(")
      self.dead = true
   end
end

do
   local metatable = {
      __index = monsterPrototype
   }
 
   function CreateMonster()
      return setmetatable({}, metatable)
   end
end


local m1 = CreateMonster()
m1.name = "Orc"

local m2 = CreateMonster()
m2.name = "Bear"
m2.hp	= 15

m1:Attack(m2)
m1:Attack(m2)
m1:Attack(m2)
