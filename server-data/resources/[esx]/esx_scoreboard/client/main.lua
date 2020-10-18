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

local ajdik = GetPlayerServerId(PlayerId())
local idVisable = true
local PlayerData              = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	local data = xPlayer
	local job = data.job
	local job2 = data.job2
	SendNUIMessage({action = "updatePraca", praca = job.label.." - "..job.grade_label})
	SendNUIMessage({action = "updatePraca2", praca2 = job2.label.." - "..job2.grade_label})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SendNUIMessage({action = "updatePraca", praca = job.label.." - "..job.grade_label})
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
	SendNUIMessage({action = "updatePraca2", praca2 = job2.label.." - "..job2.grade_label})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		ajdik = GetPlayerServerId(PlayerId())
		if ajdik == nil or ajdik == '' then
			ajdik = GetPlayerServerId(PlayerId())
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	ajdik = GetPlayerServerId(PlayerId())
	if ajdik == nil or ajdik == '' then
		ajdik = GetPlayerServerId(PlayerId())
	end
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 100),
		uptime = ajdik,
	})
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	ajdik = GetPlayerServerId(PlayerId())
	if ajdik == nil or ajdik == '' then
		ajdik = GetPlayerServerId(PlayerId())
	end
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = ajdik
	})
end)

local broker, ems, police, taxi, mechanic, sheriff, doj, players = 0, 0, 0, 0, 0, 0, 0, 0, 0

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	broker, ems, police, taxi, mechanic, sheriff, doj, players = 0, 0, 0, 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do

		table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))

		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' then
			police = police + 1
		elseif v.job == 'taxi' then
			taxi = taxi + 1
		elseif v.job == 'mecano' then
			mechanic = mechanic + 1
		elseif v.job == 'sheriff' then
			sheriff = sheriff + 1
		elseif v.job == 'doj' then
			doj = doj + 1
		elseif v.job == 'cardealer' then
			broker = broker + 1
		end

		if v.job2 == 'ambulance' then
			ems = ems + 1
		elseif v.job2 == 'police' then
			police = police + 1
		elseif v.job2 == 'taxi' then
			taxi = taxi + 1
		elseif v.job2 == 'mecano' then
			mechanic = mechanic + 1
		elseif v.job2 == 'sheriff' then
			sheriff = sheriff + 1
		elseif v.job2 == 'doj' then
			doj = doj + 1
		elseif v.job2 == 'cardealer' then
			broker = broker + 1
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	if police <= 4 then

		SendNUIMessage({
			action = 'updatePlayerJobs',
			jobs   = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, sheriff = sheriff, doj = doj, player_count = players}
		})

	else

		SendNUIMessage({
			action = 'updatePlayerJobs',
			jobs   = {ems = ems, police = "4+", taxi = taxi, mechanic = mechanic, sheriff = sheriff, doj = doj, player_count = players}
		})

	end
end

function counter(what)
	if what == 'ambulance' then
		return ems
	elseif what == 'police' then
		return police
	elseif what == 'taxi' then
		return taxi
	elseif what == 'mecano' then
		return mechanic
	elseif what == 'sheriff' then
		return sheriff
	elseif what == 'doj' then
		return doj
	elseif what == 'cardealer' then
		return broker
	elseif what == 'players' then
		return players
	end
end

RegisterNetEvent('send')
AddEventHandler('send', function(id, message, color)
	local source = PlayerId()
	local target = GetPlayerFromServerId(id)
	if target == source then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.3vw; margin: 0.3vw; border-radius: 5px; margin-left: 0; margin-right: 0;" {0} <br></div>',
			args = { message, color }
		})
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(source)), GetEntityCoords(GetPlayerPed(target)), true) < 40.0 then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.3vw; margin: 0.3vw; border-radius: 5px; margin-left: 0; margin-right: 0;" {0} <br></div>',
			args = { message, color }
		})
	end
end)

local IsNuiActive = false
local IsDisplaying = nil
local Timer = 0
local Prop = nil

local Id = nil
local IsAdmin = nil
local Counters = nil
local Players = nil

local Ped = {
	Active = false,
	Id = 0,
	Exists = false,
	Spectate = nil
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if not NetworkIsInSpectatorMode() then
			Ped.Spectate = nil
		end

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			Ped.Id = PlayerPedId()
			Ped.Exists = DoesEntityExist(Ped.Id)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
        for _, player in ipairs(GetActivePlayers()) do
            N_0x31698aa80e0223f8(player)
        end

		local found = false
		if Ped.Active and Ped.Exists then
			found = true
			if IsControlJustPressed(0, Keys['Z']) then
				IsDisplaying = false
				if IsEntityVisible(Ped.Id) then
					TriggerServerEvent('z_send', " ^7Obywatel [" .. GetPlayerServerId(PlayerId()) .. "] przegląda wykaz mieszkańców.")
					ToggleScoreBoard()
				end
			end

			if IsDisplaying ~= nil then
				if IsDisplaying == false then
					if not exports['esx_property']:isInProperty() then
						local ped = Ped.Id
						if Ped.Spectate then
							ped = Ped.Spectate
						end
						local pid = PlayerId()
						for _, player in ipairs(GetActivePlayers()) do
							if id ~= player then
								local playerPed = GetPlayerPed(player)
								if IsEntityVisible(playerPed) then
									local coords1 = GetEntityCoords(Ped.Id, true)
									local coords2 = GetEntityCoords(playerPed, true)
									if #(coords1 - coords2) < 40.0 then
										DrawText3D(coords2.x, coords2.y, coords2.z + 1.2, GetPlayerServerId(player), (NetworkIsPlayerTalking(player) and {0, 0, 255} or {255, 255, 255}))
									end
								end
							end  
						end
					end
				end

				if IsControlJustReleased(0, Keys['Z']) and GetLastInputMethod(2) then
					ToggleScoreBoard()

					IsDisplaying = nil
					IsNuiActive = false
				end
			end
		end

		if not found and IsDisplaying ~= nil then

			IsDisplaying = nil
			IsNuiActive = false
		end
	end
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end

AddEventHandler('EasyAdmin:spectate', function(ped)
	Ped.Spectate = ped
end)
