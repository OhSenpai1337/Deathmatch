-- HUD HUD HUD

local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp

local gamestate_string = {
   [GAME_WAIT]   = "game_wait",
   [GAME_ACTIVE] = "game_active",
   [GAME_POST]   = "game_post",
   [GAME_OVERTIME]   = "game_overtime"
};

if SERVER then
	AddCSLuaFile()

	resource.AddFile("resource/fonts/molot.ttf")
	resource.AddFile("resource/fonts/shogunsclan.ttf")

	local meta = FindMetaTable("Player")

	function meta:AddKillstreak()
		self:SetNWInt("Killstreak", self:GetNWInt("Killstreak") + 1)
		timer.Remove("KillstreakTimer")
		timer.Create("KillstreakTimer", 6, 1, function()
			self:SetNWInt("Killstreak", 0)
		end)
	end


	hook.Add("PlayerDeath", "UpdatePTS", function(victim, inflictor, killer)
		    if victim:IsValid() and victim:IsPlayer() then
		    	if timer.Exists("KillstreakTimer") then
		    		timer.Stop("KillstreakTimer")
		    	end
			    victim:SetNWInt("Killstreak", 0)
		    if victim != killer and killer:IsValid() and victim:IsPlayer() then
		    	killer:AddKillstreak()
		    end
		end
	end)

	--debug
	hook.Add("OnNPCKilled", "UpdatePTSForNPC", function(npc, killer)
		if npc:IsValid() and npc:IsNPC() then
			if killer:IsValid() and killer:IsPlayer() then
				killer:AddKillstreak()
			end
		end
	end)
end

if CLIENT then

local restrictweapons = {"weapon_physgun",
"weapon_physcannon",
"weapon_bugbait",
"weapon_empty_hands",
"weapon_keypadchecker"}
surface.CreateFont("HotlineMiamiHUDFont1", {
	font = "Molot",
	size = ScrH() * 0.08,
	extended = true
})

surface.CreateFont("HotlineMiamiHUDFont2", {
	font = "Molot",
	size = ScrH() * 0.06,
	extended = true
})

surface.CreateFont("HotlineMiamiHUDFont3", {
	font = "Molot",
	size = ScrH() * 0.04,
	extended = true
})

surface.CreateFont("HotlineMiamiHUDFont4", {
	font = "Shoguns Clan",
	size = ScrW() * 0.09
})

surface.CreateFont("HotlineMiamiHUDFont5", {
	font = "Molot",
	size = 70,
	extended = true
})

surface.CreateFont("HotlineMiamiHUDFont6", {
	font = "Shoguns Clan",
	size = 80
})

surface.CreateFont("HotlineMiamiHUDFont7", {
	font = "Molot",
	size = ScrH() * 0.035,
	extended = true
})

surface.CreateFont("HotlineMiamiHUDFont8", {
	font = "Molot",
	size = ScrH() * 0.03,
	extended = true
})


local defaults = {
CHudBattery = true,
CHudHealth = true,
CHudAmmo = true,
CHudSecondaryAmmo = true
}

hook.Add("HUDShouldDraw", "DisableDefaults", function(name)
	if defaults[name] then
		return false
	end
end)

function DrawHotlineMiamiText(text, font, x, y, align)
    local sin = math.sin(CurTime() * 6)
    local cos = math.cos(CurTime() * 3)
    draw.SimpleText(text, font, 
		x + 6, y + 6, Color(180 - (60 * cos), 12, 60 - (60 * cos), 255), align)
    draw.SimpleText(text, font, x - (0.003 * sin), 
    y - (2 * sin), Color(50 - (60 * sin), 254 - (40 * sin), 254, 255), align)
end

function HotlineMiamiColor1()
    local sin = math.sin(CurTime() * 6)
	return Color(100 - (60 * sin), 254 - (40 * sin), 254, 255)
end

function HotlineMiamiColor2()
    local cos = math.cos(CurTime() * 3)
	return Color(180 - (60 * cos), 12, 60 - (60 * cos), 255)
end

function DrawHotlineMiamiKillstreak(text, font, x, y, align)
    local sin = math.sin(CurTime() * 6)
    local cos = math.cos(CurTime() * 3)
    draw.SimpleText(text, font, 
		x + 6, y + 6, Color(0, 0, 0, 255), align)
    draw.SimpleText(text, font, x - (0.003 * sin), 
    y - (2 * sin), Color(184 - (92 * sin), 0, 0, 255), align)
end

