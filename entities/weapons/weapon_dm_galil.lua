AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "Galil"
   SWEP.Slot               = 2
   SWEP.SlotPos = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 58
   
	SWEP.Description = [[A less expensive option among the terrorist-exclusive 
	assault rifles]]
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 7500

SWEP.Kind                  = WEAPON_ARIFLE
SWEP.WeaponID              = AMMO_GALIL

SWEP.Primary.Delay         = 0.095
SWEP.Primary.Recoil        = 1.1
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "SMG1"
SWEP.Primary.Damage        = 16
SWEP.Primary.Cone          = 0.021
SWEP.Primary.ClipSize      = 25
SWEP.Primary.ClipMax       = 240
SWEP.Primary.DefaultClip   = 25
SWEP.Primary.Sound         = Sound( "Weapon_galil.Single" )

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_smg1"

SWEP.UseHands              = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_galil.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_galil.mdl")
SWEP.IronSightsPos = Vector( -6.361, -11.103, 2.519 )