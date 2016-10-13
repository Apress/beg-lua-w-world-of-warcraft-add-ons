-- dofile is not available in WoW, so the following line will not be executed in WoW
if dofile then dofile("localization.en.lua") end

local ranks = {"A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"}
local suits = {"H", "D", "C", "S"}
local cards = {}
local cardsByRank = {}

local value = 13
for i, r in ipairs(ranks) do
	cardsByRank[r] = {}
	for i, s in ipairs(suits) do
		cards[#cards + 1] = {
			rank = POKER_CARDS[r],
			suit = POKER_SUITS[s],
			name = POKER_CARD_NAME:format(POKER_CARDS[r], POKER_SUITS[s]),
			code = r..s,
			value = value
		}
		cardsByRank[r][s] = cards[#cards]
	end
	value = value - 1
end

PokerLib = {}

function PokerLib.GetCard(rank, suit)
	return cardsByRank[rank] and cardsByRank[rank][suit]
end

function PokerLib.GetCardByCode(code)
	local rank, suit = code:sub(1, 1), code:sub(2, 2)
	if rank and suit then
		return PokerLib.GetCard(rank, suit)
	end
end

function PokerLib.GetAllCards()
	return unpack(cards)
end

local function compareCards(v1, v2)
	return v1.value > v2.value
end


local findHandFunctions
do
	-- helper functions (note that using arrays is probably faster but performance doesn't matter here...never optimize something that doesn't need to be optimized)
	local removeArg, getMax, addHighest
	function removeArg(n, ...)
		if n > select("#", ...) then
			return ...
		elseif n == 1 then
			return select(2, ...)
		else
			return select(1, ...), removeArg(n - 1, select(2, ...))
		end
	end

	function getMax(...)
		local max = select(1, ...).value
		local maxPos = 1
		for i = 2, select("#", ...) do
			if select(i, ...).value > max then
				max = select(i, ...).value
				maxPos = i
			end
		end
		return max or 0, maxPos
	end

	do
		local function _addHighest(n, sum, ...)
			if n == 0 then
				return sum
			else
				local max, maxPos = getMax(...)
				return _addHighest(n - 1, sum + max, removeArg(maxPos, ...))
			end
		end
		
		function addHighest(n, ...)
			return _addHighest(math.min(n, select("#", ...)), 0, ...)
		end
	end
	
	-- rating functions, it would probably be shorter (and faster) to combine them in a single function that does all the magic
	-- however, this should be easy to read and understand so it's split up into a lot of functions
	local findStraightFlush, findFourOfAKind, findFullHouse, findFlush, findStraight, findThreeOfAKind, findTwoPair, findPair, findHighCard
	
	function findStraightFlush(cards)
		if #cards < 5 then
			return false
		end
		if cards[1].value == 13 then
			cards[#cards + 1] = cards[1]
		end
		local c = 1
		local high = cards[1]
		for i = 2, #cards do
			local prev = cards[i - 1]
			local cur = cards[i]
			if ((prev.value - cur.value) == 1 or (prev.value - cur.value) == -12) and cur.suit == prev.suit then
				c = c + 1
				if c == 5 then break end
			elseif prev.value == cur.value then
				-- do nothing
			else
				c = 1
				high = cur
			end
		end
		if cards[1].value == 13 then
			cards[#cards] = nil
		end
		if c == 5 then
			return true, POKER_STRAIGHT_FLUSH:format(high.rank), 14^9 * high.value
		else
			return false
		end
	end
	
	function findFourOfAKind(cards)
		if #cards < 4 then
			return false
		end
		local found = nil
		local pos = nil
		for i = 1, #cards - 3 do
			if cards[i].value == cards[i + 1].value and cards[i].value == cards[i + 2].value and cards[i].value == cards[i + 3].value then
				found = cards[i]
				pos = i
				break
			end
		end
		if found then
			local kicker = addHighest(1, removeArg(pos, removeArg(pos, removeArg(pos, removeArg(pos, unpack(cards))))))
			return true, POKER_FOUR_OF_A_KIND:format(found.rank), 14^8 * found.value + kicker
		else
			return false
		end
	end
	
	function findFullHouse(cards)
		if #cards < 5 then
			return false
		end
		local found3, found2
		local pos3, pos2
		for i = 1, #cards - 2 do
			if cards[i].value == cards[i + 1].value and cards[i].value == cards[i + 2].value then
				found3 = cards[i]
				pos3 = i
				break
			end
		end
		if not found3 then
			return false
		end
		for i = 1, #cards - 1 do
			if cards[i].value ~= found3.value and cards[i].value == cards[i + 1].value then
				found2 = cards[i]
				pos2 = i
				break
			end
		end
		if found3 and found2 then
			return true, POKER_FULL_HOUSE:format(found3.rank, found2.rank), 14^7 * found3.value + found2.value
		else
			return false
		end
	end
	
	do
		local foundSuits = {}
		function findFlush(cards)
			if #cards < 5 then
				return false
			end
			if table.wipe then
				table.wipe(foundSuits)
			else -- for testing without WoW
				for i,v in pairs(foundSuits) do foundSuits[i] = nil end
			end
			for i, v in ipairs(cards) do
				foundSuits[v.suit] = foundSuits[v.suit] and foundSuits[v.suit] + 1 or 1
			end
			for suit, count in pairs(foundSuits) do
				if count >= 5 then
					local kickers = 0
					local highcard
					for i, card in ipairs(cards) do
						if card.suit == suit then
							kickers = kickers + card.value
							if not highcard then
								highcard = card
							end
						end
					end
					return true, POKER_FLUSH:format(highcard.rank), 14^6 + kickers
				end
			end
			return false
		end
	end
	
	function findStraight(cards)
		if #cards < 5 then
			return false
		end
		if cards[1].value == 13 then
			cards[#cards + 1] = cards[1]
		end
		local c = 1
		local high = cards[1]
		for i = 2, #cards do
			local prev = cards[i - 1]
			local cur = cards[i]
			if (prev.value - cur.value) == 1 or (prev.value - cur.value) == -12 then
				c = c + 1
				if c == 5 then break end
			elseif prev.value == cur.value then
				-- do nothing
			else
				c = 1
				high = cur
			end
		end
		if cards[1].value == 13 then
			cards[#cards] = nil
		end
		if c == 5 then
			return true, POKER_STRAIGHT:format(high.rank), 14^5 * high.value
		else
			return false
		end
	end
	
	function findThreeOfAKind(cards)
		if #cards < 3 then
			return false
		end
		local found = nil
		local pos = nil
		for i = 1, #cards - 2 do
			if cards[i].value == cards[i + 1].value and cards[i].value == cards[i + 2].value then
				found = cards[i]
				pos = i
				break
			end
		end
		if found then
			local kickers = addHighest(2, removeArg(pos, removeArg(pos, removeArg(pos, unpack(cards)))))
			return true, POKER_THREE_OF_A_KIND:format(found.rank), 14^4 * found.value + kickers
		else
			return false
		end
	end
	
	function findTwoPair(cards)
		if #cards < 4 then
			return false
		end
		local found1, found2
		local pos1, pos2
		for i = 1, #cards - 1 do
			if cards[i].value == cards[i + 1].value then
				if not found1 then
					found1 = cards[i]
					pos1 = i
				else
					found2 = cards[i]
					pos2 = i
					break
				end
			end
		end
		if found1 and found2 then
			local kicker = 0
			for i = 1, #cards do
				if cards[i].value > kicker and i ~= pos1 and i ~= pos1 + 1 and i ~= pos2 and i ~= pos2 then
					kicker = cards[i].value
				end
			end
			return true, POKER_TWO_PAIR:format(found1.rank, found2.rank), 14^3 * found1.value + 14^2 * found2.value + kicker
		else
			return false
		end
	end
		
	function findPair(cards)
		local found = nil
		local pos = nil
		for i = 1, #cards - 1 do
			if cards[i].value == cards[i + 1].value then
				found = cards[i]
				pos = i
				break
			end
		end
		if found then
			local kickers = addHighest(3, removeArg(pos, removeArg(pos, unpack(cards))))
			return true, POKER_PAIR:format(found.rank), 14^2 * found.value + kickers
		else
			return false
		end
	end

	function findHighCard(cards)
		return true, POKER_HIGH_CARD:format(cards[1].rank), addHighest(5, unpack(cards))
	end

	findHandFunctions = {
		findStraightFlush,
		findFourOfAKind,
		findFullHouse,
		findFlush,
		findStraight,
		findThreeOfAKind,
		findTwoPair,
		findPair,
		findHighCard
	}
end

function PokerLib.RateCards(cards)
	table.sort(cards, compareCards) -- sort the cards
	for i, func in ipairs(findHandFunctions) do
		local found, text, rating = func(cards)
		if found then
			return text, rating
		end
	end
	return "error", 0
end

function PokerLib.CompareHands(...)
	local result = {}
	for i = 1, select("#", ...) do
		local hand, rating = PokerLib.RateCards(select(i, ...))
		result[#result + 1] = {hand = hand, rating = rating}
	end
end

-- Some simple test cases, uncomment them to verify that the rating function works properly
--[[
assert(select(2, PokerLib.RateCards{ -- high card
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("4", "C"),
	PokerLib.GetCard("7", "S"),
	PokerLib.GetCard("10", "H"),
	PokerLib.GetCard("J", "D"),
	PokerLib.GetCard("Q", "C"),
	PokerLib.GetCard("K", "D")
}) == 12 + 11 + 10 + 9 + 6)

assert(select(2, PokerLib.RateCards{ -- pair
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("9", "S"),
	PokerLib.GetCard("J", "H"),
	PokerLib.GetCard("Q", "D"),
	PokerLib.GetCard("K", "C"),
	PokerLib.GetCard("A", "D")
}) == 14^2 * 8 + 13 + 12 + 11)

assert(select(2, PokerLib.RateCards{ -- two pair
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("9", "S"),
	PokerLib.GetCard("J", "H"),
	PokerLib.GetCard("Q", "D"),
	PokerLib.GetCard("K", "C"),
	PokerLib.GetCard("3", "D")
}) == 14^3 * 8 + 14^2 * 2 + 12)

assert(select(2, PokerLib.RateCards{ -- three of a kind
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("3", "S"),
	PokerLib.GetCard("J", "H"),
	PokerLib.GetCard("3", "D"),
	PokerLib.GetCard("K", "C"),
	PokerLib.GetCard("A", "D")
}) == 14^4 * 2 + 13 + 12)

assert(select(2, PokerLib.RateCards{ -- straight
	PokerLib.GetCard("2", "H"),
	PokerLib.GetCard("3", "C"),
	PokerLib.GetCard("4", "S"),
	PokerLib.GetCard("5", "H"),
	PokerLib.GetCard("Q", "D"),
	PokerLib.GetCard("K", "C"),
	PokerLib.GetCard("A", "D")
}) == 14^5 * 4)

assert(select(2, PokerLib.RateCards{ -- flush
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("9", "S"),
	PokerLib.GetCard("J", "H"),
	PokerLib.GetCard("Q", "H"),
	PokerLib.GetCard("K", "H"),
	PokerLib.GetCard("A", "H")
}) == 14^6 + 13 + 12 + 11 + 10 + 2)

assert(select(2, PokerLib.RateCards{ -- full house
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("9", "S"),
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("Q", "H"),
	PokerLib.GetCard("9", "H"),
	PokerLib.GetCard("A", "D")
}) == 14^7 * 8 + 2)

assert(select(2, PokerLib.RateCards{ -- four of a kind
	PokerLib.GetCard("3", "H"),
	PokerLib.GetCard("9", "C"),
	PokerLib.GetCard("9", "S"),
	PokerLib.GetCard("J", "H"),
	PokerLib.GetCard("9", "H"),
	PokerLib.GetCard("9", "H"),
	PokerLib.GetCard("A", "D")
}) == 14^8 * 8 + 13)

assert(select(2, PokerLib.RateCards{ -- straight flush
	PokerLib.GetCard("6", "H"),
	PokerLib.GetCard("7", "H"),
	PokerLib.GetCard("8", "H"),
	PokerLib.GetCard("9", "H"),
	PokerLib.GetCard("10", "H"),
	PokerLib.GetCard("A", "H"),
	PokerLib.GetCard("A", "H")
}) == 14^9 * 9)

--]]