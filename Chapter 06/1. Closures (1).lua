function createCounter()
   local x = 0
   return function()
      x = x + 1
      print(x)
   end
end

c1 = createCounter()
c1() --> 1
c1() --> 2
c1() --> 3

c2 = createCounter()
print(c1 == c2)  --> false

c2() --> 1
c2() --> 2
c2() --> 3

c1() --> 4
c1() --> 5
c2() --> 4