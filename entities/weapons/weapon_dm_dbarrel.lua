AddCSLuaFile()

sound.Add({
	name = 			"Weapon_Double.Fire",			
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	pitch = { 95, 110 },
	sound = 			 "weapons/doublebarrel/shoot.wav"
})

SWEP.HoldType              = "shotgun"
SWEP.Available = true
SWEP.Price = 5500

if CLIENT then
	SWEP.PrintName          = "Double Barrel"
	SWEP.Slot               = 3
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 69

	SWEP.Description				= [[Pried out of the hands of a dead Mississippi man, this 
	double barreled shotgun is immensely powerful.]]
end

SWEP.Base                  = "weapon_dmbase"

SWEP.Primary.Recoil        = 5
SWEP.Primary.Damage        = 30
SWEP.Primary.Delay         = 0.55
SWEP.Primary.Cone          = 0.065
SWEP.Primary.ClipSize      = 2
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 2
SWEP.Primary.ClipMax       = 120
SWEP.Primary.Ammo          = "buckshot"
SWEP.Primary.NumShots      = 2
SWEP.Primary.Sound         = Sound( "Weapon_Double.Fire" )

SWEP.AmmoEnt               = "item_box_buckshot"
SWEP.Kind                  = WEAPON_SHOTGUN
SWEP.WeaponID              = AMMO_DBARREL

SWEP.HeadshotMultiplier    = 4

SWEP.UseHands              = true
SWEP.ViewModel				= "models/weapons/v_vir_doubleb.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_vir_doubleb.mdl"	-- Weapon world model

SWEP.IronSightsPos         = Vector(-2.76, 4, -0.681)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function SWEP:SetupDataTables()
   self:DTVar( "Bool", 0, "reloading" )

   return self.BaseClass.SetupDataTables( self )
end

function SWEP:Reload()
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end

   if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
	self:EmitSound( "weapons/doublebarrel/barreldown.wav" )
      if self:StartReload() then
         return
      end
   end
end

function SWEP:StartReload()
   if self.dt.reloading then
      return false
   end

   self:SetIronsights( false )

   if not IsFirstTimePredicted() then return false end

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local ply = self.Owner

   if not ply or ply:GetAmmoCount( self.Primary.Ammo ) <= 0 then 
      return false
   end

   local wep = self

   if wep:Clip1() >= self.Primary.ClipSize then 
      return false 
   end

   wep:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )

   self.reloadtimer =  CurTime() + wep:SequenceDuration()

   --wep:SetNWBool( "reloading", true )
   self.dt.reloading = true

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount( self.Primary.Ammo ) <= 0 then return end

   if self:Clip1() >= self.Primary.ClipSize then return end

   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
   self:SetClip1( self:Clip1() + 1 )

   self:SendWeaponAnim( ACT_VM_RELOAD )
   self:EmitSound( "weapons/doublebarrel/shell_insert.wav" )

   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
   self.reloadtimer = CurTime() + self:SequenceDuration()
   self:EmitSound( "weapons/doublebarrel/barrelup.wav" )
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown( IN_ATTACK ) then
         self:FinishReload()
         return
      end

      if self.reloadtimer <= CurTime() then

         if self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 then
            self:FinishReload()
         elseif self:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return            
      end
   end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy( self )
end