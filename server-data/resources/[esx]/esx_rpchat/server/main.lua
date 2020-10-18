ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

AddEventHandler('chatMessage', function(source, name, message)
	local args = stringsplit(message, " ")
	if string.sub(message,1,string.len("/"))=="/" then
	else
		TriggerClientEvent("sendProximityMessage", -1, source, name, " " .. message)
	end
	CancelEvent()
	if args[1] == '/twt' or args[1] == '/twitter' or args[1] == '/tweet' or args[1] == '/t' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local phone = xPlayer.getInventoryItem("phone")
		if(phone.count <= 0) then
			TriggerClientEvent('esx:showNotification', source, 'Nie możesz korzystac z ~b~Twittera~s~! Nie posiadasz ~r~telefonu~s~!')
		else
			local msg = args
			table.remove(msg, 1)
			local test = table.concat(msg, " ")
			test = test:gsub("%^1", "")
			test = test:gsub("%^2", "")
			test = test:gsub("%^3", "")
			test = test:gsub("%^4", "")
			test = test:gsub("%^5", "")
			test = test:gsub("%^6", "")
			test = test:gsub("%^7", "")
			test = test:gsub("%^8", "")
			test = test:gsub("%^9", "")
			local name = getIdentity(source)
			TriggerClientEvent('chat:addMessage', -1, { templateId = 'tweet', multiline = true, args = { "^4".. name.firstname .. " " .. name.lastname .."^0:", test } })
		end
	elseif args[1] == '/ogloszenie' then
			local xPlayer = ESX.GetPlayerFromId(source)
			local phone = xPlayer.getInventoryItem("phone")
			if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' or xPlayer.job.name == 'ambulance' and xPlayer.job.grade_name == 'boss' or xPlayer.job.name == 'mecano' and xPlayer.job.grade_name == 'boss' or xPlayer.job.name == 'cardealer' and xPlayer.job.grade_name == 'boss' or xPlayer.job.name == 'doj' and xPlayer.job.grade_name == 'boss' then
				if(phone.count <= 0) then
					TriggerClientEvent('esx:showNotification', source, 'Nie możesz korzystac z ~g~Ogloszenia~s~! Nie posiadasz ~r~telefonu~s~!')
				else
					if(xPlayer.getBank() >= 500) then
						local msg = args
						table.remove(msg, 1)
						local test = table.concat(msg, " ")
						test = test:gsub("%^1", "")
						test = test:gsub("%^2", "")
						test = test:gsub("%^3", "")
						test = test:gsub("%^4", "")
						test = test:gsub("%^5", "")
						test = test:gsub("%^6", "")
						test = test:gsub("%^7", "")
						test = test:gsub("%^8", "")
						test = test:gsub("%^9", "")
						local name = getIdentity(source)
						TriggerClientEvent('chat:addMessage', -1, { templateId = 'ogloszenie', multiline = true, args = { name.firstname .. " " .. name.lastname .. " ogłasza: ", test } })
						xPlayer.removeAccountMoney('bank', 500)
						TriggerClientEvent("pNotify:SendNotification", source, {text = 'Zapłacono ~g~500$~s~ za Ogłoszenie!', timeout=1500})
					else
						TriggerClientEvent('esx:showNotification', source, 'Nie masz pieniędzy w banku! Koszt wiadomości: ~g~500$~s~!')
					end
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nie masz uprawnień do tego!')
			end
		elseif args[1] == '/ad' then
			local xPlayer = ESX.GetPlayerFromId(source)
			local phone = xPlayer.getInventoryItem("phone")
			if xPlayer.job.name == 'taxi' or xPlayer.job2.name == 'tedbilcar' and xPlayer.job.grade_name == 'boss' then
				if(phone.count <= 0) then
					TriggerClientEvent('esx:showNotification', source, 'Nie możesz korzystac z ~y~Reklamy~s~! Nie posiadasz ~r~telefonu~s~!')
				else
					if(xPlayer.getBank() >= 500) then
						local msg = args
						table.remove(msg, 1)
						local test = table.concat(msg, " ")
						test = test:gsub("%^1", "")
						test = test:gsub("%^2", "")
						test = test:gsub("%^3", "")
						test = test:gsub("%^4", "")
						test = test:gsub("%^5", "")
						test = test:gsub("%^6", "")
						test = test:gsub("%^7", "")
						test = test:gsub("%^8", "")
						test = test:gsub("%^9", "")
						TriggerClientEvent('chat:addMessage', -1, { templateId = 'ad', multiline = true, args = { "^3^_Reklama:^r ", test } })
						xPlayer.removeAccountMoney('bank', 500)
						TriggerClientEvent("pNotify:SendNotification", source, {text = 'Zapłacono <b>500$</b> za Reklamę!', timeout=1500})
					else
						TriggerClientEvent('esx:showNotification', source, '~r~Nie masz~s~ pieniędzy w banku! Koszt wiadomości: ~g~500$~s~!')
					end
				end
			else
				TriggerClientEvent('esx:showNotification', source, '~r~Nie jesteś upoważniony do użycia reklamy!')
			end
	elseif args[1] == '/dw' or args[1] == '/darkweb' then
			local xPlayer = ESX.GetPlayerFromId(source)
			local phone = xPlayer.getInventoryItem("phone")
			if(phone.count <= 0) then
				TriggerClientEvent('esx:showNotification', source, 'Nie możesz korzystac z DarkWebu! Nie posiadasz ~r~telefonu~s~!')
			else
				if(xPlayer.getBank() >= 5000) then
					local msg = args
					table.remove(msg, 1)
					local name = getIdentity(source)
					TriggerClientEvent("anonTweet", -1, source, name.firstname .. " " .. name.lastname, table.concat(msg, " "),xPlayer.job.name)
					xPlayer.removeAccountMoney('bank', 5000)
					TriggerClientEvent("pNotify:SendNotification", source, {text = 'Zapłacono <b>5000$</b> za Darkweb!', timeout=1500})
				else
					TriggerClientEvent('esx:showNotification', source, '~r~Nie masz~s~ pieniędzy w banku! Koszt wiadomości: ~g~$5000~s~!')
				end
			end
	elseif args[1] == '/me' then
		local msg = args
		table.remove(msg, 1)
		local name = getIdentity(source)
		TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname .. " " .. name.lastname, table.concat(msg, " "))
	elseif args[1] == '/do' then
		local msg = args
		table.remove(msg, 1)
		local name = getIdentity(source)
		TriggerClientEvent("sendProximityMessageDo", -1, source, name.firstname .. " " .. name.lastname, table.concat(msg, " "))
	end
