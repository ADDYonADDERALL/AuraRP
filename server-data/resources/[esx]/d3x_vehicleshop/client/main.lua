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

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local actionDisplayed         = false
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}
local CurrentVehicleData      = nil
local testdrive_timer 		  = 40

ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.TriggerServerCallback('d3x_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
	Citizen.Wait(1000)
	ESX.TriggerServerCallback('d3x_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)
	
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('d3x_vehicleshop:sendCategories')
AddEventHandler('d3x_vehicleshop:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('d3x_vehicleshop:sendVehicles')
AddEventHandler('d3x_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function StartShopRestriction()

	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(0)
	
			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)

end

RegisterNUICallback('TestDrive', function(data, cb) 
	SetNuiFocus(false, false)
	local model = data.model
	IsInShopMenu = true
	RozpocznijWynajem(model)
end)

local czasWynajmu = 60    ---<<czas jazdy próbnej w sekundach
local cenaJazdy = 5000 --<<< Cene za jazde testową musisz zmienić tutaj i w server.lau

function Notyfikacja(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("")
	Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_CARSITE", "CHAR_CARSITE", true, 1, "", text, 1)
	DrawNotification_4(false, true)
end

function RozpocznijWynajem(pojazd)
	czasWynajmu = 60
	PlaySoundFrontend(-1, "Player_Enter_Line", "GTAO_FM_Cross_The_Line_Soundset", 0)
	ESX.UI.Menu.CloseAll()
	DoScreenFadeOut(300)
	Citizen.Wait(500)
	local auto = pojazd
	RequestModel(GetHashKey(auto))
	while not HasModelLoaded(GetHashKey(auto)) do
	Citizen.Wait(0)
	end
	TriggerServerEvent("sandyjazda:sprawdzforse")
	Notyfikacja('Pobrano ~g~'..cenaJazdy..'$ ~w~za jazde testową.')
	wypozyczone = CreateVehicle(GetHashKey(auto), -773.004, -234.093, 37.079, 201.03,  996.786, 25.1887, false, false)
	SetEntityAsMissionEntity(wypozyczone)
    SetVehicleLivery(wypozyczone, 0)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), wypozyczone, - 1)
    SetVehicleNumberPlateText(wypozyczone, "JAZDA")
    SetVehicleColours(wypozyczone, 111,111)
	SetPedCanBeKnockedOffVehicle(GetPlayerPed(-1),1)
	SetPedCanRagdoll(GetPlayerPed(-1),false)
	SetEntityVisible(GetPlayerPed(-1), true)
	Citizen.Wait(500)
	DoScreenFadeIn(300)
	Notyfikacja('Po upływie czasu wrócisz do Salonu.')
	local start = true
	SetVehicleDoorsLocked(wypozyczone, 2)
	
	while start do
		Citizen.Wait(0)
		DisableControlAction(0, 70, true)
		DisableControlAction(0, 69, true)
		DisableControlAction(0, 38, true)
		DisableControlAction(0, 75,  true) -- Disable exit vehicle
		DisableControlAction(27, 75, true) -- Disable exit vehicle
		local pedCoords = GetEntityCoords(GetPlayerPed(-1))
		czasWynajmu = czasWynajmu -0.015
		DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z+1.3, "~y~Pozostało: ~r~"..math.floor(czasWynajmu)..'~y~ sekund.')
			if czasWynajmu <= 0 then
			start = false
			end
	end
	SetPedCanRagdoll(GetPlayerPed(-1),true)
	SetPedCanBeKnockedOffVehicle(GetPlayerPed(-1),0)
	PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
	Notyfikacja('Jazda testowa dobiegła końca, Wrócisz do salonu.')
	DoScreenFadeOut(300)
	Citizen.Wait(500)
	DeleteEntity(wypozyczone)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	SetEntityCoordsNoOffset(GetPlayerPed(-1), -796.00, -220.164, 37.07, 0, 0, 1)
	Citizen.Wait(500)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	DoScreenFadeIn(300)
	start = false
	IsInShopMenu = false
	
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
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

RegisterNUICallback('BuyVehicle', function(data, cb)
    SetNuiFocus(false, false)

    local model = data.model
	local playerPed = PlayerPedId()
	IsInShopMenu = false

    ESX.TriggerServerCallback('d3x_vehicleshop:buyVehicle', function(hasEnoughMoney)

		if hasEnoughMoney then

			ESX.Game.SpawnVehicle(model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function (vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

				local newPlate     = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				local kurwamodel	= GetEntityModel(vehicle)
				local typauta      = GetDisplayNameFromVehicleModel(kurwamodel)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)

				if Config.EnableOwnedVehicles then
					TriggerServerEvent('d3x_vehicleshop:setVehicleOwned', vehicleProps, kurwamodel, typauta)
				end

				ESX.ShowNotification(_U('vehicle_purchased'))
			end)

		else
			ESX.ShowNotification(_U('not_enough_money'))
		end

	end, model)
end)

RegisterNUICallback('CloseMenu', function(data, cb)
    SetNuiFocus(false, false)
	IsInShopMenu = false
	cb(false)
end)


RegisterCommand('closeshop', function() 
	SetNuiFocus(false, false)
    IsInShopMenu = false
end)

function OpenShopMenu()

	local vehicle = {}

	if not IsInShopMenu then
		IsInShopMenu = true
		SetNuiFocus(true, true)
		
		SendNUIMessage({
            show = true,
			cars = Vehicles,
			categories = Categories
        })
	end

end


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

AddEventHandler('d3x_vehicleshop:hasEnteredMarker', function (zone)
	if zone == 'ShopEntering' then

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
		actionDisplayed = true
	end
end)

AddEventHandler('d3x_vehicleshop:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()

			local playerPed = PlayerPedId()
			
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function ()
	local blip = AddBlipForCoord(Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

	SetBlipSprite (blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Luxury Cars")
	EndTextCommandSetBlipName(blip)
end)

function Draw3DText(x,y,z,text,scale)
	local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	local pX,pY,pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len( text )) / 700
	DrawRect(_x, _y + 0.0150, 0.06 +factor, 0.03, 0, 0, 0, 200)
end

Citizen.CreateThread(function() 
	
	while true do
		Citizen.Wait(0)
		local coords      = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do
			if v.Type == 36 then
				if Vdist(coords.x,coords.y,coords.z, v.Pos.x,v.Pos.y,v.Pos.z) <= 8 then
					Draw3DText(v.Pos.x, v.Pos.y, v.Pos.z+1, _U('watch_catalog'),0.4)
				end
			end
		end
		
	end
	
end)


-- Enter / Exit marker events
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 3.5) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker  then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('d3x_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('d3x_vehicleshop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else

			-- ESX.ShowHelpNotification('Pressione ~INPUT_CONTEXT~ para ver o catálogo!')
			
			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)
