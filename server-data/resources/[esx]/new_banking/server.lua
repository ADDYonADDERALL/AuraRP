--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil

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

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local steamhex = GetPlayerIdentifier(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('bank:result', _source, "error", "Wplata nieudana.")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('bank:result', _source, "success", "Pieniadze wplacone. Dziekujemy za zaufanie.")
		TriggerEvent('logs:banksdeposit', xPlayer.identifier, steamhex, xPlayer.name, tonumber(amount))
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local steamhex = GetPlayerIdentifier(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('bank:result', _source, "error", "Wyplata nieudana.")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('bank:result', _source, "success", "Wyplaciles pieniadze. Zyczymy udanych zakupow")
		TriggerEvent('logs:bankswithdraw', xPlayer.identifier, steamhex, xPlayer.name, tonumber(amount))
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
    local name = getIdentity(_source)
    TriggerClientEvent('currentbalance1', _source, balance, name.firstname, name.lastname)
end)



RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local identifier = xPlayer.identifier
    local steamhex = GetPlayerIdentifier(_source)
	local balance = 0
	local found = false
	MySQL.Async.fetchAll(
	'SELECT * FROM users WHERE bankaccountnumber = @bankaccountnumber',
	{ 
		['@bankaccountnumber'] = to
	},
	function (result)
		if result[1] ~= nil then
			local targetbankaccount = result[1].bankaccountnumber
			local targetbabkbalance = result[1].bank
			local targetidentifier = result[1].identifier
			MySQL.Async.fetchAll(
			'SELECT * FROM users WHERE identifier = @identifier',
			{ 
				['@identifier'] = identifier
			},
			function (result2)
				if result2[1] ~= nil then
					local sourcebankaccount = result2[1].bankaccountnumber
					if targetbankaccount == sourcebankaccount then
						TriggerClientEvent('bank:result', _source, "error", "Przelew nieudany.")
						TriggerClientEvent('esx:showNotification', _source, "~r~Przelew nieudany.")
					else
						balance = xPlayer.getAccount('bank').money
						if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
							TriggerClientEvent('bank:result', _source, "error", "Przelew nieudany.")
							TriggerClientEvent('esx:showNotification', _source, "~r~Przelew nieudany.")
						else
							local newtargetbabkbalance = targetbabkbalance + amountt
							xPlayer.removeAccountMoney('bank', tonumber(amountt))
							for i=1, #xPlayers, 1 do
								local xPlayerx = ESX.GetPlayerFromId(xPlayers[i])
								if xPlayerx.identifier == targetidentifier then
									xPlayerx.addAccountMoney('bank', tonumber(amountt))
									found = true
									TriggerClientEvent('esx:showNotification', xPlayers[i], "~g~Otrzymales przelew!\nZ numeru konta: ~y~"..sourcebankaccount)
									ESX.SavePlayers()
									local steamid = xPlayer.identifier
									local name = GetPlayerName(_source)
									local message = name.." Przelew \n[Kwota: "..amountt.." | Numer Konta/HEX "..targetidentifier.."] \n[ID: ".._source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
									TriggerEvent('logs:bankssend', message)
								end
							end
							if not found then
								MySQL.Async.execute(
									'UPDATE users SET bank = @bank WHERE bankaccountnumber = @bankaccountnumber',
									{
										['@bankaccountnumber'] = targetbankaccount,
										['@bank'] = newtargetbabkbalance
									}
								)
								local steamid = xPlayer.identifier
								local name = GetPlayerName(_source)
								local message = name.." Przelew \n[Kwota: "..item.." | Numer Konta/HEX "..targetbankaccount.."] \n[ID: ".._source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
								TriggerEvent('logs:bankssend', message)
							end
							TriggerClientEvent('bank:result', _source, "success", "Pieniadze zostaly przelane na inne konto.")
							TriggerClientEvent('esx:showNotification', _source, "~g~Pieniadze zostaly przelane na inne konto.")
						end
					end
				else
					TriggerClientEvent('bank:result', _source, "error", "Przelew nieudany.")
					TriggerClientEvent('esx:showNotification', _source, "~r~Przelew nieudany.")
				end
			end
			)
		else
			TriggerClientEvent('bank:result', _source, "error", "Przelew nieudany.")
			TriggerClientEvent('esx:showNotification', _source, "~r~Przelew nieudany.")
		end
	end
	)
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
    local name = getIdentity(_source)
    TriggerClientEvent('currentbalance1', _source, balance, name.firstname, name.lastname)
end)

RegisterServerEvent('sandybanking:createaccount')
AddEventHandler('sandybanking:createaccount', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeAccountMoney('bank', 10000)
	local cardnumber = generateaccountnumber()
	local cardpin = math.random(1111,9999)
	MySQL.Async.execute(
		'UPDATE users SET bankaccountnumber = @bankaccountnumber, bankpin = @bankpin WHERE identifier = @identifier',
		{
			['@identifier']   = xPlayer.identifier,
			['@bankaccountnumber'] = cardnumber,
			['@bankpin'] = cardpin
		}
	)
	TriggerClientEvent('esx:showNotification', _source, '~b~BANK~w~\nNumer karty: ~y~'..cardnumber..'~w~\nPIN: ~r~'..cardpin)
end)

RegisterServerEvent('sandybanking:resetpin')
AddEventHandler('sandybanking:resetpin', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeAccountMoney('bank', 5000)
	local cardpin = math.random(1111,9999)
	MySQL.Async.execute(
		'UPDATE users SET bankpin = @bankpin WHERE identifier = @identifier',
		{
			['@identifier']   = xPlayer.identifier,
			['@bankpin'] = cardpin
		}
	)
	TriggerClientEvent('esx:showNotification', _source, '~b~BANK~w~\nPIN: ~r~'..cardpin)
end)


function generateaccountnumber()
    local running = true
    local cardnumber = nil
    while running do
        local rand = '' .. math.random(11111111,99999999)
        local count = MySQL.Sync.fetchScalar("SELECT COUNT(bankaccountnumber) FROM users WHERE bankaccountnumber = @bankaccountnumber", { ['@bankaccountnumber'] = rand })
        if count < 1 then
            cardnumber = rand
            running = false
        end
    end
    return cardnumber
end

ESX.RegisterServerCallback('sandybanking:checkpin', function (source, cb, pin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT bankpin FROM users WHERE identifier = @identifier AND bankpin = @bankpin',
	{ 
		['@identifier'] = identifier,
		['@bankpin'] = pin
	},
	function (result2)
		if result2[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
	)
end)