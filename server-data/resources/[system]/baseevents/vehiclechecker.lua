local isInVehicle = false
local isEnteringVehicle = false
local currentVehicle = 0
local currentSeat = 0

RegisterNetEvent('baseevents:enteringVehicle')
RegisterNetEvent('baseevents:enteringAborted')
RegisterNetEvent('baseevents:enteredVehicle')
RegisterNetEvent('baseevents:leftVehicle')

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = PlayerPedId()

		if not isInVehicle and not IsPlayerDead(PlayerId()) and IsEntityVisible(ped) then
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not isEnteringVehicle then
				-- trying to enter a vehicle!
				local vehicle = GetVehiclePedIsTryingToEnter(ped)
				local seat = GetSeatPedIsTryingToEnter(ped)
				local netId = VehToNet(vehicle)
				Wait(50)
				isEnteringVehicle = true
				TriggerEvent('baseevents:enteringVehicle', vehicle, seat, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), netId)
			elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
				-- vehicle entering aborted
				TriggerServerEvent('baseevents:enteringAborted')
				isEnteringVehicle = false
			elseif IsPedInAnyVehicle(ped, false) then
				-- suddenly appeared in a vehicle, possible teleport
				isEnteringVehicle = false
				isInVehicle = true
				currentVehicle = GetVehiclePedIsUsing(ped)
				currentSeat = GetPedVehicleSeat(ped)
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				Wait(50)
				TriggerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
			end
		elseif isInVehicle then
			if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
				-- bye, vehicle
				local model = GetEntityModel(currentVehicle)
				local name = GetDisplayNameFromVehicleModel()
				local netId = VehToNet(currentVehicle)
				Wait(50)
				TriggerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)), netId)
				isInVehicle = false
				currentVehicle = 0
				currentSeat = 0
			end
		end
		Citizen.Wait(50)
	end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

RegisterNetEvent('baseevents:seatSwaped')
AddEventHandler('baseevents:seatSwaped', function(time)
	isInVehicle = false
end)


AddEventHandler('baseevents:enteredVehicle', function(veh, vehseat, vehname, vehID)
	if vehseat == -1 then
		NetworkRequestControlOfNetworkId(vehID)
		for i= 1,3 do
			if not NetworkHasControlOfNetworkId(vehID) then
				NetworkRequestControlOfNetworkId(vehID)
			end
		end
	end
end) 

AddEventHandler('baseevents:leftVehicle', function(veh, vehseat, vehname)
	if vehseat == -1 then
		Wait(500)
		SetVehicleDoorShut(veh, 0, false)
	elseif vehseat == 0 then
		Wait(500)
		SetVehicleDoorShut(veh, 1, false)
	elseif vehseat == 1 then
		Wait(500)
		SetVehicleDoorShut(veh, 2, false)
	elseif vehseat == 2 then
		Wait(500)
		SetVehicleDoorShut(veh, 3, false)
	end
end)