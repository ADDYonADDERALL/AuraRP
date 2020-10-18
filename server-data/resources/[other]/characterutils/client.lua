Keys = {
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

local fov_max = 150.0
local fov_min = 7.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right 
local speed_ud = 8.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)

local helicam = false
local polmav_hash = GetHashKey("pcj")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision
local crouchedmode = 0
local knockedOut = false
local knockedwait = 15
local knockedcount = 60
local handsup = false
local mp_pointing = false
local Ped = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do

        Citizen.Wait(10)

		local lPed = GetPlayerPed(-1)
		local heli = GetVehiclePedIsIn(lPed)
		
		if helicam then

			if not ( IsPedSittingInAnyVehicle( lPed ) ) then

						Citizen.CreateThread(function()

		                    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
							PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")

						end)

					else
					end	

					Wait(2000)

					SetTimecycleModifier("heliGunCam")

			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("HELI_CAM")

			while not HasScaleformMovieLoaded(scaleform) do

				Citizen.Wait(10)

			end

			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()

			local locked_on_vehicle = nil

			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and true do

				if IsControlJustPressed(0, 177) then -- Toggle Helicam

					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(GetPlayerPed(-1))
					helicam = false

				end

				if locked_on_vehicle then
					
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)

					CheckInputRotation(cam, zoomvalue)

					local vehicle_detected = GetVehicleInView(cam)

				end

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(10)

			end

			helicam = false

			ClearTimecycleModifier()

			fov = (fov_max+fov_min)*0.5

			RenderScriptCams(false, false, 0, 1, 0)

			SetScaleformMovieAsNoLongerNeeded(scaleform)

			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

--EVENTS--

RegisterNetEvent('jumelles:Active') --Just added the event to activate the binoculars
AddEventHandler('jumelles:Active', function()
	helicam = not helicam
end)

--FUNCTIONS--

function IsPlayerInPolmav()
	local lPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end


function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,32) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,8) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	else
		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		Ped = exports['AuraRP']:GetPedData()
	end
end)

local winter = true

Citizen.CreateThread(function()
	while not HasAnimSetLoaded("move_ped_crouched") do
		RequestAnimSet("move_ped_crouched")
		Citizen.Wait(0)
	end
	while not HasAnimDictLoaded('random@mugging3') do
		RequestAnimDict('random@mugging3')
		Citizen.Wait(0)
	end
	while not HasAnimDictLoaded('anim@mp_snowball') do
		RequestAnimDict('anim@mp_snowball')
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(10)
		if Ped.Active then
			if not Ped.Vehicle then
				DisableControlAction(0, 36, true)
				if not IsPedFalling(Ped.Id) and not IsPedCuffed(Ped.Id) and not IsPedDiving(Ped.Id) then
					if IsControlJustReleased(0, 243) then
						if handsup then
							handsup = false
							TaskPlayAnim(Ped.Id, 'random@mugging3', 'handsup_standing_exit', 8.0, 8.0, 1.0, 48, 0, 0, 0, 0)	
							Wait(1)
							ClearPedTasks(Ped.Id)	
						else
							handsup = true			
							TaskPlayAnim(Ped.Id, 'random@mugging3', 'handsup_standing_enter', 8.0, 8.0, 1.0, 50, 0, 0, 0, 0)
						end
					end
					if IsDisabledControlJustPressed(0, 36) then
						crouchedmode=crouchedmode+1
						if crouchedmode == 1 then
							SetPedMovementClipset(Ped.Id, "move_ped_crouched", 0.25)
						elseif crouchedmode == 2 then
							ResetPedMovementClipset(Ped.Id, 0)
							SetPedStealthMovement(Ped.Id ,true, "")
						elseif crouchedmode == 3 then
							crouchedmode=0
							SetPedStealthMovement(Ped.Id ,false, "")
						end
					end
					if winter then 
			            if IsControlJustReleased(0, 74) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then
			                ESX.ShowNotification('Lepisz sniezke!')
			                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
			                Citizen.Wait(1950)
			                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 1, false, true)
			            end
				        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
				            SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
				        end
			        end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		while handsup do
			Citizen.Wait(0)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
		end
	end
end)

Citizen.CreateThread(function()
    while not HasAnimDictLoaded("anim@mp_point") do
		RequestAnimDict("anim@mp_point")
        Citizen.Wait(0)
    end
    while true do
        Citizen.Wait(10)
		local pointreset = false
		if Ped.Available and not Ped.InVehicle and Ped.Visible and Ped.OnFoot then
			if IsControlJustPressed(1, 29) or IsControlJustPressed(2, 29) then
				if not mp_pointing then
					mp_pointing = true
				else
					mp_pointing = false
					pointreset = true
				end
			end
		elseif mp_pointing then
            mp_pointing = false
			pointreset = true
        end
        if pointreset then
			RequestTaskMoveNetworkStateTransition(Ped.Id, "Stop")
			if not IsPedInjured(Ped.Id) then
				ClearPedSecondaryTask(Ped.Id)
			end
			if not IsPedInAnyVehicle(Ped.Id, 1) then
				SetPedCurrentWeaponVisible(Ped.Id, 1, 1, 1, 1)
			end
			SetPedConfigFlag(Ped.Id, 36, 0)
			ClearPedSecondaryTask(Ped.Id)
		elseif mp_pointing then
			if IsTaskMoveNetworkActive(Ped.Id) then
				SetTaskMoveNetworkSignalFloat(Ped.Id, "Pitch", (math.min(42.0, math.max(-70.0, GetGameplayCamRelativePitch())) + 70.0) / 112.0)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "Heading", ((math.min(180.0, math.max(-180.0, GetGameplayCamRelativeHeading())) + 180.0) / 360.0) * -1.0 + 1.0)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "isBlocked", false)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "isFirstPerson", N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
			else
				SetPedCurrentWeaponVisible(Ped.Id, 0, 1, 1, 1)
				SetPedConfigFlag(Ped.Id, 36, 1)
				TaskMoveNetworkByName(Ped.Id, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
			end
        end
    end
end)

