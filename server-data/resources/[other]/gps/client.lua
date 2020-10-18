
local ACTIVE = false
local ACTIVE_EMERGENCY_PERSONNEL = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("eblips:toggle")
AddEventHandler("eblips:toggle", function(on)

	ACTIVE = on

	if not ACTIVE then
		RemoveAnyExistingEmergencyBlips()
	end
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(personnel)
	ACTIVE_EMERGENCY_PERSONNEL = personnel
end)

RegisterNetEvent("eblips:update")
AddEventHandler("eblips:update", function(person)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
end)

RegisterNetEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	RemoveAnyExistingEmergencyBlipsById(src)
end)


function RemoveAnyExistingEmergencyBlips()
	for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(src)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[src] = nil
		end
	end
end

function RemoveAnyExistingEmergencyBlipsById(id)
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(id)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[id] = nil
		end
end

Citizen.CreateThread(function()
	while true do
		if ACTIVE then
			for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
				local player = GetPlayerFromServerId(src)
				local ped = GetPlayerPed(player)
				if GetPlayerPed(-1) ~= ped then
					if GetBlipFromEntity(ped) == 0 then
						local blip = AddBlipForEntity(ped)
						SetBlipSprite(blip, 1)
						SetBlipColour(blip, info.color)
						SetBlipAsShortRange(blip, true)
						SetBlipDisplay(blip, 4)
						SetBlipCategory(blip, 7)
						ShowHeadingIndicatorOnBlip(blip, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(info.name)
						EndTextCommandSetBlipName(blip)
					end
				end
			end
		end
		Wait(1)
	end
end)

RegisterNetEvent('tostgps:menugpsa')
AddEventHandler('tostgps:menugpsa', function()
ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'gpsmen',
	{
		title    = 'GPS',
		align    = 'center',
		elements = {
			{label = 'Zrestartuj GPS', value = '111'},
			{label = 'Zniszcz GPS', value = '222'},
		}
	},
	function(data2, menu2)
		if data2.current.value == '111' then
		menu2.close()
		TriggerServerEvent("tost:akcjazgpsem",'1')
		Citizen.Wait(1500)
		elseif data2.current.value == '222' then
		menu2.close()
		TriggerServerEvent("tost:akcjazgpsem",'2')
		Citizen.Wait(1500)
		end
		
	end,
	function(data2, menu2)
		menu2.close()
end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	TriggerEvent('esx_gps:removeGPS')
	Citizen.Wait(2500)
	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'tgps' then
			if PlayerData.inventory[i].count > 0 then
				TriggerServerEvent('tost:dodajgpsa')
				end
			end
		end
end)

Citizen.CreateThread(function()
	AddTextEntryByHash('BLIP_OTHPLYR', 'GPS')
end)