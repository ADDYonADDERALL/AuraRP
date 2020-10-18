local PlayerData              = {}
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentGarage           = nil
local CurrentAction           = nil
local IsInShopMenu            = false
local pCoords 				  = nil
ESX                           = nil
GUI.Time                      = 0

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
	blipypolice()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	blipypolice()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Garages do
		if Config.Garages[i].Blip == true then
			local blip = AddBlipForCoord(Config.Garages[i].Marker)
			SetBlipSprite (blip, 50)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.5)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('garage_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
	for i=1, #Config.Impound, 1 do
		local blip2 = AddBlipForCoord(Config.Impound[i])
		SetBlipSprite (blip2, 67)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.6)
		SetBlipColour (blip2, 61)
		SetBlipAsShortRange(blip2, true)		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('impound_blip'))
		EndTextCommandSetBlipName(blip2)
	end
end)

function blipypolice()
	for i=1, #Config.PoliceImpound, 1 do
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			blip4 = AddBlipForCoord(Config.PoliceImpound[i])
			SetBlipSprite (blip4, 67)
			SetBlipDisplay(blip4, 4)
			SetBlipScale  (blip4, 0.6)
			SetBlipColour (blip4, 3)
			SetBlipAsShortRange(blip4, true)		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Policyjne odholowywanie pojazdów')
			EndTextCommandSetBlipName(blip4)
		end
	end
end

local cache = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for _, data in ipairs(cache) do
			DrawMarker(data.marker, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, data.offset.x, data.offset.y, data.offset.z, data.size.x, data.size.y, data.size.z, data.color.r, data.color.g, data.color.b, 100, false, true, 2, false, false, false, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		cache = {}
		local isInMarker  = false
    	local currentZone = nil
		local playerPed = GetPlayerPed(-1)
		pCoords = GetEntityCoords(PlayerPedId())
		for i=1, #Config.Garages, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.Garages[i].Marker, true) < Config.DrawDistance) then
				if Config.Garages[i].Visible[1] == nil then
					table.insert(cache, {
						marker = Config.MarkerType,
						coords  = Config.Garages[i].Marker,
						offset = {x = 0.0, y = 0.0, z = 0.0},
						size = {x = 5.0, y = 5.0, z = 0.5},
						color = {r = 17, g = 255, b = 0}
					})
					if(GetDistanceBetweenCoords(pCoords, Config.Garages[i].Marker, true) < Config.MarkerSize.x) then
						if IsPedInAnyVehicle(playerPed) then
							isInMarker  = true
							currentZone = 'park_car'
							CurrentGarage = Config.Garages[i].Marker
						elseif not IsPedInAnyVehicle(playerPed) then
							isInMarker = true
							currentZone = 'pullout_car'
							CurrentGarage = Config.Garages[i].Marker
						end
					end
				else
					for j=1, #Config.Garages[i].Visible, 1 do
						if PlayerData.job ~= nil and PlayerData.job.name == Config.Garages[i].Visible[j] or PlayerData.job2 ~= nil and PlayerData.job2.name == Config.Garages[i].Visible[j] then
							table.insert(cache, {
								marker = Config.MarkerType,
								coords  = Config.Garages[i].Marker,
								offset = {x = 0.0, y = 0.0, z = 0.0},
								size = {x = 5.0, y = 5.0, z = 0.5},
								color = {r = 17, g = 255, b = 0}
							})
							if(GetDistanceBetweenCoords(pCoords, Config.Garages[i].Marker, true) < Config.MarkerSize.x) then
								if IsPedInAnyVehicle(playerPed) then
									isInMarker  = true
									currentZone = 'park_car'
									CurrentGarage = Config.Garages[i].Marker
								elseif not IsPedInAnyVehicle(playerPed) then
									isInMarker = true
									currentZone = 'pullout_car'
									CurrentGarage = Config.Garages[i].Marker
								end
							end
						end
					end
				end
			end
		end

		for i=1, #Config.PoliceGarages, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.PoliceGarages[i].Marker, true) < Config.DrawDistance) then
				for j=1, #Config.PoliceGarages[i].Visible, 1 do
					if PlayerData.job ~= nil and PlayerData.job.name == Config.PoliceGarages[i].Visible[j] or PlayerData.job2 ~= nil and PlayerData.job2.name == Config.PoliceGarages[i].Visible[j] then
						table.insert(cache, {
							marker = Config.MarkerType,
							coords  = Config.PoliceGarages[i].Marker,
							offset = {x = 0.0, y = 0.0, z = 0.0},
							size = {x = 5.0, y = 5.0, z = 0.5},
							color = {r = 0, g = 0, b = 255}
						})
						if(GetDistanceBetweenCoords(pCoords, Config.PoliceGarages[i].Marker, true) < Config.MarkerSize.x) then
							if IsPedInAnyVehicle(playerPed) then
								isInMarker  = true
								currentZone = 'policepark_car'
								CurrentGarage = Config.PoliceGarages[i].Marker
							elseif not IsPedInAnyVehicle(playerPed) then
								isInMarker = true
								currentZone = 'policepullout_car'
								CurrentGarage = Config.PoliceGarages[i].Marker
							end
						end
					end
				end
			end
		end

		for i=1, #Config.Impound, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.Impound[i], true) < Config.DrawDistance) then
				table.insert(cache, {
					marker = Config.MarkerType,
					coords  = Config.Impound[i],
					offset = {x = 0.0, y = 0.0, z = 0.0},
					size = {x = 5.0, y = 5.0, z = 0.5},
					color = {r = 17, g = 255, b = 0}
				})
				if(GetDistanceBetweenCoords(pCoords, Config.Impound[i], true) < Config.MarkerSize.x) then
					isInMarker  = true
					currentZone = 'impound_veh'
					CurrentGarage = Config.Impound[i]
				end
			end	
		end

		for i=1, #Config.SetSubowner, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.SetSubowner[i], true) < Config.DrawDistance) then
				table.insert(cache, {
					marker = Config.MarkerType,
					coords  = Config.SetSubowner[i],
					offset = {x = 0.0, y = 0.0, z = 0.0},
					size = {x = 5.0, y = 5.0, z = 0.5},
					color = {r = 17, g = 255, b = 0}
				})
				if(GetDistanceBetweenCoords(pCoords, Config.SetSubowner[i], true) < Config.MarkerSize.x) then
					isInMarker  = true
					currentZone = 'subowner_veh'
					CurrentGarage = Config.SetSubowner[i]
				end
			end	
		end

		for i=1, #Config.PoliceImpound, 1 do
			if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				if(GetDistanceBetweenCoords(pCoords, Config.PoliceImpound[i], true) < Config.DrawDistance) then
					table.insert(cache, {
						marker = Config.MarkerType,
						coords  = Config.PoliceImpound[i],
						offset = {x = 0.0, y = 0.0, z = 0.0},
						size = {x = 5.0, y = 5.0, z = 0.5},
						color = {r = 17, g = 255, b = 0}
					})
					if(GetDistanceBetweenCoords(pCoords, Config.PoliceImpound[i], true) < Config.MarkerSize.x) then
						isInMarker  = true
						currentZone = 'police_impound_veh'
						CurrentGarage = Config.PoliceImpound[i]
					end
				end
			end
		end

		for i=1, #Config.SandyZlom, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.SandyZlom[i], true) < Config.DrawDistance) then
				table.insert(cache, {
					marker = Config.MarkerType,
					coords  = Config.SandyZlom[i],
					offset = {x = 0.0, y = 0.0, z = 0.0},
					size = {x = 5.0, y = 5.0, z = 0.5},
					color = {r = 17, g = 255, b = 0}
				})
				if(GetDistanceBetweenCoords(pCoords, Config.SandyZlom[i], true) < Config.MarkerSize.x) then
					isInMarker  = true
					currentZone = 'sandyzlom_veh'
					CurrentGarage = Config.SandyZlom[i]
				end
			end
		end

		for i=1, #Config.SandyZlomLista, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.SandyZlomLista[i], true) < Config.DrawDistance) then
				table.insert(cache, {
					marker = Config.MarkerType,
					coords  = Config.SandyZlomLista[i],
					offset = {x = 0.0, y = 0.0, z = 0.0},
					size = {x = 5.0, y = 5.0, z = 0.5},
					color = {r = 17, g = 255, b = 0}
				})
				if(GetDistanceBetweenCoords(pCoords, Config.SandyZlomLista[i], true) < Config.MarkerSize.x) then
					isInMarker  = true
					currentZone = 'sandyzlom_list'
					CurrentGarage = Config.SandyZlomLista[i]
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('sandy_garages:hasEnteredMarker', currentZone)
	    end
	    if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('sandy_garages:hasExitedMarker', LastZone)
	    end

	end
end)

