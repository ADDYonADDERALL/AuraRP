ESX = nil

local otwartyboombox = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('boomboxstatus')
AddEventHandler('boomboxstatus', function(type)
  if type == 'otwarty' then
    otwartyboombox = true
  elseif type == 'zamkniety' then
    otwartyboombox = false
  end
end)

ESX.RegisterUsableItem('boombox', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeInventoryItem('boombox', 1)
	
	TriggerClientEvent('esx_hifi:place_hifi', source)
	TriggerClientEvent('esx:showNotification', source, _U('put_hifi'))
end)

ESX.RegisterServerCallback('boomboxstatus2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local przesylanie = otwartyboombox
	cb(przesylanie)
end)

RegisterServerEvent('esx_hifi:remove_hifi')
AddEventHandler('esx_hifi:remove_hifi', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('boombox', 1)
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)


RegisterServerEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:play_music', -1, id, coords)
end)

RegisterServerEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)

RegisterServerEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:setVolume', -1, volume, coords)
end)
