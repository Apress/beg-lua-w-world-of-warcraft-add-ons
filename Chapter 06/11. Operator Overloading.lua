do
   local vectorMetatable = {}

   vectorMetatable.__tostring = function(self)
      return string.format("Vector: x = %f; y = %f; z = %f", self.x, self.y, self.z)
   end

   vectorMetatable.__add = function(v1, v2)
      return CreateVector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
   end

   vectorMetatable.__mul = function(v1, v2)
      if type(v1) == "number" then
         v1, v2 = v2, v1
      end
      if type(v2) == "number" then
         return CreateVector(v1.x * v2, v1.y * v2, v1.z * v2)
      else
         return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
      end
   end

   vectorMetatable.__eq = function(v1, v2)
      return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
   end


   function CreateVector(x, y, z)
      x = x or 0
      y = y or 0
      z = z or 0	
      local obj = {x = x, y = y, z = z}
      return setmetatable(obj, vectorMetatable)
   end
end

v1 = CreateVector(1, 2, 3)
v2 = CreateVector(1, 0, 0)

print(v1) -- Vector: x = 1.000000; y = 2.000000; z = 3.000000
print(v1 + v2) -- Vector: x = 2.000000; y = 2.000000; z = 3.000000 

print(v1 * 5) -- Vector: x = 5.000000; y = 10.000000; z = 15.000000
print(5 * v1) -- Vector: x = 5.000000; y = 10.000000; z = 15.000000
print(v1 * v2) -- 1

print(CreateVector(1, 2, 3) == v1) -- true