ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandyfaktura:checkfaktura')
AddEventHandler('sandyfaktura:checkfaktura', function(target,count,kurwapraca)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetaccount = targetXPlayer.getAccount('bank')
	if kurwapraca == 'ambulance' then
		TriggerClientEvent('esx:showNotification', source, '~g~Wystawiles fakture!; Czekasz na podpis')
		TriggerClientEvent('sandyfaktura:clientconfirm', target, count, _source, kurwapraca)
	else
		if targetaccount.money >= count then
			TriggerClientEvent('esx:showNotification', source, '~g~Wystawiles fakture!; Czekasz na podpis')
			TriggerClientEvent('sandyfaktura:clientconfirm', target, count, _source, kurwapraca)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~'..target..' Nie ma tyle pieniedzy')
			TriggerClientEvent('esx:showNotification', target, '~r~Nie masz tyle pieniedzy')
		end
	end
end)

RegisterServerEvent('sandyfaktura:checkfakturasecond')
AddEventHandler('sandyfaktura:checkfakturasecond', function(target,count,kurwapraca)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetaccount = targetXPlayer.getAccount('bank')

	if targetaccount.money >= count then
		TriggerClientEvent('esx:showNotification', source, '~g~Wystawiles fakture!; Czekasz na podpis')
		TriggerClientEvent('sandyfaktura:clientconfirmsecond', target, count, _source, kurwapraca)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~'..target..' Nie ma tyle pieniedzy')
		TriggerClientEvent('esx:showNotification', target, '~r~Nie masz tyle pieniedzy')
	end
end)

RegisterServerEvent('sandyfaktura:fakturacorrect')
AddEventHandler('sandyfaktura:fakturacorrect', function(count,konfident,kurwapraca)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local konfidentXPlayer = ESX.GetPlayerFromId(konfident)
	local sourceaccount = sourceXPlayer.getAccount('bank')
	if kurwapraca == 'ambulance' then
		sourceXPlayer.removeAccountMoney('bank', count)
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. kurwapraca, function(account)
			account.addMoney(count)
		end)
		TriggerClientEvent('esx:showNotification', konfident, 'Wystawiles ~y~ID: '..source..'~w~ fakture na ~g~'..count..'$')
		TriggerClientEvent('esx:showNotification', source, 'Zaplaciles ~y~ID: '..konfident..'~w~ fakture za ~g~'..count..'$')

		local pobierzdanekonfident = getIdentity(konfident)
		local pobierzdanesource = getIdentity(_source)
		local konfidentimie = pobierzdanekonfident.firstname
		local konfidentnazwisko = pobierzdanekonfident.lastname
		local konfidentpelneimie = konfidentimie .. ' ' .. konfidentnazwisko
		local sourceimie = pobierzdanesource.firstname
		local sourcenazwisko = pobierzdanesource.lastname
		local sourcepelneimie = sourceimie .. ' ' .. sourcenazwisko
		local czas = os.date("%y/%m/%d %X")

		MySQL.Sync.execute(
		'INSERT INTO faktury (praca, worker, client, price, date, workersteamid, clientsteamid) VALUES (@praca, @worker, @client, @price, @date, @workersteamid, @clientsteamid)',
		{
			['@praca'] = kurwapraca,
			['@worker']   = konfidentpelneimie,
			['@client'] = sourcepelneimie,
			['@price'] = count,
			['@date'] = czas,
			['@workersteamid'] = konfidentXPlayer.identifier,
			['@clientsteamid'] = sourceXPlayer.identifier
		}
		)
		TriggerEvent("logs:faktury", kurwapraca, konfident, konfidentXPlayer.identifier, konfidentXPlayer.name, _source, sourceXPlayer.identifier, sourceXPlayer.name, count)
	else
		if sourceaccount.money >= count then
			sourceXPlayer.removeAccountMoney('bank', count)
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. kurwapraca, function(account)
				account.addMoney(count)
			end)
			TriggerClientEvent('esx:showNotification', konfident, 'Wystawiles ~y~ID: '..source..'~w~ fakture na ~g~'..count..'$')
			TriggerClientEvent('esx:showNotification', source, 'Zaplaciles ~y~ID: '..konfident..'~w~ fakture za ~g~'..count..'$')

			local pobierzdanekonfident = getIdentity(konfident)
			local pobierzdanesource = getIdentity(_source)
			local konfidentimie = pobierzdanekonfident.firstname
			local konfidentnazwisko = pobierzdanekonfident.lastname
			local konfidentpelneimie = konfidentimie .. ' ' .. konfidentnazwisko
			local sourceimie = pobierzdanesource.firstname
			local sourcenazwisko = pobierzdanesource.lastname
			local sourcepelneimie = sourceimie .. ' ' .. sourcenazwisko
			local czas = os.date("%y/%m/%d %X")

			MySQL.Sync.execute(
			'INSERT INTO faktury (praca, worker, client, price, date, workersteamid, clientsteamid) VALUES (@praca, @worker, @client, @price, @date, @workersteamid, @clientsteamid)',
			{
				['@praca'] = kurwapraca,
				['@worker']   = konfidentpelneimie,
				['@client'] = sourcepelneimie,
				['@price'] = count,
				['@date'] = czas,
				['@workersteamid'] = konfidentXPlayer.identifier,
				['@clientsteamid'] = sourceXPlayer.identifier
				}
			)
			TriggerEvent("logs:faktury", kurwapraca, konfident, konfidentXPlayer.identifier, konfidentXPlayer.name, _source, sourceXPlayer.identifier, sourceXPlayer.name, count)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~'..target..' Nie ma tyle pieniedzy')
			TriggerClientEvent('esx:showNotification', target, '~r~Nie masz tyle pieniedzy')
		end
	end
