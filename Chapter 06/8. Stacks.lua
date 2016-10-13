do
   local t = {}

   function push(v)
      t[#t + 1] = v
   end

   function pop()
      local v = t[#t]
      t[#t] = nil
      return v
   end
end

push("a")
push("b")
print(pop())	--> b
print(pop())	--> a
print(pop())	--> nil