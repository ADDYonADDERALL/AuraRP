local GUI = {}

ESX = nil
GUI.Time = 0
local PlayerData = {}

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

local blip2		= nil
local blip3		= nil
local blip4		= nil
local blip5		= nil
local blip6		= nil
local blip7		= nil
local blip8		= nil
local blip9		= nil

local pracuje = false
local Blipy = {}
local kurwaspierdalaj = false
local HasAlreadyEnteredMarker = false
local zbieraluj = false
local dodatkowyhajs = false
local cooldown = false

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
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
        if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
            local player = GetPlayerPed(-1)
            if GetDistanceBetweenCoords(GetEntityCoords(player, true), Config.dostawastart.x, Config.dostawastart.y, Config.dostawastart.z, true) < 10 then
                DrawMarker(1, Config.dostawastart.x, Config.dostawastart.y,Config.dostawastart.z-0.90, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
	            if GetDistanceBetweenCoords(GetEntityCoords(player, true), Config.dostawastart.x, Config.dostawastart.y, Config.dostawastart.z, true) < 1.5 then
	                HelpText("Naciśnij ~INPUT_CONTEXT~, aby otworzyć przebieralnię")
	               	if IsControlJustReleased(1, 51) and (GetGameTimer() - GUI.Time) > 1000 then
	                    MenuPrzebieralnia()
	                    GUI.Time = GetGameTimer()
		            end
		        end
		    end
	    end
	end
end)

