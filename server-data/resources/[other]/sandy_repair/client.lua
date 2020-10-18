local PlayerData = {}
local Config = {}
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
local GUI = {}

Config.automechanik = {
	uno = {
		Pos   = { x = -210.55, y = -1323.59, z = 30.89-0.90 },
		Size  = { x = 3.5, y = 3.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1,
	},
	duo = {
		Pos   = { x = 1143.73, y = -777.93, z = 57.32-0.90 },
		Size  = { x = 3.5, y = 3.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1,
	},
	tres = {
		Pos   = { x = 111.14, y = 6625.84, z = 31.51-0.90 },
		Size  = { x = 3.5, y = 3.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1,
	},
	quatro = {
		Pos   = { x = 541.32, y = -183.21, z = 54.06-0.90 },
		Size  = { x = 3.5, y = 3.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1,
	},
	sandy = {
		Pos   = { x = 1174.99, y = 2641.17, z = 37.75-0.90 },
		Size  = { x = 3.5, y = 3.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1,
	},
}

Config.kurwapozycja = {
	starynajebany = {
		Pos = {
		{ x = -210.55, y = -1323.59, z = 30.89-0.90 },
		{ x = 1143.73, y = -777.93, z = 57.32-0.90 },
		{ x = 111.14, y = 6625.84, z = 31.51-0.90 },
		{ x = 541.32, y = -183.21, z = 54.06-0.90 },
		{ x = 1174.99, y = 2641.17, z = 37.75-0.90 }
		}
	}
}

Config.lokacjemedyk = {
	vector3(307.96, -594.80, 43.29-0.90),
	vector3(-461.20, -281.27, 34.91-0.90),
	vector3(1827.19, 3676.68, 34.27-0.90)
}

Config.extrasmenulocation = {
	vector3(462.67, -1019.40, 28.10-0.90),
	vector3(-484.71, -331.85, 34.36-0.90),
	vector3(-343.42, -114.95, 39.00-0.90)
}


ESX = nil

GUI.Time = 0

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

Citizen.CreateThread(function(timer)
	while true do
	Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.automechanik) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 15) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3) then
					if IsControlJustReleased(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 1000 then
						local mechanicy = exports['esx_scoreboard']:counter('mecano')
						local ped = PlayerPedId()
						if mechanicy > 2 then
							ESX.ShowNotification('Udaj sie do mechanika!')
						else
							if IsPedInAnyVehicle(ped,  false) then
								kurwamenu()
								GUI.Time = GetGameTimer()
							end
						end
					end	
				end
			end
		end
		for i=1, #Config.lokacjemedyk, 1 do
			if(GetDistanceBetweenCoords(coords, Config.lokacjemedyk[i], true) < 15) then
				DrawMarker(1, Config.lokacjemedyk[i], 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 100, 155, 0, 0, 2, 0, 0, 0, 0)
				if (GetDistanceBetweenCoords(coords,  Config.lokacjemedyk[i], true) < 2.0) then
					DrawText3D(Config.lokacjemedyk[i].x, Config.lokacjemedyk[i].y, Config.lokacjemedyk[i].z+1, "~w~NACIŚNIJ [~o~H~w~] ABY SIĘ ULECZYĆ")
					if IsControlPressed(0, 74) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'baska_actions') and (GetGameTimer() - GUI.Time) > 2000 then
						baskamenu()
					end
				end
			end
		end
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
	      	for i=1, #Config.extrasmenulocation, 1 do
				if(GetDistanceBetweenCoords(coords, Config.extrasmenulocation[i], true) < 15) then
					DrawMarker(1, Config.extrasmenulocation[i], 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 100, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(coords,  Config.extrasmenulocation[i], true) < 5.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby modyfikować ~y~dodatki pojazdu')
						if IsControlPressed(0, 51) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'extras_actions_actions') and (GetGameTimer() - GUI.Time) > 2000 then
							Menukurwaextras()
							GUI.Time = GetGameTimer()
						end
					end
				end
			end
      	end
      	if PlayerData.job ~= nil and PlayerData.job.name == 'veterinary' then
			if(GetDistanceBetweenCoords(coords, -179.91, 411.95, 110.77, true) < 6) then
				if IsControlPressed(0, 168) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'veterinary_actions') then
					OpenVeterinaryMenu()
				end
			end
		end
	end
end)

function baskamenu()
	local elements = {
		{label = ('Gotowka'),     value = '1'},
		{label = ('Karta'),     value = '2'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'baska_actions', {
		title    = ('Baska'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
	    if data.current.value == '1' then
		    local medycy = exports['esx_scoreboard']:counter('ambulance')
			if medycy >= 2 then
				TriggerServerEvent('sandy_healer:baska', 'yes', 'gotowka')
				GUI.Time = GetGameTimer()
			else
				TriggerServerEvent('sandy_healer:baska', 'nope', 'gotowka')
				GUI.Time = GetGameTimer()
			end
			menu.close()
        elseif data.current.value == '2' then
			local medycy = exports['esx_scoreboard']:counter('ambulance')
			if medycy >= 2 then
				TriggerServerEvent('sandy_healer:baska', 'yes', 'karta')
				GUI.Time = GetGameTimer()
			else
				TriggerServerEvent('sandy_healer:baska', 'nope', 'karta')
				GUI.Time = GetGameTimer()
			end
			menu.close()
        end	

	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
  for k,v in pairs(Config.kurwapozycja) do
    for i = 1, #v.Pos, 1 do
    local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
    SetBlipSprite (blip, 402)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Naprawa Samochodu')
    EndTextCommandSetBlipName(blip)
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(1000)
	    local coords      = GetEntityCoords(GetPlayerPed(-1))
	    local isInMarker  = false
	    local currentZone = nil

	    for k,v in pairs(Config.kurwapozycja) do
	      for i = 1, #v.Pos, 1 do
	        if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 5) then
	          isInMarker  = true
	        end
	      end
	    end

	   	for i=1, #Config.lokacjemedyk, 1 do
	    	if(GetDistanceBetweenCoords(coords, Config.lokacjemedyk[i], true) < 5) then
	    		isInMarker  = true
	    	end
	    end

	    for i=1, #Config.extrasmenulocation, 1 do
	    	if(GetDistanceBetweenCoords(coords, Config.extrasmenulocation[i], true) < 5) then
	    		isInMarker  = true
	    	end
	    end

	   	if PlayerData.job ~= nil and PlayerData.job.name == 'veterinary' then
			if(GetDistanceBetweenCoords(coords, -179.91, 411.95, 110.77, true) < 7) then
				isInMarker  = true
			end
		end

	    if isInMarker and not HasAlreadyEnteredMarker then
	      HasAlreadyEnteredMarker = true
	    end
	    if not isInMarker and HasAlreadyEnteredMarker then
	      HasAlreadyEnteredMarker = false
		  ESX.UI.Menu.CloseAll()
		end
  end
end)

function kurwamenu()

	local elements = {
		{label = ('Naprawa silnika - $3500'),     value = '1'},
		{label = ('Pelna naprawa - $5000'),     value = '2'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sdasz_actions', {
		title    = ('Mechanik'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
	
	    if data.current.value == '1' then
	    	TriggerServerEvent('sandy_repair:naprawa1')
		menu.close()
        elseif data.current.value == '2' then
			TriggerServerEvent('sandy_repair:naprawa2')
		menu.close()
        end	

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('sandy_repair:fullrepair')
AddEventHandler('sandy_repair:fullrepair', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
	FreezeEntityPosition(vehicle, true)
	ESX.ShowNotification('Trwa naprawa poczekaj minute!')
	TaskLeaveVehicle(PlayerPedId(), vehicle, 256)
	Citizen.Wait(1000)
	SetVehicleDoorsLocked(vehicle, 2)
	SetVehicleDoorOpen(vehicle, 1, false)
	SetVehicleDoorOpen(vehicle, 2, false)
	SetVehicleDoorOpen(vehicle, 3, false)
	SetVehicleDoorOpen(vehicle, 4, false)
	SetVehicleDoorOpen(vehicle, 5, false)
	SetVehicleDoorOpen(vehicle, 6, false)
	SetVehicleDoorOpen(vehicle, 7, false)
	exports["taskbar"]:taskBar(60000,"Pelna Naprawa")
	SetVehicleDoorsLocked(vehicle, 1)
	SetVehicleEngineHealth(vehicle, 1000.0)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleBodyHealth(vehicle, 1000.0)
	SetVehicleFixed(vehicle)
	SetVehicleEngineOn( vehicle, true, true )
	SetVehicleUndriveable(vehicle, false)
	SetVehicleDoorShut(vehicle, 4, false)
	FreezeEntityPosition(vehicle, false)
	ESX.ShowNotification('Pojazd naprawiony!')
end)

RegisterNetEvent('sandy_repair:enginerepair')
AddEventHandler('sandy_repair:enginerepair', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
	FreezeEntityPosition(vehicle, true)
	SetVehicleDoorOpen(vehicle, 4, true)
	ESX.ShowNotification('Trwa naprawa poczekaj minute!')
	TaskLeaveVehicle(PlayerPedId(), vehicle, 256)
	TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 1, 'wrrrttttkurwa', 0.1)
	Citizen.Wait(1000)
	SetVehicleDoorsLocked(vehicle, 2)
	SetVehicleDoorOpen(vehicle, 4, false)
	exports["taskbar"]:taskBar(60000,"Naprawa silnika")
	SetVehicleDoorsLocked(vehicle, 1)
	SetVehicleEngineHealth(vehicle, 1000.0)
	SetVehicleEngineOn( vehicle, true, true )
	SetVehicleUndriveable(vehicle, false)
	SetVehicleDoorShut(vehicle, 4, false)
	FreezeEntityPosition(vehicle, false)
	ESX.ShowNotification('Pojazd naprawiony!')
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

function Menukurwaextras()
    ESX.UI.Menu.CloseAll()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, true)
    GotVehicleExtras = false
      local elements = {}

      for ExtraID = 0, 20 do
        if DoesExtraExist(veh, ExtraID) then
          table.insert(elements, {label = 'Dodatek - '..ExtraID, value = ExtraID})
        end
      end

      ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'extras_actions_actions',
      {
        title    = 'Menu Dodatkow',
        align    = 'center',
        elements = elements

      }, function(data, menu)
      for ExtraID = 0, 20 do
        if data.current.value == ExtraID then
          if IsVehicleExtraTurnedOn(veh, ExtraID) then
            SetVehicleExtra(veh, ExtraID, 1)
          else
            SetVehicleExtra(veh, ExtraID, 0)
          end
        end
      end
      end, function(data, menu)
        menu.close()
      end)
end

RegisterNetEvent('sandy_healer:healingplayer')
AddEventHandler('sandy_healer:healingplayer', function()
	ESX.ShowNotification('Leczenie!')
	FreezeEntityPosition(GetPlayerPed(-1), true)
	exports["taskbar"]:taskBar(30000,"Leczenie...")
	TriggerServerEvent('sandy_healer:idkwhatever')
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	ESX.ShowNotification('Twoje leczenie zakończyło się ~g~pozytywnie~w~!')
end)

function OpenVeterinaryMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {
      	{label = 'Udziel pomocy', value = 'healplayer'}
    }

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'veterinary_actions',
    {
        title    = 'Veterinary Co.',
        align    = 'center',
        elements = elements

	}, function(data, menu)
		if data.current.value == 'healplayer' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 2.0 then
          		local closestPed = GetPlayerPed(GetPlayerServerId(closestPlayer))
          		local playerPed = PlayerPedId()
				exports["taskbar"]:taskBar(5000,"Udzielanie pomocy")
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				for i=1, 15 do
					Citizen.Wait(900)
					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end
          		TriggerServerEvent('sandy_healer:idkwhatever2', GetPlayerServerId(closestPlayer))
          	else
          		ESX.ShowNotification('Brak graczy w pobliżu!')
          	end
		end
    end, function(data, menu)
        menu.close()
    end)
end