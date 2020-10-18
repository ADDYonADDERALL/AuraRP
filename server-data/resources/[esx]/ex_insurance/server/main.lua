ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('ex_insurance:buyInsurance', function(source, cb, price, days)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dateLast = nil

	if xPlayer.getMoney() >= price then

		dateLast = MySQL.Sync.fetchAll('SELECT insuranceDate FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier})
		dateLast = dateLast[1].insuranceDate

		local date = os.date("*t")

		local sec = (date.year-1970) * 31556926 + date.day * 86400 + days * 86400

		if tonumber(dateLast) >= sec then
			sec = tonumber(dateLast) + days * 86400
		end

		local maxWeek = (date.year-1970) * 31556926 + date.day * 86400 + Config.MaxWeekForward * 7 * 86400

		if sec <= maxWeek then

			xPlayer.removeMoney(price)

			local dateSec = os.date("*t", sec)

			if dateSec.day < 10 then
				day = '0' .. dateSec.day
			else
				day = dateSec.day
			end

			if dateSec.month < 10 then
				month = '0' .. dateSec.month+3
			else
				month = dateSec.month+3
			end
			year = dateSec.year

			MySQL.Sync.execute("UPDATE users SET insuranceDate=@date WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@date'] = sec})

			TriggerClientEvent('esx:showNotification', source, 'Zakupione ubezpieczenie jest ważne do ' .. year .. '-' .. month .. '-' .. day)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
				account.addMoney(price)
			end)

		else

			TriggerClientEvent('esx:showNotification', source, 'Nie mozesz wykupić ubezpieczenia na dlużej niż ' .. Config.MaxWeekForward .. ' tygodnie')

		end

	else
		TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczająco pieniędzy przy sobie')
	end
end)

ESX.RegisterServerCallback('ex_insurance:checkInsurance', function(source, cb, player)
	local xPlayer
	if player == nil then
		xPlayer = ESX.GetPlayerFromId(source)
	else
		xPlayer = ESX.GetPlayerFromId(player)
	end

	if xPlayer ~= nil then

		local date = MySQL.Sync.fetchAll('SELECT insuranceDate FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier})
		date = tonumber(date[1].insuranceDate)

		local today = os.date("*t")

		local todaySecond = (today.year-1970) * 31556926 + today.day * 86400

		if date >= todaySecond then

			local dateSec = os.date("*t", date)

			if dateSec.day < 10 then
				day = '0' .. dateSec.day
			else
				day = dateSec.day
			end

			if dateSec.month < 10 then
				month = '0' .. dateSec.month+3
			else
				month = dateSec.month+3
			end
			year = dateSec.year

			TriggerClientEvent('esx:showNotification', source, 'Ubezpieczenie jest zakupione do dnia ' .. year .. '-' .. month .. '-' .. day)

		else

			TriggerClientEvent('esx:showNotification', source, 'Brak wykupionego ubezpieczenia!')

		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Brak gracza o takim ID')

	end
end)
