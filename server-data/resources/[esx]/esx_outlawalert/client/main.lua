ESX = nil

local timing, isPlayerWhitelisted = math.ceil(Config.Timer * 60000), false
local streetName, playerGender
local time = 1
local timer = 0
local block = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerEvent('skinchanger:getSkin', function(skin)
		playerGender = skin.sex
	end)

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		if NetworkIsSessionStarted() then
			DecorRegister('isOutlaw', 3)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)

			return
		end
	end
end)

-- Gets the player's current street.
-- Aaalso get the current player gender
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)

		local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end


RegisterNetEvent('esx_outlawalert:outlawNotify')
AddEventHandler('esx_outlawalert:outlawNotify', function(type, data, length)
	if isPlayerWhitelisted then
		SendNUIMessage({action = 'display', style = type, info = data, length = length})
    	PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		if DecorGetInt(PlayerPedId(), 'isOutlaw') == 2 then
			Citizen.Wait(timing)
			DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		-- is jackin'
		if (IsPedTryingToEnterALockedVehicle(playerPed) or IsPedJacking(playerPed)) and Config.CarJackingAlert then

			Citizen.Wait(3000)
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			if vehicle and ((isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted) then
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

				ESX.TriggerServerCallback('esx_outlawalert:isVehicleOwner', function(owner)
					if not owner then

						local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
						vehicleLabel = GetLabelText(vehicleLabel)

						DecorSetInt(playerPed, 'isOutlaw', 2)

						TriggerServerEvent('esx_outlawalert:carJackInProgress', {
							x = ESX.Math.Round(playerCoords.x, 1),
							y = ESX.Math.Round(playerCoords.y, 1),
							z = ESX.Math.Round(playerCoords.z, 1)
						}, streetName, vehicleLabel, playerGender)
					end
				end, plate)
			end
			-- is in combat
		elseif IsPedInMeleeCombat(playerPed) and Config.MeleeAlert then

			Citizen.Wait(3000)

			if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
				DecorSetInt(playerPed, 'isOutlaw', 2)

				TriggerServerEvent('esx_outlawalert:combatInProgress', {
					x = ESX.Math.Round(playerCoords.x, 1),
					y = ESX.Math.Round(playerCoords.y, 1),
					z = ESX.Math.Round(playerCoords.z, 1)
				}, streetName, playerGender)
			end
			-- is shootin'
		elseif IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and Config.GunshotAlert and not GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then

			Citizen.Wait(3000)

			if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
				DecorSetInt(playerPed, 'isOutlaw', 2)

				TriggerServerEvent('esx_outlawalert:gunshotInProgress', {
					x = ESX.Math.Round(playerCoords.x, 1),
					y = ESX.Math.Round(playerCoords.y, 1),
					z = ESX.Math.Round(playerCoords.z, 1)
				}, streetName, playerGender)
			end

		end
	end
end)




RegisterNetEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords)
	if isPlayerWhitelisted then
		if Config.CarJackingAlert then
			local alpha = 250
			local thiefBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipJackingRadius)

			SetBlipHighDetail(thiefBlip, true)
			SetBlipColour(thiefBlip, 1)
			SetBlipAlpha(thiefBlip, alpha)
			SetBlipAsShortRange(thiefBlip, true)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipJackingTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(thiefBlip, alpha)

				if alpha == 0 then
					RemoveBlip(thiefBlip)
					return
				end
			end

		end
	end
end)

RegisterNetEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.GunshotAlert then
		local alpha = 250
		local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipGunRadius)

		SetBlipHighDetail(gunshotBlip, true)
		SetBlipColour(gunshotBlip, 1)
		SetBlipAlpha(gunshotBlip, alpha)
		SetBlipAsShortRange(gunshotBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.BlipGunTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(gunshotBlip, alpha)

			if alpha == 0 then
				RemoveBlip(gunshotBlip)
				return
			end
		end
	end
end)

RegisterNetEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords)
	if isPlayerWhitelisted and Config.MeleeAlert then
		local alpha = 250
		local meleeBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipMeleeRadius)

		SetBlipHighDetail(meleeBlip, true)
		SetBlipColour(meleeBlip, 17)
		SetBlipAlpha(meleeBlip, alpha)
		SetBlipAsShortRange(meleeBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.BlipMeleeTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(meleeBlip, alpha)

			if alpha == 0 then
				RemoveBlip(meleeBlip)
				return
			end
		end
	end
end)


