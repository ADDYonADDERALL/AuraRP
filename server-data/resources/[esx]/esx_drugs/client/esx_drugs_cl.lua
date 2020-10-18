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

local PlayerData = {}
local cokeQTE       			= 0
ESX 			    			= nil
local coke_poochQTE 			= 0
local weedQTE					= 0
local weed_poochQTE 			= 0
local weedindicaQTE					= 0
local weedindica_poochQTE 			= 0
local methQTE					= 0
local meth_poochQTE 			= 0
local opiumQTE					= 0
local opium_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local allowmarker = false
local Zones = {}

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
	TriggerServerEvent('sandy_drugs:refreshdrugs')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('sandy_drugs:setplayerdrugs')
AddEventHandler('sandy_drugs:setplayerdrugs', function(coords)
	Zones = coords
	allowmarker = true
end)

AddEventHandler('esx_veryfunstuff:hasEnteredMarker', function(zone)
	if myJob == 'police' or myJob == 'ambulance' or myJob == 'mecano' or myJob == 'doj' or myJob == 'offpolice' or myJob == 'offambulance' or myJob == 'offmecano' then
		return
	end

	if zone == 'exitMarker' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('exit_marker')
		CurrentActionData = {}
	end
	
	if zone == 'CokeField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		if cokeQTE >= 3 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'CokeDealer' then
		if coke_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'MethField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		if methQTE >= 3 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'MethDealer' then
		if meth_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedField2' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		if weedQTE >= 3 or weedindicaQTE >= 3 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedDealer' then
		if weed_poochQTE >= 1 or weedindica_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		if opiumQTE >= 3 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumDealer' then
		if opium_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'CrackField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_crack')
		CurrentActionData = {}
	end

	if zone == 'CrackProcessing' then
		if crackQTE >= 3 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_crack')
			CurrentActionData = {}
		end
	end

end)


AddEventHandler('esx_veryfunstuff:hasExitedMarker', function(zone)
    CurrentAction = nil
    CurrentActionMsg  = nil
    CurrentActionData = {}
    isInZone = false
    ESX.UI.Menu.CloseAll()

    TriggerServerEvent('esx_veryfunstuff:wstrzymajkierownice')
end)

-- Weed Effect
RegisterNetEvent('esx_veryfunstuff:onPot')
AddEventHandler('esx_veryfunstuff:onPot', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")

	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do

		Citizen.Wait(0)

	end

	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)

	Citizen.Wait(5000)

	DoScreenFadeOut(1000)

	Citizen.Wait(1000)

	ClearPedTasksImmediately(GetPlayerPed(-1))

	SetTimecycleModifier("spectator5")

	SetPedMotionBlur(GetPlayerPed(-1), true)

	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)

	SetPedIsDrunk(GetPlayerPed(-1), true)

	DoScreenFadeIn(1000)

	Citizen.Wait(600000)

	DoScreenFadeOut(1000)

	Citizen.Wait(1000)

	DoScreenFadeIn(1000)

	ClearTimecycleModifier()

	ResetScenarioTypesEnabled()

	ResetPedMovementClipset(GetPlayerPed(-1), 0)

	SetPedIsDrunk(GetPlayerPed(-1), false)

	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Render markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))
		if allowmarker then
			for k,v in pairs(Zones) do
				if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
					DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

if Config.ShowBlips then
	-- Create blips
	Citizen.CreateThread(function()
		for k,v in pairs(Zones) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.9)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end


