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

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

vehicleWashStation = {
	{26.5906,   -1392.0261, 28.3634},
	{167.1034,  -1719.4704, 28.2916},
	{-74.5693,  6427.8715,  30.4400},
	{-699.6325, -932.7043,  18.0139},
	{1361.71, 3591.81,  34.02},
	{2524.51, 4195.47,  39.05},
	{-326.91, -144.73, 38.34},
	{1182.62, 2637.64, 37.07},
	{103.28, 6623.14, 31.1},
}

-- Add blips
--[[Citizen.CreateThread(function()
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100)
		SetBlipScale(stationBlip, 0.7)
		SetBlipAsShortRange(stationBlip, true)
	end
end)]]--

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(2)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
			for i = 1, #vehicleWashStation do
				garageCoords = vehicleWashStation[i]
				--DrawMarker(27, garageCoords[1], garageCoords[2], garageCoords[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 255, 255, 55, 0, 0, 2, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords[1], garageCoords[2], garageCoords[3], true) < 15 then

        local SellPos = {
            ["x"] = garageCoords[1],
            ["y"] = garageCoords[2],
            ["z"] = garageCoords[3] + 1
          }
		ESX.Game.Utils.DrawText3D(SellPos, "NACIŚNIJ [~g~E~s~] ABY UMYĆ SAMOCHÓD~n~KWOTA: $~g~50", 0.7, 1.5, "~g~MYJNIA", 0.85)

        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords[1], garageCoords[2], garageCoords[3], true) < 5 then
					if IsControlJustPressed(1, Keys['E']) then
						WashVehicle()
					end
				end
      end
			end
		else
			-- enter 'sleep mode'
			Citizen.Wait(500)
		end
	end
end)

function WashVehicle()
	ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
		if canAfford then
			SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(),  false), 0.0000000001)
			SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)

			if Config.EnablePrice then
				ESX.ShowNotification(_U('wash_successful_paid', Config.Price))
			else
				ESX.ShowNotification(_U('wash_successful'))
			end
			Citizen.Wait(5000)
		else
			ESX.ShowNotification(_U('wash_failed'))
			Citizen.Wait(5000)
		end
	end)
end
