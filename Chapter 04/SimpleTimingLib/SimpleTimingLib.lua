local tasks = {}

local function onUpdate()
	for i = #tasks, 1, -1 do
		local val = tasks[i]
		if val.time <= GetTime() then
			table.remove(tasks, i)
			val.func(unpack(val))
		end
	end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", onUpdate)


local function schedule(time, func, obj, ...)
	local t = {...}
	t.func = func
	t.time = GetTime() + time
	tasks[#tasks + 1] =  t
end

local function unschedule(func, obj, ...)
	for i = #tasks, 1, -1 do
		local val = tasks[i]
		if not func or val.func == func then
			local matches = true
			for i = 1, select("#", ...) do
				if select(i, ...) ~= val[i] then
					matches = false
					break
				end
			end
			if matches then
				table.remove(tasks, i)
			end
		end
	end
end

function SimpleTimingLib_Unschedule(func, ...)
	return unschedule(func, nil, ...)
end

function SimpleTimingLib_Schedule(time, func, ...)
	return schedule(time, func, nil, ...)
end
