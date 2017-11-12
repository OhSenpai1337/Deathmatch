scoreboard = scoreboard or {}

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

surface.CreateFont("cool_small", {font = "coolvetica",
                                  size = 20,
                                  weight = 400})
surface.CreateFont("cool_large", {font = "coolvetica",
                                  size = 24,
                                  weight = 400})
surface.CreateFont("treb_small", {font = "Trebuchet18",
                                  size = 14,
                                  weight = 700})

function scoreboard:show()
	local ply = LocalPlayer()
	local dframe = vgui.Create("DFrame")

	local w = math.max(ScrW() * 0.4, 640)
	local h = math.Clamp(ScrH()-150, 110, ScrH() * 0.95)

	dframe:SetSize(w, h)
	dframe:SetPos( (ScrW() - w) / 2, math.min(72, (ScrH() - h) / 4))
	dframe:Center()
	dframe:ShowCloseButton(false)
	dframe.Paint = function(self,w,h)
		draw.RoundedBox(6, 0, 0, w, h, Color(232, 232, 232, 255))
	end
	
	local infopanel = vgui.Create("DPanel",dframe)
	infopanel:SetSize(dframe:GetWide(),50)
	infopanel.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(135, 206, 235, 255))
		draw.SimpleText(GetHostName(),"LargeTitle",10,8, color_white)
	end
	
	local information = vgui.Create("DPanel",dframe)
	information:SetSize(dframe:GetWide(),16)
	information:SetPos(0,50)
	information.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 255))
		draw.SimpleText(GetTranslation("sb_nick"),"treb_small",36,1, color_black,TEXT_ALIGN_LEFT)
		draw.SimpleText(GetTranslation("sb_kills"),"treb_small",435,1, color_black,TEXT_ALIGN_CENTER)
		draw.SimpleText(GetTranslation("sb_deaths"),"treb_small",510,1, color_black,TEXT_ALIGN_CENTER)
		draw.SimpleText(GetTranslation("sb_ping"),"treb_small",w - 36,1, color_black,TEXT_ALIGN_RIGHT)
	end
	
	local dpanel = vgui.Create("DPanelList",dframe)
	dpanel:StretchToParent(0,66,0,0)
	dpanel:EnableVerticalScrollbar(true)
	dpanel.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color (232, 232, 232, 255))
	end
	
	for _, ply in pairs ( player.GetAll() ) do
		local ployer = vgui.Create("DPanel")
		ployer:SetSize(w,32)
		ployer.Paint = function(self,w,h)
			draw.RoundedBox(0, 0, 0, w, h, Color (210, 210, 210, 255))
			draw.SimpleText(ply:Name(),"cool_small",36,6,color_black,TEXT_ALIGN_LEFT)
			draw.SimpleText(ply:Frags(),"cool_small",435,6,color_black,TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:Deaths(),"cool_small",510,6,color_black,TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:Ping(),"cool_small",w-54,6,color_black,TEXT_ALIGN_CENTER)
		end
		
		local avatar = vgui.Create("AvatarImage",ployer)
		avatar:SetSize(32,32)
		avatar:SetPlayer(ply,32)
		
		local avabut = vgui.Create("DButton", ployer)
		avabut:SetSize(32,32)
		avabut:SetText("")
		avabut.Paint = function(self,w,h)
			draw.RoundedBox(0, 0, 0, w, h, Color (210, 210, 210, 0))
		end
		avabut.DoClick = function()
			ply:ShowProfile()
		end
		
		local mute = vgui.Create("DImageButton", ployer)
		mute:SetSize(16,16)
		mute:DockMargin(4, 4, 8, 4)
		mute:Dock(RIGHT)
		mute.DoClick = function()
			if IsValid(ply) and ply != LocalPlayer() then
				ply:SetMuted(not ply:IsMuted())
			end
		end
		mute.Think = function()
			if ply != LocalPlayer() then
				local muted = ply:IsMuted()
				mute:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")
			else
				mute:Hide()
			end
		end
		
		dpanel:AddItem(ployer)
	end
	dframe:MakePopup()
	function scoreboard:hide()
		dframe:Close()
	end
end

function GM:ScoreboardShow()
	scoreboard:show()
end

function GM:ScoreboardHide()
	scoreboard:hide()
end