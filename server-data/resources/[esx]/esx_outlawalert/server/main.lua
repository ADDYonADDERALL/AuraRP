ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender)
    mytype = 'police'
    data = {["code"] = '10-98', ["name"] = 'Kradzież pojazdu  '   ..vehicleLabel..  '.', ["loc"] = streetName}
    length = 3500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:combatInProgress', -1, targetCoords)
    TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords, streetName, playerGender)
	mytype = 'police'
    data = {["code"] = '10-31', ["name"] = 'Walka', ["loc"] = streetName}
    length = 2500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:combatInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords, streetName, playerGender)
	mytype = 'police'
    data = {["code"] = '10-71', ["name"] = 'Strzały', ["loc"] = streetName}
    length = 3500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
end, false)

ESX.RegisterServerCallback('esx_outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('1013Pos')
AddEventHandler('1013Pos', function(targetCoords,streetName,gx,gy,gz)
    mytype = 'police'
    data = {["code"] = '10-13', ["name"] = 'Ranny Policjant', ["loc"] = streetName}
    length = 2500
    TriggerClientEvent('1013Place', -1, gx, gy, gz)
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
end)

RegisterServerEvent('gpsPos')
AddEventHandler('gpsPos', function(targetCoords,streetName,gx,gy,gz)
    mytype = 'police'
    data = {["code"] = 'Code-0', ["name"] = 'Sygnal GPS', ["loc"] = streetName}
    length = 2500
    TriggerClientEvent('esx_outlawalert:gpsInProgress', -1, gx, gy, gz)
    TriggerClientEvent('gpsPlace', -1)
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
end)