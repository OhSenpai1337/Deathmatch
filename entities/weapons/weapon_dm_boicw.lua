AddCSLuaFile()

sound.Add({
	name = 			"Weapon_OICW.Shoot",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	pitch = { 95, 110 },
	sound = 			 { "weapons/oicw/ar2_fire1.wav", "weapons/oicw/ar2_fire2.wav", "weapons/oicw/ar2_fire3.wav" }
})

sound.Add({
	name = 			"Weapon_OICW.Magout",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/oicw/oicw_reload.wav"	
})

SWEP.HoldType              = "ar2"

if CLIENT then
	SWEP.PrintName          = "XM29 OICW"
	SWEP.Slot               = 2
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 60

	SWEP.Description = [[A powerful rifle with a scope! Try the assault rifle
	of the future.]]
end

SWEP.Base				= "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 8500

SWEP.Kind               = WEAPON_ARIFLE
SWEP.WeaponID           = AMMO_BOICW

SWEP.Primary.Delay       = 0.15
SWEP.Primary.Recoil      = 0.6
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 15
SWEP.Primary.Cone        = 0.02
SWEP.Primary.Ammo        = "SMG1"
SWEP.Primary.ClipSize    = 25
SWEP.Primary.ClipMax     = 240
SWEP.Primary.DefaultClip = 25
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.Sound       = Sound( "Weapon_OICW.Shoot" )
SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.AmmoEnt = "item_ammo_smg1"

SWEP.UseHands              = false
SWEP.ViewModel				= "models/weapons/v_oicw.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_ar2.mdl"	-- Weapon world model
SWEP.IronSightsPos = Vector(-5.87, -4.388, 1.394)
SWEP.IronSightsAng = Vector(0, -0.065, 0)

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
   self:EmitSound( Sound("Weapon_OICW.Magout") )
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

