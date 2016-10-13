--[[
Name: LibFuBarPlugin-3.0
Revision: $Rev: 55 $
Developed by: ckknight (ckknight@gmail.com) and Arrowmaster
Website: http://www.wowace.com/
Description: Plugin for FuBar.
Dependencies: LibStub
License: LGPL v2.1
]]

local MAJOR_VERSION = "LibFuBarPlugin-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 55 $"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local FuBarPlugin, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not FuBarPlugin then
	return
end
local oldLib
if oldMinor then
	oldLib = {}
	for k, v in pairs(FuBarPlugin) do
		oldLib[k] = v
		FuBarPlugin[k] = nil
	end
end

local SHOW_FUBAR_ICON = "Show FuBar icon"
local SHOW_FUBAR_ICON_DESC = "Show the FuBar plugin's icon on the panel."
local SHOW_FUBAR_TEXT = "Show FuBar text"
local SHOW_FUBAR_TEXT_DESC = "Show the FuBar plugin's text on the panel."
local SHOW_COLORED_FUBAR_TEXT = "Show colored FuBar text"
local SHOW_COLORED_FUBAR_TEXT_DESC = "Allow the FuBar plugin to color its text on the panel."
local DETACH_FUBAR_TOOLTIP = "Detach FuBar tooltip"
local DETACH_FUBAR_TOOLTIP_DESC = "Detach the FuBar tooltip from the panel."
local LOCK_FUBAR_TOOLTIP = "Lock tooltip"
local LOCK_FUBAR_TOOLTIP_DESC = "Lock the tooltips position. When the tooltip is locked, you must use Alt to access it with your mouse."
local POSITION_ON_FUBAR = "Position on FuBar"
local POSITION_ON_FUBAR_DESC = "Position the FuBar plugin on the panel."
local POSITION_LEFT = "Left"
local POSITION_RIGHT = "Right"
local POSITION_CENTER = "Center"
local ATTACH_PLUGIN_TO_MINIMAP = "Attach FuBar plugin to minimap"
local ATTACH_PLUGIN_TO_MINIMAP_DESC = "Attach the FuBar plugin to the minimap instead of the panel."
local HIDE_FUBAR_PLUGIN = "Hide FuBar plugin"
local HIDE_MINIMAP_BUTTON = "Hide minimap button"
local HIDE_FUBAR_PLUGIN_DESC = "Hide the FuBar plugin from the panel or minimap, leaving the addon running."
local OTHER = "Other"
local CLOSE = "Close"
local CLOSE_DESC = "Close the menu."

if GetLocale() == "zhCN" then
	SHOW_FUBAR_ICON = "显示FuBar图标"
	SHOW_FUBAR_ICON_DESC = "在面板上显示FuBar插件的图标."
	SHOW_FUBAR_TEXT = "显示FuBar文字"
	SHOW_FUBAR_TEXT_DESC = "在面板上显示Fubar插件文字标题"
	SHOW_COLORED_FUBAR_TEXT = "显示彩色文字"
	SHOW_COLORED_FUBAR_TEXT_DESC = "允许插件显示彩色文字."
	DETACH_FUBAR_TOOLTIP = "独立提示信息"
	DETACH_FUBAR_TOOLTIP_DESC = "从面板上独立显示信息"
	LOCK_FUBAR_TOOLTIP = "锁定提示信息"
	LOCK_FUBAR_TOOLTIP_DESC = "锁定提示信息位置.当提示信息被锁定时,你必须要按Alt-鼠标方可查看."
	POSITION_ON_FUBAR = "位置"
	POSITION_ON_FUBAR_DESC = "FuBar插件在面板上的位置."
	POSITION_LEFT = "居左"
	POSITION_RIGHT = "居右"
	POSITION_CENTER = "居中"
	ATTACH_PLUGIN_TO_MINIMAP = "依附在小地图"
	ATTACH_PLUGIN_TO_MINIMAP_DESC = "插件图标依附在小地图而不显示在面板上."
	HIDE_FUBAR_PLUGIN = "隐藏FuBar插件"
	HIDE_MINIMAP_BUTTON = "隐藏小地图按钮"
	HIDE_FUBAR_PLUGIN_DESC = "隐藏在面板或小地图上的FuBar插件,暂定插件工作."
	OTHER = "其他"
	CLOSE = "关闭"
	CLOSE_DESC = "关闭目录."
elseif GetLocale() == "zhTW" then
	SHOW_FUBAR_ICON = "顯示圖示"
	SHOW_FUBAR_ICON_DESC = "在面板上顯示插件圖示。"
	SHOW_FUBAR_TEXT = "顯示文字"
	SHOW_FUBAR_TEXT_DESC = "在面板上顯示插件文字。"
	SHOW_COLORED_FUBAR_TEXT = "允許彩色文字"
	SHOW_COLORED_FUBAR_TEXT_DESC = "允許插件在面板上使用彩色文字。"
	DETACH_FUBAR_TOOLTIP = "獨立提示訊息"
	DETACH_FUBAR_TOOLTIP_DESC = "從面板上獨立提示訊息。"
	LOCK_FUBAR_TOOLTIP = "鎖定提示訊息"
	LOCK_FUBAR_TOOLTIP_DESC = "鎖定提示訊息位置。當提示訊息鎖定時，需要用Alt鍵使用提示訊息的功能。"
	POSITION_ON_FUBAR = "位置"
	POSITION_ON_FUBAR_DESC = "插件在面板上的位置。"
	POSITION_LEFT = "靠左"
	POSITION_RIGHT = "靠右"
	POSITION_CENTER = "置中"
	ATTACH_PLUGIN_TO_MINIMAP = "依附在小地圖"
	ATTACH_PLUGIN_TO_MINIMAP_DESC = "插件圖標依附在小地圖而不顯示在面板上。"
	HIDE_FUBAR_PLUGIN = "隱藏插件"
	HIDE_MINIMAP_BUTTON = "隱藏小地圖按鈕"
	HIDE_FUBAR_PLUGIN_DESC = "在面板或小地圖上隱藏該插件，但保持執行狀態。"
	OTHER = "其他"
	CLOSE = "關閉"
	CLOSE_DESC = "關閉選單。"
elseif GetLocale() == "koKR" then
	SHOW_FUBAR_ICON = "FuBar 아이콘 표시"
	SHOW_FUBAR_ICON_DESC = "FuBar 패널에 플러그인 아이콘을 표시합니다."
	SHOW_FUBAR_TEXT = "FuBar 텍스트 표시"
	SHOW_FUBAR_TEXT_DESC = "FuBar 페널에 플러그인 텍스트를 표시합니다."
	SHOW_COLORED_FUBAR_TEXT = "색상화된 FuBar 텍스트 표시"
	SHOW_COLORED_FUBAR_TEXT_DESC = "패널의 FuBar 플러그인의 텍스트 색상을 허용합니다."
	DETACH_FUBAR_TOOLTIP = "FuBar 툴팁 분리"
	DETACH_FUBAR_TOOLTIP_DESC = "패널에서 FuBar 툴팁을 분리합니다."
	LOCK_FUBAR_TOOLTIP = "툴팁 고정"
	LOCK_FUBAR_TOOLTIP_DESC = "툴팁 위치를 고정시킵니다. 툴팁이 고정되어 있을때, 마우스로 접근하기 위해 Alt키를 사용하여야 합니다."
	POSITION_ON_FUBAR = "FuBar 위치"
	POSITION_ON_FUBAR_DESC = "패널 위의 FuBar 플러그인의 위치를 설정합니다."
	POSITION_LEFT = "좌측"
	POSITION_RIGHT = "우측"
	POSITION_CENTER = "중앙"
	ATTACH_PLUGIN_TO_MINIMAP = "FuBar 플러그인 미니맵 표시"
	ATTACH_PLUGIN_TO_MINIMAP_DESC = "FuBar 플러그인을 패널 대신 미니맵에 표시합니다."
	HIDE_FUBAR_PLUGIN = "FuBar 플러그인 숨김"
	HIDE_MINIMAP_BUTTON = "미니맵 버튼 숨김"
	HIDE_FUBAR_PLUGIN_DESC = "FuBar 플러그인을 패널이나 미니맵으로 부터 숨김니다."
	OTHER = "기타"
	CLOSE = "닫기"
	CLOSE_DESC = "메뉴를 닫습니다."
elseif GetLocale() == "frFR" then
	SHOW_FUBAR_ICON = "Afficher l'icône FuBar"
	SHOW_FUBAR_ICON_DESC = "Affiche l'icône du plugin FuBar sur le panneau."
	SHOW_FUBAR_TEXT = "Afficher le texte FuBar"
	SHOW_FUBAR_TEXT_DESC = "Affiche le texte du plugin FuBar sur le panneau."
	SHOW_COLORED_FUBAR_TEXT = "Afficher le texte FuBar coloré"
	SHOW_COLORED_FUBAR_TEXT_DESC = "Autorise le plugin FuBar à colorer son texte sur le panneau."
	DETACH_FUBAR_TOOLTIP = "Détacher l'infobulle FuBar"
	DETACH_FUBAR_TOOLTIP_DESC = "Détache l'infobulle FuBar du panneau."
	LOCK_FUBAR_TOOLTIP = "Verrouiller l'infobulle"
	LOCK_FUBAR_TOOLTIP_DESC = "Verrouille l'infobulle dans sa position actuelle. Quand l'infobulle est verrouillée, vous devez utiliser la touche Alt pour y interagir avec la souris."
	POSITION_ON_FUBAR = "Position sur FuBar"
	POSITION_ON_FUBAR_DESC = "Position du plugin FuBar sur le panneau."
	POSITION_LEFT = "Gauche"
	POSITION_RIGHT = "Droite"
	POSITION_CENTER = "Centre"
	ATTACH_PLUGIN_TO_MINIMAP = "Attacher le plugin FuBar sur la minicarte"
	ATTACH_PLUGIN_TO_MINIMAP_DESC = "Attache le plugin FuBar sur la minicarte au lieu du panneau."
	HIDE_FUBAR_PLUGIN = "Masquer le plugin FuBar"
	HIDE_MINIMAP_BUTTON = "Masquer le bouton de la minicarte"
	HIDE_FUBAR_PLUGIN_DESC = "Masque le plugin FuBar du panneau ou de la minicarte, laissant l'addon fonctionner."
	OTHER = "Autre"
	CLOSE = "Fermer"
	CLOSE_DESC = "Ferme le menu."
