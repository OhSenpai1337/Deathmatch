function StaminaResetVariables(ply)
	net.Start("DM_StaminaSpawn")
		if GetConVar("dm_stamina"):GetInt() == 1 then
			net.WriteFloat(GetConVarNumber("dm_maxstamina"))
			net.WriteFloat(GetConVarNumber("dm_regenmul"))
			net.WriteFloat(GetConVarNumber("dm_decaymul"))
		else
			net.WriteFloat(0)
			net.WriteFloat(0)
			net.WriteFloat(0)
		end
	net.Send(ply)
end

function GM:PlayerConnect( name )
	LANG.Msg("ply_connected",{name = name})
end

function GM:PlayerDisconnected( ply )
	LANG.Msg("ply_disconnected",{name = ply:Name(), sid = ply:SteamID()})
end

function GM:PlayerInitialSpawn( ply )
	if not GAMEMODE.cvar_init then
		GAMEMODE:InitCvars()
	end
	ply:WS_PlayerInitialSpawn()
	ply:InitialSpawn()
	StaminaResetVariables(ply)
end

local function GiveWeapons(ply)
	local weps = {}
	for k, v in pairs(weapons.GetList()) do
		if v and v.InDefault then
			local v_id = WEPS.GetClass(v)
			local v_kind = v.Kind
			weps[v_kind] = v_id
		end
	end
	if !(ply.WS_Items == nil) then
		for k, wep in pairs(ply.WS_Items) do
			if wep and wep.Equipped then
				local wep_id = wep.id
				if !(wep_id == nil) then wep_kind = weapons.Get(wep.id).Kind end
				if wep_id != v_id then weps[wep_kind] = wep.id end

			end
		end	
	end
	for i=1,7 do
		if weps[i] != nil then ply:Give(weps[i]) end
	end
	ply:GiveAmmo(240, "SMG1")
	ply:GiveAmmo(240, "Pistol")
	ply:GiveAmmo(240, "buckshot")
	ply:GiveAmmo(240, "AlyxGun")
	ply:GiveAmmo(240, "357")
end

