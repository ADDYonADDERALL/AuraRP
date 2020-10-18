local PlayerData, CurrentAction = {}
ESX = nil

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

function OpenGetStocksMenu(station)
	ESX.TriggerServerCallback('sandy_comp:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Wyciągnij przedmiot'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Nieprawidłowa ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sandy_comp:getStockItem', station, itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, station)
end

function OpenPutStocksMenu(station)
	ESX.TriggerServerCallback('sandy_comp:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Twoje kieszenie'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Błędna ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sandy_comp:putStockItems', station, itemName, count)
					Citizen.Wait(300)
					OpenPutStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = ('Wyciągnij przedmiot'),  value = 'get_stock'},
		{label = ('Schowaj przedmiot'), value = 'put_stock'},
	}


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = ('Szafka'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu(station)
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu(station)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafke.')
		CurrentActionData = {station = station}
	end)
end

AddEventHandler('sandy_comp:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafke.')
		CurrentActionData = {station = station}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu szefa.')
		CurrentActionData = {}
	end
end)

AddEventHandler('sandy_comp:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(Config.Firmy) do
			if PlayerData.job and PlayerData.job.name == v.praca then
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local isInMarker, hasExited, letSleep = false, false, true
				local currentStation, currentPart, currentPartNum
				
				if PlayerData.job.grade >= v.szafkagrade then
					for i=1, #v.Szafka, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.Szafka[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(1, v.Szafka[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				end

				for i=1, #v.Przebieralnia, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Przebieralnia[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, v.Przebieralnia[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
					end
				end
				
				if PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(1, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end

				if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
					if
						(LastStation and LastPart and LastPartNum) and
						(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
					then
						TriggerEvent('sandy_comp:hasExitedMarker', LastStation, LastPart, LastPartNum)
						hasExited = true
					end

					HasAlreadyEnteredMarker = true
					LastStation             = currentStation
					LastPart                = currentPart
					LastPartNum             = currentPartNum

					TriggerEvent('sandy_comp:hasEnteredMarker', currentStation, currentPart, currentPartNum)
				end

				if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('sandy_comp:hasExitedMarker', LastStation, LastPart, LastPartNum)
				end

				if letSleep then
					Citizen.Wait(500)
				end
			end
		end
	end
end)

function OpenCloakroomMenu(station)
	local playerPed = PlayerPedId()

	local elements = {
		{ label = ('Ubrania'), value = 'player_dressing' },
		{ label = ('Przeglądaj ubrania'), value = 'przegladaj_ubrania' }
	}
	ESX.UI.Menu.CloseAll()
	if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {
			label = ('Dodaj ubranie'),
			value = 'zapisz_ubranie' 
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = ('Ubrania'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'przegladaj_ubrania' then
			ESX.TriggerServerCallback('sandy_comp:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
					}
					if PlayerData.job.grade_name == 'boss' then
						table.insert(elements2, {
							label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
							value = 'usun_ubranie' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
					title    = ('Ubrania'),
					align    = 'center',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'ubierz_sie' then
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('sandy_comp:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, station)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							TriggerServerEvent('sandy_comp:removeOutfit', data2.current.value, station)
							ESX.ShowNotification('Pomyślnie usunąłeś ubiór o nazwie: ' .. data2.current.label)
						end
					end, function(data3, menu3)
						menu3.close()
						
						CurrentAction     = 'menu_cloakroom'
						CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
						CurrentActionData = {}
					end)
					
				end, function(data2, menu2)
					menu2.close()
					
					CurrentAction     = 'menu_cloakroom'
					CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
					CurrentActionData = {}
				end)
			end, station)
		end
		if data.current.value == 'player_dressing' then

            ESX.TriggerServerCallback('root_property:getPlayerDressing', function(dressing)
                local elements = {}

                for i=1, #dressing, 1 do
                    table.insert(elements, {
                        label = dressing[i],
                        value = i
                    })
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
                    title    = 'Ubrania z mieszkań',
                    align    = 'center',
                    elements = elements
                }, function(data2, menu2)
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        ESX.TriggerServerCallback('root_property:getPlayerOutfit', function(clothes)
                            TriggerEvent('skinchanger:loadClothes', skin, clothes)
                            TriggerEvent('esx_skin:setLastSkin', skin)

                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                        end, data2.current.value)
                    end)
                end, function(data2, menu2)
                	menu2.close()
				
					CurrentAction     = 'menu_cloakroom'
					CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
					CurrentActionData = {}
                end)
      		end)
   		end
		if data.current.value == 'zapisz_ubranie' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
				title = ('Nazwa ubioru')
			}, function(data2, menu2)
				ESX.UI.Menu.CloseAll()

				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('sandy_comp:saveOutfit', data2.value, skin, station)
					ESX.ShowNotification('Pomyślnie zapisano ubiór o nazwie: ' .. data2.value)
				end)
				
				CurrentAction     = 'menu_cloakroom'
				CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
				CurrentActionData = {}
			end, function(data2, menu2)
				menu2.close()
				
				CurrentAction     = 'menu_cloakroom'
				CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
				CurrentActionData = {}
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	end)
end

