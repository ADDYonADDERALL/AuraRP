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

local Ped = {}

local PlayerData = {}
local GUI = {}
ESX = nil
GUI.Time = 0
local kurwarejka
local window0 = false
local window1 = false
local window2 = false
local window3 = false
local twojstarynajebany = false
local haspermissionspilot = false
local HasAlreadyEnteredMarker = false
local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

Config = {} 
Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	TriggerServerEvent('sandy_carcontrols:checkpilotpermissions')
end)

RegisterNetEvent('sandy_carcontrols:setpermissions')
AddEventHandler('sandy_carcontrols:setpermissions', function(permissions)
	haspermissionspilot = permissions
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        Ped = exports['AuraRP']:GetPedData()
    end
end)

Citizen.CreateThread(function()
 	while true do
		Citizen.Wait(5)
		if IsControlPressed(0, 56) then
			if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) == 0 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'carcontrols_actions_actions') and (GetGameTimer() - GUI.Time) > 1000 then
				carcontrolsmenu()
				GUI.Time = GetGameTimer()
			end
		end
 	end
 end)

function carcontrolsmenu()
    ESX.UI.Menu.CloseAll()
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(ped, true)
	local lockStatus = GetVehicleDoorLockStatus(veh)
	local distanceveh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(veh), 1)
	local vehicleProps = ESX.Game.GetVehicleProperties(veh)
	local modelzajebisty = GetDisplayNameFromVehicleModel(vehicleProps.model)
	if veh ~= 0 then
		if distanceveh < 10 then
			if lockStatus == 1 then --unlocked
				local elements = {}
				if DoesVehicleHaveDoor(veh, 0) then
					table.insert(elements, {label = 'Drzwi Przednie Lewe', value = 'door1'})
				end
				if DoesVehicleHaveDoor(veh, 1) then
					table.insert(elements, {label = 'Drzwi Przednie Prawe', value = 'door2'})
				end
				if DoesVehicleHaveDoor(veh, 2) then
					table.insert(elements, {label = 'Drzwi Tylnie Lewe', value = 'door3'})
				end
				if DoesVehicleHaveDoor(veh, 3) then
					table.insert(elements, {label = 'Drzwi Tylnie Prawe', value = 'door4'})
				end
				if DoesVehicleHaveDoor(veh, 4) then
					table.insert(elements, {label = 'Maska', value = 'hood'})
				end
				if DoesVehicleHaveDoor(veh, 5) then
					table.insert(elements, {label = 'Bagaznik', value = 'trunk'})
				end
				table.insert(elements, {label = 'Szyba Przednia Lewa', value = 'window1'})
				table.insert(elements, {label = 'Szyba Przednia Prawe', value = 'window2'})
				table.insert(elements, {label = 'Szyba Tylnia Lewe', value = 'window3'})
				table.insert(elements, {label = 'Szyba Tylnia Prawe', value = 'window4'})
				if haspermissionspilot then
					table.insert(elements, {label = 'Pilot RGB', value = 'pilot'})
				end

				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'carcontrols_actions',
				{
					title    = 'REJ: '..vehicleProps.plate..' | MODEL: '..modelzajebisty,
					align    = 'center',
					elements = elements

				}, function(data, menu)
					if data.current.value == 'door1' then
						openkurwadrzwikek(0)
					elseif data.current.value == 'door2' then
						openkurwadrzwikek(1)
					elseif data.current.value == 'door3' then
						openkurwadrzwikek(2)
					elseif data.current.value == 'door4' then
						openkurwadrzwikek(3)
					elseif data.current.value == 'hood' then
						openkurwadrzwikek(4)
					elseif data.current.value == 'trunk' then
						openkurwadrzwikek(5)
					elseif data.current.value == 'window1' then
						kurwaokna(0)
					elseif data.current.value == 'window2' then
						kurwaokna(1)
					elseif data.current.value == 'window3' then
						kurwaokna(2)
					elseif data.current.value == 'window4' then
						kurwaokna(3)
					elseif data.current.value == 'pilot' then
						local kurwamodel	= GetEntityModel(veh)
					ESX.TriggerServerCallback('sandy_garages:checkIfVehicleIsOwned2', function (owned)
						if owned ~= nil then                    
							OpenLightsMenu()
						else
							ESX.ShowNotification('~r~Nie jesteś właścicielem tego pojazdu')
						end
					end, vehicleProps.plate, kurwamodel)
					menu.close()
					end
				end, function(data, menu)
					menu.close()
				end)
			else -- locked
				ESX.ShowNotification('~r~Samochód jest zamknięty')
			end
		else
			ESX.ShowNotification('~r~Jestes za daleko pojazdu')
		end
	else
		ESX.ShowNotification('~r~Nie ma twojego samochodu w poblizu')
	end