function SpawnImpoundedVehicle(plate)
	TriggerServerEvent('sandy_garages:updateState', plate)
end

function SubownerVehicle()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'subowner_player',
		{
			title = _U('veh_reg'),
			align = 'center'
		},
		function(data, menu)
			local plate = string.upper(tostring(data.value))
			if string.len(plate) < 7 or string.len(plate) > 7 then
				ESX.ShowNotification(_U('no_veh'))
			else
				ESX.TriggerServerCallback('sandy_garages:checkIfPlayerIsOwner', function(isOwner)
					if isOwner then
						menu.close()
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'subowner_menu',
							{
								title = _U('owner_menu', plate),
								align = 'center',
								elements	= {
									{label = _U('set_sub'), value = 'give_sub'},
									{label = _U('manage_sub'), value = 'manage_sub'},
									{label = 'Oddaj Samochod', value = 'sellveh'}
								}
							},
							function(data2, menu2)
								if data2.current.value == 'give_sub' then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= -1 and closestDistance <= 3.0 then
										TriggerServerEvent('sandy_garages:setSubowner', plate, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification(_U('no_players'))
									end
								elseif data2.current.value == 'manage_sub' then
									ESX.TriggerServerCallback('sandy_garages:getSubowners', function(subowners)
										if #subowners > 0 then
											ESX.UI.Menu.Open(
												'default', GetCurrentResourceName(), 'subowners',
												{
													title = _U('deleting_sub', plate),
													align = 'center',
													elements = subowners
												},
												function(data3, menu3)
													local subowner = data3.current.value
													ESX.UI.Menu.Open(
														'default', GetCurrentResourceName(), 'yesorno',
														{
															title = _U('sure_delete'),
															align = 'center',
															elements = {
																{label = _U('no'), value = 'no'},
																{label = _U('yes'), value = 'yes'}
															}
														},
														function(data4, menu4)
															if data4.current.value == 'yes' then
																TriggerServerEvent('sandy_garages:deleteSubowner', plate, subowner)
																menu4.close()
																menu3.close()
																menu2.close()
															elseif data4.current.value == 'no' then
																menu4.close()
															end
														end,
														function(data4, menu4)
															menu4.close()
														end
													)													
												end,
												function(data3, menu3)
													menu3.close()
												end
											)
										else
											ESX.ShowNotification(_U('no_subs'))
										end
									end, plate)
								elseif data2.current.value == 'sellveh' then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= -1 and closestDistance <= 3.0 then
										TriggerServerEvent('sandy_garages:sellvehicle', plate, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification(_U('no_players'))
									end
								end
							end,
							function(data2,menu2)
								menu2.close()
							end
						)
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, plate)
			end
		end,
		function(data,menu)
			menu.close()
		end
	)
