local PlayerData = {}
local GUI = {}
local startjob = {x = 1133.13, y = -990.90, z = 46.11}
local vehiclegarage = {x = 1119.20, y = -993.82, z = 45.96}
local currenttarget = {x = 0, y = 0, z = 0}
local destination = {}
local allowmarker = false
local cantakevehicle = false
local onjob = false
local amountdone = 0

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

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
    	local player = GetEntityCoords(PlayerPedId())
    	if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'mecano' and PlayerData.job.name ~= 'ambulance' then
		   	if (GetDistanceBetweenCoords(player, startjob.x, startjob.y, startjob.z, true) < 10) then
		    	DrawMarker(1, startjob.x, startjob.y, startjob.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if (GetDistanceBetweenCoords(player,  startjob.x, startjob.y, startjob.z, true) < 2.0) then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby rozpoczac ~y~pranie')
			    	if IsControlPressed(1, 51) and (GetGameTimer() - GUI.Time) > 500 then
			    		if not onjob then
			    			onjob = true
			    			cantakevehicle = true
			    			ESX.ShowNotification('Rozpoczynasz pranie; ~y~wez samochod z garazu za zapleczem!')
			    			dothejob()
			    			allowmarker = true
			    		else
			    			onjob = false
			    			cantakevehicle = false
			    			ESX.ShowNotification('Konczysz pranie')
			    			allowmarker = false
			    		end
			    		GUI.Time = GetGameTimer()
			    	end
		    	end
			end

			if cantakevehicle then
				if (GetDistanceBetweenCoords(player, vehiclegarage.x, vehiclegarage.y, vehiclegarage.z, true) < 10) then
			    	DrawMarker(1, vehiclegarage.x, vehiclegarage.y, vehiclegarage.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(player,  vehiclegarage.x, vehiclegarage.y, vehiclegarage.z, true) < 2.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby ~g~wciagnac~w~/~r~schowac~w~ vana')
				    	if IsControlPressed(1, 51) and (GetGameTimer() - GUI.Time) > 500 then
				    		GUI.Time = GetGameTimer()
				    		getputvehicle()
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
    	if onjob then
    	local player = GetEntityCoords(PlayerPedId())
	    	if allowmarker then
				if (GetDistanceBetweenCoords(player, currenttarget.x, currenttarget.y, currenttarget.z, true) < 10) then
				   	DrawMarker(1, currenttarget.x, currenttarget.y, currenttarget.z, 0, 0, 0, 0, 0, 0, 3, 3, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(player,  currenttarget.x, currenttarget.y, currenttarget.z, true) < 2.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby ~g~wyprac~w~ pieniadze')
						if IsControlPressed(1, 51) and (GetGameTimer() - GUI.Time) > 10000 then
							GUI.Time = GetGameTimer()
							if IsInAuthorizedVehicle() then
								amountdone = amountdone + 1
								TriggerServerEvent('sandy_laundry:getpay', amountdone)
							else
								ESX.ShowNotification('Zły pojazd!')
							end
						end
				    end
				end
			end
		end
    end
end)

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
	if vehModel == GetHashKey('burrito3') then
		return true
	end
	return false
end

function getputvehicle()
	if IsPedInAnyVehicle(PlayerPedId(),  false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local hash      = GetEntityModel(vehicle)
		if DoesEntityExist(vehicle) then
			if hash == GetHashKey('burrito3') then
				DeleteVehicle(vehicle)
				ESX.ShowNotification('Oddano auta do garażu')
			else
				ESX.ShowNotification('Zły pojazd!')
			end	
		end
	else
		local veh = "burrito3"
		vehiclehash = GetHashKey(veh)
		RequestModel(vehiclehash)
		local spawned = CreateVehicle(vehiclehash, vehiclegarage.x, vehiclegarage.y, vehiclegarage.z, 4.82, 1, 0)
		SetPedIntoVehicle(PlayerPedId(), spawned, -1)
		local liczba = math.random(100,999)
		SetVehicleNumberPlateText(spawned,'LAU'.. liczba)
		ESX.ShowNotification('Pobrano auto z garażu')
	end
end

function rolltarget()
	local rdm = math.random(1,25)
	if rdm == 1 then
		currenttarget = {x = 3619.53, y = 3749.61, z = 28.60}
	elseif rdm == 2 then
		currenttarget = {x = 2450.47, y = -384.55, z = 92.99}
	elseif rdm == 3 then
		currenttarget = {x = 1216.28, y = -2945.53, z = 3.90}
	elseif rdm == 4 then
		currenttarget = {x = -1064.74, y = -553.42, z = 32.5}
	elseif rdm == 5 then
		currenttarget = {x = 809.53, y = -2024.22, z = 28.00}
	elseif rdm == 6 then
		currenttarget = {x = 121.06, y = -1488.49, z = 28.00}
	elseif rdm == 7 then
		currenttarget = {x = 451.48, y = -899.09, z = 27.50}
	elseif rdm == 8 then
		currenttarget = {x = -1129.44, y = -1607.24, z = 3.90}
	elseif rdm == 9 then
		currenttarget = {x = -1064.74, y = -553.42, z = 32.50}
	elseif rdm == 10 then
		currenttarget = {x = 809.53, y = -2024.22, z = 28.0}
	elseif rdm == 11 then
		currenttarget = {x = 63.26, y = -227.99, z = 50.0}
	elseif rdm == 12 then
		currenttarget = {x = -1338.69, y = -402.41, z = 34.9}
	elseif rdm == 13 then
		currenttarget = {x = 548.60, y = -206.34, z = 52.5}
	elseif rdm == 14 then
		currenttarget = {x = -1141.91, y = -2699.93, z = 13.0}
	elseif rdm == 15 then
		currenttarget = {x = -640.03, y = -1224.95, z = 10.5}
	elseif rdm == 16 then
		currenttarget = {x = 1999.54, y = 3055.06, z = 45.5}
	elseif rdm == 17 then
		currenttarget = {x = 555.47, y = 2733.95, z = 41.0}
	elseif rdm == 18 then
		currenttarget = {x =1685.15, y = 3752.08, z = 33.0}
	elseif rdm == 19 then
		currenttarget = {x = 182.70, y = 2793.98, z = 44.5}
	elseif rdm == 20 then
		currenttarget = {x = 2710.67, y = 4335.31, z = 44.8}
	elseif rdm == 21 then
		currenttarget = {x = 1930.65, y = 4637.58, z = 39.3}
	elseif rdm == 22 then
		currenttarget = {x = -448.24, y = 5993.86, z = 30.3}
	elseif rdm == 23 then
		currenttarget = {x = 107.91, y = 6605.97, z = 30.8}
	elseif rdm == 24 then
		currenttarget = {x = 916.69, y = 3568.77, z = 32.7}
	elseif rdm == 25 then
		currenttarget = {x = -128.67, y = 6344.54, z = 31.0}
	end
end

function setdestination()
	RemoveBlip(destination['cel'])
	destination['cel'] = AddBlipForCoord(currenttarget.x, currenttarget.y, currenttarget.z)
	SetBlipRoute(destination['cel'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Cel')
	EndTextCommandSetBlipName(destination['cel'])
end

function dothejob()
	rolltarget()
	Wait(1000)
	setdestination()
	Wait(1000)
end

function removedestination()
	RemoveBlip(destination['cel']) 
end

RegisterNetEvent('sandy_laundry:getnextdestination')
AddEventHandler('sandy_laundry:getnextdestination', function(takczychujwie)
	dothejob()
end)

RegisterNetEvent('sandy_laundry:removedestination')
AddEventHandler('sandy_laundry:removedestination', function(takczychujwie)
	removedestination()
	currenttarget = {x = 0, y = 0, z = 0}
	onjob = false
	amountdone = 0
	cantakevehicle = false
end)