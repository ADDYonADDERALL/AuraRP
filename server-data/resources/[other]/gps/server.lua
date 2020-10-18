
local ACTIVE_EMERGENCY_PERSONNEL = {}

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
	for k, v in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		TriggerClientEvent("eblips:updateAll", k, ACTIVE_EMERGENCY_PERSONNEL)
	end
	TriggerClientEvent("eblips:toggle", person.src, true)
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)

	ACTIVE_EMERGENCY_PERSONNEL[src] = nil

	for k, v in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		TriggerClientEvent("eblips:remove", tonumber(k), src)
	end

	TriggerClientEvent("eblips:toggle", src, false)
end)


AddEventHandler("playerDropped", function()
	if ACTIVE_EMERGENCY_PERSONNEL[source] then
		ACTIVE_EMERGENCY_PERSONNEL[source] = nil
	end
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	if item.name == 'tgps' then
		TriggerEvent('tost:dodajgpsa', source)
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'tgps' and item.count < 1 then
		TriggerEvent("eblips:remove", source)
	end
end)

RegisterServerEvent("tost:akcjazgpsem")
AddEventHandler("tost:akcjazgpsem", function(cosie)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local iloscGps = xPlayer.getInventoryItem('tgps').count
	if cosie == '1' then
		if iloscGps > 0 then
			xPlayer.removeInventoryItem('tgps', 1)
			Wait(1000)
			xPlayer.addInventoryItem('tgps', 1)
			TriggerClientEvent('esx:showNotification', _source, 'GPS zrestartowany.')
		end
	elseif cosie == '2' then
		if iloscGps > 0 then
			xPlayer.removeInventoryItem('tgps', 1)
			TriggerClientEvent('esx:showNotification', _source, 'GPS zniszczony.')
			TriggerClientEvent('esx_powiadomienia:gps', _source)
		end
	end
end)

RegisterServerEvent("tost:dodajgpsa")
AddEventHandler("tost:dodajgpsa", function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		local imieGracza = GetCharacterName(_source)
		local praca = xPlayer.job.grade_label
		local nazwapracy = xPlayer.job.label
		local nrodznaki = nil
		local kolorek = 20
		if xPlayer.job.name == 'police' then
			nrodznaki = exports['esx_policejob']:getOdznaka(_source)
			kolorek = 3
		elseif xPlayer.job.name == 'ambulance' then
			kolorek = 1
		end
		if nrodznaki ~= nil then
			TriggerEvent("eblips:add", { name = '[' .. nazwapracy.. '] ('.. nrodznaki ..') ' ..imieGracza.. ' - ' ..praca.. '', src = _source, color = kolorek})
		else
			if xPlayer.job.name == 'ambulance' then
				TriggerEvent("eblips:add", { name = '[' .. nazwapracy.. '] ' ..imieGracza.. ' - ' ..praca.. '', src = _source, color = kolorek})
			end
		end
	end
end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
		return result[1].firstname .. ' ' .. result[1].lastname
	else
		return GetPlayerName(source)
	end
end

ESX.RegisterUsableItem('tgps', function(source)
	TriggerClientEvent('tostgps:menugpsa', source)
	Wait(1500)
end)

