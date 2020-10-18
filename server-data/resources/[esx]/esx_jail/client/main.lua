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

local IsJailed = false
local unjail = false
local JailTime = 0
local fastTimer = 0
local working = false
local jobNumber = nil
local isWorking = false
local jobDestination = nil
local CurrentAction = nil
local hasAlreadyEnteredMarker = false
local jobBlips = {}
local JailLocation = Config.JailLocation
local canwork = true
ESX = nil

--ESX base
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function Cam()
	local CamOptions = Config.Cutscene["CameraPos"]

	CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
	SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])

	RenderScriptCams(true, false, 0, true, true)
end

RegisterNetEvent('esx_jailerinos:jailerinos')
AddEventHandler('esx_jailerinos:jailerinos', function(jailTime)
	SetCanAttackFriendly(PlayerPedId(), false, false)
	NetworkSetFriendlyFireOption(false)

	SetRelationshipBetweenGroups(1, GetHashKey("PRISONER"), GetHashKey('PLAYER'))
	if JailTime > 0 then
		return
	end

    JailTime = math.floor(jailTime)

    TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
		end
	end)

	local sourcePed = GetPlayerPed(-1)
    if DoesEntityExist(sourcePed) then

        LoadModel(-1320879687)
        local PolicePosition = Config.Cutscene["PolicePosition"]
        local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)
        TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)
    
        local PlayerPosition = Config.Cutscene["PhotoPosition"]
        local PlayerPed = PlayerPedId()
        SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
        SetEntityHeading(PlayerPed, PlayerPosition["h"])
        FreezeEntityPosition(PlayerPed, true)
    
        Cam()
    
        Citizen.Wait(1000)
    
        DoScreenFadeIn(100)
    
        Citizen.Wait(10000)
    
        DoScreenFadeOut(250)
        DeleteEntity(Police)
        SetModelAsNoLongerNeeded(-1320879687)
    
        Citizen.Wait(1000)
    
        DoScreenFadeIn(250)
      
        RenderScriptCams(false,  false,  0,  true,  true)
        FreezeEntityPosition(PlayerPed, false)
        DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])
    end
		Citizen.CreateThread(function()
			SetPedArmour(sourcePed, 0)
			ClearPedBloodDamage(sourcePed)
			ResetPedVisibleDamage(sourcePed)
			ClearPedLastWeaponDamage(sourcePed)
			ResetPedMovementClipset(sourcePed, 0)
			
			SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)
			IsJailed = true
			unjail = false
			while JailTime > 0 and not unjail do
				sourcePed = GetPlayerPed(-1)
				if IsPedInAnyVehicle(sourcePed, false) then
					ClearPedTasksImmediately(sourcePed)
                end
                
                for i = 1, 10 do
					JailTime = JailTime - 1
					Citizen.Wait(1000)
                end
                
				-- Is the player trying to escape?
				if GetDistanceBetweenCoords(GetEntityCoords(sourcePed), JailLocation.x, JailLocation.y, JailLocation.z) > 130.0001 then
					SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)
					TriggerEvent('chatMessage', _U('judge'), { 147, 196, 109 }, _U('escape_attempt'))
				end
				
				TriggerServerEvent('esx_jailerinos:updateRemaining', JailTime)
			end

			-- jail time served
			TriggerServerEvent('esx_jailerinos:unjailTime')
			SetEntityCoords(sourcePed, Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
			IsJailed = false

			-- Change back the user skin
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end)
	end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false) 
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 1666.064, 2555.225, 45.563)

        if dist <= 10.0 then
            DrawMarker(25, 1666.064, 2555.225, 45.563-0.90, 0, 0, 0, 0, 0, 0, 1.301, 1.3001, 1.3001, 0, 205, 250, 200, 0, 0, 0, 0)
        else
            Citizen.Wait(1500)
        end
        if dist <= 2.0 then
            DrawText3D(1666.064, 2555.225, 45.563, "~g~[E]~r~ Aby skorzystać z stołówki!")
            if IsJailed then
                if IsControlJustPressed(0, Keys['E']) then
                    TriggerServerEvent('esx_jailerinos:dajzarcie')
                    Citizen.Wait(100)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if JailTime > 0 and IsJailed then	
			fastTimer = fastTimer - 1
		else
			Citizen.Wait(1000)
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsJailed then
			if fastTimer < 0 then
				fastTimer = JailTime
			end
			draw2dText(_U('remaining_msg', ESX.Math.Round(fastTimer)), { 0.175, 0.955 } )		
		end
	end
