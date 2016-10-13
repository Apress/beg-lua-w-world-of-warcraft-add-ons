function createCounter(start)
   local x = start or 0

   return {
      incrementAndPrint = function()
         x = x + 1
         print(x)
      end,

      decrementAndPrint = function()
         x = x - 1
         print(x)
      end,

      getCurrentValue = function()
         return x
      end
   }
end

c1 = createCounter()  --> uses the default value 0
c1.incrementAndPrint()  --> 1
c1.decrementAndPrint() --> 0
print(c1.getCurrentValue())  --> 0

c2= createCounter(5)  --> a new counter starting with 5
c2.incrementAndPrint()  --> 6
print(c2.getCurrentValue())  --> 6

c1.incrementAndPrint() --> 1; the first one still works
