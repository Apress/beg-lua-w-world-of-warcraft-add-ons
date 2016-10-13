local currentItem -- the current item or nil if no auction is running
local bids = {} -- bids on the current item
local prefix = "[SimpleDKP] "

-- default values for saved variables/options
SimpleDKP_Channel = "GUILD" -- the chat channel to use
SimpleDKP_AuctionTime = 30 -- the time (in seconds) for an auction
SimpleDKP_MinBid = 15 -- the minimum amount of DKP you have to bid
SimpleDKP_ACL = {} -- the access control list

local startAuction, endAuction, placeBid, cancelAuction, onEvent

do
   local auctionAlreadyRunning = "There is already an auction running! (on %s)"
   local startingAuction = prefix.."Starting auction for item %s, please place your bids by whispering me. Remaining time: %d seconds."
   local auctionProgress =  prefix.."Time remaining for %s: %d seconds."
   function startAuction(item, starter)
      if currentItem then
         local msg = auctionAlreadyRunning:format(currentItem)
         if starter then
            SendChatMessage(msg, "WHISPER", nil, starter)
         else
            print(msg)
         end
        else
        currentItem = item
        SendChatMessage(startingAuction:format(item, SimpleDKP_AuctionTime), SimpleDKP_Channel)
        if SimpleDKP_AuctionTime > 30 then
          SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 30, SendChatMessage, auctionProgress:format(item, 30), SimpleDKP_Channel)
        end
        if SimpleDKP_AuctionTime > 15 then
          SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 15, SendChatMessage, auctionProgress:format(item, 15), SimpleDKP_Channel)
        end
        if SimpleDKP_AuctionTime > 5 then
          SimpleTimingLib_Schedule(SimpleDKP_AuctionTime - 5, SendChatMessage, auctionProgress:format(item, 5), SimpleDKP_Channel)
        end
        SimpleTimingLib_Schedule(SimpleDKP_AuctionTime, endAuction)
      end
   end
end

