local createPlayer

local servers = {}

local server = {}
local serverMt = {__index = server}

local player = {}
local playerMt = {__index = player}

function server:PlayerJoin(name)
	-- the network code checks if the player is eligible and if we have a free slot
	local player
	for i = 1, self.maxPlayers do -- find free slot
		if not self.playersByPosition[i] then
			player = createPlayer(name, i, self.bigBlind * 30, self)
			player.inactive = true -- the new player will be active in the next round
			self.playersByPosition[i] = player
			table.insert(self.players, player)
			break
		end
	end
	-- tell everyone about the new player
	self:BroadcastMessage("PlayerJoined", name, player.position, player.chips, "folded")
	-- tell the player that we accepted him
	player:SendMessage("Welcome", self.id, player.position, player.chips)
	player:SendState() -- send the current state of the game to the player
	-- check if we are currently wating for players
	if self.state == "waitingForPlayers" then
		-- the transition condition from this state to the state "bettingRoundStarted"
		-- might have become true, so check this
		local playersWithChips = 0
		for i, v in ipairs(self.players) do -- count players with chips
			if v.chips > 0 then
				playersWithChips = playersWithChips + 1
			end
		end
		if playersWithChips >= 2 then -- check transition condition
			self:StartBettingRound(1) -- it became true, change state
		end
	end
end

function server:GetPlayerByName(name)
	for i, v in ipairs(self.players) do
		if v.name == name then
			return v
		end
	end
end

function server:RemovePlayer(player)
	for i, v in ipairs(self.players) do
		if v == player then
			table.remove(self.players, i)
			break
		end
	end
	for i, v in pairs(self.playersByPosition) do
		if v == player then
			self.playersByPosition[i] = nil
			break
		end
	end
end

function server:GetClientByName(name)
	for i, v in ipairs(self.players) do
		if v.name == name then
			return v
		end
	end
end


function server:StartBettingRound(counter)
	-- set new state
	self.state = "bettingRoundStarted"
	self.bettingRound = counter
	self.minRaise = self.bigBlind
	self.call = self.bigBlind
	
	-- entry action depends on "sub-state" bettingRound
	-- 1 = first betting round; pre-flop
	-- 2 = flop
	-- 3 = turn
	-- 4 = river
	-- 5 = showdown; actually not a betting round
	self.currentPlayer = self.smallBlindPos or 1
	if counter == 1 then
		if #self.players <= 1 then
			self.state = "waitingForPlayers"
			self:BroadcastMessage("WaitingForPlayers")
			return
		end
		self.pot = 0
		self.roundCounter = self.roundCounter + 1
		self:BroadcastMessage("NewRound")
		self:BroadcastMessage("NextRoundMessage", self.roundCounter)
		table.wipe(self.communityCards) -- remove community cards
		self:ShuffleCards() -- shuffle cards...
		-- ...before dealing them
		for i, v in ipairs(self.players) do
			-- set inactive players to active if they have chips (new players)
			if v.inactive and v.chips > 0 then
				v.inactive = false
			end
			-- check if the player is active
			if not v.inactive then
				-- draw 2 cards and send them to the player
				v:SendCards(self:DrawCard(), self:DrawCard())
				v.folded = false
				self:BroadcastMessage("PlayerUpdate", v.position, v.chips, "active")
			end
			v.bet = 0
		end
		-- move the dealer button after the loop above
		-- as this loop removes the inactive state from new players
		self:MoveDealerButton()
		-- small/big blinds
		self.playersByPosition[self.smallBlindPos]:Bet(self.smallBlind)
		self.playersByPosition[self.bigBlindPos]:Bet(self.bigBlind)
	elseif counter == 2 then
		-- draw the flop
		self:AddCommunityCard(self:DrawCard())
		self:AddCommunityCard(self:DrawCard())
		self:AddCommunityCard(self:DrawCard())
	elseif counter == 3 then
		-- turn
		self:AddCommunityCard(self:DrawCard())
	elseif counter == 4 then
		-- river
		self:AddCommunityCard(self:DrawCard())
	elseif counter == 5 then
		-- change state to showdown, so we return here
		return self:Showdown()
	end
	-- we will leave this state immediately
	self:WaitForBet(self:GetNextPlayer())