hook.Add("HUDPaint", "DrawHUD", function()
	local L = GetLang()
	local ply = LocalPlayer()
	local Alpha = 0
	local Mat = Material("vgui/hsv-brightness")
	if not LocalPlayer():Alive() then 
		for line = 0, 6 do
             for part = 1, 30 do
    	        local tbl = {
		             {x = 0, y = ScrH() - ScrH() * 0.06 - line * 10},
		             {x = 1 + part * 10, y = ScrH() - ScrH() * 0.06 - line * 10},
		             {x = 1 + part * 10, y = ScrH() - ScrH() * 0.055 - line * 10},
		             {x = 0, y = ScrH() - ScrH() * 0.055 - line * 10},
                }

                surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
                draw.NoTexture()
                surface.DrawPoly(tbl)
            end
        end

        DrawHotlineMiamiText(L["press_any_button"], "HotlineMiamiHUDFont1", 40, ScrH() - ScrH() * 0.14, TEXT_ALIGN_LEFT)

		for line = 0, 6 do
			for part = 1, 30 do
				local tbl = {
		            {x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.8 - line * 10},
		            {x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.8 - line * 10},
		            {x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.795 - line * 10},
		            {x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.795 - line * 10},
				}

				surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
				draw.NoTexture()
				surface.DrawPoly(tbl)
			end
		end

		DrawHotlineMiamiText(L["you_are_dead"], "HotlineMiamiHUDFont1", ScrW() * 0.98, ScrH() - ScrH() * 0.88, TEXT_ALIGN_RIGHT)
	
	else
     
		for line = 0, ScrH()*0.01 do
			for part = 1, 30 do
			   local tbl = {
					{x = 0, y = ScrH() - ScrH() * 0.09 - line * 10},
					{x = 1 + part * 10, y = ScrH() - ScrH() * 0.09 - line * 10},
					{x = 1 + part * 10, y = ScrH() - ScrH() * 0.085 - line * 10},
					{x = 0, y = ScrH() - ScrH() * 0.085 - line * 10},
			   }

				surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
				draw.NoTexture()
				surface.DrawPoly(tbl)
			end
		end
   
		DrawHotlineMiamiText(LocalPlayer():Health().." hp", "HotlineMiamiHUDFont1", ScrW()*0.025, ScrH() - ScrH() * 0.165, TEXT_ALIGN_LEFT)

		--DrawHotlineMiamiText(LocalPlayer():Armor(),  "HotlineMiamiHUDFont2", 280, ScrH() - ScrH() * 0.114, TEXT_ALIGN_RIGHT)
		local weapon = LocalPlayer():GetActiveWeapon()
		if LocalPlayer():Alive() and weapon:IsValid() and not table.HasValue(restrictweapons, weapon:GetClass()) and weapon:GetMaxClip1() ~= -1 then
			DrawHotlineMiamiText(LocalPlayer():GetActiveWeapon():Clip1().."/"..LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()),  "HotlineMiamiHUDFont2", ScrW()*0.025, ScrH() - ScrH() * 0.21, TEXT_ALIGN_LEFT)
			--DrawHotlineMiamiText(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()),  "HotlineMiamiHUDFont3", ScrW()*0.07, ScrH() - ScrH() * 0.192, TEXT_ALIGN_LEFT)
		end
		
		for line = 0, ScrH()*0.005 do
			for part = 1, 30 do
			   local tbl = {
					{x = 0, y = ScrH() - ScrH() * 0.01 - line * 10},
					{x = 1 + part * 10, y = ScrH() - ScrH() * 0.01 - line * 10},
					{x = 1 + part * 10, y = ScrH() - ScrH() * 0.005 - line * 10},
					{x = 0, y = ScrH() - ScrH() * 0.005 - line * 10},
			   }

				surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
				draw.NoTexture()
				surface.DrawPoly(tbl)
			end
		end

		local Stamina = ply.Stamina
		local MaxStamina = ply.MaxStamina
		local Alpha = 100
		local BasePercent = Alpha/100

		if MaxStamina then
			if !(Stamina == 0 and MaxStamina == 0) then
				local BaseFade = 255
				local BarWidth = 25
				local BarHeight = 25
			
				local OPercent = 5/MaxStamina
				local Percent = Stamina/MaxStamina
				local SizeScale = 1
			
				local XPos = ScrW()/2
				local YPos = ScrH() - BarHeight*2
				local XSize = BarWidth*10
				local YSize = BarHeight
				
				--surface.SetMaterial( Mat )
				surface.SetDrawColor(HotlineMiamiColor1(),BaseFade * BasePercent)
				surface.DrawTexturedRect(ScrW()*0.025, ScrH() - ScrH() * 0.03,XSize*0.9*Percent,YSize*0.5,0)

				DrawHotlineMiamiText(L["energy"],"HotlineMiamiHUDFont7", ScrW()*0.025, ScrH() - ScrH() * 0.075, TEXT_ALIGN_LEFT)
			end
		end
		
		if GAMEMODE.game_state != GAME_WAIT then
		
			for line = 0, ScrH()*0.004 do
				for part = 1, 30 do
					local tbl = {
						{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.57 - line * 10},
						{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.57 - line * 10},
						{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.565 - line * 10},
						{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.565 - line * 10},
					}

					surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
					draw.NoTexture()
					surface.DrawPoly(tbl)
				end
			end
			
			DrawHotlineMiamiText(L["top"]..": "..MVP_Name.." - "..MVP_Kills, "HotlineMiamiHUDFont7", ScrW() * 0.99, ScrH() - ScrH() * 0.6075, TEXT_ALIGN_RIGHT)
		
		end
		
		for line = 0, ScrH()*0.007 do
			for part = 1, 30 do
				local tbl = {
					{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.76 - line * 10},
					{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.76 - line * 10},
					{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.755 - line * 10},
					{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.755 - line * 10},
				}

				surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
				draw.NoTexture()
				surface.DrawPoly(tbl)
			end
		end

		DrawHotlineMiamiText(L["kills"]..": "..LocalPlayer():Frags(), "HotlineMiamiHUDFont1", ScrW() * 0.99, ScrH() - ScrH() * 0.834, TEXT_ALIGN_RIGHT)

		for line = 0, ScrH()*0.012 do
			for part = 1, 30 do
				local tbl = {
					{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.63 - line * 10},
					{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.63 - line * 10},
					{x = ScrW() - part * 10 + (part * 10), y = ScrH() - ScrH() * 0.625 - line * 10},
					{x = ScrW() - part * 10, y = ScrH() - ScrH() * 0.625 - line * 10},
				}

				surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
				draw.NoTexture()
				surface.DrawPoly(tbl)
			end
		end
		
		DrawHotlineMiamiText(L[ gamestate_string[GAMEMODE.game_state] ], "HotlineMiamiHUDFont2", ScrW() * 0.99, ScrH() - ScrH() * 0.7455, TEXT_ALIGN_RIGHT)
		
		local text = util.SimpleTime(math.max(0, GetGlobalFloat("dm_game_end", 0) - CurTime()), "%02i:%02i")
		DrawHotlineMiamiText(text, "HotlineMiamiHUDFont2", ScrW() * 0.99, ScrH() - ScrH() * 0.69, TEXT_ALIGN_RIGHT)
		
		if LocalPlayer():GetNWInt("Killstreak") > 0 then
				for line = 0, 6 do
				for part = 1, 30 do
					local tbl = {
						{x = 0, y = ScrH() - ScrH() * 0.8 - line * 10},
						{x = 1 + part * 10, y = ScrH() - ScrH() * 0.8 - line * 10},
						{x = 1 + part * 10, y = ScrH() - ScrH() * 0.795 - line * 10},
						{x = 0, y = ScrH() - ScrH() * 0.795 - line * 10},
					}

					surface.SetDrawColor(0, 0, 0, math.Clamp(part, 0, 6))
					draw.NoTexture()
					surface.DrawPoly(tbl)
				end
			end

			DrawHotlineMiamiKillstreak(LocalPlayer():GetNWInt("Killstreak").. " x", "HotlineMiamiHUDFont4", 250, ScrH() - ScrH() * 0.88, TEXT_ALIGN_RIGHT)
		end
   end


