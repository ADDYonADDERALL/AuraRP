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

local GUI						= {}
GUI.Time						= 0

local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local currentTattoos			= false
local cam						= -1

ESX								= nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function drawTattoos()
	local ped = PlayerPedId()

	local any = false
	for i, k in pairs(currentTattoos) do
		if not k.category then
			local migrate = Config.OldTattooList[k.collection][k.texture]
			for category, list in ipairs(Config.TattooList) do
				for texture, data in ipairs(list) do
					if data.collectionHash == k.collection and data.nameHash == migrate.nameHash then
						k = {
							category = category,
							texture = texture
						}
						if not any then
							any = true
						end

						currentTattoos[i] = k
						break
					end
				end
			end
		end

		if not k.category then
			table.remove(currentTattoos, i)
			if not any then
				any = true
			end
		else
			local data = Config.TattooList[k.category][k.texture]
			ApplyPedOverlay(ped, GetHashKey(data.collectionHash), GetHashKey(data.nameHash))
		end
	end

	if any then
		ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success) end, currentTattoos, 0, nil)
	end
end

AddEventHandler('skinchanger:modelComplete', function()
	if not currentTattoos then
		currentTattoos = true
		ESX.TriggerServerCallback('esx_tattooshop:getTattoos', function(tattooList)
			currentTattoos = tattooList
			drawTattoos()
		end)
	elseif type(currentTattoos) == 'table' then
		drawTattoos()
	end
end)

RegisterNetEvent('esx_tattooshop:setTattoos')
AddEventHandler('esx_tattooshop:setTattoos', function(tattooList)
	currentTattoos = tattooList
end)

function OpenShopMenu()
	local elements = {}
	for i, name in pairs(Config.TattooCategories) do
		if #Config.TattooList[i] > 0 then
			table.insert(elements, {label = name, value = i})
		end
	end

	table.insert(elements, {label = 'Usuń tatuaże ' .. _U('money_amount', Config.ClearPrice), value = 'clear', price = Config.ClearPrice})
	if Config.LockCam and DoesCamExist(cam) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop', {
		title    = _U('tattoos'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local currentLabel, currentValue = data.current.label, data.current.value
		if currentValue == 'clear' then
			ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
				if success then
					menu.close()
					currentTattoos = {}
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end
			end, {}, data.current.price, nil)
		elseif currentValue ~= nil then
			elements = { {label = _U('go_back_to_menu'), value = nil} }
			for i, k in pairs(Config.TattooList[currentValue]) do
				table.insert(elements, {
					label = _U('tattoo_item', i, _U('money_amount', k.price)),
					value = i,
					price = k.price
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				title    = _U('tattoos') .. ' | ' .. currentLabel,
				align    = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				if data2.current.value ~= nil then
					ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
						if success then
							table.insert(currentTattoos, {category = currentValue, texture = data2.current.value})
						end
					end, currentTattoos, data2.current.price, {category = currentValue, texture = data2.current.value})
				else
					OpenShopMenu()
					if Config.LockCam then
						RenderScriptCams(false, false, 0, 1, 0)
						DestroyCam(cam, false)
					end

					setPedSkin()
				end
			end, function(data2, menu2)
				menu2.close()
				if Config.LockCam then
					RenderScriptCams(false, false, 0, 1, 0)
					DestroyCam(cam, false)
				end

				setPedSkin()
			end, function(data2, menu2) -- when highlighted
				if data2.current.value ~= nil then
					menu2.close()
					drawTattoo(currentValue, data2.current.value)
					menu2.open()
				end
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	for k, v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('tattoo_shop'))
		EndTextCommandSetBlipName(blip)
		Citizen.Wait(0)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Config.Zones) do
			if (Config.Type ~= -1 and #(coords - vec3(v.x, v.y, v.z)) < Config.DrawDistance) then
				DrawMarker(Config.Type, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
  end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k, v in pairs(Config.Zones) do
			if #(coords - vec3(v.x, v.y, v.z)) < Config.Size.x then
				isInMarker  = true
				currentZone = 'TattooShop'
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_tattooshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_tattooshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('esx_tattooshop:hasEnteredMarker', function(zone)
	if zone == 'TattooShop' then
		CurrentAction     = 'tattoo_shop'
		CurrentActionMsg  = _U('tattoo_shop_prompt')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('esx_tattooshop:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	setPedSkin() -- make sure this triggers
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'tattoo_shop' then
					OpenShopMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)

function setPedSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end

function drawTattoo(category, texture)
	local process = function(ped)
		SetEntityHeading(ped, 297.7296)

		local data = Config.TattooList[category][texture]
		ApplyPedOverlay(ped, GetHashKey(data.collectionHash), GetHashKey(data.nameHash))
		if Config.LockCam then
			local coords = GetEntityCoords(ped)
			if not DoesCamExist(cam) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
				SetCamCoord(cam, ped)
				SetCamRot(cam, 0.0, 0.0, 0.0)

				SetCamActive(cam, true)
				RenderScriptCams(true, false, 0, true, true)
				SetCamCoord(cam, ped)
			end

			local x,y,z = table.unpack(coords)
			SetCamCoord(cam, x + data.addedX, y + data.addedY, z + data.addedZ)
			SetCamRot(cam, 0.0, 0.0, data.rotZ)
		end
	end

	local pid = PlayerPedId()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 0,
				helmet_1 = -1,
				helmet_2 = 0,
				torso_1  = 15,
				torso_2  = 0,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				decals_1 = 0,
				decals_2 = 0,
				chain_1  = 0,
				chain_2  = 0,
				pants_1  = 61,
				pants_2  = 1,
				shoes_1  = 34,
				shoes_2  = 0,
				bags_1   = 0,
				bags_2   = 0,
				mask_1   = 0,
				mask_2   = 0,
				bproof_1 = 0,
				bproof_2 = 0
			}, function()
				process(pid)
			end)
		else
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 1,
				helmet_1 = -1,
				helmet_2 = 0,
				torso_1  = 15,
				torso_2  = 0,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				decals_1 = 0,
				decals_2 = 0,
				chain_1  = 0,
				chain_2  = 0,
				pants_1  = 15,
				pants_2  = 0,
				shoes_1  = 35,
				shoes_2  = 0,
				bags_1   = 0,
				bags_2   = 0,
				mask_1   = 0,
				mask_2   = 0,
				bproof_1 = 0,
				bproof_2 = 0
			}, function()
				process(pid)
			end)
		end
	end)
end