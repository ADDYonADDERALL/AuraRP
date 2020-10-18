ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getlevel(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll(
		"SELECT * FROM expsystem WHERE identifier = @identifier", 
		{
			['@identifier'] = identifier
		}
	)
	if result[1] ~= nil then
		local staty = result[1]

		return {
			identifier = staty['identifier'],
			truckerlvl = staty['truckerlvl'],
			truckerexp = staty['truckerexp'],
		}
	else
		return nil
	end
end

RegisterServerEvent('sandyrp:savexptrucker')
AddEventHandler('sandyrp:savexptrucker', function(boxnumber)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcekurierlvl = pobierzdane.truckerlvl
	local sourcekurierexp = pobierzdane.truckerexp
    if boxnumber >= 10 then
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET truckerlvl = @truckerlvl, truckerexp = @truckerexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@truckerlvl'] 		= sourcekurierlvl,
					['@truckerexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level MEXA TRANS!')
			TriggerEvent("sandyrp:truckerpay", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET truckerlvl = @truckerlvl, truckerexp = @truckerexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@truckerlvl'] 		= sourcekurierlvl,
					['@truckerexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:truckerpay", _source, sourcekurierlvl)
		end
	end
end)

RegisterServerEvent('sandyrp:truckerpay')
AddEventHandler('sandyrp:truckerpay', function(source,sourcekurierlvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = Config.boxcash
    local kurwakasa = nil
    if sourcekurierlvl == 0 then
        kurwakasa = 1
    elseif sourcekurierlvl > 50 then
        kurwakasa = 50/100
    else
        kurwakasa = (sourcekurierlvl/100)
    end
    kurwakasa = kurwakasa + 1
    local kurwasuperkasa = cash*kurwakasa
    kurwasuperkasa = math.floor(kurwasuperkasa)
    xPlayer.addMoney(kurwasuperkasa)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_trucker', function(account)
		truckerAccount = account
	end)
	truckerAccount.addMoney(kurwasuperkasa * 0.25)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za oddanie ladunku!')
end)

RegisterServerEvent('sandyrp:savexptrucker2')
AddEventHandler('sandyrp:savexptrucker2', function(noofboxes)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if noofboxes == 5 then
        xPlayer.addMoney(2500)
        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano premią w wysokości $2500 za dostarczenie wszystkich przesyłek.')
	    local identifier = xPlayer.identifier
		local pobierzdane = getlevel(_source)
		local sourceidentifier = pobierzdane.identifier
		local sourcekurierlvl = pobierzdane.truckerlvl
		local sourcekurierexp = pobierzdane.truckerexp
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET truckerlvl = @truckerlvl, truckerexp = @truckerexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@truckerlvl'] 		= sourcekurierlvl,
					['@truckerexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level MEXA TRANS!')
			TriggerEvent("sandyrp:truckerpay2", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET truckerlvl = @truckerlvl, truckerexp = @truckerexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@truckerlvl'] 		= sourcekurierlvl,
					['@truckerexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:truckerpay2", _source, sourcekurierlvl)
		end
	end
end)

RegisterServerEvent('sandyrp:truckerpay2')
AddEventHandler('sandyrp:truckerpay2', function(source,sourcekurierlvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = Config.truckdeliverycash
    local kurwakasa = nil
    if sourcekurierlvl == 0 then
        kurwakasa = 1
    elseif sourcekurierlvl > 50 then
        kurwakasa = 50/100
    else
        kurwakasa = (sourcekurierlvl/100)
    end
    kurwakasa = kurwakasa + 1
    local kurwasuperkasa = cash*kurwakasa
    kurwasuperkasa = math.floor(kurwasuperkasa)
    xPlayer.addMoney(kurwasuperkasa)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_trucker', function(account)
		truckerAccount = account
	end)
	truckerAccount.addMoney(kurwasuperkasa * 0.25)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za dostawe wina!')
end)