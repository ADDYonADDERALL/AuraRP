local GUI = {}
ESX = nil
GUI.Time = 0
local PlayerData = {}
local gotforklift = false
local currentbox = nil
local currentdelivery = nil
local numberofboxesdropped = 0
local deliveryblip = nil
local gotbox = false
local gottruck = false
local gottrailer = false
local currenttruckdelivery = nil
local gottruckbox = false
local trailertaken = nil
local closetotrailer = false
local deliveringtruckbox = false
local numberoftruckboxes = 0
local truckerjobdone = false

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
    ESX.PlayerData = xPlayer
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if PlayerData.job ~= nil and PlayerData.job.name == 'trucker' then 
            pCoords = GetEntityCoords(PlayerPedId())
            if (GetDistanceBetweenCoords(pCoords, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z, true) < 10) then
                DrawMarker(1, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                if (GetDistanceBetweenCoords(pCoords, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z, true) < 3) then
                    ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby wybrac pojazd Widlaka')
                    if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 then
                        GUI.Time = GetGameTimer()
                        GetForkLift()
                    end
                end
            end
            if gotforklift then
                if (GetDistanceBetweenCoords(pCoords, Config.Zones.Remove.Pos.x, Config.Zones.Remove.Pos.y, Config.Zones.Remove.Pos.z, true) < 10) then
                    DrawMarker(1, Config.Zones.Remove.Pos.x, Config.Zones.Remove.Pos.y, Config.Zones.Remove.Pos.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                    if (GetDistanceBetweenCoords(pCoords, Config.Zones.Remove.Pos.x, Config.Zones.Remove.Pos.y, Config.Zones.Remove.Pos.z, true) < 3) then
                        ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby oddac pojazd Widlak')
                        if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 then
                            GUI.Time = GetGameTimer()
                            local playerPed = GetPlayerPed(-1)
                            if IsPedInAnyVehicle(playerPed, false) then
                                local vehicle = GetVehiclePedIsIn(playerPed, false)
                                if IsVehicleModel(vehicle, GetHashKey('forklift')) then
                                    PutForkLift(vehicle)
                                end
                            end
                        end
                    end
                end
                if not gotbox then
                    for i=1, #Config.Zones.ForkliftPickup, 1 do
                        if (GetDistanceBetweenCoords(pCoords, Config.Zones.ForkliftPickup[i], true) < 10) then
                            DrawMarker(1, Config.Zones.ForkliftPickup[i], 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                            if (GetDistanceBetweenCoords(pCoords, Config.Zones.ForkliftPickup[i], true) < 3) then
                                ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby zaladowac paczke na Widlaka')
                                if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 then
                                    GUI.Time = GetGameTimer()
                                    local playerPed = GetPlayerPed(-1)
                                    if IsPedInAnyVehicle(playerPed, false) then
                                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                                        if IsVehicleModel(vehicle, GetHashKey('forklift')) then
                                            LoadForkLift(vehicle, pCoords)
                                            Wait(1000)
                                            if currentdelivery ~= nil then
                                                RemoveBlip(deliveryblip)
                                                deliveryblip = AddBlipForCoord(currentdelivery)
                                                SetBlipAsFriendly(deliveryblip, true)
                                                SetBlipColour(deliveryblip, 2)
                                                SetBlipCategory(deliveryblip, 3)
                                                SetBlipRoute(deliveryblip, true)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if currentdelivery ~= nil then
                    if (GetDistanceBetweenCoords(pCoords, currentdelivery.x, currentdelivery.y, currentdelivery.z, true) < 10) then
                        DrawMarker(1, currentdelivery.x, currentdelivery.y, currentdelivery.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                        if (GetDistanceBetweenCoords(pCoords, currentdelivery.x, currentdelivery.y, currentdelivery.z, true) < 3) then
                            ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby wyladowac paczke z Widlaka')
                            if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 then
                                GUI.Time = GetGameTimer()
                                local playerPed = GetPlayerPed(-1)
                                if IsPedInAnyVehicle(playerPed, false) then
                                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                                    if IsVehicleModel(vehicle, GetHashKey('forklift')) then
                                        UnloadForkLift(vehicle)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if (GetDistanceBetweenCoords(pCoords, Config.Zones.Truck.Pos.x, Config.Zones.Truck.Pos.y, Config.Zones.Truck.Pos.z, true) < 10) then
                    DrawMarker(1, Config.Zones.Truck.Pos.x, Config.Zones.Truck.Pos.y, Config.Zones.Truck.Pos.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                    if (GetDistanceBetweenCoords(pCoords, Config.Zones.Truck.Pos.x, Config.Zones.Truck.Pos.y, Config.Zones.Truck.Pos.z, true) < 3) then
                        ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby wybrac otworzyc menu pojazdow')
                        if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'truckermenu_actions') then
                            GUI.Time = GetGameTimer()
                            TruckerMenu()
                        end
                    end
                end
                if (GetDistanceBetweenCoords(pCoords, Config.Zones.TruckRemove.Pos.x, Config.Zones.TruckRemove.Pos.y, Config.Zones.TruckRemove.Pos.z, true) < 10) then
                    DrawMarker(1, Config.Zones.TruckRemove.Pos.x, Config.Zones.TruckRemove.Pos.y, Config.Zones.TruckRemove.Pos.z-0.90, 0, 0, 0, 0, 0, 0, 3.5, 3.5, 1.5, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                    if (GetDistanceBetweenCoords(pCoords, Config.Zones.TruckRemove.Pos.x, Config.Zones.TruckRemove.Pos.y, Config.Zones.TruckRemove.Pos.z, true) < 5) then
                        ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby oddac pojazd Widlak')
                        if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 2000 then
                            GUI.Time = GetGameTimer()
                            local playerPed = GetPlayerPed(-1)
                            if IsPedInAnyVehicle(playerPed, false) then
                                local vehicle = GetVehiclePedIsIn(playerPed, false)
                                if IsVehicleModel(vehicle, GetHashKey(trailertaken)) then
                                    PutTruck(vehicle)
                                end
                            end
                        end
                    end
                end
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if gottrailer and not truckerjobdone then
            local Gracz = GetPlayerPed(-1)
            local Pozycja = GetEntityCoords(Gracz)
            local Dystans = GetDistanceBetweenCoords(Pozycja, currenttruckdelivery.x, currenttruckdelivery.y, currenttruckdelivery.z, true)
            if Dystans <= 40.0 and (not gottruckbox) then
                local PozycjaDostawy = {
                    ["x"] = currenttruckdelivery.x,
                    ["y"] = currenttruckdelivery.y,
                    ["z"] = currenttruckdelivery.z
                }
                ESX.Game.Utils.DrawText3D(PozycjaDostawy, "Zabierz ~y~Paczke~s~ Z ~b~Ciezarowki~s~!", 0.6)
                local pojazd = GetClosestVehicle(Pozycja, 6.0, 0, 70)
                local usingtrailer, trailerNo = GetVehicleTrailerVehicle(pojazd)
                if IsVehicleModel(pojazd, GetHashKey(trailertaken)) and usingtrailer and trailerNo ~= 0 then
                    local pozycjaPojazdu = GetEntityCoords(pojazd)
                    local Odleglosc = GetDistanceBetweenCoords(Pozycja, pozycjaPojazdu, true)
                    ESX.Game.Utils.DrawText3D(pozycjaPojazdu, "Nacisnij [~g~E~s~] aby wyciagnac ~y~Paczke", 1.0, 5.0, "~b~Ciezarowki", 1.15)
                    if Dystans >= 4 and Odleglosc <= 5 then
                        closetotrailer = true
                    end
                end
            elseif Dystans <= 25 and gottruckbox then
                local PozycjaDostawy = {
                    ["x"] = currenttruckdelivery.x,
                    ["y"] = currenttruckdelivery.y,
                    ["z"] = currenttruckdelivery.z
                }
                ESX.Game.Utils.DrawText3D(PozycjaDostawy, "Nacisnij [~g~E~s~] aby dostarczyc ~y~Paczke", 0.55, 1.5, "~b~Dostawa", 0.7)
                if Dystans <= 3 then
                    if IsControlJustReleased(0, 38) then
                        GetTruckBox()
                        DeliverTruckBox()
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if (not gottruckbox) and closetotrailer then
            if IsControlJustReleased(0, 38) then
                Citizen.Wait(100)
                GetTruckBox()
                closetotrailer = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Wait(1000)
        if PlayerData.job ~= nil and PlayerData.job.name == 'trucker' then 
            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil
            if(GetDistanceBetweenCoords(coords, Config.Zones.Truck.Pos.x, Config.Zones.Truck.Pos.y, Config.Zones.Truck.Pos.z, true) < 3) then
                isInMarker  = true
            end
            if isInMarker and not HasAlreadyEnteredMarker then
              HasAlreadyEnteredMarker = true
            end
            if not isInMarker and HasAlreadyEnteredMarker then
              HasAlreadyEnteredMarker = false
              ESX.UI.Menu.CloseAll()
            end
        end
    end
end)

function GetTruckBox()
    local player = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'hei_prop_heist_box'
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
            loadAnimDict( ad )
            if gottruckbox then
                TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0 )
                DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                Wait(1000)
                ClearPedSecondaryTask(PlayerPedId())
                gottruckbox = false
            else
                local x,y,z = table.unpack(GetEntityCoords(player))
                prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                TaskPlayAnim( player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                gottruckbox = true
            end
        end
    end
end

function DeliverTruckBox()
    if not deliveringtruckbox then
        deliveringtruckbox = true
        numberoftruckboxes = numberoftruckboxes + 1
        gottruckbox = false    
        Citizen.Wait(2500)
        deliveringtruckbox = false
        if numberoftruckboxes < 5 then
            currenttruckdelivery = Config.Zones.TruckDropOff[GetRandomIntInRange(1, #Config.Zones.TruckDropOff)]
            if currenttruckdelivery ~= nil then
                RemoveBlip(deliveryblip)
                deliveryblip = AddBlipForCoord(currenttruckdelivery)
                SetBlipAsFriendly(deliveryblip, true)
                SetBlipColour(deliveryblip, 2)
                SetBlipCategory(deliveryblip, 3)
                SetBlipRoute(deliveryblip, true)
            end
        elseif numberoftruckboxes >= 5 then
            truckerjobdone = true
            print('pay truck')
            RemoveBlip(deliveryblip)
            currenttruckdelivery = nil
            TriggerServerEvent('sandyrp:savexptrucker2', numberoftruckboxes)
            numberoftruckboxes = 0
            deliveryblip = AddBlipForCoord(-102.63, -2539.40, 6.00)
            SetBlipAsFriendly(deliveryblip, true)
            SetBlipColour(deliveryblip, 2)
            SetBlipCategory(deliveryblip, 3)
            SetBlipRoute(deliveryblip, true)
            print(numberoftruckboxes)
        end
    end
end

function PutTruck(vehicle)
    ESX.Game.DeleteVehicle(vehicle)
    RemoveBlip(deliveryblip)
    gottrailer = false
    gottruck = false
    currenttruckdelivery = nil
    trailertaken = nil
    truckerjobdone = false
end

function loadAnimDict(dict)
    while ( not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function HelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

function AddVehicleKeys(vehicle)
    local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
    if localVehPlateTest ~= nil then
        local localVehPlate = string.lower(localVehPlateTest)
        TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
        TriggerEvent("ls:notify", "Otrzymałeś kluczki swojego do pojazdu")
    end
end

function GetForkLift()
    if ESX.Game.IsSpawnPointClear(Config.Zones.Spawn.Pos, 3) then
        if gotforklift == true then
            ESX.ShowNotification('Wypożyczyłeś/aś już pojazd! Anuluj  lub zakończ aktualne zlecenie, aby otrzymać nowy!')
        elseif gotforklift == false then
            local veh = "forklift"
            ESX.Game.SpawnVehicle(veh, {
                x = Config.Zones.Spawn.Pos.x,
                y = Config.Zones.Spawn.Pos.y,
                z = Config.Zones.Spawn.Pos.z
            }, Config.Zones.Spawn.Heading, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
            local rejka = "MEX " .. GetRandomIntInRange(100,999)
            SetVehicleNumberPlateText(vehicle, rejka)
            SetVehicleDirtLevel(vehicle, 0.0000000001)
            SetVehicleUndriveable(vehicle, false)
            AddVehicleKeys(vehicle)
            end)
            gotforklift = true
        end
    else
        ESX.ShowNotification('Miejsce parkingowe jest już zajęte przez inny pojazd!')
    end
end

function PutForkLift(vehicle)
    ESX.Game.DeleteVehicle(vehicle)
    RemoveBlip(deliveryblip)
    DeleteObject(currentbox)
    currentdelivery = nil
    gotforklift = false
end

function LoadForkLift(vehicle, pCoords)
    FreezeEntityPosition(vehicle, true)
    ESX.ShowNotification('Trwa ladowanie widlaka!')
    Wait(5000)
    ESX.Game.SpawnObject('prop_box_wood04a', {
        x = pCoords.x,
        y = pCoords.y,
        z = pCoords.z + 2
    }, function(prop)
        while not IsEntityAttached(prop) do
            AttachEntityToEntity(prop, vehicle, GetHashKey('forks'), 0, 2.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            Wait(100)
            currentbox = prop
            currentdelivery = Config.Zones.ForkliftDropOff[GetRandomIntInRange(1, #Config.Zones.ForkliftDropOff)]
            gotbox = true
            FreezeEntityPosition(vehicle, false)
        end
    end)
end

function UnloadForkLift(vehicle)
    FreezeEntityPosition(vehicle, true)
    ESX.ShowNotification('Trwa wyladowanie widlaka!')
    Wait(5000)
    DeleteObject(currentbox)
    RemoveBlip(deliveryblip)
    deliveryblip = AddBlipForCoord(-102.63, -2539.40, 6.00)
    SetBlipAsFriendly(deliveryblip, true)
    SetBlipColour(deliveryblip, 2)
    SetBlipCategory(deliveryblip, 3)
    SetBlipRoute(deliveryblip, true)
    numberofboxesdropped = numberofboxesdropped + 1
    gotbox = false
    currentdelivery = nil
    FreezeEntityPosition(vehicle, false)
    if numberofboxesdropped == 10 then
        print('pay widlak')
        TriggerServerEvent('sandyrp:savexptrucker', numberofboxesdropped)
        numberofboxesdropped = 0
        print(numberofboxesdropped)
    end
end

function TruckerMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {
        {label = 'Ciezarowki', value = 'truck'},
        {label = 'Naczepy', value = 'trailer'},
        {label = 'Usun Pojazd', value = 'deleteveh'}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'truckermenu_actions',
    {
        title    = 'Garaz MEXA TRANS',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local ply = GetPlayerPed(-1)
        if not IsPedInAnyVehicle(ply, true) then               
            if data.current.value == 'truck' then
                menu.close()
                TruckMenu()
            elseif data.current.value == 'trailer' then
                menu.close()
                TrailerMenu()
            elseif data.current.value == 'deleteveh' then
                menu.close()
                local playerPed = GetPlayerPed(-1)
                local pCoords = GetEntityCoords(playerPed)
                local vehicle = GetClosestVehicle(pCoords, 14.0, 0, 70)

                if DoesEntityExist(vehicle) then
                    SetEntityAsMissionEntity(vehicle, false, true)
                    DeleteVehicle(vehicle)
                end
                gottruck = true
                gottrailer = false
            end
        else
            ESX.ShowNotification('~r~Nie mozesz byc w pojezdzie!')
        end
    end, function(data, menu)
        menu.close()
    end)
end

function TruckMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}

    for i=1, #Config.Zones.TruckList, 1 do
        table.insert(elements, { label = Config.Zones.TruckList[i].label, model = Config.Zones.TruckList[i].model})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'truckermenu_actions',
    {
        title    = 'Ciezarowki MEXA TRANS',
        align    = 'center',
        elements = elements
    }, function(data, menu)
    if gottruck == true then
        ESX.ShowNotification('Wypożyczyłeś/aś już pojazd! Anuluj  lub zakończ aktualne zlecenie, aby otrzymać nowy!')
    elseif gottruck == false then
        if (GetGameTimer() - GUI.Time) > 2000 then
            GUI.Time = GetGameTimer()
            local ply = GetPlayerPed(-1)
            if not IsPedInAnyVehicle(ply, true) then  
                if ESX.Game.IsSpawnPointClear(Config.Zones.TruckSpawn.Pos, 3) then           
                    local model = data.current.model
                    local playerPed = PlayerPedId()
                      ESX.Game.SpawnVehicle(model, {
                        x = Config.Zones.TruckSpawn.Pos.x,
                        y = Config.Zones.TruckSpawn.Pos.y,
                        z = Config.Zones.TruckSpawn.Pos.z
                    }, Config.Zones.TruckSpawn.Heading, function(vehicle)
                        trailertaken = model
                        TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                        local rejka = "MEX " .. GetRandomIntInRange(100,999)
                        SetVehicleNumberPlateText(vehicle, rejka)
                        SetVehicleDirtLevel(vehicle, 0.0000000001)
                        SetVehicleUndriveable(vehicle, false)
                        AddVehicleKeys(vehicle)
                        gottruck = true
                    end)
                else
                    ESX.ShowNotification('Miejsce parkingowe jest już zajęte przez inny pojazd!')
                end  
            else
                ESX.ShowNotification('~r~Nie mozesz byc w pojezdzie!')
            end
        end
    end
    end, function(data, menu)
        menu.close()
    end)
end

function TrailerMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}

    for i=1, #Config.Zones.TrailerList, 1 do
        table.insert(elements, { label = Config.Zones.TrailerList[i].label, model = Config.Zones.TrailerList[i].model})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'truckermenu_actions',
    {
        title    = 'Naczepy MEXA TRANS',
        align    = 'center',
        elements = elements
    }, function(data, menu)
    if gottruck then
        if gottrailer == true then
            ESX.ShowNotification('Wypożyczyłeś/aś już pojazd! Anuluj  lub zakończ aktualne zlecenie, aby otrzymać nowy!')
        elseif gottrailer == false then
            if (GetGameTimer() - GUI.Time) > 2000 then
                GUI.Time = GetGameTimer()
                local ply = GetPlayerPed(-1)
                if not IsPedInAnyVehicle(ply, true) then  
                    if ESX.Game.IsSpawnPointClear(Config.Zones.TruckSpawn.Pos, 3) then           
                        local model = data.current.model
                          ESX.Game.SpawnVehicle(model, {
                            x = Config.Zones.TruckSpawn.Pos.x,
                            y = Config.Zones.TruckSpawn.Pos.y,
                            z = Config.Zones.TruckSpawn.Pos.z
                        }, Config.Zones.TruckSpawn.Heading, function(vehicle)
                            local rejka = "MEX " .. GetRandomIntInRange(100,999)
                            SetVehicleNumberPlateText(vehicle, rejka)
                            SetVehicleDirtLevel(vehicle, 0.0000000001)
                            SetVehicleUndriveable(vehicle, false)
                            currenttruckdelivery = Config.Zones.TruckDropOff[GetRandomIntInRange(1, #Config.Zones.TruckDropOff)]
                            gottrailer = true
                            Wait(1000)
                            if currenttruckdelivery ~= nil then
                                RemoveBlip(deliveryblip)
                                deliveryblip = AddBlipForCoord(currenttruckdelivery)
                                SetBlipAsFriendly(deliveryblip, true)
                                SetBlipColour(deliveryblip, 2)
                                SetBlipCategory(deliveryblip, 3)
                                SetBlipRoute(deliveryblip, true)
                            end
                        end)
                    else
                        ESX.ShowNotification('Miejsce parkingowe jest już zajęte przez inny pojazd!')
                    end  
                else
                    ESX.ShowNotification('~r~Nie mozesz byc w pojezdzie!')
                end
            end
        end
    end
    end, function(data, menu)
        menu.close()
    end)
end