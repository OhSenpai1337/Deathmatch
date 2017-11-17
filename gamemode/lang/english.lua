--English language strings

local l = LANG.CreateLanguage("English")

--General text used in various places
l.players          = "Players"
l.spectators       = "Spectators"

--Game
l.start_minplayers = "Not enough players to start a game..."
l.game_started     = "The game has begun!"
l.game_restart     = "The game has been forced to restart by an admin."
l.game_end         = "Game end in {time}"
l.game_cant_continue = "Not enough players to continue a game..."

--Win
l.win_time         = "Time has run out. The {name} with the {num} of kills won."
l.win_kills        = "The {name} has achieved {num} kills and he wins the game."

--Votemap
l.votemap_start    = "Voting for map started."
l.votemap_map      = "The map changes to {map}."

--Death messages
l.player_kill      = "The {name} kills a {victim} from a weapon {weapon}."
l.player_world     = "The {name} died of the world."
l.player_explode   = "The {victim} was blown up by the {name}."
l.player_exploded  = "The {name} exploded."
l.player_stabbed   = "The {victim} was stabbed by {name}."

--Equipment menu
l.equip_title      = "Equipment"
l.equip_name       = "Name"
l.equip_type  	   = "Type"
l.equip_desc       = "Description"
l.equip_confirm    = "Buy equipment"
l.equip_lacks      = "Not enough points to buy."

--Weapon types
l.item_pistol      = "Pistol"
l.item_smg         = "SMG"
l.item_rifle       = "Rifle"
l.item_arifle      = "Assault rifle"
l.item_crowbar     = "Crowbar"
l.item_shotgun     = "Shotgun"
l.item_grenade     = "Grenade"
l.item_sword       = "Sword"
l.item_knife       = "Knife"

--Spectate menu
l.spectate_menu    = "Spectate menu"
l.choose_player    = "Player selection"

--Menus and windows
l.close            = "Close"
l.cancel           = "Cancel"

--For navigation buttons
l.next             = "Next"
l.prev             = "Previous"

--Scoreboard
l.sb_playing       = "You are playing on..."

l.sb_nick          = "Nick"
l.sb_kills         = "Kills"
l.sb_deaths        = "Deaths"
l.sb_ping     	   = "Ping"

--Settings menu (F1)
l.settings_title   = "Settings"
l.settings_tip 	   = "Client-side settings"

l.set_title_gui    = "Interface settings"

l.set_cross_opacity   = "Ironsight crosshair opacity"
l.set_cross_disable   = "Disable crosshair completely"
l.set_cross_brightness = "Crosshair brightness"
l.set_cross_size      = "Crosshair size"
l.set_lowsights       = "Lower weapon when using ironsights"
l.set_lowsights_tip   = "Enable to position the weapon model lower on the screen while using ironsights. This will make it easier to see your target, but it will look less realistic."
l.set_fastsw          = "Fast weapon switch"
l.set_fastsw_tip      = "Enable to cycle through weapons without having to click again to use weapon. Enable show menu to show switcher menu."
l.set_fastsw_menu     = "Enable menu with fast weapon switch"
l.set_fastswmenu_tip  = "When fast weapons switch is enabled, the menu switcher menu will popup."
l.set_wswitch         = "Disable weapon switch menu auto-closing"
l.set_wswitch_tip     = "By default the weapon switcher automatically closes a few seconds after you last scroll. Enable this to make it stay up."

l.set_title_play      = "Gameplay settings"

l.set_specmode        = "Spectate-only mode (always stay spectator)"
l.set_specmode_tip    = "Spectate-only mode will prevent you from respawning when a new round starts, instead you stay Spectator."

l.set_title_lang      = "Language settings"

l.set_lang            = "Select language:"

--Round status
l.game_wait          = "Waiting"
l.game_active        = "In progress"
l.game_post          = "Game over"
l.game_overtime      = "Overtime"

--idle
l.idle_popup          = [[You were idle for {num} seconds and were kicked from the server!]]

l.idle_warning        = "Warning: you appear to be idle/AFK, and server can kick you!"

l.idle_message        = "(AUTOMATED MESSAGE) I have been kicked from the server."

--Hud
l.kills               = "kills"
l.you_are_dead        = "You're dead!"
l.press_any_button    = "Press any key to restart"
l.energy              = "Energy"
l.top                 = "TOP"

--Chat
l.ply_connected       = "Player {name} connected to server."
l.ply_disconnected    = "Player {name} ({sid}) disconnected from server."

--Guns
l.drop_no_room        = "You have no room here to drop your weapon!"

--Votemap
l.seconds             = "seconds"
l.rtvoted             = "{name} has voted to Rock the Vote."
l.rtvoted_total       = "{name} has voted to Rock the Vote. ({current}/{total})"
l.wait_rtv            = "You must wait a bit before voting!"
l.progress_rtv        = "There is currently a vote in progress!"
l.already_rtv         = "You have already voted to Rock the Vote!"
l.change_rtv          = "There has already been a vote, the map is going to change!"
l.players_rtv         = "You need more players before you can rock the vote!"
l.start_rtv           = "The vote has been rocked!"
l.game_loop           = "Map in game loop"

--Weapon Shop
l.weapon_shop         = "Weapon shop"
l.points              = "Points"
l.buy                 = "Buy!"
l.equip               = "Equip"
l.sell                = "Sell"
l.holster             = "Holster"
l.melee               = "Melee"
l.pistols             = "Pistols"
l.arifles             = "Assault rifles"
l.rifles              = "Rifles"
l.smg                 = "SMG"
l.shotguns            = "Shotguns"
l.grenades            = "Grenades"
l.name                = "Name"
l.clipsize            = "Clipsize"
l.slot                = "Slot"
l.price               = "Price"
l.default             = "Default"
l.bought              = "Bought {name} for {price} points!"
l.sold                = "Sold {name} for {price} points!"
l.info                = "Information"
l.donthave            = "You dont have this gun!"
l.onetype             = "Only one type of weapon can be worn"
l.opt                 = "Options"
l.equipped            = "Equipped {name}."
l.holstered           = "Holstered {name}."
l.damage              = "Damage"
l.purchase            = "Purchase"
l.sale                = "Sale"
l.areusurepurchase    = "Are you sure you want to buy"
l.areusuresale        = "Are you sure you want to sell"
l.yes                 = "Yes"
l.no                  = "No"