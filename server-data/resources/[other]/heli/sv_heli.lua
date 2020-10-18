ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'ustawbind', 'user', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local keybind = (args[1])
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		if keybind ~= nil then
			if iskeyWhitelisted(keybind) then
				MySQL.Async.execute(
					'UPDATE users SET `radiokeybind` = @radiokeybind WHERE identifier = @identifier',
					{
						['@radiokeybind']   = keybind,
						['@identifier'] = xPlayer.identifier
					}
				)
				TriggerClientEvent('esx:showNotification', _source, '~y~Ustawiles:~b~ '..keybind..'~s~ jako keybind do radia')
				TriggerClientEvent('sandy_radio:setkeybind', _source, keybind)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Nie mozesz ustawic tego przycisku!')
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie mozesz podac pustego keybinda!')
		end
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source, 'Nie masz permisji!')
end, { help = 'Ustaw keybind do radia!', params = {{ name = 'id' }}})

function iskeyWhitelisted(key)
	Keys = {
	    "ESC", 
	    "F1", 
	    "F2", 
	    "F3", 
	    "F5", 
	    "F6", 
	    "F7", 
	    "F8",
	    "F9",
	    "F10",
	    "~",
	    "1",
	    "2",
	    "3", 
	    "4",
	    "5", 
	    "6", 
	    "7",
	    "8",
	    "9",
	    "-",
	    "=",
	    "BACKSPACE",
	    "TAB",
	    "Q",
	    "W",
	    "E",
	    "R",
	    "T",
	    "Y",
	    "U",
	    "P",
	    "[",
	    "]",
	    "ENTER",
	    "CAPS",
	    "A",
	    "S",
	    "D",
	    "F",
	    "G",
	    "H",
	    "K",
	    "L",
	    "LEFTSHIFT",
	    "Z",
	    "X",
	    "C",
	    "V",
	    "B",
	    "N",
	    "M",
	    ",",
	    ".",
	    "LEFTCTRL",
	    "LEFTALT",
	    "SPACE",
	    "RIGHTCTRL",
	    "HOME",
	    "PAGEUP",
	    "PAGEDOWN",
	    "DELETE",
	    "LEFT",
	    "RIGHT",
	    "TOP",
	    "DOWN",
	    "NENTER",
	    "N4",
	    "N5",
	    "N6",
	    "N+",
	    "N-",
	    "N7",
	    "N8",
	    "N9"
	}
	for _, whitelistedKey in pairs(Keys) do
		if key == whitelistedKey then
			return true
		end
	end
	return false
end

ESX.RegisterServerCallback('sandy_radio:checkkeybind', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT radiokeybind FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local result = result[1].radiokeybind
		if result ~= nil then
			cb(result)
		else
			cb(nil)
		end
	end)
end)