end

function openkurwadrzwikek(door)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsUsing(ped)
	local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
            else	
                SetVehicleDoorOpen(veh, door, false, false)
            end
        else
            if distanceToVeh < 10 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                	kurwaanimacja()
                    SetVehicleDoorShut(vehLast, door, false)
                else
                	kurwaanimacja()	
                    SetVehicleDoorOpen(vehLast, door, false, false)
                end
            else
            end
        end
    end
end

function kurwaanimacja()
    local ad = "anim@mp_player_intmenu@key_fob@"
    local anim = "fob_click"
    local ped = PlayerPedId()

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped )) and not IsPedInAnyVehicle(ped, true) then
        loadAnimDict( ad )
        if ( IsEntityPlayingAnim( ped, ad, anim, 1 ) ) then
            TaskPlayAnim( ped, ad, "exit", 8.0, 8.0, 1.0, 50, 0, 0, 0, 0 )
            ClearPedSecondaryTask(ped)
        else
            SetCurrentPedWeapon(ped, -1569615261,true)
            Citizen.Wait(1)
            TaskPlayAnim( ped, ad, anim, 8.0, 8.0, 850, 50, 0, 0, 0, 0 )
     	end
    end
end

function kurwaokna(window)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(ped, true)
	local vehLast = GetPlayersLastVehicle()
	local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
	if IsPedInAnyVehicle(ped, false) then
		if window == 0 then
			if window0 then
				window0 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
			else
				window0 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
			end
		elseif window == 1 then
			if window1 then
				window1 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
			else
				window1 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
			end
		elseif window == 2 then
			if window2 then
				window2 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
			else
				window2 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
			end
		elseif window == 3 then
			if window3 then
				window3 = false
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
			else
				window3 = true
				TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
			end
		end
	else
		if distanceToVeh < 10 then
			if window == 0 then
				if window0 then
					window0 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
					kurwaanimacja()
				else
					window0 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window0, window)
					kurwaanimacja()
				end
			elseif window == 1 then
				if window1 then
					window1 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
					kurwaanimacja()
				else
					window1 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window1, window)
					kurwaanimacja()
				end
			elseif window == 2 then
				if window2 then
					window2 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
					kurwaanimacja()
				else
					window2 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window2, window)
					kurwaanimacja()
				end
			elseif window == 3 then
				if window3 then
					window3 = false
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
					kurwaanimacja()
				else
					window3 = true
					TriggerServerEvent( "sandycarmenu:SetVehicleWindow", window3, window)
					kurwaanimacja()
				end
			end
		end
	end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('kurwavehiclewidnow')
AddEventHandler( "kurwavehiclewidnow", function(playerID, windowsDown, window)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerID)), true)
    if window == 0 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 1 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 2 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	elseif window == 3 then
   	 	if windowsDown then
     	 	RollDownWindow(vehicle, window)
    	else
     		RollUpWindow(vehicle, window)
    	end
	end
end)

