local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false
local wozektimer = false
local isindressingmenu = false

local lib1_char_a, lib2_char_a, lib1_char_b, lib2_char_b, anim_start, anim_pump, anim_success = 'mini@cpr@char_a@cpr_def', 'mini@cpr@char_a@cpr_str', 'mini@cpr@char_b@cpr_def', 'mini@cpr@char_b@cpr_str', 'cpr_intro', 'cpr_pumpchest', 'cpr_success'

Citizen.CreateThread(function()
    RequestAnimDict(lib1_char_a)
    RequestAnimDict(lib2_char_a)

    RequestAnimDict(lib1_char_b)
    RequestAnimDict(lib2_char_b)

    -- RequestAnimDict("mini@cpr")
end)

-- MENU SKIN MEDYK

local MiejsceSkin = {x = -437.87, y = -308.43, z = 34.91}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false) 
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z)
		if not isindressingmenu then
			if dist <= 10.0 then
				DrawMarker(25, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z-0.95, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.6001, 0, 205, 250, 200, 0, 0, 0, 0)	
		   	 	if dist <= 1.0 then
		      		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
		        		ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby ~y~dopasować ubiór medyczny!')
		        		if IsControlJustPressed(0, 38) then
		          			TriggerServerEvent("ambulancejob:menuskin")
		          			isindressingmenu = true
		        		end
					end
				end
			end
		end
	end
end)

-- MENU SKIN MEDYK

function OpenAmbulanceActionsMenu()
	local elements = {
		{label = 'Ubrania z mieszkan', value = 'player_dressing'},
		{label = _U('cloakroom'), value = 'cloakroom'},
		{label = _U('szafka'), value = 'szafka'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions',
	{
		title		= _U('ambulance'),
		align		= 'center',
		elements	= elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'szafka' then
			OpenSzafka()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_societymordo:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false})
		end
		    if data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
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
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
      end)
    end
		
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('CUSTOM_esx_ambulance:playCPR')
AddEventHandler('CUSTOM_esx_ambulance:playCPR', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()

    local cpr = true

    Citizen.CreateThread(function()
        while cpr do
            Citizen.Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
        end
    end)

    ClampGameplayCamPitch(0.0, -90.0)

    local heading = 0.0

    -- SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    local coords = GetEntityCoords(playerPed)
	-- NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    --local x, y, z = table.unpack(playercoords + playerlocation * 1.0)
    local x, y, z = table.unpack(playercoords + playerlocation)
	NetworkResurrectLocalPlayer(x, y, z, playerheading, true, false)
	-- SetPlayerInvincible(playerPed, false)
	-- TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)

    -- SetEntityCoords(playerPed, x, y, z)
    SetEntityHeading(playerPed, playerheading - 270.0)


    TaskPlayAnim(playerPed, lib1_char_b, anim_start, 8.0, 8.0, -1, 0, 0, false, false, false)
    Citizen.Wait(15800 - 900)
    for i=1, 15, 1 do
        Citizen.Wait(900)
        TaskPlayAnim(playerPed, lib2_char_b, anim_pump, 8.0, 8.0, -1, 0, 0, false, false, false)
    end

    cpr = false

    TaskPlayAnim(playerPed, lib2_char_b, anim_success, 8.0, 8.0, -1, 0, 0, false, false, false)
end)


