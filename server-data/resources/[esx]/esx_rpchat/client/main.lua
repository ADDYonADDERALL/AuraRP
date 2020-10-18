ESX                           = nil
local PlayerData              = {}

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
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	Citizen.Wait(5000)
end)

RegisterNetEvent('anonTweet')
AddEventHandler('anonTweet', function(id, name, message, police)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local yourrandomid = randomString(5)
	if(pid == myId) or (pid ~= myId) then
		if PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'offsheriff' then
		else
			TriggerEvent('chat:addMessage',  { templateId = 'darkweb', multiline = true, args = {  yourrandomid..":^r ^7  ".."^7 " .. message } })
		end
	end
end)

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function randomString(length)
    if not length or length <= 0 then return '' end
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

function string.starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end
 
RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message, source)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chat:addMessage',  { templateId = 'localooc', multiline = true, args = { name, message } })
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chat:addMessage',  { templateId = 'localooc', multiline = true, args = { name, message } })
	end
end)

RegisterNetEvent('sendProximityMessageCzy')
AddEventHandler('sendProximityMessageCzy', function(id, name, message, czy)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local color = {r = 164, g = 30, b = 191, alpha = 255}
    

	if czy == 1 then
      if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.2vw; margin: 0.2vw; background: linear-gradient(to right,  rgba(0, 50, 250, 0.6) 0%, rgba(0, 20, 102, 0.6) 100%); border-radius: 3px; margin-left: 0; margin-right: 0;"><i class="far fa-check-circle"></i>&nbsp;{0}{1}</div>',
            args = {'TRY ['..name,'] Udane'..message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= 19.999 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.2vw; margin: 0.2vw; background: linear-gradient(to right,  rgba(0, 50, 250, 0.6) 0%, rgba(0, 20, 102, 0.6) 100%); border-radius: 3px; margin-left: 0; margin-right: 0;"><i class="far fa-check-circle"></i>&nbsp;{0}{1}</div>',
            args = {'TRY ['..name,'] Udane'..message }
        })
      end
	elseif czy == 2 then
	  if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.2vw; margin: 0.2vw; background: linear-gradient(to right,  rgba(0, 50, 250, 0.6) 0%, rgba(0, 20, 102, 0.6) 100%); border-radius: 3px; margin-left: 0; margin-right: 0;"><i class="far fa-times-circle"></i>&nbsp;{0}{1}</div>',
            args = {'TRY ['..name,'] Nieudane'..message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) <= 19.999 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.2vw; margin: 0.2vw; background: linear-gradient(to right,  rgba(0, 50, 250, 0.6) 0%, rgba(0, 20, 102, 0.6) 100%); border-radius: 3px; margin-left: 0; margin-right: 0;"><i class="far fa-times-circle"></i>&nbsp;{0}{1}</div>',
            args = {'TRY ['..name,'] Nieudane'..message }
        })
      end
	end
end)

