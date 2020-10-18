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
			bahamaslvl = staty['bahamaslvl'],
			bahamasexp = staty['bahamasexp'],
		}
	else
		return nil
	end
end

RegisterServerEvent('sandyrp:savexpbahamas')
AddEventHandler('sandyrp:savexpbahamas', function(boxnumber)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcekurierlvl = pobierzdane.bahamaslvl
	local sourcekurierexp = pobierzdane.bahamasexp
    if boxnumber >= 10 then
		if sourcekurierexp == 80 then
			sourcekurierlvl = sourcekurierlvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET bahamaslvl = @bahamaslvl, bahamasexp = @bahamasexp, nick = @nick  WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@bahamaslvl'] 		= sourcekurierlvl,
					['@bahamasexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcekurierlvl..' level Bahamas!')
			TriggerEvent("sandyrp:bahamaspay", _source, sourcekurierlvl)
		elseif sourcekurierexp >= 0 and sourcekurierexp <= 79 then
			sourcekurierexp = sourcekurierexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET bahamaslvl = @bahamaslvl, bahamasexp = @bahamasexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@bahamaslvl'] 		= sourcekurierlvl,
					['@bahamasexp']      = sourcekurierexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:bahamaspay", _source, sourcekurierlvl)
		end
	end
end)

RegisterServerEvent('sandyrp:bahamaspay')
AddEventHandler('sandyrp:bahamaspay', function(source,sourcekurierlvl)
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
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bahamas', function(account)
		bahamasAccount = account
	end)
	bahamasAccount.addMoney(kurwasuperkasa * 0.25)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za oddanie ladunku!')
end)

RegisterServerEvent('sandy_bahamas:purchasedrink')
AddEventHandler('sandy_bahamas:purchasedrink', function(item, price)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getMoney()
	local itemdata = getitemname(item)
	local itemname = itemdata.label
	if isitemWhitelisted(item) then
		if account >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, 1)
			TriggerClientEvent('esx:showNotification', _source, 'Kupiles ~y~'..itemname..'~w~ za ~g~'..price..'~w~$')
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bahamas', function(account)
				bahamasAccount = account
			end)
			bahamasAccount.addMoney(price * 0.50)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz ~g~'.. price ..'$ pieniędzy!')
		end
	else
		TriggerEvent("logsbanCheaterr", _source, "BLOCKEDITEM")
	end
end)

function getitemname(item)
	local result = MySQL.Sync.fetchAll("SELECT * FROM items WHERE name = @name", 
		{
			['@name'] = item
		}
	)
	if result[1] ~= nil then
		local itemname = result[1]

		return {
			item = itemname['item'],
			label = itemname['label']
		}
	else
		return nil
	end
end

function isitemWhitelisted(item)
	alloweditems = {
		"jager",
		"vodka",
		"rhum",
		"whisky",
		"tequila",
		"martini",
		"cola",
		"water",
		"bread",
		"redgull",
		"cigarette",
		"zapalniczka"
  	}
	for _, whitelistedItems in pairs(alloweditems) do
		if item == whitelistedItems then
			return true
		end
	end

	return false
end