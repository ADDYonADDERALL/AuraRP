local PlayerData = {}
local runclock = false
local name
local badge
local ispolice = false

ESX = nil

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
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('sandy_bodycam:checkbodycam')
AddEventHandler('sandy_bodycam:checkbodycam', function()
	if not runclock then
		TriggerEvent('sandy_bodycam:setbodycam', 'true')
		ESX.ShowNotification('BODYCAM ~g~wlaczony!')
	elseif runclock then
		TriggerEvent('sandy_bodycam:setbodycam', 'false')
		ESX.ShowNotification('BODYCAM ~r~wylaczony!')
	end
end)

RegisterNetEvent('sandy_bodycam:setbodycam')
AddEventHandler('sandy_bodycam:setbodycam', function(typ)
	TriggerServerEvent('sandy_bodycam:getidentity')
	Wait(1000)
	if typ == 'true' then
		runclock = true
	elseif typ == 'false' then
		runclock = false
	end
end)

RegisterNetEvent('sandy_bodycam:setname')
AddEventHandler('sandy_bodycam:setname', function(namee, badgee, police)
	if police == 'true' then
		name = namee
		badge = badgee
		ispolice = true
	elseif police == 'false' then
		name = namee
		badge = badgee
		ispolice = false
	end
end)

Citizen.CreateThread(function()
Citizen.Wait(0)
    local timer = GetGameTimer()
    while true do
    	Citizen.Wait(5)
    	if runclock then
    		local year, month, day, hour, minute, second = GetUtcTime()
    		if (GetGameTimer() - timer) > 1000 then
				timer = GetGameTimer()
			elseif (GetGameTimer() - timer) > 500 then
				drawTxt(1.400, 0.520, 1.0,1.0,1.5, '.', 255,0,0, 180)
			end
    		drawTxt(1.430, 0.620, 1.0,1.0,0.35, day..'/'..month..'/'..year, 255,255,255, 180)
    		drawTxt(1.4335, 0.600, 1.0,1.0,0.35, hour..':'..minute..':'..second, 255,255,255, 180)
    		if ispolice then
    			drawTxt(1.418, 0.580, 1.0,1.0,0.35, name..' ['..badge..']', 255,255,255, 180)
    		else
    			drawTxt(1.418, 0.580, 1.0,1.0,0.35, name, 255,255,255, 180)
    		end
    		drawTxt(1.425, 0.550, 1.0,1.0,0.55, 'BODYCAM', 255,0,0, 180)
    	end
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end