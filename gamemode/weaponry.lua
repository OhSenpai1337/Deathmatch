
include("weaponry_shd.lua") -- inits WEPS tbl

---- Weapon system, pickup limits, etc

local IsEquipment = WEPS.IsEquipment

-- Prevent players from picking up multiple weapons of the same type etc
function GM:PlayerCanPickupWeapon(ply, wep)
   if not IsValid(wep) or not IsValid(ply) then return end

   -- Disallow picking up for ammo
   if ply:HasWeapon(wep:GetClass()) then
      return false
   elseif not ply:CanCarryWeapon(wep) then
      return false
   end

   local tr = util.TraceEntity({start=wep:GetPos(), endpos=ply:GetShootPos(), mask=MASK_SOLID}, wep)
   if tr.Fraction == 1.0 or tr.Entity == ply then
      wep:SetPos(ply:GetShootPos())
   end

   return true
end

---- Weapon switching
local function ForceWeaponSwitch(ply, cmd, args)
   if not ply:IsPlayer() or not args[1] then return end
   -- Turns out even SelectWeapon refuses to switch to empty guns, gah.
   -- Worked around it by giving every weapon a single Clip2 round.
   -- Works because no weapon uses those.
   local wepname = args[1]
   local wep = ply:GetWeapon(wepname)
   if IsValid(wep) then
      -- Weapons apparently not guaranteed to have this
      if wep.SetClip2 then
         wep:SetClip2(1)
      end
      ply:SelectWeapon(wepname)
   end
end
concommand.Add("wepswitch", ForceWeaponSwitch)

---- Weapon dropping

function WEPS.DropNotifiedWeapon(ply, wep, death_drop)
   if IsValid(ply) and IsValid(wep) then
      -- Hack to tell the weapon it's about to be dropped and should do what it
      -- must right now
      if wep.PreDrop then
         wep:PreDrop(death_drop)
      end

      -- PreDrop might destroy weapon
      if not IsValid(wep) then return end

      -- Tag this weapon as dropped, so that if it's a special weapon we do not
      -- auto-pickup when nearby.
      wep.IsDropped = true

      ply:DropWeapon(wep)

      wep:PhysWake()

      -- After dropping a weapon, always switch to holstered, so that traitors
      -- will never accidentally pull out a traitor weapon
      --ply:SelectWeapon("weapon_ttt_unarmed")
   end
end

local function DropActiveWeapon(ply)
   if not IsValid(ply) then return end

   local wep = ply:GetActiveWeapon()

   if not IsValid(wep) then return end

   if wep.AllowDrop == false then
      return
   end

   local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32, ply)

   if tr.HitWorld then
      LANG.Msg(ply, "drop_no_room")
      return
   end

   --ply:AnimPerformGesture(ACT_ITEM_PLACE)

   WEPS.DropNotifiedWeapon(ply, wep)
end
concommand.Add("dm_dropweapon", DropActiveWeapon)

-- Protect against non-TTT weapons that may break the HUD
function GM:WeaponEquip(wep)
   if IsValid(wep) then
      -- only remove if they lack critical stuff
      if not wep.Kind then
         wep:Remove()
         ErrorNoHalt("Equipped weapon " .. wep:GetClass() .. " is not compatible with TTT\n")
      end
   end
end

-- non-cheat developer commands can reveal precaching the first time equipment
-- is bought, so trigger it at the start of a round instead
function WEPS.ForcePrecache()
   for k, w in ipairs(weapons.GetList()) do
      if w.WorldModel then
         util.PrecacheModel(w.WorldModel)
      end
      if w.ViewModel then
         util.PrecacheModel(w.ViewModel)
      end
   end
end