local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0

RegisterCommand("podnies",function(source, args)
	if not carryingBackInProgress then
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'podnies', {
			title    = 'Wybierz Sposob',
			align    = 'center',
			elements = {
				{label = 'Na Strazaka', value = 'CarryPeople:podnies'},
				{label = 'Na Barana', value = 'CarryPeople:baran'},
			}
		}, function(data, menu)
			local option = data.current.value
			menu.close()
			local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), true), 2.5)
			if #playersInArea > 1 then
				local elements = {}
				for _, player in ipairs(playersInArea) do
					if player ~= PlayerId() then
						local sid = GetPlayerServerId(player)
						table.insert(elements, {label = sid, value = sid})
					end
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'podnies', {
					title    = 'Wybierz obywatela',
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					local player = GetPlayerFromServerId(data2.current.value)
					if player and player ~= 0 then
						local coords1 = GetEntityCoords(PlayerPedId(), true)
						local coords2 = GetEntityCoords(GetPlayerPed(player), true)
						if #(coords1 - coords2) <= 2.5 then
							menu2.close()
							TriggerServerEvent('CarryPeople:request', data2.current.value, option)
							ESX.ShowNotification('~y~Oczekiwanie na akceptacje przez obywatela')
						else
							ESX.ShowNotification('~r~Obywatel zbyt daleko')
						end
					else
						ESX.ShowNotification('~r~Obywatel nie istnieje')
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				ESX.ShowNotification('~r~Brak obywateli w poblizu!')
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("CarryPeople:stop",target)
		end
	end
end,false)

RegisterNetEvent('CarryPeople:request')
AddEventHandler('CarryPeople:request', function(animation, playerId, me)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'podnies', {
		title    = 'Obywatel [' .. playerId .. '] chce Cie podniesc',
		align    = 'center',
		elements = {
			{ label = 'Tak', value = true },
			{ label = 'Nie', value = false }
		}
	}, function(data, menu)
		menu.close()
		if data.current.value then
			local player = GetPlayerFromServerId(playerId)
			if player and player ~= 0 then
				local coords1 = GetEntityCoords(PlayerPedId(), true)
				local coords2 = GetEntityCoords(GetPlayerPed(player), true)
				if #(coords1 - coords2) <= 2.5 then
					TriggerServerEvent('CarryPeople:accept', playerId, animation)
				else
					ESX.ShowNotification('~r~Obywatel jest zbyt daleko')
					TriggerServerEvent('CarryPeople:deny', playerId)
				end
			end
		else
			TriggerServerEvent('CarryPeople:deny', playerId)
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('CarryPeople:podnies')
AddEventHandler('CarryPeople:podnies', function(target)
	local player = PlayerPedId()	
	lib = 'missfinale_c2mcs_1'
	anim1 = 'fin_c2_mcs_1_camman'
	lib2 = 'nm'
	anim2 = 'firemans_carry'
	distans = 0.15
	distans2 = 0.27
	height = 0.63
	spin = 0.0		
	length = 100000
	controlFlagMe = 49
	controlFlagTarget = 33
	animFlagTarget = 1
	if target ~= -1 and target ~= nil then
		carryingBackInProgress = true
		TriggerServerEvent('CarryPeople:sync', target, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
	else
		ESX.ShowNotification('~r~Brak obywateli w poblizu!')
	end
end)

RegisterNetEvent('CarryPeople:baran')
AddEventHandler('CarryPeople:baran', function(target)
	local player = PlayerPedId()	
	lib = 'anim@arena@celeb@flat@paired@no_props@'
	anim1 = 'piggyback_c_player_a'
	anim2 = 'piggyback_c_player_b'
	distans = -0.07
	distans2 = 0.0
	height = 0.45
	spin = 0.0		
	length = 100000
	controlFlagMe = 49
	controlFlagTarget = 33
	animFlagTarget = 1
	if target ~= -1 and target ~= nil then
		carryingBackInProgress = true
		TriggerServerEvent('CarryPeople:sync2', target, lib, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
	else 
		ESX.ShowNotification('~r~Brak obywateli w poblizu!')
	end
end)

RegisterNetEvent('CarryPeople:syncTarget')
AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:syncMe')
AddEventHandler('CarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:syncTarget2')
AddEventHandler('CarryPeople:syncTarget2', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:syncMe2')
AddEventHandler('CarryPeople:syncMe2', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:cl_stop')
AddEventHandler('CarryPeople:cl_stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carryingBackInProgress then 
			while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		end
		Wait(0)
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end