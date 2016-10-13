local a = {2, 3, 5, 7, 11, 13, 17}

print(a[1])	--> 2
print(a[5])	--> 11
print(a[10])--> nil
print(#a) 	--> 7

a[8] = 19
print(#a) --> 8

a[8] = nil
a[7] = nil
print(#a) --> 6


local a = {
   {2, 3, 5, 7},
   {1, 4, 9, 16}
}

print(a[1]) 	--> table: 0032A458
print(a[1][1])	--> 2
print(a[2][3])	--> 9
print(a[1][9])	--> nil

-- uncomment the following line to see the error
--print(a[6][1])	--> error: attempt to index field '?' (a nil value)