-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('esx_veryfunstuff:ReturnInventory')
AddEventHandler('esx_veryfunstuff:ReturnInventory', function(cokeNbr, cokepNbr, methNbr, methpNbr, weedNbr, weedpNbr, weedindicaNbr, weedindicapNbr, opiumNbr, opiumpNbr, crackNbr, crackpNbr, jobName, currentZone)
	cokeQTE	   = cokeNbr
	coke_poochQTE = cokepNbr
	methQTE 	  = methNbr
	meth_poochQTE = methpNbr
	weedQTE 	  = weedNbr
	weed_poochQTE = weedpNbr
	weedindicaQTE 	  = weedindicaNbr
	weedindica_poochQTE = weedindicapNbr
	opiumQTE	   = opiumNbr
	opium_poochQTE = opiumpNbr
	crackQTE	   = crackNbr
	crack_poochQTE = crackpNbr
	myJob		 = jobName
	TriggerEvent('esx_veryfunstuff:hasEnteredMarker', currentZone)
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 1.5) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('esx_veryfunstuff:GetUserInventory', currentZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('esx_veryfunstuff:hasEnteredMarker', 'exitMarker')
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_veryfunstuff:hasExitedMarker', lastZone)
			Citizen.Wait(10000)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
			if IsControlJustReleased(0, Keys['E']) then
				isInZone = true -- unless we set this boolean to false, we will always freeze the user
				if CurrentAction == 'exitMarker' then
					isInZone = false -- do not freeze user
					--TriggerEvent('esx_veryfunstuff:freezePlayer', false)
					TriggerEvent('esx_veryfunstuff:hasExitedMarker', lastZone)
					Citizen.Wait(15000)
				elseif CurrentAction == 'CokeField' then
					--if PlayerData.job ~= nil and PlayerData.job.name == 'galaxy' then
						TriggerServerEvent('esx_veryfunstuff:startHarvestCoke')
					--else
						--ESX.ShowNotification('To nie twoj teren')
					--end
				elseif CurrentAction == 'CokeProcessing' then
					--if PlayerData.job ~= nil and PlayerData.job.name == 'galaxy' then
						TriggerServerEvent('esx_veryfunstuff:startTransformCoke')
					--else
						--ESX.ShowNotification('To nie twoj teren')
					--end
				elseif CurrentAction == 'CokeDealer' then
					TriggerServerEvent('esx_veryfunstuff:startSellCoke')
				elseif CurrentAction == 'MethField' then
					TriggerServerEvent('esx_veryfunstuff:startHarvestMeth')
				elseif CurrentAction == 'MethProcessing' then
					TriggerServerEvent('esx_veryfunstuff:startTransformMeth')
				elseif CurrentAction == 'MethDealer' then
					TriggerServerEvent('esx_veryfunstuff:startSellMeth')
				elseif CurrentAction == 'WeedField' then
					TriggerServerEvent('esx_veryfunstuff:startHarvestWeed')
				elseif CurrentAction == 'WeedField2' then
					TriggerServerEvent('esx_veryfunstuff:startHarvestWeed2')
				elseif CurrentAction == 'WeedProcessing' then
					if weedQTE >= 3 then
						TriggerServerEvent('esx_veryfunstuff:startTransformWeed')
					elseif weedindicaQTE >= 3 then
						TriggerServerEvent('esx_veryfunstuff:startTransformWeedIndica')
					end
				elseif CurrentAction == 'WeedDealer' then
					TriggerServerEvent('esx_veryfunstuff:startSellWeed')
				elseif CurrentAction == 'OpiumField' then
					TriggerServerEvent('esx_veryfunstuff:startHarvestOpium')
				elseif CurrentAction == 'OpiumProcessing' then
					TriggerServerEvent('esx_veryfunstuff:startTransformOpium')
				elseif CurrentAction == 'CrackField' then
					TriggerServerEvent('esx_veryfunstuff:startHarvestCrack')
				elseif CurrentAction == 'CrackProcessing' then
					TriggerServerEvent('esx_veryfunstuff:startTransformCrack')
				elseif CurrentAction == 'OpiumDealer' then
					TriggerServerEvent('esx_veryfunstuff:startSellOpium')
				else
					isInZone = false -- not a esx_drugs zone
				end
			end
		else
			TriggerEvent('esx_veryfunstuff:hasExitedMarker', lastZone)
		end
	end
end
end)
