ESX = nil

local playergrapes = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function collectgrapes(source)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local grapeslimit = xPlayer.getInventoryItem('grapes')
	SetTimeout(10000, function()
		if playergrapes[_source] == true then
			if grapeslimit.count >= 50 then
				TriggerClientEvent('sandy_vineyard:zaduzo', _source)
				TriggerClientEvent('sandy_vineyard:freezeplayer', _source, false)
			else
				xPlayer.addInventoryItem('grapes', 1)
				collectgrapes(_source)
			end
		end
	end)
end

RegisterServerEvent('sandy_vineyard:collectgrapes')
AddEventHandler('sandy_vineyard:collectgrapes', function()
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	
	playergrapes[source] = true
	TriggerClientEvent('sandy_vineyard:freezeplayer', _source, true)
	TriggerClientEvent('esx:showNotification', _source, 'Zbieranie winogron w toku...')
	collectgrapes(_source)
end)

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
			winiarzlvl = staty['winiarzlvl'],
			winiarzexp = staty['winiarzexp'],
		}
	else
		return nil
	end
end

RegisterServerEvent('sandyrp:savexpwiniarz')
AddEventHandler('sandyrp:savexpwiniarz', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcekurierlvl = pobierzdane.winiarzlvl
	local sourcekurierexp = pobierzdane.winiarzexp
	local kwitamount = xPlayer.getInventoryItem('grapes').count
    if kwitamount > 49 then
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET winiarzlvl = @winiarzlvl, winiarzexp = @winiarzexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@winiarzlvl'] 		= sourcekurierlvl,
					['@winiarzexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level winiarza!')
			TriggerEvent("sandyrp:winiarzpay", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET winiarzlvl = @winiarzlvl, winiarzexp = @winiarzexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@winiarzlvl'] 		= sourcekurierlvl,
					['@winiarzexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:winiarzpay", _source, sourcekurierlvl)
		end
	else
		TriggerClientEvent('sandy_vineyard:zamalo', _source)
	end
end)

RegisterServerEvent('sandyrp:winiarzpay')
AddEventHandler('sandyrp:winiarzpay', function(source,sourcekurierlvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = Config.grapescash
	local kwitamount = xPlayer.getInventoryItem('grapes').count
    xPlayer.removeInventoryItem('grapes', kwitamount)
    local kurwakasa = nil
    if sourcekurierlvl == 0 then
        kurwakasa = 1
    elseif sourcekurierlvl > 50 then
        kurwakasa = 50/100
    else
        kurwakasa = (sourcekurierlvl/100)
    end
    kurwakasa = kurwakasa + 1
    local kurwasuperkasa = cash*kwitamount*kurwakasa
    kurwasuperkasa = math.floor(kurwasuperkasa)
    xPlayer.addMoney(kurwasuperkasa)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vineyard', function(account)
		vineyardAccount = account
	end)
	vineyardAccount.addMoney(kurwasuperkasa * 0.25)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za oddanie winogron!')
end)

RegisterServerEvent('sandyrp:savexpwiniarz2')
AddEventHandler('sandyrp:savexpwiniarz2', function(info)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if info == 'anulowanie' then
        xPlayer.addMoney(500)
        TriggerClientEvent('esx:showNotification', _source, 'Zwrócono niepełną kaucję w wysokości $500 za anulowanie zleceń.')
    elseif info == 'zakonczenie' then
        xPlayer.addMoney(2500)
        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano premią w wysokości $2500 za dostarczenie wszystkich przesyłek.')
	    local identifier = xPlayer.identifier
		local pobierzdane = getlevel(_source)
		local sourceidentifier = pobierzdane.identifier
		local sourcekurierlvl = pobierzdane.winiarzlvl
		local sourcekurierexp = pobierzdane.winiarzexp
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET winiarzlvl = @winiarzlvl, winiarzexp = @winiarzexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@winiarzlvl'] 		= sourcekurierlvl,
					['@winiarzexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level winiarza!')
			TriggerEvent("sandyrp:winiarzpay2", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET winiarzlvl = @winiarzlvl, winiarzexp = @winiarzexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@winiarzlvl'] 		= sourcekurierlvl,
					['@winiarzexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:winiarzpay2", _source, sourcekurierlvl)
		end
    end
end)

RegisterServerEvent('sandyrp:winiarzpay2')
AddEventHandler('sandyrp:winiarzpay2', function(source,sourcekurierlvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = Config.winecash
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
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vineyard', function(account)
		vineyardAccount = account
	end)
	vineyardAccount.addMoney(kurwasuperkasa * 0.25)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za dostawe wina!')
end)

ESX.RegisterUsableItem('grapes', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('grapes', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 5000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 5000)
end)

RegisterServerEvent('sandy_vineyard:stopgather')
AddEventHandler('sandy_vineyard:stopgather', function()
	local _source = source
	playergrapes[_source] = false
end)