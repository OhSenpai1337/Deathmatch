--Deathmatch

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("mapvote.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_keys.lua")
AddCSLuaFile("cl_help.lua")
AddCSLuaFile("cl_weaponshop.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_stamina.lua")
AddCSLuaFile("cl_music.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("lang_shd.lua")
AddCSLuaFile("weaponry_shd.lua")
AddCSLuaFile("player_ext_shd.lua")
AddCSLuaFile("vgui/CustomSheet.lua")
AddCSLuaFile("cl_mapvote.lua")
AddCSLuaFile("cl_weaponshop_ext.lua")

include("shared.lua")
include("mapvote.lua")

include("entity.lua")
include("admin.lua")
include("weaponry.lua")
include("player_ext_shd.lua")
include("player_ext.lua")
include("player.lua")
include("sv_mapvote.lua")
include("rtv.lua")
include("player_weaponshop.lua")

--Convars
CreateConVar("dm_timelimit", "15", FCVAR_NOTIFY)
CreateConVar("dm_startpoints", "1500", FCVAR_ARCHIVE)
CreateConVar("dm_killreward", "150", FCVAR_NOTIFY)
CreateConVar("dm_winreward", "1500", FCVAR_NOTIFY)
CreateConVar("dm_votemaptime", "30", FCVAR_NOTIFY)
local dm_maxkills = CreateConVar("dm_maxkills", "150", FCVAR_NOTIFY)
CreateConVar("dm_doublejump", "1", FCVAR_NOTIFY)
CreateConVar("dm_stamina", "1", FCVAR_NOTIFY)
CreateConVar("dm_idle_limit", "90", FCVAR_NOTIFY)
local dm_minply = CreateConVar("dm_minplayers", "4", FCVAR_ARCHIVE + FCVAR_NOTIFY)
CreateConVar("dm_maxstamina", "150", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )
CreateConVar("dm_regenmul", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )
CreateConVar("dm_decaymul", "0.5", FCVAR_REPLICATED + FCVAR_ARCHIVE , "" )
CreateConVar("dm_disablemapvote","0", FCVAR_NOTIFY)
CreateConVar("dm_gameloop","0", FCVAR_NOTIFY)
-- Localise stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local timer = timer
local util = util

resource.AddWorkshop( '1199486971' )
resource.AddWorkshop( '1200056872' )

-- Pool some network names.
util.AddNetworkString("DM_GameState")
util.AddNetworkString("DM_IdleKick")
util.AddNetworkString("DM_ClearClientState")
util.AddNetworkString("DM_PlayerSpawned")
util.AddNetworkString("DM_PlayerDied")
util.AddNetworkString("DM_LangMsg")
util.AddNetworkString("DM_ServerLang")
util.AddNetworkString("DM_StaminaSpawn")
util.AddNetworkString("DM_MVP")
util.AddNetworkString("DM_Music")
util.AddNetworkString("DM_MusicStop")
util.AddNetworkString("DM_RandomMusic")
--Weapon shop
util.AddNetworkString("WS_Points")
util.AddNetworkString("WS_Items")
util.AddNetworkString("WS_SendNotification")
util.AddNetworkString("WS_BuyItem")
util.AddNetworkString("WS_SellItem")
util.AddNetworkString("WS_SendWeaponNotification")
util.AddNetworkString("WS_EquipItem")
util.AddNetworkString("WS_HolsterItem")
util.AddNetworkString("WS_LangNotification")
util.AddNetworkString("WS_LangPNotification")
util.AddNetworkString("WS_GiveItem")
---- Game mechanics
function GM:Initialize()
	MsgN("Deathmatch gamemode initializing...")
	ShowVersion()

	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
	RunConsoleCommand("mp_friendlyfire", "1")

	-- More map config ent defaults
	GAMEMODE.force_plymodel = ""

	GAMEMODE.MapWin = WIN_TIMELIMIT

	GAMEMODE.game_state = GAME_WAIT
	
	GAMEMODE.playermodel = GetRandomPlayerModel()
	GAMEMODE.playercolor = COLOR_WHITE

	-- Delay reading of cvars until config has definitely loaded
	GAMEMODE.cvar_init = false

	SetGlobalFloat("dm_game_end", -1)

	-- For the paranoid
	math.randomseed(os.time())

	WaitForPlayers()

	local cstrike = false
	for _, g in pairs(engine.GetGames()) do
		if g.folder == 'cstrike' then cstrike = true end
	end
	if not cstrike then
		ErrorNoHalt("DM WARNING: CS:S does not appear to be mounted by GMod. Things may break in strange ways. Server admin? Check the DM readme for help.\n")
	end
	
	if !sql.TableExists("dm_data_kills") then
		sql.Query([[CREATE TABLE IF NOT EXISTS dm_data_kills ( 
			steamid TEXT NOT NULL PRIMARY KEY, 
			kills INTEGER
		)]])
	end
	if !sql.TableExists("dm_data_points") then
		sql.Query([[CREATE TABLE IF NOT EXISTS dm_data_points ( 
			steamid TEXT NOT NULL PRIMARY KEY, 
			points INTEGER,
			items TEXT
		)]])
	end
end

-- Used to do this in Initialize, but server cfg has not always run yet by that
-- point.
function GM:InitCvars()
	MsgN("DM initializing convar settings...")

	GAMEMODE:SyncGlobals()

	self.cvar_init = true
end

function GM:InitPostEntity()
	WEPS.ForcePrecache()
end

-- Convar replication is broken in gmod, so we do this.
-- I don't like it any more than you do, dear reader.
function GM:SyncGlobals()
	SetGlobalInt("dm_time_limit_minutes", GetConVar("dm_timelimit"):GetInt())
	SetGlobalInt("dm_idle_limit", GetConVar("dm_idle_limit"):GetInt())
end

function SendGameState(state, ply)
	net.Start("DM_GameState")
		net.WriteUInt(state, 3)
	return ply and net.Send(ply) or net.Broadcast()
end

function SendMVP(name, kills, ply)
	net.Start("DM_MVP")
		net.WriteString(name or "Nope")
		net.WriteString(tostring(kills) or "0")
	return ply and net.Send(ply) or net.Broadcast()
end

-- Game state is encapsulated by set/get so that it can easily be changed to
-- eg. a networked var if this proves more convenient
function SetGameState(state)
	GAMEMODE.game_state = state

	SendGameState(state)
end

function GetGameState()
	return GAMEMODE.game_state
end

local function EnoughPlayers()
	local ready = 0
	-- only count truly available players, ie. no forced specs
	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply) and ply:ShouldSpawn() then
			ready = ready + 1
		end
	end
	return ready >= dm_minply:GetInt()
