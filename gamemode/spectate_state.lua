local function force_spectate(ply, cmd, arg)
	if IsValid(ply) then
		if #arg == 1 and tonumber(arg[1]) == 0 then
			ply:SetForceSpec(false)
			ply:SetTeam(TEAM_ALIVE)
		else
			if not ply:IsSpec() then
				ply:Kill()
			end

			GAMEMODE:PlayerSpawnAsSpectator(ply)
			ply:SetTeam(TEAM_SPEC)
			ply:SetForceSpec(true)
			ply:Spawn()

			ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here
		end
	end
end
concommand.Add("dm_spectate", force_spectate)
net.Receive("DM_Spectate", function(l, pl)
	force_spectate(pl, nil, { net.ReadBool() and 1 or 0 })
end)

