---- Help screen

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

HELPSCRN = {}

function HELPSCRN:Show()
	local margin = 15

	local dframe = vgui.Create("DFrame")
	local w, h = 630, 470
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:ShowCloseButton(false)
	dframe.Paint = function(self,w,h)
		draw.RoundedBox(6, 0, 0, w, h, Color(232, 232, 232, 255))
	end
	
	local infopanel = vgui.Create("DPanel",dframe)
	infopanel:SetSize(dframe:GetWide(),50)
	infopanel.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(135, 206, 235, 255))
		draw.SimpleText(GetTranslation("settings_title"),"LargeTitle",10,8, color_white)
	end
	
	local closeButton = vgui.Create('DButton', dframe)
	closeButton:SetFont('marlett')
	closeButton:SetText('r')
	closeButton.Paint = function() end
	closeButton:SetColor(Color(255, 255, 255))
	closeButton:SetSize(32, 32)
	closeButton:SetPos(dframe:GetWide() - 40, 8)
	closeButton.DoClick = function()
		dframe:Close()
	end

	local dtabs = vgui.Create("CustomSheet", dframe)
	dtabs:SetSize(w,h-50)
	dtabs:StretchToParent(0, 50, 0, 0)
	dtabs.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color (232, 232, 232, 255))
	end

	local padding = dtabs:GetPadding()

	padding = padding * 2

	local tutparent = vgui.Create("DPanel", dtabs)
	tutparent:SetPaintBackground(false)
	tutparent:StretchToParent(margin, 0, 0, 0)

	local dsettings = vgui.Create("DPanelList", dtabs)
	dsettings:StretchToParent(0,0,padding,0)
	dsettings:EnableVerticalScrollbar(true)
	dsettings:SetPadding(10)
	dsettings:SetSpacing(10)

	--- Interface area

	local dgui = vgui.Create("DForm", dsettings)
	dgui:SetName(GetTranslation("set_title_gui"))

	local cb = nil

	cb = dgui:NumSlider(GetTranslation("set_cross_opacity"), "dm_ironsights_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end
	cb:SetTooltip(GetTranslation("set_cross_opacity"))

	cb = dgui:NumSlider(GetTranslation("set_cross_brightness"), "dm_crosshair_brightness", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = dgui:NumSlider(GetTranslation("set_cross_size"), "dm_crosshair_size", 0.1, 3, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	dgui:CheckBox(GetTranslation("set_cross_disable"), "dm_disable_crosshair")

	cb = dgui:CheckBox(GetTranslation("set_lowsights"), "dm_ironsights_lowered")
	cb:SetTooltip(GetTranslation("set_lowsights_tip"))

	dsettings:AddItem(dgui)

	--- Gameplay area

	local dplay = vgui.Create("DForm", dsettings)
	dplay:SetName(GetTranslation("set_title_play"))

	cb = dplay:Help("Coming soon")

	dsettings:AddItem(dplay)

	--- Gameplay area

	local dmusic = vgui.Create("DForm", dsettings)
	dmusic:SetName(GetTranslation("set_music_lang"))

	cb = dmusic:CheckBox(GetTranslation("set_music_switch"), "dm_music_enable")
	cb:SetTooltip(GetTranslation("set_music_switch_tip"))

	cb = dmusic:NumSlider(GetTranslation("set_music_volume"), "dm_music_volume", 0, 100, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end
	cb:SetTooltip(GetTranslation("set_music_volume_tip"))

	dsettings:AddItem(dmusic)

	--- Language area
	local dlanguage = vgui.Create("DForm", dsettings)
	dlanguage:SetName(GetTranslation("set_title_lang"))

	local dlang = vgui.Create("DComboBox", dlanguage)
	dlang:SetConVar("dm_language")

	dlang:AddChoice("Server default", "auto")
	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end
	-- Why is DComboBox not updating the cvar by default?
	dlang.OnSelect = function(idx, val, data)
							  RunConsoleCommand("dm_language", data)
						  end
	dlang.Think = dlang.ConVarStringThink

	dlanguage:Help(GetTranslation("set_lang"))
	dlanguage:AddItem(dlang)

	dsettings:AddItem(dlanguage)

	dtabs:AddSheet(GetTranslation("settings_tip"), dsettings, "icon16/wrench.png", false, false, GetTranslation("help_settings_tip"))

	hook.Call("DMSettingsTabs", GAMEMODE, dtabs)

	dframe:MakePopup()
end


local function ShowDMHelp(ply, cmd, args)
	HELPSCRN:Show()
end
concommand.Add("dm_helpscreen", ShowDMHelp)