local blips = {
     {title="Praca Kuriera", id=67, x = 801.56, y = -2975.12, z = 15.9},
  }
      
Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.7)
      SetBlipColour(info.blip, 3)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function StworzBlipa()
	if PlayerData.job ~= nil and PlayerData.job.name == "deliverer" and pracuje then
    blip2 = AddBlipForCoord(Config.zbieraniepaczek4.x, Config.zbieraniepaczek4.y, Config.zbieraniepaczek4.z)
        SetBlipSprite(blip2, 477)
        SetBlipColour(blip2, 61)
        SetBlipAsShortRange(blip2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zbieranie paczek")
        EndTextCommandSetBlipName(blip2)	
    blip3 = AddBlipForCoord(Config.garazwyciagnij.x, Config.garazwyciagnij.y, Config.garazwyciagnij.z)
        SetBlipSprite(blip3, 85)
        SetBlipColour(blip3, 26)
        SetBlipAsShortRange(blip3, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Wyciągniecie pojazdu")
        EndTextCommandSetBlipName(blip3)		
    else
        if blip2 ~= nil then
            RemoveBlip(blip2)
            blip2 = nil
        end
        if blip3 ~= nil then
            RemoveBlip(blip3)
            blip3 = nil
        end
        if blip3 ~= nil then
            RemoveBlip(blip3)
            blip3 = nil
        end
    end
end

Citizen.CreateThread(function()
    while true do
    Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
            local coords  = GetEntityCoords(PlayerPedId())
			if (GetDistanceBetweenCoords(coords, 827.94, -2954.21, 5.9, true) < 5) then
			DrawMarker(1, 827.94, -2954.21, 5.9-0.90, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
				if(GetDistanceBetweenCoords(coords, 827.94, -2954.21, 5.9, true) < 1.5) then
					if IsControlJustReleased(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
						if pracuje == true then
							if IsPedInAnyVehicle(PlayerPedId(),  false) then
								local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
								local hash      = GetEntityModel(vehicle)
								if DoesEntityExist(vehicle) then
									if hash == GetHashKey('boxville2') then
										ESX.ShowNotification('Oddano auta do garażu')
										DeleteVehicle(vehicle)
										kurwaspierdalaj = true
									else
										ESX.ShowNotification('Zły pojazd!')
									end	
								end
							else
								local veh = "boxville2"
								ESX.Game.SpawnVehicle(veh, {
						            x = 827.94,
						            y = -2954.21,
						            z = 5.9
						        	}, 183.71, function(vehicle)
						            TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
						            local rejka = "KUR " .. GetRandomIntInRange(100,999)
						            SetVehicleNumberPlateText(vehicle, rejka)
						            SetVehicleDirtLevel(vehicle, 0.0000000001)
						            SetVehicleUndriveable(vehicle, false)
						            AddVehicleKeys(vehicle)
						        end)
								ESX.ShowNotification('Pobrano auto z garażu')
							end
						else
							ESX.ShowNotification('Musisz się przebrać!')
						end
						GUI.Time = GetGameTimer()
					end
				end
			end
		end
	end
end)

RegisterNetEvent('sandy_kurier:oddawaniemoczu')
AddEventHandler('sandy_kurier:oddawaniemoczu', function(takczychujwie)
    local ped = PlayerPedId()
    if takczychujwie == false then
        zbieraluj = false
        --FreezeEntityPosition(ped, false)
    elseif takczychujwie == true then
        zbieraluj = true
        --FreezeEntityPosition(ped, true)
    end
end)

Citizen.CreateThread(function() 

    while true do
        Citizen.Wait(5)
        if pracuje then
        if not cooldown then
            if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
                local ped = PlayerPedId()
                local koordy = GetEntityCoords(ped)
                local vehped = GetVehiclePedIsIn(ped, false)
                if GetDistanceBetweenCoords(koordy, Config.zbieraniepaczek4.x, Config.zbieraniepaczek4.y, Config.zbieraniepaczek4.z, true ) < 50 then
                    DrawMarker(1, Config.zbieraniepaczek4.x, Config.zbieraniepaczek4.y,Config.zbieraniepaczek4.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.zbieraniepaczek4.x, Config.zbieraniepaczek4.y, Config.zbieraniepaczek4.z, true ) < 3 then
                            HelpText("Naciśnij ~INPUT_CONTEXT~ aby zbierac paczki.")
                            if IsControlJustReleased(1, 51) and (GetGameTimer() - GUI.Time) > 1000 then
								if IsPedInAnyVehicle(ped, true) then
									HelpText("Nie mozesz zbierac paczek z samochodu")
								else
                                    TriggerServerEvent("sandy_kurier:zbierzpaczki")
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek1.x, Config.dostawapaczek1.y, Config.dostawapaczek1.z) 
								end
								GUI.Time = GetGameTimer()
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
        if pracuje then
        if not cooldown then
            if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
                local ped = PlayerPedId()
                local koordy = GetEntityCoords(ped)
                if GetDistanceBetweenCoords(koordy, Config.dostawapaczek1.x, Config.dostawapaczek1.y, Config.dostawapaczek1.z, true ) < 50 then
                    DrawMarker(1, Config.dostawapaczek1.x, Config.dostawapaczek1.y,Config.dostawapaczek1.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek1.x, Config.dostawapaczek1.y, Config.dostawapaczek1.z, true ) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    RemoveBlip(Blipy['cel'])
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkapolice") 
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek2.x, Config.dostawapaczek2.y, Config.dostawapaczek2.z) 
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek2.x, Config.dostawapaczek2.y, Config.dostawapaczek2.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek2.x, Config.dostawapaczek2.y,Config.dostawapaczek2.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek2.x, Config.dostawapaczek2.y, Config.dostawapaczek2.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkaems")
                                    RemoveBlip(Blipy['cel']) 
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek3.x, Config.dostawapaczek3.y, Config.dostawapaczek3.z)                                                                                                      
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek3.x, Config.dostawapaczek3.y, Config.dostawapaczek3.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek3.x, Config.dostawapaczek3.y,Config.dostawapaczek3.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek3.x, Config.dostawapaczek3.y, Config.dostawapaczek3.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkalsc")
                                    RemoveBlip(Blipy['cel'])   
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek4.x, Config.dostawapaczek4.y, Config.dostawapaczek4.z)                      
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek4.x, Config.dostawapaczek4.y, Config.dostawapaczek4.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek4.x, Config.dostawapaczek4.y,Config.dostawapaczek4.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek4.x, Config.dostawapaczek4.y, Config.dostawapaczek4.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkacoffee")
                                    RemoveBlip(Blipy['cel']) 
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek5.x, Config.dostawapaczek5.y, Config.dostawapaczek5.z)                                                                                                                   
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek5.x, Config.dostawapaczek5.y, Config.dostawapaczek5.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek5.x, Config.dostawapaczek5.y,Config.dostawapaczek5.z-0.75, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek5.x, Config.dostawapaczek5.y, Config.dostawapaczek5.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkapacific")                                            
                                    RemoveBlip(Blipy['cel']) 
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek6.x, Config.dostawapaczek6.y, Config.dostawapaczek6.z)                                              
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek6.x, Config.dostawapaczek6.y, Config.dostawapaczek6.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek6.x, Config.dostawapaczek6.y,Config.dostawapaczek6.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek6.x, Config.dostawapaczek6.y, Config.dostawapaczek6.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkahumane")                                            
                                    RemoveBlip(Blipy['cel'])   
                                    TriggerEvent('sandy_kurier:setblip', Config.dostawapaczek7.x, Config.dostawapaczek7.y, Config.dostawapaczek7.z)                                          
                                end
                                GUI.Time = GetGameTimer()
                            end
                        end
                    end
                elseif GetDistanceBetweenCoords(koordy, Config.dostawapaczek7.x, Config.dostawapaczek7.y, Config.dostawapaczek7.z, true) < 50 then
                    DrawMarker(1, Config.dostawapaczek7.x, Config.dostawapaczek7.y,Config.dostawapaczek7.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if zbieraluj == false then
                        if GetDistanceBetweenCoords(koordy, Config.dostawapaczek7.x, Config.dostawapaczek7.y, Config.dostawapaczek7.z, true) < 3 then
                            if IsControlJustPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
                                if not IsPedInAnyVehicle(ped, false) then
                                    TriggerServerEvent('sandy_kurier:dostarczpaczki', "paczkadoj")                                               
                                    RemoveBlip(Blipy['cel'])   
                                    TriggerEvent('sandy_kurier:setblip', Config.podajkwit.x, Config.podajkwit.y, Config.podajkwit.z) 
                                    dodatkowyhajs = true                                                                                  
                                end
                                GUI.Time = GetGameTimer()
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
        if kurwaspierdalaj then
            if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
                local ped = GetPlayerPed(-1)
                local koordy = GetEntityCoords(ped, true)
                if GetDistanceBetweenCoords(koordy, Config.podajkwit.x, Config.podajkwit.y, Config.podajkwit.z, true) < 10 and pracuje == true then
                    DrawMarker(1, Config.podajkwit.x, Config.podajkwit.y,Config.podajkwit.z-0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 216, 12, 239, 155, 0, 0, 2, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(koordy, Config.podajkwit.x, Config.podajkwit.y, Config.podajkwit.z, true) < 3 then
                        HelpText("Naciśnij ~INPUT_CONTEXT~, aby podac kwit szefowi")
                        if IsControlJustReleased(1, 51) and (GetGameTimer() - GUI.Time) > 1000 then					
    						RemoveBlip(Blipy['cel'])					
                            Citizen.Wait(200)
                            TriggerServerEvent('sandyrp:savexpkurier')	
                            kurwaspierdalaj = false
                            dodatkowyhajs = false
                            GUI.Time = GetGameTimer()
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('sandy_kurier:setblip')
AddEventHandler('sandy_kurier:setblip', function(cordx,cordy,cordz)
    RemoveBlip(Blipy['cel'])                 
    Blipy['cel'] = AddBlipForCoord(cordx, cordy, cordz)
    SetBlipRoute(Blipy['cel'], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Odbiorca Paczki')
    EndTextCommandSetBlipName(Blipy['cel'])
end)

RegisterNetEvent('sandy_kurier:dostarczanie')
AddEventHandler('sandy_kurier:dostarczanie', function()
    Dostarczanie()
end)

RegisterNetEvent('sandy_kurier:zaduzo')
AddEventHandler('sandy_kurier:zaduzo', function()
    HelpText("Posiadasz maksymalną ilosc paczek")
end)

RegisterNetEvent('sandy_kurier:zamalo')
AddEventHandler('sandy_kurier:zamalo', function()
    HelpText("Nie masz wystarczajaco paczek")
    
end)

RegisterNetEvent('sandy_kurier:niemakwitu')
AddEventHandler('sandy_kurier:niemakwitu', function()
    HelpText("Nie masz kwitu")
end)

function Dostarczanie() 
    local ped = PlayerPedId()

    Citizen.CreateThread(function()
        RequestAnimDict("amb@prop_human_bum_bin@idle_a")
        Citizen.Wait(100)
        TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 40, 0, 0, 0, 0)
        Citizen.Wait(7000)
        TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 40, 0, 0, 0, 0)
    end)
end

function AddVehicleKeys(vehicle)
    local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
    if localVehPlateTest ~= nil then
        local localVehPlate = string.lower(localVehPlateTest)
        TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
        TriggerEvent("ls:notify", "Otrzymałeś kluczki swojego do pojazdu")
    end
end

function HelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

function blokada_przycisk()
	Citizen.CreateThread(function()
		while blokada do
			Citizen.Wait(1)
			DisableControlAction(0, 73, true) 				-- x
			DisableControlAction(0, 105, true) 				-- x
			DisableControlAction(0, 120, true) 				-- x
			DisableControlAction(0, 154, true) 				-- x
			DisableControlAction(0, 186, true) 				-- x
            DisableControlAction(0, 252, true) 				-- x
            DisableControlAction(0, 323, true) 				-- x
            DisableControlAction(0, 337, true) 				-- x
            DisableControlAction(0, 354, true) 				-- x
            DisableControlAction(0, 357, true) 				-- x
            DisableControlAction(0, 20, true) 				-- z
            DisableControlAction(0, 48, true) 				-- z
            DisableControlAction(0, 32, true) 				-- w
            DisableControlAction(0, 33, true) 				-- s
            DisableControlAction(0, 34, true) 				-- a
            DisableControlAction(0, 35, true) 				-- d
		end
	end)
end

function MenuPrzebieralnia()
    ESX.UI.Menu.CloseAll()
 
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = 'Szatnia kuriera',
        align    = 'center',
        elements = {
          {label = 'Rozpocznij prace', value = 'job_wear'},
          {label = 'Zakoncz prace', value = 'citizen_wear'}
        }
      },
      function(data, menu)
        local ped = PlayerPedId()
        if data.current.value == 'citizen_wear' then 
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'ubieranie', 0.2)
            RequestAnimDict("move_m@_idles@shake_off")
            Citizen.Wait(100)
            TaskPlayAnim((ped), 'move_m@_idles@shake_off', 'shakeoff_1', 8.0, 8.0, -1, 40, 0, 0, 0, 0)
              blokada = true
              blokada_przycisk()
              Wait(3000)
              ClearPedTasks(GetPlayerPed(-1))
              blokada = false
          pracuje = false
          StworzBlipa()
 
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
              TriggerEvent('skinchanger:loadSkin', skin)
          end)
        end
        if data.current.value == 'job_wear' then
              TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'ubieranie', 0.2)
              RequestAnimDict("move_m@_idles@shake_off")
              Citizen.Wait(100)
              TaskPlayAnim((ped), 'move_m@_idles@shake_off', 'shakeoff_1', 8.0, 8.0, -1, 40, 0, 0, 0, 0)
              blokada = true
              blokada_przycisk()
              Wait(3000)
              ClearPedTasks(GetPlayerPed(-1))
              blokada = false
          pracuje = true
          StworzBlipa()
 
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
              if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)  
            else
                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
            end
           
          end)
        end
        menu.close()
      end,
      function(data, menu)
        menu.close()
      end
    )