elseif GetLocale() == "ruRU" then
	SHOW_FUBAR_ICON = "Показ иконку"
	SHOW_FUBAR_ICON_DESC = "Показывать иконку плагина на панели."
	SHOW_FUBAR_TEXT = "Показ текста"
	SHOW_FUBAR_TEXT_DESC = "Показывать текст плагина на панели."
	SHOW_COLORED_FUBAR_TEXT = "Показ цветового текста"
	SHOW_COLORED_FUBAR_TEXT_DESC = "Позволить плагину использовать его цвета в тексте."
	DETACH_FUBAR_TOOLTIP = "Отделить подсказку"
	DETACH_FUBAR_TOOLTIP_DESC = "Отделить всплывающую подсказку от панели."
	LOCK_FUBAR_TOOLTIP = "Закрепить подсказку"
	LOCK_FUBAR_TOOLTIP_DESC = "Закрепить позицию всплывающей подсказки. Когда всплывающая подсказка закреплена, используйте Alt для отображения ее у мыши."
	POSITION_ON_FUBAR = "Позиция"
	POSITION_ON_FUBAR_DESC = "Позиция плагина на панели."
	POSITION_LEFT = "Слева"
	POSITION_RIGHT = "Справа"
	POSITION_CENTER = "По центру"
	ATTACH_PLUGIN_TO_MINIMAP = "Закрепить у мини-карты"
	ATTACH_PLUGIN_TO_MINIMAP_DESC = "Закрепить плагин у мини-карты вместо панели."
	HIDE_FUBAR_PLUGIN = "Скрыть плагин"
	HIDE_MINIMAP_BUTTON = "Скрыть кнопку у мини-карты"
	HIDE_FUBAR_PLUGIN_DESC = "Скрыть плагин с панели или мини-карты, но оставить аддон в рабочем состоянии."
	OTHER = "Другое"
	CLOSE = "Закрыть"
	CLOSE_DESC = "Закрыть меню."
end

-- #AUTODOC_NAMESPACE FuBarPlugin

local newList, del
do
	local pool = setmetatable({}, {__mode = 'kv'})

	function newList(...)
		local t = next(pool)
		local n = select('#', ...)
		if t then
			pool[t] = nil
			for i = 1, n do
				t[i] = select(i, ...)
			end
		else
			t = { ... }
		end
		
		return t, n
	end

	function del(t)
		if not t then
			error(("Bad argument #1 to `del'. Expected %q, got %q."):format("table", type(t)), 2)
		end
		if pool[t] then
			local _, ret = pcall(error, "Error, double-free syndrome.", 3)
			geterrorhandler()(ret)
		end
		setmetatable(t, nil)
		for k in pairs(t) do
			t[k] = nil
		end
		t[true] = true
		t[true] = nil
		pool[t] = true
	end
end

FuBarPlugin.pluginToFrame = oldLib and oldLib.pluginToFrame or {}
local pluginToFrame = FuBarPlugin.pluginToFrame
FuBarPlugin.pluginToMinimapFrame = oldLib and oldLib.pluginToMinimapFrame or {}
local pluginToMinimapFrame = FuBarPlugin.pluginToMinimapFrame
FuBarPlugin.pluginToPanel = oldLib and oldLib.pluginToPanel or {}
local pluginToPanel = FuBarPlugin.pluginToPanel
FuBarPlugin.pluginToOptions = oldLib and oldLib.pluginToOptions or {}
local pluginToOptions = FuBarPlugin.pluginToOptions
FuBarPlugin.folderNames = oldLib and oldLib.folderNames or {}
local folderNames = FuBarPlugin.folderNames

local RockConfig
local Tablet20
local Dewdrop20
local AceConfigRegistry30
local AceConfigDialog30
local AceConfigDropdown30

FuBarPlugin.MinimapContainer = oldLib and oldLib.MinimapContainer or {}
local MinimapContainer = FuBarPlugin.MinimapContainer

local epsilon = 1e-5

FuBarPlugin.mixinTargets = oldLib and oldLib.mixinTargets or {}
local mixinTargets = FuBarPlugin.mixinTargets
local mixins = {
	"SetFuBarOption",
	"GetTitle",
	"GetName",
	"GetCategory",
	"SetFontSize",
	"GetFrame",
	"Show",
	"Hide",
	"GetPanel",
	"IsFuBarTextColored",
	"ToggleFuBarTextColored",
	"IsFuBarMinimapAttached",
	"ToggleFuBarMinimapAttached",
	"UpdateFuBarPlugin",
	"UpdateFuBarText",
	"UpdateFuBarTooltip",
	"SetFuBarIcon",
	"GetFuBarIcon",
	"CheckWidth",
	"SetFuBarText",
	"GetFuBarText",
	"IsFuBarIconShown",
	"ToggleFuBarIconShown",
	"ShowFuBarIcon",
	"HideFuBarIcon",
	"IsFuBarTextShown",
	"ToggleFuBarTextShown",
	"ShowFuBarText",
	"HideFuBarText",
	"IsFuBarTooltipDetached",
	"ToggleFuBarTooltipDetached",
	"DetachFuBarTooltip",
	"ReattachFuBarTooltip",
	"GetDefaultPosition",
	"SetPanel",
	"IsDisabled",
	"CreateBasicPluginFrame",
	"CreatePluginChildFrame",
	"OpenMenu"
}

-- #AUTODOC_NAMESPACE FuBarPlugin

--[[---------------------------------------------------------------------------
Notes:
	*Set metadata about a certain plugin.
	; tooltipType : string -
	: "GameTooltip"
	:: Use Blizzard's GameTooltip. (default if not given)
	: "Tablet-2.0"
	:: Use Tablet-2.0.
	: "Custom"
	:: LibFuBarPlugin-3.0 will not provide any extra mechanisms, all done manually.
	; configType : string -
	: "LibRockConfig-1.0"
	:: Use LibRockConfig-1.0 to show configuration. (default if not given)
	: "Dewdrop-2.0"
	:: Use Dewdrop-2.0.
	: "AceConfigDialog-3.0"
	:: Use AceConfigDialog-3.0.
	: "AceConfigDropdown-3.0"
	:: Use AceConfigDropdown-3.0.
	; hasNoText : boolean - If set to true, then it will be a text-less frame.
	; iconPath : string - the path of the icon to show.
	; hasNoColor : boolean - If set to true, then it is assumed that no color will be in the text (and thus not show the menu item)
	; cannotHideText : boolean - If set to true, then the menu item to hide text will not be shown.
	; overrideMenu : boolean - If set to true, then the menu will not show any of the standard menu items
	; hideMenuTitle : boolean - If set to true, the plugins name will not be added to the top of the menu as a header.
	; defaultPosition : string -
	: "LEFT"
	::show on the left. (default if not given)
	: "CENTER"
	::show in the center.
	: "RIGHT"
	::show on the right.
	: "MINIMAP"
	::show on the minimap.
	; defaultMinimapPosition : number - Angle on the minimap, in degrees. [0, 360)
	; clickableTooltip : boolean - Whether you can drag your mouse onto the tooltip and click a line
	; tooltipHiddenWhenEmpty : boolean - Whether the detached tooltip is hidden when it is empty.
	; cannotDetachTooltip : boolean - Whether the tooltip cannot be detached from the plugin text.
	::Normally, a tooltip can detach (if using Tablet-2.0). This should be set if there is no relevant data in the tooltip.
	; independentProfile : boolean - If set to true, then the profile setting will not be stripped from .OnMenuRequest, and FuBar will not set the plugin's profile when it changes.
	::non-FuBar-centric plugins should set this to true.
Arguments:
	string - the key to set
	value - the value to set said key to.
Example:
	self:SetFuBarOption('tooltipType', "Tablet-2.0")
-----------------------------------------------------------------------------]]
function FuBarPlugin:SetFuBarOption(key, value)
	local pluginToOptions_self = pluginToOptions[self]
	if not pluginToOptions_self then
		pluginToOptions_self = {}
		pluginToOptions[self] = pluginToOptions_self
	end

	pluginToOptions_self[key] = value

	if key == 'tooltipType' then
		if value == "Tablet-2.0" then
			Tablet20 = LibStub("Tablet-2.0", true)
			if not Tablet20 then
				error(("Cannot specify %q = %q if %q is not loaded."):format(key, value, value), 2)
			end
		end
	end
	if key == 'configType' then
		if value == "Dewdrop-2.0" then
			Dewdrop20 = LibStub("Dewdrop-2.0", true)
			if not Dewdrop20 then
				error(("Cannot specify %q = %q if %q is not loaded."):format(key, value, value), 2)
			end
		elseif value == "AceConfigDialog-3.0" then
			AceConfigRegistry30 = LibStub("AceConfigRegistry-3.0", true)
			AceConfigDialog30 = LibStub("AceConfigDialog-3.0", true)
			if not AceConfigDialog30 then
				error(("Cannot specify %q = %q if %q is not loaded."):format(key, value, value), 2)
			end
		elseif value == "AceConfigDropdown-3.0" then
			AceConfigRegistry30 = LibStub("AceConfigRegistry-3.0", true)
			AceConfigDropdown30 = LibStub("AceConfigDropdown-3.0", true)
			if not AceConfigDropdown30 then
				error(("Cannot specify %q = %q if %q is not loaded."):format(key, value, value), 2)
			end
		end
	end
end

local function getPluginOption(object, key, default)
	local pluginToOptions_object = pluginToOptions[object]
	if pluginToOptions_object == nil then
		return default
	end
	local value = pluginToOptions_object[key]
	if value == nil then
		return default
	end
	return value
end

local good = nil
local function CheckFuBar()
	if not good then
		if FuBar then
			local version = FuBar.version
			if type(version) == "string" then
			 	local num = version:match("^(%d+%.?%d*)")
				if num then
					num = tonumber(num)
					good = num > 2
				end
			end
		end
	end
	return good
end

