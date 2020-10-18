ESX = nil
local Jobs = {}
local RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

AddEventHandler('esx_societymordo:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_societymordo:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_societymordo:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_societymordo:withdrawMoney')
AddEventHandler('esx_societymordo:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_societymordo: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
			TriggerEvent("logs:konafirmyremove", society.name, xPlayer.name, xPlayer.identifier, source, amount)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_societymordo:depositMoney')
AddEventHandler('esx_societymordo:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_societymordo: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
		TriggerEvent("logs:konafirmyadd", society.name, xPlayer.name, xPlayer.identifier, source, amount)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

ESX.RegisterServerCallback('esx_societymordo:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_societymordo:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_societymordo:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)


ESX.RegisterServerCallback('esx_societymordo:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_societymordo: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_societymordo:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_societymordo:getPlayersInArea', function(source, cb, sId)
	local players  = {}
	for i=1, #sId, 1 do
		local xPlayer = ESX.GetPlayerFromId(sId[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end
	cb(players)
end)

ESX.RegisterServerCallback('esx_societymordo:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_societymordo: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

--- CRIME

AddEventHandler('esx_societycrime:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)


AddEventHandler('esx_societycrime:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_societycrime:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_societycrime:withdrawMoney')
AddEventHandler('esx_societycrime:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job2.name ~= society then
		print(('esx_societycrime: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
			TriggerEvent("logs:konafirmyremove", society, xPlayer.name, xPlayer.identifier, source, amount)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_societycrime:depositMoney')
AddEventHandler('esx_societycrime:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job2.name ~= society then
		print(('esx_societycrime: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
		TriggerEvent("logs:konafirmyadd", society, xPlayer.name, xPlayer.identifier, source, amount)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

ESX.RegisterServerCallback('esx_societycrime:getSocietyMoney', function(source, cb, societyName)

	if societyName then
		TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_societycrime:getEmployees', function(source, cb, society)

  if Config.EnableESXIdentity then
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job2 = @job2 ORDER BY job2_grade DESC',
      { ['@job2'] = society },
      function (results)
        local employees = {}

        for i=1, #results, 1 do
          table.insert(employees, {
            name        = results[i].firstname .. ' ' .. results[i].lastname,
            identifier  = results[i].identifier,
            job2 = {
              name        = results[i].job2,
              label       = Jobs[results[i].job2].label,
              grade       = results[i].job2_grade,
              grade_name  = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].name,
              grade_label = Jobs[results[i].job2].grades[tostring(results[i].job2_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE job2 = @job2 ORDER BY job2_grade DESC',
      { ['@job2'] = society },
      function (result)
        local employees = {}

        for i=1, #result, 1 do
          table.insert(employees, {
            name        = result[i].name,
            identifier  = result[i].identifier,
            job2 = {
              name        = result[i].job2,
              label       = Jobs[result[i].job2].label,
              grade       = result[i].job2_grade,
              grade_name  = Jobs[result[i].job2].grades[tostring(result[i].job2_grade)].name,
              grade_label = Jobs[result[i].job2].grades[tostring(result[i].job2_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_societycrime:getJob', function(source, cb, society)

  local job2    = json.decode(json.encode(Jobs[society]))
  local grades = {}

  for k,v in pairs(job2.grades) do
    table.insert(grades, v)
  end

  table.sort(grades, function(a, b)
    return a.grade < b.grade
  end)

  job2.grades = grades

  cb(job2)

end)

ESX.RegisterServerCallback('esx_societycrime:setJob', function(source, cb, identifier, job2, grade2, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job2.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob2(job2, grade2)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job2))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getJob2().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier', {
				['@job2']        = job2,
				['@job2_grade']  = grade2,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_societycrime: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_societycrime:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job2        = xPlayer.job2
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_societycrime:getPlayersInArea', function(source, cb, sId)
	local players  = {}
	for i=1, #sId, 1 do
		local xPlayer = ESX.GetPlayerFromId(sId[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job2        = xPlayer.job2
		})
	end
	cb(players)
end)

ESX.RegisterServerCallback('esx_societycrime:isBoss', function(source, cb, job2)
	cb(isPlayerBossCRIME(source, job2))
end)

function isPlayerBossCRIME(playerId, job2)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job2.name == job2 and xPlayer.job2.grade_name == 'boss' then
		return true
	else
		print(('esx_societycrime: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end