end

Citizen.CreateThread(function()
    while true do
        Wait(10)
        local coords      = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker  = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
            if(GetDistanceBetweenCoords(coords, Config.zbieraniepaczek4.x, Config.zbieraniepaczek4.y, Config.zbieraniepaczek4.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek1.x, Config.dostawapaczek1.y, Config.dostawapaczek1.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek2.x, Config.dostawapaczek2.y, Config.dostawapaczek2.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek3.x, Config.dostawapaczek3.y, Config.dostawapaczek3.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek4.x, Config.dostawapaczek4.y, Config.dostawapaczek4.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek5.x, Config.dostawapaczek5.y, Config.dostawapaczek5.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek6.x, Config.dostawapaczek6.y, Config.dostawapaczek6.z, true) < 5) then
                isInMarker = true
            elseif(GetDistanceBetweenCoords(coords, Config.dostawapaczek7.x, Config.dostawapaczek7.y, Config.dostawapaczek7.z, true) < 5) then
                isInMarker = true
            end
               
            if isInMarker and not HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = true
            end
            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerServerEvent('sandy_kurier:stopgather')
                cooldown = true
                zbieraluj = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if PlayerData.job ~= nil and PlayerData.job.name == 'deliverer' then
			if cooldown then
				ESX.ShowNotification('Poczekaj 5 sekund przed ponownym zbieraniem')
				Wait (5000)
				cooldown = false
			end
		end
    end
end)