function OpenLightsMenu()

		local elements = {
		{label = 'Białe', value = 'swiatla1'},
		{label = 'Czerwone', value = 'swiatla2'},
		{label = 'Niebieskie', value = 'swiatla3'},
		{label = 'Zielone', value = 'swiatla4'},
		{label = 'Żółte', value = 'swiatla5'},
		{label = 'Fioletowe',		value = 'swiatla6'},
		{label = 'Pomarańczowe',	value = 'swiatla7'},
		{label = 'Różowe',		value = 'swiatla8'},
		{label = 'Ciemne',	value = 'swiatla9'},
		}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lights_colors',
	{
		title    = 'Pilot RGB',
		align    = 'center',
		elements = elements
		}, function(data2, menu2)
			local ply = GetPlayerPed(-1)
			if (IsPedInAnyVehicle(ply, true)) then
				local action = data2.current.value					
				if action == 'swiatla1' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 0)
					menu2.close()
				elseif action == 'swiatla2' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 8)
					menu2.close()
				elseif action == 'swiatla3' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 1)
					menu2.close()
				elseif action == 'swiatla4' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 4)
					menu2.close()
				elseif action == 'swiatla5' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 5)
					menu2.close()
				elseif action == 'swiatla6' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 11)
					menu2.close()
				elseif action == 'swiatla7' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 7)
					menu2.close()
				elseif action == 'swiatla8' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 10)
					menu2.close()
				elseif action == 'swiatla9' then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 12)
					menu2.close()
				end
			else
				ESX.ShowNotification('~r~Musisz byc w aucie!')
			end
		end, function(data2, menu2)
			menu2.close()
		end)
