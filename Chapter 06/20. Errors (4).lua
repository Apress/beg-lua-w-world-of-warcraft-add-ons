function fac(n)
   if type(n) ~= "number" then
      error("Error: cannot calculate the factorial of a "..type(n).." value", 2)
   end
   if n >= 0 and n % 1 == 0 then
      error("Error: n must be a positive integer", 1)
   end
   if n == 0 then
      return 1
   else
      return n * fac(n - 1)
   end
end

fac("hello")