Citizen.CreateThread(function()
	while true do
		local fps = true
		Citizen.Wait(1)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			for k,v in pairs(Config.Firmy) do
				fps = false
				if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == v.praca then
					if CurrentAction == 'menu_armory' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestDistance > 3 or closestPlayer == -1 then
							OpenArmoryMenu(CurrentActionData.station)
						else
							ESX.ShowNotification('Stoisz za blisko innego gracza!')
						end
					elseif CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu(v.praca)
					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent('esx_societymordo:openBossMenu', v.praca, function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu szefa.')
							CurrentActionData = {}
						end, { wash = false, grades = false })	
					end
					CurrentAction = nil
				end
			end
		end
		if fps then
			Wait(100)
		end
	end		
end)


RegisterNetEvent('sandyfakeid:checkdistance')
AddEventHandler('sandyfakeid:checkdistance', function(id, firstname, lastname, weapon, drive, insurance, job)
	if PlayerData.job2 ~= nil and PlayerData.job2.name == 'ndrangheta' and PlayerData.job2.grade_name == 'boss' then 
		local pCoords = GetEntityCoords(PlayerPedId())
		if(GetDistanceBetweenCoords(pCoords, 1402.78, 1154.37, 114.33, true) < 3) then
			TriggerServerEvent('sandyfakeid:setfakeid', id, firstname, lastname, weapon, drive, insurance, job)
		else
			ESX.ShowNotification('Stoisz za daleko szafki!')
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if PlayerData.job2 ~= nil and PlayerData.job2.name == 'ndrangheta' and PlayerData.job2.grade_name == 'boss' then
		local pCoords = GetEntityCoords(PlayerPedId())
			if(GetDistanceBetweenCoords(pCoords, 1402.78, 1154.37, 114.33, true) < 15) then
				DrawMarker(1, 1402.78, 1154.37, 114.33-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
				if(GetDistanceBetweenCoords(pCoords, 1402.78, 1154.37, 114.33, true) < 1) then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby otworzyc menu falszywych dowodow')
					if IsControlPressed(0, 54) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'fakeid_actions') then
						menufakeids()
					end
				end
			end
		end
	end
end)

function menufakeids()
	ESX.TriggerServerCallback('sandyfakeid:showfakeids', function(dane)

    local elements = {
      head = {'Imie', 'Nazwisko', 'Licencja na Bron', 'Prawo Jazdy', 'Ubezpieczenie', 'Praca', 'Akcje'},
      rows = {}
    }

    for i=1, #dane, 1 do
      table.insert(elements.rows, {
        data = dane[i],
        cols = {
          dane[i].firstname,
          dane[i].lastname,
          dane[i].weapon,
          dane[i].drive,
          dane[i].insurance,
          dane[i].job,
          '{{' .. 'Usun' .. '|usun}}'
        }
      })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'fakeid_actions', elements, function(data, menu)
      local target = data.data
      if data.value == 'usun' then
        TriggerServerEvent('sandyfakeid:removefakeids', target.owner)
        menu.close()
      end
    end, function(data, menu)
      menu.close()
    end)
  end)
end