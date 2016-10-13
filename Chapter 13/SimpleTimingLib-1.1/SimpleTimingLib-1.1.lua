local MAJOR, MINOR = "SimpleTimingLib-1.1", 4
local SimpleTimingLib = LibStub:NewLibrary(MAJOR, MINOR)

if not SimpleTimingLib then
	return -- a greater or equal version is already loaded
end

SimpleTimingLib.tasks = SimpleTimingLib.tasks or nil
local tasks = SimpleTimingLib.tasks

local function onUpdate()
	local node = tasks
	while node do
		if node.time <= GetTime() then
			tasks = node.next
			node.func(unpack(node))
		else
			break
		end
		node = node.next
	end
end

SimpleTimingLib.frame = SimpleTimingLib.frame or CreateFrame("Frame")
local frame = SimpleTimingLib.frame

frame:SetScript("OnUpdate", onUpdate)

function SimpleTimingLib_Schedule(time, func, ...)
   return schedule(time, func, nil, ...)
end

local function schedule(time, func, obj, ...)
   local t = {...}
   t.func = func
   t.time = GetTime() + time
   t.obj = obj
	if not tasks or t.time <= tasks.time then
		 -- list is empty or the new is due before the first one
		 -- insert the new element at the very beginning
		t.next = tasks
		tasks = t
	else
		local node = tasks
		while node.next and node.next.time < time do
			node = node.next
		end
		t.next = node.next
		node.next = t
	end
end

function SimpleTimingLib_Unschedule(func, ...)
   return unschedule(func, nil, ...)
end

local function unschedule(func, obj, ...)
	local node = tasks
	local prev -- previous node required for the removal operation
	while node do
		if node.obj == obj and (not func or node.func == func) then
			local matches = true
			for i = 1, select("#", ...) do
				if select(i, ...) ~= node[i] then
					matches = false
					break
				end
			end
			if matches then
				if not prev then -- trying to remove first node
					tasks = node
				else
					prev.next = node.next
				end
			else
				prev = node
			end
			node = node.next
		end
	end
end

function SimpleTimingLib:Schedule(time, func, ...)
	return schedule(time, func, self, ...)
end

function SimpleTimingLib:Unschedule(func, ...)
	return unschedule(func, self, ...)
end

do
	local metatable = {__index = SimpleTimingLib}
	function SimpleTimingLib:New()
		return setmetatable({}, metatable)
	end
end