--[[---------------------------------------------------------------------------
Returns:
	string - the localized name of the plugin, not including the "FuBar - " part.
Example
	local title = self:GetTitle()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetTitle()
	local name = self.title or self.name
	if type(name) ~= "string" then
		error("You must provide self.title or self.name", 2)
	end
	local title = name:match("[Ff][Uu][Bb][Aa][Rr]%s*%-%s*(.-)%s*$") or name
	return title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

--[[---------------------------------------------------------------------------
Returns:
	string - name of the plugin.
Notes:
	This is here for FuBar core to communicate properly.
Example:
	local name = self:GetName()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetName()
	return self.name
end

--[[---------------------------------------------------------------------------
Returns:
	string - category of the plugin.
Notes:
	This is here for FuBar core to communicate properly.
Example:
	local category = self:GetCategory()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetCategory()
	return self.category or OTHER
end

--[[---------------------------------------------------------------------------
Returns:
	frame - frame for the plugin.
Notes:
	This is here for FuBar core to communicate properly.
Example:
	local frame = self:GetFrame()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetFrame()
	return pluginToFrame[self]
end

--[[---------------------------------------------------------------------------
Returns:
	object - panel for the plugin.
Notes:
	This is here for FuBar core to communicate properly.
Example:
	local panel = self:GetPanel()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetPanel()
	return pluginToPanel[self]
end

local function getLazyDatabaseValueDefault(object, value, ...)
	local object_db = object.db
	if type(object_db) ~= "table" then
		return value
	end
	local current = object_db.profile
	for i = 1, select('#', ...) do
		-- traverse through, make sure tables exist.
		if type(current) ~= "table" then
			return value
		end
		current = current[(select(i, ...))]
	end
	if current == nil then
		return value
	else
		return current
	end
end

local function getLazyDatabaseValue(object, ...)
	return getLazyDatabaseValueDefault(object, nil, ...)
end

local function setLazyDatabaseValue(object, value, ...)
	local object_db = object.db
	if type(object_db) ~= "table" then
		return nil
	end
	local current = object_db.profile
	if type(current) ~= "table" then
		return nil
	end
	local n = select('#', ...)
	for i = 1, n-1 do
		-- traverse through, create tables if necessary.
		local nextOne = current[(select(i, ...))]
		if type(nextOne) ~= "table" then
			if nextOne ~= nil then
				return nil
			end
			nextOne = {}
			current[(select(i, ...))] = nextOne
		end
		current = nextOne
	end
	current[select(n, ...)] = value
	return true
end

--[[---------------------------------------------------------------------------
Returns:
	boolean - whether the text has color applied.
Example:
	local colored = self:IsFuBarTextColored()
-----------------------------------------------------------------------------]]
function FuBarPlugin:IsFuBarTextColored()
	return not getLazyDatabaseValue(self, 'uncolored')
end

--[[---------------------------------------------------------------------------
Notes:
	Toggles whether the text has color applied
Example:
	self:ToggleTextColored()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ToggleFuBarTextColored()
	if not setLazyDatabaseValue(self, not getLazyDatabaseValue(self, 'uncolored') or nil, 'uncolored') then
		error(("%s: Cannot change text color if self.db is not available."):format(self:GetTitle()), 2)
	end
	self:UpdateFuBarText()
end

--[[---------------------------------------------------------------------------
Returns:
	boolean - whether the plugin is attached to the minimap.
Example:
	local attached = self:IsMinimapAttached()
-----------------------------------------------------------------------------]]
function FuBarPlugin:IsFuBarMinimapAttached()
	if not CheckFuBar() then
		return true
	end
	return pluginToPanel[self] == MinimapContainer
end

--[[---------------------------------------------------------------------------
Notes:
	Toggles whether the plugin is attached to the minimap.
Example:
	self:ToggleMinimapAttached()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ToggleFuBarMinimapAttached()
	if CheckFuBar() and not getPluginOption(self, 'cannotAttachToMinimap', false) then
		local panel = pluginToPanel[self]
		local value = panel == MinimapContainer
		if value then
			panel:RemovePlugin(self)
			local defaultPosition = getPluginOption(self, 'defaultPosition', "LEFT")
			FuBar:GetPanel(1):AddPlugin(self, nil, defaultPosition == "MINIMAP" and "LEFT" or defaultPosition)
		else
			if panel then
				panel:RemovePlugin(self)
			end
			MinimapContainer:AddPlugin(self)
		end
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Calls :UpdateFuBarText() and :UpdateFuBarTooltip(), in that order.
Example:
	self:UpdateFuBarPlugin()
-----------------------------------------------------------------------------]]
function FuBarPlugin:UpdateFuBarPlugin()
	self:UpdateFuBarText()
	self:UpdateFuBarTooltip()
end

--[[---------------------------------------------------------------------------
Notes:
	* Calls :OnUpdateFuBarText() if it is available and the plugin is not disabled.
	* It is expected to update the icon in :OnUpdateFuBarText as well as text.
Example:
	self:UpdateFuBarText()
-----------------------------------------------------------------------------]]
function FuBarPlugin:UpdateFuBarText()
	if type(self.OnUpdateFuBarText) == "function" then
		if not self:IsDisabled() then
			self:OnUpdateFuBarText()
		end
	elseif self:IsFuBarTextShown() then
		self:SetFuBarText(self:GetTitle())
	end
end

local function Tablet20_point(frame)
	if frame:GetTop() > GetScreenHeight() / 2 then
		local x = frame:GetCenter()
		if x < GetScreenWidth() / 3 then
			return "TOPLEFT", "BOTTOMLEFT"
		elseif x < GetScreenWidth() * 2 / 3 then
			return "TOP", "BOTTOM"
		else
			return "TOPRIGHT", "BOTTOMRIGHT"
		end
	else
		local x = frame:GetCenter()
		if x < GetScreenWidth() / 3 then
			return "BOTTOMLEFT", "TOPLEFT"
		elseif x < GetScreenWidth() * 2 / 3 then
			return "BOTTOM", "TOP"
		else
			return "BOTTOMRIGHT", "TOPRIGHT"
		end
	end
end

local function RegisterTablet20(self)
	local frame = pluginToFrame[self]
	if not Tablet20:IsRegistered(frame) then
		local db = getLazyDatabaseValue(self)
		if db and not db.detachedTooltip then
			db.detachedTooltip = {}
		end
		Tablet20:Register(frame,
			'children', function()
				Tablet20:SetTitle(self:GetTitle())
				if type(self.OnUpdateFuBarTooltip) == "function" then
					if not self:IsDisabled() then
						self:OnUpdateFuBarTooltip()
					end
				end
			end,
			'clickable', getPluginOption(self, 'clickableTooltip', false),
			'data', CheckFuBar() and FuBar.db.profile.tooltip or db and db.detachedTooltip or {},
			'detachedData', db and db.detachedTooltip or {},
			'point', Tablet20_point,
			'menu', self.OnMenuRequest and function(level, value, valueN_1, valueN_2, valueN_3, valueN_4)
				if level == 1 then
					local name = tostring(self)
					if not name:find('^table:') then
						name = name:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
						LibStub("Dewdrop-2.0"):AddLine(
							'text', name,
							'isTitle', true
						)
					end
				end
				if type(self.OnMenuRequest) == "function" then
					self:OnMenuRequest(level, value, true, valueN_1, valueN_2, valueN_3, valueN_4)
				elseif type(self.OnMenuRequest) == "table" then
					LibStub("Dewdrop-2.0"):FeedAceOptionsTable(self.OnMenuRequest)
				end
			end,
			'hideWhenEmpty', getPluginOption(self, 'tooltipHiddenWhenEmpty', false)
		)
		local func = pluginToFrame[self]:GetScript("OnEnter")
		frame:SetScript("OnEnter", function(this, ...)
			-- HACK
			func(this, ...)

			if FuBar and FuBar.IsHidingTooltipsInCombat and FuBar:IsHidingTooltipsInCombat() and InCombatLockdown() then
				if Tablet20:IsAttached(this) then
					Tablet20:Close(this)
				end
			end
		end)
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Calls :OnUpdateFuBarTooltip() if it is available, the plugin is not disabled, and the tooltip is shown.
Example:
	self:UpdateFuBarTooltip()
-----------------------------------------------------------------------------]]
function FuBarPlugin:UpdateFuBarTooltip()
	local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")

	if tooltipType == "GameTooltip" then
		local frame = self:IsFuBarMinimapAttached() and pluginToMinimapFrame[self] or pluginToFrame[self]
		if not GameTooltip:IsOwned(frame) then
			return
		end
		GameTooltip:Hide()

		local anchor
		if frame:GetTop() > GetScreenHeight() / 2 then
			local x = frame:GetCenter()
			if x < GetScreenWidth() / 2 then
				anchor = "ANCHOR_BOTTOMRIGHT"
			else
				anchor = "ANCHOR_BOTTOMLEFT"
			end
		else
			local x = frame:GetCenter()
			if x < GetScreenWidth() / 2 then
				anchor = "ANCHOR_TOPLEFT"
			else
				anchor = "ANCHOR_TOPRIGHT"
			end
		end
		GameTooltip:SetOwner(frame, anchor)
		if type(self.OnUpdateFuBarTooltip) == "function" and not self:IsDisabled() then
			self:OnUpdateFuBarTooltip()
		end
		GameTooltip:Show()
		return
	elseif tooltipType == "Custom" then
		if type(self.OnUpdateFuBarTooltip) == "function" and not self:IsDisabled() then
			self:OnUpdateFuBarTooltip()
		end
		return
	elseif tooltipType == "Tablet-2.0" then
		RegisterTablet20(self)
		if self:IsFuBarMinimapAttached() and not self:IsFuBarTooltipDetached() and pluginToMinimapFrame[self] then
			Tablet20:Refresh(pluginToMinimapFrame[self])
		else
			Tablet20:Refresh(pluginToFrame[self])
		end
	elseif tooltipType == "None" then
		return
	else
		error(("Unknown %s option for %q: %q"):format(MAJOR_VERSION, 'tooltipType', tostring(tooltipType)), 2)
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Shows the plugin, enables the plugin if previously disabled, and calls :UpdateFuBarPlugin().
Example:
	self:Show()
-----------------------------------------------------------------------------]]
function FuBarPlugin:Show(panelId)
	if pluginToFrame[self]:IsShown() or (pluginToMinimapFrame[self] and pluginToMinimapFrame[self]:IsShown()) then
		return
	end
	if panelId ~= false then
		setLazyDatabaseValue(self, nil, 'hidden')
	end
	if self.IsActive and not self:IsActive() then
		self.panelIdTmp = panelId
		self:ToggleActive()
		self.panelIdTmp = nil
		setLazyDatabaseValue(self, nil, 'disabled')
	elseif not getLazyDatabaseValue(self, 'hidden') then
		if panelId == 0 or not CheckFuBar() then
			MinimapContainer:AddPlugin(self)
		else
			FuBar:ShowPlugin(self, panelId or self.panelIdTmp)
		end
		if not getPluginOption(self, 'userDefinedFrame', false) then
			if not self:IsFuBarTextShown() then
				local text = pluginToFrame[self].text
				text:SetText("")
				text:SetWidth(epsilon)
				text:Hide()
			end
			if not self:IsFuBarIconShown() then
				local icon = pluginToFrame[self].icon
				icon:SetWidth(epsilon)
				icon:Hide()
			end
		end
		self:UpdateFuBarPlugin()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Hides the plugin, disables the plugin if cannot hide without standby.
Arguments:
	[optional] boolean - internal variable. Do not set this.
Example:
	self:Hide()
-----------------------------------------------------------------------------]]
function FuBarPlugin:Hide(check)
	if not pluginToFrame[self]:IsShown() and (not pluginToMinimapFrame[self] or not pluginToMinimapFrame[self]:IsShown()) then
		return
	end
	local hideWithoutStandby = getPluginOption(self, 'hideWithoutStandby', false)
	if hideWithoutStandby and check ~= false then
		setLazyDatabaseValue(self, true, 'hidden')
	end
	if not hideWithoutStandby then
		if getPluginOption(self, 'tooltipType', "GameTooltip") == "Tablet-2.0" and not getPluginOption(self, 'cannotDetachTooltip', false) and self:IsFuBarTooltipDetached() and getLazyDatabaseValue(self, 'detachedTooltip', 'detached') then
			self:ReattachTooltip()
			setLazyDatabaseValue(self, true, 'detachedTooltip', 'detached')
		end
		if self.IsActive and self:IsActive() and self.ToggleActive and (not CheckFuBar() or not FuBar:IsChangingProfile()) then
			self:ToggleActive()
		end
	end
	if pluginToPanel[self] then
		pluginToPanel[self]:RemovePlugin(self)
	end
	pluginToFrame[self]:Hide()
	if pluginToMinimapFrame[self] then
		pluginToMinimapFrame[self]:Hide()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Sets the path to the icon for the plugin.
Arguments:
	string or nil - The path to the icon. If nil, then no icon.
Example:
	self:SetFuBarIcon("Interface\\AddOns\\MyAddon\\otherIcon")
-----------------------------------------------------------------------------]]
function FuBarPlugin:SetFuBarIcon(path)
	if not path then
		return
	end
	if not pluginToFrame[self] or not pluginToFrame[self].icon then
		return
	end
	if path:match([[^Interface\Icons\]]) then
		pluginToFrame[self].icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	else
		pluginToFrame[self].icon:SetTexCoord(0, 1, 0, 1)
	end
	pluginToFrame[self].icon:SetTexture(path)
	if pluginToMinimapFrame[self] and pluginToMinimapFrame[self].icon then
		if path:match([[^Interface\Icons\]]) then
			pluginToMinimapFrame[self].icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
		else
			pluginToMinimapFrame[self].icon:SetTexCoord(0, 1, 0, 1)
		end
		pluginToMinimapFrame[self].icon:SetTexture(path)
	end
end

--[[---------------------------------------------------------------------------
Returns:
	string or nil - The path to the icon for the plugin. If nil, then no icon.
Example:
	local path = self:GetFuBarIcon()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetFuBarIcon()
	if getPluginOption(self, 'iconPath', false) then
		return pluginToFrame[self] and pluginToFrame[self].icon and pluginToFrame[self].icon:GetTexture()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Checks the current width of the icon and text, then updates frame to expand/shrink to it if necessary.
Arguments:
	[optional] boolean - if true, Shrink/expand no matter what, otherwise if the width is less than 8 pixels smaller, don't shrink.
Example:
	self:CheckWidth(true)
-----------------------------------------------------------------------------]]
function FuBarPlugin:CheckWidth(force)
	local frame = pluginToFrame[self]
	if not frame then
		return
	end
	local icon = frame.icon
	local text = frame.text
	if (not icon or not icon:IsShown()) and (not text or not text:IsShown()) then
		return
	end

	local db = getLazyDatabaseValue(self)

	if (db and not self:IsFuBarIconShown()) or not getPluginOption(self, 'iconPath', false) then
		icon:SetWidth(epsilon)
	end
	local width
	if not getPluginOption(self, 'hasNoText', false) then
		text:SetHeight(0)
		text:SetWidth(500)
		width = text:GetStringWidth() + 1
		text:SetWidth(width)
		text:SetHeight(text:GetHeight())
	end
	local panel = pluginToPanel[self]
	if getPluginOption(self, 'hasNoText', false) or not text:IsShown() then
		frame:SetWidth(icon:GetWidth())
		if panel and panel:GetPluginSide(self) == "CENTER" then
			panel:UpdateCenteredPosition()
		end
	elseif force or not frame.textWidth or frame.textWidth < width or frame.textWidth - 8 > width then
		frame.textWidth = width
		text:SetWidth(width)
		if icon and icon:IsShown() then
			frame:SetWidth(width + icon:GetWidth())
		else
			frame:SetWidth(width)
		end
		if panel and panel:GetPluginSide(self) == "CENTER" then
			panel:UpdateCenteredPosition()
		end
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Sets the text of the plugin. Should only be called from within :OnFuBarUpdateText()
Arguments:
	string - text to set the plugin to. If not given, set to title.
Example:
	myAddon.OnFuBarUpdateText = function(self)
		self:SetFuBarText("Hello")
	fend
-----------------------------------------------------------------------------]]
function FuBarPlugin:SetFuBarText(text)
	local frame = pluginToFrame[self]
	if not frame or not frame.text then
		return
	end
	if text == "" then
		if getPluginOption(self, 'iconPath', false) then
			self:ShowFuBarIcon()
		else
			text = self:GetTitle()
		end
	end
	if not self:IsFuBarTextColored() then
		text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	end
	frame.text:SetText(text)
	self:CheckWidth()
end

--[[---------------------------------------------------------------------------
Returns:
	string - The current text of the plugin.
Example:
	local text = self:GetFuBarText()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetFuBarText()
	local frame = pluginToFrame[self]
	if not frame or not frame.text then
		error(("%s: Cannot get text without a text frame."):format(self:GetTitle()), 2)
	end
	if not getPluginOption(self, 'hasNoText', false) then
		return frame.text:GetText() or ""
	end
end

--[[---------------------------------------------------------------------------
Returns:
	boolean - whether the icon for the plugin is showing.
Example:
	local isIconShowing = self:IsFuBarIconShown()
-----------------------------------------------------------------------------]]
function FuBarPlugin:IsFuBarIconShown()
	if not getPluginOption(self, 'iconPath', false) then
		return false
	elseif getPluginOption(self, 'hasNoText', false) then
		return true
	end
	return not not getLazyDatabaseValueDefault(self, true, 'showIcon')
end

--[[---------------------------------------------------------------------------
Notes:
	Toggles whether the icon for the plugin is showing.
Example:
	self:ToggleFuBarIconShown()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ToggleFuBarIconShown()
	local frame = pluginToFrame[self]
	local icon = frame and frame.icon
	local text = frame and frame.text
	if not icon then
		error(("%s: Cannot toggle icon without an icon frame."):format(self:GetTitle()), 2)
	elseif not text then
		error(("%s: Cannot toggle icon without a text frame."):format(self:GetTitle()), 2)
	elseif not getPluginOption(self, 'iconPath', false) then
		error(("%s: Cannot show icon unless 'iconPath' is set."):format(self:GetTitle()), 2)
	elseif getPluginOption(self, 'hasNoText', false) then
		error(("%s: Cannot show icon if 'hasNoText' is set."):format(self:GetTitle()), 2)
	elseif not getLazyDatabaseValue(self) then
		error(("%s: Cannot hide icon if self.db is not available."):format(self:GetTitle()), 2)
	end
	local value = not self:IsFuBarIconShown()
	setLazyDatabaseValue(self, value, 'showIcon')
	if value then
		if not self:IsFuBarTextShown() and text:IsShown() and text:GetText() == self:GetTitle() then
			text:Hide()
			text:SetText("")
		end
		icon:Show()
		icon:SetWidth(pluginToFrame[self].icon:GetHeight())
		self:UpdateFuBarText()
	else
		if not text:IsShown() or not text:GetText() or text:GetText() == "" then
			text:Show()
			text:SetText(self:GetTitle())
		end
		icon:Hide()
		icon:SetWidth(epsilon)
	end
	self:CheckWidth(true)
	return value
end

--[[---------------------------------------------------------------------------
Notes:
	Shows the icon of the plugin if hidden.
Example:
	self:ShowFuBarIcon()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ShowFuBarIcon()
	if not self:IsFuBarIconShown() then
		self:ToggleFuBarIconShown()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Hides the icon of the plugin if shown.
Example:
	self:HideFuBarIcon()
-----------------------------------------------------------------------------]]
function FuBarPlugin:HideFuBarIcon()
	if self:IsFuBarIconShown() then
		self:ToggleFuBarIconShown()
	end
end

--[[---------------------------------------------------------------------------
Returns:
	boolean - whether the text for the plugin is showing.
Example:
	local isTextShowing = self:IsFuBarTextShown()
-----------------------------------------------------------------------------]]
function FuBarPlugin:IsFuBarTextShown()
	if getPluginOption(self, 'hasNoText', false) then
		return false
	elseif not getPluginOption(self, 'iconPath', false) then
		return true
	end
	return not not getLazyDatabaseValueDefault(self, true, 'showText')
end

--[[---------------------------------------------------------------------------
Notes:
	Toggles whether the text for the plugin is showing.
Example:
	self:ToggleFuBarTextShown()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ToggleFuBarTextShown()
	local frame = pluginToFrame[self]
	local icon = frame and frame.icon
	local text = frame and frame.text
	if not icon then
		error(("%s: Cannot toggle text without an icon frame."):format(self:GetTitle()), 2)
	elseif not text then
		error(("%s: Cannot toggle text without a text frame."):format(self:GetTitle()), 2)
	elseif getPluginOption(self, 'cannotHideText', false) then
		error(("%s: Cannot toggle text if 'cannotHideText' is set."):format(self:GetTitle()), 2)
	elseif not getPluginOption(self, 'iconPath', false) then
		error(("%s: Cannot toggle text unless 'iconPath' is set."):format(self:GetTitle()), 2)
	elseif getPluginOption(self, 'hasNoText', false) then
		error(("%s: Cannot toggle text if 'hasNoText' is set."):format(self:GetTitle()), 2)
	elseif not getLazyDatabaseValue(self) then
		error(("%s: Cannot toggle text if self.db is not available."):format(self:GetTitle()), 2)
	end
	local value = not self:IsFuBarTextShown()
	setLazyDatabaseValue(self, value, 'showText')
	if value then
		text:Show()
		self:UpdateFuBarText()
	else
		text:SetText("")
		text:SetWidth(epsilon)
		text:Hide()
		self:ShowFuBarIcon()
	end
	self:CheckWidth(true)
	return value
end

--[[---------------------------------------------------------------------------
Notes:
	Shows the text of the plugin if hidden.
Example:
	self:ShowFuBarText()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ShowFuBarText()
	if not self:IsFuBarTextShown() then
		self:ToggleFuBarTextShown()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Hides the text of the plugin if shown.
Example:
	self:HideFuBarText()
-----------------------------------------------------------------------------]]
function FuBarPlugin:HideFuBarText()
	if self:IsFuBarTextShown() then
		self:ToggleFuBarTextShown()
	end
end

--[[---------------------------------------------------------------------------
Returns:
	string - default position of the plugin.
Notes:
	This is here for FuBar core to communicate properly.
Example:
	local pos = self:GetDefaultPosition()
-----------------------------------------------------------------------------]]
function FuBarPlugin:GetDefaultPosition()
	return getPluginOption(self, 'defaultPosition', "LEFT")
end

--[[---------------------------------------------------------------------------
Returns:
	boolean - Whether the tooltip is detached.
Example:
	local detached = self:IsFuBarTooltipDetached()
-----------------------------------------------------------------------------]]
function FuBarPlugin:IsFuBarTooltipDetached()
	local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
	if tooltipType ~= "Tablet-2.0" then
		return
	end

	RegisterTablet20(self)
	return not Tablet20:IsAttached(pluginToFrame[self])
end

--[[---------------------------------------------------------------------------
Notes:
	Toggles whether the tooltip is detached.
Example:
	self:ToggleFuBarTooltipDetached()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ToggleFuBarTooltipDetached()
	local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
	if tooltipType ~= "Tablet-2.0" then
		return
	end

	RegisterTablet20(self)
	if Tablet20:IsAttached(pluginToFrame[self]) then
		Tablet20:Detach(pluginToFrame[self])
	else
		Tablet20:Attach(pluginToFrame[self])
	end
end

--[[---------------------------------------------------------------------------
Notes:
	* Detaches the tooltip from the plugin.
	* This does nothing if already detached.
Example:
	self:DetachFuBarTooltip()
-----------------------------------------------------------------------------]]
function FuBarPlugin:DetachFuBarTooltip()
	if not self:IsFuBarTooltipDetached() then
		self:ToggleFuBarTooltipDetached()
	end
end

--[[---------------------------------------------------------------------------
Notes:
	Reattaches the tooltip to the plugin.
	This does nothing if already attached.
Example:
	self:ReattachFuBarTooltip()
-----------------------------------------------------------------------------]]
function FuBarPlugin:ReattachFuBarTooltip()
	if self:IsFuBarTooltipDetached() then
		self:ToggleFuBarTooltipDetached()
	end
end

local function IsCorrectPanel(panel)
	if type(panel) ~= "table" then
		return false
	elseif type(panel.AddPlugin) ~= "function" then
		return false
	elseif type(panel.RemovePlugin) ~= "function" then
		return false
	elseif type(panel.GetNumPlugins) ~= "function" then
		return false
	elseif type(panel:GetNumPlugins()) ~= "number" then
		return false
	elseif type(panel.GetPlugin) ~= "function" then
		return false
	elseif type(panel.HasPlugin) ~= "function" then
		return false
	elseif type(panel.GetPluginSide) ~= "function" then
		return false
	end
	return true
end

-- #NODOC
-- this is used internally by FuBar
function FuBarPlugin:SetPanel(panel)
	pluginToPanel[self] = panel
end

-- #NODOC
-- this is used internally by FuBar
function FuBarPlugin:SetFontSize(size)
	if getPluginOption(self, 'userDefinedFrame', false) then
		error(("%sYou must provide a :SetFontSize(size) method if you have 'userDefinedFrame' set."):format(self.name and self.name .. ": " or ""), 2)
	end
	if getPluginOption(self, 'iconPath', false) then
		local frame = pluginToFrame[self]
		local icon = frame and frame.icon
		if not icon then
			error(("%sno icon frame found."):format(self.name and self.name .. ": " or ""), 2)
		end
		icon:SetWidth(size + 3)
		icon:SetHeight(size + 3)
	end
	if not getPluginOption(self, 'hasNoText', false) then
		local frame = pluginToFrame[self]
		local text = frame and frame.text
		if not text then
			error(("%sno text frame found."):format(self.name and self.name .. ": " or ""), 2)
		end
		local font, _, flags = text:GetFont()
		text:SetFont(font, size, flags)
	end
	self:CheckWidth()
end

local function IsLoadOnDemand(plugin)
	return IsAddOnLoadOnDemand(folderNames[plugin] or "")
end

-- #NODOC
-- this is used internally by FuBar.
function FuBarPlugin:IsDisabled()
	return type(self.IsActive) == "function" and not self:IsActive() or false
end

function FuBarPlugin:Embed(target)
	local stack = debugstack(5, 1, 0)
	local folder = stack:match("[Oo%.][Nn%.][Ss%.]\\([^\\]+)\\")
	if not folder then
		local partFolder = stack:match("...([^\\]+)\\")
		if partFolder then
			local partFolder_len = #partFolder
			for i = 1, GetNumAddOns() do
				local name = GetAddOnInfo(i)
				if #name >= partFolder_len then
					local partName = name:sub(-partFolder_len)
					if partName == partFolder then
						folder = name
					end
				end
			end
		end
		if not folder then
			for i = 6, 3, -1 do
				folder = debugstack(i, 1, 0):match([[\AddOns\(.*)\]])
				if folder then
					break
				end
			end
		end
	end
	folderNames[target] = folder
	
	for _,name in pairs(mixins) do
		target[name] = FuBarPlugin[name]
	end
	FuBarPlugin.mixinTargets[target] = true
end

local frame_OnClick, frame_OnDoubleClick, frame_OnMouseDown, frame_OnMouseUp, frame_OnReceiveDrag, frame_OnEnter, frame_OnLeave
--[[---------------------------------------------------------------------------
Arguments:
	[optional] string - name of the frame
Returns:
	frame - a frame with the basic scripts to be considered a plugin frame.
Example:
	MyPlugin.frame = MyPlugin:CreateBasicPluginFrame("FuBar_MyPluginFrame")
-----------------------------------------------------------------------------]]
function FuBarPlugin:CreateBasicPluginFrame(name)
	local frame = CreateFrame("Button", name, UIParent)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(7)
	frame:EnableMouse(true)
	frame:EnableMouseWheel(true)
	frame:SetMovable(true)
	frame:SetWidth(150)
	frame:SetHeight(24)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame.self = self
	if not frame_OnEnter then
		function frame_OnEnter(this)
			local self = this.self
			local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
			if tooltipType == "GameTooltip" then
				GameTooltip:SetOwner(self:IsFuBarMinimapAttached() and pluginToMinimapFrame[self] or pluginToFrame[self], "ANCHOR_CURSOR")
				self:UpdateFuBarTooltip()
			end
			if type(self.OnFuBarEnter) == "function" then
				self:OnFuBarEnter()
			end
		end
	end
	frame:SetScript("OnEnter", frame_OnEnter)
	if not frame_OnLeave then
		function frame_OnLeave(this)
			local self = this.self
			if type(self.OnFuBarLeave) == "function" then
				self:OnFuBarLeave()
			end
			local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
			if tooltipType == "GameTooltip" and GameTooltip:IsOwned(self:IsFuBarMinimapAttached() and pluginToMinimapFrame[self] or pluginToFrame[self]) then
				GameTooltip:Hide()
			end
		end
	end
	frame:SetScript("OnLeave", frame_OnLeave)
	if not frame_OnClick then
		function frame_OnClick(this, button)
			local self = this.self
			if self:IsFuBarMinimapAttached() and this.dragged then return end
			if type(self.OnFuBarClick) == "function" then
				self:OnFuBarClick(button)
			end
		end
	end
	frame:SetScript("OnClick", frame_OnClick)
	if not frame_OnDoubleClick then
		function frame_OnDoubleClick(this, button)
			local self = this.self
			if type(self.OnFuBarDoubleClick) == "function" then
				self:OnFuBarDoubleClick(button)
			end
		end
	end
	frame:SetScript("OnDoubleClick", frame_OnDoubleClick)
	if not frame_OnMouseDown then
		function frame_OnMouseDown(this, button)
			local self = this.self
			if button == "RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
				self:OpenMenu()
				return
			else
				if type(self.OnFuBarMouseDown) == "function" then
					self:OnFuBarMouseDown(button)
				end
			end
		end
	end
	frame:SetScript("OnMouseDown", frame_OnMouseDown)
	if not frame_OnMouseUp then
		function frame_OnMouseUp(this, button)
			local self = this.self
			if type(self.OnFuBarMouseUp) == "function" then
				self:OnFuBarMouseUp(button)
			end
		end
	end
	frame:SetScript("OnMouseUp", frame_OnMouseUp)
	if not frame_OnReceiveDrag then
		function frame_OnReceiveDrag(this)
			local self = this.self
			if (self:IsFuBarMinimapAttached() and not this.dragged) and type(self.OnReceiveDrag) == "function" then
				self:OnFuBarReceiveDrag()
			end
		end
	end
	frame:SetScript("OnReceiveDrag", frame_OnReceiveDrag)
	return frame
end

local child_OnEnter, child_OnLeave, child_OnClick, child_OnDoubleClick, child_OnMouseDown, child_OnMouseUp, child_OnReceiveDrag
--[[---------------------------------------------------------------------------
Arguments:
	string - type of the frame, e.g. "Frame", "Button", etc.
	[optional] string - name of the frame
	[optional] frame - parent frame
Returns:
	frame - a child frame that can be manipulated and used
Example:
	local child = self:CreatePluginChildFrame("Frame", nil, self.frame)
-----------------------------------------------------------------------------]]
function FuBarPlugin:CreatePluginChildFrame(frameType, name, parent)
	local child = CreateFrame(frameType, name, parent)
	if parent then
		child:SetFrameLevel(parent:GetFrameLevel() + 2)
	end
	child.self = self
	if not child_OnEnter then
		function child_OnEnter(this, ...)
			local self = this.self
			local frame = pluginToFrame[self]
			if frame:GetScript("OnEnter") then
				frame:GetScript("OnEnter")(frame, ...)
			end
		end
	end
	child:SetScript("OnEnter", child_OnEnter)
	if not child_OnLeave then
		function child_OnLeave(this, ...)
			local self = this.self
			local frame = pluginToFrame[self]
			if frame:GetScript("OnLeave") then
				frame:GetScript("OnLeave")(frame, ...)
			end
		end
	end
	child:SetScript("OnLeave", child_OnLeave)
	if child:HasScript("OnClick") then
		if not child_OnClick then
			function child_OnClick(this, ...)
				local self = this.self
				local frame = pluginToFrame[self]
				if frame:HasScript("OnClick") and frame:GetScript("OnClick") then
					frame:GetScript("OnClick")(frame, ...)
				end
			end
		end
		child:SetScript("OnClick", child_OnClick)
	end
	if child:HasScript("OnDoubleClick") then
		if not child_OnDoubleClick then
			function child_OnDoubleClick(this, ...)
				local self = this.self
				local frame = pluginToFrame[self]
				if frame:HasScript("OnDoubleClick") and frame:GetScript("OnDoubleClick") then
					frame:GetScript("OnDoubleClick")(frame, ...)
				end
			end
		end
		child:SetScript("OnDoubleClick", child_OnDoubleClick)
	end
	if not child_OnMouseDown then
		function child_OnMouseDown(this, ...)
			local self = this.self
			local frame = pluginToFrame[self]
			if frame:HasScript("OnMouseDown") and frame:GetScript("OnMouseDown") then
				frame:GetScript("OnMouseDown")(frame, ...)
			end
		end
	end
	child:SetScript("OnMouseDown", child_OnMouseDown)
	if not child_OnMouseUp then
		function child_OnMouseUp(this, ...)
			local self = this.self
			local frame = pluginToFrame[self]
			if frame:HasScript("OnMouseUp") and frame:GetScript("OnMouseUp") then
				frame:GetScript("OnMouseUp")(frame, ...)
			end
		end
	end
	child:SetScript("OnMouseUp", child_OnMouseUp)
	if not child_OnReceiveDrag then
		function child_OnReceiveDrag(this, ...)
			local self = this.self
			local frame = pluginToFrame[self]
			if frame:HasScript("OnReceiveDrag") and frame:GetScript("OnReceiveDrag") then
				frame:GetScript("OnReceiveDrag")(frame, ...)
			end
		end
	end
	child:SetScript("OnReceiveDrag", child_OnReceiveDrag)
	return child
end

--[[---------------------------------------------------------------------------
Notes:
	Opens the configuration menu associated with this plugin.
Example:
	self:OpenMenu()
-----------------------------------------------------------------------------]]
function FuBarPlugin:OpenMenu(frame)
	if not frame then
		frame = self:IsFuBarMinimapAttached() and pluginToMinimapFrame[self] or pluginToFrame[self]
	end
	if not frame:IsVisible() then
		frame = UIParent
	end
	local configType = getPluginOption(self, 'configType', "LibRockConfig-1.0")
	if configType == "Dewdrop-2.0" then
		if not frame or not self:GetFrame() or Dewdrop20:IsOpen(frame) then
			Dewdrop20:Close()
			return
		end
		local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
		if tooltipType == "GameTooltip" then
			if GameTooltip:IsOwned(frame) then
				GameTooltip:Hide()
			end
		elseif tooltipType == "Custom" and type(self.CloseTooltip) == "function" then
			self:CloseTooltip()
		elseif tooltipType == "Tablet-2.0" and Tablet20 then
			Tablet20:Close()
		end

		if not Dewdrop20:IsRegistered(self:GetFrame()) then
			if type(self.OnMenuRequest) == "table" and (not self.OnMenuRequest.handler or self.OnMenuRequest.handler == self) and self.OnMenuRequest.type == "group" then
				Dewdrop20:InjectAceOptionsTable(self, self.OnMenuRequest)
				if self.OnMenuRequest.args and CheckFuBar() and not getPluginOption(self, 'independentProfile', false) then
					self.OnMenuRequest.args.profile = nil
					if self.OnMenuRequest.extraArgs then
						self.OnMenuRequest.extraArgs.profile = nil
					end
				end
			end
			Dewdrop20:Register(self:GetFrame(),
				'children', type(self.OnMenuRequest) == "table" and self.OnMenuRequest or function(level, value, valueN_1, valueN_2, valueN_3, valueN_4)
					if level == 1 then
						if not getPluginOption(self, 'hideMenuTitle', false) then
							Dewdrop20:AddLine(
								'text', self:GetTitle(),
								'isTitle', true
							)
						end

						if self.OnMenuRequest then
							self:OnMenuRequest(level, value, false, valueN_1, valueN_2, valueN_3, valueN_4)
						end

						if not getPluginOption(self, 'overrideMenu', false) then
							if self.MenuSettings and not getPluginOption(self, 'hideMenuTitle', false) then
								Dewdrop20:AddLine()
							end
							self:AddImpliedMenuOptions()
						end
					else
						if not getPluginOption(self, 'overrideMenu', false) and self:AddImpliedMenuOptions() then
						else
							if self.OnMenuRequest then
								self:OnMenuRequest(level, value, false, valueN_1, valueN_2, valueN_3, valueN_4)
							end
						end
					end
					if level == 1 then
						Dewdrop20:AddLine(
							'text', CLOSE,
							'tooltipTitle', CLOSE,
							'tooltipText', CLOSE_DESC,
							'func', Dewdrop.Close,
							'arg1', Dewdrop
						)
					end
				end,
				'point', function(frame)
					local x, y = frame:GetCenter()
					local leftRight
					if x < GetScreenWidth() / 2 then
						leftRight = "LEFT"
					else
						leftRight = "RIGHT"
					end
					if y < GetScreenHeight() / 2 then
						return "BOTTOM" .. leftRight, "TOP" .. leftRight
					else
						return "TOP" .. leftRight, "BOTTOM" .. leftRight
					end
				end,
				'dontHook', true
			)
		end
		if frame == self:GetFrame() then
			Dewdrop20:Open(self:GetFrame())
		elseif frame ~= UIParent then
			Dewdrop20:Open(frame, self:GetFrame())
		else
			Dewdrop20:Open(frame, self:GetFrame(), 'cursorX', true, 'cursorY', true)
		end
	elseif configType == "LibRockConfig-1.0" then
		if not RockConfig then
			RockConfig = Rock and Rock("LibRockConfig-1.0", false, true)
		end
		if RockConfig then
			RockConfig.OpenConfigMenu(self)
		end
	elseif configType == "AceConfigDialog-3.0" then
		if not AceConfigDialog30 then
			AceConfigDialog30 = LibStub("AceConfigDialog-3.0", true)
		end
		if AceConfigDialog30 then
			AceConfigDialog30:Open(getPluginOption(self, 'aceConfig30', self.name))
		end
	elseif configType == "AceConfigDropdown-3.0" then
		if not AceConfigDropdown30 then
			AceConfigDropdown30 = LibStub("AceConfigDropdown-3.0", true)
		end
		if AceConfigDropdown30 then
			-- TODO: finalize this once AceConfigDropdown-3.0 exists
		end
	else
		-- TODO: add more possibilities
	end
end

function FuBarPlugin.OnEmbedInitialize(FuBarPlugin, self)
	if not self.frame then
		local name = MAJOR_VERSION .. "_" .. self:GetTitle() .. "_" .. "Frame"
		local frame = _G[name]
		if not frame or not _G[name .. "Text"] or not _G[name .. "Icon"] then
			frame = FuBarPlugin.CreateBasicPluginFrame(self, name)

			local icon = frame:CreateTexture(name .. "Icon", "ARTWORK")
			frame.icon = icon
			icon:SetWidth(16)
			icon:SetHeight(16)
			icon:SetPoint("LEFT", frame, "LEFT")

			local text = frame:CreateFontString(name .. "Text", "ARTWORK")
			frame.text = text
			text:SetWidth(134)
			text:SetHeight(24)
			text:SetPoint("LEFT", icon, "RIGHT", 0, 1)
			text:SetFontObject(GameFontNormal)
		end
		pluginToFrame[self] = frame
	else
		pluginToFrame[self] = self.frame
		if not pluginToOptions[self] then
			pluginToOptions[self] = {}
		end
		pluginToOptions[self].userDefinedFrame = true
	end

	local frame = pluginToFrame[self]
	frame.plugin = self
	frame:SetParent(UIParent)
	frame:SetPoint("RIGHT", UIParent, "LEFT", -5, 0)
	frame:Hide()

	local iconPath = getPluginOption(self, 'iconPath', false)
	if iconPath then
		self:SetFuBarIcon(iconPath)
	end

	local registerCallback = rawget(self, "db") and rawget(rawget(self, "db"), "callbacks") and rawget(rawget(self, "db"), "RegisterCallback") or nil
	if type(registerCallback) == "function" then
		registerCallback(FuBarPlugin, "OnProfileChanged", "OnEmbedProfileEnable", self)
		registerCallback(FuBarPlugin, "OnProfileCopied", "OnEmbedProfileEnable", self)
		registerCallback(FuBarPlugin, "OnProfileReset", "OnEmbedProfileEnable", self)
	end
	if CheckFuBar() then
		FuBar:RegisterPlugin(self)
	end
end

local CheckShow = function(self, panelId)
	if not pluginToFrame[self]:IsShown() and (not pluginToMinimapFrame[self] or not pluginToMinimapFrame[self]:IsShown()) then
		self:Show(panelId)
	end
end

local schedules = {}
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(this)
	for i,v in ipairs(schedules) do
		local success, ret = pcall(unpack(v))
		if not success then
			geterrorhandler()(ret)
		end
		schedules[i] = del(v)
	end
	f:Hide()
end)

--local recheckPlugins
--local AceConsole
local notFirst = {}
function FuBarPlugin.OnEmbedEnable(FuBarPlugin, self)
	if not getPluginOption(self, 'userDefinedFrame', false) then
		local icon = pluginToFrame[self].icon
		if self:IsFuBarIconShown() then
			icon:Show()
		else
			icon:Hide()
		end
	end
	self:CheckWidth(true)

	if not getPluginOption(self, 'hideWithoutStandby', false) or (getLazyDatabaseValue(self) and not getLazyDatabaseValue(self, 'hidden')) then
		if notFirst[self] then
			CheckShow(self, self.panelIdTmp)
		else
			notFirst[self] = true
			schedules[#schedules+1] = newList(CheckShow, self, self.panelIdTmp)
			f:Show()
		end
	end

	local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
	if tooltipType == "Tablet-2.0" and not getPluginOption(self, 'cannotDetachTooltip', false) and getLazyDatabaseValue(self, 'detachedTooltip', 'detached') then
		schedules[#schedules+1] = newList(self.DetachFuBarTooltip, self)
		f:Show()
	end

	if IsLoadOnDemand(self) and CheckFuBar() then
		if not FuBar.db.profile.loadOnDemand then
			FuBar.db.profile.loadOnDemand = {}
		end
		if not FuBar.db.profile.loadOnDemand[folderNames[self]] then
			FuBar.db.profile.loadOnDemand[folderNames[self]] = {}
		end
		FuBar.db.profile.loadOnDemand[folderNames[self]].disabled = nil
	end
	--[[
	if CheckFuBar() and AceLibrary:HasInstance("AceConsole-2.0") then
		if not recheckPlugins then
			if not AceConsole then
				AceConsole = AceLibrary("AceConsole-2.0")
			end
			recheckPlugins = function()
				for k,v in pairs(AceConsole.registry) do
					if type(v) == "table" and v.args and AceOO.inherits(v.handler, FuBarPlugin) and not v.handler.independentProfile then
						v.args.profile = nil
					end
				end
			end
		end
		FuBarPlugin:ScheduleEvent("FuBarPlugin-recheckPlugins", recheckPlugins, 0)
	end
	]]
end

function FuBarPlugin.OnEmbedDisable(FuBarPlugin, self)
	self:Hide(false)

	if IsLoadOnDemand(self) and CheckFuBar() then
		if not FuBar.db.profile.loadOnDemand then
			FuBar.db.profile.loadOnDemand = {}
		end
		if not FuBar.db.profile.loadOnDemand[folderNames[self]] then
			FuBar.db.profile.loadOnDemand[folderNames[self]] = {}
		end
		FuBar.db.profile.loadOnDemand[folderNames[self]].disabled = true
	end
end

function FuBarPlugin.OnEmbedProfileEnable(FuBarPlugin, self)
	self:UpdateFuBarPlugin()
	if getLazyDatabaseValue(self) then
		if not getLazyDatabaseValue(self, 'detachedTooltip') then
			setLazyDatabaseValue(self, {}, 'detachedTooltip')
		end
		local tooltipType = getPluginOption(self, 'tooltipType', "GameTooltip")
		if tooltipType == "Tablet-2.0" and Tablet20 then
			if Tablet20.registry[pluginToFrame[self]] then
				Tablet20:UpdateDetachedData(pluginToFrame[self], getLazyDatabaseValue(self, 'detachedTooltip'))
			else
				RegisterTablet20(self)
			end
		end
		if MinimapContainer:HasPlugin(self) then
			MinimapContainer:ReadjustLocation(self)
		end
	end
end

-- #NODOC
function FuBarPlugin.GetEmbedRockConfigOptions(FuBarPlugin, self)
	return 'icon', {
		type = 'boolean',
		name = SHOW_FUBAR_ICON,
		desc = SHOW_FUBAR_ICON_DESC,
		set = "ToggleFuBarIconShown",
		get = "IsFuBarIconShown",
		hidden = function()
			return not getPluginOption(self, 'iconPath', false) or getPluginOption(self, 'hasNoText', false) or self:IsDisabled() or self:IsFuBarMinimapAttached() or not getLazyDatabaseValue(self)
		end,
		order = -13.7,
		handler = self,
	}, 'text', {
		type = 'boolean',
		name = SHOW_FUBAR_TEXT,
		desc = SHOW_FUBAR_TEXT_DESC,
		set = "ToggleFuBarTextShown",
		get = "IsFuBarTextShown",
		hidden = function()
			return getPluginOption(self, 'cannotHideText', false) or not getPluginOption(self, 'iconPath', false) or getPluginOption(self, 'hasNoText') or self:IsDisabled() or self:IsFuBarMinimapAttached() or not getLazyDatabaseValue(self)
		end,
		order = -13.6,
		handler = self,
	}, 'colorText', {
		type = 'boolean',
		name = SHOW_COLORED_FUBAR_TEXT,
		desc = SHOW_COLORED_FUBAR_TEXT_DESC,
		set = "ToggleFuBarTextColored",
		get = "IsFuBarTextColored",
		hidden = function()
			return getPluginOption(self, 'userDefinedFrame', false) or getPluginOption(self, 'hasNoText', false) or getPluginOption(self, 'hasNoColor', false) or self:IsDisabled() or self:IsFuBarMinimapAttached() or not getLazyDatabaseValue(self)
		end,
		order = -13.5,
		handler = self,
	}, 'detachTooltip', {
		type = 'boolean',
		name = DETACH_FUBAR_TOOLTIP,
		desc = DETACH_FUBAR_TOOLTIP_DESC,
		get = "IsFuBarTooltipDetached",
		set = "ToggleFuBarTooltipDetached",
		hidden = function()
			return not Tablet20 or getPluginOption(self, 'tooltipType', "GameTooltip") ~= "Tablet-2.0" or self:IsDisabled()
		end,
		order = -13.4,
		handler = self,
	}, 'lockTooltip', {
		type = 'boolean',
		name = LOCK_FUBAR_TOOLTIP,
		desc = LOCK_FUBAR_TOOLTIP_DESC,
		get = function()
			return Tablet20:IsLocked(pluginToFrame[self])
		end,
		set = function()
			return Tablet20:ToggleLocked(pluginToFrame[self])
		end,
		disabled = function()
			return not self:IsFuBarTooltipDetached()
		end,
		hidden = function()
			return not Tablet20 or getPluginOption(self, 'tooltipType', "GameTooltip") ~= "Tablet-2.0" or getPluginOption(self, 'cannotDetachTooltip', false) or self:IsDisabled()
		end,
		order = -13.3,
		handler = self,
	}, 'position', {
		type = 'choice',
		name = POSITION_ON_FUBAR,
		desc = POSITION_ON_FUBAR_DESC,
		choices = {
			LEFT = POSITION_LEFT,
			CENTER = POSITION_CENTER,
			RIGHT = POSITION_RIGHT
		},
		choiceSort = {
			"LEFT",
			"CENTER",
			"RIGHT",
		},
		get = function()
			return self:GetPanel() and self:GetPanel():GetPluginSide(self)
		end,
		set = function(value)
			if self:GetPanel() then
				self:GetPanel():SetPluginSide(self, value)
			end
		end,
		hidden = function()
			return self:IsFuBarMinimapAttached() or self:IsDisabled() or not pluginToPanel[self]
		end,
		order = -13.2,
		handler = self,
	}, 'minimapAttach', {
		type = 'boolean',
		name = ATTACH_PLUGIN_TO_MINIMAP,
		desc = ATTACH_PLUGIN_TO_MINIMAP_DESC,
		get = "IsFuBarMinimapAttached",
		set = "ToggleFuBarMinimapAttached",
		hidden = function()
			return (getPluginOption(self, 'cannotAttachToMinimap', false) and not self:IsFuBarMinimapAttached()) or not CheckFuBar() or self:IsDisabled()
		end,
		order = -13.1,
		handler = self,
	}, 'hide', {
		type = 'boolean',
		name = function()
			if self:IsFuBarMinimapAttached() then
				return HIDE_MINIMAP_BUTTON
			else
				return HIDE_FUBAR_PLUGIN
			end
		end,
		desc = HIDE_FUBAR_PLUGIN_DESC,
		get = function()
			return not pluginToFrame[self]:IsShown() and (not pluginToMinimapFrame[self] or not pluginToMinimapFrame[self]:IsShown())
		end,
		set = function(value)
			if not value then
				self:Show()
			else
				self:Hide()
			end
		end,
		hidden = function()
			return not getPluginOption(self, 'hideWithoutStandby', false) or self:IsDisabled()
		end,
		order = -13,
		handler = self,
	}
end

local plugins = MinimapContainer.plugins or {}
for k in pairs(MinimapContainer) do
	MinimapContainer[k] = nil
end
MinimapContainer.plugins = plugins

local minimap_OnMouseDown, minimap_OnMouseUp
function MinimapContainer:AddPlugin(plugin)
	if CheckFuBar() and FuBar:IsChangingProfile() then
		return
	end
	if pluginToPanel[plugin] then
		pluginToPanel[plugin]:RemovePlugin(plugin)
	end
	pluginToPanel[plugin] = self
	if not pluginToMinimapFrame[plugin] then
		local frame = CreateFrame("Button", pluginToFrame[plugin]:GetName() .. "MinimapButton", Minimap)
		pluginToMinimapFrame[plugin] = frame
		plugin.minimapFrame = frame
		frame.plugin = plugin
		frame:SetWidth(31)
		frame:SetHeight(31)
		frame:SetFrameStrata("BACKGROUND")
		frame:SetFrameLevel(4)
		frame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
		local icon = frame:CreateTexture(frame:GetName() .. "Icon", "BACKGROUND")
		plugin.minimapIcon = icon
		local path = plugin:GetFuBarIcon() or (pluginToFrame[plugin].icon and pluginToFrame[plugin].icon:GetTexture()) or "Interface\\Icons\\INV_Misc_QuestionMark"
		icon:SetTexture(path)
		if path:sub(1, 16) == "Interface\\Icons\\" then
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		else
			icon:SetTexCoord(0, 1, 0, 1)
		end
		icon:SetWidth(20)
		icon:SetHeight(20)
		icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, -5)
		local overlay = frame:CreateTexture(frame:GetName() .. "Overlay","OVERLAY")
		overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
		overlay:SetWidth(53)
		overlay:SetHeight(53)
		overlay:SetPoint("TOPLEFT",frame,"TOPLEFT")
		frame:EnableMouse(true)
		frame:RegisterForClicks("LeftButtonUp")

		frame.self = plugin
		if not frame_OnEnter then
			function frame_OnEnter(this)
				if type(this.self.OnFuBarEnter) == "function" then
					this.self:OnFuBarEnter()
				end
			end
		end
		frame:SetScript("OnEnter", frame_OnEnter)
		if not frame_OnLeave then
			function frame_OnLeave(this)
				if type(this.self.OnFuBarLeave) == "function" then
					this.self:OnFuBarLeave()
				end
			end
		end
		frame:SetScript("OnLeave", frame_OnLeave)
		if not frame_OnClick then
			function frame_OnClick(this, arg1)
				if this.self:IsMinimapAttached() and this.dragged then return end
				if type(this.self.OnFuBarClick) == "function" then
					this.self:OnFuBarClick(arg1)
				end
			end
		end
		frame:SetScript("OnClick", frame_OnClick)
		if not frame_OnDoubleClick then
			function frame_OnDoubleClick(this, arg1)
				if type(this.self.OnFuBarDoubleClick) == "function" then
					this.self:OnFuBarDoubleClick(arg1)
				end
			end
		end
		frame:SetScript("OnDoubleClick", frame_OnDoubleClick)
		if not frame_OnReceiveDrag then
			function frame_OnReceiveDrag(this)
				if this.self:IsMinimapAttached() and this.dragged then return end
				if type(this.self.OnFuBarReceiveDrag) == "function" then
					this.self:OnFuBarReceiveDrag()
				end
			end
		end
		frame:SetScript("OnReceiveDrag", frame_OnReceiveDrag)
		if not minimap_OnMouseDown then
			function minimap_OnMouseDown(this, arg1)
				this.dragged = false
				if arg1 == "LeftButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
					HideDropDownMenu(1)
					if type(this.self.OnFuBarMouseDown) == "function" then
						this.self:OnFuBarMouseDown(arg1)
					end
				elseif arg1 == "RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
					this.self:OpenMenu(this)
				else
					HideDropDownMenu(1)
					if type(this.self.OnFuBarMouseDown) == "function" then
						this.self:OnFuBarMouseDown(arg1)
					end
				end
				if this.self.OnFuBarClick or this.self.OnFuBarMouseDown or this.self.OnFuBarMouseUp or this.self.OnFuBarDoubleClick then
					if this.self.minimapIcon:GetTexture():sub(1, 16) == "Interface\\Icons\\" then
						this.self.minimapIcon:SetTexCoord(0.14, 0.86, 0.14, 0.86)
					else
						this.self.minimapIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					end
				end
			end
		end
		frame:SetScript("OnMouseDown", minimap_OnMouseDown)
		if not minimap_OnMouseUp then
			function minimap_OnMouseUp(this, arg1)
				if not this.dragged and type(this.self.OnFuBarMouseUp) == "function" then
					this.self:OnFuBarMouseUp(arg1)
				end
				if this.self.minimapIcon:GetTexture():sub(1, 16) == "Interface\\Icons\\" then
					this.self.minimapIcon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
				else
					this.self.minimapIcon:SetTexCoord(0, 1, 0, 1)
				end
			end
		end
		frame:SetScript("OnMouseUp", minimap_OnMouseUp)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", self.OnDragStart)
		frame:SetScript("OnDragStop", self.OnDragStop)

		if getPluginOption(plugin, 'tooltipType', "GameTooltip") == "Tablet-2.0" then
			-- Note that we have to do this after :SetScript("OnEnter"), etc,
			-- so that Tablet-2.0 can override it properly.
			RegisterTablet20(plugin)
			Tablet20:Register(frame, pluginToFrame[plugin])
		end
	end
	pluginToFrame[plugin]:Hide()
	pluginToMinimapFrame[plugin]:Show()
	self:ReadjustLocation(plugin)
	table.insert(self.plugins, plugin)
	local exists = false
	return true
end

function MinimapContainer:RemovePlugin(index)
	if CheckFuBar() and FuBar:IsChangingProfile() then
		return
	end
	if type(index) == "table" then
		index = self:IndexOfPlugin(index)
		if not index then
			return
		end
	end
	local t = self.plugins
	local plugin = t[index]
	assert(pluginToPanel[plugin] == self, "Plugin has improper panel field")
	plugin:SetPanel(nil)
	table.remove(t, index)
	return true
end

function MinimapContainer:ReadjustLocation(plugin)
	local frame = pluginToMinimapFrame[plugin]
	if plugin.db and plugin.db.profile.minimapPositionWild then
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", plugin.db.profile.minimapPositionX, plugin.db.profile.minimapPositionY)
	elseif not plugin.db and plugin.minimapPositionWild then
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", plugin.minimapPositionX, plugin.minimapPositionY)
	else
		local position
		if plugin.db then
			position = plugin.db.profile.minimapPosition or getPluginOption(plugin, 'defaultMinimapPosition', nil) or math.random(1, 360)
		else
			position = plugin.minimapPosition or getPluginOption(plugin, 'defaultMinimapPosition', nil) or math.random(1, 360)
		end
		local angle = math.rad(position or 0)
		local x,y
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local cos = math.cos(angle)
		local sin = math.sin(angle)

		local round = true
		if minimapShape == "ROUND" then
			-- do nothing
		elseif minimapShape == "SQUARE" then
			round = false
		elseif minimapShape == "CORNER-TOPRIGHT" then
			if cos < 0 or sin < 0 then
				round = false
			end
		elseif minimapShape == "CORNER-TOPLEFT" then
			if cos > 0 or sin < 0 then
				round = false
			end
		elseif minimapShape == "CORNER-BOTTOMRIGHT" then
			if cos < 0 or sin > 0 then
				round = false
			end
		elseif minimapShape == "CORNER-BOTTOMLEFT" then
			if cos > 0 or sin > 0 then
				round = false
			end
		elseif minimapShape == "SIDE-LEFT" then
			if cos > 0 then
				round = false
			end
		elseif minimapShape == "SIDE-RIGHT" then
			if cos < 0 then
				round = false
			end
		elseif minimapShape == "SIDE-TOP" then
			if sin < 0 then
				round = false
			end
		elseif minimapShape == "SIDE-BOTTOM" then
			if sin > 0 then
				round = false
			end
		elseif minimapShape == "TRICORNER-TOPRIGHT" then
			if cos < 0 and sin < 0 then
				round = false
			end
		elseif minimapShape == "TRICORNER-TOPLEFT" then
			if cos > 0 and sin < 0 then
				round = false
			end
		elseif minimapShape == "TRICORNER-BOTTOMRIGHT" then
			if cos < 0 and sin > 0 then
				round = false
			end
		elseif minimapShape == "TRICORNER-BOTTOMLEFT" then
			if cos > 0 and sin > 0 then
				round = false
			end
		end

		if round then
			x = cos * 80
			y = sin * 80
		else
			x = 80 * 2^0.5 * cos
			y = 80 * 2^0.5 * sin
			if x < -80 then
				x = -80
			elseif x > 80 then
				x = 80
			end
			if y < -80 then
				y = -80
			elseif y > 80 then
				y = 80
			end
		end
		frame:SetPoint("CENTER", Minimap, "CENTER", x, y)
	end
end

function MinimapContainer:GetPlugin(index)
	return self.plugins[index]
end

function MinimapContainer:GetNumPlugins()
	return #self.plugins
end

function MinimapContainer:IndexOfPlugin(plugin)
	for i,p in ipairs(self.plugins) do
		if p == plugin then
			return i, "MINIMAP"
		end
	end
end

function MinimapContainer:HasPlugin(plugin)
	return self:IndexOfPlugin(plugin) ~= nil
end

function MinimapContainer:GetPluginSide(plugin)
	local index = self:IndexOfPlugin(plugin)
	assert(index, "Plugin not in panel")
	return "MINIMAP"
end

function MinimapContainer.OnDragStart(this)
	this.dragged = true
	this:LockHighlight()
	this:SetScript("OnUpdate", MinimapContainer.OnUpdate)
	if this.self.minimapIcon:GetTexture():sub(1, 16) == "Interface\\Icons\\" then
		this.self.minimapIcon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	else
		this.self.minimapIcon:SetTexCoord(0, 1, 0, 1)
	end
end

function MinimapContainer.OnDragStop(this)
	this:SetScript("OnUpdate", nil)
	this:UnlockHighlight()
end

function MinimapContainer.OnUpdate(this, elapsed)
	if not IsAltKeyDown() then
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		px, py = px / scale, py / scale
		local position = math.deg(math.atan2(py - my, px - mx))
		if position <= 0 then
			position = position + 360
		elseif position > 360 then
			position = position - 360
		end
		if this.self.db then
			this.self.db.profile.minimapPosition = position
			this.self.db.profile.minimapPositionX = nil
			this.self.db.profile.minimapPositionY = nil
			this.self.db.profile.minimapPositionWild = nil
		else
			this.self.minimapPosition = position
			this.self.minimapPositionX = nil
			this.self.minimapPositionY = nil
			this.self.minimapPositionWild = nil
		end
	else
		local px, py = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		px, py = px / scale, py / scale
		if this.self.db then
			this.self.db.profile.minimapPositionX = px
			this.self.db.profile.minimapPositionY = py
			this.self.db.profile.minimapPosition = nil
			this.self.db.profile.minimapPositionWild = true
		else
			this.self.minimapPositionX = px
			this.self.minimapPositionY = py
			this.self.minimapPosition = nil
			this.self.minimapPositionWild = true
		end
	end
	MinimapContainer:ReadjustLocation(this.self)
end

for target,_ in pairs(mixinTargets) do
	for _,name in pairs(mixins) do
		if not target[name] or target[name] == oldLib[name] then
			target[name] = FuBarPlugin[name]
		end
	end
end
