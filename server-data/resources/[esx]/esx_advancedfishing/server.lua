

ESX = nil
local PlayersSellingFish       = {}
local soldfish = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('turtlebait', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "turtle")
		
		xPlayer.removeInventoryItem('turtlebait', 1)
		TriggerClientEvent('fishing:message', _source, "Zalozyles przynete na zolwie na wedke")
	else
		TriggerClientEvent('fishing:message', _source, "Nie posiadasz wedki")
	end
	
end)

ESX.RegisterUsableItem('fishbait', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "fish")
		
		xPlayer.removeInventoryItem('fishbait', 1)
		TriggerClientEvent('fishing:message', _source, "Zalozyles przynete na ryby na wedke")
		
	else
		TriggerClientEvent('fishing:message', _source, "Nie posiadasz wedki")
	end
	
end)

ESX.RegisterUsableItem('turtle', function(source)

	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "shark")
		
		xPlayer.removeInventoryItem('turtle', 1)
		TriggerClientEvent('fishing:message', _source, "Zalozyles miesa zolwia na lodke")
	else
		TriggerClientEvent('fishing:message', _source, "Nie posiadasz wedki")
	end
	
end)
--[[
ESX.RegisterUsableItem('fishingrod', function(source)

	local _source = source
	TriggerClientEvent('fishing:fishstart', _source)
	
	

end)
]]--

RegisterServerEvent('fishing:fishingrod')
AddEventHandler('fishing:fishingrod', function()
	local _source = source
	TriggerClientEvent('fishing:fishstart', _source)
end)


RegisterNetEvent('Rybak:Kaska')
AddEventHandler('Rybak:Kaska', function()
	local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(250)
end)
				
RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)
	
	_source = source
	local weight = 2
	local rnd = math.random(1,50)
	xPlayer = ESX.GetPlayerFromId(_source)
	if bait == "turtle" then
		if rnd >= 78 then
			if rnd >= 94 then
				TriggerClientEvent('fishing:setbait', _source, "none")
				TriggerClientEvent('fishing:message', _source, "Ryba byla za duza i zerwala twoja wedke!")
				TriggerClientEvent('fishing:break', _source)
				xPlayer.removeInventoryItem('fishingrod', 1)
			else
				TriggerClientEvent('fishing:setbait', _source, "none")
				if xPlayer.getInventoryItem('turtle').count > 4 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej zolwi")
				else
					TriggerClientEvent('fishing:message', _source, "Zlapales zolwia")
					xPlayer.addInventoryItem('turtle', 1)
				end
			end
		else
			if rnd >= 75 then
				if xPlayer.getInventoryItem('fish').count > 50 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(4,9)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
				
			else
				if xPlayer.getInventoryItem('fish').count > 50 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(2,6)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('fishing:setbait', _source, "none")
				if xPlayer.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(1,8)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
				
			else
				if xPlayer.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(1,6)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
			end
		end
		if bait == "none" then
			
			if rnd >= 70 then
				TriggerClientEvent('fishing:setbait', _source, "none")
				if xPlayer.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(1,8)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
				
			else
				if xPlayer.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ~r~ryb")
				else
					weight = math.random(1,6)
					TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
					xPlayer.addInventoryItem('fish', weight)
				end
			end
		end
		if bait == "shark" then
			if rnd >= 82 then
			
						if rnd >= 91 then
							TriggerClientEvent('fishing:setbait', _source, "none")
							TriggerClientEvent('fishing:message', _source, "Ryba byla za duza i zerwala twoja wedke!")
							TriggerClientEvent('fishing:break', _source)
							xPlayer.removeInventoryItem('fishingrod', 1)
						else
							if xPlayer.getInventoryItem('shark').count > 0  then
									TriggerClientEvent('fishing:setbait', _source, "none")
									TriggerClientEvent('fishing:message', _source, "Nie możesz utrzymać więcej rekinów")
							else
									TriggerClientEvent('fishing:message', _source, "Zlapales rekina")
									TriggerClientEvent('fishing:spawnPed', _source)
									xPlayer.addInventoryItem('shark', 1)
							end
						end	
							else
									if xPlayer.getInventoryItem('fish').count > 50 then
										TriggerClientEvent('fishing:message', _source, "Nie możesz unieść więcej ryb")
									else
										weight = math.random(4,8)
										TriggerClientEvent('fishing:message', _source, "Złapłeś rybę ważącą: ~y~" .. weight .. "kg")
										xPlayer.addInventoryItem('fish', weight)
									end
								
							end
			end
			
		end
	
	
end)

RegisterServerEvent("fishing:lowmoney")
AddEventHandler("fishing:lowmoney", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
end)

