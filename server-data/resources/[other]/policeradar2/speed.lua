local tempInfo = "~y~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić"
local veh,a, b, c, d, e, f, g, h, i, j, fmodel, fvspeed, fplate, bmodel, bvspeed, bplate
local radar =
{
	shown = false,
	freeze = false,
	info = tempInfo,
	info2 = tempInfo,
	frontPlate = "",
	frontModel = "",
	backPlate = "",
	backModel = "",
	minSpeed = 5.0,
	maxSpeed = 75.0,
}

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.02 + h)
end

Citizen.CreateThread(function()
	while true do
		if radar.shown then
			local pPed = GetPlayerPed(-1)
			veh = GetVehiclePedIsIn(pPed, false)
		end
		Citizen.Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if radar.shown then
			local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
			local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
			local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
			a, b, c, d, e = GetShapeTestResult(frontcar)
			if IsEntityAVehicle(e) then
				fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
				fvspeed = GetEntitySpeed(e)*3.6
				fplate = GetVehicleNumberPlateText(e)
			end
			local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
			local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
			f, g, h, i, j  = GetShapeTestResult(rearcar)
			if IsEntityAVehicle(j) then
				bmodel = GetDisplayNameFromVehicleModel(GetEntityModel(j))
				bvspeed = GetEntitySpeed(j)*3.6
				bplate = GetVehicleNumberPlateText(j)
			end
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(5)
		if IsControlJustPressed(1, 128) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
			if radar.shown then
				radar.shown = false
			elseif not radar.shown then
				radar.shown = true
			end
            Citizen.Wait(200)
		end
		if IsControlJustPressed(1, 127) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
			if radar.freeze then 
				radar.freeze = false
			else 
				radar.freeze = true
			end
		end
		if radar.freeze then
			DrawAdvancedText(0.591, 0.833, 0.005, 0.0028, 0.40, "~y~Zatrzymano radar", 0, 191, 255, 255, 6, 0)
		end
		if radar.shown then
			if radar.freeze == false then
				if IsEntityAVehicle(e) then
					radar.frontPlate = fplate
					radar.frontModel = fmodel
					radar.info = string.format("~y~Rejestracja: ~w~%s  ~y~Pojazd: ~w~%s  ~y~Prędkość: ~w~%s km/h", fplate, fmodel, math.ceil(fvspeed))
				end
				if IsEntityAVehicle(j) then
					radar.backPlate = bplate
					radar.backModel = bmodel
					radar.info2 = string.format("~y~Rejestracja: ~w~%s  ~y~Pojazd: ~w~%s  ~y~Prędkość: ~w~%s km/h", bplate, bmodel, math.ceil(bvspeed))				
				end
			end
			if IsControlJustPressed(1, 124) then
				TriggerServerEvent('radar:checkVehicle', radar.frontPlate, radar.frontModel)
			end
			if IsControlJustPressed(1, 125) then
				TriggerServerEvent('radar:checkVehicle', radar.backPlate, radar.backModel)
			end	
			DrawAdvancedText(0.602, 0.903, 0.005, 0.0028, 0.4, "RADAR - Front ([Num4] aby sprawdzić bazę)", 0, 153, 0, 255, 6, 0)
			DrawAdvancedText(0.602, 0.953, 0.005, 0.0028, 0.4, "RADAR - Tył ([Num6] aby sprawdzić bazę)", 0, 153, 0, 255, 6, 0)
			DrawAdvancedText(0.602, 0.928, 0.005, 0.0028, 0.4, radar.info, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.602, 0.979, 0.005, 0.0028, 0.4, radar.info2, 255, 255, 255, 255, 6, 0)
		end
		if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
			radar.shown = false
			radar.freeze = false
		end
	end
end)

