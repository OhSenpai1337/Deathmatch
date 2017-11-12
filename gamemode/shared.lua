GM.Name = "Deathmatch"
GM.Author = "Oh, Senpai ( ͡° ͜ʖ ͡°)"
GM.Email = ""
GM.Website = "dm.unnamedproject.ru"
GM.Version = "2017-11-05"
WS = {}	

-- Round status consts
GAME_WAIT   = 1
GAME_ACTIVE = 2
GAME_POST   = 3
GAME_OVERTIME = 4

WIN_PLAYER      = 1
WIN_TIMELIMIT   = 2

-- Weapon categories, you can only carry one of each
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_SHOTGUN  = 3
WEAPON_SMG   = 4
WEAPON_ARIFLE  = 5
WEAPON_RIFLE = 6
WEAPON_GRENADE = 7

COLOR_WHITE  = Color(255, 255, 255, 255)
COLOR_BLACK  = Color(0, 0, 0, 255)
COLOR_GREEN  = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED    = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY  = Color(200, 200, 200, 255)
COLOR_BLUE   = Color(0, 0, 255, 255)
COLOR_NAVY   = Color(0, 0, 100, 255)
COLOR_PINK   = Color(255,0,255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE  = Color(100, 100, 0, 255)

include("util.lua")
include("lang_shd.lua") -- uses some of util
include("mapvote.lua")

TEAM_ALIVE = 1
TEAM_SPEC = TEAM_SPECTATOR

function GM:CreateTeams()
   team.SetUp(TEAM_ALIVE, "Players", Color(229, 43, 80, 255), false)
   team.SetUp(TEAM_SPEC, "Spectators", Color(253, 217, 181, 255), true)

   -- Not that we use this, but feels good
   team.SetSpawnPoint(TEAM_ALIVE, "info_player_deathmatch")
   team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Everyone's model
local dm_playermodels = {
   Model("models/player/phoenix.mdl"),
   Model("models/player/arctic.mdl"),
   Model("models/player/guerilla.mdl"),
   Model("models/player/leet.mdl"),
   Model("models/player/combine_soldier.mdl"),
   Model("models/player/combine_soldier_prisonguard.mdl"),
   Model("models/player/gman_high.mdl"),
   Model("models/player/police_fem.mdl"),
   Model("models/player/gasmask.mdl"),
   Model("models/player/police.mdl"),
   Model("models/player/riot.mdl"),
   Model("models/player/urban.mdl"),
   Model("models/player/dod_german.mdl"),
   Model("models/player/dod_american.mdl"),
   Model("models/player/swat.mdl"),
   Model("models/player/barney.mdl"),
   Model("models/player/monk.mdl")
};

function GetRandomPlayerModel()
   return table.Random(dm_playermodels)
end

function WS:ValidateItems(items)
	if type(items) ~= 'table' then return {} end
	
	return items
end
