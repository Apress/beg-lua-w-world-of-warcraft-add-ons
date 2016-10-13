local function foo()
   for i = 1, math.huge do
      coroutine.yield(i)
   end
end

local co = coroutine.wrap(foo)
print(co())  --> 1
print(co())  --> 2
print(co())  --> 3