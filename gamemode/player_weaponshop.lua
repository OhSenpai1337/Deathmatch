local Player = FindMetaTable('Player')

local wep_tbl = {
	[WEAPON_MELEE]  = "weapon_melee",
	[WEAPON_PISTOL] = "weapon_pistol",
	[WEAPON_SHOTGUN]  = "weapon_shotgun",
	[WEAPON_SMG]   = "weapon_smg",
	[WEAPON_ARIFLE]  = "weapon_arifle",
	[WEAPON_RIFLE] = "weapon_rifle",
	[WEAPON_GRENADE] = "weapon_grenade"
}

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

function Player:WS_SendPoints()
	net.Start('WS_Points')
		net.WriteEntity(self)
		net.WriteInt(self.WS_Points, 32)
	net.Broadcast()
end

function Player:WS_SendItems()
	net.Start('WS_Items')
		net.WriteEntity(self)
		net.WriteTable(self.WS_Items)
	net.Broadcast()
end

function WS:GetPlayerData(ply, callback)
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		callback(0,{})
	else
		local points = tbl_points[1].points or 0
		local items = util.JSONToTable(tbl_points[1].items) or {}
		callback(points,WS:ValidateItems(items))
	end
end

function Player:WS_LoadData()
	self.WS_Points = 0
	self.WS_Items = {}

	WS:GetPlayerData(self, function(points, items)
		self.WS_Points = points
		self.WS_Items = items

		self:WS_SendPoints()
		self:WS_SendItems()
	end)
end

function Player:WS_PlayerInitialSpawn()
	self.WS_Points = 0
	self.WS_Items = {}

	-- Send stuff
	timer.Simple(1, function()
		if !IsValid(self) then return end

		self:WS_LoadData()
	end)
end

function WS:SetPlayerPoints(ply, points)
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr("{}").." )")
	else
		local items = tbl_points[1].items
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	end
end

function WS:GivePlayerPoints(ply, points)
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		local points = 0+points
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr("{}").." )")
	else
		local items = tbl_points[1].items
		local points = tbl_points[1].points+points
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	end
end

function WS:TakePlayerPoints(ply, points)
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		local points = 0
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr("{}").." )")
	else
		local items = tbl_points[1].items
		local points = tbl_points[1].points-points
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	end
end

function Player:WS_SetPoints(points)
	self.WS_Points = points
	WS:SetPlayerPoints(self, points)
	self:WS_SendPoints()
end

function Player:WS_GivePoints(points)
	self.WS_Points = self.WS_Points + points
	WS:GivePlayerPoints(self, points)
	self:WS_SendPoints()
end

function Player:WS_TakePoints(points)
	self.WS_Points = self.WS_Points - points >= 0 and self.WS_Points - points or 0
	WS:TakePlayerPoints(self, points)
	self:WS_SendPoints()
end

function Player:WS_HasPoints(points)
	return tonumber(self.WS_Points) >= points
end

function Player:WS_HasItem(weapon_id)
	return self.WS_Items[weapon_id] or false
end

