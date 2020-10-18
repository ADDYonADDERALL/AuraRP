local holdingup = false
local bank = ""
local secondsRemaining = 0
local blipRobbery = nil
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

RegisterNetEvent('esx_holdupbank:currentlyrobbing')
AddEventHandler('esx_holdupbank:currentlyrobbing', function(robb)
	for k,v in pairs(Banks)do
	holdingup = true
	bank = robb
	secondsRemaining = Banks[bank].secondsRemaining
	--secondsRemaining = 500
	end
end)

RegisterNetEvent('esx_holdupbank:killblip')
AddEventHandler('esx_holdupbank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdup_bank:setblip')
AddEventHandler('esx_holdup_bank:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('^ Napad w trakcie')
    EndTextCommandSetBlipName(blipRobbery)
    PulseBlip(blipRobbery)
    PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
end)

RegisterNetEvent('esx_holdupbank:toofarlocal')
AddEventHandler('esx_holdupbank:toofarlocal', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('esx_holdupbank:robberycomplete')
AddEventHandler('esx_holdupbank:robberycomplete', function(robb)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete') .. Banks[bank].reward)
	bank = ""
	secondsRemaining = 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
	end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Banks)do
        local ve = v.position
        local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
        SetBlipSprite(blip, v.ikonka)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, v.kolor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip)
        EndTextCommandSetBlipName(blip)
    end
end)
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText(_U('press_to_rob') .. v.nameofbank)
						end
						incircle = true
						if IsControlJustReleased(1, 51) then
							ESX.TriggerServerCallback('sandy_cooldown:canrob', function(status)
								print(status)
								if status == false then
									TriggerServerEvent('esx_holdupbank:rob', k)
								else
									TriggerServerEvent('sandy_cooldown:gettimer')
								end
							end)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup then
			local ped = PlayerPedId()
			if IsControlJustReleased(1, 73) then
				TriggerServerEvent('esx_holdupbank:toofar', bank)
				ClearPedTasks(ped)
				Citizen.Wait(1000)
			else
				if not IsPedUsingScenario(ped, "WORLD_HUMAN_CONST_DRILL") then
					ClearPedTasks(ped)
					TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CONST_DRILL", 0, true)
			   end	
			end
			DrawText3D(pos.x, pos.y, pos.z + 0.98, 'Pozostało:~b~ '.. secondsRemaining ..' sekund.')

			local pos2 = Banks[bank].position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5)then
				TriggerServerEvent('esx_holdupbank:toofar', bank)
			end
		end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_napady:wierceniekurwa')
AddEventHandler('esx_napady:wierceniekurwa', function(source)
	DrillAnimation()
end)

RegisterNetEvent('esx_napad:kurwaprzerwij')
AddEventHandler('esx_napad:kurwaprzerwij', function()
	local playerPed = GetPlayerPed(-1)
	ClearPedTasks(playerPed)
end)

function DrillAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CONST_DRILL", 0, true)               
	end)
end