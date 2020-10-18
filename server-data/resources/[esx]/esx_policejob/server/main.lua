ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)

TriggerEvent('esx_societymordo:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})
TriggerEvent('esx_societymordo:registerSociety', 'policedirty', 'Policedirty', 'society_policedirty', 'society_policedirty', 'society_policedirty', {type = 'public'})

RegisterServerEvent('esx_jobpolice:giveWeapon')
AddEventHandler('esx_jobpolice:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterCommand("bk", function(source, args, rawCommand)
  local s = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer ~= nil then
      if xPlayer.job.name == 'police' then
          local bkLvl = args[1]
          if not bkLvl then
            TriggerClientEvent("rich:ShowInfo", source, "~y~Proszę podać poziom kodu ~n~~s~0, 1, 2, 3, 99")
          elseif bkLvl == "0" then
            TriggerClientEvent("rich:BackupReq", -1, bkLvl, s)
          elseif bkLvl == "1" then
            TriggerClientEvent("rich:BackupReq", -1, bkLvl, s)
          elseif bkLvl == "2" then
            TriggerClientEvent("rich:BackupReq", -1, bkLvl, s)
          elseif bkLvl == "3" then
            TriggerClientEvent("rich:BackupReq", -1, bkLvl, s)
          elseif bkLvl == "99" then
            TriggerClientEvent("rich:BackupReq", -1, bkLvl, s)
          elseif bkLvl ~= "0" or bkLvl ~= "1" or bkLvl ~= "2" or bkLvl ~= "3" or bkLvl ~= "99" then
            TriggerClientEvent("rich:ShowInfo", source, "~y~Nieprawidłowy poziom kodu")
          end
      end
  end
end)

ESX.RegisterServerCallback('richrp:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

ESX.RegisterServerCallback('sandy:sprawdzhexa', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.getIdentifier()
  cb(identifier)
end)

ESX.RegisterServerCallback('sandy:sprawdzhexagu', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.getIdentifier()
  cb(identifier)
end)

ESX.RegisterServerCallback('sandy:sprawdzhexam', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.getIdentifier()
  cb(identifier)
end)

RegisterServerEvent('esx_jobpolice:confiscatePlayerItem')
AddEventHandler('esx_jobpolice:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('za_duzo'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, target))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, _source))
        TriggerEvent('logs:takeitem', sourceXPlayer.name, targetXPlayer.name, sourceItem.label, amount, sourceXPlayer.identifier, targetXPlayer.identifier)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('za_duzo'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, target))
    TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, _source))
    TriggerEvent('logs:takeitem', sourceXPlayer.name, targetXPlayer.name, itemName, amount, sourceXPlayer.identifier, targetXPlayer.identifier)

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, target, amount))
    TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, _source))
    TriggerEvent('logs:takeitem', sourceXPlayer.name, targetXPlayer.name, ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.identifier, targetXPlayer.identifier)
	end
end)

RegisterServerEvent('esx_jobpolice:handcuff')
AddEventHandler('esx_jobpolice:handcuff', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', _source, '~y~ID: '..target..' Probujesz Zakuc/Odkuc')
  TriggerClientEvent('esx:showNotification', target, '~r~ID: '.._source..' Probuje cie Zakuc/Odkuc')
  Citizen.Wait(100)
  TriggerClientEvent('esx_jobpolice:handcuff', target)
end)

RegisterServerEvent('esx_jobpolice:message')
AddEventHandler('esx_jobpolice:message', function(target, message)
  TriggerClientEvent('esx:showNotification', target, message)
end)

RegisterServerEvent('esx_jobpolice:drag')
AddEventHandler('esx_jobpolice:drag', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', _source, '~y~Chwytasz ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Chwyta cię ID: '.._source..' ')
  TriggerClientEvent('esx_jobpolice:drag', target, _source)
end)

RegisterServerEvent('esx_jobpolice:bagajnotifka')
AddEventHandler('esx_jobpolice:bagajnotifka', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', _source, '~y~Wsadzasz do bagaja ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Wsadza cię do bagaja ID: '.._source..' ')
end)

RegisterServerEvent('esx_jobpolice:bagajnotifka1')
AddEventHandler('esx_jobpolice:bagajnotifka1', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', _source, '~y~Wyciągasz z bagaja ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Wyciąga cię z bagaja ID: '.._source..' ')
end)

RegisterServerEvent('esx_jobpolice:przeszukaj')
AddEventHandler('esx_jobpolice:przeszukaj', function(target)
	local _source = source
	TriggerClientEvent('esx_jobpolice:przeszukaj', _source)
	TriggerClientEvent('esx:showNotification', _source, '~y~Przeszukujesz ID: '..target..' ')
	TriggerClientEvent('esx:showNotification', target, '~r~Przeszukuje cię ID: '.._source..' ')
end)

