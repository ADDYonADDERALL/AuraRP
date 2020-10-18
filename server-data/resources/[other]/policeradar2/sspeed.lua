RegisterServerEvent('radar:checkVehicle')
AddEventHandler('radar:checkVehicle', function(plate, model)
	local _source = source
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, 
	function (result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
				['@identifier'] = result[1].owner
			}, 
			function (result2)
				TriggerClientEvent('esx:showNotification', _source, 'Tablice: ' .. plate .. '\nWłaściciel: ' .. result2[1].firstname .. ' ' .. result2[1].lastname .. '\nModel: ' .. model)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Pojazd o numerze rejestracyjnym ' .. plate ..' jest niezarejestrowany!' )
		end
	end)
end)