end)

RegisterServerEvent('sandyfaktura:fakturacorrectsecond')
AddEventHandler('sandyfaktura:fakturacorrectsecond', function(count,konfident,kurwapraca)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local konfidentXPlayer = ESX.GetPlayerFromId(konfident)
	local sourceaccount = sourceXPlayer.getAccount('bank')
	
	if sourceaccount.money >= count then
		sourceXPlayer.removeAccountMoney('bank', count)
		TriggerEvent('esx_addonaccount:getSharedAccount', kurwapraca, function(account)
			account.addMoney(count)
		end)
		TriggerClientEvent('esx:showNotification', konfident, 'Wystawiles ~y~ID: '..source..'~w~ fakture na ~g~'..count..'$')
		TriggerClientEvent('esx:showNotification', source, 'Zaplaciles ~y~ID: '..konfident..'~w~ fakture za ~g~'..count..'$')

		local pobierzdanekonfident = getIdentity(konfident)
		local pobierzdanesource = getIdentity(_source)
		local konfidentimie = pobierzdanekonfident.firstname
		local konfidentnazwisko = pobierzdanekonfident.lastname
		local konfidentpelneimie = konfidentimie .. ' ' .. konfidentnazwisko
		local sourceimie = pobierzdanesource.firstname
		local sourcenazwisko = pobierzdanesource.lastname
		local sourcepelneimie = sourceimie .. ' ' .. sourcenazwisko
		local czas = os.date("%y/%m/%d %X")

		MySQL.Sync.execute(
		'INSERT INTO faktury (praca, worker, client, price, date, workersteamid, clientsteamid) VALUES (@praca, @worker, @client, @price, @date, @workersteamid, @clientsteamid)',
		{
			['@praca'] = kurwapraca,
			['@worker']   = konfidentpelneimie,
			['@client'] = sourcepelneimie,
			['@price'] = count,
			['@date'] = czas,
			['@workersteamid'] = konfidentXPlayer.identifier,
			['@clientsteamid'] = sourceXPlayer.identifier
			}
		)
		TriggerEvent("logs:faktury", kurwapraca, konfident, konfidentXPlayer.identifier, konfidentXPlayer.name, _source, sourceXPlayer.identifier, sourceXPlayer.name, count)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~'..target..' Nie ma tyle pieniedzy')
		TriggerClientEvent('esx:showNotification', target, '~r~Nie masz tyle pieniedzy')
	end
end)

ESX.RegisterServerCallback('sandyfaktura:showfaktures', function(source, cb, kurwapraca)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT * FROM faktury WHERE praca = @praca',
	{
		['@praca'] = kurwapraca
	},
	function(result2)
		local dane = {}
		for i=1, #result2, 1 do
			local daneData = (result2[i])
			table.insert(dane, daneData)
		end
		cb(dane)
	end
	)
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname']
		}
	else
		return nil
	end
end