function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'center',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'},
			{label = 'Pokaz Identifikator', value = 'idenfi'}

		}
	}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title		= _U('ems_menu_title'),
				align		= 'center',
				elements	= {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'},
					{label = _U('ems_menu_putoutcar'), value = 'put_out_vehicle'},
					{label = 'Wozek inwalidzki', value = 'wozek'},
					{label = 'Usun wozek inwalidzki', value = 'wozek2'},
					{label = 'Nosze szpitalne', value = 'bed'},
					{label = 'Usun nosze szpitalne', value = 'bed2'}
				}
			}, function(data, menu)

				if IsBusy then return end
				if data.current.value == 'wozek' then
					if wozektimer == false then
						local playerPed = PlayerPedId()
						local coords    = GetEntityCoords(playerPed)
						local forward   = GetEntityForwardVector(playerPed)
						local x, y, z   = table.unpack(coords + forward * 1.0)
						ESX.Game.SpawnObject('prop_wheelchair_01', {
							x = x,
							y = y,
							z = z
						}, function(obj)
							SetEntityHeading(obj, GetEntityHeading(playerPed))
							PlaceObjectOnGroundProperly(obj)
						end)
						stoper()
						return
					else
						ESX.ShowNotification('Nie możesz tak szybko wyciągać wózków!')
						return
					end
				elseif data.current.value == 'wozek2' then
					local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_wheelchair_01'))
					if DoesEntityExist(wheelchair) then
						DeleteEntity(wheelchair)
						return
					end
				end

				if data.current.value == 'bed' then
					if wozektimer == false then
						local playerPed = PlayerPedId()
						local coords    = GetEntityCoords(playerPed)
						local forward   = GetEntityForwardVector(playerPed)
						local x, y, z   = table.unpack(coords + forward * 1.0)
						ESX.Game.SpawnObject('v_med_emptybed', {
							x = x+0.7,
							y = y,
							z = z
						}, function(obj)
							SetEntityHeading(obj, GetEntityHeading(playerPed))
							PlaceObjectOnGroundProperly(obj)
						end)
						stoper()
						return
					else
						ESX.ShowNotification('Nie możesz tak szybko wyciągać noszy!')
						return
					end
				elseif data.current.value == 'bed2' then
					local lozko = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('v_med_emptybed'))
					if DoesEntityExist(lozko) then
						DeleteEntity(lozko)
						return
					end
				end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.5 then
					ESX.ShowNotification(_U('no_players'))
				else

					if data.current.value == 'revive' then

						IsBusy = true

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)

								if IsPedDeadOrDying(closestPlayerPed, 1) then
									local playerPed = PlayerPedId()
									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
									ESX.ShowNotification(_U('revive_inprogress'))

									for i=1, 15 do
										Citizen.Wait(900)

										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
										end)
									end

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:revivee', GetPlayerServerId(closestPlayer))
								else
									ESX.ShowNotification(_U('player_not_unconscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end

							IsBusy = false

						end, 'medikit')

					elseif data.current.value == 'small' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'bandage')

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif data.current.value == 'put_out_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putOutVehicle', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'idenfi' then
			TriggerServerEvent('aurarp:legitkapokaz')
		end

	end, function(data, menu)
		menu.close()
	end)
end

function stoper()
	wozektimer = true
	Wait(10000)
	wozektimer = false
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

		for hospitalNum,hospital in pairs(Config.Hospitals) do

			-- Ambulance Actions
			for k,v in ipairs(hospital.AmbulanceActions) do
				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
				end
			end

			-- Pharmacies
			for k,v in ipairs(hospital.Pharmacies) do
				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
				end
			end

			--xd

			for k,v in ipairs(hospital.VehicleDeleter) do
				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehicleDeleter', k
				end
			end

			-- Vehicle Spawners
			for k,v in ipairs(hospital.Vehicles) do
				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < v.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
				end
			end

			if(GetDistanceBetweenCoords(playerCoords, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z, true) < 1.0) then
				isInMarker  = true
			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				isindressingmenu = false
			end

			if letSleep then
				Citizen.Wait(500)
			end
		end
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Pharmacy' then
			CurrentAction = part
			CurrentActionMsg = _U('open_pharmacy')
			CurrentActionData = {}
		elseif part == 'Vehicles' then
			CurrentAction = part
			CurrentActionMsg = _U('veh_spawn')
			CurrentActionData = {hospital = hospital, partNum = partNum, plate = "EMS " .. GetRandomIntInRange(100,999)}
		elseif part == 'VehicleDeleter' then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
		
			if IsPedInAnyVehicle(playerPed,  false) then
		
			  local vehicle = GetVehiclePedIsIn(playerPed, false)
		
			  if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			  end
		
			end
		end
	end
end)
AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenu(CurrentActionData)
				elseif CurrentAction == 'delete_vehicle' then
					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_societymordo:putVehicleInGarage', 'ambulance', vehicleProps)
					end
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				CurrentAction = nil

			end

		elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not IsDead then
			if IsControlJustReleased(0, Keys['F6']) then
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

