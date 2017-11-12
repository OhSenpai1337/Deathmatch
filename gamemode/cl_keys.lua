-- Key overrides for DM specific keyboard functions

local function SendWeaponDrop()
   RunConsoleCommand("dm_dropweapon")

   -- Turn off weapon switch display if you had it open while dropping, to avoid
   -- inconsistencies.
end

function GM:OnSpawnMenuOpen()
	SendWeaponDrop()
end

local DefaultRunSpeed		= 500	-- If you change this value you need to change it in garrysmod\addons\darkrpmodification\lua\darkrp_config\settings.lua too
local DefaultWalkSpeed		= 250	-- If you change this value you need to change it in garrysmod\addons\darkrpmodification\lua\darkrp_config\settings.lua too

local DisableLevel			= 10	-- (0 - 100) When should Run & Jump get disabled

local StaminaDrainSpeed 	= 0.25	-- Time in seconds
local StaminaRestoreSpeed 	= 0.75	-- Time in seconds

function StaminaRestore(ply)
	timer.Create( "StaminaGain", StaminaRestoreSpeed, 0, function( ) 
		if ply:GetNWInt( "Stamina" ) >= 100 then
			return false
		else
			ply:SetNWInt( "Stamina", ply:GetNWInt( "Stamina" ) + 1 )
		end
	end)
end

function GM:KeyPress(ply, key)
	if not IsValid(ply) then return end
	if key == IN_SPEED then
		if ply:InVehicle() then return end
		if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
		if ply:GetMoveType() ==  MOVETYPE_LADDER then return end
		if ply:GetNWInt( "Stamina" ) >= DisableLevel then
			ply:SetRunSpeed( DefaultRunSpeed )
			timer.Destroy( "StaminaGain" )
			timer.Create( "StaminaTimer", StaminaDrainSpeed, 0, function( )
				if ply:GetNWInt( "Stamina" ) <= 0 then
					ply:SetRunSpeed( DefaultWalkSpeed )
					timer.Destroy( "StaminaTimer" )
					return false
				end
				local vel = ply:GetVelocity()
				if vel.x >= DefaultWalkSpeed or vel.x <= -DefaultWalkSpeed or vel.y >= DefaultWalkSpeed or vel.y <= -DefaultWalkSpeed then
					ply:SetNWInt( "Stamina", ply:GetNWInt( "Stamina" ) - 1 )
				end
			end)
		else
			ply:SetRunSpeed( DefaultWalkSpeed )
			timer.Destroy( "StaminaTimer" )
		end
	end
end
function GM:KeyRelease(ply, key)
	if key == IN_SPEED then
		timer.Destroy( "StaminaTimer" )
		StaminaRestore( ply )	
	end
end