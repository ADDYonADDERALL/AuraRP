ESX = nil

local windaopen = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('windastatus')
AddEventHandler('windastatus', function(type)
  if type == 'otwarty' then
    windaopen = true
  elseif type == 'zamkniety' then
    windaopen = false
  end
end)

ESX.RegisterServerCallback('windastatus2', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local przesylanie = windaopen
  cb(przesylanie)
end)


