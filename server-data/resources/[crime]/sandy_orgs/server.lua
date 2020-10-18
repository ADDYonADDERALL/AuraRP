ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cops

for k,v in pairs(Config.Organizacje) do
	TriggerEvent('esx_societycrime:registerSociety', v.praca, v.nazwa_organizacji, v.praca, v.praca, v.praca, {type = 'public'})
	TriggerEvent('esx_societycrime:registerSociety', v.praca..'dirty', v.nazwa_organizacji..'dirty', v.praca..'dirty', v.praca..'dirty', v.praca..'dirty', {type = 'public'})
end

RegisterServerEvent('sandy_org:saveOutfit')
AddEventHandler('sandy_org:saveOutfit', function(label, skin, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
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

ESX.RegisterServerCallback('sandy_org:getPlayerDressing', function(source, cb, organizacja)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
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

ESX.RegisterServerCallback('sandy_org:getPlayerOutfit', function(source, cb, num, organizacja)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
			local outfit = store.get('dressing', num)
			cb(outfit.skin)
		end)
	end
end)

RegisterServerEvent('sandy_org:removeOutfit')
AddEventHandler('sandy_org:removeOutfit', function(label, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job2.name == organizacja then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
			local dressing = store.get('dressing') or {}

			table.remove(dressing, label)
			store.set('dressing', dressing)
		end)
	end
end)

ESX.RegisterServerCallback('sandy_org:removeArmoryWeapon', function(source, cb, weaponName, organizacja, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job2.name == organizacja then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
			TriggerEvent("logs:szafkaorggetweapon", xPlayer.name, xPlayer.identifier, _source, count, organizacja, weaponName)
			local storeWeapons = store.get('weapons') or {}

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == weaponName then
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo

					table.remove(storeWeapons, i)
					break
				end
			end

			store.set('weapons', storeWeapons)
			xPlayer.addWeapon(weaponName, ammo)
			local xPlayer = ESX.GetPlayerFromId(source)
			cb()
		end)
	end
end)

ESX.RegisterServerCallback('sandy_org:getArmoryWeapons', function(source, cb, organizacja)
	TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
		local weapons    = {}
		weapons = store.get('weapons') or {}
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('sandy_org:addArmoryWeapon', function(source, cb, weaponName, removeWeapon, organizacja, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job2.name == organizacja then
		if xPlayer.hasWeapon(weaponName) then
			if removeWeapon then
				xPlayer.removeWeapon(weaponName)
			end
			TriggerEvent("logs:szafkaorgputweapon",xPlayer.name, xPlayer.identifier, _source, count, organizacja, weaponName)
			TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
				local storeWeapons = store.get('weapons') or {}

				table.insert(storeWeapons, {
					name = weaponName,
					ammo = count
				})
	
				store.set('weapons', storeWeapons)

				cb()
			end)
		else
			TriggerClientEvent('esx:showNotification', source, 'Błąd.')
		end
	end
end)

ESX.RegisterServerCallback('sandy_org:getStockItems', function(source, cb, organizacja)
	TriggerEvent('esx_addoninventory:getSharedInventory', organizacja, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('sandy_org:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent('sandy_org:getStockItem')
AddEventHandler('sandy_org:getStockItem', function(organizacja, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer and xPlayer.job2.name == organizacja then
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', organizacja, function(inventory)
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

RegisterServerEvent('sandy_org:putStockItems')
AddEventHandler('sandy_org:putStockItems', function(organizacja, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.job2.name == organizacja then
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', organizacja, function(inventory)
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

RegisterServerEvent('sandy_org:takemoney')
AddEventHandler('sandy_org:takemoney', function(organizacja, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addonaccount:getSharedAccount', organizacja..'dirty', function(account)
		local organisationAccountMoney = account.money

		if organisationAccountMoney >= count then
			account.removeMoney(count)
			xPlayer.addAccountMoney('black_money', count)
			ESX.SavePlayer(xPlayer)
			TriggerEvent("logs:szafkaorgbrudneremove", xPlayer.name, xPlayer.identifier, _source, count, organizacja)
			TriggerClientEvent('esx:showNotification', _source, 'Wypłaciłeś '..count..'$ brudnych pieniędzy z konta organizacji!')
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie możesz pobrać takiej kwoty.')
		end
	end)
end)

RegisterServerEvent('sandy_org:putmoney')
AddEventHandler('sandy_org:putmoney', function(organizacja, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)

	local playerAccountMoney = xPlayer.getAccount('black_money').money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney('black_money', count)
			TriggerEvent('esx_addonaccount:getSharedAccount', organizacja..'dirty', function(account)
				account.addMoney(count)
				ESX.SavePlayer(xPlayer)
				TriggerEvent("logs:szafkaorgbrudneadd", xPlayer.name, xPlayer.identifier, _source, count, organizacja)
				TriggerClientEvent('esx:showNotification', _source, 'Wpłaciłeś '..count..'$ brudnych pieniędzy na konto!')
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie masz takie kwoty.')
		end
end)

RegisterServerEvent('sandy_org:showmoney')
AddEventHandler('sandy_org:showmoney', function(organizacja)
	local _source      = source
	local job = organizacja .. 'dirty'
	local hajs
	TriggerEvent('esx_addonaccount:getSharedAccount', organizacja .. 'dirty', function(account)
		hajs = account.money
	end)

	TriggerClientEvent('sandy_org:safe', _source, hajs)	
end)

RegisterServerEvent('sandy_org:makebrick')
AddEventHandler('sandy_org:makebrick', function(item)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)

    if item == 'coke' then
		local cokelimit = xPlayer.getInventoryItem('cokebrick')
        if(cokelimit.limit < cokelimit.count + 1) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle koki')
        else
        	local cokekurwalimit = xPlayer.getInventoryItem('coke_pooch')
        	if cokekurwalimit.count >= 100 then
           		TriggerClientEvent('sandy_org:timer', source)
            	Citizen.Wait(60000)
            	xPlayer.removeInventoryItem('coke_pooch', 100)
            	xPlayer.addInventoryItem('cokebrick', 1)
        	else
        		TriggerClientEvent('esx:showNotification', source, 'Nie masz tyle koki')
        	end
        end
    elseif item == 'opium' then
    	local opiumlimit = xPlayer.getInventoryItem('opiumbrick')
        if(opiumlimit.limit < opiumlimit.count + 1) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle opium')
        else
        	local opiumkurwalimit = xPlayer.getInventoryItem('opium_pooch')
        	if opiumkurwalimit.count >= 100 then
           		TriggerClientEvent('sandy_org:timer', source)
            	Citizen.Wait(60000)
            	xPlayer.removeInventoryItem('opium_pooch', 100)
            	xPlayer.addInventoryItem('opiumbrick', 1)
        	else
        		TriggerClientEvent('esx:showNotification', source, 'Nie masz tyle opium')
        	end
        end
    elseif item == 'meta' then
   		local metalimit = xPlayer.getInventoryItem('metabrick')
        if(metalimit.limit < metalimit.count + 1) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle mety')
        else
        	local metakurwalimit = xPlayer.getInventoryItem('meth_pooch')
        	if metakurwalimit.count >= 100 then
           		TriggerClientEvent('sandy_org:timer', source)
            	Citizen.Wait(60000)
            	xPlayer.removeInventoryItem('meth_pooch', 100)
            	xPlayer.addInventoryItem('metabrick', 1)
        	else
        		TriggerClientEvent('esx:showNotification', source, 'Nie masz tyle mety')
        	end
        end
    elseif item == 'crack' then
   		local cracklimit = xPlayer.getInventoryItem('crackbrick')
        if(cracklimit.limit < cracklimit.count + 1) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle cracku')
        else
        	local crackkurwalimit = xPlayer.getInventoryItem('crack_pooch')
        	if crackkurwalimit.count >= 100 then
           		TriggerClientEvent('sandy_org:timer', source)
            	Citizen.Wait(60000)
            	xPlayer.removeInventoryItem('crack_pooch', 100)
            	xPlayer.addInventoryItem('crackbrick', 1)
        	else
        		TriggerClientEvent('esx:showNotification', source, 'Nie masz tyle cracku')
        	end
        end
    end

end)

ESX.RegisterUsableItem('cokebrick', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local cokelimit = xPlayer.getInventoryItem('coke_pooch')
        if(cokelimit.limit < cokelimit.count + 100) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle koki')
        else
        	xPlayer.removeInventoryItem('cokebrick', 1)
            xPlayer.addInventoryItem('coke_pooch', 100)
        end
end)

ESX.RegisterUsableItem('opiumbrick', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local opiumlimit = xPlayer.getInventoryItem('opium_pooch')
        if(opiumlimit.limit < opiumlimit.count + 100) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle opium')
        else
        	xPlayer.removeInventoryItem('opiumbrick', 1)
            xPlayer.addInventoryItem('opium_pooch', 100)
        end
end)

ESX.RegisterUsableItem('metabrick', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local metalimit = xPlayer.getInventoryItem('meth_pooch')
        if(metalimit.limit < metalimit.count + 100) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle mety')
        else
        	xPlayer.removeInventoryItem('metabrick', 1)
            xPlayer.addInventoryItem('meth_pooch', 100)
        end
end)

ESX.RegisterUsableItem('crackbrick', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local cracklimit = xPlayer.getInventoryItem('crack_pooch')
        if(cracklimit.limit < cracklimit.count + 100) then
            TriggerClientEvent('esx:showNotification', source, 'Nie mozesz uniesc tyle cracku')
        else
        	xPlayer.removeInventoryItem('crackbrick', 1)
            xPlayer.addInventoryItem('crack_pooch', 100)
        end
end)

RegisterServerEvent('sandy_org:setdrugjob')
AddEventHandler('sandy_org:setdrugjob', function(target, org)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	if isjobWhitelisted(xPlayer.job2.name) then
		if tPlayer.job2.name ~= xPlayer.job2.name then
			if tPlayer.job.name ~= 'police' or tPlayer.job.name ~= 'ambulance' or tPlayer.job.name ~= 'mecano' then
				TriggerClientEvent('sandy_org:setdrugjob', target, org)
				TriggerClientEvent('esx:showNotification', _source, 'Dales zlecenie ID: '..target)
				TriggerClientEvent('esx:showNotification', target, 'Otrzymales zlecenie od ID: '.._source)
			end
		elseif tPlayer.job2.grade <= 1 then
			if tPlayer.job.name ~= 'police' or tPlayer.job.name ~= 'ambulance' or tPlayer.job.name ~= 'mecano' then
				TriggerClientEvent('sandy_org:setdrugjob', target, org)
				TriggerClientEvent('esx:showNotification', _source, 'Dales zlecenie ID: '..target)
				TriggerClientEvent('esx:showNotification', target, 'Otrzymales zlecenie od ID: '.._source)
			end
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
end)

RegisterServerEvent('sandy_org:removedrugjob')
AddEventHandler('sandy_org:removedrugjob', function(target, org)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	if isjobWhitelisted(xPlayer.job2.name) then
		if tPlayer.job2.name ~= xPlayer.job2.name then
			if tPlayer.job.name ~= 'police' or tPlayer.job.name ~= 'ambulance' or tPlayer.job.name ~= 'mecano' then
				TriggerClientEvent('sandy_org:removedrugjob', target, org)
				TriggerClientEvent('esx:showNotification', _source, 'Zatrzymales zlecenie ID: '..target)
				TriggerClientEvent('esx:showNotification', target, 'Zatrzymano zlecenie od ID: '.._source)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie mozesz dawac zlecen swoim ludzia')
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
end)

function isjobWhitelisted(job)
	for k,v in pairs(Config.Organizacje) do
		if job == v.praca then
			return true
		end
	end
	return false
end

RegisterServerEvent('sandy_org:drugsNotify')
AddEventHandler('sandy_org:drugsNotify', function()
	TriggerClientEvent("sandy_org:drugsEnable", source)
end)

RegisterServerEvent('sandy_org:drugsInProgressPos')
AddEventHandler('sandy_org:drugsInProgressPos', function(gx, gy, gz)
	TriggerClientEvent('sandy_org:drugsPlace', -1, gx, gy, gz, source, "Obywatel sprzedaje narkotyki!")
end)

RegisterServerEvent('sandy_org:rolldrugtosell')
AddEventHandler('sandy_org:rolldrugtosell', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local weedqty = xPlayer.getInventoryItem('weed_pooch').count
	local methqty = xPlayer.getInventoryItem('meth_pooch').count
	local cokeqty = xPlayer.getInventoryItem('coke_pooch').count
	local opiuqty = xPlayer.getInventoryItem('opium_pooch').count
	local marihty = xPlayer.getInventoryItem('weedindica_pooch').count
	local crackqty = xPlayer.getInventoryItem('crack_pooch').count
	
	local drug = {}

	if weedqty > 0 then
		drug = {
			bCCP8 = 'weed_pooch',
			A9jqY = Config.WeedPrice,
			XzzF7 = weedqty,
			CJ4rD = 'gramow marihuany (Sativa)'
		}
		TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
	else
		if cokeqty > 0 then
			drug = {
				bCCP8 = 'coke_pooch',
				A9jqY = Config.CokePrice,
				XzzF7 = cokeqty,
				CJ4rD = 'gramow kokainy'
			}
			TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
		else
			if marihty > 0 then
				drug = {
					bCCP8 = 'weedindica_pooch',
					A9jqY = Config.WeedIndicaPrice,
					XzzF7 = marihty,
					CJ4rD = 'gramow marihuany (Indica)'
				}
				TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
			else
				if opiuqty > 0 then
					drug = {
						bCCP8 = 'opium_pooch',
						A9jqY = Config.OpiumPrice,
						XzzF7 = opiuqty,
						CJ4rD = 'gramow opium'
					}
					TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
				else
					if methqty > 0 then
						drug = {
							bCCP8 = 'meth_pooch',
							A9jqY = Config.MethPrice,
							XzzF7 = methqty,
							CJ4rD = 'metamfetaminy'
						}
						TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
					else
						if crackqty > 0 then
							drug = {
								bCCP8 = 'crack_pooch',
								A9jqY = Config.CrackPrice,
								XzzF7 = crackqty,
								CJ4rD = 'Crack'
							}
							TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
						else
							drug = {
								bCCP8 = 'nomore',
								A9jqY = 'nomore',
								XzzF7 = 'nomore',
								CJ4rD = 'nomore'
							}
							TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug)
							TriggerClientEvent('esx:showNotification', _source, 'Nie masz juz narkotykow!')
						end
					end
				end
			end
		end
	end 
end)

RegisterServerEvent('sandy_org:selldrug')
AddEventHandler('sandy_org:selldrug', function(drug, cops, org)
	if drug.bCCP8 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.A9jqY == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.XzzF7 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.CJ4rD == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local drugqty = drug.XzzF7
	local x = 0
	local blackMoney = 0

	if drugqty > 0 then
		if drugqty == 1 then
			x = 1
		elseif drugqty == 2 then
			x = math.random(1,2)
		elseif drugqty == 3 then
			x = math.random(1,3)
		elseif drugqty == 4 then
			x = math.random(2,4)
		elseif drugqty >= 5 then
			x = math.random(3,5)
		elseif drugqty >= 6 then
			x = math.random(3,6)
		elseif drugqty >= 7 then
			x = math.random(3,7)
		elseif drugqty >= 8 then
			x = math.random(4,8)
		elseif drugqty >= 9 then
			x = math.random(4,9)
		elseif drugqty >= 10 then
			x = math.random(5,10)
		end
	else
		
		return
	end

	if drug.XzzF7 ~= nil then
		xPlayer.removeInventoryItem(drug.bCCP8, x)
	end
	
	blackMoney = drug.A9jqY
	blackMoney = blackMoney * x
	
	if cops == 2 then
		blackMoney = blackMoney * 1
	elseif cops == 3 then
		blackMoney = blackMoney * 1.10
	elseif cops == 4 then
		blackMoney = blackMoney * 1.15
	elseif cops == 5 then
		blackMoney = blackMoney * 1.20
	elseif cops == 6 then
		blackMoney = blackMoney * 1.25
	elseif cops >= 7 then
		blackMoney = blackMoney * 1.30
	end
	
	blackMoney = math.floor(blackMoney)
	
	xPlayer.addAccountMoney('black_money', blackMoney)
	TriggerClientEvent('esx:showNotification', _source, 'Sprzedałeś ~y~' .. 'x'..x.. ' ~b~'..drug.CJ4rD..'~s~ za ~g~' .. '$' .. blackMoney)
	local randomcut = math.random(10,25)
	randomcut = '0.'..randomcut
	local orgpayout = blackMoney*randomcut
	orgpayout = math.floor(orgpayout)
	TriggerEvent('esx_addonaccount:getSharedAccount', org..'dirty', function(account)
		account.addMoney(orgpayout)
	end)
	local newitemqty = xPlayer.getInventoryItem(drug.bCCP8).count
	local drug2 = {
		bCCP8 = drug.bCCP8,
		A9jqY = drug.A9jqY,
		XzzF7 = newitemqty,
		CJ4rD = drug.CJ4rD
	}
	TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug2)
end)

RegisterServerEvent('sandy_org:stealdrug')
AddEventHandler('sandy_org:stealdrug', function(drug)
	if drug.bCCP8 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.A9jqY == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.XzzF7 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.CJ4rD == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local drugqty = drug.XzzF7
	local x = 0

	if drugqty > 0 then
		if drugqty == 1 then
			x = 1
		elseif drugqty == 2 then
			x = math.random(1,2)
		elseif drugqty == 3 then
			x = math.random(1,3)
		elseif drugqty == 4 then
			x = math.random(1,4)
		elseif drugqty >= 5 then
			x = math.random(1,5)
		end
	else
		
		return
	end

	if drug.XzzF7 ~= nil then
		xPlayer.removeInventoryItem(drug.bCCP8, x)
	end
	local drug2 = {
		bCCP8 = drug.bCCP8,
		A9jqY = drug.A9jqY,
		XzzF7 = x,
		CJ4rD = drug.CJ4rD
	}
	TriggerClientEvent('sandy_org:playerstolendrugs', _source, drug2)
end)

RegisterServerEvent('sandy_org:getdrugback')
AddEventHandler('sandy_org:getdrugback', function(drug)
	if drug.bCCP8 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.A9jqY == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.XzzF7 == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	if drug.CJ4rD == nil then
		TriggerEvent("logsbanCheaterr", _source, "DRUGS")
	end
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local drugqty = drug.XzzF7

	if drugqty > 0 then
		if drug.XzzF7 ~= nil then
			xPlayer.addInventoryItem(drug.bCCP8, drugqty)
		end
	end
	local newitemqty = xPlayer.getInventoryItem(drug.bCCP8).count
	local drug2 = {
		bCCP8 = drug.bCCP8,
		A9jqY = drug.A9jqY,
		XzzF7 = newitemqty,
		CJ4rD = drug.CJ4rD
	}
	TriggerClientEvent('sandy_org:playerhasdrugs', _source, drug2)
end)
