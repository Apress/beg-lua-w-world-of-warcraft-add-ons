---------------------
--  Table Browser  --
---------------------
POKER_BROWSER_TITLE		= "Poker Table Browser"

-- table list
POKER_BROWSER_NAME		= "Table Name"
POKER_BROWSER_HOST		= "Host"
POKER_BROWSER_PLAYERS	= "Players"
POKER_BROWSER_BLINDS	= "Blinds"

-- buttons
POKER_BROWSER_JOIN			= "Join Table"
POKER_BROWSER_ENTER_NAME	= "Enter a Name"
POKER_BROWSER_CREATE_TABLE	= "Create Table"
POKER_BROWSER_CLOSE			= "Close"

-- join by name popup
POKER_ENTER_NAME_DIALOG = "Please enter the host's name of the table you want to join"


--------------------
--  Create Table  --
--------------------
POKER_CREATE_TITLE		= "Host Game"

-- edit box
POKER_CREATE_TABLE_NAME	= "Table Name"

-- sliders
POKER_CREATE_MAXPLAYERS = "Max Players: %d"
POKER_CREATE_SMALLBLIND = "Small Blind: %d"
POKER_CREATE_BIGBLIND = "Big Blind: %d"

-- check boxes
POKER_CREATE_EVERYONE = "Allow Everyone to Join"
POKER_CREATE_GROUP = "Allow Group Members to Join"
POKER_CREATE_GUILD = "Allow Guild Members to Join"
POKER_CREATE_FRIENDS = "Allow Friends to Join"

---------------------------
--  Auxiliary Functions  --
---------------------------
POKER_CARD_NAME = "%s of %s"
POKER_CARDS = {
	A = "Ace",
	K = "King",
	Q = "Queen",
	J = "Jack",
	["10"] = "Ten",
	["9"] = "Nine",
	["8"] = "Eight",
	["7"] = "Seven",
	["6"] = "Six",
	["5"] = "Five",
	["4"] = "Four",
	["3"] = "Three",
	["2"] = "Two",
}
POKER_SUITS = {
	H = "Hearts",
	D = "Diamonds",
	C = "Clubs",
	S = "Spades",
}

POKER_STRAIGHT_FLUSH = "%s-high Straight Flush"
POKER_FOUR_OF_A_KIND = "Four of a Kind: %s"
POKER_FULL_HOUSE = "Full House: %ss full of %ss"
POKER_FLUSH = "%s-high Flush"
POKER_STRAIGHT = "%s-high Straight"
POKER_THREE_OF_A_KIND = "Three of a Kind: %s"
POKER_TWO_PAIR = "Two Pair: %ss over %ss"
POKER_PAIR = "Pair: %s"
POKER_HIGH_CARD = "High card: %s"


------------
-- Client --
------------

POKER_CLIENT_TITLE			= "Texas Hold'em"
POKER_CLIENT_LEAVE_TABLE	= "Leave Table"
POKER_WELCOME_MSG			= "You are now playing on %s's table!"

POKER_CLIENT_ERROR_ACCESS_DENIED	= "Access denied!"
POKER_CLIENT_ERROR_SERVER_FULL		= "Server is full, please try again later."

POKER_POT		= "Pot: %d"
POKER_CHIPS		= "Chips: %d"

POKER_CLIENT_BET			= "Raise:"
POKER_CLIENT_ALL_IN			= "All-in!"
POKER_CLIENT_RAISE			= "Raise by %d"
POKER_CLIENT_CHECK			= "Check"
POKER_CLIENT_FOLD			= "Fold"
POKER_CLIENT_CALL			= "Call %d"
POKER_CLIENT_CALL_NO_FMT	= "Call"

POKER_CLIENT_NEW_PLAYER		= "%s joined the table."
POKER_CLIENT_NEW_ROUND		= "Starting round #%d."
POKER_CLIENT_WINNER_WITH	= "%s wins %d chips with %s."
POKER_CLIENT_WINNER			= "%s wins %d chips."
POKER_CLIENT_PLAYER_DROPPED	= "Lost connection to player %s."
POKER_CLIENT_PLAYER_LEFT	= "Player %s left the table."

POKER_CLIENT_YOU_DISCONNECTED = "You were disconnected from the server, please try to rejoin the game."


