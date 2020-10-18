ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandy_laundry:getpay')
AddEventHandler('sandy_laundry:getpay', function(amountdone)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local steamhex = GetPlayerIdentifier(_source)
	local blackmoneyamount = xPlayer.getAccount('black_money').money
	local price = 15000
	local extrapay = ((amountdone*price)/10)*2
	local payday = extrapay+price
	payday = math.floor(payday)
	if blackmoneyamount >= payday then  
		xPlayer.removeAccountMoney('black_money', payday)
		xPlayer.addMoney(payday)
		TriggerClientEvent('esx:showNotification', _source, 'Wyprales ' .. payday .. '$')
		TriggerEvent('logs:pranie', xPlayer.name, payday, _source, steamhex)
		local blackmoneyamountagain = xPlayer.getAccount('black_money').money
		if blackmoneyamountagain >= payday then
			TriggerClientEvent('sandy_laundry:getnextdestination', _source)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz wiecej brudnych pieniędzy!')
			TriggerClientEvent('sandy_laundry:removedestination', _source)
		end
	else
		xPlayer.removeAccountMoney('black_money', blackmoneyamount)
		xPlayer.addMoney(blackmoneyamount)
		TriggerClientEvent('esx:showNotification', _source, 'Wyprales ' .. blackmoneyamount .. '$')
		TriggerEvent('logs:pranie', xPlayer.name, blackmoneyamount, _source, steamhex)
		TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz wiecej brudnych pieniędzy!')
		TriggerClientEvent('sandy_laundry:removedestination', _source)
	end
end)