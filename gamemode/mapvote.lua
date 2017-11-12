MapVote = {}
MapVote.Config = {}

--Default Config
MapVoteConfigDefault = {
    MapLimit = 24,
    TimeLimit = 28,
    AllowCurrentMap = false,
    EnableCooldown = false,
    MapsBeforeRevote = 2,
    RTVPlayerCount = 3,
    MapPrefixes = {"dm_","deathmatch","ttt"}
    }
--Default Config

hook.Add( "Initialize", "MapVoteConfigSetup", function()
    if not file.Exists( "dm_data", "DATA") then
        file.CreateDir( "dm_data" )
    end
    if not file.Exists( "dm_data/vote_config.txt", "DATA" ) then
        file.Write( "dm_data/vote_config.txt", util.TableToJSON( MapVoteConfigDefault ) )
    end
end )

function MapVote.HasExtraVotePower(ply)
	-- Example that gives admins more voting power
	--[[
    if ply:IsAdmin() then
		return true
	end 
    ]]

	return false
end


MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3