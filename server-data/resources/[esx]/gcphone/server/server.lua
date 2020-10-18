--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

math.randomseed(os.time()) 

local ESX = nil

local FixePhone = {}

local alertsCount = 0

local actAlert = {
	number = nil,
	message = '',
	coords = nil
}

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)

RegisterServerEvent('rich-alert:acceptedAlert')
AddEventHandler('rich-alert:acceptedAlert', function(dt, aO)
	local _source = source
	
	local deta = dt
	local num = deta.number
	
	local xPlayers = ESX.GetPlayers()
	
	if num == 'police' then
		local notif = ('~b~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'ambulance' then
		local notif = ('~r~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('gln:zaakceptowalizgloszenie', xPlayer.source)
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'mecano' then
		local notif = ('~g~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'mecano' then
                TriggerClientEvent('gln:zaakceptowalizgloszenie', xPlayer.source)
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'taxi' then
		local notif = ('~y~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'taxi' then
                TriggerClientEvent('gln:zaakceptowalizgloszenie', xPlayer.source)
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	end
	if actAlert.oneAccept == false then
		TriggerClientEvent('esx:showNotification', aO, '~g~Twoje zgłoszenie zostało odebrane.')
		actAlert.oneAccept = true
	end
end)

RegisterServerEvent('rich-alert:startCall')
AddEventHandler('rich-alert:startCall', function(number, message, coords, player)
    local source = source
    local xPlayers = ESX.GetPlayers()
	
	if number == 'police' then
    
            actAlert = {
                number = number,
                message = message,
                coords = coords,
                oneAccept = false
            }
	
		alertsCount = alertsCount + 1
		
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('rich-alert:sendAlert', xPlayer.source, actAlert, player)

                getPhoneNumber(source, function (phone)
                    notifyAlertSMS(xPlayer.source, actAlert, phone)
                end)
			end
		end
		
	elseif number == 'ambulance' then
	
            actAlert = {
                number = number,
                message = message,
                coords = coords,
                oneAccept = false
            }
	
		alertsCount = alertsCount + 1
		
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'ambulance' then
				TriggerClientEvent('rich-alert:sendAlert', xPlayer.source, actAlert, player)

                getPhoneNumber(source, function (phone)
                    notifyAlertSMS(xPlayer.source, actAlert, phone)
                end)
			end
		end
		
	elseif number == 'mecano' then

            actAlert = {
                number = number,
                message = message,
                coords = coords,
                oneAccept = false
            }
	
		alertsCount = alertsCount + 1
		
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'mecano' then
				TriggerClientEvent('rich-alert:sendAlert', xPlayer.source, actAlert, player)

                getPhoneNumber(source, function (phone)
                    notifyAlertSMS(xPlayer.source, actAlert, phone)
                end)
			end
		end
		
	elseif number == 'taxi' then
    
            actAlert = {
                number = number,
                message = message,
                coords = coords,
                oneAccept = false
            }
	
		alertsCount = alertsCount + 1
		
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'taxi' then
				TriggerClientEvent('rich-alert:sendAlert', xPlayer.source, actAlert, player)

                getPhoneNumber(source, function (phone)
                    notifyAlertSMS(xPlayer.source, actAlert, phone)
                end)
			end
		end
	end
end)

function getPhoneNumber (source, callback) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then
      callback(nil)
    end
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
      ['@identifier'] = xPlayer.identifier
    }, function(result)
      callback(result[1].phone_number)
    end)
  end

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		--if Config.OnlyFirstname then
			--return result[1].firstname
		--else
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
		--end
	else
		return GetPlayerName(source)
	end
end

function GetCharacterPhone(source)
	local result = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].phone_number then
		return result[1].phone_number
	else
		return nil
	end
end

function notifyAlertSMS(sors, alert, numer)
	local playerNumber = GetCharacterPhone(sors)
	local mess = 'Od #' .. numer  .. ' Wiadomość: ' .. alert.message
	if alert.coords ~= nil then
		mess = mess .. ' | GPS: ' .. string.format("%.2f", alert.coords.x) .. ', ' .. string.format("%.2f", alert.coords.y) 
	end

	if playerNumber ~= nil then
		TriggerEvent('gcPhone:_internalAddMessage', alert.number, playerNumber, mess, 0, function (smsMess)
			TriggerClientEvent("gcPhone:receiveMessage", sors, smsMess)
		end)
	end
end

RegisterServerEvent("route68:RenameSim")
AddEventHandler("route68:RenameSim", function(id, txt, _)
  MySQL.Async.execute(
    'UPDATE user_sim SET label = @label WHERE id=@id',
    {
      ['@id'] = id,
      ['@label'] = txt

    }
  )

 -- TriggerClientEvent("esx:showNotification",source,"Vous avez bien renommé votre ".."sim".." en "..txt)

end)

ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local qtty = xPlayer.getInventoryItem(item).count
	--print("phone qtty: " .. qtty)
    cb(qtty)
end)

