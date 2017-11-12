-- shared extensions to player table

local plymeta = FindMetaTable( "Player" )
if not plymeta then return end

local math = math

function plymeta:IsAlive() return self:Team() == TEAM_ALIVE end

AccessorFunc(plymeta, "role", "Role", FORCE_NUMBER)

-- Role access
function plymeta:GetAlive() return self:Team() == TEAM_ALIVE end

plymeta.IsAlive = plymeta.GetAlive

-- Player is alive and in an active round
function plymeta:IsActive()
   return self:IsAlive() and GetRoundState() == ROUND_ACTIVE
end

--local role_strings = {
   --[ROLE_ALIVE]   = "player"
--};

local GetRTranslation = CLIENT and LANG.GetRawTranslation or util.passthrough

function plymeta:HasEquipmentWeapon()
   for _, wep in pairs(self:GetWeapons()) do
      if IsValid(wep) and wep:IsEquipment() then
         return true
      end
   end

   return false
end

function plymeta:CanCarryWeapon(wep)
   if (not wep) or (not wep.Kind) then return false end

   return self:CanCarryType(wep.Kind)
end

function plymeta:CanCarryType(t)
   if not t then return false end

   for _, w in pairs(self:GetWeapons()) do
      if w.Kind and w.Kind == t then
         return false
      end
   end
   return true
end

function plymeta:IsDeadPlayer()
   return !(self:Alive())
end

function plymeta:HasBought(id)
   return self.bought and table.HasValue(self.bought, id)
end

function plymeta:GetEquipmentItems() return self.equipment_items or EQUIP_NONE end

-- Given an equipment id, returns if player owns this. Given nil, returns if
-- player has any equipment item.
function plymeta:HasEquipmentItem(id)
   if not id then
      return self:GetEquipmentItems() != EQUIP_NONE
   else
      return util.BitSet(self:GetEquipmentItems(), id)
   end
end

function plymeta:HasEquipment()
   return self:HasEquipmentItem() or self:HasEquipmentWeapon()
end

if CLIENT then
   -- Server has this, but isn't shared for some reason
   function plymeta:HasWeapon(cls)
      for _, wep in pairs(self:GetWeapons()) do
         if IsValid(wep) and wep:GetClass() == cls then
            return true
         end
      end

      return false
   end

   local gmod_GetWeapons = plymeta.GetWeapons
   function plymeta:GetWeapons()
      if self != LocalPlayer() then
         return {}
      else
         return gmod_GetWeapons(self)
      end
   end
end

-- Override GetEyeTrace for an optional trace mask param. Technically traces
-- like GetEyeTraceNoCursor but who wants to type that all the time, and we
-- never use cursor tracing anyway.
function plymeta:GetEyeTrace(mask)
   if self.LastPlayerTraceMask == mask and self.LastPlayerTrace == CurTime() then
      return self.PlayerTrace
   end

   local tr = util.GetPlayerTrace(self)
   tr.mask = mask

   self.PlayerTrace = util.TraceLine(tr)
   self.LastPlayerTrace = CurTime()
   self.LastPlayerTraceMask = mask

   return self.PlayerTrace
end
