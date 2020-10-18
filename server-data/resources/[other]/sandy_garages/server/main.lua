ESX              = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)
    
end)

MySQL.ready(function()
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE state = @state',
		{
			['@state'] = '0'
		},
		function(result2)
			local impoundedcars = {}
			if result2 ~= nil then
				for i=1, #result2, 1 do
					local daneImpounded = (result2[i])
					table.insert(impoundedcars, daneImpounded)
				end
				if impoundedcars ~= nil then
					for i=1,#impoundedcars,1 do
						MySQL.Async.execute(
							'UPDATE owned_vehicles SET state = @state WHERE plate = @plate',
							{
								['@state'] 	   = 1,
								['@plate'] 	   = impoundedcars[i].plate,
							}
						) 
					end
				end
			end
		end
	)
end)

Citizen.CreateThread(function()
	while true do
		MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE zlomed = @zlomed',
		{
			['@zlomed'] = '1'
		},
		function(result2)
			local zlomedcars = {}
			for i=1, #result2, 1 do
				local daneData = (result2[i])
				table.insert(zlomedcars, daneData)
			end
			if zlomedcars ~= nil then
				for i=1,#zlomedcars,1 do
					if zlomedcars[i].zlom > 0 then
						zlomedcars[i].zlom = zlomedcars[i].zlom - 1
							MySQL.Async.execute(
								'UPDATE owned_vehicles SET zlom = @zlom, zlomed = @zlomed WHERE state = @state and plate = @plate',
								{
									['@state'] 	   = 4,
									['@plate'] 	   = zlomedcars[i].plate,
									['@zlom']      = zlomedcars[i].zlom,
									['@zlomed']      = 1
								}
							) 
							--print('REJ: '..zlomedcars[i].plate..' Czas zlomowania :'..zlomedcars[i].zlom)
						if zlomedcars[i].zlom == 0 then
							MySQL.Async.execute(
								'UPDATE owned_vehicles SET state = @state, zlomed = @zlomed WHERE zlom = @zlom and plate = @plate',
								{
									['@zlom'] 	   = zlomedcars[i].zlom,
									['@plate'] 	   = zlomedcars[i].plate,
									['@state']      = 1,
									['@zlomed']      = 0
								}
							)
							--print('REJ: '..zlomedcars[i].plate..' Stan : 1') 
						end
					elseif zlomedcars[i].zlom == 0 then
							MySQL.Async.execute(
								'UPDATE owned_vehicles SET state = @state, zlomed = @zlomed WHERE zlom = @zlom and plate = @plate',
								{
									['@zlom'] 	   = zlomedcars[i].zlom,
									['@plate'] 	   = zlomedcars[i].plate,
									['@state']      = 1,
									['@zlomed']      = 0
								}
							)
							--print('REJ: '..zlomedcars[i].plate..' Stan : 1') 
					end
				end
			end
		end
		)
		Citizen.Wait(3600000)
	end
end)

RegisterServerEvent('sandy_garages:sandysendzlom')
AddEventHandler('sandy_garages:sandysendzlom', function(vehicleProps,modelkurwacar1,kurwamodel)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate AND model = @model AND state = @state',
		{
			['@plate'] = vehicleProps.plate,
			['@model'] = kurwamodel,
			['@state'] = 0,
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)

				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET state = @state, zlom = @zlom, zlomed = @zlomed WHERE plate = @plate',
					{
						['@zlom'] 	   = '12',
						['@plate'] 	   = vehicleProps.plate,
						['@state']      = 4,
						['@zlomed']      = 1
					}
				)
				TriggerClientEvent('sandykurwazlom:superfajnyzlom', _source)
				TriggerEvent("logs:zlom", xPlayer.name, vehicleProps.plate, modelkurwacar1, result2[i].owner, _source, xPlayer.identifier, '0')
			else
				TriggerClientEvent('esx:showNotification', _source, '~r~Zlomiarz nie jest zainteresowany tym samochodem')
			end
		end
	)
 end)

