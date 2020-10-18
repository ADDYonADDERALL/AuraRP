ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_societymordo:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function(source, kurwatylekasyichuj,sourcetaxilvl)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if kurwatylekasyichuj ~= nil then
		if xPlayer.job.name ~= 'taxi' then
			print(('esx_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
			return
		end

		math.randomseed(os.time())

		local total = kurwatylekasyichuj
		local societyAccount
		
		if xPlayer.job.grade == 1 then
			total = total * 1.05
		elseif xPlayer.job.grade == 2 then
			total = total * 1.10
		elseif xPlayer.job.grade == 3 then
			total = total * 1.15
		elseif xPlayer.job.grade == 4 then
			total = total * 1.20
		end

		local kurwakasa = nil
	    if sourcetaxilvl == 0 then
	        kurwakasa = 1
	    elseif sourcetaxilvl > 50 then
	        kurwakasa = 50/100
	    else
	        kurwakasa = (sourcetaxilvl/100)
	    end
	    kurwakasa = kurwakasa + 1
	    local kurwasuperkasa = total*kurwakasa
	    kurwasuperkasa = kurwasuperkasa
	    kurwasuperkasa = math.floor(kurwasuperkasa)
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
			societyAccount = account
		end)

		xPlayer.addMoney(kurwasuperkasa)
		TriggerClientEvent('esx:showNotification', _source, 'Zarobiles $ ~g~'..kurwasuperkasa)

		if societyAccount then
			local playerMoney  = ESX.Math.Round(kurwasuperkasa)
			local taxikurwaMoney = ESX.Math.Round(kurwasuperkasa / 100 * 50)

			societyAccount.addMoney(taxikurwaMoney)
		end
	end
end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent('sandyrp:savetaxilevel')
AddEventHandler('sandyrp:savetaxilevel', function( amountofjobs, kurwatylekasyichuj)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcetaxilvl = pobierzdane.taxilvl
	local sourcetaxiexp = pobierzdane.taxiexp
	--if sourcekurierlvl < 50 then
    if amountofjobs == 5 then
		if sourcetaxiexp == 80 then
			sourcetaxilvl = sourcetaxilvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET taxilvl = @taxilvl, taxiexp = @taxiexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@taxilvl'] 		= sourcetaxilvl,
					['@taxiexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcetaxilvl..' level taxi!')
			TriggerEvent('esx_taxijob:success', _source, kurwatylekasyichuj, sourcetaxilvl)
		elseif sourcetaxiexp >= 0 and sourcetaxiexp <= 79 then
			sourcetaxiexp = sourcetaxiexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET taxilvl = @taxilvl, taxiexp = @taxiexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@taxilvl'] 		= sourcetaxilvl,
					['@taxiexp']      = sourcetaxiexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent('esx_taxijob:success', _source, kurwatylekasyichuj, sourcetaxilvl)
		end
	--elseif sourcekurierlvl >= 50 then
		--TriggerClientEvent('esx:showNotification', _source, 'Masz juz maksymalny level kuriera!')
		--TriggerEvent("sandyrp:kurierpay", _source, sourcekurierlvl)
	--end
	else
		--TriggerClientEvent('sandy_kurier:niemakwitu', _source)
	end
end)

function getlevel(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll(
		"SELECT * FROM expsystem WHERE identifier = @identifier", 
		{
			['@identifier'] = identifier
		}
	)
	if result[1] ~= nil then
		local staty = result[1]

		return {
			identifier = staty['identifier'],
			kurierlvl = staty['kurierlvl'],
			kurierexp = staty['kurierexp'],
			rybaklvl = staty['rybaklvl'],
			rybakexp = staty['rybakexp'],
			taxilvl = staty['taxilvl'],
			taxiexp = staty['taxiexp']
		}
	else
		return nil
	end
end