RegisterServerEvent('esx_jobpolice:putInVehicle')
AddEventHandler('esx_jobpolice:putInVehicle', function(target)
  local _source = source
  TriggerClientEvent('esx_jobpolice:putInVehicle', target)
  TriggerClientEvent('esx:showNotification', _source, '~y~Wsadzasz do pojazdu ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Wsadza cię do pojazdu ID: '.._source..' ')
end)

RegisterServerEvent('esx_jobpolice:OutVehicle')
AddEventHandler('esx_jobpolice:OutVehicle', function(target)
  local _source = source
  TriggerClientEvent('esx_jobpolice:OutVehicle', target)
  TriggerClientEvent('esx:showNotification', _source, '~y~Wyciągasz z pojazdu ID: '..target..' ')
  TriggerClientEvent('esx:showNotification', target, '~r~Wyciąga cię z pojazdu ID: '.._source..' ')
end)

RegisterServerEvent('esx_jobpolice:getStockItem')
AddEventHandler('esx_jobpolice:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
      else
				inventory.removeItem(itemName, count)
        xPlayer.addInventoryItem(itemName, count)
        TriggerEvent("logs:szafkapolicetake", xPlayer.name, count, inventoryItem.label)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)


RegisterServerEvent('esx_jobpolice:putStockItems')
AddEventHandler('esx_jobpolice:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
      TriggerEvent("logs:szafkapolicegive", xPlayer.name, count, inventoryItem.label)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_jobpolice:putStockItems2')
AddEventHandler('esx_jobpolice:putStockItems2', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    local inventoryItem = inventory.getItem(itemName)
    if itemName == 'pistol_ammo' or itemName == 'stungun_ammo' or itemName == 'shotgun_ammo' or itemName == 'smg_ammo' or itemName == 'rifle_ammo' then
      inventory.addItem(itemName, 1000)

      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', 1000, inventoryItem.label))
    else
      inventory.addItem(itemName, 1)
      TriggerEvent("logs:szafkapolicegive", xPlayer.name, 1, inventoryItem.label)
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', 1, inventoryItem.label))
    end
  end)
end)

ESX.RegisterServerCallback('esx_jobpolice:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_jobpolice:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_jobpolice:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate', 
		{
			['@plate'] = plate
		},
		function(result)
			if result[1] ~= nil then
				local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).name
				cb(playerName, true)
			else
				cb('unknown', false)
			end
		end
	)
end)

ESX.RegisterServerCallback('esx_jobpolice:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_jobpolice:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

  local xPlayer = ESX.GetPlayerFromId(source)

  if removeWeapon then
   xPlayer.removeWeapon(weaponName)
  end

  TriggerEvent("esx:szafkapolicji2",xPlayer.name,weaponName)
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_jobpolice:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 250)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)
  TriggerEvent("esx:szafkapolicji",xPlayer.name,weaponName)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_jobpolice:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_jobpolice:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_jobpolice:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source
	
	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		
    -- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
      TriggerClientEvent('esx_jobpolice:updateBlip', -1)
		end
	end	
end)

RegisterServerEvent('esx_jobpolice:spawned')
AddEventHandler('esx_jobpolice:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_jobpolice:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_jobpolice:forceBlip')
AddEventHandler('esx_jobpolice:forceBlip', function()
	TriggerClientEvent('esx_jobpolice:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_jobpolice:updateBlip', -1)
	end
end)

ESX.RegisterUsableItem('handcuffs', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx_jobpolice:kajdanki', _source)


end)

RegisterServerEvent('gsrtestmenu')
AddEventHandler('gsrtestmenu', function(identifier)
  local _source = source
  local identifier = GetPlayerIdentifiers(identifier)[1]
  MySQL.Async.fetchAll('SELECT * FROM gsr WHERE identifier=@identifier', {['@identifier'] = identifier}, function(gotInfo)
    if gotInfo[1] ~= nil then
      TriggerClientEvent('hasShotNotify', _source)
    else
      TriggerClientEvent('hasNotShotNotify', _source)
    end
  end)
end)

