ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayersPaczki       = {}
local ladujkurwepolicyjnawdupe = {}
local ladujkurwemedycznawdupe = {}
local ladujkurwemechanikawdupe = {}
local ladujkurwekelnerawdupe = {}
local ladujkurwebankierawdupe = {}
local ladujkurwealchemikawdupe = {}
local ladujkurweakwizytorawdupe = {}

local function zbierzpaczkensa(source)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local paczkalimit = xPlayer.getInventoryItem('paczkapolice')
	SetTimeout(5000, function()
		if PlayersPaczki[source] == true then
			if paczkalimit.count >= 20 then
				xPlayer.setInventoryItem('paczkapolice', paczkalimit.limit)
				TriggerClientEvent('sandy_kurier:zaduzo', _source)
				TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
			else
				xPlayer.addInventoryItem('paczkapolice', 1)
				zbierzpaczkensa(_source)
			end
		end
	end)
end

RegisterServerEvent('sandy_kurier:zbierzpaczki')
AddEventHandler('sandy_kurier:zbierzpaczki', function()
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	
	PlayersPaczki[source] = true

	TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, true)

	TriggerClientEvent('esx:showNotification', _source, 'Zbieranie paczek w toku...')

	zbierzpaczkensa(_source)

end)

local function ladujkurwopaczke(source, jebanytyp)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	SetTimeout(5000, function()
		if jebanytyp == "paczkapolice" then
			if ladujkurwepolicyjnawdupe[source] == true then
				local PaczkaPoliceQuantity = xPlayer.getInventoryItem('paczkapolice').count
				if PaczkaPoliceQuantity <= 0 then
					TriggerClientEvent('sandy_kurier:zamalo', source)	
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else   
					xPlayer.removeInventoryItem('paczkapolice', 1)
					local paczkaemslimit = xPlayer.getInventoryItem('paczkaems')
					if(paczkaemslimit.limit < paczkaemslimit.count + 1) then
						xPlayer.setInventoryItem('paczkaems', paczkaemslimit.limit)
						TriggerClientEvent('sandy_kurier:zaduzo', source)
						TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
					else
						xPlayer.addInventoryItem('paczkaems', 1)
						ladujkurwopaczke(_source, "paczkapolice")
					end
				end
			end
		elseif jebanytyp == "paczkaems" then
			if ladujkurwemedycznawdupe[source] == true then
				local PaczkaEmsQuantity = xPlayer.getInventoryItem('paczkaems').count
				if PaczkaEmsQuantity <= 0 then
					TriggerClientEvent('sandy_kurier:zamalo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else   
					xPlayer.removeInventoryItem('paczkaems', 1)
					local paczkalsclimit = xPlayer.getInventoryItem('paczkalsc')
					if(paczkalsclimit.limit < paczkalsclimit.count + 1) then
						xPlayer.setInventoryItem('paczkalsc', paczkalsclimit.limit)
						TriggerClientEvent('sandy_kurier:zaduzo', source)
						TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
					else
						xPlayer.addInventoryItem('paczkalsc', 1)
						ladujkurwopaczke(_source, "paczkaems")
					end
				end
			end
		elseif jebanytyp == "paczkalsc" then
			if ladujkurwemechanikawdupe[source] == true then
				local PaczkaLcsQuantity = xPlayer.getInventoryItem('paczkalsc').count
				if PaczkaLcsQuantity <= 0 then
					TriggerClientEvent('sandy_kurier:zamalo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else   
					xPlayer.removeInventoryItem('paczkalsc', 1)
					local paczkacoffeelimit = xPlayer.getInventoryItem('paczkacoffee')
					if(paczkacoffeelimit.limit < paczkacoffeelimit.count + 1) then
						xPlayer.setInventoryItem('paczkacoffee', paczkacoffeelimit.limit)
						TriggerClientEvent('sandy_kurier:zaduzo', source)
						TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
					else
						xPlayer.addInventoryItem('paczkacoffee', 1)
						ladujkurwopaczke(_source, "paczkalsc")
					end
				end
			end
		elseif jebanytyp == "paczkacoffee" then
			local PaczkaCoffeeQuantity = xPlayer.getInventoryItem('paczkacoffee').count
			if PaczkaCoffeeQuantity <= 0 then
				TriggerClientEvent('sandy_kurier:zamalo', source)
				TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
			else   
				xPlayer.removeInventoryItem('paczkacoffee', 1)
				local paczkapacificlimit = xPlayer.getInventoryItem('paczkapacific')
				if(paczkapacificlimit.limit < paczkapacificlimit.count + 1) then
					xPlayer.setInventoryItem('paczkapacific', paczkapacificlimit.limit)
					TriggerClientEvent('sandy_kurier:zaduzo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else
					xPlayer.addInventoryItem('paczkapacific', 1)
					ladujkurwopaczke(_source, "paczkacoffee")
				end
			end
		elseif jebanytyp == "paczkapacific" then	
			local PaczkaPacificQuantity = xPlayer.getInventoryItem('paczkapacific').count
			if PaczkaPacificQuantity <= 0 then
				TriggerClientEvent('sandy_kurier:zamalo', source)
				TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
			else   
				xPlayer.removeInventoryItem('paczkapacific', 1)
				local paczkahumanelimit = xPlayer.getInventoryItem('paczkahumane')
				if(paczkahumanelimit.limit < paczkahumanelimit.count + 1) then
					xPlayer.setInventoryItem('paczkahumane', paczkahumanelimit.limit)
					TriggerClientEvent('sandy_kurier:zaduzo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else
					xPlayer.addInventoryItem('paczkahumane', 1)
					ladujkurwopaczke(_source, "paczkapacific")
				end
			end
		elseif jebanytyp == "paczkahumane" then	
			local PaczkaHumaneQuantity = xPlayer.getInventoryItem('paczkahumane').count
			if PaczkaHumaneQuantity <= 0 then
				TriggerClientEvent('sandy_kurier:zamalo', source)
				TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
			else   
				xPlayer.removeInventoryItem('paczkahumane', 1)
				local paczkadojlimit = xPlayer.getInventoryItem('paczkadoj')
				if(paczkadojlimit.limit < paczkadojlimit.count + 1) then
					xPlayer.setInventoryItem('paczkadoj', paczkadojlimit.limit)
					TriggerClientEvent('sandy_kurier:zaduzo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else
					xPlayer.addInventoryItem('paczkadoj', 1)
					ladujkurwopaczke(_source, "paczkahumane")
				end
			end
		elseif jebanytyp == "paczkadoj" then
			local PaczkaDojQuantity = xPlayer.getInventoryItem('paczkadoj').count
			if PaczkaDojQuantity <= 0 then
				TriggerClientEvent('sandy_kurier:zamalo', source)
				TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
			else   
				xPlayer.removeInventoryItem('paczkadoj', 1)
				local kwitlimit = xPlayer.getInventoryItem('kwit')
				if(kwitlimit.limit < kwitlimit.count + 1) then
					xPlayer.setInventoryItem('kwit', kwitlimit.limit)
					TriggerClientEvent('sandy_kurier:zaduzo', source)
					TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, false)
				else
					xPlayer.addInventoryItem('kwit', 1)
					ladujkurwopaczke(_source, "paczkadoj")
				end
			end
		end
	end)
end

RegisterServerEvent('sandy_kurier:dostarczpaczki')
AddEventHandler('sandy_kurier:dostarczpaczki', function(item)
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('sandy_kurier:oddawaniemoczu', _source, true)
	TriggerClientEvent('esx:showNotification', _source, 'Oddawanie paczek w toku...')
	if item == "paczkapolice" then
		ladujkurwepolicyjnawdupe[source] = true
		ladujkurwopaczke(_source, "paczkapolice")
	elseif item == "paczkaems" then
		ladujkurwemedycznawdupe[source] = true
		ladujkurwopaczke(_source, "paczkaems")		
	elseif item == "paczkalsc" then
		ladujkurwemechanikawdupe[source] = true
		ladujkurwopaczke(_source, "paczkalsc")
	elseif item == "paczkacoffee" then
		ladujkurwekelnerawdupe[source] = true
		ladujkurwopaczke(_source, "paczkacoffee")	
	elseif item == "paczkapacific" then
		ladujkurwebankierawdupe[source] = true
		ladujkurwopaczke(_source, "paczkapacific")		
	elseif item == "paczkahumane" then
		ladujkurwealchemikawdupe[source] = true
		ladujkurwopaczke(_source, "paczkahumane")	
	elseif item == "paczkadoj" then
		ladujkurweakwizytorawdupe[source] = true
		ladujkurwopaczke(_source, "paczkadoj")
	end
end)

RegisterServerEvent('sandy_kurier:stopgather')
AddEventHandler('sandy_kurier:stopgather', function()
	local _source = source
	PlayersPaczki[_source] = false
	ladujkurwepolicyjnawdupe[_source] = false
	ladujkurwemedycznawdupe[_source] = false
	ladujkurwemechanikawdupe[_source] = false
	ladujkurwekelnerawdupe[_source] = false
	ladujkurwebankierawdupe[_source] = false
	ladujkurwealchemikawdupe[_source] = false
	ladujkurweakwizytorawdupe[_source] = false
end)

RegisterServerEvent('sandyrp:savexpkurier')
AddEventHandler('sandyrp:savexpkurier', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcekurierlvl = pobierzdane.kurierlvl
	local sourcekurierexp = pobierzdane.kurierexp
	--if sourcekurierlvl < 50 then
	local kwitamount = xPlayer.getInventoryItem('kwit').count
    if kwitamount > 19 then
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET kurierlvl = @kurierlvl, kurierexp = @kurierexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@kurierlvl'] 		= sourcekurierlvl,
					['@kurierexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level kuriera!')
			TriggerEvent("sandyrp:kurierpay", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET kurierlvl = @kurierlvl, kurierexp = @kurierexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@kurierlvl'] 		= sourcekurierlvl,
					['@kurierexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:kurierpay", _source, sourcekurierlvl)
		end
	--elseif sourcekurierlvl >= 50 then
		--TriggerClientEvent('esx:showNotification', _source, 'Masz juz maksymalny level kuriera!')
		--TriggerEvent("sandyrp:kurierpay", _source, sourcekurierlvl)
	--end
	else
		TriggerClientEvent('sandy_kurier:niemakwitu', _source)
	end
end)

RegisterServerEvent('sandyrp:kurierpay')
AddEventHandler('sandyrp:kurierpay', function(source,sourcekurierlvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = 1266
	local kwitamount = xPlayer.getInventoryItem('kwit').count
    Citizen.Wait(2000)
    xPlayer.removeInventoryItem('kwit', kwitamount)
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
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za oddanie kwitu szefowi!')
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
			kurierlvl = staty['kurierlvl'],
			kurierexp = staty['kurierexp'],
		}
	else
		return nil
	end
end

ESX.RegisterServerCallback('sandyrp:checkprofile', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local result = MySQL.Sync.fetchAll(
		"SELECT * FROM expsystem WHERE identifier = @identifier", 
		{
			['@identifier'] = identifier
		}
	)
	local chui          = result[1]
	local kurierlvl     = chui['kurierlvl']
	local kurierexp     = chui['kurierexp']
	local rybaklvl     = chui['rybaklvl']
	local rybakexp     = chui['rybakexp']
	local taxilvl     = chui['taxilvl']
	local taxiexp     = chui['taxiexp']
	local winiarzlvl     = chui['winiarzlvl']
	local winiarzexp     = chui['winiarzexp']
	local truckerlvl     = chui['truckerlvl']
	local truckerexp     = chui['truckerexp']
	local bahamaslvl     = chui['bahamaslvl']
	local bahamasexp     = chui['bahamasexp']
	local data = {
		kurierlvl = kurierlvl,
		kurierexp = kurierexp,
		rybaklvl = rybaklvl,
		rybakexp = rybakexp,
		taxilvl = taxilvl,
		taxiexp = taxiexp,
		winiarzlvl = winiarzlvl,
		winiarzexp = winiarzexp,
		truckerlvl = truckerlvl,
		truckerexp = truckerexp,
		bahamaslvl = bahamaslvl,
		bahamasexp = bahamasexp,
	}
	cb(data)
end)
