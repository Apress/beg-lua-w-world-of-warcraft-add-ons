print("Hello, World!") --> Hello, World!

function fac(n)
	if n == 0 then
		return 1
	else
		return n * fac(n - 1)
	end
end

for i = 1, 10 do
	print(fac(i)) -- this is executed 10 times
end