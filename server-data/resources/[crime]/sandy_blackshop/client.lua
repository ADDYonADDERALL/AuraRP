local PlayerData = {}
local GUI = {}
local shopcoords = {x = 0, y = 0, z = 0}
local weaponshopcoords = {x = 0, y = 0, z = 0}
local infobuycoords = {x = 0, y = 0, z = 0}
local allowmarker = false
local canbuyinfo = true
local destination = {}
local hasAlreadyEnteredMarker 	 = false
local hasAlreadyEnteredMarkerr 	 = false
local lastZone 					 = nil
local mafiashop = {x = 736.83, y = 2585.67, z = 75.52}
local mafiashopaddons = {x = 737.23, y = 2584.03, z = 75.52}
local ballasshop = {x = 78.13, y = -1968.07, z = 17.83}
local vagosshop = {x = 334.92, y = -2018.04, z = 22.39}
local grooveshop = {x = -23.87, y = -1405.41, z = 24.56}
local bloodsshop = {x = 851.33, y = -531.61, z = 38.54}
local hasshopaccess = false

ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	TriggerServerEvent('sandy_blackshop:refreshshop')
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

RegisterNetEvent('sandy_blackshop:setplayerblackshop')
AddEventHandler('sandy_blackshop:setplayerblackshop', function(coords, coords2, coordsinfo, access)
	shopcoords = coords
	weaponshopcoords = coords2
	infobuycoords = coordsinfo
	allowmarker = true
	hasshopaccess = access
end)