RegisterNetEvent('sendProximityMessageMe3D')
AddEventHandler('sendProximityMessageMe3D', function(id, message)
	if GetPlayerFromServerId(id) == PlayerId() then
		TriggerServerEvent('3dme:shareDisplayMe', message)
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageMed')
AddEventHandler('sendProximityMessageMed', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chat:addMessage',  { templateId = 'med', multiline = true, args = {  " [" .. id .."] " .. name.. ":", message } })
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 10.999 then
		TriggerEvent('chat:addMessage',  { templateId = 'med', multiline = true, args = {  " [" .. id .."] " .. name ..":", message } })
	end
end)

RegisterNetEvent('sendProximityCmdMessage')
AddEventHandler('sendProximityCmdMessage', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	end
end)

-- Settings
local color = { r = 138, g = 85, b = 162, alpha = 255 } -- Color of the text
local colordo = { r = 222, g = 202, b = 233, alpha = 200 } -- Color of the text 
local font = 4 -- Font of the text
local time = 6000 -- Duration of the display of the text : 1000ms = 1sec
local background = {
    enable = true,
    color = { r = 152, g = 11, b = 196, alpha = 50 },
    colordo = { r = 0, g = 68, b = 176, alpha = 50 },
}
local chatMessage = true
local dropShadow = true

-- Don't touch
local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
    local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterCommand('do', function(source, args)
    local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
    TriggerServerEvent('3ddo:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 0.9 + (nbrDisplaying*0.16)
    Display(source, GetPlayerFromServerId(source), text, offset, 'me')
end)

RegisterNetEvent('3ddo:triggerDisplay')
AddEventHandler('3ddo:triggerDisplay', function(text, source)
    local offset = 0.9 + (nbrDisplaying*0.16)
    Display(source, GetPlayerFromServerId(source), text, offset, 'do')
end)

function Display(source, mePlayer, text, offset, type)
    local displaying = true

    -- Chat message
    if type == 'me' then
        if chatMessage then
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            local playerName = GetPlayerServerId(source)
            if dist < 200 then
                TriggerEvent('chat:addMessage', {
                    color = { color.r, color.g, color.b },
                    template = '<div style="padding: 0.3vw; margin: 0.3vw; background: linear-gradient(to right,  rgba(221, 7, 237, 0.6) 0%, rgba(153, 5, 163, 0.6) 100%); border-radius: 5px; margin-left: 0; margin-right: 0;"<i class="fas fa-user"></i> {0} {1}<br></div>',
                    args = {'^7ME ['..source..'] ', '^7^r'..text..''}
                })
            end
        end

        Citizen.CreateThread(function()
            Wait(time)
            displaying = false
        end)
        Citizen.CreateThread(function()
            nbrDisplaying = nbrDisplaying + 1
            while displaying do
                Wait(0)
                local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
                local coords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist2(coordsMe, coords)
                if dist < 200 then
                    DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
                end
            end
            nbrDisplaying = nbrDisplaying - 1
        end)
    elseif type == 'do' then
        if chatMessage then
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            local playerName = GetPlayerServerId(source)
            if dist < 200 then
                TriggerEvent('chat:addMessage', {
                    color = { colordo.r, colordo.g, colordo.b },
                    template = '<div style="padding: 0.3vw; margin: 0.3vw; background: linear-gradient(to right,  rgba(0, 50, 250, 0.6) 0%, rgba(0, 20, 102, 0.6) 100%); border-radius: 5px; margin-left: 0; margin-right: 0;"<i class="fas fa-user"></i> {0} {1}<br></div>',
                    args = {'^7DO ['..source..'] ', '^7^r'..text..''}
                })
            end
        end
    
        Citizen.CreateThread(function()
            Wait(time)
            displaying = false
        end)
        Citizen.CreateThread(function()
            nbrDisplaying = nbrDisplaying + 1
            while displaying do
                Wait(0)
                local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
                local coords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist2(coordsMe, coords)
                if dist < 200 then
                    DrawText3DDo(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
                end
            end
            nbrDisplaying = nbrDisplaying - 1
        end)
    end
end

function DrawText3D(x, y, z, text)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextCentre(1)

	SetTextEntry("STRING")
	AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	DrawText(_x,_y)

	local factor = text:len() / 250
	DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, 41, 11, 41, 68)
end

function DrawText3DDo(x, y, z, text)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextCentre(1)

	SetTextEntry("STRING")
	AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	DrawText(_x,_y)

	local factor = text:len() / 250
	DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, background.colordo.r, background.colordo.g, background.colordo.b, 68)
end

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
            local WaypointHandle = GetFirstBlipInfoId(8)

            ESX.TriggerServerCallback('tpm:permisje', function(permisje)
                if permisje then
            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end
            else
                ESX.ShowNotification("~r~Zaznacz waypoint.")
            end
            else
                ESX.ShowNotification("~r~Nie masz permisji.")
            end
        end)
    end)
end

RegisterCommand("getpos", function(source, args, raw)
    local ped = GetPlayerPed(PlayerId())
    local coords = GetEntityCoords(ped, false)
    local heading = GetEntityHeading(ped)
    TriggerEvent("chatMessage", tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading))
end, false)

RegisterNetEvent("esx_rpchat:kosci")
AddEventHandler('esx_rpchat:kosci', function()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    Citizen.Wait(100)
    local score = math.random(1,6)
    local text ='Bierze do ręki jedną kostkę po czym nią rzuca'
    TriggerServerEvent('3dme:shareDisplay', text)
    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intcelebrationmale@wank', "wank", 18.0, 10.0, -1, 50, 0, false, true, true)
    Citizen.Wait(1000)
    ClearPedTasks(ped)
    text ='Liczba oczek: '..score
    TriggerServerEvent('3ddo:shareDisplay', text)
end)