end)

RegisterNetEvent('esx_jailerinos:unjail')
AddEventHandler('esx_jailerinos:unjail', function(source)
	unjail = true
    working = false
    SetCanAttackFriendly(sourcePed, true, false)
    FreezeEntityPosition(sourcePed, false)
    NetworkSetFriendlyFireOption(true)
    RemoveBlip(jobBlips['job'])
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	SetBlipSprite(blip, 237)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.3)
	SetBlipColour(blip, 1)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function draw2dText(text, coords)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(table.unpack(coords))
end
 
function getJailStatus()
    return IsJailed
end

 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsJailed then
            if not working then
                CreateJob()
            else
                local isInMarker = false
                local coords = GetEntityCoords(PlayerPedId())
                if Config.Marker == true then
                    DrawMarker(Config.Jobs.Marker.Type, jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Jobs.Marker.Size.x, Config.Jobs.Marker.Size.y, Config.Jobs.Marker.Size.z, Config.Jobs.Marker.Color.r, Config.Jobs.Marker.Color.g, Config.Jobs.Marker.Color.b, 100, false, true, 2, false, false, false, false)
                else   
                    if GetDistanceBetweenCoords(coords, jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z, true) < 40 then
                        ESX.Game.Utils.DrawText3D({ ["x"] = jobDestination.Pos.x, ["y"] = jobDestination.Pos.y, ["z"] = (jobDestination.Pos.z + 1), ["h"] = 137.83 }, "Naciśnij [~b~E~w~] aby ~y~pracować", 0.7)
                    end
                end    
                    if GetDistanceBetweenCoords(coords, jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z, true) < 2 then
                        ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby zacząć pracować')
                        if IsControlJustReleased(0, 38) and canwork == true then
                            StartWork()
                        end
                    end
            end        
        end
    end
end)
 
function CreateJob()
    local newJob
    repeat
        newJob = math.random(1, #Config.Jobs.List)
        Citizen.Wait(1)
    until newJob ~= jobNumber
 
    working = true
    jobNumber = newJob
    jobDestination = Config.Jobs.List[jobNumber]
    CreateBlip(jobDestination)
end
 
function CreateBlip(cords)
    if jobBlips['job'] ~= nil then
        RemoveBlip(jobBlips['job'])
    end
 
    jobBlips['job'] = AddBlipForCoord(cords.Pos.x, cords.Pos.y, cords.Pos.z)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Praca więzienna ' .. cords.Name)
    EndTextCommandSetBlipName(jobBlips['job'])
end
 
function StartWork()
    canwork = false
    isWorking = true
    local delay = math.random(5000, 10000)
    if Config.Notify == true then
        TriggerEvent("pNotify:SetQueueMax", "work", 2)
        TriggerEvent("pNotify:SendNotification", {
            text = "Zaczynasz pracować",
            type = "error",
            queue = "work",
            timeout = 5000,
            layout = "centerRight"
        })
    else
        ESX.ShowNotification('~g~Pracujesz...')
    end
    FreezeEntityPosition(PlayerPedId(), true)
 
    Citizen.CreateThread(function()
        Citizen.Wait(delay)
        isWorking = false
 
        local minusTime = math.random(15,30)
        JailTime = JailTime - minusTime
        TriggerServerEvent('esx_jailerinos:updateRemaining', JailTime)
        fastTimer = fastTimer - minusTime
        if Config.Notify == true then
            TriggerEvent("pNotify:SetQueueMax", "work", 2)
            TriggerEvent("pNotify:SendNotification", {
                text = "Od twojej odsiadki odjęto " .. minusTime ..  " miesięcy!",
                type = "error",
                queue = "work",
                timeout = 5000,
                layout = "centerRight"
            })
		else
            ESX.ShowNotification('Od twojej odsiadki odjęto ~r~' .. minusTime .. '~w~ sekund!')
        end
        CreateJob()
        FreezeEntityPosition(PlayerPedId(), false)
        canwork = true
    end)
end

RegisterNetEvent('esx_jail:shouldbeinjail')

AddEventHandler('esx_jail:shouldbeinjail', function()

	TriggerServerEvent('esx_jailerinos:checkJail')

end)