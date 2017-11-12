AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "P90"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Description = "Typical noob weapon"
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Price = 9500

SWEP.Kind                  = WEAPON_SMG
SWEP.WeaponID              = AMMO_P90
SWEP.AmmoEnt               = "item_ammo_smg1"

SWEP.Primary.Damage        = 10
SWEP.Primary.Delay         = 0.08
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 50
SWEP.Primary.ClipMax       = 240
SWEP.Primary.DefaultClip   = 50
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Recoil        = 1
SWEP.Primary.Sound         = Sound( "Weapon_p90.Single" )

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_p90.mdl"

SWEP.IronSightsPos         = Vector(-5.5, -1.5, 3)
SWEP.IronSightsAng         = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 2.3 -- brain fizz
--SWEP.DeploySpeed = 3