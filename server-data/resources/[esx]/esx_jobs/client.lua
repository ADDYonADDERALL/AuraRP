local setjoblocation = { x = -265.63, y = -962.84, z = 31.22-0.05 }

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
   		local player = GetEntityCoords(PlayerPedId())
   		if (GetDistanceBetweenCoords(player, setjoblocation.x, setjoblocation.y, setjoblocation.z, true) < 30) then
		    DrawMarker(1, setjoblocation.x, setjoblocation.y, setjoblocation.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 100, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
			if (GetDistanceBetweenCoords(player,  setjoblocation.x, setjoblocation.y, setjoblocation.z, true) < 2.0) then
				ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~, aby wybrac ~g~prace')
			    if IsControlPressed(1, 51) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'setjob_menu') then
			    	setjobmenu()
			    end
		    end
		end
	end
end)

function setjobmenu()

	local elements = {
		{label = ('Taxi'),     value = 'taxi'},
		{label = ('Kurier'),     value = 'deliverer'},
		{label = ('Rybak'),     value = 'fisherman'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'setjob_menu', {
		title    = ('Wybierz Prace'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
	
	    TriggerServerEvent('esxjobs:setJob', data.current.value)

	end, function(data, menu)
		menu.close()
	end)
end


Citizen.CreateThread(function()
  while true do
    Wait(10)
	    local coords      = GetEntityCoords(GetPlayerPed(-1))
	    local isInMarker  = false
	    local currentZone = nil

	    if(GetDistanceBetweenCoords(coords, setjoblocation.x, setjoblocation.y, setjoblocation.z, true) < 5) then
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
end)