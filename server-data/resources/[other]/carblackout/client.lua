oldVehicle = nil
oldDamage = 0
injuredTime = 0

isBlackedOut = false
isInjured = false
dzwonCalled = false

RegisterNetEvent('sandy_dzwon:dzwon')
AddEventHandler('sandy_dzwon:dzwon', function(damage)
	isBlackedOut = true
	dzwonCalled = false
	Citizen.CreateThread(function()
		SendNUIMessage({
			transaction = 'play'
		})

		StartScreenEffect('DeathFailOut', 0, true)
		SetTimecycleModifier("hud_def_blur")

		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)
		StopScreenEffect('DeathFailOut')

		isInjured = false
		injuredTime = math.min(20, damage/4)
		injuredTime = math.floor(injuredTime)
		isBlackedOut = false
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local exists = DoesEntityExist(vehicle)

			local driver
			if exists then
				driver = GetPedInVehicleSeat(vehicle, -1)
			end

			if (exists and (not driver or driver == 0 or driver == playerPed)) or (not exists and DoesEntityExist(oldVehicle)) then
				local fall = true
				if exists then
					oldVehicle = vehicle
					fall = false
				end

				if not GetPlayerInvincible(PlayerId()) and not dzwonCalled then
					if IsCar(oldVehicle, true) then
						local currentDamage = GetVehicleEngineHealth(oldVehicle)
						if not isBlackedOut then
							local speed, vehicleClass = math.floor(GetEntitySpeed(oldVehicle) * 3.6 + 0.5), GetVehicleClass(oldVehicle)
							if (currentDamage < oldDamage and (oldDamage - currentDamage) >= 150) or (fall and speed > (vehicleClass == 8 and 5 or 30)) then
								local damage
								if not fall then
									damage = math.floor((oldDamage - currentDamage) / 20 + 0.5)
								else
									damage = math.floor(speed / 10 + 0.5)
								end

								local list = {}
								if oldVehicle == vehicle and driver == playerPed then
									local tmp = {}
									for _, player in ipairs(GetActivePlayers()) do
										tmp[GetPlayerPed(player)] = GetPlayerServerId(player)
									end

									for i = 0, GetVehicleNumberOfPassengers(oldVehicle) do
										local ped = GetPedInVehicleSeat(oldVehicle, i)
										if ped and ped ~= 0 then
											table.insert(list, tmp[ped])
										end
									end
								end

								dzwonCalled = true
								TriggerServerEvent('sandy_dzwon:dzwon', list, damage)
								TriggerServerEvent('sandy_dzwon:dzwon2', damage)
							end
						end

						if not fall then
							oldDamage = currentDamage
						end
					end
				end

				if fall then
					oldVehicle = nil
					oldDamage = 0
				end
			else
				oldDamage = 0
			end
		else
			oldDamage = 0
		end

		if isBlackedOut then
			DisableControlAction(0,71,true) -- veh forward
			DisableControlAction(0,72,true) -- veh backwards
			DisableControlAction(0,63,true) -- veh turn left
			DisableControlAction(0,64,true) -- veh turn right
			DisableControlAction(0,288,true) -- disable phone
			DisableControlAction(0,75,true) -- disable exit vehicle
		end

		if injuredTime > 0 and not isInjured then
			isInjured = true
			Citizen.CreateThread(function()
				ShakeGameplayCam("DRUNK_SHAKE", 5.0)
				repeat
					injuredTime = injuredTime - 1
					SetPedMovementClipset(playerPed, "move_m@injured", 1.0)
					SetTimecycleModifier("hud_def_blur")

					Citizen.Wait(1000)
				until injuredTime == 0
				ClearTimecycleModifier()
				StopGameplayCamShaking(true)

				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
				ResetPedMovementClipset(playerPed, 0.0)

				SendNUIMessage({
					transaction = 'fade',
					time = 3000
				})
				isInjured = false
			end)
		end
	end
end)

function IsCar(v, ignoreBikes)
	if ignoreBikes and IsThisModelABike(GetEntityModel(v)) then
		return false
	end

	local vc = GetVehicleClass(v)
	return (vc >= 0 and vc <= 12) or vc == 17 or vc == 18 or vc == 20
end

function IsAffected()
	return isBlackedOut or isInjured
end