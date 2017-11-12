AddCSLuaFile()

SWEP.HoldType            = "smg"

if CLIENT then
   SWEP.PrintName        = "SMG"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 60

	SWEP.Description = "Classic SMG from Half-Life 2"
end

SWEP.Base                = "weapon_dmbase"
SWEP.Available = true

SWEP.Kind                = WEAPON_SMG
SWEP.WeaponID            = AMMO_SMG

SWEP.Primary.Damage      = 13
SWEP.Primary.Delay       = 0.1
SWEP.Primary.Cone        = 0.025
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 240
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 0.5
SWEP.HeadshotMultiplier    = 1.75
SWEP.Primary.Sound       = Sound( "Weapon_SMG1.Single" )

SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/c_smg1.mdl"
SWEP.WorldModel          = "models/weapons/w_smg1.mdl"
SWEP.InDefault = true
SWEP.CanSell = false

SWEP.IronSightsPos = Vector( -5.361, -7.481, 1.559 )
SWEP.IronSightsAng = Vector( 2, 0, 0 )

