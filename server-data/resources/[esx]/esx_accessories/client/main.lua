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
	
ESX									= nil
local HasAlreadyEnteredMarker		= false
local LastZone						= nil
local CurrentAction					= nil
local CurrentActionMsg				= ''
local CurrentActionData				= {}
local isDead						= false
local HasPaid						= false
local lastSkin = {}
local newSkin = {}
local clearSkinMale = {
	['tshirt_1'] = 15,
	['tshirt_2'] = 0,
	['torso_1'] = 15,
	['torso_2'] = 0,
	['chain_1'] = 0,
	['chain_2'] = 0,
	['arms'] = 15,
	['arms_2'] = 0,
	['pants_1'] = 61,
	['pants_2'] = 0,
	['shoes_1'] = 34,
	['shoes_2'] = 0,
	['helmet_1'] = -1,
	['helmet_2'] = 0,
	['ears_1'] = -1,
	['ears_2'] = 0,
	['mask_1'] = 0,
	['mask_2'] = 0,
	['bproof_1'] = 0,
	['bproof_2'] = 0,
	['glasses_1'] = 0,
	['glasses_2'] = 0,
	['bags_1'] = 0,
	['bags_2'] = 0,
	['watches_1'] = -1,
	['watches_2'] = 0,
	['bracelets_1'] = -1,
	['bracelets_2'] = 0,
	['decals_1'] = 0,
	['decals_2'] = 0,
}

