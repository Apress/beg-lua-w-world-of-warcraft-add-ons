do
   local old = print --> Assign a new reference
   print = function(...) --> Redefine the print command
      return old(os.date("%H:%M:%S", os.time()), ...) --> new print command
   end
end

print("Hello, World!")  --> 05:41:19  Hello, World!