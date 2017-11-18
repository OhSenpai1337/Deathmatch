CreateConVar("dm_music_enable", "1", FCVAR_ARCHIVE)
CreateConVar("dm_music_volume", "5", FCVAR_ARCHIVE)
function MusicChecker()
	local ply = LocalPlayer()
	timer.Create("MusicChecker",3,0,function()
		if IsValid( ply.channel ) and ply.channel:GetState() == 0 then
			RandomMusic(ply)
			timer.Destroy("MusicChecker")
		end
	end)
end
function RandomMusic()
	local ply = LocalPlayer()
	local vol = GetConVar( "dm_music_volume" ):GetInt()
	if GetConVar( "dm_music_enable" ):GetInt() == 0 then return end
	if GetGameState() != GAME_ACTIVE then return end
	if table.HasValue( map_music_blacklist, game.GetMap() ) then return end
	sound.PlayURL( GetRandomMusic(), "", function( station )
		if station and IsValid( station ) then
			station:Play()
			ply.channel = station
			ply.channel:SetVolume(vol)
			if GetGameState() == GAME_ACTIVE then
				MusicChecker()
			end
		end
	end )
end
function StartMusic(music)
	local ply = LocalPlayer()
	local vol = GetConVar( "dm_music_volume" ):GetInt()
	if GetConVar( "dm_music_enable" ):GetInt() == 0 then return end
	sound.PlayURL( music, "", function( station )
		if station and IsValid( station ) then
			station:Play()
			ply.channel = station
			ply.channel:SetVolume(vol)
		end
	end )
end
function StopMusic()
	local ply = LocalPlayer()
	if ply.channel and IsValid( ply.channel ) then ply.channel:Stop() end
	timer.Destroy("MusicChecker")
end
net.Receive("DM_RandomMusic", function(len)
	RandomMusic()
end)
net.Receive("DM_Music", function(len)
	local ply = LocalPlayer()
	local music = net.ReadString()
	StartMusic(music)
end)
net.Receive("DM_MusicStop", function(len)
	StopMusic()
end)
cvars.AddChangeCallback( "dm_music_enable", function( name, old, new )
	if new == old then return end
	if new == "0" then
		StopMusic()
	else
		RandomMusic()
	end
end)