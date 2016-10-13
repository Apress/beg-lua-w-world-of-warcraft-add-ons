local function syncHandler(msg)
   -- do stuff here
   -- adding print(msg) here is a bad idea as the msg will be really long
   print("Received a sync message!")
end

local received = {}
local function receive(player, prefix, msg)
   received[player] = received[player] or ""
   received[player] = received[player]..msg
   if prefix == "Foo-End" then
      return syncHandler(received[player])
   end
end

local testMsgs = {}
local player = "TestPlayer"
local msg = string.rep("x", 245)

-- uncomment one of the lines below to see how worse string concatenation can be!
for i = 1, 1000 do
--for i = 1, 5000 do
--for i = 1, 10000 do
--for i = 1, 15000 do
--for i = 1, 20000 do
--for i = 1, 50000 do
   table.insert(testMsgs, {player, "Foo", msg})
end
table.insert(testMsgs, {player, "Foo-End", msg})

for i, v in ipairs(testMsgs) do
   receive(unpack(v))
end

print(os.clock())