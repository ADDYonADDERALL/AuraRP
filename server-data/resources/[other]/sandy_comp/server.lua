ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.Firmy) do
	TriggerEvent('esx_societymordo:registerSociety', v.praca, v.nazwa_organizacji, 'society_'..v.praca, 'society_'..v.praca, 'society_'..v.praca, {type = 'public'})
end

RegisterServerEvent('sandy_comp:saveOutfit')
AddEventHandler('sandy_comp:saveOutfit', function(label, skin, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..organizacja, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
	end)
end)

ESX.RegisterServerCallback('sandy_comp:getPlayerDressing', function(source, cb, organizacja)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..organizacja, function(store)
			local count  = store.count('dressing')
			local labels = {}

			for i=1, count, 1 do
				local entry = store.get('dressing', i)
				table.insert(labels, entry.label)
			end

			cb(labels)
		end)
	end
end)

ESX.RegisterServerCallback('sandy_comp:getPlayerOutfit', function(source, cb, num, organizacja)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..organizacja, function(store)
			local outfit = store.get('dressing', num)
			cb(outfit.skin)
		end)
	end
end)

RegisterServerEvent('sandy_comp:removeOutfit')
AddEventHandler('sandy_comp:removeOutfit', function(label, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job.name == organizacja then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..organizacja, function(store)
			local dressing = store.get('dressing') or {}

			table.remove(dressing, label)
			store.set('dressing', dressing)
		end)
	end
end)

ESX.RegisterServerCallback('sandy_comp:getStockItems', function(source, cb, organizacja)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..organizacja, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('sandy_comp:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent('sandy_comp:getStockItem')
AddEventHandler('sandy_comp:getStockItem', function(organizacja, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer and xPlayer.job.name == organizacja then
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..organizacja, function(inventory)
			local inventoryItem = inventory.getItem(itemName)
			if count > 0 and inventoryItem.count >= count then
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, ('Nieprawidłowa ilość'))
				else
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
					TriggerEvent("logs:szafkaorggetitem", xPlayer.name, xPlayer.identifier, _source, count, organizacja, inventoryItem.label)
					TriggerClientEvent('esx:showNotification', _source, 'Wyciągnąłeś ze schowka: x' .. count .. ' ' .. inventoryItem.label)
				end
			else
				TriggerClientEvent('esx:showNotification', _source, ('Nieprawidłowa ilość'))
			end
		end)
	end
end)

RegisterServerEvent('sandy_comp:putStockItems')
AddEventHandler('sandy_comp:putStockItems', function(organizacja, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job.name == organizacja then
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..organizacja, function(inventory)
			local inventoryItem = inventory.getItem(itemName)
			
			if sourceItem.count >= count and count > 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				TriggerEvent("logs:szafkaorgputitem", xPlayer.name, xPlayer.identifier, _source, count, organizacja, inventoryItem.label)
				TriggerClientEvent('esx:showNotification', _source, 'Włożyłeś przedmiot: x' .. count .. ' ' .. inventoryItem.label)
			else
				TriggerClientEvent('esx:showNotification', _source, ('Nieprawidłowa ilość'))
			end
		end)
	end
end)

ESX.RegisterUsableItem('fakeid', function(source)
	local _source = source
	local driving = nil
    local weapon  = nil
    local insurance = nil
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if getIdentity(_source) ~= nil then
		local name = getIdentity(_source)
	    local realname = name.firstname
		local realname2 = name.lastname
		local weapon = name.weapon
		local drive = name.drive
		local insurance = name.insurance
		local job = name.job

		Citizen.Wait(100)
		if(drive ~= nil and weapon ~= nil and insurance ~= nil) then
			TriggerClientEvent("dowod:animka", _source)
			TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje swój dowód: '.. realname ..' '.. realname2 ..'', _source)
			TriggerClientEvent("dowod:DisplayId", -1, _source, realname, realname2, drive, weapon, job, insurance)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Dowod wyglada na zniszczony')
		end
	else
		TriggerClientEvent('esx:showNotification', _source, 'Dowod wyglada na zniszczony')
	end
end)

function getIdentity(source)
	local owner = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM fakeid WHERE owner = @owner",
		{
			['@owner'] = owner
		}
	)
	if result[1] ~= nil then
		local identity = result[1]

		return {
			owner = identity['owner'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			weapon = identity['weapon'],
			drive = identity['drive'],
			insurance = identity['insurance'],
			job = identity['job'],
		}
	else
		return nil
	end
end

TriggerEvent('es:addGroupCommand', 'wyrobdowod', 'user', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local firstname = args[2]
	local lastname = args[3]
	local weapon = args[4]
	local drive = args[5]
	local insurance = args[6]
	local job = args[7]
	local found = nil
	if xPlayer.job2.name == "ndrangheta" then
		if xPlayer.job2.grade_name == "boss" then
			TriggerClientEvent("sandyfakeid:checkdistance", source, args[1], firstname, lastname, weapon, drive, insurance, job)
		else
			TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi w radiu!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi w radiu!')
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source, 'Nie masz permisji!')
end, { help = 'Wydaj falszywy dowod', params = {{ name = 'id' }, { name = 'imie' }, { name = 'nazwisko' }, { name = 'bron' }, { name = 'prawo jazdy' }, { name = 'ubezpieczenie' }, { name = 'praca' }}})

