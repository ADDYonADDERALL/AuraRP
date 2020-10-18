ESX = nil
local PlayerData = {}
local kurwafrozen = false
local sprzedanestackiryb = 0
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

local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0
local branie = false

local bait = "none"

local blip = AddBlipForCoord(Config.SellFish.x, Config.SellFish.y, Config.SellFish.z)
			SetBlipSprite (blip, 356)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, 17)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Sprzedaz ryb")
			EndTextCommandSetBlipName(blip)
					
for _, info in pairs(Config.MarkerZones) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, 455)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.8)
		SetBlipColour(info.blip, 20)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Wypozyczalnia lodek")
		EndTextCommandSetBlipName(info.blip)
	end
	
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
	        for k in pairs(Config.MarkerZones) do
	            DrawMarker(1, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 150, 150, 100, 0, 0, 0, 0)	
			end
			for k in pairs(Config.DeleterMarkerZones) do
	            DrawMarker(1, Config.DeleterMarkerZones[k].x, Config.DeleterMarkerZones[k].y, Config.DeleterMarkerZones[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 0, 150, 150, 100, 0, 0, 0, 0)	
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlPressed(0, 344) and PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'wedka_actions') then
        kurwawedkamenu()
       end
    end
end)

function kurwawedkamenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'wedka_actions',
    {
        title    = 'Rybak',
        align    = 'center',
        elements = {
      {label = 'Kotwica', value = 'startkotwica'},
      {label = 'Uzyj Wedki', value = 'startlowienie'},
        }
  }, function(data, menu)
  	if data.current.value == 'startkotwica' then
  		playerPed = GetPlayerPed(-1)
  		vehicle = GetVehiclePedIsIn(playerPed, true)
  		Citizen.Wait(1000)
  		checkCar(vehicle)
  		menu.close()
    elseif data.current.value == 'startlowienie' then
      TriggerServerEvent('fishing:fishingrod')
      menu.close()
    end
    end, function(data, menu)
        menu.close()
    end)
end

function checkCar(car)
	if car then
		playerPed = GetPlayerPed(-1)
		carModel = GetEntityModel(car)
		playercoords = GetEntityCoords(playerPed)
		if isCarWhitelisted(carModel) then
			if kurwafrozen then
				FreezeEntityPosition(car, false)
				kurwafrozen = false
				ESX.ShowNotification("~g~Lodz zakotwiczona")
  			else
  				FreezeEntityPosition(car, true)
  				kurwafrozen = true
  				ESX.ShowNotification("~g~Kotwica zaciagnieta")
  			end
		else
			ESX.ShowNotification("~r~Nie mozesz uzyc kotwicy na tym pojezdzie")
        end
	end
end

function isCarWhitelisted(model)
	allowedvehicles = {
		"Dinghy",
		"Dinghy2",
		"Dinghy3",
  		"Dinghy4",
  		"Jetmax",
  		"Marquis",
  		"Speeder",
  		"Speeder2",
  		"Squalo",
  		"Suntrap",
  		"Toro",
  		"Toro2",
  		"Tropic",
  		"Tropic2",
  		"Tug"
  	}
	for _, whitelistedCar in pairs(allowedvehicles) do
		if model == GetHashKey(whitelistedCar) then
			return true
		end
	end

	return false
end
			
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

local sprzedawanko = false

RegisterNetEvent('stopsprzedawanko')
AddEventHandler('stopsprzedawanko', function()
	sprzedawanko = false
	FreezeEntityPosition(GetPlayerPed(-1), false)
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		if fishing then
			playerPed = GetPlayerPed(-1)
			local pos = GetEntityCoords(playerPed)
			if IsControlJustReleased(0, Keys['E']) then
				 input = 1
			end
			if IsControlJustReleased(0, Keys['X']) then
				fishing = false
				ESX.ShowNotification("~r~Przestajesz łowic")
			end
			if IsControlJustReleased(0, Keys['TAB']) then
				fishing = false
				ESX.ShowNotification("~r~Przestajesz łowic")
			end
			if IsPedInAnyVehicle(playerPed) then
				fishing = false
				ESX.ShowNotification("~r~Przestajesz łowic")
			end
		
			if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or IsPedInAnyVehicle(playerPed) then
			else
				fishing = false
				ESX.ShowNotification("~r~Przestajesz łowic")
			end
			if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
				fishing = false
				ESX.ShowNotification("~r~Przestajesz łowic")
			end
			
			if pausetimer > 3 then
				input = 99
			end
			
			if pause and input ~= 0 then
				pause = false
				if input == correct then
					branie = false
					TriggerServerEvent('fishing:catch', bait)
				else
					branie = false
					ESX.ShowNotification("~r~Ryba uciekła")
				end
			end
		end

		local ped = PlayerPedId()
		local pedcoords = GetEntityCoords(ped, false)
		local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.SellFish.x, Config.SellFish.y, Config.SellFish.z)
		if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			if distance <= 3 then
				if sprzedawanko == false then
					DisplayHelpText('Nacisnij ~INPUT_PICKUP~ aby ~g~sprzedać rybki')
				end
				if IsControlJustPressed(0, Keys['E']) then
					if not IsPedInAnyVehicle(playerPed, false) then
						if sprzedawanko == false then
							sprzedawanko = true
							FreezeEntityPosition(GetPlayerPed(-1), true)
							TriggerServerEvent('fishing:startSelling', "fish")
							Citizen.Wait(1000)
						else
							ESX.ShowNotification('~r~Nie możesz sprzedawać w pojeździe')
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
		if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			DrawMarker(1, Config.SellFish.x, Config.SellFish.y, Config.SellFish.z , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 0, 70, 250, 30, false, true, 2, false, false, false, false)
			if branie == true then
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local kordyyy = {
					["x"] = pos.x,
					["y"] = pos.y,
					["z"] = pos.z+1.20
				}
				ESX.Game.Utils.DrawText3D(kordyyy, '🎣', 1.7)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local wait = math.random(Config.FishTime.a , Config.FishTime.b)
			Wait(wait)
				if fishing then
					pause = true
					branie = true
					correct = 1
					ESX.ShowNotification("Ryba ~g~złapała przynęte~w~, naciśnij ~y~E~w~, aby ją złowić!")
					input = 0
					pausetimer = 0
				end
	end
