AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
	SWEP.PrintName          = "XM8 Compact"
	SWEP.Slot               = 2
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = true
	SWEP.ViewModelFOV       = 70

SWEP.Description = [[Using one of the most advanced weapon designs, quickly 
tear into your foes with this zooming automatic rifle.]]
end

SWEP.Base				= "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 9500

SWEP.Kind               = WEAPON_ARIFLE
SWEP.WeaponID           = AMMO_XM8B

SWEP.Primary.Delay       = 0.125
SWEP.Primary.Recoil      = 0.55
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 14
SWEP.Primary.Cone        = 0.03
SWEP.Primary.Ammo        = "SMG1"
SWEP.Primary.ClipSize    = 45
SWEP.Primary.ClipMax     = 300
SWEP.Primary.DefaultClip = 45
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.Sound       = Sound( "weapons/xm8/xm8fire.wav" )
SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.AmmoEnt = "item_ammo_smg1"

SWEP.UseHands              = true
SWEP.ViewModel				= "models/weapons/v_pvp_xm8.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_pvp_xm8.mdl"	-- Weapon world model
SWEP.IronSightsPos = Vector(2.969, -4.167, 1.869)
SWEP.IronSightsAng = Vector(0, -0.903, 0)

function SWEP:SetZoom(state)
   if IsValid(self.Owner) and self.Owner:IsPlayer() then
      if state then
         self.Owner:SetFOV(15, 0.3)
      else
         self.Owner:SetFOV(0, 0.2)
      end
   end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   if self:GetIronsights() then
	self:SetIronsights( false )
   end
   self:SetZoom( false )
   self:DefaultReload( ACT_VM_RELOAD )
   self:EmitSound( "weapons/xm8/reload.wav" )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end