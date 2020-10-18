
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
			job = identity['job']
		}
	else
		return nil
	end
end

function LoadLicenses(source)
  TriggerEvent('dowod:getLicenses', source, function (licenses)
    TriggerClientEvent('dowod:loadLicenses', source, licenses)
  end)
end

function getJobName(jobname)
	local result = MySQL.Sync.fetchAll("SELECT * FROM jobs WHERE name = @identifier", {['@identifier'] = jobname})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			name = identity['name'],
			label = identity['label'],
		}
	else
		return nil
	end
end

TriggerEvent('es:addCommand', 'dowod', function(source, args, user)
	local _source = source
	local driving = nil
    local weapon  = nil
    local ubezpieczenie = nil
	TriggerEvent('esx_license:checkLicense', _source, "drive", function(stat)
		if (stat) then driving = "TAK" else driving = "NIE" end
	end)
	
	TriggerEvent('esx_license:checkLicense', _source, "weapon", function(stat)
		if (stat) then weapon = "TAK" else weapon = "NIE" end
	end)
	Citizen.Wait(100)
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local name = getIdentity(_source)
    local realname = name.firstname
	local realname2 = name.lastname
	local date = MySQL.Sync.fetchAll('SELECT insuranceDate FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier})
	date = tonumber(date[1].insuranceDate)
	local today = os.date("*t")
	local todaySecond = (today.year-1970) * 31556926 + today.day * 86400
	if date >= todaySecond then

		ubezpieczenie = "TAK"

		local dateSec = os.date("*t", date)

		if dateSec.day < 10 then
			day = '0' .. dateSec.day
		else
			day = dateSec.day
		end

		if dateSec.month < 10 then
			month = '0' .. dateSec.month
		else
			month = dateSec.month
		end
		year = dateSec.year

	else
		ubezpieczenie = "NIE"
	end

	local rawjob = xPlayer.getJob()
	local job = getJobName(rawjob.name)
	
	if(driving ~= nil and weapon ~= nil and ubezpieczenie ~= nil) then
		TriggerClientEvent("dowod:animka", _source)
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje swój dowód: '.. realname ..' '.. realname2 ..'', _source)
		TriggerClientEvent("dowod:DisplayId", -1, _source, realname, realname2, driving, weapon, job.label, ubezpieczenie)
	else
		TriggerClientEvent("dowod:animka", _source)
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje swój dowód: '.. realname ..' '.. realname2 ..'', _source)
		TriggerClientEvent("dowod:DisplayId", -1, _source, realname, realname2, "Brak", "Brak", job.label, ubezpieczenie)
	end
end)

RegisterNetEvent('dowod:pokaz')
AddEventHandler('dowod:pokaz', function()
	local _source = source
	local driving = nil
    local weapon  = nil
    local ubezpieczenie = nil
	TriggerEvent('esx_license:checkLicense', _source, "drive", function(stat)
		if (stat) then driving = "TAK" else driving = "NIE" end
	end)
	
	TriggerEvent('esx_license:checkLicense', _source, "weapon", function(stat)
		if (stat) then weapon = "TAK" else weapon = "NIE" end
	end)
	Citizen.Wait(100)
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local name = getIdentity(_source)
    local realname = name.firstname
	local realname2 = name.lastname
	local date = MySQL.Sync.fetchAll('SELECT insuranceDate FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier})
	date = tonumber(date[1].insuranceDate)
	local today = os.date("*t")
	local todaySecond = (today.year-1970) * 31556926 + today.day * 86400
	if date >= todaySecond then

		ubezpieczenie = "TAK"

		local dateSec = os.date("*t", date)

		if dateSec.day < 10 then
			day = '0' .. dateSec.day
		else
			day = dateSec.day
		end

		if dateSec.month < 10 then
			month = '0' .. dateSec.month
		else
			month = dateSec.month
		end
		year = dateSec.year
	else
		ubezpieczenie = "NIE"
	end

	local rawjob = xPlayer.getJob()
	local job = getJobName(rawjob.name)
	
	if(driving ~= nil and weapon ~= nil and ubezpieczenie ~= nil) then
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje swój dowód: '.. realname ..' '.. realname2 ..'', _source)
		TriggerClientEvent("dowod:DisplayId", -1, _source, realname, realname2, driving, weapon, job.label, ubezpieczenie)
	else
		TriggerClientEvent('3dme:triggerDisplay', -1, 'pokazuje swój dowód: '.. realname ..' '.. realname2 ..'', _source)
		TriggerClientEvent("dowod:DisplayId", -1, _source, realname, realname2, "Brak", "Brak", job.label, ubezpieczenie)
	end
end)

function getIdentity2(source)

	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})

	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			name = identity['name'],
			phone_number = identity['phone_number'],
			bankaccountnumber = identity['bankaccountnumber']
                        
		}
	else
		return nil
	end 
end

TriggerEvent('es:addCommand', 'wizytowka', function(source, args, user)
	local _source = source
	local name = getIdentity2(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local rname = name.firstname
	local numer = name.phone_number
	local bankaccount = name.bankaccountnumber
	if numer == nil or bankaccount == nil then
		TriggerClientEvent('3dme:triggerDisplay', -1, 'podaje wizytówkę: '.. rname ..' - Brak konta', _source)
		TriggerClientEvent("aurarp:wizytowka", -1, _source, rname, "Brak numeru", "Brak konta")
	else
		TriggerClientEvent('3dme:triggerDisplay', -1, 'podaje wizytówkę: '.. rname ..' - '.. name.phone_number ..' - '.. name.bankaccountnumber ..'', _source)
		TriggerClientEvent("aurarp:wizytowka", -1, _source, rname, name.phone_number, name.bankaccountnumber)
	end
end)

TriggerEvent('es:addCommand', 'opis', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    if args[1] ~= nil then
        local text = table.concat(args, " ",1)
        TriggerClientEvent('identification:opis', -1, source, ''..text..'')
	else
		TriggerClientEvent('identification:opis', -1, source, '')
	end
end)