function foo(arg)
   print("foo was called with the argument", arg)
   return arg
end

print(foo("Hello")) --> foo was called with the argument		Hello
--> Hello

do
   local old = foo
   foo = function(arg)
      if arg == "Hello" then
         return
      else
         return old(arg).."!"
      end
   end
end

print(foo("Hello")) --> nothing happens
print(foo("Hi")) --> foo was called with the argument		Hi
--> Hi!
