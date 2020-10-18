
ESX                       = nil
local PhoneNumbers        = {}

-- PhoneNumbers = {
--   police = {
--     type  = "police",
--     sources = {
--        ['3'] = true
--     }
--   }
-- }

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)


function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
	local mess = 'Od #' .. alert.numero  .. ' Wiadomość: ' .. alert.message
	if alert.coords ~= nil then
		mess = mess .. ' | GPS: ' .. string.format("%.2f", alert.coords.x) .. ', ' .. string.format("%.2f", alert.coords.y) 
	end
    for k, _ in pairs(listSrc) do
      getPhoneNumber(tonumber(k), function (n)
        if n ~= nil then
          TriggerEvent('gcPhone:_internalAddMessage', number, n, mess, 0, function (smsMess)
            TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
          end)
        end
      end)
    end
  end
end



AddEventHandler('esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('==== Enregistrement du telephone ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type          = type,
    sources       = {},
    alerts        = {}
	}
end)


AddEventHandler('esx:setJob', function(source, job, lastJob)
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, source)
  end

  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:addSource', job.name, source)
  end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)


RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function (number, message, coords)

  local xPlayers = ESX.GetPlayers()
  local taxi = 0

  local source = source
  if PhoneNumbers[number] ~= nil then
    if number == 'taxi' then
      if message == 'cancel' then
        TriggerClientEvent('esx_aiTaxi:cancelTaxi', source, true)
      else
        for i=1, #xPlayers, 1 do
          local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer.job.name == 'taxi' then
            taxi = taxi + 1
          end
        end
        if taxi == 0 then
          TriggerClientEvent('pNotify:SendNotification', source, {text = 'Zamówiono taksówkę NPC'})
          TriggerClientEvent('esx_aiTaxi:callTaxi', source, coords)
        else
          getPhoneNumber(source, function (phone) 
            notifyAlertSMS(number, {
            message = message,
            coords = coords,
            numero = phone,
            }, PhoneNumbers[number].sources)
          end)
        end
      end
    else
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
        }, PhoneNumbers[number].sources)
      end)
    end
  else
    print('Appels sur un service non enregistre => numero : ' .. number)
  end
end)


AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result[1].phone_number
    xPlayer.set('phoneNumber', phoneNumber)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
      TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, source)
    end
  end)

end)


AddEventHandler('esx:playerDropped', function(source)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if PhoneNumbers[xPlayer.job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, source)
  end
end)


function getPhoneNumber (source, callback) 
  print('get phone to ' .. source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then
    print('esx_addons_gcphone. source null ???')
    callback(nil)
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result[1].phone_number)
  end)
end