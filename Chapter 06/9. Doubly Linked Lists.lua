function newList()
   return {first = nil, last = nil} -- empty list head
end

function insertAfter(list, node, data)
   local new = {prev = node, next = node.next, data = data} -- creates a new node
   node.next = new -- the node after node is the new node
   if node == list.last then -- check if the old node is the last node...
      list.last = new -- ...and set the new node as last node
   else
      -- otherwise set the next nodes previous node to the new one
      new.next.prev = new 
   end
   return new -- return the new node
end

function insertAtStart(list, data)
   local new = {prev = nil, next = list.first, data = data} -- create the new node
   if not list.first then -- check if the list is empty
      list.first = new -- the new node is the first and the last in this case
      list.last = new
   else
      -- the node before the old first node is the new first node
      list.first.prev = new
      list.first = new -- update the list's first field
   end
   return new
end

function delete(list, node)
   if node == list.first then -- check if the node is the first one...
      -- ...and set the new first node if we remove the first
      list.first = node.next
   else
      -- set the previous node's next node to the next node
      node.prev.next = node.next
   end
   if node == list.last then -- check if the node is the last one...
      -- ...the new last node is the node before the deleted node
      list.last = node.prev
   else
      node.next.prev = node.prev -- update the next node's prev field
   end
end

function nextNode(list, node)
   return (not node and list.first) or node.next
end


local l = newList()
local a = insertAtStart(l, "a")
local b = insertAtStart(l, "b")
local c = insertAtStart(l, "c")
local d = insertAfter(l, c, "d")

for node in nextNode, l do
   print(node.data)
end

print("----")
delete(l, b)
delete(l, c)

for node in nextNode, l do
   print(node.data)
end