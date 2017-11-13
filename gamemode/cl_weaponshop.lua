---- Weapon Shop

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

WeaponShop = {}

function WeaponShop:Info(weapon_id)
	local margin = 15
	local ply = LocalPlayer()
	local dframe = vgui.Create("DFrame")
	local w, h = 450, 200
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:ShowCloseButton(true)
	dframe.Paint = function(self,w,h)
		draw.RoundedBox(6, 0, 0, w, h, Color(220, 220, 220, 255))
	end
	
	local infopanel = vgui.Create("DPanel",dframe)
	infopanel:SetSize(dframe:GetWide(),30)
	infopanel.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(135, 206, 235, 255))
		draw.SimpleText(GetTranslation("info"), "SmallTitle", 110, 14, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	local closeButton = vgui.Create('DButton', dframe)
	closeButton:SetFont('marlett')
	closeButton:SetText('r')
	closeButton.Paint = function() end
	closeButton:SetColor(Color(255, 255, 255))
	closeButton:SetSize(32, 32)
	closeButton:SetPos(dframe:GetWide() - 40, -2)
	closeButton.DoClick = function()
		dframe:Close()
	end
	
	local wep = weapons.Get(weapon_id)
	
	local wep_name = vgui.Create("DLabel",dframe)
	wep_name:SetText(GetTranslation("name")..[[: ]]..wep.PrintName..[[
			
	]]..GetTranslation("clipsize")..[[: ]]..wep.Primary.ClipSize..[[
			
	]]..GetTranslation("slot")..[[: ]]..(wep.Slot+1)..[[
			
	]]..GetTranslation("price")..[[: ]]..wep.Price..[[
	
	]]..GetTranslation("damage")..[[: ]]..wep.Primary.Damage..[[
	
	]]..GetTranslation("equip_desc")..[[: ]]..wep.Description)
	wep_name:SetFont("TextFont")
	wep_name:SetColor(Color(0,0,0))
	wep_name:SizeToContents()
	wep_name:SetPos(5,35)
	
	dframe:MakePopup()
end	

function WeaponShop:Show()
	local margin = 15
	local ply = LocalPlayer()
	local dframe = vgui.Create("DFrame")
	local w, h = ScrW()*0.5, ScrH()*0.95
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
		draw.SimpleText(GetTranslation("weapon_shop"),"LargeTitle",10,8, color_white)
		draw.SimpleText(GetTranslation("points")..": "..ply:WS_GetPoints(), "SmallTitle", self:GetWide() - 40, 24, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
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
	dtabs:SetSize(w,800-50)
	dtabs:StretchToParent(0, 50, 0, 0)
	dtabs.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color (232, 232, 232, 255))
	end

	local padding = dtabs:GetPadding()

	padding = padding *2
	
	local melee = vgui.Create("DPanelList", dtabs)
	melee:StretchToParent(0,0,padding,0)
	melee:EnableVerticalScrollbar(true)
	melee:SetPadding(10)
	melee:SetSpacing(10)
	
	local pistol = vgui.Create("DPanelList", dtabs)
	pistol:StretchToParent(0,0,padding,0)
	pistol:EnableVerticalScrollbar(true)
	pistol:SetPadding(10)
	pistol:SetSpacing(10)
	
	local shotgun = vgui.Create("DPanelList", dtabs)
	shotgun:StretchToParent(0,0,padding,0)
	shotgun:EnableVerticalScrollbar(true)
	shotgun:SetPadding(10)
	shotgun:SetSpacing(10)
	
	local smg = vgui.Create("DPanelList", dtabs)
	smg:StretchToParent(0,0,padding,0)
	smg:EnableVerticalScrollbar(true)
	smg:SetPadding(10)
	smg:SetSpacing(10)
	
	local arifle = vgui.Create("DPanelList", dtabs)
	arifle:StretchToParent(0,0,padding,0)
	arifle:EnableVerticalScrollbar(true)
	arifle:SetPadding(10)
	arifle:SetSpacing(10)
	
	local rifle = vgui.Create("DPanelList", dtabs)
	rifle:StretchToParent(0,0,padding,0)
	rifle:EnableVerticalScrollbar(true)
	rifle:SetPadding(10)
	rifle:SetSpacing(10)
	
	local grenade = vgui.Create("DPanelList", dtabs)
	grenade:StretchToParent(0,0,padding,0)
	grenade:EnableVerticalScrollbar(true)
	grenade:SetPadding(10)
	grenade:SetSpacing(10)
	
	for k, v in pairs(weapons.GetList()) do
		if v and v.Available then
			local wep = {
				id       = WEPS.GetClass(v),
				name     = v.PrintName or "Unnamed",
				kind     = v.Kind or WEAPON_NONE,
				clipsize     = v.Primary.ClipSize or "None",
				slot     = (v.Slot or 0) + 1,
				description = v.Description or "None",
				price = v.Price or "Default",
				default = v.InDefault or false,
				model = v.WorldModel
			}
			local weapon = vgui.Create("DPanel")
			weapon:SetSize(614, 64)
			
			local weapon_md_bg = vgui.Create("DPanel",weapon)
			weapon_md_bg:SetSize(64,64)
			weapon_md_bg.Paint = function(self,w,h)
				draw.RoundedBox(0, 0, 0, w, h, Color (240, 240, 240, 255))
			end
			
			local weapon_model = vgui.Create("DModelPanel",weapon)
			weapon_model:SetSize(64,64)
			weapon_model:SetModel(wep.model)
			
			local PrevMins, PrevMaxs = weapon_model.Entity:GetRenderBounds()
			weapon_model:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.45, 0.45, 0.45))
			weapon_model:SetLookAt((PrevMaxs + PrevMins) / 2)
			weapon_model:SetTooltip(wep.description)
			
			local wep_name = vgui.Create("DLabel",weapon)
			wep_name:SetText(GetTranslation("name")..[[: ]]..wep.name..[[
			
			]]..GetTranslation("clipsize")..[[: ]]..wep.clipsize..[[
			
			]]..GetTranslation("slot")..[[: ]]..wep.slot..[[
			
			]]..GetTranslation("price")..[[: ]]..wep.price)
			wep_name:SetFont("TextFont")
			wep_name:SetColor(Color(0,0,0))
			wep_name:SizeToContents()
			wep_name:SetPos(74,0)
			
			local wep_opt = vgui.Create("DButton", weapon)
			wep_opt:SetSize(64,64)
			wep_opt:SetFont("TextFont")
			wep_opt:SetText(GetTranslation("opt"))
			wep_opt.Paint = function(self,w,h)
				draw.RoundedBox(0, 0, 0, w, h, Color (153, 102, 204, 255))
			end
			wep_opt:Dock(RIGHT)
			wep_opt.DoClick = function()
				local menu = DermaMenu()
				if !ply:WS_HasItem(wep.id) and !wep.default then
					menu:AddOption( GetTranslation("buy"), function()
						ply:WS_BuyItem(wep.id)
					end ):SetIcon( "icon16/basket.png" )
				end
				if !wep.default and ply:WS_HasItem(wep.id) then
					menu:AddOption( GetTranslation("sell"), function()
						ply:WS_SellItem(wep.id)
					end ):SetIcon( "icon16/money_add.png" )	
				end
				if ply:WS_HasItem(wep.id) or wep.default then
					if ply:WS_HasItemEquipped(wep.id) then
						menu:AddOption( GetTranslation("holster"), function()
							ply:WS_HolsterItem(wep.id)
						end ):SetIcon( "icon16/package_go.png" )	
					else
						menu:AddOption( GetTranslation("equip"), function()
							ply:WS_EquipItem(wep.id)
						end ):SetIcon( "icon16/accept.png" )
					end
				end
				menu:AddOption( GetTranslation("info"), function()
					WeaponShop:Info(wep.id)
				end ):SetIcon( "icon16/information.png" )						
				menu:Open()
			end
			
			if wep.kind == WEAPON_MELEE then
				melee:AddItem(weapon)
			elseif wep.kind == WEAPON_PISTOL then
				pistol:AddItem(weapon)
			elseif wep.kind == WEAPON_SHOTGUN then
				shotgun:AddItem(weapon)
			elseif wep.kind == WEAPON_SMG then
				smg:AddItem(weapon)
			elseif wep.kind == WEAPON_ARIFLE then
				arifle:AddItem(weapon)
			elseif wep.kind == WEAPON_RIFLE then
				rifle:AddItem(weapon)
			else
				grenade:AddItem(weapon)
			end
		end
	end
	
	dtabs:AddSheet(GetTranslation("melee"), melee, "icon16/cog.png", false, false, GetTranslation("melee"))
	dtabs:AddSheet(GetTranslation("pistols"), pistol, "icon16/gun.png", false, false, GetTranslation("pistols"))
	dtabs:AddSheet(GetTranslation("shotguns"), shotgun, "icon16/sport_8ball.png", false, false, GetTranslation("shotguns"))
	dtabs:AddSheet(GetTranslation("smg"), smg, "icon16/controller.png", false, false, GetTranslation("smg"))
	dtabs:AddSheet(GetTranslation("arifles"), arifle, "icon16/mouse.png", false, false, GetTranslation("arifles"))
	dtabs:AddSheet(GetTranslation("rifles"), rifle, "icon16/emoticon_tongue.png", false, false, GetTranslation("rifles"))
	dtabs:AddSheet(GetTranslation("grenades"), grenade, "icon16/bomb.png", false, false, GetTranslation("grenades"))
	
	dframe:MakePopup()
end

function WeaponShop:Think()
	local ply = LocalPlayer()
	
	PrintTable(melee:GetItems())
end

local function ShowDMShop(ply, cmd, args)
	WeaponShop:Show()
end
concommand.Add("dm_weaponshop", ShowDMShop)
