local GUI = {}
ESX                           = nil
GUI.Time = 0
local hasAlreadyEnteredMarker 	 = false

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end) 


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyCoords = GetEntityCoords(PlayerPedId())
		for i=1, #Config.Teleporters, 1 do
			if (GetDistanceBetweenCoords(plyCoords,  Config.Teleporters[i], true) < 2.0) then
				DrawText3D(Config.Teleporters[i].x, Config.Teleporters[i].y, Config.Teleporters[i].z+1, "~w~NACIŚNIJ [~o~H~w~] ABY UZYC WINDY")
				if IsControlPressed(0, 74) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'winda_actions') and (GetGameTimer() - GUI.Time) > 2000 then
					Openkurwajebanawinda()
				end
			end
		end
    end
end)

function Openkurwajebanawinda()
	local elements = {
		{label = ('Wejscie 1'), value = '1'},
		{label = ('Wejscie 2'), value = '2'},
		{label = ('Wejscie 3'), value = '3'},
		{label = ('Lobby'), value = '4'},
		{label = ('Parking'), value = '5'},
		{label = ('SOR'), value = '6'},
		{label = ('Operacyjne'), value = '7'},
		{label = ('Prywatne'), value = '8'},
		{label = ('Sale 1'), value = '9'},
		{label = ('Sale 2'), value = '10'},
		{label = ('Sale 3'), value = '11'},
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'winda_actions', {
		title    = ('Winda'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		DoScreenFadeOut(100)
		Citizen.Wait(750)
		if data.current.value == '1' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[1])
		elseif data.current.value == '2' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[2])	
		elseif data.current.value == '3' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[3])
		elseif data.current.value == '4' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[4])
		elseif data.current.value == '5' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[5])
		elseif data.current.value == '6' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[6])
		elseif data.current.value == '7' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[7])
		elseif data.current.value == '8' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[8])
		elseif data.current.value == '9' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[9])
		elseif data.current.value == '10' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[10])
		elseif data.current.value == '11' then
			ESX.Game.Teleport(PlayerPedId(), Config.Teleporters[11])
		end
		Citizen.Wait(750)
		DoScreenFadeIn(100)
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local coords      = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker  = false
        
        for i=1, #Config.Teleporters, 1 do
	    	if(GetDistanceBetweenCoords(coords, Config.Teleporters[i], true) < 3) then
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