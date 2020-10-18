ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--SECONDJOBY

RegisterServerEvent('esxjobs:setJob')
AddEventHandler('esxjobs:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if job == 'taxi'then
		MySQL.Async.execute(
			'UPDATE users SET `job` = @job WHERE identifier = @identifier',
			{
				  ['@job']   = 'taxi',
				  ['@identifier'] = xPlayer.identifier
			}
		)
		MySQL.Async.execute(
			'UPDATE users SET `job_grade` = @job_grade WHERE identifier = @identifier',
			{
				  ['@job_grade']   = 0,
				  ['@identifier'] = xPlayer.identifier
			}
		)
		xPlayer.setJob('taxi', 0)
		TriggerClientEvent('esx:showNotification', source, 'Zatrudniles sie jako ~y~TAXI')
 	elseif job == 'deliverer'then
	 	MySQL.Async.execute(
			'UPDATE users SET `job` = @job WHERE identifier = @identifier',
			{
				  ['@job']   = 'deliverer',
				  ['@identifier'] = xPlayer.identifier
			}
		)
		MySQL.Async.execute(
			'UPDATE users SET `job_grade` = @job_grade WHERE identifier = @identifier',
			{
				  ['@job_grade']   = 0,
				  ['@identifier'] = xPlayer.identifier
			}
		)
		xPlayer.setJob('deliverer', 0)
		TriggerClientEvent('esx:showNotification', source, 'Zatrudniles sie jako ~y~KURIER')
	elseif job == 'fisherman'then
		MySQL.Async.execute(
			'UPDATE users SET `job` = @job WHERE identifier = @identifier',
			{
				  ['@job']   = 'fisherman',
				  ['@identifier'] = xPlayer.identifier
			}
		)
		MySQL.Async.execute(
			'UPDATE users SET `job_grade` = @job_grade WHERE identifier = @identifier',
			{
				  ['@job_grade']   = 0,
				  ['@identifier'] = xPlayer.identifier
			}
		)
		xPlayer.setJob('fisherman', 0)
		TriggerClientEvent('esx:showNotification', source, 'Zatrudniles sie jako ~y~RYBAK')
	end
end)