end

-- Used to be in Think/Tick, now in a timer
function WaitingForPlayersChecker()
	if GetGameState() == GAME_WAIT then
		if EnoughPlayers() then
			timer.Create("begingame", 1, 1, BeginGame)

			timer.Stop("waitingforply")
		end
	end
end

-- Start waiting for players
function WaitForPlayers()
	SetGameState(GAME_WAIT)
	net.Start("DM_MusicStop")
	net.Broadcast()
	net.Start("DM_Music")
		net.WriteString(WaitMusic())
	net.Broadcast()
	for k, v in pairs(player.GetAll()) do
		v:SetFrags(0)
		v:SetDeaths(0)
	end
	sql.Query("DELETE FROM dm_data_kills")
	if not timer.Start("waitingforply") then
		timer.Create("waitingforply", 2, 0, WaitingForPlayersChecker)
	end
end

-- When a player initially spawns after mapload, everything is a bit strange;
-- just making him spectator for some reason does not work right. Therefore,
-- we regularly check for these broken spectators while we wait for players
-- and immediately fix them.
function FixSpectators()
	for k, ply in pairs(player.GetAll()) do
		if ply:IsSpec() and not ply:GetRagdollSpec() and ply:GetMoveType() < MOVETYPE_NOCLIP then
			ply:Spectate(OBS_MODE_ROAMING)
		end
	end
end

local function StopGameTimers()
	-- remove all timers
	timer.Stop("wait2prep")
	timer.Stop("begingame")
	timer.Stop("end2prep")
	timer.Stop("winchecker")
end

