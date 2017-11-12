AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Magnum"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

	SWEP.Description = "Like a cowboy."
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 6000

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_MAGNUM

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 3
SWEP.Primary.Damage        = 65
SWEP.Primary.Delay         = 0.8
SWEP.Primary.Cone          = 0.015
SWEP.Primary.ClipSize      = 6
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "Weapon_357.Single" )

SWEP.AmmoEnt               = "item_ammo_revolver"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/c_357.mdl"
SWEP.WorldModel            = "models/weapons/w_357.mdl"

SWEP.IronSightsPos = Vector ( -4.64, -3.96, 0.68 )
SWEP.IronSightsAng = Vector ( 0.214, -0.1767, 0 )
