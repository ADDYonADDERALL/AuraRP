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

local PlayerData = {}
local wzial = false
local delete = false
local radiokeybind = nil
ESX = nil

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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
  PlayerData.job2 = job2
end)

function DrawText3D(x, y, z, text)
        local onScreen,_x,_y=World3dToScreen2d(x, y, z)
        local px,py,pz=table.unpack(GetGameplayCamCoords())
        SetTextScale(0.40, 0.40)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(0, 204, 0, 255)
        SetTextEntry("STRING")
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 150)
            SetTextDropShadow()
            SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

Citizen.CreateThread(function()
        while true do
                Citizen.Wait(1000)
                if wzial == true then
                        Citizen.Wait(Config.Delay * 60000)
                        wzial = false
                end
        end
end)

Citizen.CreateThread(function()
        while true do
                Citizen.Wait(5)
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local delay = Config.Delay
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PosLSPD.x, Config.PosLSPD.y, Config.PosLSPD.z)
                local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PosEMS.x, Config.PosEMS.y, Config.PosEMS.z)
                local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.PosNEWS.x, Config.PosNEWS.y, Config.PosNEWS.z)
                if Config.LSPD then
                        if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job2 ~= nil and PlayerData.job2.name == 'weazelnews' then
                                if dist <= 10.0 then
                                    DrawText3D(Config.PosLSPD.x, Config.PosLSPD.y, Config.PosLSPD.z+1, "~g~[E]~w~ Weź helikopter!")
                                    DrawMarker(Config.MarkerType, Config.PosLSPD.x, Config.PosLSPD.y, Config.PosLSPD.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                                elseif dist2 <= 10.0 then
                                    DrawMarker(Config.MarkerType, Config.PosEMS.x, Config.PosEMS.y, Config.PosEMS.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                                    DrawText3D(Config.PosEMS.x, Config.PosEMS.y, Config.PosEMS.z+1, "~g~[E]~w~ Weź helikopter!")
                                elseif dist3 <= 10.0 then
                                    DrawMarker(Config.MarkerType, Config.PosNEWS.x, Config.PosNEWS.y, Config.PosNEWS.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                                    DrawText3D(Config.PosNEWS.x, Config.PosNEWS.y, Config.PosNEWS.z+1, "~g~[E]~w~ Weź helikopter!")
                                else
                                    Citizen.Wait(1000)
                                end
                                if GetDistanceBetweenCoords(pos, Config.PosLSPD.x, Config.PosLSPD.y, Config.PosLSPD.z,  true) < 3 then
                                        if IsControlJustReleased(0, Config.Przycisk) then
                                                if not wzial then
                                                        DoScreenFadeOut(500)
                                                        Citizen.Wait(500)
                                                        ESX.Game.SpawnVehicle(Config.Helikopter, { x = Config.HeliLSPD.x, y = Config.HeliLSPD.y, z = Config.HeliLSPD.z }, Config.HeliLSPD.h, function(heliLSPD)
                                                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), heliLSPD, -1)
                                                        end)
                                                        delete = true
                                                        wzial = true
                                                        Citizen.Wait(500)
                                                        DoScreenFadeIn(500)
                                                else
                                                        ESX.ShowNotification("Wziąłeś już helikopter. Musisz odczekać " .. delay .. " minut")
                                                end
                                        end
                                elseif GetDistanceBetweenCoords(pos, Config.PosEMS.x, Config.PosEMS.y, Config.PosEMS.z,  true) < 3 then
                                        if IsControlJustReleased(0, Config.Przycisk) then
                                                if not wzial then
                                                        DoScreenFadeOut(500)
                                                        Citizen.Wait(500)
                                                        ESX.Game.SpawnVehicle(Config.Helikopterems, { x = Config.HeliEMS.x, y = Config.HeliEMS.y, z = Config.HeliEMS.z }, Config.HeliEMS.h, function(heliEMS)
                                                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), heliEMS, -1)
                                                                delete = true
                                                                wzial = true
                                                        end)
                                                        delete = true
                                                        wzial = true
                                                        Citizen.Wait(500)
                                                        DoScreenFadeIn(500)
                                                else
                                                        ESX.ShowNotification("Wziąłeś już helikopter. Musisz odczekać " .. delay .. " minut")
                                                end
                                        end
                                elseif GetDistanceBetweenCoords(pos, Config.PosNEWS.x, Config.PosNEWS.y, Config.PosNEWS.z,  true) < 3 then
                                        if IsControlJustReleased(0, Config.Przycisk) then
                                                if not wzial then
                                                        DoScreenFadeOut(500)
                                                        Citizen.Wait(500)
                                                        ESX.Game.SpawnVehicle(Config.Helikopternews, { x = Config.HeliNEWS.x, y = Config.HeliNEWS.y, z = Config.HeliNEWS.z }, Config.HeliNEWS.h, function(heliEMS)
                                                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), heliEMS, -1)
                                                                delete = true
                                                                wzial = true
                                                        end)
                                                        delete = true
                                                        wzial = true
                                                        Citizen.Wait(500)
                                                        DoScreenFadeIn(500)
                                                else
                                                        ESX.ShowNotification("Wziąłeś już helikopter. Musisz odczekać " .. delay .. " minut")
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
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                if delete then
                        DrawMarker(34, Config.DeleterEMS.x, Config.DeleterEMS.y, Config.DeleterEMS.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                        DrawMarker(34, Config.DeleterLSPD.x, Config.DeleterLSPD.y, Config.DeleterLSPD.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                        if GetDistanceBetweenCoords(pos, Config.DeleterEMS.x, Config.DeleterEMS.y, Config.DeleterEMS.z,  true) < 3 then
                                if IsControlJustReleased(0, Config.Przycisk) then
                                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped, false))
                                        ESX.ShowNotification("Odholowałeś helikopter")
                                        delete = false
                                        wzial = false
                                end
                        elseif GetDistanceBetweenCoords(pos, Config.DeleterLSPD.x, Config.DeleterLSPD.y, Config.DeleterLSPD.z,  true) < 3 then
                                if IsControlJustReleased(0, Config.Przycisk) then
                                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped, false))
                                        ESX.ShowNotification("Odholowałeś helikopter")
                                        delete = false
                                        wzial = false
                                end
                        elseif GetDistanceBetweenCoords(pos, Config.DeleterNEWS.x, Config.DeleterNEWS.y, Config.DeleterNEWS.z,  true) < 3 then
                                if IsControlJustReleased(0, Config.Przycisk) then
                                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ped, false))
                                        ESX.ShowNotification("Odholowałeś helikopter")
                                        delete = false
                                        wzial = false
                                end
                        end
                end
        end
