ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersTransformingWeedIndica  = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersHarvestingCrack   = {}
local PlayersTransformingCrack = {}
local Zones = {
	CokeField =			{x = -771.92, y = 4302.86, z = 143.19-0.90, name = 'plantacja kokainy',		sprite = 501,	color = 40}, -- ZMIENIONE
	CokeProcessing =	{x = 179.70, y = 2221.51, z = 82.49-0.90, name = 'przerobka lisci kokainy',	sprite = 478,	color = 40}, -- ZMIENIONE

	MethField =			{x = 2434.78, y = 4968.23, z = 42.34-0.90, name = 'laboratorium metamfetaminy',		sprite = 499,	color = 26}, -- ZMIENIONE
	MethProcessing =	{x = 2025.53, y = 4980.75, z = 29.48-0.90, name = 'kruszenie metamfetaminy',	sprite = 499,	color = 26}, -- ZMIENIONE
	
	WeedField =			{x = 2221.76, y = 5577.46, z = 53.83-0.90, name = 'plantacja marihuany',		sprite = 496,	color = 52}, -- ZMIENIONE
    --WeedField2 =		{x = -112.510, y = 1910.096, z = 197.031-0.90, name = 'plantacja marihuany',		sprite = 496,	color = 52}, -- ZMIENIONE
	WeedProcessing =	{x = 380.117, y = -815.38, z = 29.30-0.90, name = 'suszenie marihuany',	sprite = 496,	color = 52}, -- ZMIENIONE
	
	OpiumField =		{x = 1079.51, y = 2236.79, z = 44.57-0.90, name = 'pole opium',		sprite = 496,	color = 52}, -- ZMIENIONE
	OpiumProcessing =	{x = 245.07, y = 370.30, z = 105.73-0.90, name = 'przerobka opium',	sprite = 51,	color = 60}, -- ZMIENIONE

	CrackField =		{x = 980.14, y = -2194.55, z = 31.58-0.90, name = 'pole crack',		sprite = 496,	color = 52}, -- ZMIENIONE
	CrackProcessing =	{x = 1244.88, y = -2572.18, z = 43.05-0.90, name = 'przerobka crack',	sprite = 51,	color = 60}, -- ZMIENIONE
}
local realtrigger = 'BxhqkXd4GKnn'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandy_drugs:refreshdrugs')
AddEventHandler('sandy_drugs:refreshdrugs', function()
	local _source = source
	TriggerClientEvent('sandy_drugs:setplayerdrugs', _source, Zones)
end)

RegisterServerEvent('sandy_drugs:gettrigger')
AddEventHandler('sandy_drugs:gettrigger', function()
	local _source = source
	TriggerClientEvent('sandy_drugs:settrigger', _source, realtrigger)
end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestCoke')
AddEventHandler('esx_veryfunstuff:startHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif cokeQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
			else
				xPlayer.removeInventoryItem('coke', 3)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformCoke')
AddEventHandler('esx_veryfunstuff:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestMeth')
AddEventHandler('esx_veryfunstuff:startHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif methQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
			else
				xPlayer.removeInventoryItem('meth', 3)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformMeth')
AddEventHandler('esx_veryfunstuff:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

RegisterServerEvent('esx_veryfunstuff:stopTransformMeth')
AddEventHandler('esx_veryfunstuff:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

local function HarvestWeed2(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weedindica')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
			else
				xPlayer.addInventoryItem('weedindica', 1)
				HarvestWeed2(source)
			end

		end
	end)
end


RegisterServerEvent('esx_veryfunstuff:startHarvestWeed')
AddEventHandler('esx_veryfunstuff:startHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source)

end)

RegisterServerEvent('esx_veryfunstuff:startHarvestWeed2')
AddEventHandler('esx_veryfunstuff:startHarvestWeed2', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed2(_source)

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weed', 3)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

local function TransformWeedIndica(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeedIndica[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weedindica').count
			local poochQuantity = xPlayer.getInventoryItem('weedindica_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif weedQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
			else
				xPlayer.removeInventoryItem('weedindica', 3)
				xPlayer.addInventoryItem('weedindica_pooch', 1)
				TransformWeedIndica(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformWeed')
AddEventHandler('esx_veryfunstuff:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

RegisterServerEvent('esx_veryfunstuff:startTransformWeedIndica')
AddEventHandler('esx_veryfunstuff:startTransformWeedIndica', function()

	local _source = source

	PlayersTransformingWeedIndica[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeedIndica(_source)

end)

--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestOpium')
AddEventHandler('esx_veryfunstuff:startHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif opiumQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('opium', 3)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformOpium')
AddEventHandler('esx_veryfunstuff:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

-- crack

local function HarvestCrack(source)

	if CopsConnected < Config.RequiredCopsCrack then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCrack))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCrack[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local crack = xPlayer.getInventoryItem('crack')

			if crack.limit ~= -1 and crack.count >= crack.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_crack'))
			else
				xPlayer.addInventoryItem('crack', 1)
				HarvestCrack(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startHarvestCrack')
AddEventHandler('esx_veryfunstuff:startHarvestCrack', function()

	local _source = source

	PlayersHarvestingCrack[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCrack(_source)

end)

local function TransformCrack(source)

	if CopsConnected < Config.RequiredCopsCrack then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCrack))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCrack[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local crackQuantity = xPlayer.getInventoryItem('crack').count
			local poochQuantity = xPlayer.getInventoryItem('crack_pooch').count

			if poochQuantity > 99 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif crackQuantity < 3 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
			else
				xPlayer.removeInventoryItem('crack', 3)
				xPlayer.addInventoryItem('crack_pooch', 1)
			
				TransformCrack(source)
			end

		end
	end)
end

RegisterServerEvent('esx_veryfunstuff:startTransformCrack')
AddEventHandler('esx_veryfunstuff:startTransformCrack', function()

	local _source = source

	PlayersTransformingCrack[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCrack(_source)

end)

RegisterServerEvent('esx_veryfunstuff:GetUserInventory')
AddEventHandler('esx_veryfunstuff:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_veryfunstuff:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count,
		xPlayer.getInventoryItem('weedindica').count, 
		xPlayer.getInventoryItem('weedindica_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.getInventoryItem('crack').count, 
		xPlayer.getInventoryItem('crack_pooch').count,
		xPlayer.job.name, 
		currentZone
	)
end)

RegisterServerEvent('esx_veryfunstuff:wstrzymajkierownice')
AddEventHandler('esx_veryfunstuff:wstrzymajkierownice', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false
	PlayersTransformingCoke[_source] = false
	PlayersHarvestingOpium[_source] = false
	PlayersTransformingOpium[_source] = false
	PlayersTransformingWeed[_source] = false
	PlayersHarvestingWeed[_source] = false
	PlayersTransformingWeedIndica[_source] = false
	PlayersHarvestingMeth[_source] = false
	PlayersTransformingMeth[_source] = false
	PlayersHarvestingCrack[_source] = false
	PlayersTransformingCrack[_source] = false


end)
