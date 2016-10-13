-- global variables
PokerClient = CreateFrame("Frame")

-- local variables
local curHost
local curServerID
local playing
local pot
local mySlot
local myChips
local myCard1
local myCard2
local numCommunityCards
local communityCards = {}
local allCards = {}
local players = {}

-- initialize these locals with their defaults
local function initialize()
	numCommunityCards = 0
	pot = 0
	table.wipe(communityCards)
	table.wipe(allCards)
	table.wipe(players)
	myCard1 = nil
	myCard2 = nil
end

-- print function
function PokerClient:Print(...)
	if PokerClientFrame:IsShown() then
		PokerClientFrameInfoFrame:AddMessage(date("[%H:%M:%S] ", time())..string.join(" ", ...))
	else
		DEFAULT_CHAT_FRAME:AddMessage("[Poker] "..string.join(" ", ...))
	end
end

-- event dispatcher
PokerClient:RegisterEvent("CHAT_MSG_ADDON")
PokerClient:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

-- receive sync messages
function PokerClient:CHAT_MSG_ADDON(prefix, msg, channel, sender)
	if sender ~= curHost or prefix ~= "Poker-S2C" or channel ~= "WHISPER" then
		return
	end
	return self:OnMessage(string.split("\t", msg))
end

function PokerClient:OnMessage(id, ...)
	if self["On"..id] and id ~= "Message" then -- avoid error messages on invalid addon messages
		return self["On"..id](self, ...)
	end
end

-- send sync messages
function PokerClient:SendMessage(...)
	if not curHost then
		return
	end
	SendAddonMessage("Poker-C2S", string.join("\t", curServerID or 0, ...), "WHISPER", curHost)
end


-- join table and initialize stuff
function PokerClient:JoinTable(host, name)
	curHost = host
	self:SendMessage("JoinRequest", name)
end

function PokerClient:OnAccessDenied()
	self:Print(POKER_CLIENT_ERROR_ACCESS_DENIED)
	curHost = nil
end

function PokerClient:OnServerFull()
	self:Print(POKER_CLIENT_ERROR_SERVER_FULL)
	curHost = nil
end

function PokerClient:OnWelcome(serverId, slot, chips)
	serverId = tonumber(serverId or 0) or 0
	slot = tonumber(slot or 0) or 0
	chips = tonumber(chips or 0) or 0
	initialize() -- resets a few variables to their defaults
	curServerID = serverId
	mySlot = slot
	myChips = chips
	playing = true
	PokerClientFrame:Show()
	self:InitializeFrame()
	self:Print(POKER_WELCOME_MSG:format(curHost))
	Poker_TableBrowser:Hide()
end

function PokerClient:InitializeFrame()
	for i = 1, 5 do
		getglobal("PokerClientFrameCommunityCard"..i):Hide()
	end
	for i = 1, 10 do
		getglobal("PokerClientFramePlayer"..i):Hide()
		getglobal("PokerClientFramePlayer"..i.."Cards"):Hide()
		getglobal("PokerClientFramePlayer"..i.."Highlight"):Hide()
	end
	PokerClientFrameBestHand:SetText("")
	PokerClientFramePot:SetText("")
	PokerClientFrameCall:Disable()
	PokerClientFrameRaise:Disable()
	PokerClientFrameCheck:Disable()
	PokerClientFrameFold:Disable()
	numCommunityCards = 0
end

function PokerClient:LeaveTable()
	self:SendMessage("PlayerLeave")
	curServerID = nil
	PokerClientFrame:Hide()
end

function PokerClient:OnNewRound()
	for i = 1, 5 do
		getglobal("PokerClientFrameCommunityCard"..i):Hide()
	end
	for i = 1, 10 do
		getglobal("PokerClientFramePlayer"..i.."Cards"):Hide()
		getglobal("PokerClientFramePlayer"..i.."Highlight"):Hide()
	end
	table.wipe(communityCards)
	numCommunityCards = 0
	PokerClientFrameBestHand:SetText("")
	PokerClientFrameCall:Disable()
	PokerClientFrameRaise:Disable()
	PokerClientFrameCheck:Disable()
	PokerClientFrameFold:Disable()
end

-- announces (next round, winner, etc)
function PokerClient:OnNewPlayerMessage(name)
	self:Print(POKER_CLIENT_NEW_PLAYER:format(name))
end

function PokerClient:OnNextRoundMessage(round)
	self:Print(POKER_CLIENT_NEW_ROUND:format(tonumber(round) or 0))
end

function PokerClient:OnPlayerDropped(name)
	if name == UnitName("player") then -- we should never receive the message for ourselves as this means we didn't respond for 90 seconds...so something went wrong
		PokerClientFrame:Hide()
		curServerID = nil
		self:Print(POKER_CLIENT_YOU_DISCONNECTED)
	else
		self:Print(POKER_CLIENT_PLAYER_DROPPED:format(tostring(name)))
	end
end