function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end

RegisterServerEvent('route68:SetNumber')
AddEventHandler('route68:SetNumber', function(numb)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  
  
  phoneNumber = numb
  TriggerClientEvent("route68:UpdateNumber",_source,numb)
  
  MySQL.Async.execute(
      'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
      {
          ['@identifier']   = xPlayer.identifier,
          ['@phone_number'] = phoneNumber
      }
  )
	TriggerClientEvent("route68:shownotif",_source,"Użyto karty SIM: <font color='#00cc00'>" .. tostring(phoneNumber) .. "</font>",26)  
	

	
end)

RegisterServerEvent('route68:SetNumberWejscie')
AddEventHandler('route68:SetNumberWejscie', function(numb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    phoneNumber = numb
    if phoneNumber ~= nil then
        TriggerClientEvent("route68:UpdateNumber",_source,numb)
        MySQL.Async.execute(
            'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
            {
                ['@identifier']   = xPlayer.identifier,
                ['@phone_number'] = phoneNumber
            }
        )
        if phoneNumber ~= 'xxx' then
        	TriggerClientEvent("route68:shownotif",_source,"Wczytano kartę SIM: <font color='#00cc00'>" .. tostring(phoneNumber) .. "</font>",26)
    	end
    end
end)


ESX.RegisterServerCallback('route68:getCurrentSim', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    
  
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
  
        cb(result[1].phone_number)
  
    end )
  
end)

ESX.RegisterServerCallback('route68:getSim', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
  
    MySQL.Async.fetchAll(
      'SELECT * FROM user_sim WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
  
        cb(result)
      --  --(json.encode(result))
  
    end )
  
end)

ESX.RegisterServerCallback('sandycards:getSim', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll(
      'SELECT * FROM user_sim WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
        cb(result)
    end )
end)

ESX.RegisterServerCallback('route68:stealsimsy', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
  
    MySQL.Async.fetchAll(
      'SELECT * FROM user_sim WHERE identifier = @identifier',
      {
          ['@identifier'] = xPlayer.identifier
      },
      function(result)
  
        cb(result)
  
    end )
  
end)