local clearSkinFemale = {
	['tshirt_1'] = 14,
	['tshirt_2'] = 0,
	['torso_1'] = 15,
	['torso_2'] = 0,
	['chain_1'] = 0,
	['chain_2'] = 0,
	['arms'] = 15,
	['arms_2'] = 0,
	['pants_1'] = 15,
	['pants_2'] = 0,
	['shoes_1'] = 35,
	['shoes_2'] = 0,
	['helmet_1'] = -1,
	['helmet_2'] = 0,
	['ears_1'] = -1,
	['ears_2'] = 0,
	['mask_1'] = 0,
	['mask_2'] = 0,
	['bproof_1'] = 0,
	['bproof_2'] = 0,
	['glasses_1'] = 5,
	['glasses_2'] = 0,
	['bags_1'] = 0,
	['bags_2'] = 0,
	['watches_1'] = -1,
	['watches_2'] = 0,
	['bracelets_1'] = -1,
	['bracelets_2'] = 0,
	['decals_1'] = 0,
	['decals_2'] = 0,
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local whichSkin = nil
local updatedSkin = {}
local set = true
function OpenAccessoryMenu()
	UpdateSkin()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'set_unset_accessory',
	{
		title = _U('set_unset'),
		align    = 'center',
		elements = {
			{label = 'Czapka / Kask', value = 'helmet_1', value2 = 'helmet_2', lib = 'missheistdockssetup1hardhat@', anim  = 'put_on_hat', duration = -1, loop = 56 },
			{label = 'Kolczyki / Akcesoria', 		value = 'ears_1', value2 = 'ears_2', lib = 'anim@amb@nightclub@djs@switch@tale_djset_switchover@', anim  = 'tale_start_mm', duration = 2800, loop = 56 },
			{label = 'Maska', 		value = 'mask_1', value2 = 'mask_2', lib = 'mp_masks@standard_car@rds@', anim  = 'put_on_mask', duration = -1, loop = 56 },
			{label = 'Okulary', 	value = 'glasses_1', value2 = 'glasses_2', lib = 'clothingspecs', anim  = 'try_glasses_negative_b', duration = 1300, loop = 56 },
			{label = 'Tors / Ręce',value = 'tshirt_1', value2 = 'tshirt_2', lib = 'clothingshirt', anim  = 'try_shirt_positive_d', duration = 2500, loop = 56 },
			{label = 'Kamizelka',value = 'bproof_1', value2 = 'bproof_2', lib = 'clothingshirt', anim  = 'try_shirt_positive_d', duration = 2500, loop = 56 },
			{label = 'Szyja',		value = 'chain_1', value2 = 'chain_2', lib = 'clothingtie', anim  = 'try_tie_positive_a', duration = 3250, loop = 56 },
			{label = 'Zegarek',		value = 'watches_1', value2 = 'watches_2', lib = 'anim@random@shop_clothes@watches', anim  = 'idle_d', duration = 1600, loop = 56 },
			{label = 'Bransoletka',	value = 'bracelets_1', value2 = 'bracelets_2', lib = 'clothingshirt', anim  = 'try_shirt_negative_c', duration = 800, loop = 56 },
			{label = 'Spodnie',		value = 'pants_1', value2 = 'pants_2', lib = 'clothingtrousers', anim  = 'try_trousers_neutral_c', duration = 2700, loop = 0 },
			{label = 'Buty', 		value = 'shoes_1', value2 = 'shoes_2', lib = 'clothingshoes', anim  = 'try_shoes_positive_d', duration = 2400, loop = 0 },
			{label = 'Torba / Plecak',value = 'bags_1', value2 = 'bags_2', lib = 'skydive@parachute@', anim  = 'chute_off', duration = -1, loop = 56 },
		}
	},
	function(data, menu)
		UpdateSkin()
		local currentData = data.current
		if currentData.lib ~= '' and currentData.anim ~= '' then
			PA(currentData.lib, currentData.anim, currentData.duration, currentData.loop)
		end
		whichSkin = tostring(currentData.value)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 and (updatedSkin[currentData.value] ~= clearSkinMale[currentData.value] or currentData.value == 'tshirt_1' and updatedSkin[currentData.value] == 15 and updatedSkin['torso_1'] ~= 15) then
				newSkin[currentData.value] = clearSkinMale[currentData.value]
				if currentData.value == 'tshirt_1' then
					newSkin['arms'] = clearSkinMale['arms']
					newSkin['arms_2'] = clearSkinMale['arms_2']
					newSkin['torso_1'] = clearSkinMale['torso_1']
					newSkin['torso_2'] = clearSkinMale['torso_2']
					newSkin['decals_1'] = clearSkinMale['decals_1']
					newSkin['decals_2'] = clearSkinMale['decals_2']
				end
				if currentData.value == 'bproof_1' then
					newSkin['bproof_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'shoes_1' then
					newSkin['shoes_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'watches_1' then
					newSkin['watches_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'helmet_1' then
					newSkin['helmet_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'ears_1' then
					newSkin['ears_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'mask_1' then
					newSkin['mask_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'glasses_1' then
					newSkin['glasses_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'bracelets_1' then
					newSkin['bracelets_2'] = clearSkinMale[currentData.value2]
				end
				if currentData.value == 'tshirt_1' and updatedSkin[currentData.value] == 15 and updatedSkin['torso_1'] ~= 15 then
					newSkin['torso_1'] = clearSkinMale['torso_1']
					newSkin['torso_2'] = clearSkinMale['torso_2']
					--print(newSkin['torso_1'] )
				end
				if currentData.value2 ~= '' and  currentData.value2 ~= 'tshirt_1' then
					newSkin[currentData.value2] = clearSkinMale[currentData.value2]
				end
				
				--print(currentData.value .. " " .. updatedSkin[currentData.value] .. " ".. updatedSkin['watches_1'])
			elseif skin.sex == 1 and (updatedSkin[currentData.value] ~= clearSkinFemale[currentData.value] or currentData.value == 'tshirt_1' and updatedSkin[currentData.value] == 14 and updatedSkin['torso_1'] ~= 15) then
				newSkin[currentData.value] = clearSkinFemale[currentData.value]
				if currentData.value == 'tshirt_1' then
					newSkin['arms'] = clearSkinFemale['arms']
					newSkin['arms_2'] = clearSkinFemale['arms_2']
					newSkin['torso_1'] = clearSkinFemale['torso_1']
					newSkin['torso_2'] = clearSkinFemale['torso_2']
					newSkin['decals_1'] = clearSkinFemale['decals_1']
					newSkin['decals_2'] = clearSkinFemale['decals_2']
				end
				if currentData.value == 'bproof_1' then
					newSkin['bproof_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'shoes_1' then
					newSkin['shoes_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'watches_1' then
					newSkin['watches_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'helmet_1' then
					newSkin['helmet_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'ears_1' then
					newSkin['ears_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'mask_1' then
					newSkin['mask_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'glasses_1' then
					newSkin['glasses_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'bracelets_1' then
					newSkin['bracelets_2'] = clearSkinFemale[currentData.value2]
				end
				if currentData.value2 ~= '' then
					newSkin[currentData.value2] = clearSkinFemale[currentData.value2]
				end
				if currentData.value == 'tshirt_1' and updatedSkin[currentData.value] == 14 and updatedSkin['torso_1'] ~= 15 then
					newSkin['torso_1'] = clearSkinFemale['torso_1']
					newSkin['torso_1'] = clearSkinFemale['torso_2']
				end
			else
				newSkin[currentData.value] = lastSkin[currentData.value]
				if currentData.value == 'tshirt_1' then
					newSkin['torso_1'] = lastSkin['torso_1']
					newSkin['torso_2'] = lastSkin['torso_2']
					newSkin['arms'] = lastSkin['arms']
					newSkin['arms_2'] = lastSkin['arms_2']
					newSkin['decals_1'] = lastSkin['decals_1']
					newSkin['decals_2'] = lastSkin['decals_2']

				end
				if currentData.value2 ~= '' then
					local replaceValue = currentData.value2
					replaceValue = replaceValue:gsub("1", "2")
					newSkin[currentData.value2] = lastSkin[currentData.value2]
					newSkin[replaceValue] = lastSkin[replaceValue]
				end
			end
			Wait(1000)
			TriggerEvent('skinchanger:loadClothes', skin, newSkin)
		end)
	end,
	function(data, menu)
		menu.close()
	end)
end

--[[local fix = false

RegisterCommand("naprawskin", function(source, args, rawCommand)
	if not fix then
		ESX.ShowNotification('~g~Rozpoczynasz naprawę skina ~w~wpisz komendę ponownie jeżeli skin już się naprawi!')
	else
		ESX.ShowNotification('~r~Kończysz naprawę skina! ~w~Ułatwiliśmy Ci życie :)')
	end
	fix = not fix
end, false)

Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	while true do
		Citizen.Wait(0)
		if fix then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin) 
			end)
			SetPedComponentVariation(player, 1, 1, 0, 2)
			Citizen.Wait(200)
			SetPedComponentVariation(player, 1, 0, 0, 2)
			Citizen.Wait(200)
		end
	end
end)]]

function UpdateSkin()
	TriggerEvent('skinchanger:getSkin', function(skin)
		updatedSkin = skin
		newSkin = skin
		if skin.sex == 0 then
			for i in pairs(skin) do
				if lastSkin[i] == nil then
					lastSkin[i] = skin[i]
				elseif clearSkinMale[i] ~= nil and skin[i] ~= clearSkinMale[i] then
					lastSkin[i] = skin[i]
				end
			end
		else
			for i in pairs(skin) do
				if lastSkin[i] == nil then
					lastSkin[i] = skin[i]
				elseif clearSkinFemale[i] ~= nil and skin[i] ~= clearSkinFemale[i] then
					lastSkin[i] = skin[i]
				end
			end
		end
	end)
end

function PA(lib, anim, duration, loop)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded(lib) do
		Citizen.Wait(10)
	end
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, duration, loop, 0, 0, 0, 0)
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)
		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0	  
				if _accessory == "mask" then
					mAccessory = 0
				end
				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end
				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			ESX.ShowNotification(_U('no_' .. _accessory))
		end
	end, accessory)
end

function OpenShopMenu(accessory)
	local _accessory = string.lower(accessory)
	local restrict = {}
	HasPaid = false
	restrict = { _accessory .. '_1', _accessory .. '_2' }
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_purchase'),
				align    = 'right',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'}
				}
			},
			function(data, menu)
				menu.close()
				if data.current.value == 'yes' then
					ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
						if hasEnoughMoney then
							TriggerServerEvent('esx_accessories:pay')
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_accessories:save', skin, accessory)
								HasPaid = true
							end)
						else
							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end)
				end
				if data.current.value == 'no' then
					local player = GetPlayerPed(-1)
					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					if accessory == "Ears" then
						ClearPedProp(player, 2)
					elseif accessory == "Mask" then
						SetPedComponentVariation(player, 1, 0 ,0 ,2)
					elseif accessory == "Helmet" then
						ClearPedProp(player, 0)
					elseif accessory == "Glasses" then
						SetPedPropIndex(player, 1, -1, 0, 0)
					end
				end
				CurrentAction	 = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}
			end,
			function(data, menu)
				menu.close()
				CurrentAction	 = 'shop_menu'
				CurrentActionMsg  = _U('press_access')
				CurrentActionData = {}

			end)
	end, 
	function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_access')
		CurrentActionData = {}
	end, restrict)
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('esx_accessories:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	TriggerEvent('esx_tattooshop:refreshTattoos')

		if not HasPaid then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin) 
		end)

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and CurrentActionData.accessory ~= nil then
				OpenShopMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		end
		if Config.EnableControls then
			if IsControlPressed(0, Keys['F10']) and GetLastInputMethod(2) and not isDead then
				OpenAccessoryMenu()
			end
		end
	end
end)

RegisterCommand("fixpostac", function(source, args, rawCommand)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)