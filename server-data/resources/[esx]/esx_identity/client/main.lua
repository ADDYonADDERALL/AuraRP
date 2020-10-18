local guiEnabled = false
local myIdentity = {}
local myIdentifiers = {}
local hasIdentity = false
local isDead = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function EnableGui(state)
	SetEntityCoords(GetPlayerPed(-1), -1037.66, -2737.81, 20.16)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state
	})
end

RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	if not isDead then
		EnableGui(true)
	end
end)

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('escape', function(data, cb)
	if hasIdentity then
		EnableGui(false)
	else
		TriggerEvent('chat:addMessage', { args = { '^1[IDENTITY]', '^1Stworz swoja postac aby grac!' } })
	end
end)

RegisterNUICallback('register', function(data, cb)
	local reason = ""
	myIdentity = data
	for theData, value in pairs(myIdentity) do
		print(theData, value)
		if theData == "firstname" or theData == "lastname" then
			reason = verifyName(value)
			
			if reason ~= "" then
				break
			end
		--elseif theData == "dateofbirth" then
		--	if value == "invalid" then
		--		reason = "Invalid date of birth!"
		--		break
		--	end
		elseif theData == "height" then
			local height = tonumber(value)
			if height then
				if height > 200 or height < 140 then
					reason = "Musisz podac prawidlowy wzrost!"
					break
				end
			else
				reason = "Musisz podac prawidlowy wzrost!"
				break
			end
		end
	end
	
	if reason == "" then
		local plate = GeneratePlate()
		TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers, plate)
		EnableGui(false)
		ESX.SetTimeout(2500, function()
			TriggerEvent('esx_skin:openSaveableRestrictedMenu', myIdentifiers.id)
		end)
	else
		ESX.ShowNotification(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		if guiEnabled then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		end
		Citizen.Wait(10)
	end
end)

function verifyName(name)
	-- Don't allow short user names
	local nameLength = string.len(name)
	if nameLength > 25 or nameLength < 2 then
		return 'Nieprawidlowe Imie postaci.'
	end
	
	-- Don't allow special characters (doesn't always work)
	local count = 0
	for i in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do
		count = count + 1
	end
	if count ~= nameLength then
		return 'Imie zawiera niedozwolone znaki.'
	end
	
	-- Does the player carry a first and last name?
	-- 
	-- Example:
	-- Allowed:     'Bob Joe'
	-- Not allowed: 'Bob'
	-- Not allowed: 'Bob joe'
	local spacesInName    = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, '%S+') do

		if string.match(word, '%u') then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 2 then
		return 'Imie zawiera wiecej niz 2 spacje'
	end
	
	if spacesWithUpper ~= spacesInName then
		return 'Imie musi sie zaczynac duza litera.'
	end

	return ''
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())

		generatedPlate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))

		ESX.TriggerServerCallback('d3x_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('d3x_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
