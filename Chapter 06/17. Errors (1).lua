function myPrint(text)
   print("myPrint: "..text)
end

local ok, errorMsg = pcall(myPrint, nil)
print(ok) --> false
print(errorMsg)	--> 17. Errors (1).lua:2: attempt to concatenate local 'text' (a nil value)
