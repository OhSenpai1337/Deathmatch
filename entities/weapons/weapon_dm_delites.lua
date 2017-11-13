AddCSLuaFile()

SWEP.HoldType              = "duel"

if CLIENT then
   SWEP.PrintName          = "Dual Berettas"
   SWEP.Slot               = 1
   
   SWEP.UseHands = true 
   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 55
	SWEP.Description				= [[Two guns are better than one. Use this combo to 
	your advantage.]]
end
SWEP.Price = 3000

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_dmbase"
SWEP.Available = true
SWEP.HoldType			= "duel"
SWEP.Primary.Delay       = 0.15
SWEP.Primary.Recoil      = 1
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 16
SWEP.Primary.Cone        = 0.03
SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.Sound = Sound("Weapon_Elite.Single")
SWEP.NoSights = true
SWEP.ViewModel  = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_pistol"
