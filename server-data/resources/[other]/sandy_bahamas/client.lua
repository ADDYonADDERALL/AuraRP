local GUI = {}
ESX = nil
GUI.Time = 0
local PlayerData = {}
local deliveryblip = nil
local gottruck = false
local currenttruckdelivery = nil
local gottruckbox = false
local trailertaken = nil
local closetotrailer = false
local deliveringtruckbox = false
local numberoftruckboxes = 0
local truckerjobdone = false
local closetopickup = false

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
        pCoords = GetEntityCoords(PlayerPedId())
        if (GetDistanceBetweenCoords(pCoords, Config.Zones.Shop.Pos.x, Config.Zones.Shop.Pos.y, Config.Zones.Shop.Pos.z, true) < 10) then
            DrawMarker(1, Config.Zones.Shop.Pos.x, Config.Zones.Shop.Pos.y, Config.Zones.Shop.Pos.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
            if (GetDistanceBetweenCoords(pCoords, Config.Zones.Shop.Pos.x, Config.Zones.Shop.Pos.y, Config.Zones.Shop.Pos.z, true) < 3) then
                --ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby kupic drinka')
                if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 1000 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'bahamasshop_actions') then
                    GUI.Time = GetGameTimer()
                    bahamasshopmenu()
                end
            end
        end
        if PlayerData.job ~= nil and PlayerData.job.name == 'bahamas' then 
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
                    ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby oddac pojazd VAN')
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
end)

function bahamasshopmenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bahamasshop_actions',
        {
            title    = 'Bahamas Club',
            align    = 'center',
            elements =
        {
            {label = 'Jagermeister - <font color=green>200$</font>', price = 200, value = 'jager'},
            {label = 'Wodka - <font color=green>11$</font>', price = 11, value = 'vodka'},
            {label = 'Rum - <font color=green>200$</font>', price = 200, value = 'rhum'},
            {label = 'Whisky - <font color=green>200$</font>', price = 200, value = 'whisky'},
            {label = 'Tequila - <font color=green>200$</font>', price = 200, value = 'tequila'},
            {label = 'Martini blanc - <font color=green>200$</font>', price = 200, value = 'martini'},
            {label = 'Cola - <font color=green>15$</font>', price = 15, value = 'cola'},
            {label = 'Woda - <font color=green>5$</font>', price = 5, value = 'water'},
            {label = 'Chleb - <font color=green>5$</font>', price = 5, value = 'bread'},
            {label = 'Redgull - <font color=green>500$</font>', price = 500, value = 'redgull'},
            {label = 'Papieros - <font color=green>50$</font>', price = 50, value = 'cigarette'},
            {label = 'Zapalniczka - <font color=green>25$</font>', price = 25, value = 'zapalniczka'},
        }   
        }, function(data, menu)
            local item = data.current.value
            local price = data.current.price
            if (GetGameTimer() - GUI.Time) > 100 then
                TriggerServerEvent('sandy_bahamas:purchasedrink', item, price)
            end
            GUI.Time = GetGameTimer()
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if currenttruckdelivery ~= nil and not truckerjobdone then
            local Gracz = GetPlayerPed(-1)
            local Pozycja = GetEntityCoords(Gracz)
            local Dystans = GetDistanceBetweenCoords(Pozycja, currenttruckdelivery.x, currenttruckdelivery.y, currenttruckdelivery.z, true)
            if Dystans <= 40.0 and (not gottruckbox) then
                local PozycjaDostawy = {
                    ["x"] = currenttruckdelivery.x,
                    ["y"] = currenttruckdelivery.y,
                    ["z"] = currenttruckdelivery.z
                }
                ESX.Game.Utils.DrawText3D(PozycjaDostawy, "Nacisnij [~g~G~s~] aby odebrac ~y~Paczke", 0.55, 1.5, "~b~Odbior", 0.7)
                if Dystans <= 3 then
                    closetopickup = true
                end
            elseif Dystans <= 25 and gottruckbox then
                local PozycjaDostawy = {
                    ["x"] = currenttruckdelivery.x,
                    ["y"] = currenttruckdelivery.y,
                    ["z"] = currenttruckdelivery.z
                }
                local pojazd = GetClosestVehicle(Pozycja, 6.0, 0, 70)
                if IsVehicleModel(pojazd, GetHashKey(trailertaken)) then
                    local pozycjaPojazdu = GetEntityCoords(pojazd)
                    local Odleglosc = GetDistanceBetweenCoords(Pozycja, pozycjaPojazdu, true)
                    ESX.Game.Utils.DrawText3D(pozycjaPojazdu, "Nacisnij [~g~G~s~] aby zaladowac ~y~Paczke", 1.0, 5.0, "~b~VANA", 1.15)
                    if Dystans >= 4 and Odleglosc <= 5 then
                        closetotrailer = true
                        if IsControlJustReleased(0, 47) and closetotrailer then
                            GetTruckBox()
                            DeliverTruckBox()
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if (not gottruckbox) and closetopickup then
            if IsControlJustReleased(0, 47) then
                Citizen.Wait(100)
                GetTruckBox()
                closetopickup = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Wait(1000)
        if PlayerData.job ~= nil and PlayerData.job.name == 'bahamas' then 
            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil
            if(GetDistanceBetweenCoords(coords, Config.Zones.Truck.Pos.x, Config.Zones.Truck.Pos.y, Config.Zones.Truck.Pos.z, true) < 3) then
                isInMarker  = true
            end
            if(GetDistanceBetweenCoords(coords, Config.Zones.Shop.Pos.x, Config.Zones.Shop.Pos.y, Config.Zones.Shop.Pos.z, true) < 3) then
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
        if numberoftruckboxes < 10 then
            currenttruckdelivery = Config.Zones.TruckDropOff[GetRandomIntInRange(1, #Config.Zones.TruckDropOff)]
            if currenttruckdelivery ~= nil then
                RemoveBlip(deliveryblip)
                deliveryblip = AddBlipForCoord(currenttruckdelivery)
                SetBlipAsFriendly(deliveryblip, true)
                SetBlipColour(deliveryblip, 2)
                SetBlipCategory(deliveryblip, 3)
                SetBlipRoute(deliveryblip, true)
            end
        elseif numberoftruckboxes >= 10 then
            truckerjobdone = true
            RemoveBlip(deliveryblip)
            currenttruckdelivery = nil
            deliveryblip = AddBlipForCoord(Config.Zones.TruckRemove.Pos.x, Config.Zones.TruckRemove.Pos.y, Config.Zones.TruckRemove.Pos.z)
            SetBlipAsFriendly(deliveryblip, true)
            SetBlipColour(deliveryblip, 2)
            SetBlipCategory(deliveryblip, 3)
            SetBlipRoute(deliveryblip, true)
        end
    end
end

function PutTruck(vehicle)
    if numberoftruckboxes >= 10 then
        TriggerServerEvent('sandyrp:savexpbahamas', numberoftruckboxes)
        numberoftruckboxes = 0
    end
    ESX.Game.DeleteVehicle(vehicle)
    RemoveBlip(deliveryblip)
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

function TruckerMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {
        {label = 'Vany', value = 'truck'},
        {label = 'Usun Pojazd', value = 'deleteveh'}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'truckermenu_actions',
    {
        title    = 'Garaz Bahamas',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local ply = GetPlayerPed(-1)
        if not IsPedInAnyVehicle(ply, true) then               
            if data.current.value == 'truck' then
                menu.close()
                TruckMenu()
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
        title    = 'Vany Bahamas',
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
                        currenttruckdelivery = Config.Zones.TruckDropOff[GetRandomIntInRange(1, #Config.Zones.TruckDropOff)]
                        gottruck = true
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
    end, function(data, menu)
        menu.close()
    end)
end