function GM:PlayerSpawn(ply)
	-- Some spawns may be tilted
	ply:ResetViewRoll()
	-- latejoiner, send him some info
	if GetGameState() == GAME_ACTIVE then
		SendGameState(GetGameState(), ply)
	end
	ply.has_spawned = true
	ply:SetupHands()
	StaminaResetVariables(ply)
	if GetGameState() == GAME_ACTIVE then
		GiveWeapons(ply)
	end
	local mdl = GetRandomPlayerModel()
	util.PrecacheModel(mdl)
	ply:SetModel(mdl)
	--hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:PlayerSetHandsModel( pl, ent )
   local simplemodel = player_manager.TranslateToPlayerModelName(pl:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      ent:SetModel(info.model)
      ent:SetSkin(info.skin)
      ent:SetBodyGroups(info.body)
   end
end

function GM:IsSpawnpointSuitable(ply, spwn, force, rigged)
   if not IsValid(ply) or not ply:IsAlive() then return true end
   if not rigged and (not IsValid(spwn) or not spwn:IsInWorld()) then return false end

   -- spwn is normally an ent, but we sometimes use a vector for jury rigged
   -- positions
   local pos = rigged and spwn or spwn:GetPos()

   if not util.IsInWorld(pos) then return false end

   local blocking = ents.FindInBox(pos + Vector( -16, -16, 0 ), pos + Vector( 16, 16, 64 ))

   for k, p in pairs(blocking) do
      if IsValid(p) and p:IsPlayer() and p:IsAlive() and p:Alive() then
         if force then
            p:Kill()
         else
            return false
         end
      end
   end

   return true
end

local SpawnTypes = {"info_player_deathmatch", "info_player_combine",
"info_player_rebel", "info_player_counterterrorist", "info_player_terrorist",
"info_player_axis", "info_player_allies", "gmod_player_start",
"info_player_teamspawn"}

function GetSpawnEnts(shuffled, force_all)
   local tbl = {}
   for k, classname in pairs(SpawnTypes) do
      for _, e in pairs(ents.FindByClass(classname)) do
         if IsValid(e) and (not e.BeingRemoved) then
            table.insert(tbl, e)
         end
      end
   end


   -- Don't use info_player_start unless absolutely necessary, because eg. TF2
   -- uses it for observer starts that are in places where players cannot really
   -- spawn well. At all.
   if force_all or #tbl == 0 then
      for _, e in pairs(ents.FindByClass("info_player_start")) do
         if IsValid(e) and (not e.BeingRemoved) then
            table.insert(tbl, e)
         end
      end
   end

   if shuffled then
      table.Shuffle(tbl)
   end

   return tbl
end

-- Generate points next to and above the spawn that we can test for suitability
local function PointsAroundSpawn(spwn)
   if not IsValid(spwn) then return {} end
   local pos = spwn:GetPos()

   local w, h = 36, 72 -- bit roomier than player hull

   -- all rigged positions
   -- could be done without typing them out, but would take about as much time
   return {
      pos + Vector( w,  0,  0),
      pos + Vector( 0,  w,  0),
      pos + Vector( w,  w,  0),
      pos + Vector(-w,  0,  0),
      pos + Vector( 0, -w,  0),
      pos + Vector(-w, -w,  0),
      pos + Vector(-w,  w,  0),
      pos + Vector( w, -w,  0)
      --pos + Vector( 0,  0,  h) -- just in case we're outside
   };
end

function GM:PlayerSelectSpawn(ply)
   if (not self.SpawnPoints) or (table.Count(self.SpawnPoints) == 0) or (not IsTableOfEntitiesValid(self.SpawnPoints)) then

      self.SpawnPoints = GetSpawnEnts(true, false)

      -- One might think that we have to regenerate our spawnpoint
      -- cache. Otherwise, any rigged spawn entities would not get reused, and
      -- MORE new entities would be made instead. In reality, the map cleanup at
      -- round start will remove our rigged spawns, and we'll have to create new
      -- ones anyway.
   end

   local num = table.Count(self.SpawnPoints)
   if num == 0 then
      Error("No spawn entity found!\n")
      return
   end

   -- Just always shuffle, it's not that costly and should help spawn
   -- randomness.
   table.Shuffle(self.SpawnPoints)

   -- Optimistic attempt: assume there are sufficient spawns for all and one is
   -- free
   for k, spwn in pairs(self.SpawnPoints) do
      if self:IsSpawnpointSuitable(ply, spwn, false) then
         return spwn
      end
   end

   -- That did not work, so now look around spawns
   local picked = nil

   for k, spwn in pairs(self.SpawnPoints) do
      picked = spwn -- just to have something if all else fails

      -- See if we can jury rig a spawn near this one
      local rigged = PointsAroundSpawn(spwn)
      for _, rig in pairs(rigged) do
         if self:IsSpawnpointSuitable(ply, rig, false, true) then
            local rig_spwn = ents.Create("info_player_terrorist")
            if IsValid(rig_spwn) then
               rig_spwn:SetPos(rig)
               rig_spwn:Spawn()

               ErrorNoHalt("DM WARNING: Map has too few spawn points, using a rigged spawn for ".. tostring(ply) .. "\n")

               self.HaveRiggedSpawn = true
               return rig_spwn
            end
         end
      end
   end

   -- Last attempt, force one
   for k, spwn in pairs(self.SpawnPoints) do
      if self:IsSpawnpointSuitable(ply, spwn, true) then
         return spwn
      end
   end

   return picked
end

function GM:PlayerSetModel(ply)
   local mdl = GAMEMODE.playermodel or "models/player/phoenix.mdl"
   util.PrecacheModel(mdl)
   ply:SetModel(mdl)

   -- Always clear color state, may later be changed in TTTPlayerSetColor
   ply:SetColor(COLOR_WHITE)
end

function GM:CanPlayerSuicide(ply)
   return ply:IsAlive()
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	if GetGameState() == GAME_ACTIVE then
		ply:AddDeaths(1)
		--Drop current weapon
		local wep = ply:GetActiveWeapon()
		if !wep.InDefault then WEPS.DropNotifiedWeapon(ply, wep, true) end
		if ( attacker:IsValid() && attacker:IsPlayer() ) then
			if ( attacker == ply ) then
				attacker:AddFrags( 0 )
			else
				attacker:AddFrags( 1 )
			end
		end
	end
end

function GM:PlayerDeath(victim,weapon,attacker)
	if GetGameState() == GAME_ACTIVE then
		if attacker:IsPlayer() and !(attacker == victim) then
			local tbl_kills = sql.Query([[SELECT kills FROM dm_data_kills WHERE steamid="]]..attacker:SteamID()..[["]])
			if tbl_kills == nil or tbl_kills[1].kills == nil then 
				value = 1
			else
				value = tbl_kills[1].kills+1
			end
			sql.Query( "REPLACE INTO dm_data_kills ( steamid, kills ) VALUES ( " .. SQLStr( attacker:SteamID() ) .. ", " .. SQLStr( value ) .. ")")
			attacker:WS_GivePoints(GetConVar("dm_killreward"):GetInt())
		end
		local tbl_kills = sql.Query("SELECT * FROM dm_data_kills WHERE kills=(SELECT MAX(kills) FROM dm_data_kills)")
		if tbl_kills != nil then
			winner_steamid = tbl_kills[1].steamid
			winner_kills = tbl_kills[1].kills
			if player.GetBySteamID(winner_steamid):Name() != nil then
				SendMVP(player.GetBySteamID(winner_steamid):Name(), winner_kills)
			end
		else
			SendMVP("Nope", "0")
		end
	end
end

hook.Add("KeyPress", "DoubleJump", function(pl, k)
	if !tobool(GetConVar("dm_doublejump"):GetInt()) then return end
	if not pl or not pl:IsValid() or k~=2 then
		return
	end
	if not pl.Jumps or pl:IsOnGround() then
		pl.Jumps=0
	end
	
	if pl.Jumps==2 then return end
	
	pl.Jumps = pl.Jumps + 1
	if pl.Jumps==2 then
		local ang = pl:GetAngles()
		local forward, right = ang:Forward(), ang:Right()
		
		local vel = -1 * pl:GetVelocity() -- Nullify current velocity
		vel = vel + Vector(0, 0, 200) -- Add vertical force
		
		local spd = pl:GetMaxSpeed()
		
		if pl:KeyDown(IN_FORWARD) then
			vel = vel + forward * spd
		elseif pl:KeyDown(IN_BACK) then
			vel = vel - forward * spd
		end
		
		if pl:KeyDown(IN_MOVERIGHT) then
			vel = vel + right * spd
		elseif pl:KeyDown(IN_MOVELEFT) then
			vel = vel - right * spd
		end
		
		pl:SetVelocity(vel)
	end
end)

function GM:ShowHelp(ply)
	if IsValid(ply) then
		ply:ConCommand("dm_helpscreen")
	end
end

function GM:ShowTeam(ply)
	if IsValid(ply) then
		ply:ConCommand("dm_weaponshop")
	end
end

function GM:PlayerSwitchFlashlight(ply, on)
   if not IsValid(ply) then return false end

   -- add the flashlight "effect" here, and then deny the switch
   -- this prevents the sound from playing, fixing the exploit
   -- where weapon sound could be silenced using the flashlight sound
   if (not on) or ply:IsAlive() then
      if on then
         ply:AddEffects(EF_DIMLIGHT)
      else
         ply:RemoveEffects(EF_DIMLIGHT)
      end
   end

   return false
end

function GM:GetFallDamage(ply, speed)
   return 0
end

local fallsounds = {
   Sound("player/damage1.wav"),
   Sound("player/damage2.wav"),
   Sound("player/damage3.wav")
};

function GM:OnPlayerHitGround(ply, in_water, on_floater, speed)
   if in_water or speed < 450 or not IsValid(ply) then return end

   -- Everything over a threshold hurts you, rising exponentially with speed
   local damage = math.pow(0.05 * (speed - 480), 1.75)

   -- I don't know exactly when on_floater is true, but it's probably when
   -- landing on something that is in water.
   if on_floater then damage = damage / 2 end

   -- if we fell on a dude, that hurts (him)
   local ground = ply:GetGroundEntity()
   if IsValid(ground) and ground:IsPlayer() then
      if math.floor(damage) > 0 then
         local att = ply

         -- if the faller was pushed, that person should get attrib
         local push = ply.was_pushed
         if push then
            -- TODO: move push time checking stuff into fn?
            if math.max(push.t or 0, push.hurt or 0) > CurTime() - 4 then
               att = push.att
            end
         end

         local dmg = DamageInfo()

         if att == ply then
            -- hijack physgun damage as a marker of this type of kill
            dmg:SetDamageType(DMG_CRUSH + DMG_PHYSGUN)
         else
            -- if attributing to pusher, show more generic crush msg for now
            dmg:SetDamageType(DMG_CRUSH)
         end

         dmg:SetAttacker(att)
         dmg:SetInflictor(att)
         dmg:SetDamageForce(Vector(0,0,-1))
         dmg:SetDamage(damage)

         ground:TakeDamageInfo(dmg)
      end

      -- our own falling damage is cushioned
      damage = damage / 3
   end

   if math.floor(damage) > 0 then
      local dmg = DamageInfo()
      dmg:SetDamageType(DMG_FALL)
      dmg:SetAttacker(game.GetWorld())
      dmg:SetInflictor(game.GetWorld())
      dmg:SetDamageForce(Vector(0,0,1))
      dmg:SetDamage(damage)

      ply:TakeDamageInfo(dmg)

      -- play CS:S fall sound if we got somewhat significant damage
      if damage > 5 then
         sound.Play(table.Random(fallsounds), ply:GetShootPos(), 55 + math.Clamp(damage, 0, 50), 100)
      end
   end
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
   if dmginfo:IsBulletDamage() and ply:HasEquipmentItem(EQUIP_ARMOR) then
      -- Body armor nets you a damage reduction.
      dmginfo:ScaleDamage(0.7)
   end

   ply.was_headshot = false
   -- actual damage scaling
   if hitgroup == HITGROUP_HEAD then
      -- headshot if it was dealt by a bullet
      ply.was_headshot = dmginfo:IsBulletDamage()

      local wep = util.WeaponFromDamage(dmginfo)

      if IsValid(wep) then
         local s = wep:GetHeadshotMultiplier(ply, dmginfo) or 2
         dmginfo:ScaleDamage(s)
      end
   elseif (hitgroup == HITGROUP_LEFTARM or
           hitgroup == HITGROUP_RIGHTARM or
           hitgroup == HITGROUP_LEFTLEG or
           hitgroup == HITGROUP_RIGHTLEG or
           hitgroup == HITGROUP_GEAR ) then

      dmginfo:ScaleDamage(0.55)
   end

   -- Keep ignite-burn damage etc on old levels
   if (dmginfo:IsDamageType(DMG_DIRECT) or
       dmginfo:IsExplosionDamage() or
       dmginfo:IsDamageType(DMG_FALL) or
       dmginfo:IsDamageType(DMG_PHYSGUN)) then
      dmginfo:ScaleDamage(2)
   end
end