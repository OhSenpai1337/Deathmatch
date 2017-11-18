include("shared.lua")

-- Define GM12 fonts for compatibility
surface.CreateFont("DefaultBold", {font = "Tahoma",
                                   size = 13,
                                   weight = 1000})
surface.CreateFont("TabLarge",    {font = "Tahoma",
                                   size = 13,
                                   weight = 700,
                                   shadow = true, antialias = false})
surface.CreateFont("Trebuchet22", {font = "Trebuchet MS",
                                   size = 22,
                                   weight = 900})

surface.CreateFont( "TextFont", {
	font = "DermaLarge",
	size = 16,
	weight = 1200,
	antialias = true,
	extended = true
} )

surface.CreateFont( "LargeTitle", {
	font = "Roboto",
	size = 32, weight = 500, antialias = true, extended = true
})

surface.CreateFont( "SmallTitle", {
	font = "Roboto",
	size = 20, weight = 500, antialias = true, extended = true
})

include("player_ext_shd.lua")
include("weaponry_shd.lua")

include("vgui/CustomSheet.lua")

include("cl_hud.lua")
include("cl_keys.lua")
include("cl_help.lua")
include("cl_mapvote.lua")
include("cl_stamina.lua")
include("cl_weaponshop.lua")
include("cl_weaponshop_ext.lua")
include("cl_scoreboard.lua")
include("cl_music.lua")

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

function GM:Initialize()
   MsgN("DM Client initializing...")

   GAMEMODE.game_state = GAME_WAIT

   LANG.Init()

   self.BaseClass:Initialize()
end

function GM:InitPostEntity()
   MsgN("DM Client post-init...")

   if not game.SinglePlayer() then
      timer.Create("idlecheck", 5, 0, CheckIdle)
   end

   -- make sure player class extensions are loaded up, and then do some
   -- initialization on them
   if IsValid(LocalPlayer()) and LocalPlayer().GetAlive then
      GAMEMODE:ClearClientState()
   end

   RunConsoleCommand("_dm_request_serverlang")
end

function GetGameState() return GAMEMODE.game_state end

local function GameStateChange(o, n)
   if n == GAME_WAIT then
      -- prep starts
      GAMEMODE:ClearClientState()
      GAMEMODE:CleanUpMap()

      -- reset cached server language in case it has changed
      RunConsoleCommand("_dm_request_serverlang")
   elseif n == GAME_ACTIVE then
      -- game starts

      -- clear blood decals produced during prep
      RunConsoleCommand("r_cleardecals")

      GAMEMODE.StartingPlayers = #util.GetAlivePlayers()
   end

   -- stricter checks when we're talking about hooks, because this function may
   -- be called with for example o = WAIT and n = POST, for newly connecting
   -- players, which hooking code may not expect
   if n == GAME_WAIT then
      -- can enter PREP from any phase due to ttt_gamerestart
      hook.Call("DMWaitGame", GAMEMODE)
   elseif (o == GAME_WAIT) and (n == GAME_ACTIVE) then
      hook.Call("DMBeginGame", GAMEMODE)
   elseif (o == GAME_ACTIVE) and (n == GAME_POST) then
      hook.Call("DMEndGame", GAMEMODE)
   end
end

concommand.Add("dm_print_playercount", function() print(GAMEMODE.StartingPlayers) end)

-- Game state comm
local function ReceiveGameState()
   local o = GetGameState()
   GAMEMODE.game_state = net.ReadUInt(3)

   if o != GAMEMODE.game_state then
      GameStateChange(o, GAMEMODE.game_state)
   end

   --MsgN("Game state: " .. GAMEMODE.game_state)
end
net.Receive("DM_GameState", ReceiveGameState)
MVP_Name = "Nope"
MVP_Kills = "0"
-- MVP
local function ReceiveMVP()
	local name = net.ReadString()
	local kills = net.ReadString()
	MVP_Name = name or "Nope"
	MVP_Kills = kills or "0"
end
net.Receive("DM_MVP", ReceiveMVP)

-- Cleanup at start of new game
function GM:ClearClientState()

   local client = LocalPlayer()
   if not client.SetRole then return end -- code not loaded yet

   client:SetRole(ROLE_ALIVE)

   client.equipment_items = EQUIP_NONE
   client.bought = {}
   client.last_id = nil

   for _, p in pairs(player.GetAll()) do
      if IsValid(p) then
         p.sb_tag = nil
         p:SetRole(ROLE_ALIVE)
         p.search_result = nil
      end
   end

   if GAMEMODE.ForcedMouse then
      gui.EnableScreenClicker(false)
   end
end
net.Receive("DM_ClearClientState", GM.ClearClientState)

function GM:CleanUpMap()
   game.CleanUpMap()
end

-- server tells us to call this when our LocalPlayer has spawned
local function PlayerSpawn()
end
net.Receive("DM_PlayerSpawned", PlayerSpawn)

local function PlayerDeath(victim, wep, attacker)
	
end
net.Receive("DM_PlayerDied", PlayerDeath)

function GM:ShouldDrawLocalPlayer(ply) return false end

function GM:Tick()
	local client = LocalPlayer()
	if IsValid(client) then
		if client:Alive() and client:Team() != TEAM_SPEC then
		end
	end
end

-- Simple client-based idle checking
local idle = {ang = nil, pos = nil, mx = 0, my = 0, t = 0}
function CheckIdle()
   local client = LocalPlayer()
   if not IsValid(client) then return end

   if not idle.ang or not idle.pos then
      -- init things
      idle.ang = client:GetAngles()
      idle.pos = client:GetPos()
      idle.mx = gui.MouseX()
      idle.my = gui.MouseY()
      idle.t = CurTime()

      return
   end

	if GetGameState() == GAME_ACTIVE and client:IsAlive() and client:Alive() then
		local idle_limit = GetGlobalInt("dm_idle_limit", 90) or 90
		if idle_limit <= 0 then idle_limit = 90 end -- networking sucks sometimes


		if client:GetAngles() != idle.ang then
			-- Normal players will move their viewing angles all the time
			idle.ang = client:GetAngles()
			idle.t = CurTime()
		elseif gui.MouseX() != idle.mx or gui.MouseY() != idle.my then
			-- Players in eg. the Help will move their mouse occasionally
			idle.mx = gui.MouseX()
			idle.my = gui.MouseY()
			idle.t = CurTime()
		elseif client:GetPos():Distance(idle.pos) > 10 then
			-- Even if players don't move their mouse, they might still walk
			idle.pos = client:GetPos()
			idle.t = CurTime()
		elseif CurTime() > (idle.t + idle_limit) then
			RunConsoleCommand("say", GetTranslation("idle_message"))
			net.Start("DM_IdleKick")
				net.WriteString(GetPTranslation("idle_popup", {num = tostring(idle_limit)}))
			net.SendToServer()
		elseif CurTime() > (idle.t + (idle_limit / 2)) then
			-- will repeat
			LANG.Msg("idle_warning")
		end
	end
end