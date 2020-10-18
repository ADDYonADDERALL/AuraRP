local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local alert1 = false
local alert2 = false
local alertkurwa = false
local kwotafaktury
local ziomek
local twojapraca

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
    	if IsControlPressed(0, Keys['F7']) and PlayerData.job and isjobWhitelisted(PlayerData.job.name) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'faktury_menu') then
       		Openfakturymenu()
    	end
    	if IsControlPressed(0, Keys['F7']) and PlayerData.job2 and isjobWhitelisted(PlayerData.job2.name) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'faktury_menu') then
       		Openfakturymenusecond()
    	end
    end
end)

function isjobWhitelisted(job)
	allowedjobs = {
		"mecano",
		"ambulance",
		"tedbilcar"
		-- Add any job that is allowed to open the billing menu
  	}
	for _, whitelistedJob in pairs(allowedjobs) do
		if job == whitelistedJob then
			return true
		end
	end

	return false
end

function Openfakturymenu()

	local elements = {
		{label = 'Wystaw fakture',   value = 'billing'}
	}

	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' then
		table.insert(elements, {label = 'Lista faktur', value = 'billing_list'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'faktury_menu', {
		title    = 'Faktury',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		
		if data.current.value == 'billing' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 2.0 then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'menu_faktura',
                    {
                      title = 'Wpisz kwotę'
                    },
                    function(data1, menu1)
                        local count = tonumber(data1.value)

                        if count == nil or count > 10000000 then
                            ESX.ShowNotification('Nieprawidłowa kwota!')
                        else
                            menu1.close()
                            TriggerServerEvent('sandyfaktura:checkfaktura', GetPlayerServerId(closestPlayer), count, PlayerData.job.name)
                        end
                    end,function(data1, menu1)
                          menu1.close()
                    end
                )
            else
                ESX.ShowNotification('Brak osob w poblizu!')
            end
		elseif data.current.value == 'billing_list' then
			TriggerEvent('sandyfaktura:showclientfaktures', PlayerData.job.name)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function Openfakturymenusecond()

	local elements = {
		{label = 'Wystaw fakture',   value = 'billing'}
	}

	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' or PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' then
		table.insert(elements, {label = 'Lista faktur', value = 'billing_list'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'faktury_menu', {
		title    = 'Faktury',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		
		if data.current.value == 'billing' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 2.0 then
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'menu_faktura',
                    {
                      title = 'Wpisz kwotę'
                    },
                    function(data1, menu1)
                        local count = tonumber(data1.value)

                        if count == nil or count > 10000000 then
                            ESX.ShowNotification('Nieprawidłowa kwota!')
                        else
                            menu1.close()
                            TriggerServerEvent('sandyfaktura:checkfakturasecond', GetPlayerServerId(closestPlayer), count, PlayerData.job2.name)
                        end
                    end,function(data1, menu1)
                          menu1.close()
                    end
                )
            else
                ESX.ShowNotification('Brak osob w poblizu!')
            end
		elseif data.current.value == 'billing_list' then
			TriggerEvent('sandyfaktura:showclientfaktures', PlayerData.job2.name)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('sandyfaktura:showclientfaktures')
AddEventHandler('sandyfaktura:showclientfaktures', function(kurwapraca)
	Openshowclientfaktures(kurwapraca)
end)

function Openshowclientfaktures(kurwapraca)

	ESX.TriggerServerCallback('sandyfaktura:showfaktures', function (dane)
		if dane ~= nil then
			local elements = {
				head = {'Pracownik', 'Klient', 'Cena', 'Data'},
				rows = {}
			}
			for i=1, #dane, 1 do
				table.insert(elements.rows, {
					data = dane[i],
					cols = {
						dane[i].worker,
						dane[i].client,
						dane[i].price .. '$',
						dane[i].date
					}
				})
			end

			ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'faktura_list', elements, function(data, menu)

			end, function(data, menu)
				menu.close()
			end)

		else
			ESX.ShowNotification('Nie widac zadnych faktur')
		end
	end, kurwapraca)

end

RegisterNetEvent('sandyfaktura:clientconfirm')
AddEventHandler('sandyfaktura:clientconfirm', function(count,konfident,kurwapraca)
	alert1 = true
	kwotafaktury = count
	ziomek = konfident
	twojapraca = kurwapraca
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if alert1 == true then    
			ESX.ShowHelpNotification('Dostales fakture na: ~g~' .. kwotafaktury .. '$\n~o~~INPUT_MP_TEXT_CHAT_TEAM~~s~, aby ~g~ZAAKCEPTOWAC')
			if IsControlJustReleased(0, Keys['Y']) then
				Citizen.Wait(10)
				TriggerServerEvent('sandyfaktura:fakturacorrect', kwotafaktury, ziomek, twojapraca)
				alert1 = false 
				alertkurwa = true
			end
		end
	end
end)

RegisterNetEvent('sandyfaktura:clientconfirmsecond')
AddEventHandler('sandyfaktura:clientconfirmsecond', function(count,konfident,kurwapraca)
	alert2 = true
	kwotafaktury = count
	ziomek = konfident
	twojapraca = kurwapraca
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if alert2 == true then    
			ESX.ShowHelpNotification('Dostales fakture na: ~g~' .. kwotafaktury .. '$\n~o~~INPUT_MP_TEXT_CHAT_TEAM~~s~, aby ~g~ZAAKCEPTOWAC')
			if IsControlJustReleased(0, Keys['Y']) then
				Citizen.Wait(10)
				TriggerServerEvent('sandyfaktura:fakturacorrectsecond', kwotafaktury, ziomek, twojapraca)
				alert2 = false 
				alertkurwa = true
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
    	if alert1 == true then
      		Wait(10000)
      		alert1 = false
    		if alertkurwa ~= true then
				ESX.ShowNotification('~r~Faktura wygasla')
			end
			alertkurwa = false
    	end
  	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
    	if alert2 == true then
      		Wait(10000)
      		alert2 = false
    		if alertkurwa ~= true then
				ESX.ShowNotification('~r~Faktura wygasla')
			end
			alertkurwa = false
    	end
  	end
end)