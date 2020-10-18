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

local medic = vector3(-437.17, -325.42, 34.91-1)
local HasAlreadyEnteredMarker = false

ESX = nil
CurrentActionMsg = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)


-- Create Marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local canSleep, isInMarker, hasExited = true, false, false

    local distance = GetDistanceBetweenCoords(playerCoords, medic, true)

    if distance < Config.DrawDistance then
      DrawMarker(1, medic, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, 250, 250, 0, 200, false, false, 2, Config.Marker.rotate, nil, nil, false)
      canSleep = false
    end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false

		if GetDistanceBetweenCoords(coords, medic, true) < 1.5 then
			isInMarker = true
		end

    if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('ex_insurance:hasEnteredMarker')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('ex_insurance:hasExitedMarker')
		end

	end
end)

AddEventHandler('ex_insurance:hasEnteredMarker', function()
		CurrentAction     = 'insurance_menu'
		CurrentActionMsg  = ('Ubezpieczenie medyczne')
end)

AddEventHandler('ex_insurance:hasExitedMarker', function()
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification('Wciśnij ~INPUT_CONTEXT~ aby otworzyć ~y~Menu ubezpieczen~s~.')

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'insurance_menu' then

          OpenInsuranceMenu()

				end

				CurrentAction = nil
			end
		end
	end
end)

function OpenInsuranceMenu()

  local elements = {}
	ShopOpen = true

  table.insert(elements, {
    label = ('1 dzien - <span style="color: green;">$%s</span>'):format(ESX.Math.GroupDigits(Config.BasicPrice//7*3)),
    price = Config.BasicPrice//7*3,
		days = 1
  })
	for i=1, Config.Weeks, 1 do

	table.insert(elements, {
		label = ('%s tydzien - <span style="color: green;">$%s</span>'):format(i, ESX.Math.GroupDigits(Config.BasicPrice*((100-(Config.Discount*i-Config.Discount))/100)*i)),
		price = Config.BasicPrice*((100-(Config.Discount*i-Config.Discount))/100)*i,
		days = i*7
	})
	end

  table.insert(elements, {
    label = 'Sprawdź swoje ubezpieczenie',
    price = 0
  })


  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title = 'Menu Ubezpieczeń',
		align = 'center',
		elements = elements
	}, function(data, menu)
    if data.current.price > 0 then

			ESX.TriggerServerCallback('ex_insurance:buyInsurance', function(bought)
				menu.close()
			end, data.current.price, data.current.days)
		elseif data.current.price == 0 then
      ESX.TriggerServerCallback('ex_insurance:checkInsurance', function() end, nil)
    end
	end, function(data, menu)
		menu.close()
	end)

	HasAlreadyEnteredMarker = false

end

RegisterCommand('ubezpieczenie', function(source, args)
	local player
		if player == nil then
    player = args[1] or nil

		print(player)
		ESX.TriggerServerCallback('ex_insurance:checkInsurance', function(value) end, player)
	end
end)
