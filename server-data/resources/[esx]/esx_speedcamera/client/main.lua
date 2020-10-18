ESX = nil
local hasBeenCaught = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local SpeedcameraZone1 = {
	vector3(223.79113769531, 194.94471740723, 105.57413482666), --(bank główny)
	vector3(184.35504150391, 198.84757995605, 105.58553314209), --(bank główny)
	vector3(196.47486877441, 172.8056640625, 105.58787536621), --(bank główny)
	vector3(-350.16259765625, -383.82571411133, 30.569591522217), --(droga do szpitala)
	vector3(-349.00662231445, -400.07852172852, 30.437595367432), --(droga do szpitala)
	vector3(180.4606628418, -818.26190185547, 31.167533874512), --(główny)
	vector3(163.14512634277, -821.28839111328, 31.175849914551), --(główny)
	vector3(114.06287384033, -999.59222412109, 29.394920349121), --(bank flecca)
	vector3(98.12003326416, -999.67852783203, 29.40470123291), --(bank flecca)
	vector3(426.27783203125, -539.19470214844, 28.744354248047), --(wjazd do miasta)
	vector3(575.96166992188, 6548.2182617188, 27.97190284729), --(wjazd do paleto)
	vector3(-87.533416748047, 6298.787109375, 31.339553833008), --(paleto)
	vector3(-102.21141052246, 6267.28515625, 31.324506759644), --(paleto)
	vector3(-427.771484375, 5930.8271484375, 32.338779449463), --(wjazd do paleto)
	vector3(-875.20196533203, -664.74017333984, 27.857196807861), --(near vespucci)
	vector3(-842.54205322266, -650.57666015625, 27.87463760376), --(near vespucci)
	vector3(1183.7663574219, -515.33532714844, 65.076080322266), --(mirror park)
	vector3(1170.4714355469, -503.65893554688, 65.232421875), --(mirror park)
	vector3(683.54809570312, -11.373346328735, 84.190872192383), --(vinewood)
	vector3(696.75695800781, 25.005107879639, 84.191764831543), --(vinewood)
}

local SpeedcameraZone2 = {
	vector3(2814.3930664062, 4393.8095703125, 49.300769805908), --( skrzyżowanie autostrada)
	vector3(2769.4870605469, 4424.091796875, 48.589454650879), --( skrzyżowanie autostrada)
	vector3(-2162.9514160156, -359.22875976562, 13.151779174805), --(wjazd do miasta)
}

local SpeedcameraZone3 = {
	vector3(1409.9677734375, 693.04943847656, 78.809951782227), --(autostrada w stronę więzienia)
	vector3(1706.9674072266, 1549.5325927734, 84.718635559082), --(autostrada w stronę więzienia)
	vector3(-1780.8919677734, 4744.6938476562, 57.046672821045), --(most)
	vector3(-2021.2066650391, 4490.8637695312, 57.024719238281), --(most)
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        for k in pairs(SpeedcameraZone1) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, SpeedcameraZone1[k].x, SpeedcameraZone1[k].y, SpeedcameraZone1[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 80.0 -- THIS IS THE MAX SPEED IN KM/H
				local vehicleProps = ESX.Game.GetVehicleProperties(playerCar)
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then						
								TriggerServerEvent('esx_speedcamera:openGUI')
								TriggerServerEvent("SANDY_InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
								Citizen.Wait(200)
								TriggerServerEvent('esx_speedcamera:closeGUI')
								ESX.TriggerServerCallback('esx_speedcamera:isVehicleOwned', function(owner)
									if owner then
										TriggerServerEvent('esx_speedcamera:PayBill', owner, vehicleProps.plate, SpeedKM, 'Fotoradar (80KM/H)')
									end
								end, vehicleProps.plate)	
								hasBeenCaught = true
								Citizen.Wait(5000)
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		for k in pairs(SpeedcameraZone2) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, SpeedcameraZone2[k].x, SpeedcameraZone2[k].y, SpeedcameraZone2[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 160.0 -- THIS IS THE MAX SPEED IN KM/H
				local vehicleProps = ESX.Game.GetVehicleProperties(playerCar)
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								TriggerServerEvent('esx_speedcamera:openGUI')
								TriggerServerEvent("SANDY_InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
								Citizen.Wait(200)
								TriggerServerEvent('esx_speedcamera:closeGUI')
								ESX.TriggerServerCallback('esx_speedcamera:isVehicleOwned', function(owner)
									if owner then
										TriggerServerEvent('esx_speedcamera:PayBill', owner, vehicleProps.plate, SpeedKM, 'Fotoradar (160KM/H)')
									end
								end, vehicleProps.plate)	
								hasBeenCaught = true
								Citizen.Wait(5000)
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		for k in pairs(SpeedcameraZone3) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, SpeedcameraZone3[k].x, SpeedcameraZone3[k].y, SpeedcameraZone3[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 200.0 -- THIS IS THE MAX SPEED IN KM/H
				local vehicleProps = ESX.Game.GetVehicleProperties(playerCar)
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then					
								TriggerServerEvent('esx_speedcamera:openGUI')
								TriggerServerEvent("SANDY_InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
								Citizen.Wait(200)
								TriggerServerEvent('esx_speedcamera:closeGUI')
								ESX.TriggerServerCallback('esx_speedcamera:isVehicleOwned', function(owner)
									if owner then
										TriggerServerEvent('esx_speedcamera:PayBill', owner, vehicleProps.plate, SpeedKM, 'Fotoradar (200KM/H)')
									end
								end, vehicleProps.plate)	
								hasBeenCaught = true
								Citizen.Wait(5000)
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

RegisterNetEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)
