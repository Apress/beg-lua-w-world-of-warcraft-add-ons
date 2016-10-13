function iterator(tbl, key)
   print("Called iterator with tbl = "..tostring(tbl)..", key = "..tostring(key))
   if key == nil then
      return 1, tbl[1] -- return the first key/value pair if key is nil
   else
      key = key + 1 -- get the next key...
      if tbl[key] then
         -- ...and return it with its associated value if it exists
         return key, tbl[key]
      else
         return nil -- we iterated over all elements, let's break the loop
      end
   end
end

t = {"a", "b", "c"}

for i, v in iterator, t do
   print("Loop: i = "..i..", v = "..tostring(v))
end
