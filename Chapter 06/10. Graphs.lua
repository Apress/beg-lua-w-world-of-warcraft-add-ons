local graph = {
   Start = {Q1 = 10, Q2 = 20, Q3 = 45, Q4 = 25},
   Q1 = {Start = 10, Q2 = 10, Q3 = 50, Q4 = 30},
   Q2 = {Start = 30, Q1 = 10, Q3 = 55, Q4 = 35},
   Q3 = {Start = 45, Q1 = 50, Q2 = 55, Q4 = 20},
   Q4 = {Start = 25, Q1 = 30, Q2 = 35, Q3 = 20}
}
function findRoundTrip(start)
   local visited = {
      [start] = true,
   }
   local path = {start}
   local currNode = start
   while true do
      local shortest = nil
      for node, distance in pairs(graph[currNode]) do -- search for the nearest neighbour
         if distance < (shortest and shortest.distance or math.huge)
         and not visited[node] then
            shortest = node
         end
      end
      if shortest then
         currNode = shortest
         visited[shortest] = true
         path[#path + 1] = shortest
      else -- we visited all nodes, return to the first one...
         path[#path + 1] = start
         break -- ...and break the loop
      end
   end
   for i, v in ipairs(path) do -- print the result
      print(v)
   end
end

findRoundTrip("Start")
--> Start
--> Q4
--> Q3
--> Q1
--> Q2
--> Start