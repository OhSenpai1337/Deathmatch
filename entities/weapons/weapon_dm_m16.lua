AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "M16"
   SWEP.Slot               = 2
	SWEP.SlotPos = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 64

   SWEP.Description = "Play like a counter-terrorist"
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 9000

SWEP.Kind                  = WEAPON_ARIFLE
SWEP.WeaponID              = AMMO_M16

SWEP.Primary.Delay         = 0.15
SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "SMG1"
SWEP.Primary.Damage        = 22
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.Cone          = 0.030
SWEP.Primary.ClipSize      = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.Sound         = Sound( "Weapon_M4A1.Single" )

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_smg1"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_m4a1.mdl"

SWEP.IronSightsPos         = Vector(-7.58, -9.2, 0.55)
SWEP.IronSightsAng         = Vector(2.599, -1.3, -3.6)