end

function server:WaitForBet(player)
	-- set new state
	self.state = "waitingForBet"
	self.call = self.call or self.bigBlind
	self.waitingFor = player
	-- check if we are at the first player...
	if player.position == self:FindNextPosition(self.bigBlindPos) then
		-- ...if all active players bet the same amount we move to the next betting round
		local roundOver = true
		for i, v in ipairs(self.players) do
			-- player is active and didn't check yet
			if not v.inactive and v.bet ~= self.call then
				roundOver = false
				break
			end
		end
		if roundOver then
			-- change state to "bettingRoundStarted" with bettingRound + 1
			-- this means we have to return here!
			return self:StartBettingRound(self.bettingRound + 1)
		end
	end
	player:SendMessage("YourTurn", self.call, self.minRaise, player.bet or 0) -- your turn, player!
	self:BroadcastMessage("SetActivePlayer", player.position)
	-- set timeout: 45, self:BetTimeout(player)
	self:Schedule(45, self.BetTimeout, self, player)
end

function server:BetTimeout(player)
	if player.bet == self.call then
		player:Bet(0)
	end
end

do
	local function sortPlayers(v1, v2)
		return v1.rating > v2.rating
	end

	function server:Showdown()
		self.state = "showdown"
		local winners = {} -- array of all players who didn't fold
		-- fill the array
		for i, v in ipairs(self.players) do
			-- not inactive and didn't fold
			if not v.inactive and not v.folded then
				winners[#winners + 1] = player
				-- rate the player's cards
				player.rating = PokerLib.RateCards{player.card1, player.card2, unpack(self.communityCards)}
				-- the player has to show his or her cards
				self:BroadcastMessage("Showdown", player.position, player.card1, player.card2)
			end
		end
		-- sort the table descending
		table.sort(winners, sortPlayers)
		if winners[1].rating == winners[2].rating then -- split pot
			self:SplitPot(winners)
		else
			self:BroadcastMessage("TheWinner", winners[1].position, self.pot)
		end
	end
end

function server:GetNextPlayer()
	self.currentPlayer = self:FindNextPosition(self.currentPlayer)
	return self.playersByPosition[self.currentPlayer]
end


function server:FindNextPosition(pos)
	for i = 0, self.maxPlayers - 1 do
		local p = (pos + i) % self.maxPlayers + 1
		if self.playersByPosition[p] and not self.playersByPosition[p].inactive then
			return p
		end
	end
end

function server:MoveDealerButton()
	if not self.dealerPos then -- first round on this table
		-- initial button position
		self.dealerPos = self:FindNextPosition(1)
	else
		-- move the button
		self.dealerPos = self:FindNextPosition(self.dealerPos)
	end
	-- set small blind position
	self.smallBlindPos = self:FindNextPosition(self.dealerPos)
	-- set big blind position
	self.bigBlindPos = self:FindNextPosition(self.smallBlindPos)
	-- tell all clients to move the button
	self:BroadcastMessage("ButtonMoved", self.dealerPos)
end


do
	-- compare function
	local function compare(v1, v2)
		return v1.random > v2.random
	end

	function server:ShuffleCards()
		self.stackPointer = 1 -- reset the stack pointer
		for i, v in ipairs(self.cards) do
			v.random = math.random() -- assign random values to all cards
		end
		table.sort(self.cards, compare) -- sort the array
	end
end

function server:DrawCard()
	local card = self.cards[self.stackPointer]
	self.stackPointer = self.stackPointer + 1
	return card
end

function server:AddCommunityCard(card)
	self.communityCards[#self.communityCards + 1] = card
	self:BroadcastMessage("CommunityCard", card.code)
end


function player:SendCards(card1, card2)
	self.card1 = card1
	self.card2 = card2
	self:SendMessage("YourCards", card1.code, card2.code)
end

-- call, raise and fold
function player:Bet(amount)
	if amount >= self.chips then
		amount = self.chips
	end
	if self.bet + amount < self.server.call and amount ~= self.chips then -- bet too low...it's not even enough to check and the player does have more chips....so someone is trying to cheat ;)
		return
	end
	if self.bet + amount > self.server.call and self.bet + amount < self.server.call + self.server.minRaise and amount ~= self.chips then -- raise too low (does not apply for all-ins)
		return
	end
	self.bet = self.bet + amount
	self.server.call = self.bet 
	self.chips = self.chips - amount
	self.server.pot = self.server.pot + amount
	self.server:BroadcastMessage("PlayerUpdate", self.position, self.chips, "active")
	self.server:WaitForBet(self.server:GetNextPlayer())
end

function player:Fold()
	self.folded = true
	self.server:BroadcastMessage("PlayerUpdate", self.position, self.chips, "folded")
	self.server:CheckForEnd()
end

function server:CheckForEnd()
	local activePlayers = 0
	local winner
	for i, v in ipairs(self.players) do
		if not self.inactive and not self.folded then
			activePlayers = activePlayers + 1
			winner = v
		end
	end
	if activePlayers > 1 then
		self:WaitForBet(self:GetNextPlayer())
	else
		if winner then
			self:BroadcastMessage("WinnerMessage", winner.name, self.pot)
		end
		self:StartBettingRound(1)
	end
end

function Poker_CreateServer(name, maxPlayers, smallBlind, bigBlind, allowEveryone, allowGuild, allowGroup, allowFriends)
	for i, v in ipairs(servers) do
		if v.name == name then
			return print("You are already hosting a server with this name.")
		end
	end
	local obj = {
		name = name, -- server name
		maxPlayers = maxPlayers,
		smallBlind = smallBlind,
		bigBlind = bigBlind,
		allowEveryone = allowEveryone,
		allowGuild = allowGuild,
		allowGroup = allowGroup,
		allowFriends = allowFriends,
		players = {}, -- list of connected players
		playersByPosition = {}, -- key: player position (1-10), value: player
		cards = {PokerLib.GetAllCards()}, -- all cards
		stackPointer = 1, -- stack pointer, increased by 1 when a card is drawn
		communityCards = {}, -- community cards
		id = #servers + 1, -- server id (for multiple servers)
		roundCounter = 0,
		state = "waitingForPlayers" -- current server state
	}
	servers[#servers + 1] = obj
	return setmetatable(obj, serverMt)
end

function createPlayer(name, position, chips, server)
	return setmetatable({
		name = name,
		position = position,
		chips = chips,
		server = server,
		lastPong = GetTime(),
		folded = true,
		bet = 0
	}, playerMt)
end

-- Network Stuff

local frame = CreateFrame("Frame")
do
	local elapsed = 0
	local pingTimer = 0
	-- Game Broadcasts and disconnect detection
	frame:SetScript("OnUpdate", function(self, e)
		elapsed = elapsed + e
		pingTimer = pingTimer + e
		if elapsed >= 3 then
			elapsed = 0
			for i, v in ipairs(servers) do
				if #v.players < v.maxPlayers then
					local msg = string.format("%d\t%d\t%d\t%d\t%s", #v.players, v.maxPlayers, v.smallBlind, v.bigBlind, v.name)
					local sentMsg
					if IsInGuild() and (v.allowGuild or v.allowEveryone) then
						SendAddonMessage("Poker-GA", msg, "GUILD")
						sentMsg = true
					end
					if v.allowGroup or v.allowEveryone then
						if GetNumRaidMembers() > 0 then
							SendAddonMessage("Poker-GA", msg, "RAID")
							sentMsg = true
						elseif GetNumPartyMembers() > 0 then
							SendAddonMessage("Poker-GA", msg, "PARTY")
							sentMsg = true
						end
					end
					if not sentMsg then
						-- no message was sent, fake one for ourselves
						Poker_TableBrowser.CHAT_MSG_ADDON("Poker-GA", msg, "GUILD", UnitName("player"))
					end
				end
				for i, player in ipairs(v.players) do
					if GetTime() - player.lastPong > 90 then
						v:DropPlayer(player)
					end
				end
			end
		end
		
		if pingTimer > 30 then
			pingTimer = 0
			for i, v in ipairs(servers) do
				for i, v in ipairs(v.players) do
					v:SendMessage("Ping")
				end
			end
		end
	end)
end

function server:DropPlayer(player)
	self:BroadcastMessage("PlayerDropped", player.name)
	self:BroadcastMessage("RemovePlayer", player.name)
	self:RemovePlayer(player)
end

function server:OnPlayerLeave(sender)
	player = self:GetPlayerByName(sender)
	self:BroadcastMessage("PlayerLeft", player.name)
	self:BroadcastMessage("RemovePlayer", player.name)
	self:RemovePlayer(player)
end

-- S2C Commands

function server:BroadcastMessage(...)
	for i, v in ipairs(self.players) do
		SendAddonMessage("Poker-S2C", string.join("\t", ...), "WHISPER", v.name)
	end
end

function player:SendMessage(...)
	SendAddonMessage("Poker-S2C", string.join("\t", ...), "WHISPER", self.name)
end

function player:SendState()
	for i, v in ipairs(self.server.players) do
		self:SendMessage("PlayerJoined", v.name, v.position, v.chips, v.folded and "folded" or "active")
	end
	self:SendMessage("ButtonMoved", self.server.dealerPos or 0)
	self:SendMessage("PotChanged", self.server.pot or 0)
	for i, v in ipairs(self.server.communityCards) do
		self:SendMessage("CommunityCard", v.code)
	end
end

-- C2S Commands

function server:OnBet(sender, amount)
	amount = tonumber(amount or 0) or 0
	self:Unschedule(self.BetTimeout, self, sender)
	local player = self:GetPlayerByName(sender)
	player:Bet(amount)
end

function server:OnFold(sender)
	self:Unschedule(self.BetTimeout, self, sender)
	local player = self:GetPlayerByName(sender)
	player:Fold()
end

function server:OnPong(sender)
	sender = self:GetClientByName(sender)
	sender.lastPong = GetTime()
end

do
	local function isInGroup(player)
		if GetNumRaidMembers() > 0 then
			for i = 1, GetNumRaidMembers() do
				if UnitName("raid"..i) == player then
					return true
				end
			end
		elseif GetNumpartyMembers() > 0 then
			for i = 1, GetNumPartyMembers() do
				if UnitName("party"..i) == player then
					return true
				end
			end
		end
		return false
	end
	
	local function isInGuild(player)
		for i = 1, GetNumGuildMembers() do
			if GetGuildRosterInfo(i) == player then
				return true
			end
		end
		return false
	end
	
	local function isFriend(player)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == player then
				return true
			end
		end
		return false
	end
	
	function server:OnJoinRequest(sender)
		if #self.players >= self.maxPlayers then
			return SendAddonMessage("Poker-S2C", "ServerFull", "WHISPER", sender)
		end
		if not self:GetClientByName(sender) and (sender == UnitName("player") or self.allowEveryone or self.allowGroup and isInGroup(sender) or self.allowGuild and isInGuild(sender) or self.allowFriends and isFriend(sender)) then
			return self:PlayerJoin(sender)
		else
			return SendAddonMessage("Poker-S2C", "AccessDenied", "WHISPER", sender)
		end
	end
end

local function handleCommand(sender, serverId, cmd, ...)
	serverId = serverId and tonumber(serverId)
	cmd = tostring(cmd)
	if serverId == 0 and cmd == "JoinRequest" then -- the client doesn't know the id yet so it sends the server's name and id 0
		local serverName = ...
		for i, v in ipairs(servers) do
			if v.name == serverName then
				return v:OnJoinRequest(sender) -- handle this special command here as the checks below (client connected etc.) would obviously fail as the client wants to join the table...
			end
		end
	end
	
	-- check if it is a valid server id, a valid command and if the client is connected
	if serverId and servers[serverId] and servers[serverId]["On"..cmd] and servers[serverId]:GetClientByName(sender) then
		return servers[serverId]["On"..cmd](servers[serverId], sender, ...)
	end
end

frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		local prefix, msg, channel, sender = ...
		if channel == "WHISPER" and prefix == "Poker-C2S" then
			handleCommand(sender, string.split("\t", msg))
		end
	end
end)


-- scheduling/simple timing lib
local stl = SimpleTimingLib:New()

function server:Schedule(...)
	stl:Schedule(...)
end

function server:Unschedule(...)
	stl:Unschedule(...)
end