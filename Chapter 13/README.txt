All Lua files that are not wrapped in an addon do not require the game and can 
just be executed with Lua.

The file "Priority Queue used in DBM.lua" contains a code snippet 
from DBM that was mentioned in the chapter, you cannot run this script as it
is usually embedded into DBM. It makes use of some local variables that are 
only visible from within DBM.