end)

RegisterNetEvent('fishing:message')
AddEventHandler('fishing:message', function(message)
	ESX.ShowNotification(message)
end)
RegisterNetEvent('fishing:break')
AddEventHandler('fishing:break', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('fishing:spawnPed')
AddEventHandler('fishing:spawnPed', function()
	
	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
		while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
			Citizen.Wait( 1 )
		end
	local pos = GetEntityCoords(GetPlayerPed(-1))
	
	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('fishing:setbait')
AddEventHandler('fishing:setbait', function(bool)
	bait = bool
	--print(bait)
end)

RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()	
	playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if IsPedInAnyVehicle(playerPed) then
		ESX.ShowNotification("~r~Nie możesz używać wędki w pojeździe")
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 then
			ESX.ShowNotification("~g~Zaczynasz łowić ryby!")
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			ESX.ShowNotification("~r~Musisz odpłynąć od brzegu!")
		end
	end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for k in pairs(Config.MarkerZones) do
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
            if distance <= 1.40 then
				DisplayHelpText('Naciśnij ~INPUT_PICKUP~ aby ~g~wypożyczyć lodke')
				if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
					OpenBoatsMenu(Config.MarkerZones[k].xs, Config.MarkerZones[k].ys, Config.MarkerZones[k].zs)
				end 
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for k in pairs(Config.DeleterMarkerZones) do
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.DeleterMarkerZones[k].x, Config.DeleterMarkerZones[k].y, Config.DeleterMarkerZones[k].z)
            if distance <= 5 then
				DisplayHelpText('Naciśnij ~INPUT_PICKUP~ aby ~r~oddać łódke')
				if IsControlJustPressed(0, Keys['E']) then 
					if IsPedInAnyBoat(ped) then
						TriggerEvent('esx:deleteVehicle')
						ESX.ShowNotification('~g~Oddałeś łódkę! Order Uśmiechu za bycie przykładnym obywatelem!')
					else
						ESX.ShowNotification('~r~Nie jesteś na łódce!')
					end
				end
            end
        end
    end
end)

function OpenBoatsMenu(x, y , z)
	local ped = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local elements = {}
	
	table.insert(elements, {label = '<span style="color:green;">Dinghy</span> <span style="color:red;">1000$</span>', value = 'boat'})
	table.insert(elements, {label = '<span style="color:green;">Suntrap</span> <span style="color:red;">2000$</span>', value = 'boat6'}) 
	table.insert(elements, {label = '<span style="color:green;">Jetmax</span> <span style="color:red;">800$</span>', value = 'boat5'}) 
	table.insert(elements, {label = '<span style="color:green;">Marquis</span> <span style="color:red;">2500$</span>', value = 'boat3'})
	table.insert(elements, {label = '<span style="color:green;">Toro</span> <span style="color:red;">5000$</span>', value = 'boat2'})  
		
	--If user has police job they will be able to get free Police Predator boat
	if PlayerData.job.name == "police" then
		table.insert(elements, {label = '<span style="color:green;">Police Predator</span>', value = 'police'})
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = 'Wypozyczalnia lodek',
		align    = 'center',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'boat' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 1000) 
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$1000')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "dinghy4")
	end
	
	if data.current.value == 'boat2' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 5000) 
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$5000')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "TORO")
	end
	
	if data.current.value == 'boat3' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 2500) 
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$2500')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "MARQUIS")
	end

	if data.current.value == 'boat4' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 7500) 
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$7500')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "tug")
	end
	
	if data.current.value == 'boat5' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 800) 
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$800')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "jetmax")
	end
	
	if data.current.value == 'boat6' then
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent("fishing:lowmoney", 2000)
		ESX.ShowNotification('~y~Wypozyczyles lodke za ~g~$2000')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "suntrap")
	end
	
	
	if data.current.value == 'police' then
		ESX.UI.Menu.CloseAll()

		TriggerEvent("chatMessage", 'Pobrales lodke')
		SetPedCoordsKeepVehicle(ped, x, y , z)
		TriggerEvent('esx:spawnVehicle', "predator")
	end
	ESX.UI.Menu.CloseAll()
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end

RegisterNetEvent('sandyrp:stackiryb')
AddEventHandler('sandyrp:stackiryb', function(liczba)	
	sprzedanestackiryb = sprzedanestackiryb + liczba
	--print(sprzedanestackiryb)
	if sprzedanestackiryb == 2 then
		TriggerServerEvent('sandyrp:savexprybak')
		sprzedanestackiryb = 0
	end
end)