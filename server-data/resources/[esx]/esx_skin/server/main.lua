ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
	{
		['@skin']       = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			else
				print(('esx_skin: %s attempted saving skin to file'):format(user.getIdentifier()))
			end
		end)
	end)

end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then 
		MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(users)
			local user = users[1]
			local skin = nil

			local jobSkin = {
				skin_male   = xPlayer.job.skin_male,
				skin_female = xPlayer.job.skin_female
			}

			if user.skin ~= nil then
				skin = json.decode(user.skin)
			end

			cb(skin, jobSkin)
		end)
	end
end)

-- Commands
TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, id, user)
	if id[1]== nil then
		TriggerClientEvent('esx:showNotification', source, "Nie podałeś ID gracza")
		return
	elseif GetPlayerPing(id[1])== 0 then
		TriggerClientEvent('esx:showNotification', source, "Niema nikogo o takim ID")
		return
	end
	TriggerClientEvent('esx:showNotification', source, "Otwarto menu skin Graczowi o ID " .. id[1])
	TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
  end, 
  function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { id = { '^1SYSTEM', 'Insufficient Permissions.' } })
  end, {help = _U('skin')})

TriggerEvent('es:addGroupCommand', 'skin', 'adminx', function(source, id, user)
	if id[1]== nil then
		TriggerClientEvent('esx:showNotification', source, "Nie podałeś ID gracza")
		return
	elseif GetPlayerPing(id[1])== 0 then
		TriggerClientEvent('esx:showNotification', source, "Niema nikogo o takim ID")
		return
	end
	TriggerClientEvent('esx:showNotification', source, "Otwarto menu skin Graczowi o ID " .. id[1])
	TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
  end, 
  function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { id = { '^1SYSTEM', 'Insufficient Permissions.' } })
  end, {help = _U('skin')})

  TriggerEvent('es:addGroupCommand', 'skin', 'moderator', function(source, id, user)
	if id[1]== nil then
		TriggerClientEvent('esx:showNotification', source, "Nie podałeś ID gracza")
		return
	elseif GetPlayerPing(id[1])== 0 then
		TriggerClientEvent('esx:showNotification', source, "Niema nikogo o takim ID")
		return
	end
	TriggerClientEvent('esx:showNotification', source, "Otwarto menu skin Graczowi o ID " .. id[1])
	TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
  end, 
  function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { id = { '^1SYSTEM', 'Insufficient Permissions.' } })
  end, {help = _U('skin')})

  TriggerEvent('es:addGroupCommand', 'skin', 'support', function(source, id, user)
	if id[1]== nil then
		TriggerClientEvent('esx:showNotification', source, "Nie podałeś ID gracza")
		return
	elseif GetPlayerPing(id[1])== 0 then
		TriggerClientEvent('esx:showNotification', source, "Niema nikogo o takim ID")
		return
	end
	TriggerClientEvent('esx:showNotification', source, "Otwarto menu skin Graczowi o ID " .. id[1])
	TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
  end, 
  function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { id = { '^1SYSTEM', 'Insufficient Permissions.' } })
  end, {help = _U('skin')})

TriggerEvent('es:addGroupCommand', 'skinsave', 'admin', function(source, args, user)
	TriggerClientEvent('esx_skin:requestSaveSkin', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('saveskin')})


function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam:", "")
end
