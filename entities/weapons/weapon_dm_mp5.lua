AddCSLuaFile()

SWEP.HoldType            = "smg"

if CLIENT then
   SWEP.PrintName        = "MP5"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 60

   SWEP.Description = "Just MP5. Yep"
end

SWEP.Base                = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 3500

SWEP.Kind                = WEAPON_SMG
SWEP.WeaponID            = AMMO_MP5

SWEP.Primary.Damage      = 16
SWEP.Primary.Delay       = 0.1
SWEP.Primary.Cone        = 0.045
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.HeadshotMultiplier    = 1.75
SWEP.Primary.Sound       = Sound( "Weapon_mp5navy.Single" )

SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mp5.mdl"

SWEP.IronSightsPos = Vector( -5.361, -7.481, 1.559 )
SWEP.IronSightsAng = Vector( 2, 0, 0 )

