AddCSLuaFile()

SWEP.HoldType              = "shotgun"

if CLIENT then
   SWEP.PrintName          = "Pump Shotgun"
   SWEP.Slot               = 3

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54
   
   SWEP.Description = "Pump shotgun. Yep. I dont know what else to write."
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 6500

SWEP.Kind                  = WEAPON_SHOTGUN
SWEP.WeaponID              = AMMO_SHOTGUN

SWEP.Primary.Ammo          = "Buckshot"
SWEP.Primary.Damage        = 13
SWEP.Primary.Cone          = 0.2
SWEP.Primary.Delay         = 1
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.Automatic     = false
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "Weapon_m3.Single" )
SWEP.Primary.Recoil        = 10

SWEP.AmmoEnt               = "item_box_buckshot"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel            = "models/weapons/w_shot_m3super90.mdl"

SWEP.IronSightsPos         = Vector(-6.881, -9.214, 2.66)
SWEP.IronSightsAng         = Vector(-0.101, -0.7, -0.201)

SWEP.reloadtimer           = 0

function SWEP:SetupDataTables()
   self:DTVar( "Bool", 0, "reloading" )

   return self.BaseClass.SetupDataTables( self )
end

function SWEP:Reload()
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end

   if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then

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

   self.reloadtimer = CurTime() + self:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )

   self.reloadtimer = CurTime() + self:SequenceDuration()
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

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 60)

   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.8)))
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy( self )
end