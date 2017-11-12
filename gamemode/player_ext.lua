
-- serverside extensions to player table

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

-- Strips player of all equipment
function plymeta:StripAll()
end

-- Sets all flags (force_spec, etc) to their default
function plymeta:ResetStatus()
end

-- Forced specs and latejoin specs should not get points
function plymeta:ShouldScore()
	return true
end

function plymeta:ResetViewRoll()
	local ang = self:EyeAngles()
	if ang.r != 0 then
		ang.r = 0
		self:SetEyeAngles(ang)
	end
end

function plymeta:ShouldSpawn()
	return true
end

-- Preps a player for a new round, spawning them if they should. If dead_only is
-- true, only spawns if player is dead, else just makes sure he is healed.
function plymeta:SpawnForGame(dead_only)
   -- wrong alive status and not a willing spec who unforced after prep started
   -- (and will therefore be "alive")
   if dead_only and self:Alive() then
      -- if the player does not need respawn, make sure he has full health
      self:SetHealth(self:GetMaxHealth())
      return false
   end

   if not self:ShouldSpawn() then return false end

   self:StripAll()
   self:SetTeam(TEAM_ALIVE)
   self:Spawn()

   -- tell caller that we spawned
   return true
end

function plymeta:InitialSpawn()
   self.has_spawned = false

   -- The team the player spawns on depends on the round state
   self:SetTeam(TEAM_ALIVE)

   -- Always spawn innocent initially, traitor will be selected later
   self:ResetStatus()
end