end
-- Key controls
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if CurrentAction ~= nil then
			if CurrentAction == 'park_car' then
				DisplayHelpText(_U('store_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					OpenPutCarMenu()
					CurrentAction = 'park_car'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'pullout_car' then
				DisplayHelpText(_U('release_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					OpenPullCarMenu()
					CurrentAction = 'pullout_car'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'policepark_car' then
				DisplayHelpText(_U('release_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					OpenPutPoliceCarMenu()
					CurrentAction = 'policepark_car'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'policepullout_car' then
				DisplayHelpText(_U('release_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					OpenPullPoliceCarMenu()
					CurrentAction = 'policepullout_car'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'tow_menu' then
				DisplayHelpText(_U('tow_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					OpenTowMenu()
					CurrentAction = 'tow_menu'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'police_impound_menu' then
				DisplayHelpText(_U('p_impound_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					SendNUIMessage({
						clearpolice = true
					})
					ESX.TriggerServerCallback('sandy_garages:getTakedVehicles', function(vehicles)
						for i=1, #vehicles, 1 do
							SendNUIMessage({
								policecar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<font color=#000000>[" .. vehicles[i].plate .. "]</font>&emsp;" ..  GetDisplayNameFromVehicleModel(vehicles[i].model)
							})
						end
					end)
					openGui()
					CurrentAction = 'police_impound_menu'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'subowner_veh' then
				DisplayHelpText(_U('subowner_veh'))
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
						SubownerVehicle()
					end
					CurrentAction = 'subowner_veh'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'sandyzlom_veh' then
				DisplayHelpText('Nacisnij ~INPUT_CONTEXT~, aby zezlomowac samochod')
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					local playerPed = GetPlayerPed(-1)
					local vehicle       = GetVehiclePedIsIn(playerPed)
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local modelkurwacar1 = GetDisplayNameFromVehicleModel(vehicleProps.model)
					local plate         = vehicleProps.plate
					local kurwamodel	= GetEntityModel(vehicle)
					if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
						TriggerServerEvent("sandy_garages:sandysendzlom", vehicleProps,modelkurwacar1,kurwamodel)
					else
						ESX.ShowNotification('Musisz kierowac autem aby je zezlomowac!')
					end
					CurrentAction = 'sandyzlom_veh'
					GUI.Time      = GetGameTimer()
				end
			elseif CurrentAction == 'sandyzlom_list' then
				DisplayHelpText('Nacisnij ~INPUT_CONTEXT~, aby przejrzec liste zezlomowanych samochodow')
				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
					ZlomedCarsMenu()
					CurrentAction = 'sandyzlom_list'
					GUI.Time      = GetGameTimer()
				end
			end
		end
	end
end)

function changecarmodelname(car)
	local carnames = {
		{label = ('Raptor'), price = 250000, value = '1raptor'},
        {label = ('Dodge 14'), price = 100000, value = '14awd'},
        {label = ('Ford Fusion'), price = 175000, value = '17fusionrb'},
        {label = ('Colorado'), price = 300000, value = '17zr2'},
        {label = ('Ford F350'), price = 250000, value = '20f350'},
        {label = ('Silverado'), price = 275000, value = '20silv'},
        {label = ('Challanger 18'), price = 350000, value = 'challenger18'},
        {label = ('Dodge 16'), price = 125000, value = 'charger1'},
        {label = ('Dodge Charger 14 UC'), price = 150000, value = 'charger14'},
        {label = ('Victoria'), price = 50000, value = 'cvpi'},
        {label = ('Challanger'), price = 250000, value = 'demonrb'},
        {label = ('Explorer'), price = 125000, value = 'explorer1'},
        {label = ('Explorer UC'), price = 225000, value = 'fpiu'},
        {label = ('Tahoe'), price = 175000, value = 'fr'},
        {label = ('GMC'), price = 250000, value = 'gmc'},
        {label = ('Dodge Charger'), price = 350000, value = 'heat2'},
        {label = ('Dodge SRT Hellcat'), price = 500000, value = 'hellcatred'},
        {label = ('Mustang'), price = 750000, value = 'mustang19'},
        {label = ('Dodge Ram'), price = 225000, value = 'polram1'},
        {label = ('Jeep'), price = 150000, value = 'poljeep1'},
        {label = ('Dodge Ram'), price = 275000, value = 'river01'},
        {label = ('Taurus'), price = 75000, value = 'sp1'},
        {label = ('Suburban'), price = 200000, value = 'suburbanpd'}
	}
	for _, editedcarnames in pairs(carnames) do
		if car == editedcarnames.value then
			return editedcarnames.label
		end
	end
	return car
end


function isjobWhitelisted(job)
	for _, whitelistedJob in pairs(Config.OrgGarages) do
		if job == whitelistedJob then
			return true
		end
	end
	return false
end

function isjobWhitelistedEmg(job)
	for _, whitelistedJobEmg in pairs(Config.EmgGarages) do
		if job == whitelistedJobEmg then
			return true
		end
	end
	return false
end

function OpenPutPoliceCarMenu()
	local elements = {}
	if PlayerData.job ~= nil and isjobWhitelistedEmg(PlayerData.job.name) then
		table.insert(elements, {label = ('Garaz Frakcji'), value = 'emggarage'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garageputcarmenu', {
		title    = ('Garaz'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local playerPed 	= PlayerPedId()
		local vehicle       = GetVehiclePedIsIn(playerPed)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
		local plate         = vehicleProps.plate
		local kurwamodel	= GetEntityModel(vehicle)
		local playerjob 	= PlayerData.job.name
		local kurwapraca 	= PlayerData.job2.name
		if data.current.value == 'emggarage' then
			menu.close()
			Citizen.Wait(200)
			if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
				ESX.TriggerServerCallback('sandy_garages:sandycheckIfVehicleIsOwnedEMG2', function (owned)
					if owned ~= nil then
						local vehicleProps2  = GetVehicleProperties(vehicle)                    
						TriggerServerEvent("sandy_garages:sandysendcarEMG", vehicleProps2, playerjob)
						TaskLeaveVehicle(playerPed, vehicle, 16)
						Citizen.Wait(200)
						while DoesEntityExist(vehicle) do
							ESX.Game.DeleteVehicle(vehicle)
							Wait(100)
						end
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, vehicleProps.plate, kurwamodel, playerjob)
			else
				ESX.ShowNotification('Musisz kierować autem żeby je schować!')
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutCarMenu()
	local elements = {
		{label = ('Garaz'), value = 'garage'}
	}

	if PlayerData.job2 ~= nil and isjobWhitelisted(PlayerData.job2.name) then
		table.insert(elements, {label = ('Garaz Organizacji'), value = 'orggarage'})
	end
	if PlayerData.job2 ~= nil and isjobWhitelisted(PlayerData.job2.name) and PlayerData.job2.grade_name == 'boss' then
		table.insert(elements, {label = ('Akcje Szefa Organizacji'), value = 'orggarageboss'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garageputcarmenu', {
		title    = ('Garaz'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local playerPed 	= PlayerPedId()
		local vehicle       = GetVehiclePedIsIn(playerPed)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
		local plate         = vehicleProps.plate
		local kurwamodel	= GetEntityModel(vehicle)
		local playerjob 	= PlayerData.job.name
		local kurwapraca 	= PlayerData.job2.name
		if data.current.value == 'garage' then
			menu.close()
			Citizen.Wait(200)
			if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
				ESX.TriggerServerCallback('sandy_garages:checkIfVehicleIsOwned2', function (owned)
					if owned ~= nil then
						local vehicleProps2  = GetVehicleProperties(vehicle)
						TriggerServerEvent("sandy_garages:updateOwnedVehicle", vehicleProps2)
						TaskLeaveVehicle(playerPed, vehicle, 16)
						Citizen.Wait(200)
						while DoesEntityExist(vehicle) do
							ESX.Game.DeleteVehicle(vehicle)
							Wait(100)
						end
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, vehicleProps.plate, kurwamodel)
			else
				ESX.ShowNotification('Musisz kierować autem żeby je schować!')
			end
		elseif data.current.value == 'emggarage' then
			menu.close()
			Citizen.Wait(200)
			if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
				ESX.TriggerServerCallback('sandy_garages:sandycheckIfVehicleIsOwnedEMG2', function (owned)
					if owned ~= nil then
						local vehicleProps2  = GetVehicleProperties(vehicle)                    
						TriggerServerEvent("sandy_garages:sandysendcarEMG", vehicleProps2, playerjob)
						TaskLeaveVehicle(playerPed, vehicle, 16)
						Citizen.Wait(200)
						while DoesEntityExist(vehicle) do
							ESX.Game.DeleteVehicle(vehicle)
							Wait(100)
						end
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, vehicleProps.plate, kurwamodel, playerjob)
			else
				ESX.ShowNotification('Musisz kierować autem żeby je schować!')
			end
		elseif data.current.value == 'orggarage' then
			menu.close()
			Citizen.Wait(200)
			if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
				ESX.TriggerServerCallback('sandy_garages:sandycheckIfVehicleIsOwned', function (owned)
					if owned ~= nil then
						local vehicleProps2  = GetVehicleProperties(vehicle)                    
						TriggerServerEvent("sandy_garages:sandysendkurwacar2", vehicleProps2, kurwapraca)
						TaskLeaveVehicle(playerPed, vehicle, 16)
						Citizen.Wait(200)
						while DoesEntityExist(vehicle) do
							ESX.Game.DeleteVehicle(vehicle)
							Wait(100)
						end
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, vehicleProps.plate, kurwamodel, kurwapraca)
			else
				ESX.ShowNotification('Musisz kierować autem żeby je schować!')
			end
		elseif data.current.value == 'orggarageboss' then
			menu.close()
			BossCarMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPullPoliceCarMenu()
	local elements = {}
	if PlayerData.job ~= nil and isjobWhitelistedEmg(PlayerData.job.name) then
		table.insert(elements, {label = ('Garaz Frakcji'), value = 'emggarage'})
	end
	if PlayerData.job ~= nil and isjobWhitelistedEmg(PlayerData.job.name) and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = ('Akcje Szefa Frakcji'), value = 'emggarageboss'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garageputcarmenu', {
		title    = ('Garaz'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'emggarage' then
			menu.close()
			local playerjob = PlayerData.job.name

			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesInGarageEMG', function(vehicles)

				local elements = {}
				for i=1, #vehicles, 1 do
					if vehicles[i] then
						local nazwa
						local nazwa2
						local nazwa3
						if nazwa == nil then
							nazwa = 'white'
							if round(vehicles[i].engineHealth)/10 < 30.99 then
								nazwa = 'red'
							elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
								nazwa = 'yellow'
							elseif round(vehicles[i].engineHealth)/10 > 76 then
								nazwa = 'green'
							end
						end

						if nazwa2 == nil then
							nazwa2 = 'white'
							if round(vehicles[i].bodyHealth)/10 < 30.99 then
								nazwa2 = 'red'
							elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
								nazwa2 = 'yellow'
							elseif round(vehicles[i].bodyHealth)/10 > 76 then
								nazwa2 = 'green'
							end
						end

						if nazwa3 == nil then
							nazwa3 = 'white'
							if round(vehicles[i].fuelLevel) < 30.99 then
								nazwa3 = 'red'
							elseif round(vehicles[i].fuelLevel) > 31 and round(vehicles[i].fuelLevel) < 75.99 then
								nazwa3 = 'yellow'
							elseif round(vehicles[i].fuelLevel) > 76 then
								nazwa3 = 'green'
							end
						end
						local actualcarname = changecarmodelname(GetDisplayNameFromVehicleModel(vehicles[i].model))
						table.insert(elements, {label = '['..vehicles[i].plate..'] ['..actualcarname..'] [Silnik: <font color='..nazwa..'>'..(round(vehicles[i].engineHealth)/10)..'</font>] [Karoseria:  <font color='..nazwa2..'>'..(round(vehicles[i].bodyHealth)/10)..'</font>] [Paliwo: <font color='..nazwa3..'>'..round(vehicles[i].fuelLevel)..'</font>]', value = vehicles[i].plate})
					end
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
						title    = ('Garaz Frakcji'),
						align    = 'center',
						elements = elements
					}, function(data2, menu2)
						local playerPed = PlayerPedId()
						local heading, coords = GetEntityHeading(playerPed), GetEntityCoords(playerPed, true)
						ESX.TriggerServerCallback('sandy_garages:sandycheckIfVehicleIsOwnedEMG', function (owned)
							local spawnCoords  = {
								x = coords.x,
								y = coords.y,
								z = coords.z,
							}
							ESX.Game.SpawnVehicle(owned.model, spawnCoords, heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
								local kurwakolorswiatel
								if owned.headlights ~= nil then
									kurwakolorswiatel = owned.headlights
								else
									kurwakolorswiatel = -1
								end
								AddVehicleKeys(vehicle)
								SetVehicleProperties(vehicle, owned)
								SetVehicleHeadlightsColour(vehicle, kurwakolorswiatel)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								local localVehLockStatus = GetVehicleDoorLockStatus(vehicle)
								TriggerEvent("ls:getOwnedVehicle", vehicle, localVehPlate, localVehLockStatus)
								local networkid = NetworkGetNetworkIdFromEntity(vehicle)
								TriggerServerEvent("sandy_garages:sandyremoveCarFromParkingEMG", owned.plate, networkid)
								local vehicleProps  = GetVehicleProperties(vehicle)
								vehicleProps["engineHealth"] = 1000.0
								TriggerServerEvent("sandy_garages:sandyupdateOwnedVehicleEMG", vehicleProps, playerjob)
							end)
						end, data2.current.value, playerjob)
						menu2.close()
						end, function(data2, menu2)
					menu2.close()
				end)
			end, playerjob)
		elseif data.current.value == 'emggarageboss' then
			menu.close()
			EMGBossCarMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPullCarMenu()
	local elements = {
		{label = ('Garaz'), value = 'garage'}
	}

	if PlayerData.job2 ~= nil and isjobWhitelisted(PlayerData.job2.name) then
		table.insert(elements, {label = ('Garaz Organizacji'), value = 'orggarage'})
	end
	if PlayerData.job2 ~= nil and isjobWhitelisted(PlayerData.job2.name) and PlayerData.job2.grade_name == 'boss' then
		table.insert(elements, {label = ('Akcje Szefa Organizacji'), value = 'orggarageboss'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garageputcarmenu', {
		title    = ('Garaz'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'garage' then
			menu.close()
			SendNUIMessage({
				clearme = true
			})
								
			ESX.TriggerServerCallback('sandy_garages:getVehiclesInGarage', function(vehicles)
				for i=1, #vehicles, 1 do
					local nazwa
					local nazwa2
					local nazwa3
					if nazwa == nil then
						nazwa = '#fc2200'
						if round(vehicles[i].engineHealth)/10 < 30.99 then
							nazwa = '#fc2200'
						elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
							nazwa = '#fca400'
						elseif round(vehicles[i].engineHealth)/10 > 76 then
							nazwa = '#4dd446'
						end
					end

					if nazwa2 == nil then
						nazwa2 = '#fc2200'
						if round(vehicles[i].bodyHealth)/10 < 30.99 then
							nazwa2 = '#fc2200'
						elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
							nazwa2 = '#fca400'
						elseif round(vehicles[i].bodyHealth)/10 > 76 then
							nazwa2 = '#4dd446'
						end
					end

					if nazwa3 == nil then
						nazwa3 = '#fc2200'
						if round(vehicles[i].fuelLevel) < 30.99 then
							nazwa3 = '#fc2200'
						elseif round(vehicles[i].fuelLevel) > 31 and round(vehicles[i].fuelLevel) < 75.99 then
							nazwa3 = '#fca400'
						elseif round(vehicles[i].fuelLevel) > 76 then
							nazwa3 = '#4dd446'
						end
					end

					SendNUIMessage({
						addcar = true,
						number = i,
						model = vehicles[i].plate,
						name = "<font color=#000000>[ " .. vehicles[i].plate .. " ]</font>&emsp;<b>" ..  GetDisplayNameFromVehicleModel(vehicles[i].model) .. "</b>&emsp;  <font size=2.5><b>Silnik</b>: <font color="..nazwa..">" .. round(vehicles[i].engineHealth) /10 .. "%</font>" .. "&emsp;  <b>Karoseria</b>: <font color="..nazwa2..">" .. round(vehicles[i].bodyHealth) /10 .. "%</font>" .. "&emsp;  <b>Paliwo</b>: <font color="..nazwa3..">" .. round(vehicles[i].fuelLevel) .. "%</font>"
					})
				end
			end)
			openGui()
		elseif data.current.value == 'orggarage' then
			menu.close()
			local kurwapraca 	= PlayerData.job2.name
			SendNUIMessage({
				clearme = true
			})
					
			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesInGarage', function(vehicles)
				for i=1, #vehicles, 1 do
					local nazwa
					local nazwa2
					local nazwa3
					if nazwa == nil then
						nazwa = '#fc2200'
						if round(vehicles[i].engineHealth)/10 < 30.99 then
							nazwa = '#fc2200'
						elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
							nazwa = '#fca400'
						elseif round(vehicles[i].engineHealth)/10 > 76 then
							nazwa = '#4dd446'
						end
					end

					if nazwa2 == nil then
						nazwa2 = '#fc2200'
						if round(vehicles[i].bodyHealth)/10 < 30.99 then
							nazwa2 = '#fc2200'
						elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
							nazwa2 = '#fca400'
						elseif round(vehicles[i].bodyHealth)/10 > 76 then
							nazwa2 = '#4dd446'
						end
					end

					if nazwa3 == nil then
						nazwa3 = '#fc2200'
						if round(vehicles[i].fuelLevel) < 30.99 then
							nazwa3 = '#fc2200'
						elseif round(vehicles[i].fuelLevel) > 31 and round(vehicles[i].fuelLevel) < 75.99 then
							nazwa3 = '#fca400'
						elseif round(vehicles[i].fuelLevel) > 76 then
							nazwa3 = '#4dd446'
						end
					end

					SendNUIMessage({
						addcar = true,
						number = i,
						model = vehicles[i].plate,
						name = "<font color=#000000>[ " .. vehicles[i].plate .. " ]</font>&emsp;<b>" ..  GetDisplayNameFromVehicleModel(vehicles[i].model) .. "</b>&emsp;  <font size=2.5><b>Silnik</b>: <font color="..nazwa..">" .. round(vehicles[i].engineHealth) /10 .. "%</font>" .. "&emsp;  <b>Karoseria</b>: <font color="..nazwa2..">" .. round(vehicles[i].bodyHealth) /10 .. "%</font>" .. "&emsp;  <b>Paliwo</b>: <font color="..nazwa3..">" .. round(vehicles[i].fuelLevel) .. "%</font>"
					})
				end
			end, kurwapraca)
			openGui()
		elseif data.current.value == 'orggarageboss' then
			menu.close()
			BossCarMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenTowMenu()
	local elements = {
		{label = ('Odholownik'), value = 'towcaroption'}
	}
	if PlayerData.job ~= nil and isjobWhitelistedEmg(PlayerData.job.name) then
		table.insert(elements, {label = ('Odholownik Frakcji'), value = 'towemggarage'})
	end
	if PlayerData.job2 ~= nil and isjobWhitelisted(PlayerData.job2.name) then
		table.insert(elements, {label = 'Odholownik ogranizacji', value = 'towcaroptiongang'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'towcarmenu', {
		title    = ('Odholownik'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'towcaroption' then
			menu.close()
			SendNUIMessage({
				clearimp = true
			})
			ESX.TriggerServerCallback('sandy_garages:getVehiclesToTow', function(vehicles)
				for i=1, #vehicles, 1 do
					SendNUIMessage({
						impcar = true,
						number = i,
						model = vehicles[i].plate,
						name = "<font color=#000000>[" .. vehicles[i].plate .. "]</font>&emsp;" ..  GetDisplayNameFromVehicleModel(vehicles[i].model)
					})
				end
			end)
			openGui()
		elseif data.current.value == 'towcaroptiongang' then
			menu.close()
			GangsterImpoundMenu()
		elseif data.current.value == 'towemggarage' then
			menu.close()
			EMGImpoundMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ZlomedCarsMenu()
	local elements = {
		{label = ('Przejrzyj liste zezlomowanych pojazdow'), value = 'zlomed_car'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
		title    = ('Zlomowisko'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'zlomed_car' then

			ESX.TriggerServerCallback('sandy_garages:sandygetzlomedvehicles', function(vehicles)

			local elements = {}
			for i=1, #vehicles, 1 do
				if vehicles[i] then
					local modelzajebisty = GetDisplayNameFromVehicleModel(tonumber(vehicles[i].model))
					table.insert(elements, {label = '[REJ: '..vehicles[i].plate..']    |    [Model: '..modelzajebisty..']    |    [Pozostaly Czas: '..vehicles[i].zlom..' H]', value = vehicles[i]})
				end
			end

			ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
					title    = ('Lista zezlomowanych pojazdow'),
					align    = 'center',
					elements = elements
				}, function(data, menu)
					menu.close()
					end, function(data, menu)
				menu.close()
			end)
		end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('sandykurwazlom:superfajnyzlom')
AddEventHandler('sandykurwazlom:superfajnyzlom', function()
	local playerPed = GetPlayerPed(-1)
	local vehicle       = GetVehiclePedIsIn(playerPed)
	Citizen.Wait(100)
	TaskLeaveVehicle(playerPed, vehicle, 0)
	Citizen.Wait(2000)
	ESX.Game.DeleteVehicle(vehicle)
end)

function GangsterImpoundMenu()
	local elements = {
		{label = ('Wyciagnij Samochod'), value = 'orgget_car'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impoundorg', {
		title    = ('Odholownik Ogranizacji'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'orgget_car' then
			local kurwapraca 	= PlayerData.job2.name

			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesToTow', function(vehicles)

			local elements = {}
			for i=1, #vehicles, 1 do
				if vehicles[i] then
					table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) ..' - '.. vehicles[i].plate, value = vehicles[i]})
				end
			end

			ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impoundorg', {
					title    = ('Odholuj Samochod'),
					align    = 'center',
					elements = elements
				}, function(data, menu)

					ESX.TriggerServerCallback('sandy_garages:checkMoney', function(hasMoney)
						if hasMoney then
							ESX.ShowNotification(_U('checking_veh'))
							Citizen.Wait(math.random(500, 4000))
							TriggerServerEvent('sandy_garages:pay')
							SpawnImpoundedVehicle(data.current.value.plate)
							ESX.ShowNotification(_U('veh_impounded', data.current.value.plate))
						else
							ESX.ShowNotification(_U('no_money'))
						end
					end)
					
					menu.close()
					end, function(data, menu)
				menu.close()
			end)
		end, kurwapraca)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function EMGImpoundMenu()
	local elements = {
		{label = ('Wyciagnij Samochod'), value = 'emgget_car'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impoundorg', {
		title    = ('Odholownik Frakcji'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'emgget_car' then
			local kurwapraca 	= PlayerData.job.name

			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesToTowEMG', function(vehicles)

			local elements = {}
			for i=1, #vehicles, 1 do
				if vehicles[i] then
					table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) ..' - '.. vehicles[i].plate, value = vehicles[i]})
				end
			end

			ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impoundorg', {
					title    = ('Odholuj Samochod'),
					align    = 'center',
					elements = elements
				}, function(data, menu)

					ESX.TriggerServerCallback('sandy_garages:checkMoney', function(hasMoney)
						if hasMoney then
							ESX.ShowNotification(_U('checking_veh'))
							Citizen.Wait(math.random(500, 4000))
							TriggerServerEvent('sandy_garages:pay')
							TriggerServerEvent('sandy_garages:updateStateEMG', data.current.value.plate)
							ESX.ShowNotification(_U('veh_impounded', data.current.value.plate))
						else
							ESX.ShowNotification(_U('no_money'))
						end
					end)
					
					menu.close()
					end, function(data, menu)
				menu.close()
			end)
		end, kurwapraca)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function EMGBossCarMenu()
	local elements = {
		{label = ('Kup Pojazd'), value = 'buy_car'},
		{label = ('Daj Pojazd'),     value = 'give_car'},
		{label = ('Zabierz Pojazd'),     value = 'take_car'},
		{label = ('Lista Pojazdow'),     value = 'list_car'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
		title    = ('Garaz Szefa Frakcji'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'buy_car' then
			menu.close()
			EMGBuyCarMenu()
		elseif data.current.value == 'give_car' then
			local playerjob = PlayerData.job.name

			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesInGarageEMG2', function(vehicles)

				local elements = {}
				for i=1, #vehicles, 1 do
					if vehicles[i] then
						if nazwa == nil then
							nazwa = 'white'
							if round(vehicles[i].engineHealth)/10 < 30.99 then
								nazwa = 'red'
							elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
								nazwa = 'yellow'
							elseif round(vehicles[i].engineHealth)/10 > 76 then
								nazwa = 'green'
							end
						end

						if nazwa2 == nil then
							nazwa2 = 'white'
							if round(vehicles[i].bodyHealth)/10 < 30.99 then
								nazwa2 = 'red'
							elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
								nazwa2 = 'yellow'
							elseif round(vehicles[i].bodyHealth)/10 > 76 then
								nazwa2 = 'green'
							end
						end

						if nazwa3 == nil then
							nazwa3 = 'white'
							if round(vehicles[i].fuelLevel) < 30.99 then
								nazwa3 = 'red'
							elseif round(vehicles[i].fuelLevel) > 31 and round(vehicles[i].fuelLevel) < 75.99 then
								nazwa3 = 'yellow'
							elseif round(vehicles[i].fuelLevel) > 76 then
								nazwa3 = 'green'
							end
						end
						local actualcarname = changecarmodelname(GetDisplayNameFromVehicleModel(vehicles[i].model))
						table.insert(elements, {label = '['..vehicles[i].plate..'] ['..actualcarname..'] [Silnik: <font color='..nazwa..'>'..(round(vehicles[i].engineHealth)/10)..'</font>] [Karoseria:  <font color='..nazwa2..'>'..(round(vehicles[i].bodyHealth)/10)..'</font>] [Paliwo: <font color='..nazwa3..'>'..round(vehicles[i].fuelLevel)..'</font>]', value = vehicles[i].plate})
					end
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
						title    = ('Garaz Frakcji'),
						align    = 'center',
						elements = elements
					}, function(data2, menu2)
						if data2.current.value then
							ESX.TriggerServerCallback('esx_jobpolice:sandyshowodznakas', function(dane)
								ESX.UI.Menu.CloseAll()
								local elements = {}

								for i=1, #dane, 1 do
							    	local imieinazwisko = (dane[i].firstname .. ' ' .. dane[i].lastname)
							    	table.insert(elements, {label = imieinazwisko, value = dane[i].identifier})
							    end

								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
										title    = ('Wybierz Policjanta'),
										align    = 'center',
										elements = elements
									}, function(data3, menu3)
										TriggerServerEvent('sandy_garages:sandysendcarEMG2', playerjob, data2.current.value, data3.current.value, data3.current.label)
										menu3.close()
									end, function(data3, menu3)
									menu3.close()
								end)
							end)
						end
						menu2.close()
					end, function(data2, menu2)
					menu2.close()
				end)
			end, playerjob)
		elseif data.current.value == 'take_car' then
			ESX.TriggerServerCallback('esx_jobpolice:sandyshowodznakas', function(dane)
				ESX.UI.Menu.CloseAll()
				local elements = {}

				for i=1, #dane, 1 do
			    	local imieinazwisko = (dane[i].firstname .. ' ' .. dane[i].lastname)
			    	table.insert(elements, {label = imieinazwisko, value = dane[i].identifier})
			    end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
						title    = ('Wybierz Policjanta'),
						align    = 'center',
						elements = elements
					}, function(data4, menu4)
						if data4.current.value then
							local keyholderidentifier = data4.current.value
							local playerjob = PlayerData.job.name
							ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesInGarageEMG3', function(vehicles)

								local elements = {}
								for i=1, #vehicles, 1 do
									if vehicles[i] then
										if nazwa == nil then
											nazwa = 'white'
											if round(vehicles[i].engineHealth)/10 < 30.99 then
												nazwa = 'red'
											elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
												nazwa = 'yellow'
											elseif round(vehicles[i].engineHealth)/10 > 76 then
												nazwa = 'green'
											end
										end

										if nazwa2 == nil then
											nazwa2 = 'white'
											if round(vehicles[i].bodyHealth)/10 < 30.99 then
												nazwa2 = 'red'
											elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
												nazwa2 = 'yellow'
											elseif round(vehicles[i].bodyHealth)/10 > 76 then
												nazwa2 = 'green'
											end
										end

										if nazwa3 == nil then
											nazwa3 = 'white'
											if round(vehicles[i].fuelLevel) < 30.99 then
												nazwa3 = 'red'
											elseif round(vehicles[i].fuelLevel) > 31 and round(vehicles[i].fuelLevel) < 75.99 then
												nazwa3 = 'yellow'
											elseif round(vehicles[i].fuelLevel) > 76 then
												nazwa3 = 'green'
											end
										end
										local actualcarname = changecarmodelname(GetDisplayNameFromVehicleModel(vehicles[i].model))
										table.insert(elements, {label = '['..vehicles[i].plate..'] ['..actualcarname..'] [Silnik: <font color='..nazwa..'>'..(round(vehicles[i].engineHealth)/10)..'</font>] [Karoseria:  <font color='..nazwa2..'>'..(round(vehicles[i].bodyHealth)/10)..'</font>] [Paliwo: <font color='..nazwa3..'>'..round(vehicles[i].fuelLevel)..'</font>]', value = vehicles[i].plate})
									end
								end
								ESX.UI.Menu.CloseAll()

								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
										title    = ('Garaz Frakcji'),
										align    = 'center',
										elements = elements
									}, function(data5, menu5)
										if data5.current.value then
											TriggerServerEvent('sandy_garages:sandysendcarEMG3', playerjob, data5.current.value)
											menu5.close()
										end
										menu5.close()
									end, function(data5, menu5)
									menu5.close()
								end)
							end, playerjob, keyholderidentifier)
						end
						menu4.close()
					end, function(data4, menu4)
					menu4.close()
				end)
			end)
		elseif data.current.value == 'list_car' then
			menu.close()
			local playerjob = PlayerData.job.name
			ESX.TriggerServerCallback('sandy_garages:listallvehicles', function(dane, rawdane)

		    	local elements = {
		      		head = {'Funkcjonariusz', 'Rejestracja'},
		      		rows = {}
		    	}

		    	for i=1, #dane, 1 do
		      		table.insert(elements.rows, {data = dane[i], cols = {rawdane[i].currentowner, dane[i].plate}})
		    	end

		    	ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'car_list', elements, function(data2, menu2)
		    	end, function(data2, menu2)
		     	menu2.close()
		    	end)
		  	end, playerjob)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function EMGBuyCarMenu()
	local playerjob = PlayerData.job.name

	local elements = {}
	if playerjob == 'police' then
		elements = {
			{label = ('Raptor - 250000$'), price = 250000, value = '1raptor'},
            {label = ('Dodge 14 - 100000$'), price = 100000, value = '14awd'},
            {label = ('Ford Fusion - 175000$'), price = 175000, value = '17fusionrb'},
            {label = ('Colorado - 300000$'), price = 300000, value = '17zr2'},
            {label = ('Ford F350 - 250000$'), price = 250000, value = '20f350'},
            {label = ('Silverado - 275000$'), price = 275000, value = '20silv'},
            {label = ('Challanger 18 - 350000$'), price = 350000, value = 'challenger18'},
            {label = ('Dodge 16 - 125000$'), price = 125000, value = 'charger1'},
            {label = ('Dodge Charger 14 UC - 150000$'), price = 150000, value = 'charger14'},
            {label = ('Victoria - 50000$'), price = 50000, value = 'cvpi'},
            {label = ('Challanger - 250000$'), price = 250000, value = 'demonrb'},
            {label = ('Explorer - 125000$'), price = 125000, value = 'explorer1'},
            {label = ('Explorer UC - 225000$'), price = 225000, value = 'fpiu'},
            {label = ('Tahoe - 175000$'), price = 175000, value = 'fr'},
            {label = ('GMC - 250000$'), price = 250000, value = 'gmc'},
            {label = ('Dodge Charger - 350000$'), price = 350000, value = 'heat2'},
            {label = ('Dodge SRT Hellcat - 500000$'), price = 500000, value = 'hellcatred'},
            {label = ('Mustang - 750000$'), price = 750000, value = 'mustang19'},
            {label = ('Dodge Ram - 225000$'), price = 225000, value = 'polram1'},
            {label = ('Jeep - 150000$'), price = 150000, value = 'poljeep1'},
            {label = ('Dodge Ram - 275000$'), price = 275000, value = 'river01'},
            {label = ('Taurus - 75000$'), price = 75000, value = 'sp1'},
            {label = ('Suburban - 200000$'), price = 200000, value = 'suburbanpd'}
		}
	end
	if playerjob == 'ambulance' then
		elements = {

		}
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
		title    = ('Kup Pojazd'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if (GetGameTimer() - GUI.Time) > 2000 then
			menu.close()
			GUI.Time      = GetGameTimer()
			ESX.ShowNotification('Pojazd jest wlasnie zamawiany')
			local playerPed = PlayerPedId()
			local car = data.current.value
			local plate = exports['d3x_vehicleshop']:GeneratePlate()
			while plate == nil do
				Citizen.Wait(100)
			end
			local price = data.current.price
			local heading, coords = GetEntityHeading(playerPed), GetEntityCoords(playerPed, true)
			local spawnCoords  = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
			}
			Citizen.Wait(200)
			ESX.TriggerServerCallback('sandy_garages:buyVehicle', function(hasEnoughMoney)
				if hasEnoughMoney then
					ESX.Game.SpawnVehicle(car, spawnCoords, heading, function (vehicle)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
						local kurwamodel	= GetEntityModel(vehicle)
						local typauta      = GetDisplayNameFromVehicleModel(kurwamodel)
						vehicleProps.plate = plate
						SetVehicleNumberPlateText(vehicle, plate)

						TriggerServerEvent('sandy_garages:setVehicleOwned', vehicleProps, kurwamodel, typauta, price)

						ESX.ShowNotification('Pojazd kupiony; znajduje sie w policyjnym garazu')
						Citizen.Wait(2000)
						DeleteVehicle(vehicle)
					end)
				else
					ESX.ShowNotification('Konto policji nie ma tyle pieniedzy')
				end
			end, price)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function BossCarMenu()
	local elements = {
		{label = ('Dodaj samochod organizacji'), value = 'put_car'},
		{label = ('Usun samochod organizacji'),     value = 'get_car'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
		title    = ('Garaz Akcje Szefa'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'get_car' then
			local kurwapraca 	= PlayerData.job2.name

			ESX.TriggerServerCallback('sandy_garages:sandygetVehiclesInGarage', function(vehicles)

				local elements = {}
				for i=1, #vehicles, 1 do
					if vehicles[i] then
						table.insert(elements, {label = vehicles[i].plate, value = vehicles[i]})
					end
				end

				ESX.UI.Menu.CloseAll()

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garaz', {
						title    = ('Usun samochod organizacji'),
						align    = 'center',
						elements = elements
					}, function(data, menu)

						local twojstary = GetDisplayNameFromVehicleModel(data.current.value.model)

						TriggerServerEvent("sandy_garages:sandyremovekurwacar", data.current.value, kurwapraca, twojstary)
						ESX.ShowNotification('Samochod jest teraz w twoim garazu')
						menu.close()

						end, function(data, menu)
					menu.close()
				end)
			end, kurwapraca)
		elseif data.current.value == 'put_car' then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local playerPed = GetPlayerPed(-1)
				local vehicle       = GetVehiclePedIsIn(playerPed)
				local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
				local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
				local plate         = vehicleProps.plate
				local kurwamodel	= GetEntityModel(vehicle)
				local kurwapraca 	= PlayerData.job2.name
				local twojstary 	= GetDisplayNameFromVehicleModel(kurwamodel)
					if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle, -1) then
						ESX.TriggerServerCallback('sandy_garages:checkIfVehicleIsOwned3', function (owned)
							if owned ~= nil then        
								local vehicleProps2  = GetVehicleProperties(vehicle)              
								TriggerServerEvent("sandy_garages:sandysendkurwacar", vehicleProps2, kurwapraca, twojstary)
								Citizen.Wait(100)
								TaskLeaveVehicle(playerPed, vehicle, 16)
								while DoesEntityExist(vehicle) do
									ESX.Game.DeleteVehicle(vehicle)
									Wait(100)
								end
								ESX.ShowNotification('Oddano samochod do garazu organizacji!')
							else
								ESX.ShowNotification(_U('not_owner'))
							end
						end, vehicleProps.plate, kurwamodel, kurwapraca, twojstary)
					else
						ESX.ShowNotification('Musisz kierować autem żeby je schować!')
					end
				menu.close()
			else
				ESX.ShowNotification('Musisz kierować autem żeby je schować!')
			end
		end

	end, function(data, menu)
		menu.close()
	end)
end

function round(n)
    if not n then return 0; end
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

-- Open Gui and Focus NUI
function openGui()
	SetNuiFocus(true, true)
	SendNUIMessage({openGarage = true})
	TriggerEvent('route68_chatMenu:ChatActive', true)
end

-- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openGarage = false})
	TriggerEvent('route68_chatMenu:ChatActive', false)
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)

-- NUI Callback Methods
RegisterNUICallback('pullCar', function(data, cb)
	local playerPed = PlayerPedId()
	local heading, coords = GetEntityHeading(playerPed), GetEntityCoords(playerPed, true)
	local kurwapraca 	= PlayerData.job2.name
	ESX.TriggerServerCallback('sandy_garages:checkIfVehicleIsOwned', function (owned)
		local spawnCoords  = {
			x = coords.x,
			y = coords.y,
			z = coords.z,
		}
		if owned ~= nil then
			ESX.Game.SpawnVehicle(owned.model, spawnCoords, heading, function(vehicle)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
				local kurwakolorswiatel
				if owned.headlights ~=nil then
					kurwakolorswiatel = owned.headlights
				else
					kurwakolorswiatel = -1
				end
				AddVehicleKeys(vehicle)
				SetVehicleProperties(vehicle, owned)
				SetVehicleHeadlightsColour(vehicle, kurwakolorswiatel)
				local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
				local localVehLockStatus = GetVehicleDoorLockStatus(vehicle)
				TriggerEvent("ls:getOwnedVehicle", vehicle, localVehPlate, localVehLockStatus)
				local networkid = NetworkGetNetworkIdFromEntity(vehicle)
				TriggerServerEvent("sandy_garages:removeCarFromParking", owned.plate, networkid)
				local vehicleProps  = GetVehicleProperties(vehicle)
				vehicleProps["engineHealth"] = 1000.0
				TriggerServerEvent("sandy_garages:sandyupdateOwnedVehicle", vehicleProps)
			end)
		else
			ESX.TriggerServerCallback('sandy_garages:sandycheckIfVehicleIsOwned2', function (owned)
				local spawnCoords  = {
					x = coords.x,
					y = coords.y,
					z = coords.z,
				}
				ESX.Game.SpawnVehicle(owned.model, spawnCoords, heading, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					local kurwakolorswiatel
					if owned.headlights ~=nil then
						kurwakolorswiatel = owned.headlights
					else
						kurwakolorswiatel = -1
					end
					AddVehicleKeys(vehicle)
					SetVehicleProperties(vehicle, owned)
					SetVehicleHeadlightsColour(vehicle, kurwakolorswiatel)
					local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
					local localVehLockStatus = GetVehicleDoorLockStatus(vehicle)
					TriggerEvent("ls:getOwnedVehicle", vehicle, localVehPlate, localVehLockStatus)
					local networkid = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("sandy_garages:sandyremoveCarFromParking", owned.plate, networkid)
					local vehicleProps  = GetVehicleProperties(vehicle)
					vehicleProps["engineHealth"] = 1000.0
					TriggerServerEvent("sandy_garages:sandyupdateOwnedVehicle2", vehicleProps)
				end)
			end, data.model, kurwapraca)
		end
	end, data.model)
	closeGui()
	cb('ok')
end)

RegisterNUICallback('towCar', function(data, cb)
	closeGui()
	cb('ok')
	impoundpaymenu(data)
end)

function impoundpaymenu(car)
	local elements = {
		{label = ('Gotowka'),     value = '1'},
		{label = ('Karta'),     value = '2'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'odholownikpay_actions', {
		title    = ('Odholownik'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
	    if data.current.value == '1' then
			ESX.TriggerServerCallback('sandy_garages:towVehicle', function(id)
				if id ~= nil then
					local entity = NetworkGetEntityFromNetworkId(tonumber(id))
					ESX.ShowNotification(_U('checking_veh'))
					Citizen.Wait(math.random(500, 4000))
					if entity == 0 then
						ESX.TriggerServerCallback('sandy_garages:checkMoney', function(hasMoney)
							if hasMoney then
								ESX.ShowNotification(_U('checking_veh'))
								Citizen.Wait(math.random(500, 4000))
								TriggerServerEvent('sandy_garages:pay')
								SpawnImpoundedVehicle(car.model)
								ESX.ShowNotification(_U('veh_impounded', car.model))
							else
								ESX.ShowNotification(_U('no_money'))
							end
						end)
					elseif entity ~= 0 and (GetVehicleNumberOfPassengers(entity) > 0 or not IsVehicleSeatFree(entity, -1)) then
						ESX.ShowNotification(_U('cant_impound'))
					else
						ESX.TriggerServerCallback('sandy_garages:checkMoney', function(hasMoney)
							if hasMoney then
								TriggerServerEvent('sandy_garages:pay')
								SpawnImpoundedVehicle(car.model)
								if entity ~= 0 then
									ESX.Game.DeleteVehicle(entity)
								end
								ESX.ShowNotification(_U('veh_impounded', car.model))
							else
								ESX.ShowNotification(_U('no_money'))
							end
						end)
					end
				else
					ESX.TriggerServerCallback('sandy_garages:checkMoney', function(hasMoney)
						if hasMoney then
							ESX.ShowNotification(_U('checking_veh'))
							Citizen.Wait(math.random(500, 4000))
							TriggerServerEvent('sandy_garages:pay')
							SpawnImpoundedVehicle(car.model)
							ESX.ShowNotification(_U('veh_impounded', car.model))
						else
							ESX.ShowNotification(_U('no_money'))
						end
					end)
				end
			end, car.model)
			menu.close()
        elseif data.current.value == '2' then
			ESX.TriggerServerCallback('sandy_garages:towVehicle', function(id)
				if id ~= nil then
					local entity = NetworkGetEntityFromNetworkId(tonumber(id))
					ESX.ShowNotification(_U('checking_veh'))
					Citizen.Wait(math.random(500, 4000))
					if entity == 0 then
						ESX.TriggerServerCallback('sandy_garages:checkMoneybank', function(hasMoney)
							if hasMoney then
								ESX.ShowNotification(_U('checking_veh'))
								Citizen.Wait(math.random(500, 4000))
								TriggerServerEvent('sandy_garages:paybank')
								SpawnImpoundedVehicle(car.model)
								ESX.ShowNotification(_U('veh_impounded', car.model))
							else
								ESX.ShowNotification(_U('no_money'))
							end
						end)
					elseif entity ~= 0 and (GetVehicleNumberOfPassengers(entity) > 0 or not IsVehicleSeatFree(entity, -1)) then
						ESX.ShowNotification(_U('cant_impound'))
					else
						ESX.TriggerServerCallback('sandy_garages:checkMoneybank', function(hasMoney)
							if hasMoney then
								TriggerServerEvent('sandy_garages:paybank')
								SpawnImpoundedVehicle(car.model)
								if entity ~= 0 then
									ESX.Game.DeleteVehicle(entity)
								end
								ESX.ShowNotification(_U('veh_impounded', car.model))
							else
								ESX.ShowNotification(_U('no_money'))
							end
						end)
					end
				else
					ESX.TriggerServerCallback('sandy_garages:checkMoneybank', function(hasMoney)
						if hasMoney then
							ESX.ShowNotification(_U('checking_veh'))
							Citizen.Wait(math.random(500, 4000))
							TriggerServerEvent('sandy_garages:paybank')
							SpawnImpoundedVehicle(car.model)
							ESX.ShowNotification(_U('veh_impounded', car.model))
						else
							ESX.ShowNotification(_U('no_money'))
						end
					end)
				end
			end, car.model)
			menu.close()
        end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback('impoundCar', function(data, cb)
	closeGui()
	cb('ok')
	local playerPed  = GetPlayerPed(-1)
	ESX.TriggerServerCallback('sandy_garages:checkVehProps', function(veh)
		ESX.ShowNotification(_U('checking_veh'))
		Citizen.Wait(math.random(500, 4000))
		local spawnCoords  = {
			x = CurrentGarage.x,
			y = CurrentGarage.y,
			z = CurrentGarage.z,
		}
		ESX.Game.SpawnVehicle(veh.model, spawnCoords, GetEntityHeading(playerPed), function(vehicle)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			ESX.Game.SetVehicleProperties(vehicle, veh)
			local networkid = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("sandy_garages:removeCarFromPoliceParking", data.model, networkid)
		end)
	end, data.model)
	
end)

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

AddEventHandler('sandy_garages:hasEnteredMarker', function (zone)
	if zone == 'pullout_car' then
		CurrentAction = 'pullout_car'
	elseif zone == 'park_car' then
		CurrentAction = 'park_car'
	elseif zone == 'policepark_car' then
		CurrentAction = 'policepark_car'
	elseif zone == 'policepullout_car' then
		CurrentAction = 'policepullout_car'
	elseif zone == 'impound_veh' then
		CurrentAction = 'tow_menu'
	elseif zone == 'police_impound_veh' then
		CurrentAction = 'police_impound_menu'
	elseif zone == 'subowner_veh' then
		CurrentAction = 'subowner_veh'
	elseif zone == 'sandyzlom_veh' then
		CurrentAction = 'sandyzlom_veh'
	elseif zone == 'sandyzlom_list' then
		CurrentAction = 'sandyzlom_list'
	end
end)

function AddVehicleKeys(vehicle)
    local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
    if localVehPlateTest ~= nil then
        local localVehPlate = string.lower(localVehPlateTest)
		TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
		TriggerEvent("ls:notify", "Otrzymałeś kluczki swojego do pojazdu")
	end
end

AddEventHandler('sandy_garages:hasExitedMarker', function (zone)
  if IsInShopMenu then
    IsInShopMenu = false
    CurrentGarage = nil
  end
  if not IsInShopMenu then
	ESX.UI.Menu.CloseAll()
  end
  CurrentAction = nil
end)

function DoesVehicleHaveExtras(vehicle)
    for i = 1, 30 do 
        if (DoesExtraExist(vehicle, i)) then 
            return true 
        end 
    end 
    return false 
end 

SetVehicleProperties = function(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
	SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)
	local extras = vehicleProps["extras"]

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end

    for i = 1, 30 do
		if (DoesExtraExist(vehicle, i)) then
			SetVehicleExtra(vehicle, i, true)
		end
	end

	for k, v in pairs(extras) do
		local extra = tonumber(v)
		SetVehicleExtra(vehicle, extra, false)
	end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}
        vehicleProps["headlights"] = GetVehicleHeadlightsColour(vehicle)
        vehicleProps["extras"] = {}
        local extras = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

	    if (DoesVehicleHaveExtras(vehicle)) then
			for i = 1, 30 do
				if (DoesExtraExist(vehicle, i)) then
					if (IsVehicleExtraTurnedOn( vehicle, i )) then
						table.insert(extras, i)
					end
				end
			end
		end

        local fuellevel = exports['fuelsystem']:GetFuel(vehicle)

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)
        vehicleProps["extras"] = extras

        return vehicleProps
    end
end