end)

RegisterCommand("wezbind", function(source, args, rawCommand)
    if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.TriggerServerCallback('sandy_radio:checkkeybind', function (playerkeybind)
            if playerkeybind ~= nil then
                radiokeybind = playerkeybind
                ESX.ShowNotification('~y~Wczytano:~b~ '..radiokeybind..'~s~ jako keybind do radia')
            end
        end)
    end
end)

RegisterNetEvent('sandy_radio:setkeybind')
AddEventHandler('sandy_radio:setkeybind', function(keybind)
  radiokeybind = keybind
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local ped = PlayerPedId()
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
				if not IsPauseMenuActive() and radiokeybind ~= nil then 
					loadAnimDict( "random@arrests" )
					if IsControlJustReleased( 0, Keys[radiokeybind]) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TriggerServerEvent('SANDY_InteractSound_SV:PlayOnSource', 'off', 0.1)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
					else
						if IsControlJustPressed( 0, Keys[radiokeybind] ) and not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
							TriggerServerEvent('SANDY_InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						elseif IsControlJustPressed( 0, Keys[radiokeybind] ) and IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
							TriggerServerEvent('SANDY_InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						end 
						if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
							DisableActions(ped)
						elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
							DisableActions(ped)
						end
					end
				end
			end
		end
	end
end )

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end