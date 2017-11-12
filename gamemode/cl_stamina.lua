net.Receive("DM_StaminaSpawn", function(len)
	local ply = LocalPlayer()

	local MaxStamina = net.ReadFloat()
	local RegenMul = net.ReadFloat()
	local DecayMul = net.ReadFloat()
	
	ply.Stamina = MaxStamina
	ply.MaxStamina = MaxStamina
	ply.DecayMul = DecayMul
	ply.RegenMul = RegenMul
end)

function GetClientMove(cmd)
	local ply = LocalPlayer()
	if ply.MaxStamina == 0 and ply.DecayMul == 0 and ply.RegenMul == 0 then return end
	local NewButtons = cmd:GetButtons()
	local Change = FrameTime() * 5
	if not first then
		ply.Stamina = 100
		ply.MaxStamina = 100
		ply.DecayMul = 1
		ply.RegenMul = 1
		ply.NextRegen = 0
		first = true
	end
	if cmd:KeyDown(IN_SPEED) and ( cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) ) and (ply:GetVelocity():Length() > 100) and ( ply:OnGround() or ply:WaterLevel() ~= 0 ) and !ply:InVehicle() then
		if ply.Stamina <= 0 then
			NewButtons = NewButtons - IN_SPEED
		else
			ply.Stamina = math.Clamp(ply.Stamina - Change * ply.DecayMul,0,ply.MaxStamina)
			ply.NextRegen = CurTime() + 1.25
		end
	end
	if ply.NextRegen then
		if ply.NextRegen < CurTime() then
			if (cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT)) then
				ply.Stamina = math.Clamp(ply.Stamina + ( Change * 0.1 * ply.RegenMul ) ,0,ply.MaxStamina)
			else
				ply.Stamina = math.Clamp(ply.Stamina + ( Change * 0.5 * ply.RegenMul ) ,0,ply.MaxStamina)
			end
		end
	end
	cmd:SetButtons(NewButtons)
end
hook.Add("CreateMove","Sprint",GetClientMove)