ESX = nil
local playersHealing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
  
	cb({
	  items = items
	})
  
  end)

  ESX.RegisterServerCallback('esx_ambulancejob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
	  cb(inventory.items)
	end)
  
  end)

RegisterServerEvent('stopbronS')
AddEventHandler('stopbronS', function(target)
	TriggerClientEvent('stopbron', target)
end)

RegisterServerEvent("ambulancejob:menuskin")
AddEventHandler("ambulancejob:menuskin", function()
  TriggerClientEvent('esx_skin:openSaveableMenu', source)
end)
  
RegisterServerEvent('esx_ambulancejob:revivee')
AddEventHandler('esx_ambulancejob:revivee', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('esx_ambulancejob:revivee', target)
	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:putOutVehicle')
AddEventHandler('esx_ambulancejob:putOutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putOutVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
	end
end)


RegisterServerEvent('esx_ambulancejob:putStockItems')
AddEventHandler('esx_ambulancejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('odklada', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('zla_ilosc'))
		end
	end)
end)

RegisterServerEvent('esx_ambulancejob:getStockItem')
AddEventHandler('esx_ambulancejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('zla_ilosc'))
      else
				inventory.removeItem(itemName, count)
        xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('zabral', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('zla_ilosc'))
		end
	end)
end)


TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_societymordo:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	ESX.SavePlayers()
	cb()
end)

RegisterServerEvent('CUSTOM_esx_ambulance:requestCPR')
AddEventHandler('CUSTOM_esx_ambulance:requestCPR', function(target, playerheading, playerCoords, playerlocation)
    print(target)
    TriggerClientEvent("CUSTOM_esx_ambulance:playCPR", target, playerheading, playerCoords, playerlocation)
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_ambulancejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
			['@owner'] = xPlayer.identifier,
			['@vehicle'] = json.encode(vehicleProps),
			['@plate'] = vehicleProps.plate,
			['@type'] = type,
			['@job'] = xPlayer.job.name,
			['@stored'] = true
		}, function (rowsChanged)
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:odbierzsygnal')
AddEventHandler('esx_ambulancejob:odbierzsygnal', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local telefon = xPlayer.getInventoryItem('phone').count
	if telefon > 0 then
		Citizen.Wait(100)
		TriggerClientEvent('esx_ambulancejob:sygnal', _source)
	else
		TriggerClientEvent('esx:showNotification', _source, 'Nie masz telefonu!')
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage' and itemName ~= 'oxygen_mask') then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'adminx', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('esx:showNotification', source, '~y~ID: ~b~'..tonumber(args[1])..'~s~ dostał revive!')
			TriggerClientEvent('esx_ambulancejob:revivee', tonumber(args[1]))
			TriggerClientEvent('esx:showNotification', tonumber(args[1]), '~y~SUPPORT: ~b~'.. nazwa ..'~s~ podał ci ręke!')
		end
	else
		TriggerClientEvent('esx_ambulancejob:revivee', source)
		TriggerClientEvent('esx:showNotification', source, 'Dostałeś revive od samego ~b~siebie~s~ :D')
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source, 'Nie masz permisji')
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

TriggerEvent('es:addGroupCommand', 'revive', 'support', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('esx:showNotification', source, '~y~ID: ~b~'..tonumber(args[1])..'~s~ dostał revive!')
			TriggerClientEvent('esx_ambulancejob:revivee', tonumber(args[1]))
			TriggerClientEvent('esx:showNotification', tonumber(args[1]), '~y~SUPPORT: ~b~'.. nazwa ..'~s~ podał ci ręke!')
		end
	else
		TriggerClientEvent('esx_ambulancejob:revivee', source)
		TriggerClientEvent('esx:showNotification', source, 'Dostałeś revive od samego ~b~siebie~s~ :D')
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source, 'Nie masz permisji')
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

TriggerEvent('es:addGroupCommand', 'revive', 'moderator', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			local xPlayer = ESX.GetPlayerFromId(source)
			local nazwa = xPlayer.getName(source)
			TriggerClientEvent('esx:showNotification', source, '~y~ID: ~b~'..tonumber(args[1])..'~s~ dostał revive!')
			TriggerClientEvent('esx_ambulancejob:revivee', tonumber(args[1]))
			TriggerClientEvent('esx:showNotification', tonumber(args[1]), '~y~ADMINISTRATOR: ~b~'.. nazwa ..'~s~ podał ci ręke!')
		end
	else
		TriggerClientEvent('esx_ambulancejob:revivee', source)
		TriggerClientEvent('esx:showNotification', source, 'Dostałeś revive od samego ~b~siebie~s~ :D')
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source, 'Nie masz permisji')
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

TriggerEvent('es:addGroupCommand', 'fix', 'admin', function(source, args, user)
	TriggerClientEvent('esx_ambulancejob:fix', source)
end, function(source, args, user)
end)

TriggerEvent('es:addGroupCommand', 'fix', 'adminx', function(source, args, user)
	TriggerClientEvent('esx_ambulancejob:fix', source)
end, function(source, args, user)
end)

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('leki', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('leki', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'leki')

		Citizen.Wait(5000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)

--[[RegisterServerEvent('esx_ambulacnejob:drag')
AddEventHandler('esx_ambulacnejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', _source, '~y~Chwytasz ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Chwyta cię ID: '.._source..' ')
  TriggerClientEvent('esx_ambulacnejob:drag', target, _source)
end)]]

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname']
		}
	else
		return nil
	end
end

TriggerEvent('es:addCommand', 'identyfikator', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(_source)
	local rname = name.firstname.. " " ..name.lastname
	if xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" then
		TriggerClientEvent("aurarp:Legitanim", _source)
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje identyfikator: '.. rname ..' - '.. xPlayer.job.grade_label ..'', _source)
		TriggerClientEvent("aurarp:DisplayLegit", -1, _source, rname, xPlayer.job.grade_label)
	else
		TriggerClientEvent('pNotify:SendNotification', xPlayer.source, {text = 'Nie jestes pracownikiem EMS!'})
	end
end)

RegisterNetEvent('aurarp:legitkapokaz')
AddEventHandler('aurarp:legitkapokaz', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local name = getIdentity(_source)
local rname = name.firstname.. " " ..name.lastname
if xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" then
	TriggerClientEvent("aurarp:Legitanim", _source)
	TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje identyfikator: '.. rname ..' - '.. xPlayer.job.grade_label ..'', _source)
	TriggerClientEvent("aurarp:DisplayLegit", -1, _source, rname, xPlayer.job.grade_label)
else
	TriggerClientEvent('pNotify:SendNotification', xPlayer.source, {text = 'Nie jestes pracownikiem EMS!'})
end
end)