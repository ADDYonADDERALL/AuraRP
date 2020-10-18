local peopleintrunk = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent( "sandycarmenu:SetVehicleWindow" )
AddEventHandler( "sandycarmenu:SetVehicleWindow", function(windowsDown,window)
  TriggerClientEvent( "kurwavehiclewidnow", -1, source, windowsDown, window)
end)

RegisterServerEvent( "sandy_carcontrols:checkpilotpermissions" )
AddEventHandler( "sandy_carcontrols:checkpilotpermissions", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if IsPlayerAceAllowed(source, "rgb.pilot") then
        TriggerClientEvent('sandy_carcontrols:setpermissions', source, true)
        TriggerClientEvent('sandy_cinema:setpermissions', source, true)
    else
        TriggerClientEvent('sandy_carcontrols:setpermissions', source, false)
        TriggerClientEvent('sandy_cinema:setpermissions', source, false)
    end
end)

ESX.RegisterServerCallback('sandy_trunk:checkifanyoneintrunk', function(source, cb, plate)
	local found = false
	for i=1,#peopleintrunk,1 do
		if peopleintrunk[i].plate == plate then
			print('occupied '..plate)
			found = true
			cb(true)
   		end 
	end
	if not found then
		table.insert(peopleintrunk, {
			plate = plate,
		})
		print('added '..plate)
		cb(false)
	end
end)	

RegisterServerEvent("sandy_trunk:removefromtrunk")
AddEventHandler("sandy_trunk:removefromtrunk", function(plate)
	for i=1,#peopleintrunk,1 do
		if peopleintrunk[i].plate == plate then
			print('removed '..plate)
			table.remove(peopleintrunk, i)
   		end 
	end
end)