ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('headbag', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		TriggerClientEvent('atlantisHeadbag:checkplayers', _source)
end)

RegisterServerEvent('atlantisHeadbag:setbagon')
AddEventHandler('atlantisHeadbag:setbagon', function(target, idkurwy)
	local _target = target
	local _idkurwy = idkurwy
	local xPlayer = ESX.GetPlayerFromId(_idkurwy)
	local xTarget = ESX.GetPlayerFromId(_target)
		TriggerClientEvent('atlantisHeadbag:setbag', _target, _idkurwy)

end)

RegisterServerEvent('atlantisHeadbag:check')
AddEventHandler('atlantisHeadbag:check', function(target, idkurwy)
	local _target = target
	local _idkurwy = idkurwy
		TriggerClientEvent('atlantisHeadbag:checkthiskurwe', _target, _idkurwy)
end)

RegisterServerEvent('atlantisHeadbag:itemhuj')
AddEventHandler('atlantisHeadbag:itemhuj', function(idkurwy, gowno)
	local idhuj = idkurwy
	local _gowno = gowno
		TriggerClientEvent('atlantisHeadbag:kurwodajitem', idhuj, _gowno)
end)

RegisterServerEvent('atlantisHeadbag:item')
AddEventHandler('atlantisHeadbag:item', function(what)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _what = what
	local limitworkowbotypersiesprul = xPlayer.getInventoryItem('headbag').count
		if _what == 'remove' then
			xPlayer.removeInventoryItem('headbag', 1)
		elseif _what == 'give' then
			if limitworkowbotypersiesprul < 8 then
				xPlayer.addInventoryItem('headbag', 1)
			else
				TriggerClientEvent("pNotify:SendNotification", _source, {text = "Kieszenie pełne :(", type = "atlantis", queue = "global", timeout = 5000, layout = "atlantis"})	
			end	
		end
end)

RegisterServerEvent('atlantisHeadbag:woreknaleb')
AddEventHandler('atlantisHeadbag:woreknaleb', function(idkurwy, onglowa)
	local _source = source
	local _idkurwy = idkurwy
	local xPlayer = ESX.GetPlayerFromId(_idkurwy)
	local xTarget = ESX.GetPlayerFromId(_source)
	if onglowa == 0 then
		TriggerEvent('esx:woreknaleb', xPlayer.name..' sciągnął '..xTarget.name..' worek z łba')
	elseif onglowa == 1 then
		TriggerEvent('esx:woreknaleb', xPlayer.name..' załozył '..xTarget.name..' worek na łeb i bomby od dołu mu wali')
	end
end)