AddCSLuaFile()

sound.Add({
	name = 			"Weapon_akimbo.fire",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	pitch = { 95, 110 },
	sound = 			{ "weapons/akimbo/akimbofire1.wav", "weapons/akimbo/akimbofire2.wav" }
})

SWEP.HoldType              = "duel"

if CLIENT then
	SWEP.PrintName          = "Akimbo Pistols"
	SWEP.Slot               = 1
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = true
	SWEP.ViewModelFOV       = 70
	SWEP.Description				= [[Two guns are better than one. Use this combo to 
	your advantage.]]
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 3500

SWEP.Primary.Recoil        = 0.75
SWEP.Primary.Damage        = 15
SWEP.Primary.Delay         = 0.125
SWEP.Primary.Cone          = 0.025
SWEP.Primary.ClipSize      = 24
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 24
SWEP.Primary.ClipMax       = 120
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_akimbo.fire" )

SWEP.AmmoEnt               = "item_ammo_pistol"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_AKIMBO

SWEP.HeadshotMultiplier    = 2

SWEP.UseHands              = true
SWEP.ViewModel				= "models/weapons/v_pvp_akimbo.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_pvp_akimbo.mdl"	-- Weapon world model
SWEP.NoSights = true