end)

TriggerEvent('es:addCommand', 'try', function(source, args, user)
    local name = getIdentity(source)
		local czy = math.random(1, 2)
    TriggerClientEvent("sendProximityMessageCzy", -1, source, source, table.concat(args, " "), czy)

		local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
	    for i = 1,#args do
	        text = text .. ' ' .. args[i]
	    end
		color = {r = 106, g = 212, b = 176, alpha = 255}
end)

RegisterServerEvent('srvsendProximityCmdMessage')
AddEventHandler('srvsendProximityCmdMessage', function(name, message)
	TriggerClientEvent("sendProximityCmdMessage", -1, source, name, message)
end)

RegisterServerEvent('esx_rpchat:kick')
AddEventHandler('esx_rpchat:kick', function()
	DropPlayer(source, 'AutoKick: Nadużywanie local ooc.')
end)

RegisterServerEvent('srvsendnoPoliceDark')
AddEventHandler('srvsendnoPoliceDark', function(name, message)
    TriggerClientEvent("noPoliceDark", -1, source, name, message, police)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	local xPlayer      = ESX.GetPlayerFromId(source)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
	TriggerEvent("logs:me", xPlayer.name, text)
	Wait(100)
end)

RegisterServerEvent('3ddo:shareDisplay')
AddEventHandler('3ddo:shareDisplay', function(text)
	local xPlayer      = ESX.GetPlayerFromId(source)
	TriggerClientEvent('3ddo:triggerDisplay', -1, text, source)
	TriggerEvent("logs:do", xPlayer.name, text)
	Wait(100)
end)

ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)


ESX.RegisterServerCallback('tpm:permisje', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if IsPlayerAceAllowed(source, "tpm.permisje") then
        cb(true)
    else
        cb(false)
    end
end)

TriggerEvent('es:addCommand', 'kosci', function(source, args, user)
	local _source = source
	TriggerClientEvent("esx_rpchat:kosci", _source)
end)