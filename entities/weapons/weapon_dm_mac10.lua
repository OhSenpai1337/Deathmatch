AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "MAC10"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/unnamed/icon/icon_mac"
   SWEP.IconLetter       = "l"
   
   SWEP.Description      = "MAC-10 is a moderately powerful machine pistol"
end

SWEP.Base                = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 3000

SWEP.Kind                = WEAPON_SMG
SWEP.WeaponID            = AMMO_MAC10

SWEP.Primary.Damage      = 12
SWEP.Primary.Delay       = 0.075
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mac10.mdl"

SWEP.IronSightsPos       = Vector(-8.921, -9.528, 2.9)
SWEP.IronSightsAng       = Vector(0.699, -5.301, -7)

--SWEP.DeploySpeed         = 3

SWEP.HeadshotMultiplier    = 2
