function myPrint(text)
   print("myPrint: "..text)
end

xpcall(myPrint, function(err)
   print(err)
   print(debug.traceback())
end)

xpcall(function() myPrint("Hello!") end, function(err)
	print(err)
	print(debug.traceback())
end)