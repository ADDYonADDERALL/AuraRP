ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local bagonhead = false
local enabled = false
local bag = nil
local isdead = false

RegisterNetEvent('atlantisHeadbag:checkthiskurwe')
AddEventHandler('atlantisHeadbag:checkthiskurwe', function(chujmnieobchodzitojebaneid)
local ktokurwa = chujmnieobchodzitojebaneid
	if bagonhead then
		bagonhead = false
		TriggerEvent('atlantisHeadbag:display', false)
		TriggerServerEvent('atlantisHeadbag:itemhuj', ktokurwa, 'give')
	end
end)

RegisterNetEvent('atlantisHeadbag:checkplayers')
AddEventHandler('atlantisHeadbag:checkplayers', function()
local player, distance = ESX.Game.GetClosestPlayer()
local idkurwy = GetPlayerServerId(GetPlayerIndex())
	if distance ~= -1 and distance <= 1.0 then
		if not IsPedSprinting(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
			TriggerServerEvent('atlantisHeadbag:setbagon', GetPlayerServerId(player), idkurwy)
		end
	else
		ESX.ShowNotification('Brak graczy w pobliżu.')
	end
end)

RegisterNetEvent('atlantisHeadbag:setbag')
AddEventHandler('atlantisHeadbag:setbag', function(idkurwy)
local _idkurwy = idkurwy
	if bagonhead then
		bagonhead = false
		TriggerEvent('atlantisHeadbag:display', false)
		TriggerServerEvent('atlantisHeadbag:woreknaleb', _idkurwy, 0)
	else
		bagonhead = true
		TriggerEvent('atlantisHeadbag:display', true)
		TriggerServerEvent('atlantisHeadbag:woreknaleb', _idkurwy, 1)
	end
end)

RegisterNetEvent('atlantisHeadbag:display')
AddEventHandler('atlantisHeadbag:display', function(value)
	print(value)
	if value == true then
    bag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(bag, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
		enabled = true
	elseif value == false then
		DeleteEntity(bag)
		SetEntityAsNoLongerNeeded(bag)
		enabled = false
	end
  SendNUIMessage({
    display = enabled
  })
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if bagonhead then
			if IsPedSprinting(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedJumping(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedInMeleeCombat(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedHurt(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
		end
	end
end)

AddEventHandler('playerSpawned', function()
	bagonhead = false
	isdead = false
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isdead = true
	  SendNUIMessage({
    display = false
  })
end)
