RTV = RTV or {}

RTV.ChatCommands = {
	
	"!rtv",
	"/rtv",
	"rtv",
	"!кем",
	"кем",
	"/кем"

}

RTV.TotalVotes = 0

RTV.Wait = 60 -- The wait time in seconds. This is how long a player has to wait before voting when the map changes. 

RTV._ActualWait = CurTime() + RTV.Wait

RTV.PlayerCount = MapVote.Config.RTVPlayerCount or 3

function RTV.ShouldChange()
	return RTV.TotalVotes >= math.Round(#player.GetAll()*0.66)
end

function RTV.RemoveVote()
	RTV.TotalVotes = math.Clamp( RTV.TotalVotes - 1, 0, math.huge )
end

function RTV.Start()
	net.Start("RTV_Delay")
	net.Broadcast()

	hook.Add("DMEndGame", "MapvoteDelayed", function()
		MapVote.Start(nil, nil, nil, nil)
	end)
end


function RTV.AddVote( ply )

	if RTV.CanVote( ply ) then
		RTV.TotalVotes = RTV.TotalVotes + 1
		ply.RTVoted = true
		LANG.Msg("rtvoted_total",{name = ply:Name(), current = RTV.TotalVotes, total = math.Round(#player.GetAll()*0.66)})
		if RTV.ShouldChange() then
			RTV.Start()
		end
	end

end

hook.Add( "PlayerDisconnected", "Remove RTV", function( ply )

	if ply.RTVoted then
		RTV.RemoveVote()
	end

	timer.Simple( 0.1, function()

		if RTV.ShouldChange() then
			RTV.Start()
		end

	end )

end )

function RTV.CanVote( ply )
	local plyCount = table.Count(player.GetAll())
	
	if RTV._ActualWait >= CurTime() then
		return false, "wait_rtv"
	end

	if GetGlobalBool( "In_Voting" ) then
		return false, "progress_rtv"
	end

	if ply.RTVoted then
		return false, "already_rtv"
	end

	if RTV.ChangingMaps then
		return false, "change_rtv"
	end
	if plyCount < RTV.PlayerCount then
        return false, "players_rtv"
    end

	return true

end

function RTV.StartVote( ply )

	local can, err = RTV.CanVote(ply)

	if not can then
		LANG.Msg(ply, err)
		return
	end

	RTV.AddVote( ply )

end

concommand.Add( "rtv_start", RTV.StartVote )

hook.Add( "PlayerSay", "RTV Chat Commands", function( ply, text )

	if table.HasValue( RTV.ChatCommands, string.lower(text) ) then
		if GetConVar("dm_gameloop"):GetBool() then
			LANG.Msg(ply, "game_loop")
			return
		end
		if GetConVar("dm_disablemapvote"):GetBool() then return end		
		RTV.StartVote( ply )
		return ""
	end

end )