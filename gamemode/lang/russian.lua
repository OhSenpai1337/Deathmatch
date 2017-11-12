--Russian language strings

local l = LANG.CreateLanguage("Русский")

--General text used in various places
l.players          = "Игроки"
l.spectators       = "Наблюдатели"

--Game
l.start_minplayers = "Недостаточно игроков для начала игры..."
l.game_started     = "Игра началась!"
l.game_restart     = "Игра была перезапущена админом."
l.game_end         = "Игра заканчивает через {time}"
l.game_cant_continue = "Недостаточно игроков для продолжения игры..."

--Win
l.win_time         = "Время закончилось. Игрок {name} с количеством {num} убийств выиграл."
l.win_kills        = "Игрок {name} достиг {num} убийств и выиграл игру."

--Votemap
l.votemap_start    = "Голосование за карту началось."
l.votemap_map      = "Карта меняется на {map}."

--Death messages
l.player_kill      = "Игрок {name} убивает {victim} с {weapon}."
l.player_world     = "Игрок {name} умирает от мира."
l.player_explode   = "Игрок {name} взорвал {victim}."
l.player_exploded  = "Игрок {name} взорвался."
l.player_stabbed   = "Игрок {name} зарезал {victim}."

--Equipment menu
l.equip_title      = "Снаряжение"
l.equip_name       = "Название"
l.equip_type  	   = "Тип"
l.equip_desc       = "Описание"
l.equip_confirm    = "Купить"
l.equip_lacks      = "Недостаточно поинтов для покупки."

--Weapon types
l.item_pistol      = "Пистолет"
l.item_smg         = "SMG"
l.item_rifle       = "Винтовка"
l.item_arifle      = "Штурмовая винтовка"
l.item_crowbar     = "Лом"
l.item_shotgun     = "Дробовик"
l.item_grenade     = "Граната"
l.item_sword       = "Меч"
l.item_knife       = "Нож"

--Spectate menu
l.spectate_menu    = "Меню наблюдения"
l.choose_player    = "Выбор игрока"

--Menus and windows
l.close            = "Закрыть"
l.cancel           = "Отмена"

--For navigation buttons
l.next             = "Дальше"
l.prev             = "Назад"

--Scoreboard
l.sb_playing       = "Вы играете на..."

l.sb_nick          = "Ник"
l.sb_kills         = "Убийства"
l.sb_deaths        = "Смерти"
l.sb_ping     	   = "Пинг"

--Settings menu (F1)
l.settings_title   = "Настройки"
l.settings_tip 	   = "Клиенсткие настройки"

l.set_title_gui    = "Настройки интерфейса"

l.set_cross_opacity   = "Положение прицела на экране"
l.set_cross_disable   = "Выключить прицел"
l.set_cross_brightness = "Яркость прицела"
l.set_cross_size      = "Размер прицела"
l.set_lowsights       = "Опустить оружие во время прицеливания"
l.set_lowsights_tip   = "Опустить оружие во время прицеливания. Это делает прицеливание более легким, но менее реалистичным."
l.set_fastsw          = "Быстрое переключение оружия"
l.set_fastsw_tip      = "Выключить меню оружие, что позволяет вам мгновенно переключаться между оружием."
l.set_fastsw_menu     = "Enable menu with fast weapon switch"
l.set_fastswmenu_tip  = "When fast weapons switch is enabled, the menu switcher menu will popup."
l.set_wswitch         = "Выключить автоматическое закрытие меню выбора оружия"
l.set_wswitch_tip     = "Отключает авто-закрытие меню оружия."

l.set_title_play      = "Настройки геймплея"

l.set_specmode        = "Режим наблюдения (всегда быть наблюдателем)"
l.set_specmode_tip    = "Режим наблюдения не позволит вам возрождаться в раундах, пока вы его не выключите."

l.set_title_lang      = "Настройки локализации"

l.set_lang            = "Выберите язык:"

--Round status
l.game_wait          = "Ожидание"
l.game_active        = "В процессе"
l.game_post          = "Игра окончена"
l.game_overtime      = "ДОП.ВРЕМЯ"

--Idle
l.idle_popup          = [[Вы не двигались в течении {num} секунд и были кикнуты с сервера.]]

l.idle_warning        = "Внимание: Возможно вы АФК. Если вы не покажете свою активность вы будете кикнуты с сервера!"

l.idle_message        = "(Автоматическое сообщение) Я был кикнут с сервера."

--Hud
l.kills               = "убийств"
l.you_are_dead        = "Вы мертвы!"
l.press_any_button    = "Нажмите любую кнопку для продолжения"
l.energy              = "Энергия"
l.top                 = "ТОП"

--Guns
l.drop_no_room        = "Нет места чтобы выбросить оружие"

--Votemap
l.seconds             = "секунд"
l.rtvoted             = "{name} проголосовал за смену карты."
l.rtvoted_total       = "{name} проголосовал за смену карты. ({current}/{total})"
l.wait_rtv            = "Вы должны подождать перед голосованием!"
l.progress_rtv        = "Голосование уже в процессе!"
l.already_rtv         = "Вы уже проголосовали за смену карты!"
l.change_rtv          = "Голосование уже прошло, идет смена карты!"
l.players_rtv         = "Нужно больше игроков для голосования!"
l.start_rtv           = "Голосование за смену карты успешно!"

--Weapon Shop
l.weapon_shop         = "Магазин оружия"
l.points              = "Поинтов"
l.buy                 = "Купить!"
l.equip               = "Надеть"
l.sell                = "Продать"
l.holster             = "Снять"
l.melee               = "Рукопашное"
l.pistols             = "Пистолеты"
l.arifles             = "Штурмовые винтовки"
l.rifles              = "Винтовки"
l.smg                 = "СМГ"
l.shotguns            = "Дробовики"
l.grenades            = "Гранаты"
l.name                = "Название"
l.clipsize            = "Размер обоймы"
l.slot                = "Слот"
l.price               = "Цена"
l.default             = "Стандарт"
l.bought              = "Вы купили {name} за {price} поинтов!"
l.sold                = "Вы продали {name} за {price} поинтов!"
l.info                = "Информация"
l.donthave            = "У вас нет этого оружия!"
l.onetype             = "Только один тип оружия может быть надет"
l.opt                 = "Опции"
l.equipped            = "Надето {name}."
l.holstered           = "Снято {name}."
l.damage              = "Урон"