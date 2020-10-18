ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bodycam', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('sandy_bodycam:checkbodycam', source)
		elseif xPlayer.job.name == 'ambulance' then
			TriggerClientEvent('sandy_bodycam:checkbodycam', source)
		end
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if item.name == 'bodycam' and item.count < 1 then
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('sandy_bodycam:setbodycam', source, 'false')
		elseif xPlayer.job.name == 'ambulance' then
			TriggerClientEvent('sandy_bodycam:setbodycam', source, 'false')
		end
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
			numerodznaki = identity['numerodznaki']
		}
	else
		return nil
	end
end

RegisterServerEvent('sandy_bodycam:getidentity')
AddEventHandler('sandy_bodycam:getidentity', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerdata = getIdentity(source)
	local name = playerdata.firstname.. " " ..playerdata.lastname
	if xPlayer.job.name == 'police' then
		local badgenumber = playerdata.numerodznaki
		TriggerClientEvent('sandy_bodycam:setname', _source, name, badgenumber, 'true')
	elseif xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('sandy_bodycam:setname', _source, name, '', 'false')
	end
end)