RegisterNetEvent('1013Place')
AddEventHandler('1013Place', function(gx, gy, gz)
	if isPlayerWhitelisted then
		TriggerServerEvent('SANDY_InteractSound_SV:PlayOnSource', 'PoliceDispatch', 0.7)
			local transG = 250
			local gunshotBlip = AddBlipForCoord(gx, gy, gz)
			SetBlipSprite(gunshotBlip,  42)
			SetBlipAlpha(gunshotBlip,  transG)
			SetBlipAsShortRange(gunshotBlip,  false)
			SetBlipScale(gunshotBlip, 0.6)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('# Ranny Funkcjonariusz!')
			EndTextCommandSetBlipName(gunshotBlip)
			while transG ~= 0 do
				Wait(Config.BlipGunTime * 5)
				transG = transG - 1
				SetBlipAlpha(gunshotBlip,  transG)
				if transG == 0 then
					SetBlipSprite(gunshotBlip,  1)
					return
				end
			end
	elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "ambulance" then
		TriggerServerEvent('SANDY_InteractSound_SV:PlayOnSource', 'FireDispatch', 0.7)
		local transG = 250
		local gunshotBlip = AddBlipForCoord(gx, gy, gz)
		SetBlipSprite(gunshotBlip,  42)
		SetBlipAlpha(gunshotBlip,  transG)
		SetBlipAsShortRange(gunshotBlip,  false)
		SetBlipScale(gunshotBlip, 0.6)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('# Ranny Funkcjonariusz!')
		EndTextCommandSetBlipName(gunshotBlip)
		while transG ~= 0 do
			Wait(Config.BlipGunTime * 5)
			transG = transG - 1
			SetBlipAlpha(gunshotBlip,  transG)
			if transG == 0 then
				SetBlipSprite(gunshotBlip,  1)
				return
			end
		end
	end
end)

RegisterNetEvent('esx_powiadomienia:1013')
AddEventHandler('esx_powiadomienia:1013', function()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
	if isPlayerWhitelisted or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "ambulance" then
		TriggerServerEvent('1013Pos', {
			x = ESX.Math.Round(playerCoords.x, 1),
			y = ESX.Math.Round(playerCoords.y, 1),
			z = ESX.Math.Round(playerCoords.z, 1)
		}, streetName,playerCoords.x,playerCoords.y,playerCoords.z)
	Wait(3000)
	end
end)

RegisterCommand("10-13", function(source, args, rawCommand)
	ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
		if qtty > 0 then
			if IsPedDeadOrDying(GetPlayerPed(-1)) then
				if ESX.PlayerData and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' then
					if not block then
						TriggerEvent('esx_powiadomienia:1013')
						block = true
					else
						ESX.ShowNotification('~r~Musisz poczekac minute!')
					end
				else
					ESX.ShowNotification('Nie jesteś policjantem!')
				end
			else
				ESX.ShowNotification('Jesteś przytomny!')
			end
		else
			ESX.ShowNotification('~r~Nie posiadasz GPSa!')
		end
	end, 'tgps')
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if block then
			while (timer ~= 0) do
    		Wait (60000)
    		timer = timer - 1
			end
			block = false
		end
	end
end)

RegisterNetEvent('esx_powiadomienia:gps')
AddEventHandler('esx_powiadomienia:gps', function()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
	if isPlayerWhitelisted then
		TriggerServerEvent('gpsPos', {
			x = ESX.Math.Round(playerCoords.x, 1),
			y = ESX.Math.Round(playerCoords.y, 1),
			z = ESX.Math.Round(playerCoords.z, 1)
		}, streetName,playerCoords.x,playerCoords.y,playerCoords.z)
		Wait(3000)
	end
end)

RegisterNetEvent('esx_outlawalert:gpsInProgress')
AddEventHandler('esx_outlawalert:gpsInProgress', function(x,y,z)
	if isPlayerWhitelisted then
		local alpha = 250
		local gpsshotBlip = AddBlipForCoord(x, y, z)

		SetBlipSprite(gpsshotBlip,  280)
		SetBlipColour(gpsshotBlip,  3)
		SetBlipAlpha(gpsshotBlip, alpha)
		SetBlipAsShortRange(gpsshotBlip, 1)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('GPS Zniszczony')
        EndTextCommandSetBlipName(gpsshotBlip)

		while alpha ~= 0 do
			Citizen.Wait(Config.BlipGunTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(gpsshotBlip, alpha)

			if alpha == 0 then
				SetBlipSprite(gpsshotBlip,  2)
				return
			end
		end
	end
end)

RegisterNetEvent('gpsPlace')
AddEventHandler('gpsPlace', function()
	if isPlayerWhitelisted then
		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  		Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  		Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  		Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  		Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  		Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  	 	Wait(500)
  		PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
	end
end)