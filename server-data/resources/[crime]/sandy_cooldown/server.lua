local time = 60
local timer = 0
local block = false

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandy_cooldown:block')
AddEventHandler('sandy_cooldown:block', function(status)
    if status == true then
        block = true
        timer = time
    else
        block = false
    end
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

RegisterServerEvent('sandy_cooldown:gettimer')
AddEventHandler('sandy_cooldown:gettimer', function()
	local _source = source
	if timer ~= 0 then
		TriggerClientEvent('sandy_cooldown:showtimer', _source, timer)
	end
end)

ESX.RegisterServerCallback('sandy_cooldown:canrob', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local data = block
  cb(data)
end)