RegisterServerEvent('route68:Throw')
AddEventHandler('route68:Throw', function(number,data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

			
				MySQL.Async.execute(
					'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
					{
						['@identifier']   = xPlayer.identifier,
						['@phone_number'] = nil
			
					}
				)
				TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
				TriggerClientEvent("route68:UpdateNumber",_source,nil)
			
			MySQL.Async.execute(
				'UPTADE user_sim SET identifier = @job WHERE number = @name ',
				{
					['@job']   = nil,
					['@count'] = "c",
					['@name'] = number
				}
            )
			TriggerClientEvent("route68:shownotif", source,"Wyrzucono karte SIM: <font color='#00cc00'>" .. number .. "</font>")

		
	
end)

RegisterServerEvent('gcphone:billCall')
AddEventHandler('gcphone:billCall', function(czas)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bill = czas/100
    bill = math.floor(bill)
    if bill < 1 then
    	bill = 1
    end
    xPlayer.removeMoney(bill)
    TriggerClientEvent('esx:showNotification', _source, 'Zapłaciłeś ~g~'.. bill ..'$ ~w~za połączenie!')
end)

RegisterServerEvent('route68:off')
AddEventHandler('route68:off', function(number,data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

			
				MySQL.Async.execute(
					'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
					{
						['@identifier']   = xPlayer.identifier,
						['@phone_number'] = nil
			
					}
				)
				TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
				TriggerClientEvent("route68:UpdateNumber",_source,nil)
--[[			
			MySQL.Async.execute(
				'DELETE FROM user_sim where identifier = @job AND number = @name ',
				{
					['@job']   = xPlayer.identifier,
					['@count'] = "c",
					['@name'] = number
		
				}
            )
]]
			TriggerClientEvent("route68:shownotif",_source,"Odpieto karte SIM: <font color='#00cc00'>" .. phoneNumber .. "</font>")


		
	
end)

ESX.RegisterUsableItem('sim', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('sim', 1)
	phoneNumber = GenerateUniquePhoneNumber()

	TriggerClientEvent('route68:UpdateNumber', _source,phoneNumber)
	MySQL.Async.execute(
		'INSERT INTO user_sim (identifier,number,label,firstowner) VALUES(@identifier,@phone_number,@label,@firstowner)',
		{
			['@identifier']   = xPlayer.identifier,
			['@phone_number'] = phoneNumber,
			['@label'] = "SIM "..phoneNumber,
			['@firstowner']   = xPlayer.identifier

		}
	)
	MySQL.Async.execute(
		'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
		{
			['@identifier']   = xPlayer.identifier,
			['@phone_number'] = phoneNumber,

		}
	)
	TriggerClientEvent("route68:shownotif",_source,"Nowa karta SIM: <font color='#00cc00'>" .. phoneNumber .. "</font>",26) 	
	TriggerClientEvent("route68:syncSim",source)
	


end)


function GenerateUniquePhoneNumber()
    local running = true
    local phone = nil
    while running do
        local rand = '' .. math.random(111111,999999)
      --  --('Recherche ... : ' .. rand)
        local count = MySQL.Sync.fetchScalar("SELECT COUNT(number) FROM user_sim WHERE number = @phone_number", { ['@phone_number'] = rand })
        if count < 1 then
            phone = rand
            running = false
        end
    end
  --  --('Numero Choisi  : ' .. phone)
    return phone
end

    
RegisterServerEvent('route68:useSim')
AddEventHandler('route68:useSim', function(number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("gcPhone:myPhoneNumber",_source,number)
	TriggerClientEvent("route68:UpdateNumber",_source,number)
	
	MySQL.Async.execute(
		'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
		{
			['@identifier']   = xPlayer.identifier,
			['@phone_number'] = number

		}
	)

end)

RegisterServerEvent('gcphone:zabierz')
AddEventHandler('gcphone:zabierz', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('gcphone:zajebkarte', targetPlayer.source, source)
end)

RegisterServerEvent('route68:GiveNumber')
AddEventHandler('route68:GiveNumber', function(target,number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayer2 = ESX.GetPlayerFromId(target)
    local poprzedni
	MySQL.Async.fetchAll(
		'SELECT * FROM `users` WHERE `identifier` = @identifier',
		{
			['@identifier'] = xPlayer.identifier,
			
		},
		function(result)

			if result[1].phone_number == number then
				TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
				TriggerClientEvent("route68:UpdateNumber",_source,nil)
				MySQL.Async.execute(
					'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
					{
						['@identifier']   = xPlayer.identifier,
						['@phone_number'] = nil
			
					}
				)
			end
            MySQL.Async.fetchAll(
                'SELECT * FROM `user_sim` WHERE identifier = @identifier AND number = @number',
                {
                    ['@identifier'] = xPlayer.identifier,
                    ['@number'] = number
                    
                },
                function(result2)
                    poprzedni = result2[1].firstowner
                    MySQL.Async.execute('INSERT INTO user_sim (identifier, number, label, firstowner) VALUES (@name, @count, @job, @firstowner)',
                    {
                      ['@name']   = xPlayer2.identifier,
                      ['@count'] = number,
                      ['@job'] = "SIM ".. number,
                      ['@firstowner']   = poprzedni
                    },
                    function (_)
                      
                    end)
                    TriggerClientEvent("route68:shownotif", _source,"Oddales karte SIM: <font color='#00cc00'>" .. number .. "</font>")
                    TriggerClientEvent("route68:shownotif", target,"Otrzymano karte SIM: <font color='#00cc00'>" .. number .. "</font>")	
                    TriggerClientEvent("route68:syncSim",_source)
                    TriggerClientEvent("route68:syncSim",target)
                    MySQL.Async.execute(
                        'DELETE FROM user_sim where identifier = @job AND number = @name ',
                        {
                            ['@job']   = xPlayer.identifier,
                            ['@count'] = "c",
                            ['@name'] = number
                
                        }
                    )
            end)
		end
	)

end)

RegisterServerEvent('sandy:zajebnumber')
AddEventHandler('sandy:zajebnumber', function(target,number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
    local xPlayer2 = ESX.GetPlayerFromId(_source)
    local poprzedni
	MySQL.Async.fetchAll(
		'SELECT * FROM `users` WHERE `identifier` = @identifier',
		{
			['@identifier'] = xPlayer.identifier,
			
		},
		function(result)

			if result[1].phone_number == number then
				TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
				TriggerClientEvent("route68:UpdateNumber",_source,nil)
				MySQL.Async.execute(
					'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
					{
						['@identifier']   = xPlayer.identifier,
						['@phone_number'] = nil
			
					}
				)
			end
            MySQL.Async.fetchAll(
                'SELECT * FROM `user_sim` WHERE identifier = @identifier AND number = @number',
                {
                    ['@identifier'] = xPlayer.identifier,
                    ['@number'] = number
                    
                },
                function(result2)
                    poprzedni = result2[1].firstowner
                    MySQL.Async.execute('INSERT INTO user_sim (identifier, number, label, firstowner) VALUES (@name, @count, @job, @firstowner)',
                    {
                      ['@name']   = xPlayer2.identifier,
                      ['@count'] = number,
                      ['@job'] = "SIM ".. number,
                      ['@firstowner']   = poprzedni
                    },
                    function (_)
                      
                    end)
                    TriggerClientEvent("route68:shownotif", _source,"Zabrałeś kartę SIM: <font color='#00cc00'>" .. number .. "</font>")
                    TriggerClientEvent("route68:shownotif", target,"Karta: <font color='#00cc00'>" .. number .. "</font> ~r~została Ci skradziona!")
                    TriggerClientEvent("route68:syncSim",_source)
                    TriggerClientEvent("route68:syncSim",target)
                    MySQL.Async.execute(
                        'DELETE FROM user_sim where identifier = @job AND number = @name ',
                        {
                            ['@job']   = xPlayer.identifier,
                            ['@count'] = "c",
                            ['@name'] = number
                
                        }
                    )
            end)
		end
	)

end)

ESX.RegisterServerCallback('sandy:getoriginalkartas', function(source, cb)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  
    MySQL.Async.fetchAll(
   		'SELECT * FROM user_sim WHERE firstowner = @firstowner',
        {
        	['@firstowner'] = xPlayer.identifier
        },
      	function(result)
        cb(result)
    end)
end)

RegisterServerEvent('sandy:blockkarta')
AddEventHandler('sandy:blockkarta', function(number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll(
		'SELECT * FROM `user_sim` WHERE `firstowner` = @firstowner',
		{
			['@firstowner'] = xPlayer.identifier,
			
		},
		function(result)
			local simcards = {}
			for i=1, #result, 1 do
				local daneData = (result[i])
				table.insert(simcards, daneData)
			end
			if simcards ~= nil then
				for i=1, #simcards, 1 do
					if simcards[i].number == number then
						MySQL.Async.execute(
							'UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
							{
								['@identifier']   = simcards[i].identifier,
								['@phone_number'] = nil
					
							}
						)
						if xPlayer.identifier ~= simcards[i].identifier then
							MySQL.Async.execute(
								'UPDATE user_sim SET identifier = @identifier WHERE number = @number AND firstowner = @firstowner',
								{
									['@identifier']   = xPlayer.identifier,
									['@number'] = number,
									['@firstowner']   = xPlayer.identifier
								}
							)
						end
						TriggerClientEvent("route68:shownotif", _source,"Zablokowales karte SIM: <font color='#00cc00'>" .. number .. "</font>")
						TriggerClientEvent("route68:shownotif", _source,"Skopiowałes karte SIM: <font color='#00cc00'>" .. number .. "</font>")
					end
				end
			end
		end
		)
end)
--====================================================================================
--  Utils
--====================================================================================

function getSourceFromIdentifier(identifier, cb)
    TriggerEvent("es:getPlayers", function(users)
        for k , user in pairs(users) do
            if (user.getIdentifier ~= nil and user.getIdentifier() == identifier) or (user.identifier == identifier) then
                cb(k)
                return
            end
        end
    end)
    cb(nil)
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end


function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
	--[[
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
	]]
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local numer = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_contacts WHERE identifier = @identifier", {
        ['@identifier'] = tostring(numer[1].phone_number)
    })
    if result then
        return result
    end
end
function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    local numer = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    MySQL.Async.insert("INSERT INTO user_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
        ['@identifier'] = tostring(numer[1].phone_number),
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE user_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    local numer = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    MySQL.Sync.execute("DELETE FROM user_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = tostring(numer[1].phone_number),
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    local numer = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    MySQL.Sync.execute("DELETE FROM user_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = tostring(numer[1].phone_number)
    })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
         ['@identifier'] = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        getSourceFromIdentifier(otherIdentifier, function (osou)
            if tonumber(osou) ~= nil then 
                -- TriggerClientEvent("gcPhone:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("gcPhone:receiveMessage", tonumber(osou), tomess, sourcePlayer)
            end
        end) 
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "#####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)


RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }

    local mam5telefonow = 0
    local xp =
    getSourceFromIdentifier(destPlayer, function (srcTo)
        if srcTo ~= nil then
            jestemgraczem = ESX.GetPlayerFromId(srcTo)
            mam5telefonow = jestemgraczem.getInventoryItem('phone').count
        end
    end)

    if mam5telefonow > 0 then
        if is_valid == true then
            getSourceFromIdentifier(destPlayer, function (srcTo)
                if srcTo ~= nil then
                    AppelsEnCours[indexCall].receiver_src = srcTo
                    TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                    TriggerClientEvent('gcPhone:waitingCall', tonumber(srcTo), AppelsEnCours[indexCall], false)
                elseif AppelsEnCours[indexCall].receiver_src == nil then
                    TriggerClientEvent('esx:showNotification', sourcePlayer, '~r~Abonent niedostępny!')
                    --TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                    --TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', sourcePlayer, '~r~Numer nie istnieje!')
        end
    else
        if is_valid == true then
            getSourceFromIdentifier(destPlayer, function (srcTo)
                if srcTo ~= nil then
                    AppelsEnCours[indexCall].receiver_src = srcTo
                    TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                elseif AppelsEnCours[indexCall].receiver_src == nil then
                    TriggerClientEvent('esx:showNotification', sourcePlayer, '~r~Abonent niedostępny!')
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', sourcePlayer, '~r~Numer nie istnieje!')
        end
    end

end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)


RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)










































--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('es:playerLoaded',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, myPhoneNumber)
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
        TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(identifier))
    end)
end)

-- Just For reload
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
    TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(identifier))
    TriggerClientEvent('gcPhone:getBourse', sourcePlayer, getBourse())
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    --  Format
    --  Array 
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution 
    -- 
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end


ESX.RegisterUsableItem('phone', function(source)

	TriggerClientEvent('gcPhone:ekwipunek', source)
end)

RegisterServerEvent('gcPhone:dostajesms')
AddEventHandler('gcPhone:dostajesms', function()
end)

RegisterServerEvent('gcPhone:wysylasms')
AddEventHandler('gcPhone:wysylasms', function()
end)

RegisterServerEvent('gcPhone:dzwonitelefon')
AddEventHandler('gcPhone:dzwonitelefon', function()
end)