RegisterNetEvent('sandy_blackshop:setdestination')
AddEventHandler('sandy_blackshop:setdestination', function(canbuy)
	destination['cel'] = AddBlipForCoord(shopcoords.x, shopcoords.y, shopcoords.z)
	SetBlipRoute(destination['cel'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Czarny Sklep')
	EndTextCommandSetBlipName(destination['cel'])
	canbuyinfo = canbuy
end)

RegisterNetEvent('sandy_blackshop:setdestinationweapons')
AddEventHandler('sandy_blackshop:setdestinationweapons', function(canbuy)
	destination['cel'] = AddBlipForCoord(weaponshopcoords.x, weaponshopcoords.y, weaponshopcoords.z)
	SetBlipRoute(destination['cel'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Bronie')
	EndTextCommandSetBlipName(destination['cel'])
	canbuyinfo = canbuy
end)

RegisterNetEvent('sandy_blackshop:removedestination')
AddEventHandler('sandy_blackshop:removedestination', function()
	RemoveBlip(destination['cel']) 
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
    	local player = GetEntityCoords(PlayerPedId())
    	if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'mecano' and PlayerData.job.name ~= 'ambulance' then
    		if allowmarker then
		    	if (GetDistanceBetweenCoords(player, infobuycoords.x, infobuycoords.y, infobuycoords.z, true) < 10) then
		    		DrawMarker(1, infobuycoords.x, infobuycoords.y, infobuycoords.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(player,  infobuycoords.x, infobuycoords.y, infobuycoords.z, true) < 2.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby kupic ~y~wtyke')
			    		if IsControlPressed(1, 51) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'blackshopinfo_actions') then
			    			if canbuyinfo then
			    				infomenu()
				    		else
		    					ESX.ShowNotification('Wroc pozniej!')
		    				end
			    		end
		    		end
		    	end 

			    if (GetDistanceBetweenCoords(player, shopcoords.x, shopcoords.y, shopcoords.z, true) < 10) then
					DrawMarker(1, shopcoords.x, shopcoords.y, shopcoords.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(player,  shopcoords.x, shopcoords.y, shopcoords.z, true) < 2.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby otworzyc ~y~Czarny Sklep')
						if IsControlPressed(1, 51) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'blackshop_actions') then
							shopmenu()
						end
					end
				end

				if (GetDistanceBetweenCoords(player, weaponshopcoords.x, weaponshopcoords.y, weaponshopcoords.z, true) < 10) then
					DrawMarker(1, weaponshopcoords.x, weaponshopcoords.y, weaponshopcoords.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(player,  weaponshopcoords.x, weaponshopcoords.y, weaponshopcoords.z, true) < 2.0) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby otworzyc ~y~Bronie')
						if IsControlPressed(1, 51) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'blackshopweapons_actions') then
							weaponshopmenu()
						end
					end
				end

			end
		end
    end
end)

function infomenu()
	ESX.UI.Menu.CloseAll()
	local elements =
			{
				{label = 'Czarny Sklep - <font color=green>5000$</font>', price = 5000, value = 'blackshop'},
				{label = 'Bronie - <font color=green>15000$</font>', price = 15000, value = 'weaponsblackshop'},
				--{label = 'Karta Dostepu - <font color=green>5000$</font>', value = 'karta'}
			}	
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'blackshopinfo_actions',
		{
			title    = 'Czarny Sklep',
			align    = 'center',
			elements = elements


			}, function(data, menu)
				local item = data.current.value
				local price = data.current.price
				if item == 'blackshop' then
					TriggerServerEvent('sandy_blackshop:buyinfo')
					menu.close()
				elseif item == 'weaponsblackshop' then
					TriggerServerEvent('sandy_blackshop:buyinfoweapons')
					menu.close()
				--[[
				elseif item == 'karta' then
					menu.close()
					ESX.TriggerServerCallback('esx_TruckRobbery:canrob', function(status)
						if status == false then
							local policeamount = exports['esx_scoreboard']:counter('police')
							if policeamount > 3 then
								TriggerServerEvent("esx_TruckRobbery:missionAccepted")
							else
								ESX.ShowNotification('Musi byc 4 policjantow na sluzbie!')
							end
						else
							ESX.ShowNotification('~r~Ktos juz wykonal zlecenie na furgonetke!')
						end
					end)
				]]--
				end
		end, function(data, menu)
			menu.close()
	end)
end

function shopmenu()
	TriggerEvent('sandy_blackshop:removedestination')
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('sandy_blackshop:getshopstatus', function(status)
		if status == false then
				TriggerServerEvent('sandy_blackshop:setshopstatus', 'true')
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'blackshop_actions',
					{
						title    = 'Czarny Sklep',
						align    = 'center',
						elements =
						{
							{label = 'Worek na glowe - <font color=green>5000$</font>', price = 5000, value = 'headbag'},
							{label = 'Wiertło - <font color=green>50000$</font>', price = 50000, value = 'drill'},
							{label = 'Kajdanki - <font color=green>10000$</font>', price = 10000, value = 'handcuffs'},
							{label = 'Wytrych - <font color=green>15000$</font>', price = 15000, value = 'wytrych'},
							{label = 'Ładunek Termalny - <b><font color=green>25000$</font></b>', price = 25000, value = 'thermal_charge'},
							{label = 'Wytrych do drzwi - <b><font color=green>25000$</font></b>', price = 25000, value = 'lockpick'},
							{label = 'Laptop do hackowania - <b><font color=green>75000$</font></b>', price = 75000, value = 'laptop_h'},
							{label = 'Magazynek - <b><font color=green>5000$</font></b>', price = 5000,	value = 'pistol_ammo_box'},
							--{label = 'Magazynek Karabin - <b><font color=green>5000$</font></b>', price = 5000,	value = 'rifle_ammo_box'},
							--{label = 'Magazynek Shotgun - <b><font color=green>5000$</font></b>', price = 5000,	value = 'shotgun_ammo_box'},
							--{label = 'Magazynek SMG - <b><font color=green>5000$</font></b>', price = 5000,	value = 'smg_ammo_box'}
						}	
				}, function(data, menu)
					local item = data.current.value
					local price = data.current.price
					if (GetGameTimer() - GUI.Time) > 1000 then
						TriggerServerEvent('sandy_blackshop:purchaseitem', item, price)
					end
					GUI.Time = GetGameTimer()
			end, function(data, menu)
				menu.close()
				TriggerServerEvent('sandy_blackshop:setshopstatus', 'false')
			end)
		else
			ESX.ShowNotification('Sklep jest juz otwarty!')
		end
	end)
end

function weaponshopmenu()
	TriggerEvent('sandy_blackshop:removedestination')
	ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('sandy_blackshop:getshopstatus2', function(status)
			if status == false then
				TriggerServerEvent('sandy_blackshop:setshopstatus2', 'true')
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'blackshopweapons_actions',
					{
						title    = 'Czarny Sklep',
						align    = 'center',
						elements =
						{
							{label = 'Pistol - <font color=green>150000$</font>', price = 150000, value = 'pistol'},
							{label = 'SNS Pistol - <font color=green>100000$</font>', price = 100000, value = 'snspistol'}
						}	
				}, function(data, menu)
					local item = data.current.value
					local price = data.current.price
					if (GetGameTimer() - GUI.Time) > 1000 then
						TriggerServerEvent('sandy_blackshop:purchaseweapon', item, price)
					end
					GUI.Time = GetGameTimer()
			end, function(data, menu)
				menu.close()
				TriggerServerEvent('sandy_blackshop:setshopstatus2', 'false')
			end)
		else
			ESX.ShowNotification('Sklep jest juz otwarty!')
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		if(GetDistanceBetweenCoords(coords, shopcoords.x, shopcoords.y, shopcoords.z, true) < 2.0) then
			isInMarker  = true
		end		
		if(GetDistanceBetweenCoords(coords, weaponshopcoords.x, weaponshopcoords.y, weaponshopcoords.z, true) < 2.0) then
			isInMarker  = true
		end		
		if(GetDistanceBetweenCoords(coords, infobuycoords.x, infobuycoords.y, infobuycoords.z, true) < 2.0) then
			isInMarker  = true
		end		
			
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('sandy_blackshop:setshopstatus', 'false')
		end
	end
end)

RegisterNetEvent('sandy_blackshop:bodyarmor')
AddEventHandler('sandy_blackshop:bodyarmor', function(size)
local playerPed = PlayerPedId()
	if size == 'large' then
		AddArmourToPed(playerPed,50)
    	SetPedArmour(playerPed, 50)
	elseif size == 'small' then
		AddArmourToPed(playerPed,25)
   	 	SetPedArmour(playerPed, 25)
	end
end)