function PokerClient:OnPlayerLeft(name)
	if name ~= UnitName("player") then
		self:Print(POKER_CLIENT_PLAYER_LEFT:format(tostring(name)))
	end
end

do
	local winningCards = {}
	
	function PokerClient:OnWinnerMessage(player, amount, card1, card2)
		card1 = PokerLib.GetCardByCode(card1 or "")
		card2 = PokerLib.GetCardByCode(card2 or "")
		if card1 and card2 then
			table.wipe(winningCards)
			for i, v in ipairs(communityCards) do
				table.insert(winningCards, v)
			end
			table.insert(winningCards, card1)
			table.insert(winningCards, card2)
			self:Print(POKER_CLIENT_WINNER_WITH:format(player, amount, PokerLib.RateCards(winningCards)))
		else
			self:Print(POKER_CLIENT_WINNER:format(player, amount))
		end
	end
end

-- new players/player state updates
function PokerClient:OnPlayerJoined(name, slot, chips, status)
	slot = tonumber(slot or 0) or 0
	chips = tonumber(chips or 0) or 0
	status = tostring(status)
	if slot < 1 or slot > 10 then
		return
	end
	self:AddPlayer(slot, name)
	self:SetChips(slot, chips)
	self:SetStatus(slot, status)
end

function PokerClient:OnPlayerUpdate(slot, chips, status)
	slot = tonumber(slot or 0) or 0
	chips = tonumber(chips or 0) or 0
	if slot < 1 or slot > 10 then
		return
	end
	self:SetChips(slot, chips)
	self:SetStatus(slot, status)
end

function PokerClient:OnRemovePlayer(name)
	local slot
	for k, v in pairs(players) do
		if v.name == name then
			slot = k
			players[k] = nil
		end
	end
	if slot then
		getglobal("PokerClientFramePlayer"..slot):Hide()
	end
end

function PokerClient:OnWaitingForPlayers()
	self:InitializeFrame() -- hide everything, we are waiting for players to join
end

function PokerClient:AddPlayer(slot, name)
	slot = tonumber(slot) or 0
	players[slot] = {}
	players[slot].name = name
	getglobal("PokerClientFramePlayer"..slot.."Name"):SetText(name)
	getglobal("PokerClientFramePlayer"..slot):Show()
	getglobal("PokerClientFramePlayer"..slot.."Highlight"):Hide()
	getglobal("PokerClientFramePlayer"..slot.."Portrait"):SetTexture("Interface\\TargetingFrame\\TempPortrait")
end

function PokerClient:SetChips(slot, chips)
	if not players[slot] then return end
	players[slot].chips = chips
	getglobal("PokerClientFramePlayer"..slot.."Chips"):SetText(POKER_CHIPS:format(tonumber(chips) or 0))
	if tonumber(slot) == mySlot then
		PokerClientFrameChips:SetText(POKER_CHIPS:format(chips))
		myChips = chips
	end
end

function PokerClient:SetStatus(slot, status)
	slot = tonumber(slot or 0) or 0
	if not players[slot] then return end
	players[slot].status = status
	if status == "folded" then
		getglobal("PokerClientFramePlayer"..slot.."Cards"):Hide()
		getglobal("PokerClientFramePlayer"..slot.."Highlight"):Hide()
	elseif status == "active" then
		getglobal("PokerClientFramePlayer"..slot.."Cards"):Show()
		if slot ~= mySlot then
			getglobal("PokerClientFramePlayer"..slot.."Cards1"):SetTexture("Interface\\AddOns\\Texas_Hold'em\\images\\cards\\flipside")
			getglobal("PokerClientFramePlayer"..slot.."Cards2"):SetTexture("Interface\\AddOns\\Texas_Hold'em\\images\\cards\\flipside")
		end
		getglobal("PokerClientFramePlayer"..slot.."Highlight"):Hide()
	end
end

do
	local buttonPositions = {
		{"TOP", 60, -100},
		{"TOP", 133, -110},
		{"TOP", 270, -170},
		{"TOP", 270, -310},
		{"TOP", 133, -360},
		{"TOP", 50, -375},
		{"TOP", -145, -360},
		{"TOP", -290, -310},
		{"TOP", -290, -170},
		{"TOP", -145, -110}
	}
	function PokerClient:OnButtonMoved(pos)
		pos = tonumber(pos) or 0
		if pos > 0 and pos <= 10 then
			PokerClientFrameDealerButton:ClearAllPoints()
			PokerClientFrameDealerButton:SetPoint(unpack(buttonPositions[pos]))
			PokerClientFrameDealerButton:Show()
		else
			PokerClientFrameDealerButton:Hide()
		end
	end
end