RegisterServerEvent('esx_jobpolice:DajLicencje')
AddEventHandler('esx_jobpolice:DajLicencje', function(owner)
  local _source = source
  local typ = 'weapon'
  local xPlayer = ESX.GetPlayerFromId(owner)
  local identifier = xPlayer.identifier
  local xPlayerx = ESX.GetPlayerFromId(_source)

  if xPlayerx.job.grade >= 16 then
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
    {
      ['@type'] = typ,
      ['@owner'] = identifier
    }, function(rowsChanged)
      local xPlayer = ESX.GetPlayerFromIdentifier(owner)
  
    end)
    TriggerClientEvent('esx:showNotification', _source, '~g~Wydano licencje dla osoby obok ciebie!')
    TriggerClientEvent('esx:showNotification', owner, '~g~ID: '.._source..' wydał Ci licencje na broń!')
  else
    TriggerClientEvent('esx:showNotification', _source, '~r~Nie mozesz wydawac licencji!')
  end
end)

Guys = {}
PGuys = {}
RegisterServerEvent('esx_inventory_TMM:delete')
AddEventHandler('esx_inventory_TMM:delete', function(guy)

print('delguy' .. guy)
local T = 1
for f,b in pairs (Guys) do
	if b == guy then
	table.remove(Guys, T)
	break
	end
	print(Guys[T])
	T = T + 1
	end
end)

AddEventHandler('esx_inventory_TMM:add2', function(guy)
print('add guy 2: ' .. guy)
table.insert(PGuys, guy)
end)



AddEventHandler('esx_inventory_TMM:delete2', function(guy)

print('delguy2: ' .. guy)
local T = 1
for f,b in pairs (PGuys) do
	if b == guy then
	table.remove(PGuys, T)
	break
	end
	print(PGuys[T])
	T = T + 1
	end
end)


ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
local C = false
  if Config.EnableESXIdentity then

  	
	for k,v in pairs(Guys) do 
	if v == target then
	C = true
	print("wykryto:" .. v)
	break
	end
end
for k,v in pairs(PGuys) do 
	if v == target then
	C = true
	print("wykryto:" .. v)
	break
	end
end
  local _source = source
	if not C then 
table.insert(Guys, target)
 print("otwieram:" .. target)
	else
	print("zamykam:" .. target)
	end
  
  
  
  
  
    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user          = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
	local money         = user['money']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " cm"
	local alive			= user['isdead'] 
	

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts, 
      weapons     = xPlayer.loadout,
	  isdead	  = xPlayer.isdead,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
	  money 	  = money,
      dob         = dob,
      height      = height,
	  F 		  = C
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

RegisterServerEvent('esx_jobpolice:takeVehicle')
AddEventHandler('esx_jobpolice:takeVehicle', function(plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            MySQL.Async.execute(
                'UPDATE owned_vehicles SET vehicleid = NULL, state = 2 WHERE plate = @plate',
                {
                    ['@plate'] = plate
                }
            )
        end
    end)
end)

RegisterServerEvent('esx_jobpolice:sandysetodznaka')
AddEventHandler('esx_jobpolice:sandysetodznaka', function(policjant,policjantimie,quantity)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "police" then
		if xPlayer.job.grade_name == "boss" then
			if quantity ~= nil then
				MySQL.Async.execute(
					'UPDATE users SET `numerodznaki` = @numerodznaki WHERE identifier = @identifier',
					{
					  	['@numerodznaki']   = quantity,
					  	['@identifier'] = policjant
					}
				)
				TriggerClientEvent('esx:showNotification', source, '~y~POLICJANT:~b~ '..policjantimie..'~s~ dostał odznake ~b~LSPD!')
				--TriggerClientEvent('esx:showNotification', tonumber(args[1]), '~y~POLICJANT:~b~ '.. rname ..'~s~ nadał ci odnake: ~b~' .. numerodznaki .. ' !')
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi w policji!')
		end
	end
end)

RegisterServerEvent('esx_jobpolice:sandyremoveodznaka')
AddEventHandler('esx_jobpolice:sandyremoveodznaka', function(policjant,policjantimie)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "police" then
		if xPlayer.job.grade_name == "boss" then
			MySQL.Async.execute(
				'UPDATE users SET `numerodznaki` = @numerodznaki WHERE identifier = @identifier',
				{
				  	['@numerodznaki']   = '',
				  	['@identifier'] = policjant
				}
			)
			TriggerClientEvent('esx:showNotification', source, '~y~POLICJANT:~b~ '..policjantimie..'~r~ stracil odznake ~b~LSPD!')
			--TriggerClientEvent('esx:showNotification', tonumber(args[1]), '~y~POLICJANT:~b~ '.. rname ..'~s~ nadał ci odnake: ~b~' .. numerodznaki .. ' !')
		else
			TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej rangi w policji!')
		end
	end
end)