local function SellFish(source)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local FishQuantity = xPlayer.getInventoryItem('fish').count
	SetTimeout(500, function()
		if PlayersSellingFish[source] == true then
			if FishQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz więcej: ~r~ryb')
				TriggerClientEvent('stopsprzedawanko', source)	
			else   
				local found = false
				for i=1,#soldfish,1 do
          			if soldfish[i].name == source then
          				if soldfish[i].count == nil or soldfish[i].count <= 49 then
	          				if soldfish[i].count == nil then
	          					soldfish[i].count = 1
	          					found = true
	          					--print('ID: ' .. soldfish[i].name .. ' Ryby:' .. soldfish[i].count)
	          				else
	           					--if soldfish[i].count == 50 then
	           						--soldfish[i].count = 0
									--TriggerClientEvent('sandyrp:stackiryb', source, '1')
								--end
								soldfish[i].count = soldfish[i].count + 1
								found = true
								--print('ID: ' .. soldfish[i].name .. ' Ryby:' .. soldfish[i].count)
	           				end
	           			end 
	           			if soldfish[i].count == 50 then
	           				soldfish[i].count = 1
							TriggerClientEvent('sandyrp:stackiryb', source, '1')
							--print('ID: ' .. soldfish[i].name .. ' Ryby:' .. soldfish[i].count)
           				end
         			end
        		end
        		if not found then
					table.insert(soldfish, {
       					name = source,
        				count = count
     				})
				end
				xPlayer.removeInventoryItem('fish', 1)
				--payment = math.random(Config.FishPrice.a, Config.FishPrice.b) 
				--xPlayer.addMoney(payment)
				SellFish(source)
			end
		end
	end)
end

RegisterServerEvent('fishing:startSelling')
AddEventHandler('fishing:startSelling', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	PlayersSellingFish[source] = true

	TriggerClientEvent('esx:showNotification', _source, '~y~Sprzedajesz ryby~w~, aby otrzymać ~g~wypłatę ~w~sprzedaj 150 rybek!')

	SellFish(_source)
end)

RegisterServerEvent('sandyrp:savexprybak')
AddEventHandler('sandyrp:savexprybak', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local pobierzdane = getlevel(_source)
	local sourceidentifier = pobierzdane.identifier
	local sourcerybaklvl = pobierzdane.rybaklvl
	local sourcerybakexp = pobierzdane.rybakexp
	--if sourcerybaklvl < 50 then
		if sourcerybakexp == 80 then
			sourcerybaklvl = sourcerybaklvl + 1
			MySQL.Async.execute(
				'UPDATE expsystem SET rybaklvl = @rybaklvl, rybakexp = @rybakexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@rybaklvl'] 		= sourcerybaklvl,
					['@rybakexp']      = 0,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerClientEvent('esx:showNotification', _source, 'Wbiles '..sourcerybaklvl..' level rybaka!')
			TriggerEvent("sandyrp:rybakpay", _source, sourcerybaklvl)
		elseif sourcerybakexp >= 0 and sourcerybakexp <= 79 then
			sourcerybakexp = sourcerybakexp + 20
			MySQL.Async.execute(
				'UPDATE expsystem SET rybaklvl = @rybaklvl, rybakexp = @rybakexp, nick = @nick WHERE identifier = @identifier',
				{
					['@identifier']		= sourceidentifier,
					['@rybaklvl'] 		= sourcerybaklvl,
					['@rybakexp']      = sourcerybakexp,
					['@nick']      		= xPlayer.name
				}
			)
			TriggerEvent("sandyrp:rybakpay", _source, sourcerybaklvl)
		end
	--elseif sourcerybaklvl >= 50 then
		--TriggerClientEvent('esx:showNotification', _source, 'Masz juz maksymalny level rybaka!')
		--TriggerEvent("sandyrp:rybakpay", _source, sourcerybaklvl)
	--end
end)

RegisterServerEvent('sandyrp:rybakpay')
AddEventHandler('sandyrp:rybakpay', function(source,sourcerybaklvl)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = 267
    Citizen.Wait(2000)
    local kurwakasa = nil
    if sourcerybaklvl == 0 then
        kurwakasa = 1
    elseif sourcerybaklvl > 50 then
        kurwakasa = 50/100
    else
        kurwakasa = (sourcerybaklvl/100)
    end
    kurwakasa = kurwakasa + 1
    local kurwasuperkasa = cash*150*kurwakasa
    kurwasuperkasa = math.floor(kurwasuperkasa)
    if kurwasuperkasa > 60000 then
    	kurwasuperkasa = 60000
    end
    xPlayer.addMoney(kurwasuperkasa)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymałeś ~g~' .. kurwasuperkasa .. '~w~$ za oddanie 150 ryb!')
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
			rybaklvl = staty['rybaklvl'],
			rybakexp = staty['rybakexp'],
			taxilvl = staty['taxilvl'],
			taxiexp = staty['taxiexp']
		}
	else
		return nil
	end
end