do
   local noBids = prefix.."No one wants to have %s :("
   local wonItemFor = prefix.."%s won %s for %d DKP."
   local pleaseRoll = prefix.."%s bid %d DKP on %s, please roll!"
   local highestBidders = prefix.."%d. %s bid %d DKP"
   local sortBids = function(v1, v2)
      return v1.bid > v2.bid
   end

   function endAuction()
      table.sort(bids, sortBids)
      if #bids == 0 then
        SendChatMessage(noBids:format(currentItem), SimpleDKP_Channel)
      elseif #bids == 1 then
       SendChatMessage(wonItemFor:format(bids[1].name, currentItem, SimpleDKP_MinBid), SimpleDKP_Channel)
        SendChatMessage(highestBidders:format(1, bids[1].name, bids[1].bid), SimpleDKP_Channel)
      elseif bids[1].bid ~= bids[2].bid then
        SendChatMessage(wonItemFor:format(bids[1].name, currentItem, bids[2].bid + 1), SimpleDKP_Channel)
        for i = 1, math.min(#bids, 3) do
          SendChatMessage(highestBidders:format(i, bids[i].name, bids[i].bid), SimpleDKP_Channel)
        end
      else
        local str = ""
        for i = 1, #bids do
          if bids[i].bid ~= bids[1].bid then
            break
          else
            if bids[i + 2] and bids[i + 2].bid == bids[i].bid then
               str = str..bids[i].name..", "
            else
               str = str..bids[i].name.." and "
            end
          end
        end
        str = str:sub(0, -6)
        SendChatMessage(pleaseRoll:format(str, bids[1].bid, currentItem), SimpleDKP_Channel)
      end
      
      currentItem = nil
      table.wipe(bids)
   end
end

do
	local cancelled = "Auction cancelled by %s"
	function cancelAuction(sender)
		currentItem = nil
		table.wipe(bids)
		SimpleTimingLib_Unschedule(SendChatMessage)
		SimpleTimingLib_Unschedule(endAuction)
		SendChatMessage(cancelled:format(sender or UnitName("player")), SimpleDKP_Channel)
	end
end

do
   local oldBidDetected = prefix.."Your old bid was %d DKP, your new bid is %d DKP."
   local bidPlaced = prefix.."Your bid of %d DKP has been placed!"
   local bidToLow = prefix.."The lowest bid is %d DKP."
   function onEvent(self, event, msg, sender)
      if event == "CHAT_MSG_WHISPER" and currentItem and tonumber(msg) then
         local bid = tonumber(msg)
         if bid < SimpleDKP_MinBid then
            SendChatMessage(bidToLow:format(SimpleDKP_MinBid), "WHISPER", nil, sender)
            return
         end
         for i, v in ipairs(bids) do -- check if that player already bid
            if sender == v.name then
               SendChatMessage(oldBidDetected:format(v.bid, bid), "WHISPER", nil, sender)
               v.bid = bid
               return
            end
         end
         -- he didn't bid yet, so create a new entry in bids
         table.insert(bids, {bid = bid, name = sender})
		 SendChatMessage(bidPlaced:format(bid), "WHISPER", nil, sender)
      elseif SimpleDKP_ACL[sender] then
	     -- not a whisper or a whisper that is not a bid
		 -- and the sender has the permission to send commands
		 local cmd, arg = msg:match("^!(%w+)%s*(.*)")
		 if cmd and cmd:lower() == "auction" and arg then
		    startAuction(arg, sender)
		 elseif cmd and cmd:lower() == "cancel" then
		    cancelAuction(sender)
		 end
	  end
   end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", onEvent)
frame:RegisterEvent("CHAT_MSG_WHISPER")

frame:RegisterEvent("CHAT_MSG_RAID")
frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
frame:RegisterEvent("CHAT_MSG_GUILD")
frame:RegisterEvent("CHAT_MSG_OFFICER")

SLASH_SimpleDKP1 = "/simpledkp"
SLASH_SimpleDKP2 = "/sdkp"

do
   local setChannel = "Channel is now \"%s\""
   local setTime = "Time is now %s"
   local setMinBid = "Lowest bid is now %s"
   local addedToACL = "Added %s player(s) to the ACL"
   local removedFromACL = "Removed %s player(s) from the ACL"
   local currChannel = "Channel is currently set to \"%s\""
   local currTime = "Time is currently set to %s"
   local currMinBid = "Lowest bid is currently set to %s"
   local ACL = "Access Control List:"
   
   local function addToACL(...)
      for i = 1, select("#", ...) do
         SimpleDKP_ACL[select(i, ...)] = true
      end
      print(addedToACL:format(select("#", ...)))
   end
   local function removeFromACL(...)
      for i = 1, select("#", ...) do
         SimpleDKP_ACL[select(i, ...)] = nil
      end
      print(removedFromACL:format(select("#", ...)))
   end
   
   SlashCmdList["SimpleDKP"] = function(msg)
      local cmd, arg = string.split(" ", msg)
      cmd = cmd:lower()
      if cmd == "start" and arg then
         startAuction(msg:match("^start%s+(.+)"))
      elseif cmd == "stop" then
         stopAuction()
      elseif cmd == "channel" then
         if arg then
            SimpleDKP_Channel = arg:upper()
            print(setChannel:format(SimpleDKP_Channel))
         else
            print(currChannel:format(SimpleDKP_Channel))
         end
      elseif cmd == "time" then
         if arg and tonumber(arg) then
            SimpleDKP_AuctionTime = tonumber(arg)
         print(setTime:format(SimpleDKP_AuctionTime))
         else
            print(currTime:format(SimpleDKP_AuctionTime))
         end
      elseif cmd == "minbid" then
         if arg and tonumber(arg) then
            SimpleDKP_MinBid = tonumber(arg)
            print(setMinBid:format(SimpleDKP_MinBid))
         else
            print(currMinBid:format(SimpleDKP_MinBid))
         end
      elseif cmd == "acl" then
         if not arg then
            print(ACL)
            for k, v in pairs(SimpleDKP_ACL) do
               print(k)
            end
         elseif arg:lower() == "add" then
            addToACL(select(3, string.split(" ", msg)))
         elseif arg:lower() == "remove" then
            removeFromACL(select(3, string.split(" ", msg)))
		 end
      end
   end
end

local function filterIncoming(self, event, ...)
	local msg = ... -- get the message from the vararg
	-- return true if there is an ongoing auction and the whisper is a number
	-- followed by all event handler arguments
	return currentItem and tonumber(msg), ...
end

local function filterOutgoing(self, event, ...)
		local msg = ... -- extract the message
	return msg:sub(0, prefix:len()) == prefix, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterIncoming)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterOutgoing)