ESX.RegisterServerCallback('esx_jobpolice:sandyshowodznakas', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.identifier
  local kurwapraca = 'police'
  local dane = {}
  MySQL.Async.fetchAll(
  'SELECT * FROM users WHERE job = @job or job = @job2 ORDER BY firstname ASC',
  {
    ['@job'] = kurwapraca,
    ['@job2'] = 'off'..kurwapraca
  },
  function(result)
    for i=1, #result, 1 do
      local daneData = (result[i])
      table.insert(dane, daneData)
    end
    cb(dane)
  end
  )
end)

RegisterNetEvent('esx_jobpolice:ShowPlate')
AddEventHandler('esx_jobpolice:ShowPlate', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(_source)
	local rname = name.firstname.. " " ..name.lastname
	local numerodznaka = name.numerodznaka
	if xPlayer.job.name == "police" or xPlayer.job.name == "offpolice" then
		if numerodznaka == '' then
			TriggerClientEvent('esx:showNotification', _source, 'Jeszcze nie masz nadanej odznaki!')
			return
		end
		TriggerClientEvent("esx_jobpolice:plateanim", _source)
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje odznakę policjanta: ['.. numerodznaka ..'] '.. rname ..' - '.. xPlayer.job.grade_label ..'', _source)
		TriggerClientEvent("esx_jobpolice:DisplayPlate", -1, _source, rname, xPlayer.job.grade_label, numerodznaka)
	else
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie jestes policjantem!')
	end
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			job = identity['job'],
			jobgrade = identity['job_grade'],
			secondjob = identity['secondjob'],
			secondjobgrade = identity['secondjob_grade'],
			numerodznaka = identity['numerodznaki']
		}
	else
		return nil
	end
end

function getOdznaka(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  local result = MySQL.Sync.fetchAll("SELECT numerodznaki FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
  if result[1] ~= nil then
    return result[1].numerodznaki
  else
    return nil
  end
end

ESX.RegisterServerCallback('esx_jobpolice:showdirtymoney', function(source, cb)
  local xPlayer  = ESX.GetPlayerFromId(source)
  local dirtymoney
  if xPlayer.job.grade_name == "boss" then
    TriggerEvent('esx_addonaccount:getSharedAccount', 'policedirty', function(account)
      dirtymoney = account.money
      cb(dirtymoney)
    end)
  else
    cb('Nieznana kwota')
  end
end)


RegisterServerEvent('esx_jobpolice:takemoney')
AddEventHandler('esx_jobpolice:takemoney', function(count)
  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  if xPlayer.job.grade == 20 and xPlayer.job.name == "police" then
    TriggerEvent('esx_addonaccount:getSharedAccount', 'policedirty', function(account)
      local organisationAccountMoney = account.money
      if organisationAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney('black_money', count)
        ESX.SavePlayer(xPlayer)
        TriggerEvent("logs:szafkaorgbrudneremove", xPlayer.name, xPlayer.identifier, _source, count, 'Police')
        TriggerClientEvent('esx:showNotification', _source, 'Wypłaciłeś '..count..'$ brudnych pieniędzy')
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie możesz pobrać takiej kwoty.')
      end
    end)
  end
end)

RegisterServerEvent('esx_jobpolice:putmoney')
AddEventHandler('esx_jobpolice:putmoney', function(count)
  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  if xPlayer.job.name == "police" then
    local playerAccountMoney = xPlayer.getAccount('black_money').money
      if playerAccountMoney >= count and count > 0 then
        xPlayer.removeAccountMoney('black_money', count)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'policedirty', function(account)
          account.addMoney(count)
          ESX.SavePlayer(xPlayer)
          TriggerEvent("logs:szafkaorgbrudneadd", xPlayer.name, xPlayer.identifier, _source, count, 'Police')
          TriggerClientEvent('esx:showNotification', _source, 'Wpłaciłeś '..count..'$ brudnych pieniędzy')
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie masz takie kwoty.')
      end
  end
end)

RegisterServerEvent('esx_jobpolice:burnmoney')
AddEventHandler('esx_jobpolice:burnmoney', function(count)
  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  if xPlayer.job.grade == 20 and xPlayer.job.name == "police" then
    TriggerEvent('esx_addonaccount:getSharedAccount', 'policedirty', function(account)
      local organisationAccountMoney = account.money
      if organisationAccountMoney >= count then
        account.removeMoney(count)
        local newcount = count*0.15
        newcount = math.floor(newcount)
        xPlayer.addAccountMoney('black_money', newcount)
        ESX.SavePlayer(xPlayer)
        TriggerEvent("logs:szafkaorgbrudneburn", xPlayer.name, xPlayer.identifier, _source, count, newcount, 'Police')
        TriggerClientEvent('esx:showNotification', _source, 'Spaliles '..newcount..'$ brudnych pieniędzy')
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie możesz spalic takiej kwoty.')
      end
    end)
  end
end)