-- Used to be in think, now a timer
local function WinChecker()
	if GetGameState() == GAME_ACTIVE then
		local tbl_kills = sql.Query("SELECT * FROM dm_data_kills WHERE kills=(SELECT MAX(kills) FROM dm_data_kills)")
		if tbl_kills != nil then
			winner_steamid = tbl_kills[1].steamid or "BOT"
			winner_kills = tbl_kills[1].kills or 0
			if IsValid(player.GetBySteamID(winner_steamid)) then 
				winner_player = player.GetBySteamID(winner_steamid):Name()
			else
				winner_player = "Nope"
			end
		else
			winner_player = "Nope"
			winner_kills = 0
		end
		if CurTime() > GetGlobalFloat("dm_game_end", 0) then
			EndGame(WIN_TIMELIMIT, winner_player, winner_kills)
		elseif not EnoughPlayers() then
			LANG.Msg("game_cant_continue")
			SetGlobalFloat("dm_game_end", -1)
			WaitForPlayers()
		else
			local win = hook.Call("DMCheckForWin", GAMEMODE)
			if win != WIN_NONE then
				EndGame(win, player.GetBySteamID(winner_steamid):Name(), winner_kills)
			end
		end
	end
end

function StartWinChecks()
	if not timer.Start("winchecker") then
		timer.Create("winchecker", 1, 0, WinChecker)
	end
end

function StopWinChecks()
	timer.Stop("winchecker")
end

function GiveWeapons()
	local weps = {}
	for k, ply in pairs(player.GetAll()) do
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
end

function SpawnWillingPlayers(dead_only)
	local plys = player.GetAll()
	local wave_delay = 1

	-- simple method, should make this a case of the other method once that has
	-- been tested.
	if wave_delay <= 0 or dead_only then
		for k, ply in pairs(player.GetAll()) do
			if IsValid(ply) then
				ply:SpawnForGame(dead_only)
			end
		end
	else
		-- wave method
		local num_spawns = #GetSpawnEnts()

		local to_spawn = {}
		for _, ply in RandomPairs(plys) do
			if IsValid(ply) and ply:ShouldSpawn() then
				table.insert(to_spawn, ply)
				GAMEMODE:PlayerSpawnAsSpectator(ply)
			end
		end

		local sfn = function()
							local c = 0
							-- fill the available spawnpoints with players that need
							-- spawning
							while c < num_spawns and #to_spawn > 0 do
								for k, ply in pairs(to_spawn) do
									if IsValid(ply) and ply:SpawnForGame() then
										-- a spawn ent is now occupied
										c = c + 1
									end
									-- Few possible cases:
									-- 1) player has now been spawned
									-- 2) player should remain spectator after all
									-- 3) player has disconnected
									-- In all cases we don't need to spawn them again.
									table.remove(to_spawn, k)

									-- all spawn ents are occupied, so the rest will have
									-- to wait for next wave
									if c >= num_spawns then
										break
									end
								end
							end

							MsgN("Spawned " .. c .. " players in spawn wave.")

							if #to_spawn == 0 then
								timer.Remove("spawnwave")
								MsgN("Spawn waves ending, all players spawned.")
							end
						end

		MsgN("Spawn waves starting.")
		timer.Create("spawnwave", wave_delay, 0, sfn)

		-- already run one wave, which may stop the timer if everyone is spawned
		-- in one go
		sfn()
	end
end

local function SpawnEntities()
	-- Finally, get players in there
	SpawnWillingPlayers()
end

-- Make sure we have the players to do a round, people can leave during our
-- preparations so we'll call this numerous times
local function CheckForAbort()
	if not EnoughPlayers() then
		LANG.Msg("start_minplayers")
		StopGameTimers()

		WaitForPlayers()
		return true
	end

	return false
end

function SetGameEnd(endtime)
	SetGlobalFloat("dm_game_end", endtime)
end

function IncGameEnd(incr)
	SetGameEnd(GetGlobalFloat("dm_game_end", 0) + incr)
end

local function InitGameEndTime()
	-- Init round values
	local endtime = CurTime() + (GetConVar("dm_timelimit"):GetInt() * 60)
	
	SetGameEnd(endtime)
end