RegisterCommand("staty", function(source, args, rawCommand)
    ESX.TriggerServerCallback('sandyrp:checkprofile', function (zwrot)
        if zwrot ~= nil then
            local lvlkurier = zwrot.kurierlvl
            local expkurier = zwrot.kurierexp
            local lvlrybak = zwrot.rybaklvl
            local exprybak = zwrot.rybakexp
            local lvltaxi = zwrot.taxilvl
            local exptaxi = zwrot.taxiexp
            local lvlwiniarz = zwrot.winiarzlvl
            local expwiniarz = zwrot.winiarzexp
            local lvltrucker = zwrot.truckerlvl
            local exptrucker = zwrot.truckerexp
            local lvlbahamas = zwrot.bahamaslvl
            local expbahamas = zwrot.bahamasexp
            if lvlkurier == nil then
                lvlkurier = 0
            end
            if expkurier == nil then
                expkurier = 0
            end
            if lvlrybak == nil then
                lvlrybak = 0
            end
            if exprybak == nil then
                exprybak = 0
            end
            if lvltaxi == nil then
                lvltaxi = 0
            end
            if exptaxi == nil then
                exptaxi = 0
            end
            if lvlwiniarz == nil then
                lvlwiniarz = 0
            end
            if expwiniarz == nil then
                expwiniarz = 0
            end
            if lvltrucker == nil then
                lvltrucker = 0
            end
            if exptrucker == nil then
                exptrucker = 0
            end
            if lvlbahamas == nil then
                lvlbahamas = 0
            end
            if expbahamas == nil then
                expbahamas = 0
            end

            local elements = {
                {label = 'Kurier - LVL: ' .. lvlkurier .. ' - EXP: ' .. expkurier,     value = 'discobania'},
                {label = 'Rybak - LVL: ' .. lvlrybak .. ' - EXP: ' .. exprybak,     value = 'discobania'},
                {label = 'Taxi - LVL: ' .. lvltaxi .. ' - EXP: ' .. exptaxi,     value = 'discobania'},
                {label = 'Winiarz - LVL: ' .. lvlwiniarz .. ' - EXP: ' .. expwiniarz,     value = 'discobania'},
                {label = 'MEXA TRANS - LVL: ' .. lvltrucker .. ' - EXP: ' .. exptrucker,     value = 'discobania'},
                {label = 'Bahamas - LVL: ' .. lvlbahamas .. ' - EXP: ' .. expbahamas,     value = 'discobania'},
            }
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'stats',
                {
                title    = 'Twoje Statystyki',
                align    = 'center',
                elements = elements,
                },
                function(data, menu)
                    
                end,
                function(data, menu)
        
                menu.close()
        
                end
            )
        end
    end)
end)