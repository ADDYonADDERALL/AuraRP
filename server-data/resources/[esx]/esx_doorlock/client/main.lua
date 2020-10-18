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
local Doors = {}
local Cache = {}
local Scanning = {}
local Markers = {}
local Current = nil
local PlayerData = {}

ESX	= nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	ESX.TriggerServerCallback('esx_door:get', function(doors)
		Doors = doors	
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		for _, door in ipairs(Scanning) do
			local entity = door.entity
			if not DoesEntityExist(door.entity) then
				local doors = GetClosestObjectOfType(door.x, door.y, door.z, 2.5, door.object, false, false, false)
				if doors and doors ~= 0 then
					entity = doors
				else
					entity = nil
				end
			end

			if entity then
				local _, heading = GetStateOfClosestDoorOfType(door.object, door.x, door.y, door.z)
				if math.abs(heading) < 0.01 then
					FreezeEntityPosition(door.entity, true)
					Cache[door.i][door.j] = true
				end
			end
		end
		
		if Current then
			local door = Doors[Current]
			if door.draw then
				DrawText3Ds(door.position.x, door.position.y, door.position.z, (door.gate == nil and (door.locked and '[E] ~r~Zamknięte' or '[E] ~g~Otwarte') or (door.locked and '[H] ~r~Zamknięte' or '[H] ~g~Otwarte')))
			end
			
			if IsControlJustReleased(1, (door.gate == nil and 51 or 74)) and door.locked ~= nil and PlayerData and PlayerData.job then
				local let = true
				if door.jobs then
					let = door.jobs[PlayerData.job.name] == true or door.jobs[PlayerData.job2.name] == true
				end
			
				if let then
					door.locked = not door.locked
					
					if door.soundLib then
						if not door.locked then							
							TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'unlockDoor', 0.8)
							Wait(1000)
						else
							TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'lockDoor', 0.8)
						end
					else
						if not door.locked then
							TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'lockDoor', 0.8)
						else
							TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'unlockDoor', 0.8)
						end
					end
				
					TriggerServerEvent('esx_doorlock:updateState', Current, door.locked)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		
		Scanning = {}
		Current = nil
		Markers = {}
		Gate = nil
		
		local closetDistance = -1
		if #Doors ~= 0 then
			local ped = PlayerPedId()
			
			local coords = GetEntityCoords(ped)
			for i, door in ipairs(Doors) do
				local distance = #(coords - vec3(door.position.x, door.position.y, door.position.z))
				if distance <= 20.0 then
					if not Cache[i] then
						Cache[i] = {}
					end				
				
					local status = (door.locked ~= false)
					for j, data in pairs(door.objects) do
						local tmp = Cache[i][j]
						if tmp == nil or tmp ~= status then
							local doors = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.object, false, false, false)
							if not doors or doors == 0 then
								if tmp ~= nil then
									Cache[i][j] = nil
								end
							elseif status and not door.noSwing and tmp ~= nil then
								table.insert(Scanning, {
									i = i, j = j, x = data.x, y = data.y, z = data.z,
									object = data.object, entity = doors
								})
							else
								FreezeEntityPosition(doors, status)
								Cache[i][j] = status
							end
						end
					end
					
					if distance <= door.distance and (closetDistance == -1 or distance < closetDistance) then
						Current = i
					end
				else
					Cache[i] = {}
				end
			end
		end
	end
end)

RegisterNetEvent('esx_doorlock:update')
AddEventHandler('esx_doorlock:update', function(id, state)
	if Doors[id] then
		Doors[id].locked = state
	end
end)

--Utils

function DrawText3Ds(x,y,z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 55)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end