-- handle bets, turns etc.
local currentMinRaise = 0
local currentCall = 0
function PokerClient:OnYourTurn(call, minRaise, yourCurrentBet)
	minRaise = tonumber(minRaise or 0) or 0
	call = tonumber(call or 0) or 0
	yourCurrentBet = tonumber(yourCurrentBet or 0) or 0
	currentMinRaise = minRaise
	currentCall = call
	PokerClientFrameCall:SetText(POKER_CLIENT_CALL:format(call - yourCurrentBet))
	PokerClientFrameBet:SetText(math.min(minRaise, myChips - call))
	PokerClientFrameRaise:SetText(POKER_CLIENT_RAISE:format(math.min(minRaise, myChips)))
	PokerClientFrameCall:Enable()
	PokerClientFrameRaise:Enable()
	PokerClientFrameCheck:Enable()
	PokerClientFrameFold:Enable()
end

function PokerClient:Raise()
	local raise = tonumber(PokerClientFrameBet:GetText())
	if raise < currentMinRaise and raise < myChips - currentCall then
		PokerClientFrameBet:SetText(math.min(currentMinRaise, myChips - currentCall))
	elseif raise + currentCall > myChips then
		PokerClientFrameBet:SetText(math.min(currentMinRaise, myChips - currentCall))
	else
		self:SendMessage("Bet", raise + currentCall)
	end
end

function PokerClient:Call()
	self:SendMessage("Bet", math.min(currentCall, myChips))
end

function PokerClient:Check()
	self:SendMessage("Raise", 0)
end

function PokerClient:Fold()
	self:SendMessage("Fold")
end

function PokerClient:AllIn()
	PokerClientFrameBet:SetText(math.max(myChips - call, 0))
end

function PokerClient:OnSetActivePlayer(slot)
	slot = tonumber(slot or 0) or 0
	if slot < 1 or slot > 10 then
		return
	end
	if slot ~= mySlot then
		PokerClientFrameCall:Disable()
		PokerClientFrameRaise:Disable()
		PokerClientFrameCheck:Disable()
		PokerClientFrameFold:Disable()
	end
	for i, v in pairs(players) do
		if i ~= slot then
			getglobal("PokerClientFramePlayer"..slot.."Highlight"):Hide()
		else
			getglobal("PokerClientFramePlayer"..slot.."Highlight"):Show()
		end
	end
end


-- card updates
function PokerClient:OnCommunityCard(cardCode)
	local card = PokerLib.GetCardByCode(cardCode)
	if not card then -- invalid card
		return
	end
	numCommunityCards = numCommunityCards + 1
	if numCommunityCards > 5 then
		return
	end
	local frame = getglobal("PokerClientFrameCommunityCard"..numCommunityCards)
	frame:Show()
	frame:SetTexture("Interface\\AddOns\\Texas_Hold'em\\images\\cards\\"..card.code)
	table.insert(communityCards, card)
	table.insert(allCards, card)
	self:UpdateBestCards()
end

function PokerClient:OnYourCards(card1, card2)
	local card1 = PokerLib.GetCardByCode(card1 or "")
	local card2 = PokerLib.GetCardByCode(card2 or "")
	if not card1 or not card2 then
		return
	end
	getglobal("PokerClientFramePlayer"..mySlot.."Cards"):Show()
	getglobal("PokerClientFramePlayer"..mySlot.."Cards1"):SetTexture("Interface\\AddOns\\Texas_Hold'em\\images\\cards\\"..card1.code)
	getglobal("PokerClientFramePlayer"..mySlot.."Cards2"):SetTexture("Interface\\AddOns\\Texas_Hold'em\\images\\cards\\"..card2.code)
	myCard1 = card1
	myCard2 = card2
	table.insert(allCards, card1)
	table.insert(allCards, card2)
	self:UpdateBestCards()
end

function PokerClient:UpdateBestCards()
	local description = PokerLib.RateCards(allCards)
	PokerClientFrameBestHand:SetText(description)
end

-- pot
function PokerClient:OnPotChanged(value)
	pot = tonumber(value or 0) or 0
	PokerClientFramePot:SetFormattedText(POKER_POT, tonumber(value or 0) or 0)
end

-- ping/pong
function PokerClient:OnPing()
	self:SendMessage("Pong")
end

-- set and update player portraits
do
	local t = 0
	PokerClient:SetScript("OnUpdate", function(self, elapsed)
		t = t + elapsed
		if t > 10 then
			t = 0
			for slot, player in pairs(players) do
				local frame = getglobal("PokerClientFramePlayer"..slot.."Portrait")
				if UnitName("player") == player.name then
					SetPortraitTexture(frame, "player")
				else
					if GetNumRaidMembers() > 0 then
						for i = 1, GetNumRaidMembers() do
							if UnitName("raid"..i) == player.name and UnitIsVisible("raid"..i) then
								SetPortraitTexture(frame, "raid"..i)
							end
						end
					elseif GetNumPartyMembers() > 0 then
						for i = 1, GetNumPartyMembers() do
							if UnitName("party"..i) == player.name and UnitIsVisible("party"..i) then
								SetPortraitTexture(frame, "party"..i)
							end
						end
					end
				end
			end
		end
	end)
end