end

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
	Citizen.Wait(2000)
    while true do
		if Ped.Active then
			local vehicle = ESX.Game.GetVehicleInDirection()
			if vehicle and vehicle ~= 0 and GetVehicleEngineHealth(vehicle) <= Config.DamageNeeded then
				local roll = GetEntityRoll(vehicle)
				if roll < 75.0 and roll > -75.0 then
					Vehicle.Coords = GetEntityCoords(vehicle)
					Vehicle.Dimensions = GetModelDimensions(GetEntityModel(vehicle), First, Second)
					Vehicle.Vehicle = vehicle

					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)

					local vector = GetEntityForwardVector(vehicle)
					if #((Vehicle.Coords + vector) - coords) > #((Vehicle.Coords + vector * -1) - coords) then
						Vehicle.IsInFront = false
					else
						Vehicle.IsInFront = true
					end
				else
					Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false}
				end
			else
				Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false}
			end
		end

        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
	RequestAnimDict('missfinale_c2ig_11')
	while not HasAnimDictLoaded('missfinale_c2ig_11') do
		Citizen.Wait(0)
	end

    while true do 
        Citizen.Wait(0)
        if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
            if GetVehiclePedIsIn(ped, true) == Vehicle.Vehicle then
                ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Naciśnij [~g~SHIFT~w~] oraz [~g~E~w~] aby pchać pojazd', 0.8)
            end
     
            if IsControlPressed(0, Keys["LEFTSHIFT"]) then
				DisableControlAction(2, Keys["E"], true)
				if IsDisabledControlPressed(2, Keys["E"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
					NetworkRequestControlOfEntity(Vehicle.Vehicle)
					local coords = GetEntityCoords(ped)
					if Vehicle.IsInFront then    
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
					else
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
					end

					TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
					Citizen.Wait(200)

					local currentVehicle = Vehicle.Vehicle
					while true do
						Citizen.Wait(0)
						if IsDisabledControlPressed(0, Keys["A"]) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
						end

						if IsDisabledControlPressed(0, Keys["D"]) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
						end

						if Vehicle.IsInFront then
							SetVehicleForwardSpeed(currentVehicle, -1.0)
						else
							SetVehicleForwardSpeed(currentVehicle, 1.0)
						end

						if HasEntityCollidedWithAnything(currentVehicle) then
							SetVehicleOnGroundProperly(currentVehicle)
						end

						if not IsDisabledControlPressed(0, Keys["E"]) then
							DetachEntity(ped, false, false)
							StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
							FreezeEntityPosition(ped, false)
							break
						end
					end
                end
            end
        end
    end
end)

local inTrunk = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inTrunk then
            local vehicle = GetEntityAttachedTo(PlayerPedId())
            if DoesEntityExist(vehicle) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
                local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
                SetEntityCollision(PlayerPedId(), false, false)

                if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
                    SetEntityVisible(PlayerPedId(), false, false)
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                        loadDict('timetable@floyd@cryingonbed@base')
                        TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

                        SetEntityVisible(PlayerPedId(), true, false)
                    end
                end
                if IsControlJustReleased(0, 177) and inTrunk then
                	local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local plate         = vehicleProps.plate
                	TriggerServerEvent('sandy_trunk:removefromtrunk', plate)
                    SetCarBootOpen(vehicle)
                    SetEntityCollision(PlayerPedId(), true, true)
                    EnableAllControlActions(0)
                    EnableAllControlActions(1)
                    EnableAllControlActions(2)
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityVisible(PlayerPedId(), true, false)
                    ClearPedTasks(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                    Wait(250)
                    inTrunk = false
                    SetVehicleDoorShut(vehicle, 5)
                end
            else
                SetEntityCollision(PlayerPedId(), true, true)
                DetachEntity(PlayerPedId(), true, true)
                SetEntityVisible(PlayerPedId(), true, false)
                ClearPedTasks(PlayerPedId())
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
            end
        end
    end
end)   

Citizen.CreateThread(function()
    while true do
        local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
		local lockStatus = GetVehicleDoorLockStatus(vehicle)
        if DoesEntityExist(vehicle)
		then
            local trunk = GetEntityBoneIndexByName(vehicle, 'boot')
            if trunk ~= -1 then
                local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) <= 1.5 then
                    if not inTrunk then
                        if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
								if IsControlJustReleased(0, 74)then
									if lockStatus == 1 then --unlocked
										SetCarBootOpen(vehicle)
									else
										ESX.ShowNotification('Samochód jest zamknięty')
									end
								end
                        else
                            if IsControlJustReleased(0, 74) then
                                SetVehicleDoorShut(vehicle, 5)
                            end
                        end
                    end
                    if IsControlJustReleased(3, 74) and not inTrunk then
                        local player = ESX.Game.GetClosestPlayer()
                        local playerPed = GetPlayerPed(player)
						local playerPed2 = GetPlayerPed(-1)
						local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
						local plate         = vehicleProps.plate
						if lockStatus == 1 then --unlocked
							if DoesEntityExist(playerPed) then
								ESX.TriggerServerCallback('sandy_trunk:checkifanyoneintrunk', function (isintrunk)
									if not isintrunk then                    
										SetCarBootOpen(vehicle)
										Wait(350)
										AttachEntityToEntity(PlayerPedId(), vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
										loadDict('timetable@floyd@cryingonbed@base')
										TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
										Wait(50)
	                                    inTrunk = true
										Wait(1500)
										SetVehicleDoorShut(vehicle, 5)
									else
										ESX.ShowNotification('~r~Ktos juz jest w bagazniku')
									end
								end, plate)
							end
						else
							ESX.ShowNotification('Samochód jest zamknięty')
						end
                    end
                end
            end
        end
        Wait(10)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if inTrunk == true then
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
            EnableControlAction(3, 74, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 0, true) --- V - camera
            EnableControlAction(0, 249, true) --- N - push to talk	
            EnableControlAction(2, 1, true) --- camera moving
            EnableControlAction(2, 2, true) --- camera moving	
            EnableControlAction(0, 177, true) --- BACKSPACE
            EnableControlAction(0, 200, true) --- ESC
		else
			Citizen.Wait(500)
		end
	end
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end