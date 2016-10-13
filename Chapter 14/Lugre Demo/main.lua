--###############################
--###        CONSTANTS        ###
--###############################

gMainWorkingDir = GetMainWorkingDir and GetMainWorkingDir() or ""
datapath = gMainWorkingDir.."data/"
libpath = datapath.."lua/"
lugreluapath = gMainWorkingDir..(file_exists(gMainWorkingDir.."mylugre") and "mylugre/lua/" or "lugre/lua/")
gConfigPath 		= datapath.."config.lua"
gConfigPathFallback	= datapath.."config.lua.dist"
gSecondsSinceLastFrame = 0
gMyFrameCounter = 0

--###############################
--###     OTHER LUA FILES     ###
--###############################

-- utils first
print("MainWorkingDir",gMainWorkingDir)
print("lugreluapath",lugreluapath)
dofile(lugreluapath .. "lugre.lua")
lugre_include_libs(lugreluapath)
--dofile(libpath .. "lib.myfile.lua")

--###############################
--###        CONFIG           ###
--###############################

dofile(gConfigPathFallback)
if (file_exists(gConfigPath)) then
	-- execute local config
	dofile(gConfigPath)
else
	-- no local config file, create empty
	local fp = io.open(gConfigPath,"w")
	fp:write("# this is your local config file, here you can override the options from "..gConfigPathFallback.."\n")
	fp:close()
end

--###############################
--###        FUNCTIONS        ###
--###############################

--- called from c right before Main() for every commandline argument
gCommandLineArguments = {}
gCommandLineSwitches = {}
function CommandLineArgument (i,s) gCommandLineArguments[i] = s gCommandLineSwitches[s] = i end

function HandleCommandLine	() 
	--if (gCommandLineArguments[1] == "-g") then
		--DoSomething(gCommandLineArguments[2])
	--end
end

local function CreateTree(leaves, leafScale, leafMaterial, x, y, z)
   local p = CreateCaduneTreeParameters()
   p:SetNumLeaves(leaves)
   p:SetLeafScale(leafScale)
   p:SetLeafMaterial(leafMaterial)
   local s = CreateCaduneTreeStem(p)
   s:Grow()
   local gfx_stem = s:CreateGeometry()
   local gfx_leav = s:CreateLeaves()
   gfx_stem:SetPosition(x, y, z)
   gfx_leav:SetPosition(x, y, z)
   return s
end


--- main function, when it returns, the program ends
function Main ()
	local luaversion = string.sub(_VERSION, 5, 7)
	print("Lua version : "..luaversion)

	HandleCommandLine()
	
	gMyTicks = Client_GetTicks()
	
	if (not InitOgre("LugreExample",lugre_detect_ogre_plugin_path())) then Exit() end
	if (OgreInitResLocs) then OgreInitResLocs() end
	
	Client_RenderOneFrame() -- first frame rendered with ogre, needed for init of viewport size
	
	----- your init code here ----
	Bind("v",   function (state) Client_TakeScreenshot(gMainWorkingDir.."screenshots/") end )

	-- Example Code here!
	local s1 = CreateTree(10, 3, "Leaves/Ivylite", -10, -10, 10)
	local s2 = CreateTree(3, 5, "Leaves/Orange", 10, -10, 10)
	local caelum = CreateCaelumCaelumSystem(
		CAELUM_COMPONENT_SKY_DOME +
		CAELUM_COMPONENT_SUN + 
		CAELUM_COMPONENT_CLOUDS +
		CAELUM_COMPONENT_MOON +
		CAELUM_COMPONENT_IMAGE_STARFIELD
	)
	caelum:SetManageSceneFog(true)
	caelum:SetSceneFogDensityMultiplier(0.0001)
	caelum:SetManageAmbientLight(true)
	caelum:GetUniversalClock():SetTimeScale(1000)
	
	-- mainloop
	while (Client_IsAlive()) do MainStep() end

	----- your deinit code here ----
	
	--Cleanup
	if (gfx) then gfx:Destroy() end
	if (s) then s:Destroy() end
	if (p) then p:Destroy() end
	------------------------------
end

-- called every frame, after all timer-steppers, see Step() in lib.time.lua
function MainStep ()
	if (gMainWindowSizeDirty) then UpdateMainWindowSize() end
	
	LugreStep()
	
	NetReadAndWrite()
	
	InputStep() -- generate mouse_left_drag_* and mouse_left_click_single events 
	GUIStep() -- generate mouse_enter, mouse_leave events (might adjust cursor -> before CursorStep)
	ToolTipStep() -- needs mouse_enter, should be after GUIStep
	
	CursorStep() -- update cursor gfx pos, should be directly before frame is drawn
	Client_RenderOneFrame()
		
	if gBall then gBall:SetAnimTimePos(Client_GetTicks() / 1000) end
	if gChild then gChild:SetAnimTimePos(Client_GetTicks() / 1000) end

	-- kill the programm with the escape key
	if gKeyPressed[GetNamedKey("escape")] then Terminate() end

	--SoundStep()
	Client_USleep(1) -- just 1 millisecond, but gives other processes a chance to do something
end


-- called from c, WARNING ! also called during window creation, just use this to set a flag for later !
function NotifyMainWindowResized (w,h) gMainWindowSizeDirty = true end
function UpdateMainWindowSize ()
	gMainWindowSizeDirty = false
	-- set aspect ratio
	-- TODO : right&center alignment hud elements
	local vp = GetMainViewport()
	GetMainCam():SetAspectRatio(vp:GetActualWidth() / vp:GetActualHeight())
end

function MouseEnterHUDElement () end -- obsolete : HUDElement2D.cpp
function MouseLeaveHUDElement () end -- obsolete : HUDElement2D.cpp