RegisterServerEvent('sandyfakeid:setfakeid')
AddEventHandler('sandyfakeid:setfakeid', function(id, firstname, lastname, weapon, drive, insurance, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job2.name == "ndrangheta" then
		if xPlayer.job2.grade_name == "boss" then
			if id ~= nil or firstname ~= nil or lastname ~= nil or weapon ~= nil or drive ~= nil or insurance ~= nil or job ~= nil then
				if GetPlayerName(tonumber(id)) ~= nil then
					local targetXPlayer = ESX.GetPlayerFromId(tonumber(id))
					MySQL.Async.fetchAll(
					'SELECT * FROM fakeid WHERE owner = @owner',
						{ 
							['@owner'] = targetXPlayer.identifier
						},
						function (result2)
							if result2[1] ~= nil then
								MySQL.Async.execute(
									'UPDATE fakeid SET firstname = @firstname, lastname = @lastname, weapon = @weapon, drive = @drive, insurance = @insurance, job = @job, sucks = @sucks WHERE owner = @owner',
									{
								  		['@owner']   = targetXPlayer.identifier,
								  		['@firstname']   = firstname,
								  		['@lastname']   = lastname,
								  		['@weapon']   = weapon,
								  		['@drive']   = drive,
								  		['@insurance']   = insurance,
								  		['@job'] = job,
								  		['@sucks'] = 1
									}
								)
							else
								MySQL.Async.execute(
									'INSERT INTO fakeid (owner,firstname,lastname,weapon,drive,insurance,job,sucks) VALUES (@owner,@firstname,@lastname,@weapon,@drive,@insurance,@job,@sucks)',
									{
								  		['@owner']   = targetXPlayer.identifier,
								  		['@firstname']   = firstname,
								  		['@lastname']   = lastname,
								  		['@weapon']   = weapon,
								  		['@drive']   = drive,
								  		['@insurance']   = insurance,
								  		['@job'] = job,
								  		['@sucks'] = 1
									}
								)
							end
						end
					)
					TriggerClientEvent('esx:showNotification', source, '~g~Wydales falszywy dowod dla :~b~ '..id)
					TriggerClientEvent('esx:showNotification', tonumber(id), '~g~Dostales falszywy dowod od ~b~'..source..' !')
					xPlayer.addInventoryItem('fakeid', 1)
				else
					TriggerClientEvent('esx:showNotification', source, 'Nie znaleziono obywatela')
				end
			else
				TriggerClientEvent('esx:showNotification', source, 'Blad nieprawidlowe dane')
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi!')
			return
		end
	end
end)

ESX.RegisterServerCallback('sandyfakeid:showfakeids', function(source, cb)
	MySQL.Async.fetchAll(
	'SELECT * FROM fakeid WHERE sucks = @sucks',
	{
		['@sucks'] = 1
	},
	function(result2)
		local dane = {}
		for i=1, #result2, 1 do
			local daneData = (result2[i])
			table.insert(dane, daneData)
		end
		cb(dane)
	end
	)
end)

RegisterServerEvent('sandyfakeid:removefakeids')
AddEventHandler('sandyfakeid:removefakeids', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job2.name == "ndrangheta" then
		if xPlayer.job2.grade_name == "boss" then
			MySQL.Async.execute(
				'DELETE FROM fakeid WHERE owner = @owner',
				{
				  	['@owner'] = target
				}
			)
			TriggerClientEvent('esx:showNotification', source, '~y~Client: stracil swoj dowod!')
		else
			TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi!')
		end
	end
end)