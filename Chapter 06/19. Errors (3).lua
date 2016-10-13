function fac(n)
   assert(type(n) == "number",	"Error: cannot calculate the factorial of a "..type(n).." value")
   assert(n >= 0 and n % 1 == 0, "Error: n must be a positive integer")
   if n == 0 then
      return 1
   else
      return n * fac(n - 1)
   end
end


fac(-2)
