-- the first and last timer objects in the double-linked list
local firstTimer, lastTimer

-- prototype for the timer object
local timer = {}

local popOrCreateFrame, pushFrame
do
	local id = 1
	local frameStack -- the object on the top of the stack
	
	-- pops a frame from the stack or creates a new frame
	function popOrCreateFrame()
		local frame
		if frameStack then -- old frame exists
			frame = frameStack -- re-use it...
			-- ...and remove it from the stack by chaning the object on the top
			frameStack = frameStack.next
			frame:Show() -- it might be hidden
		else -- stack is empty...
			-- ...so we have to create a new frame
			frame = CreateFrame("StatusBar", "CooldownMonitor_Bar"..id, CooldownMonitor_Anchor, "CooldownBarTemplate")
			id = id + 1 -- increase the id
		end
		return frame
	end
	
	-- pushes a frame on the stack
	function pushFrame(frame)
		-- delete the reference to the object to allow
		-- the garbage collector to collect it
		frame.obj = nil
		-- the next object on the stack is the one that is currently on the top
		frame.next = frameStack
		-- the new object on the top is the new one
		frameStack = frame
	end
end


local mt = {__index = timer} -- metatable

-- the constructor
function CooldownMonitor.StartTimer(timer, player, spell, texture)
	local frame = popOrCreateFrame() -- create or recycle a frame
	local class = CooldownMonitor.GetClassByName(player) -- the class of player
	-- set the color the status bar by using color informations from the table
	-- RAID_CLASS_COLORS that contains the default colors of all classes
	if RAID_CLASS_COLORS[class] then
		local color = RAID_CLASS_COLORS[class]
		frame:SetStatusBarColor(color.r, color.g, color.b)
	else -- this should actually never happen
		frame:SetStatusBarColor(1, 0.7, 0) -- default color from the template
	end
	-- set the text
	_G[frame:GetName().."Text"]:SetFormattedText("%s: %s", player, spell)
	-- and the icon
	local ok = _G[frame:GetName().."Icon"]:SetTexture(texture)
	if ok then
		_G[frame:GetName().."Icon"]:Show()
	else -- hide the texture if it couldn't be loaded for some reason
		_G[frame:GetName().."Icon"]:Hide()
	end
	-- add a short flash effect by fading out the flash texture
	UIFrameFadeOut(_G[frame:GetName().."Flash"], 0.5, 1, 0)
	
	local obj = setmetatable({ -- this is the actual object
		frame = frame, -- the frame is stored in the object...
		totalTime = timer,
		timer = timer
	}, mt)
	frame.obj = obj -- ...and the object in the frame
	-- add the object to the end of the list
	if firstTimer == nil then -- our list is empty
		firstTimer = obj
		lastTimer = obj
	else -- our list is not empty, append it after the last entry
		-- the element in front of our object is the old last element
		obj.prev = lastTimer
		-- the element after the old last element is our object
		lastTimer.next = obj
		-- the new last element is our object
		lastTimer = obj
	end
	obj:SetPosition()
	obj:Update(0)
	return obj -- return the object
end

function timer:SetPosition()
	self.frame:ClearAllPoints()
	if self == firstTimer then -- it's the first timer
		self.frame:SetPoint("CENTER", CooldownMonitor_Anchor, "CENTER")
	else -- it's not the first timer, anchor it to the previous one
		self.frame:SetPoint("TOP", self.prev.frame, "BOTTOM", 0, -11)
	end
end

local function stringFromTimer(t)
	if t <= 60 then
		return string.format("%.1f", t)
	else
		return string.format("%d:%0.2d", t / 60, t % 60)
	end
end

function timer:Update(elapsed)
	self.timer = self.timer - elapsed
	if self.timer <= 0 then -- time's up
		self:Cancel() -- cancel the timer
	else
		-- currentBarPos holds a value between 0 and 1
		local currentBarPos = self.timer / self.totalTime
		-- the min value of a status bar timer is 0 and the max value 1 by default
		self.frame:SetValue(currentBarPos)
		-- update the text
		_G[self.frame:GetName().."Timer"]:SetText(stringFromTimer(self.timer))
		-- set the position of the spark
		_G[self.frame:GetName().."Spark"]:SetPoint("CENTER", self.frame, "LEFT", self.frame:GetWidth() * currentBarPos, 2)
	end
end

function timer:Cancel()
	-- remove it from the list
	if self == firstTimer then
		firstTimer = self.next
	else
		self.prev.next = self.next
	end
	if self == lastTimer then
		lastTimer = self.prev
	else
		self.next.prev = self.prev
	end
	-- update the position of the next timer if there is a next timer
	if self.next then
		self.next:SetPosition()
	end
	self.frame:Hide() -- hide the frame...
	pushFrame(self.frame) -- ...and recycle it
end

local timingLib = SimpleTimingLib:New()
local function lock()
	CooldownMonitor_Anchor.unlocked = false
end


local updater=CreateFrame("Frame")
updater:SetScript("OnUpdate", function(self, elapsed)
	if CooldownMonitor_Anchor:IsShown() and not CooldownMonitor_Anchor:IsVisible() then
		local timer = firstTimer
		while timer do
			timer:Update(elapsed)
			timer = timer.next
		end
	end
end)


function CooldownMonitor.Unlock()
	CooldownMonitor.StartTimer(45, "CooldownMonitor", "unlocked")
	CooldownMonitor_Anchor.unlocked = true
	timingLib:Schedule(45, lock)
end