end)

hook.Add("PostPlayerDraw", "Draw3D2DHUD", function(ply)
	if not IsValid(ply) then return end
	if not ply:Alive() then return end
	if ply == LocalPlayer() then return end

	if LocalPlayer():GetPos():Distance(ply:GetPos()) >= 300 then return end

	local shootpos = LocalPlayer():GetShootPos()
	local aim = LocalPlayer():GetAimVector()

	local plypos = ply:GetShootPos()
	if plypos:DistToSqr(shootpos) < 110000 then
		local pos = plypos - shootpos
		local unitpos = pos:GetNormalized()
		if unitpos:Dot(aim) > 0.95 then
			local off = Vector(0, 0, 95)
			local ang = LocalPlayer():EyeAngles()
			local pos = ply:GetPos() + off + ang:Up()

			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)

			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
			--DrawHotlineMiamiText(ply:Frags(), "HotlineMiamiHUDFont5", 5, 0, TEXT_ALIGN_CENTER)
            if ply:GetNWInt("Killstreak") > 0 then
			    DrawHotlineMiamiKillstreak(LocalPlayer():GetNWInt("Killstreak").. " x", "HotlineMiamiHUDFont6", 5, -60, TEXT_ALIGN_CENTER)
		    end
			cam.End3D2D()

		end
	end
end)


end