ESX.RegisterServerCallback('sandy_garages:sandygetzlomedvehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehicles` WHERE zlomed = @zlomed',
	{
		['@zlomed'] = 1
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = (result2[i])
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:getOwnedVehicles', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
		['@owner'] = identifier
		},
		function (result2)
			local vehicles = {}

			for i=1, #result2, 1 do
				local vehicleData = json.decode(result[i].vehicle)
				table.insert(vehicles, vehicleData)
			end

			cb(vehicles)
		end
	)
end)

ESX.RegisterServerCallback('sandy_garages:checkIfVehicleIsOwned', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner',
	{ 
		['@owner'] = identifier
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:checkIfVehicleIsOwned3', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner AND owner_type = @owner_type',
	{ 
		['@owner'] = identifier,
		['@owner_type'] = 1
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:checkIfVehicleIsOwned2', function (source, cb, plate, kurwamodel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner AND model = @model and zlomed = @zlomed',
	{ 
		['@owner'] = identifier,
		['@model'] = kurwamodel,
		['@zlomed'] = 0,
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if result2[i].plate ~= 4 then
				if vehicleData.plate == plate then
					found = true
					cb(vehicleData)
					break
				end
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

RegisterServerEvent('sandy_garages:sandysendkurwacar')
AddEventHandler('sandy_garages:sandysendkurwacar', function(vehicleProps, kurwapraca, twojstary)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local steamhex = GetPlayerIdentifier(_source)
	TriggerEvent("logs:dodajgarazorg", kurwapraca, xPlayer.name, vehicleProps.plate, twojstary, _source, steamhex)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 1, owner = @owner WHERE plate = @plate',
					{
						['@owner']		= kurwapraca,
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 

				MySQL.Async.execute(
					'DELETE from owned_vehicles WHERE plate = @plate and owner_type = @owner_type',
					{
						['@owner_type'] 	= 0,
						['@plate']      = vehicleProps.plate
					}
				) 

			end
		end
	)
 end)

RegisterServerEvent('sandy_garages:sandyremovekurwacar')
AddEventHandler('sandy_garages:sandyremovekurwacar', function(vehicleProps, kurwapraca, twojstary)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local steamhex = GetPlayerIdentifier(_source)
	TriggerEvent("logi:usungarazorg", kurwapraca, xPlayer.name, vehicleProps.plate, twojstary, _source, steamhex)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = kurwapraca
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 1, owner = @owner WHERE plate = @plate',
					{
						['@owner']		= identifier,
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
 end)

RegisterServerEvent('sandy_garages:sandyremoveCarFromParking')
AddEventHandler('sandy_garages:sandyremoveCarFromParking', function(plate, networkid)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehicles` SET state = 3 WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_released'))
	end
end)

RegisterServerEvent('sandy_garages:sandysendkurwacar2')
AddEventHandler('sandy_garages:sandysendkurwacar2', function(vehicleProps, kurwapraca)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = kurwapraca
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 1 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
 end)

ESX.RegisterServerCallback('sandy_garages:sandycheckIfVehicleIsOwned', function (source, cb, plate, kurwamodel, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner and model = @model and zlomed = @zlomed',
	{ 
		['@owner'] = kurwapraca,
		['@model'] = kurwamodel,
		['@zlomed'] = 0
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if result2[i].state ~= 4 then
				if vehicleData.plate == plate then
					found = true
					cb(vehicleData)
					break
				end
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:sandycheckIfVehicleIsOwned2', function (source, cb, plate, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner',
	{ 
		['@owner'] = kurwapraca
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:checkVehProps', function (source, cb, plate)
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE plate = @plate',
	{ 
		['@plate'] = plate
	},
	function (result2)
		if result2[1] then
			cb(json.decode(result2[1].vehicle))
		end
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:checkIfPlayerIsOwner', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND owner_type = 1',
	{ 
		['@owner'] = identifier,
		['@plate'] = plate
	},
	function (result2)
		if result2[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
	)
end)

RegisterServerEvent('sandy_garages:updateOwnedVehicle')
AddEventHandler('sandy_garages:updateOwnedVehicle', function(vehicleProps)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 1 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
 end)

RegisterServerEvent('sandy_garages:sandyupdateOwnedVehicle')
AddEventHandler('sandy_garages:sandyupdateOwnedVehicle', function(vehicleProps)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 0 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
 end)

RegisterServerEvent('sandy_garages:sandyupdateOwnedVehicle2')
AddEventHandler('sandy_garages:sandyupdateOwnedVehicle2', function(vehicleProps)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 3 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
 end)

RegisterServerEvent('sandy_garages:removeCarFromParking')
AddEventHandler('sandy_garages:removeCarFromParking', function(plate, networkid)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehicles` SET state = 0, vehicleid = @networkid WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@networkid'] = networkid
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_released'))
	end
end)

RegisterServerEvent('sandy_garages:removeCarFromPoliceParking')
AddEventHandler('sandy_garages:removeCarFromPoliceParking', function(plate, networkid)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehicles` SET state = 0, vehicleid = @networkid WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@networkid'] = networkid
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_released'))
	end
end)

ESX.RegisterServerCallback('sandy_garages:getVehiclesInGarage', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehicles` WHERE owner = @identifier AND state = 1 and zlomed = 0',
	{
		['@identifier'] = identifier
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesInGarage', function(source, cb, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehicles` WHERE owner = @owner AND state = 1 and zlomed = 0',
	{
		['@owner'] = kurwapraca
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:towVehicle', function(source, cb, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll("SELECT vehicleid FROM owned_vehicles WHERE owner=@identifier AND plate = @plate",
	{
		['@identifier'] = identifier,
		['@plate'] = plate
	}, 
	function(data)
		if data[1] ~= nil then
			cb(data[1].vehicleid)
		end
	end)
end)

ESX.RegisterServerCallback('sandy_garages:sandytowVehicle', function(source, cb, plate, kurwapraca)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll("SELECT vehicleid FROM owned_vehicles WHERE owner=@identifier AND plate = @plate",
	{
		['@identifier'] = kurwapraca,
		['@plate'] = plate
	}, 
	function(data)
		if data[1] ~= nil then
			cb(data[1].vehicleid)
		end
	end)
end)

ESX.RegisterServerCallback('sandy_garages:getVehiclesToTow',function(source, cb)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=0",
	{
		['@identifier'] = identifier
	}, 
	function(data) 
		for _,v in pairs(data) do
			if v.vehicleid == nil then
				v.vehicleid = -1
			end
			v.vehicle = v.vehicle:sub(1,-2)
			v.vehicle = v.vehicle .. ',"networkid":' .. v.vehicleid .. '}'
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesToTow',function(source, cb, kurwapraca)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=3",
	{
		['@identifier'] = kurwapraca
	}, 
	function(data) 
		for _,v in pairs(data) do
			if v.vehicleid == nil then
				v.vehicleid = -1
			end
			v.vehicle = v.vehicle:sub(1,-2)
			v.vehicle = v.vehicle .. ',"networkid":' .. v.vehicleid .. '}'
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('sandy_garages:getTakedVehicles', function(source, cb)
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE state=2",
	{}, 
	function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('sandy_garages:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.ImpoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('sandy_garages:checkMoneybank', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getBank() >= Config.ImpoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('sandy_garages:pay')
AddEventHandler('sandy_garages:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.ImpoundPrice)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
end)

RegisterServerEvent('sandy_garages:paybank')
AddEventHandler('sandy_garages:paybank', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('bank', Config.ImpoundPrice)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
end)


RegisterServerEvent('sandy_garages:updateState')
AddEventHandler('sandy_garages:updateState', function(plate)
	MySQL.Sync.execute(
		'UPDATE `owned_vehicles` SET state = 1, vehicleid = NULL WHERE plate = @plate',
		{
		['@plate'] = plate
		}
	)
end)

--SUBOWNER
ESX.RegisterServerCallback('sandy_garages:getSubowners', function(source, cb, plate)
	local subowners = {}
	local found = false
	MySQL.Async.fetchAll(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate and owner_type = 0',
		{ ['@plate'] = plate },
		function(data)
			if #data == nil or #data < 1 then
				found = true
			else
				for i=1, #data, 1 do
					MySQL.Async.fetchAll(
						'SELECT firstname, lastname FROM characters WHERE identifier = @identifier',
						{
							['@identifier'] = data[i].owner
						},
						function(data2)
							local subowner = {}
							table.insert(subowners, {label = data2[1].firstname .. " " .. data2[1].lastname, value= data[i].owner})
						end
					)
					if i==#data then
						found = true
					end
				end
			end
		end
	)
	Citizen.CreateThread(function()
		while found == false do
			Citizen.Wait(250)
			if found == true then
				cb(subowners)
			end
		end
	end)
end)

RegisterServerEvent('sandy_garages:setSubowner')
AddEventHandler('sandy_garages:setSubowner', function(plate, tID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.identifier
	local tIdentifier = tPlayer.identifier
	local ilosckasy = xPlayer.getBank()
	
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate AND owner_type = 1',
		{
			['@plate'] = plate
		},
		function(result2)
			if result2 ~= nil then
				if result2[1].owner_type == 1 then
					MySQL.Async.fetchAll(
						'SELECT owner FROM owned_vehicles WHERE plate = @plate AND owner_type = 0',
						{
							['@plate'] = plate
						},
						function(count)
							if #count >= Config.MaxSubs then
								TriggerClientEvent('esx:showNotification', xPlayer.source, _U('max_subs'))
							else
								if ilosckasy > 10000 then
									MySQL.Sync.execute(
										'INSERT INTO owned_vehicles (owner, owner_type, state, plate, vehicle, vehicleid, model) VALUES (@owner, @owner_type, @state, @plate, @vehicle, @vehicleid, @model)',
										{
											['@owner']   = tIdentifier,
											['@owner_type'] = 0,
											['@state'] = result2[1].state,
											['@plate'] = plate,
											['@vehicle'] =	result2[1].vehicle,
											['@vehicleid'] = result2[1].vehicleid,
											['@model'] = result2[1].model
										}
									)
									TriggerClientEvent('esx:showNotification', xPlayer.source, _U('sub_added'))
									TriggerClientEvent('esx:showNotification', tPlayer.source, _U('you_are_sub', plate))
									xPlayer.removeAccountMoney('bank', 10000)
								else
									TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nie posiadasz <b><font color="green">1000$</font></b> (bank)')
								end
							end
						end
					)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_owner'))
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_veh'))
			end
		end
	)
end)

RegisterServerEvent('sandy_garages:setSubowner2')
AddEventHandler('sandy_garages:setSubowner2', function(plate, tID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.identifier
	local tIdentifier = tPlayer.identifier
	local ilosckasy = xPlayer.getBank()
	
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate AND owner_type = 1',
		{
			['@plate'] = plate
		},
		function(result2)
			if result2 ~= nil then
				if result2[1].owner_type == 1 then
					MySQL.Async.fetchAll(
						'SELECT owner FROM owned_vehicles WHERE plate = @plate AND owner_type = 0',
						{
							['@plate'] = plate
						},
						function(count)
							if #count >= 1 then
								TriggerClientEvent('esx:showNotification', xPlayer.source, _U('max_subs'))
							else
								MySQL.Sync.execute(
									'INSERT INTO owned_vehicles (owner, owner_type, state, plate, vehicle, vehicleid, model) VALUES (@owner, @owner_type, @state, @plate, @vehicle, @vehicleid, @model)',
									{
										['@owner']   = tIdentifier,
										['@owner_type'] = 0,
										['@state'] = result2[1].state,
										['@plate'] = plate,
										['@vehicle'] =	result2[1].vehicle,
										['@vehicleid'] = result2[1].vehicleid,
										['@model'] = result2[1].model
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source, _U('sub_added'))
								TriggerClientEvent('esx:showNotification', tPlayer.source, _U('you_are_sub', plate))
							end
						end
					)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_owner'))
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_veh'))
			end
		end
	)
end)

RegisterServerEvent('sandy_garages:sellvehicle')
AddEventHandler('sandy_garages:sellvehicle', function(plate, tID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.identifier
	local tIdentifier = tPlayer.identifier
	local ilosckasy = xPlayer.getBank()
	
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate AND owner_type = 1',
		{
			['@plate'] = plate
		},
		function(result2)
			if result2 ~= nil then
				if result2[1].owner_type == 1 then
					MySQL.Async.execute(
						'UPDATE owned_vehicles SET vehicleid = NULL, state = 1, owner = @owner WHERE plate = @plate',
						{
							['@owner']		= tIdentifier,
							['@plate']      = plate
						}
					) 
					MySQL.Async.execute(
						'DELETE from owned_vehicles WHERE plate = @plate and owner_type = @owner_type',
						{
							['@owner_type'] 	= 0,
							['@plate']      = plate
						}
					) 
					TriggerClientEvent('esx:showNotification', tPlayer.source, 'Zostales wlascicielem pojazdu o rejestracji:'..plate)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_owner'))
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('not_veh'))
			end
		end
	)
end)

RegisterServerEvent('sandy_garages:deleteSubowner')
AddEventHandler('sandy_garages:deleteSubowner', function(plate, identifier)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Sync.execute(
		'DELETE FROM owned_vehicles WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('sub_deleted'))
end)

function parkAllOwnedVehicles()
	MySQL.ready(function ()
		MySQL.Sync.execute(
			'UPDATE `owned_vehicles` SET vehicleid = NULL WHERE vehicleid IS NOT NULL',
			{
			}, function(rowsChanged)
			end
		)
	end)
end

parkAllOwnedVehicles()

-- POLICE / EMS

ESX.RegisterServerCallback('sandy_garages:sandycheckIfVehicleIsOwnedEMG2', function (source, cb, plate, kurwamodel, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehiclesEMG WHERE owner = @owner AND model = @model AND identifier = @identifier',
	{ 
		['@owner'] = kurwapraca,
		['@identifier'] = identifier,
		['@model'] = kurwamodel
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if result2[i].state ~= 4 then
				if vehicleData.plate == plate then
					found = true
					cb(vehicleData)
					break
				end
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

RegisterServerEvent('sandy_garages:sandysendcarEMG')
AddEventHandler('sandy_garages:sandysendcarEMG', function(vehicleProps, kurwapraca)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehiclesEMG WHERE owner = @owner AND identifier = @identifier',
		{
			['@owner'] = kurwapraca,
			['@identifier'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehiclesEMG SET vehicle = @vehicle, vehicleid = NULL, state = 1 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesInGarageEMG', function(source, cb, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehiclesEMG` WHERE owner = @owner AND identifier = @identifier AND state = 1',
	{
		['@owner'] = kurwapraca,
		['@identifier'] = identifier
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesInGarageEMG2', function(source, cb, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehiclesEMG` WHERE owner = @owner AND identifier is null',
	{
		['@owner'] = kurwapraca
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesInGarageEMG3', function(source, cb, kurwapraca, identifier)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehiclesEMG` WHERE owner = @owner AND identifier = @identifier',
	{
		['@owner'] = kurwapraca,
		['@identifier'] = identifier
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles)
	end
	)
end)

ESX.RegisterServerCallback('sandy_garages:listallvehicles', function(source, cb, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM `owned_vehiclesEMG` WHERE owner = @owner',
	{
		['@owner'] = kurwapraca
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			if result2[i].type ~= 'boat' then
				local vehicleData = json.decode(result2[i].vehicle)
				table.insert(vehicles, vehicleData)
			end
		end
		cb(vehicles, result2)
	end
	)
end)

RegisterServerEvent('sandy_garages:sandysendcarEMG2')
AddEventHandler('sandy_garages:sandysendcarEMG2', function(kurwapraca, plate, identifier, imie)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local steamhex = GetPlayerIdentifier(_source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		if xPlayer.job.grade_name == "boss" then
			MySQL.Async.execute(
				'UPDATE owned_vehiclesEMG SET identifier = @identifier, currentowner = @currentowner WHERE owner = @owner AND plate = @plate',
				{
					['@owner']		= kurwapraca,
					['@identifier'] 	= identifier,
					['@plate']      = plate,
					['@currentowner']      = imie
				}
			) 
		end
	end
 end)

RegisterServerEvent('sandy_garages:sandysendcarEMG3')
AddEventHandler('sandy_garages:sandysendcarEMG3', function(kurwapraca, plate, identifier)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local steamhex = GetPlayerIdentifier(_source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		if xPlayer.job.grade_name == "boss" then
			MySQL.Async.execute(
				'UPDATE owned_vehiclesEMG SET identifier = @identifier, currentowner = @currentowner WHERE owner = @owner AND plate = @plate',
				{
					['@owner']		= kurwapraca,
					['@identifier'] 	= nil,
					['@plate']      = plate,
					['@currentowner']      = nil,
				}
			) 
		end
	end
 end)


ESX.RegisterServerCallback('sandy_garages:sandycheckIfVehicleIsOwnedEMG', function (source, cb, plate, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT * FROM owned_vehiclesEMG WHERE owner = @owner AND identifier = @identifier',
	{ 
		['@owner'] = kurwapraca,
		['@identifier'] = identifier
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

RegisterServerEvent('sandy_garages:sandyremoveCarFromParkingEMG')
AddEventHandler('sandy_garages:sandyremoveCarFromParkingEMG', function(plate, networkid)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehiclesEMG` SET state = 2 WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('veh_released'))
	end
end)

RegisterServerEvent('sandy_garages:sandyupdateOwnedVehicleEMG')
AddEventHandler('sandy_garages:sandyupdateOwnedVehicleEMG', function(vehicleProps, kurwapraca)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehiclesEMG WHERE owner = @owner',
		{
			['@owner'] = kurwapraca,
			['@identifier'] = identifier
		},
		function(result2) 
			local foundVehicleId = nil 
			for i=1, #result2, 1 do 				
				local vehicle = json.decode(result2[i].vehicle)
				if vehicle.plate == vehicleProps.plate then
					foundVehiclePlate = result2[i].plate
					break
				end
			end
			if foundVehiclePlate ~= nil then
				MySQL.Async.execute(
					'UPDATE owned_vehiclesEMG SET vehicle = @vehicle, vehicleid = NULL, state = 2 WHERE plate = @plate',
					{
						['@vehicle'] 	= json.encode(vehicleProps),
						['@plate']      = vehicleProps.plate
					}
				) 
			end
		end
	)
end)

ESX.RegisterServerCallback('sandy_garages:buyVehicle', function (source, cb, price)
	print('kek')
	local xPlayer     = ESX.GetPlayerFromId(source)
	local xPlayerJob = xPlayer.job.name
	local accountmoney = nil
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		if xPlayer.job.grade_name == "boss" then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayerJob, function(account)
				accountmoney = account.money
			end)
			if accountmoney >= price then
				cb(true)
			else
				cb(false)
			end
		end
	end
end)

RegisterServerEvent('sandy_garages:setVehicleOwned')
AddEventHandler('sandy_garages:setVehicleOwned', function (vehicleProps, kurwamodel, autko, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayerJob = xPlayer.job.name
	local steamhex = GetPlayerIdentifier(_source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		if xPlayer.job.grade_name == "boss" then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayerJob, function(account)
				if price > 0 and account.money >= price then
					account.removeMoney(price)
					TriggerEvent("logs:cars", xPlayer.name, vehicleProps.plate, autko, _source, steamhex)

					MySQL.Async.execute('INSERT INTO owned_vehiclesEMG (vehicle, owner, identifier, plate, model, state) VALUES (@vehicle, @owner, @identifier, @plate, @model, @state)',
					{
						['@vehicle'] = json.encode(vehicleProps),
						['@owner']   = xPlayerJob,
						['@identifier']   = nil,
						['@plate'] = vehicleProps.plate,
						['@model']	= kurwamodel,
						['@state']	= 1
					}, function(rowsChanged)
					end)
				end
			end)
		end
	end
end)

ESX.RegisterServerCallback('sandy_garages:sandygetVehiclesToTowEMG',function(source, cb, kurwapraca)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehiclesEMG WHERE owner=@identifier AND state=2",
	{
		['@identifier'] = kurwapraca
	}, 
	function(data) 
		for _,v in pairs(data) do
			if v.vehicleid == nil then
				v.vehicleid = -1
			end
			v.vehicle = v.vehicle:sub(1,-2)
			v.vehicle = v.vehicle .. ',"networkid":' .. v.vehicleid .. '}'
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

RegisterServerEvent('sandy_garages:updateStateEMG')
AddEventHandler('sandy_garages:updateStateEMG', function(plate)
	MySQL.Sync.execute(
		'UPDATE `owned_vehiclesEMG` SET state = 1, vehicleid = NULL WHERE plate = @plate',
		{
		['@plate'] = plate
		}
	)
end)