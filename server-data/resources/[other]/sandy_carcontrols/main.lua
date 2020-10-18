local inTrunk = false

ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

Config = {} 
Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

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

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)


local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        ped = PlayerPedId()
        if not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) and not IsPedBeingStunned(ped) then
            local vehicle = ESX.Game.GetVehicleInDirection()
            if vehicle and vehicle ~= 0 and GetVehicleEngineHealth(vehicle) <= Config.DamageNeeded then
                local roll = GetEntityRoll(vehicle)
                if roll < 75.0 and roll > -75.0 then
                    Vehicle.Coords = GetEntityCoords(vehicle)
                    Vehicle.Dimensions = GetModelDimensions(GetEntityModel(vehicle), First, Second)
                    Vehicle.Vehicle = vehicle
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
                ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Naciśnij [~o~SHIFT~w~] oraz [~o~E~w~] aby pchać pojazd', 0.8)
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
                if IsControlJustReleased(3, 74) and inTrunk then
                    SetCarBootOpen(vehicle)
                    SetEntityCollision(PlayerPedId(), true, true)
                    inTrunk = false
                    EnableAllControlActions(0)
                    EnableAllControlActions(1)
                    EnableAllControlActions(2)
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityVisible(PlayerPedId(), true, false)
                    ClearPedTasks(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                    Wait(250)
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
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while not NetworkIsSessionStarted() or ESX.GetPlayerData().job == nil do Wait(0) end
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
						if lockStatus == 1 then --unlocked
							if DoesEntityExist(playerPed) then
								if not IsEntityAttached(playerPed) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
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
									ESX.ShowNotification('W bagażniku jest już ktoś!')
								end
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