--[[Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      	if IsControlJustReleased(0, 7) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not IsDead then
      		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        	if closestPlayer ~= -1 and closestDistance <= 2.0 then
        		TriggerServerEvent('esx_ambulacnejob:drag', GetPlayerServerId(closestPlayer))
    		else
    			ESX.ShowNotification('Brak graczy w ~r~pobliżu')
    		end
      	end
    end
end)]]

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:putOutVehicle')
AddEventHandler('esx_ambulancejob:putOutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title		= _U('cloakroom'),
		align		= 'center',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
			{label = 'Maska chirurgiczna', value = 'maska'},
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'maska' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
					['mask_1'] = 107, ['mask_2'] = 0
					}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenSzafka()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title		= _U('cloakroom'),
		align		= 'center',
		elements = {
			{label = _U('wez'), value = 'wez'},
			{label = _U('schowaj'), value = 'schowaj'},
		}
	}, function(data, menu)
		if data.current.value == 'wez' then
			OpenGetStocksMenu()
			end
		if data.current.value == 'schowaj' then
			OpenPutStocksMenu()
			end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_ambulancejob:getPlayerInventory', function(inventory)
  
	  local elements = {}
  
	  for i=1, #inventory.items, 1 do
  
		local item = inventory.items[i]
  
		if item.count > 0 then
		  table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end
  
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = 'Ekwipunek',
		  align = 'center',
		  elements = elements
		},
		function(data, menu)
  
		  local itemName = data.current.value
  
		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
			  title = 'Ilosc'
			},
			function(data2, menu2)
  
			  local count = tonumber(data2.value)
  
			  if count == nil then
				ESX.ShowNotification(_U('zla_ilosc'))
			  else
				menu2.close()
				menu.close()
				OpenPutStocksMenu()
  
				TriggerServerEvent('esx_ambulancejob:putStockItems', itemName, count)
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end

  function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(items)
  
  
	  local elements = {}
  
	  for i=1, #items, 1 do
		if items[i].count > 0 then
		table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
	  end
	end 
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = 'Magazyn EMS',
		  align = 'center',
		  elements = elements
		},
		function(data, menu)
  
		  local itemName = data.current.value
  
		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
			{
			  title = 'Ilosc'
			},
			function(data2, menu2)
  
			  local count = tonumber(data2.value)
  
			  if count == nil then
				ESX.ShowNotification(_U('zla_ilosc'))
			  else
				menu2.close()
				menu.close()
				OpenGetStocksMenu()
  
				TriggerServerEvent('esx_ambulancejob:getStockItem', itemName, count)
			  end
  
			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
  end

  function AddVehicleKeys(vehicle)
	local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
	if localVehPlateTest ~= nil then
	  local localVehPlate = string.lower(localVehPlateTest)
	  TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
	end
  end

function OpenVehicleSpawnerMenu(action)
	local playerCoords = GetEntityCoords(PlayerPedId())
	local distance = GetDistanceBetweenCoords(playerCoords, Config.Zones.VehicleSpawnPoint.Posxd, true)
	local distance2 = GetDistanceBetweenCoords(playerCoords, Config.Zones.VehicleSpawnPoint2.Posxd, true)
	local distance3 = GetDistanceBetweenCoords(playerCoords, Config.Zones.VehicleSpawnPoint3.Posxd, true)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
	{
		title		= _U('veh_menu'),
		align		= 'center',
		elements	= Config.AuthorizedVehicles
	}, function(data, menu)
		menu.close()

		if distance < 20 then
			ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, 174.76, function(vehicle)
				SetVehicleNumberPlateText(vehicle, action.plate)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				AddVehicleKeys(vehicle)
			end)
		end
		if distance2 < 20 then
			ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint2.Pos, 342.80, function(vehicle)
				SetVehicleNumberPlateText(vehicle, action.plate)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				AddVehicleKeys(vehicle)
			end)
		end
		if distance3 < 20 then
			ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint3.Pos, 113.20, function(vehicle)
				SetVehicleNumberPlateText(vehicle, action.plate)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				AddVehicleKeys(vehicle)
			end)
		end
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'vehicle_spawner_menu'
		CurrentActionMsg	= _U('veh_spawn')
		CurrentActionData	= {}
	end)
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle({
		x = coords.x,
		y = coords.y,
		z = coords.z
	})

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		local freeSeat = nil

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat ~= nil then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm',
		{
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'center',
			elements = {
				{ label = _U('confirm_no'), value = 'no' },
				{ label = _U('confirm_yes'), value = 'yes' }
			}
		}, function(data2, menu2)

			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
				
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
				
						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification(_U('vehicleshop_money'))
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end

		end, function(data2, menu2)
			menu2.close()
		end)

		end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy',
	{
		title    = _U('pharmacy_menu_title'),
		align    = 'center',
		elements = {
			{label = _U('pharmacy_take', _U('medikit')), value = 'medikit'},
			{label = _U('pharmacy_take', _U('bandage')), value = 'bandage'},
			{label = _U('pharmacy_take', 'Maska Tlenowa'), value = 'oxygen_mask'}
		}
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	elseif healType == 'leki' then
		if GetEntityHealth(playerPed) <= 175 then
			local health = GetEntityHealth(playerPed)
			local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
			SetEntityHealth(playerPed, newHealth)
		else
			ESX.ShowNotification('Nic cię nie boli, nie potrzebujesz leków!')
		end
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

--[[RegisterNetEvent('esx_ambulacnejob:drag')
AddEventHandler('esx_ambulacnejob:drag', function(cop)
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
			local myped = PlayerPedId()
			AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			DetachEntity(PlayerPedId(), true, false)
		end
	end
end)]]