function BeginGame(bool)
	local bool = bool or false
	GAMEMODE:SyncGlobals()

	if CheckForAbort() then return end

	AnnounceVersion()

	InitGameEndTime()

	if CheckForAbort() then return end

	-- Respawn dumb people who died during prep
	SpawnWillingPlayers(true)
	if !bool then
		GiveWeapons()
	end
	SendMVP("Nope", "0")
	game.CleanUpMap()

	if CheckForAbort() then return end

	-- Select traitors & co. This is where things really start so we can't abort
	-- anymore.
	--SelectRoles()
	--SendFullStateUpdate()

	-- Edge case where a player joins just as the round starts and is picked as
	-- traitor, but for whatever reason does not get the traitor state msg. So
	-- re-send after a second just to make sure everyone is getting it.
	--timer.Simple(1, SendFullStateUpdate)
	--timer.Simple(10, SendFullStateUpdate)
	--timer.Simple(2.5, ShowGameStartPopup)

	-- Start the win condition check timer
	StartWinChecks()
	sql.Query("DELETE FROM dm_data_kills")
	for k, v in pairs(player.GetAll()) do
		v:SetFrags(0)
		v:SetDeaths(0)
	end
	GAMEMODE.GameStartTime = CurTime()
	GAMEMODE.playermodel = GAMEMODE.force_plymodel == "" and GetRandomPlayerModel() or GAMEMODE.force_plymodel
	SetGameState(GAME_ACTIVE)
	LANG.Msg("game_started")
	ServerLog("Game proper has begun...\n")
	net.Start("DM_MusicStop")
	net.Broadcast()
	timer.Simple(2, function()
		net.Start("DM_RandomMusic")
		net.Broadcast()
	end)

	--GAMEMODE:UpdatePlayerLoadouts() -- needs to happen when round_active

	hook.Call("DMBeginGame")
end

function PrintResultMessage(type)
	ServerLog("Game ended.\n")
end

function EndGame(type,name,num)
	if name != nil and num != nil then
		if type == WIN_PLAYER then
			LANG.Msg("win_kills",{name = name, num = num})
		elseif type == WIN_TIMELIMIT then
			LANG.Msg("win_time",{name = name, num = num})
		end
	else
		PrintResultMessage(type)
	end
	sql.Query("DELETE FROM dm_data_kills")
	-- first handle round end
	SetGameState(GAME_POST)

	local ptime = math.max(5, GetConVar("dm_votemaptime"):GetInt())

	-- Piggyback on "round end" time global var to show end of phase timer
	SetGlobalFloat("dm_game_end", -1)

	-- Stop checking for wins
	StopWinChecks()

	net.Start("DM_MusicStop")
	net.Broadcast()
	net.Start("DM_Music")
		net.WriteString(EndMusic())
	net.Broadcast()

	-- Votemap Start
	
	MapVote.Start(nil, nil, nil, nil)
	if GetConVar("dm_gameloop"):GetBool() then
		StopGameTimers()
		BeginGame(true)
		MapVote.Cancel()
	end
	if GetConVar("dm_disablemapvote"):GetBool() then
		MapVote.Cancel()
	end

	-- server plugins might want to start a map vote here or something
	-- these hooks are not used by DM internally
	hook.Call("DMEndGame", GAMEMODE, type)
end

function GM:MapTriggeredEnd(wintype)
	self.MapWin = wintype
end

-- The most basic win check is whether both sides have one dude alive
function GM:DMCheckForWin()
	local tbl_kills = sql.Query("SELECT * FROM dm_data_kills WHERE kills=(SELECT MAX(kills) FROM dm_data_kills)")
	if tbl_kills != nil then
		winner_steamid = tbl_kills[1].steamid
		winner_kills = tbl_kills[1].kills
	else
		winner_steamid = 0
		winner_kills = 0
	end
	if (tonumber(winner_kills) >= GetConVar("dm_maxkills"):GetInt()) then
		player.GetBySteamID(winner_steamid):WS_GivePoints(GetConVar("dm_winreward"):GetInt())
		return WIN_PLAYER
	end
	return WIN_NONE
end

local function ForceGameRestart(ply, command, args)
	-- ply is nil on dedicated server console
	if (not IsValid(ply)) or ply:IsAdmin() or ply:IsSuperAdmin() or cvars.Bool("sv_cheats", 0) then
		LANG.Msg("game_restart")

		StopGameTimers()

		-- do prep
		BeginGame(true)
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "You must be a GMod Admin or SuperAdmin on the server to use this command, or sv_cheats must be enabled.")
	end
end
concommand.Add("dm_gamerestart", ForceGameRestart)

-- Version announce also used in Initialize
function ShowVersion(ply)
	local text = Format("This is DM version %s\n", GAMEMODE.Version)
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTNOTIFY, text)
	else
		Msg(text)
	end
end
concommand.Add("dm_version", ShowVersion)

function AnnounceVersion()
	local text = Format("You are playing %s, version %s.\n", GAMEMODE.Name, GAMEMODE.Version)

	-- announce to players
	for k, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTTALK, text)
		end
	end
end

net.Receive("DM_IdleKick", function(len, ply)
	local reason = net.ReadString()
	ply:Kick(reason)
end)
