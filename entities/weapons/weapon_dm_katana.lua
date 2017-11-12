AddCSLuaFile()

SWEP.HoldType              = "melee2"
SWEP.BlockHoldType 				= "magic"

if CLIENT then
	SWEP.PrintName          = "Katana"
	SWEP.Slot               = 0
	SWEP.SlotPos = 1

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 70
	
	SWEP.Description				= [[Slice and dice like a ninja. Dash forward and unleash your 
	fury.]]
end

SWEP.Base                  = "weapon_dmbase"
SWEP.Available = true
SWEP.Price = 11000

SWEP.Primary.Damage        = 65
SWEP.Primary.Delay         = 0.55
SWEP.Primary.ClipSize      = -1
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.ClipMax       = -1
SWEP.Primary.Ammo          = "none"
SWEP.Primary.Sound         = Sound( "weapons/katana/katana_swing_miss1.wav" )

SWEP.AmmoEnt               = "none"
SWEP.Kind                  = WEAPON_MELEE
SWEP.WeaponID              = AMMO_KATANA

SWEP.UseHands              = true
SWEP.ViewModel      = "models/weapons/c_katana.mdl"
SWEP.WorldModel   	= "models/weapons/w_katana.mdl"
SWEP.NoSights = true
SWEP.SwingSound = Sound("weapons/katana/katana_swing_miss1.wav")

function SWEP:Initialize()
	if (SERVER) then
		self:SetHoldType( self.HoldType )
	end
	
	SWoodHit = {
		Sound( "weapons/katana/katana_wood_hit_1.wav" ),
		Sound( "weapons/katana/katana_wood_hit_2.wav" ),
		Sound( "weapons/katana/katana_wood_hit_3.wav" )
	}
	
	SFleshHit = {
		Sound( "ambient/machines/slicer1.wav" ),
		Sound( "ambient/machines/slicer2.wav" ),
		Sound( "ambient/machines/slicer3.wav" ),
		Sound( "ambient/machines/slicer4.wav" )
	} 
	
	SGlassHit = {
		Sound( "weapons/katana/katana_glass_hit_1.wav" ),
		Sound( "weapons/katana/katana_glass_hit_2.wav" ),
		Sound( "weapons/katana/katana_glass_hit_3.wav" )
	}
	
	SMetalHit = {
		Sound( "weapons/katana/katana_metal_hit_1.wav" ),
		Sound( "weapons/katana/katana_metal_hit_2.wav" ),
		Sound( "weapons/katana/katana_metal_hit_3.wav" ),
		Sound( "weapons/katana/katana_metal_hit_4.wav" ),
		Sound( "weapons/katana/katana_metal_hit_5.wav" ),
		Sound( "weapons/katana/katana_metal_hit_6.wav" ),
		Sound( "weapons/katana/katana_metal_hit_7.wav" )
	}
	
	SGroundHit = {
		Sound( "weapons/katana/katana_ground_hit_1.wav" ),
		Sound( "weapons/katana/katana_ground_hit_2.wav" ),
		Sound( "weapons/katana/katana_ground_hit_3.wav" ),
		Sound( "weapons/katana/katana_ground_hit_4.wav" ),
		Sound( "weapons/katana/katana_ground_hit_5.wav" )
	}
	
	self.FleshHit = {
		Sound( "weapons/katana/melee_katana_01.wav" ),
		Sound( "weapons/katana/melee_katana_02.wav" ),
		Sound( "weapons/katana/melee_katana_03.wav" )
	}	
end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self.Weapon:EmitSound("weapons/katana/katana_draw.wav")
	return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:EmitSound("Weapon_Knife.Slash")
	
	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 70 then		
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 18
		bullet.Damage = 65
		
		
		self.Owner:FireBullets(bullet)
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		
		if(trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass() == "prop_ragdoll") then
			self.Weapon:EmitSound(SFleshHit[math.random(1,#SFleshHit)])
			
		else
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
				if (trace.MatType == MAT_METAL or trace.MatType == MAT_VENT or trace.MatType == MAT_COMPUTER) then
					self.Weapon:EmitSound(SMetalHit[math.random(1,#SMetalHit)])
				elseif (trace.MatType == MAT_WOOD or trace.MatType == "MAT_FOLIAGE") then
					self.Weapon:EmitSound(SWoodHit[math.random(1,#SWoodHit)])
				elseif (trace.MatType == MAT_GLASS) then
					self.Weapon:EmitSound(SGlassHit[math.random(1,#SGlassHit)])
				elseif (trace.MatType == MAT_DIRT or trace.MatType == MAT_SAND or trace.MatType == MAT_SLOSH or trace.MatType == MAT_TILE or trace.MatType == MAT_PLASTIC or trace.MatType == MAT_CONCRETE) then
					self.Weapon:EmitSound(SGroundHit[math.random(1,#SGroundHit)])
				else 
					self.Weapon:EmitSound(SGroundHit[math.random(1,#SGroundHit)])
				end
			end
		
		if (SERVER) then
			local hitposent = ents.Create("info_target")
			local trace = self.Owner:GetEyeTrace()
			local hitpos = trace.HitPos	
		end	
	end
end

function SWEP:SecondaryAttack()
	return
end
