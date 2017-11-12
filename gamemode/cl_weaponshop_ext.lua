local Player = FindMetaTable('Player')
local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
net.Receive('WS_Items', function(length)
	local ply = net.ReadEntity()
	local items = net.ReadTable()
	ply.WS_Items = items
end)

net.Receive('WS_Points', function(length)
	local ply = net.ReadEntity()
	local points = net.ReadInt(32)
	ply.WS_Points = points
end)

function Player:WS_GiveItem(weapon_id)
	if self:WS_HasItem(weapon_id) then return false end
	
	net.Start('WS_GiveItem')
		net.WriteString(weapon_id)
	net.SendToServer()
end

function Player:WS_GetItems()
	return self.WS_Items or {}
end

function Player:WS_GetPoints()
	return self.WS_Points or 0
end

function Player:WS_HasPoints(points)
	return self:WS_GetPoints() >= points
end

function Player:WS_HasItem(weapon_id)
	return self.WS_Items[weapon_id] and true or false
end

function Player:WS_GiveItem(weapon_id)
	if self:WS_HasItem(weapon_id) then return false end
	
	net.Start('WS_GiveItem')
		net.WriteString(weapon_id)
	net.SendToServer()
end

function Player:WS_HasItemEquipped(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end
	
	return self.WS_Items[weapon_id].Equipped or false
end

net.Receive('WS_SendNotification', function(length)
	local str = net.ReadString()
	notification.AddLegacy(str, NOTIFY_GENERIC, 5)
end)

net.Receive('WS_LangNotification', function(length)
	local str = net.ReadString()
	local message = GetTranslation(str)
	notification.AddLegacy(message, NOTIFY_GENERIC, 5)
end)

net.Receive('WS_LangPNotification', function(length)
	local str = net.ReadString()
	local weapon_id = net.ReadString()
	local message = GetPTranslation(str,{name = weapons.Get(weapon_id).PrintName})
	notification.AddLegacy(message, NOTIFY_GENERIC, 5)
end)

net.Receive('WS_SendWeaponNotification', function(length)
	local weapon_id = net.ReadString()
	local price = net.ReadString()
	local bool = net.ReadBool()
	if bool then
		msg = "bought"
	else
		msg = "sold"
	end
	local message = GetPTranslation(msg, {name = weapons.Get(weapon_id).PrintName, price = price})
	notification.AddLegacy(message, NOTIFY_GENERIC, 5)
end)

function Player:WS_BuyItem(weapon_id)
	if not self:WS_HasPoints(weapons.Get(weapon_id).Price) then return false end
	
	net.Start('WS_BuyItem')
		net.WriteString(weapon_id)
	net.SendToServer()
end

function Player:WS_SellItem(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end
	
	net.Start('WS_SellItem')
		net.WriteString(weapon_id)
	net.SendToServer()
end

function Player:WS_EquipItem(weapon_id)
	if weapons.Get(weapon_id).InDefault then self:WS_GiveItem(weapon_id) end
	timer.Simple(0.1, function()
		if not self:WS_HasItem(weapon_id) then return false end
		
		net.Start('WS_EquipItem')
			net.WriteString(weapon_id)
		net.SendToServer()
	end)
end

function Player:WS_HolsterItem(weapon_id)
	if not self:WS_HasItem(weapon_id) then return false end
	
	net.Start('WS_HolsterItem')
		net.WriteString(weapon_id)
	net.SendToServer()
end