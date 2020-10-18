ESX = nil
local shopcoords = {x = 0, y = 0, z = 0}
local weaponshopcoords = {x = 0, y = 0, z = 0}
local infobuycoords = {x = -579.95, y = -1612.78, z = 27.01}
local isshopopen = false
local isshopopen2 = false
local hasbeenlooted = false
local doingloot = false
local mafiashopaccess = {
  'steam:110000103355131',     -- SANDY
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function rollshop()
	local rdm = math.random(1,10)
	if rdm == 1 then
		shopcoords = {x = 2330.41, y = 2570.89, z = 46.68}
		weaponshopcoords = {x = -1600.61, y = 5204.71, z = 4.31}
	elseif rdm == 2 then
		shopcoords = {x = 980.23, y = -1705.80, z = 31.11}
		weaponshopcoords = {x = 173.99, y = 2778.55, z = 46.07}
	elseif rdm == 3 then
		shopcoords = {x = -674.14, y = -999.68, z = 18.24}
		weaponshopcoords = {x = -2.29, y = -1822.06, z = 29.54}
	elseif rdm == 4 then
		shopcoords = {x = -621.85, y = 311.46, z = 83.92}
		weaponshopcoords = {x = -1165.06, y = -2022.90, z = 13.16}
	elseif rdm == 5 then
		shopcoords = {x = -217.34, y = 6367.20, z = 31.49}
		weaponshopcoords = {x = 3725.24, y = 4525.10, z = 22.47}
	elseif rdm == 6 then
		shopcoords = {x = -1165.06, y = -2022.90, z = 13.16}
		weaponshopcoords = {x = -217.34, y = 6367.20, z = 31.49}
	elseif rdm == 7 then
		shopcoords = {x = -2.29, y = -1822.06, z = 29.54}
		weaponshopcoords = {x = -621.85, y = 311.46, z = 83.92}
	elseif rdm == 8 then
		shopcoords = {x = 173.99, y = 2778.55, z = 46.07}
		weaponshopcoords = {x = -674.14, y = -999.68, z = 18.24}
	elseif rdm == 9 then
		shopcoords = {x = -1600.61, y = 5204.71, z = 4.31}
		weaponshopcoords = {x = 980.23, y = -1705.80, z = 31.11}
	elseif rdm == 10 then
		shopcoords = {x = -1486.29, y = -909.54, z = 10.02}
		weaponshopcoords = {x = 2330.41, y = 2570.89, z = 46.68}
	end
end

rollshop()

RegisterServerEvent('sandy_blackshop:refreshshop')
AddEventHandler('sandy_blackshop:refreshshop', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
  	local identifier = xPlayer.getIdentifier()
	if identifier then
    	for i=0, #mafiashopaccess do
    		if tostring(identifier) == tostring(mafiashopaccess[i]) then
    			access = true
    		else
    			access = false
    		end
    	end
    end
	TriggerClientEvent('sandy_blackshop:setplayerblackshop', _source, shopcoords, weaponshopcoords, infobuycoords, access)
end)

ESX.RegisterServerCallback('sandy_blackshop:getshopstatus', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local data = isshopopen
  cb(data)
end)

RegisterServerEvent('sandy_blackshop:setshopstatus')
AddEventHandler('sandy_blackshop:setshopstatus', function(type)
  if type == 'true' then
    isshopopen2 = true
  elseif type == 'false' then
    isshopopen2 = false
  end
end)

ESX.RegisterServerCallback('sandy_blackshop:getshopstatus2', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local data = isshopopen2
  cb(data)
end)

RegisterServerEvent('sandy_blackshop:setshopstatus2')
AddEventHandler('sandy_blackshop:setshopstatus2', function(type)
  if type == 'true' then
    isshopopen2 = true
  elseif type == 'false' then
    isshopopen2 = false
  end
end)

RegisterServerEvent('sandy_blackshop:buyinfo')
AddEventHandler('sandy_blackshop:buyinfo', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local price = 5000
	if account >= price then
		xPlayer.removeMoney(price)
		TriggerClientEvent('esx:showNotification', _source, 'Dostales info; wpisujesz dane do GPS...')
		TriggerClientEvent('sandy_blackshop:setdestination', _source, false)
	else
		TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
	end
end)

RegisterServerEvent('sandy_blackshop:buyinfoweapons')
AddEventHandler('sandy_blackshop:buyinfoweapons', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local price = 5000
	if account >= price then
		xPlayer.removeMoney(price)
		TriggerClientEvent('esx:showNotification', _source, 'Dostales info; wpisujesz dane do GPS...')
		TriggerClientEvent('sandy_blackshop:setdestinationweapons', _source, false)
	else
		TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
	end
end)

RegisterServerEvent('sandy_blackshop:purchaseitem')
AddEventHandler('sandy_blackshop:purchaseitem', function(item, price)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local itemdata = getitemname(item)
	local itemname = itemdata.label
	local sourceItemlimit = xPlayer.getInventoryItem(item)
	if isitemWhitelisted(item) then
		if sourceItemlimit.limit ~= -1 and (sourceItemlimit.count + 1) > sourceItemlimit.limit then
			TriggerClientEvent('esx:showNotification', _source, 'Nie mozesz uniesc tyle ~y~'..itemname..'')
		else
			if account >= price then
				xPlayer.removeMoney(price)
				xPlayer.addInventoryItem(item, 1)
				local itemnewcount = sourceItemlimit.count + 1
				TriggerClientEvent('esx:showNotification', _source, 'Kupiles ~y~'..itemname..'~w~ za ~r~'..price..'~w~$ Posiadasz ~g~'..itemnewcount..'~w~ z ~r~'..sourceItemlimit.limit..'')
				TriggerEvent("logi:blackshopitem", xPlayer.identifier, _source, xPlayer.name, item)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz ~r~'.. price ..'$ pieniędzy!')
			end
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "BLOCKEDWEAPON")
	end
end)

