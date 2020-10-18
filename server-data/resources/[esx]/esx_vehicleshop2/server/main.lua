setVehicleOwnedsetVehicleOwnedESX = nil
local Categories, Vehicles = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_societymordo:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('esx_vehicleshop2: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories2')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles2')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('esx_vehicleshop2:sendCategories', -1, Categories)
	TriggerClientEvent('esx_vehicleshop2:sendVehicles', -1, Vehicles)
end)

RegisterServerEvent('esx_vehicleshop2:setVehicleOwned')
AddEventHandler('esx_vehicleshop2:setVehicleOwned', function(vehicleProps, vehicleData, kurwamodel, autko)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local steamhex = GetPlayerIdentifier(_source)

	TriggerEvent("logs:cars", xPlayer.name, vehicleProps.plate, autko,_source, steamhex)

	TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))

	MySQL.Async.execute('INSERT INTO owned_vehicles (vehicle, owner, plate, model) VALUES (@vehicle, @owner, @plate, @model)',
	{
		['@vehicle'] = json.encode(vehicleProps),
		['@owner']   = xPlayer.identifier,
		['@plate'] = vehicleProps.plate,
		['@model']	= kurwamodel
	}, function(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop2:getCategories', function(source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop2:getVehicles', function(source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop2:buyVehicle', function(source, cb, vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if vehicleData and xPlayer.getMoney() >= vehicleData.price then
		xPlayer.removeMoney(vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop2:buyVehiclecard', function(source, cb, vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if vehicleData and xPlayer.getBank() >= vehicleData.price then
		xPlayer.removeAccountMoney('bank', vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop2:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles', {}, function(result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			if xPlayer then -- message player if connected
				xPlayer.removeAccountMoney('bank', result[i].rent_price)
				xPlayer.showNotification(_U('paid_rental', ESX.Math.GroupDigits(result[i].rent_price)))
			else -- pay rent by updating SQL
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank'] = result[i].rent_price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end

RegisterServerEvent('sandyjazda:sprawdzforse')
AddEventHandler('sandyjazda:sprawdzforse', function(opcja)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local accountMoney = 0
	local CenaJazdy = 5000
	accountMoney = xPlayer.getAccount('bank').money
	
	xPlayer.removeAccountMoney('bank', CenaJazdy)
	Wait(500)

end)

TriggerEvent('cron:runAt', 22, 00, PayRent)