function Player:WS_HasItemEquipped(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end

	return self.WS_Items[weapon_id].Equipped or false
end

function WS:GivePlayerItem(ply, weapon_id, data)
	local tmp = table.Copy(ply.WS_Items)
	tmp[weapon_id] = data
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		local points = 0
		local items = util.TableToJSON(tmp)
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	else
		local points = tbl_points[1].points or 0
		local items = util.TableToJSON(tmp)
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	end
end

function Player:WS_GiveItem(weapon_id)
	self.WS_Items[weapon_id] = { id = weapon_id, Equipped = false }

	WS:GivePlayerItem(self, weapon_id, self.WS_Items[weapon_id])

	self:WS_SendItems()

	return true
end

net.Receive('WS_GiveItem', function(length, ply)
	ply:WS_GiveItem(net.ReadString())
end)

function Player:WS_Notify(...)
	local str = table.concat({...}, '')
	net.Start('WS_SendNotification')
		net.WriteString(str)
	net.Send(self)
end

function Player:WS_LangNotify(lang)
	net.Start('WS_LangNotification')
		net.WriteString(lang)
	net.Send(self)
end

function Player:WS_LangPNotify(lang,weapon_id)
	net.Start('WS_LangPNotification')
		net.WriteString(lang)
		net.WriteString(weapon_id)
	net.Send(self)
end

function Player:WS_NotifyWeapon(weapon_id,price,bool)
	net.Start('WS_SendWeaponNotification')
		net.WriteString(weapon_id)
		net.WriteString(price)
		net.WriteBool(bool)
	net.Send(self)
end

function WS:TakePlayerItem(ply, weapon_id)
	local tmp = table.Copy(ply.WS_Items)
	tmp[weapon_id] = nil
	local tbl_points = sql.Query([[SELECT * FROM dm_data_points WHERE steamid="]]..ply:SteamID()..[["]])
	if tbl_points == nil then
		local points = 0
		local items = util.TableToJSON(tmp)
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
		print(sql.LastError())
	else
		local points = tbl_points[1].points or 0
		local items = util.TableToJSON(tmp)
		sql.Query("REPLACE INTO dm_data_points (steamid,points,items) VALUES ( ".. SQLStr(ply:SteamID()) ..", "..points..", "..SQLStr(items).." )")
	end
end

function Player:WS_TakeItem(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end

	self.WS_Items[weapon_id] = nil

	WS:TakePlayerItem(self, weapon_id)

	self:WS_SendItems()

	return true
end

function Player:WS_BuyItem(weapon_id)
	if weapons.Get(weapon_id).InDefault then return end
	if self:WS_HasItem(weapon_id) then return end
	local points = weapons.Get(weapon_id).Price
	if not self:WS_HasPoints(points) then return false end
	self:WS_TakePoints(points)
	self:WS_NotifyWeapon(weapon_id,points,true)
	self:WS_GiveItem(weapon_id)
end

function Player:WS_SellItem(weapon_id)
	if weapons.Get(weapon_id).InDefault then return end
	if !self:WS_HasItem(weapon_id) then return end
	local price = weapons.Get(weapon_id).Price
	local points = math.Round(price * 0.75)
	self:WS_GivePoints(points)
	self:WS_NotifyWeapon(weapon_id,points,false)
	self:WS_TakeItem(weapon_id)
end

net.Receive('WS_BuyItem', function(length, ply)
	ply:WS_BuyItem(net.ReadString())
end)

net.Receive('WS_SellItem', function(length, ply)
	ply:WS_SellItem(net.ReadString())
end)

function WS:SavePlayerItem(ply, weapon_id, data)
	self:GivePlayerItem(ply, weapon_id, data)
end

function Player:WS_EquipItem(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end
	local kind = weapons.Get(weapon_id).Kind
	for k, v in pairs(self.WS_Items) do
		if v and v.Equipped then
			local wep = weapons.Get(v.id)
			if wep == nil then
				equipped_kind = "none"
			else
				equipped_kind = wep.Kind
			end
			if kind == equipped_kind then
				self:WS_LangNotify("onetype")
				return
			end
		end
	end
	self.WS_Items[weapon_id].Equipped = true
	self:WS_LangPNotify("equipped",weapon_id)
	WS:SavePlayerItem(self, weapon_id, self.WS_Items[weapon_id])
	self:WS_SendItems()
end

function Player:WS_HolsterItem(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end

	self.WS_Items[weapon_id].Equipped = false

	self:WS_LangPNotify("holstered",weapon_id)

	WS:SavePlayerItem(self, weapon_id, self.WS_Items[weapon_id])

	self:WS_SendItems()
	self:WS_LoadData()
end

net.Receive('WS_EquipItem', function(length, ply)
	ply:WS_EquipItem(net.ReadString())
end)

net.Receive('WS_HolsterItem', function(length, ply)
	ply:WS_HolsterItem(net.ReadString())
end)