RegisterServerEvent('sandy_blackshop:purchaseweapon')
AddEventHandler('sandy_blackshop:purchaseweapon', function(item, price)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local itemdata = getitemname(item)
	local itemname = itemdata.label
	if isitemWhitelisted(item) then
		if account >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, 1)
			xPlayer.addInventoryItem('pistol_ammo', 100)
			TriggerClientEvent('esx:showNotification', _source, 'Kupiles ~y~'..itemname..'~w~ za ~r~'..price..'~w~$')
			TriggerEvent("logs:blackshopweapon", xPlayer.identifier, _source, xPlayer.name, item)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz ~r~'.. price ..'$ pieniędzy!')
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "BLOCKEDWEAPON")
	end
end)

function getitemname(item)
	local result = MySQL.Sync.fetchAll("SELECT * FROM items WHERE name = @name", 
		{
			['@name'] = item
		}
	)
	if result[1] ~= nil then
		local itemname = result[1]

		return {
			item = itemname['item'],
			label = itemname['label']
		}
	else
		return nil
	end
end

RegisterServerEvent('sandy_blackshop:purchaseweaponmafia')
AddEventHandler('sandy_blackshop:purchaseweaponmafia', function(item, price)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local itemdata = getitemname(item)
	local itemname = itemdata.label
	if isitemWhitelisted(item) then
		if account >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, 1)
			TriggerClientEvent('esx:showNotification', _source, 'Kupiles ~y~'..itemname..'~w~ za ~r~'..price..'~w~$')
			TriggerEvent("logi:blackshopweapon", _source, xPlayer.identifier, xPlayer.name, item)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz ~r~'.. price ..'$ pieniędzy!')
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "BLOCKEDWEAPON")
	end
end)

ESX.RegisterUsableItem('bodyarmor', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bodyarmor', 1)
	TriggerClientEvent('sandy_blackshop:bodyarmor', source, 'small')
end)

ESX.RegisterUsableItem('bodyarmorx', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bodyarmorx', 1)
	TriggerClientEvent('sandy_blackshop:bodyarmor', source, 'large')
end)

function isitemWhitelisted(item)
	alloweditems = {
		"Suppressor",
		"powiekszonymagazynek",
		"celownikdluga",
		"holografik",
		"largescope",
		"mediumscope",
		"MountedScope",
		"grip",
		"bodyarmor",
		"bodyarmorx",
		"pistol_ammo_box",
		"pistol_mk2",
		"snspistol_mk2",
		"pistol50",
		"vintagepistol",
		"heavypistol",
		"molotov",
		"bat",
		"switchblade",
		"machete",
		"knuckle",
		"knife",
		"wrench",
		"crowbar",
		"hatchet",
		"blackshop",
		"weaponsblackshop",
		"headbag",
		"drill",
		"handcuffs",
		"wytrych",
		"thermal_charge",
		"lockpick",
		"laptop_h",
		"pistol",
		"snspistol"
  	}
	for _, whitelistedItems in pairs(alloweditems) do
		if item == whitelistedItems then
			return true
		end
	end

	return false
end
