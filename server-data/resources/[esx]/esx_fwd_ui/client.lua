local isTalking = false
local talkingTrigger = false

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

RegisterNetEvent('esx_customui:talking')
AddEventHandler('esx_customui:talking', function(prox)
	SendNUIMessage({action = "setProximity", value = prox})
end)

RegisterNetEvent('esx_customui:istalking')
AddEventHandler('esx_customui:istalking', function(istalkingrly)
	talkingTrigger = true
	if istalkingrly then
		isTalking = true
	else
		isTalking = false
	end
end)

RegisterCommand("cam", function(source, args, raw)
	cam = not cam
	if cam then
		TriggerEvent("aurarp:displayid", false)
		TriggerEvent("chat:CinemaMode", true)
		SendNUIMessage({action = "hideui"})
		TriggerEvent("chat:display", false)
		TriggerEvent("carhud:display", false)
		TriggerEvent("wyspa:setDisplayStreet", false)
	elseif not cam then
		TriggerEvent("aurarp:displayid", true)
		TriggerEvent("chat:CinemaMode", false)
		SendNUIMessage({action = "showui"})
		TriggerEvent("chat:display", true)
		TriggerEvent("carhud:display", true)
		TriggerEvent("wyspa:setDisplayStreet", true)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		--TriggerEvent('es:setMoneyDisplay', 0.0)
		--ESX.UI.HUD.SetDisplay(0.0)
		if talkingTrigger then
			if isTalking == false then
					SendNUIMessage({action = "setTalking", value = false})
			else

					SendNUIMessage({action = "setTalking", value = true})
			end
			talkingTrigger = false
		end
	end
end)

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)

		if cam then

			DisplayRadar(false)
      		HideHelpTextThisFrame()
      		HideHudAndRadarThisFrame()
			HideHudComponentThisFrame(5)
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)

		end

	end

end)
