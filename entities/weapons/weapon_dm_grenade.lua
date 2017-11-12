AddCSLuaFile()

SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName	 = "Grenade"
   SWEP.Slot		 = 4
   SWEP.ViewModelFlip      = true

	SWEP.Description = "Just a grenade. Yep"
end

SWEP.Base				= "weapon_dmbasegrenade"
SWEP.Available = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_GRENADE

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = false
SWEP.InDefault = true
SWEP.CanSell = false

function SWEP:GetGrenadeName()
   return "dm_grenade_proj"
end
