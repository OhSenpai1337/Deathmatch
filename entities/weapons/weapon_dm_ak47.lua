AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
	SWEP.PrintName          = "AK-47"
	SWEP.Slot               = 2
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = true
	SWEP.ViewModelFOV       = 72

	SWEP.Description = "Play like a terrorist."
end

SWEP.Base				= "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 10000

SWEP.Kind               = WEAPON_ARIFLE
SWEP.WeaponID           = AMMO_AK47

SWEP.Primary.Delay       = 0.1
SWEP.Primary.Recoil      = 0.8
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 17
SWEP.Primary.Cone        = 0.035
SWEP.Primary.Ammo        = "SMG1"
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.Sound       = Sound( "Weapon_AK47.Single" )

SWEP.AmmoEnt = "item_ammo_smg1"

SWEP.UseHands              = true
SWEP.ViewModel  = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

