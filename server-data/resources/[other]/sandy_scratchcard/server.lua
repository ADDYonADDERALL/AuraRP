ESX = nil

local chance = 60 -- chance to win 100-60= 40%

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('scratchcard', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local rndm = math.random(1,100)
	local wygrana = 0
	xPlayer.removeInventoryItem('scratchcard', 1)
	TriggerClientEvent('sandy_scratchcard:anim', src)
	TriggerClientEvent('esx:showNotification', src, 'Sprawdzasz Zdrapke...')
	Citizen.Wait(1000)
	if rndm >= chance then
		local rndm2 = math.random(1,100)
		if rndm2 >= 1 and rndm2 <= 50 then
			wygrana = 15000
		elseif rndm2 >= 51 and rndm2 <= 75 then
			wygrana = 20000
		elseif rndm2 >= 76 and rndm2 <= 99 then
			wygrana = 25000
		elseif rndm2 > 99 then
			wygrana = 100000
		end
		TriggerClientEvent('esx:showNotification', src, 'WYGRANA! '..wygrana..'$')
		TriggerClientEvent('sandy_scratchcard:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		xPlayer.addMoney(wygrana)
	else
		TriggerClientEvent('sandy_scratchcard:Sound', src, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		TriggerClientEvent('esx:showNotification', src, 'Pusto! Sprobuj ponownie')
	end
end)

ESX.RegisterUsableItem('scratchcard2', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local rndm = math.random(1,100)
	local wygrana = 0
	xPlayer.removeInventoryItem('scratchcard2', 1)
	TriggerClientEvent('sandy_scratchcard:anim', src)
	TriggerClientEvent('esx:showNotification', src, 'Sprawdzasz Zdrapke...')
	Citizen.Wait(1000)
	if rndm >= chance then
		local rndm2 = math.random(1,100)
		if rndm2 >= 1 and  rndm2<= 50 then
			wygrana = 37500
		elseif rndm2 >= 51 and rndm2 <= 75 then
			wygrana = 50000
		elseif rndm2 >= 76 and rndm2 <= 99 then
			wygrana = 62500
		elseif rndm2 > 99 then
			wygrana = 250000
		end
		TriggerClientEvent('esx:showNotification', src, 'WYGRANA! '..wygrana..'$')
		TriggerClientEvent('sandy_scratchcard:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		xPlayer.addMoney(wygrana)
	else
		TriggerClientEvent('sandy_scratchcard:Sound', src, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		TriggerClientEvent('esx:showNotification', src, 'Pusto! Sprobuj ponownie')
	end
end)

ESX.RegisterUsableItem('scratchcard3', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local rndm = math.random(1,100)
	local wygrana = 0
	xPlayer.removeInventoryItem('scratchcard3', 1)
	TriggerClientEvent('sandy_scratchcard:anim', src)
	TriggerClientEvent('esx:showNotification', src, 'Sprawdzasz Zdrapke...')
	Citizen.Wait(1000)
	if rndm >= chance then
		local rndm2 = math.random(1,100)
		if rndm2 >= 1 and rndm2 <= 50 then
			wygrana = 75000
		elseif rndm2 >= 51 and rndm2 <= 75 then
			wygrana = 100000
		elseif rndm2 >= 76 and rndm2 <= 99 then
			wygrana = 125000
		elseif rndm2 > 99 then
			wygrana = 500000
		end
		TriggerClientEvent('esx:showNotification', src, 'WYGRANA! '..wygrana..'$')
		TriggerClientEvent('sandy_scratchcard:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		xPlayer.addMoney(wygrana)
	else
		TriggerClientEvent('sandy_scratchcard:Sound', src, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		TriggerClientEvent('esx:showNotification', src, 'Pusto! Sprobuj ponownie')
	end
end)

ESX.RegisterUsableItem('zapalniczka', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local smoke = xPlayer.getInventoryItem('cigarette').count
    local zapalniczka = xPlayer.getInventoryItem('zapalniczka').count
    if smoke >= 1 then
        xPlayer.removeInventoryItem('cigarette', 1)
        TriggerClientEvent('esx_cigarette:startSmoke', source)
        TriggerClientEvent('esx:showNotification', source, 'Odpalasz papierosa przy uzyciu zapalniczki!')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'wyciąga papierosa z kieszeni i odpala', source)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz papierosów!')
    end
end)

ESX.RegisterUsableItem('bletka', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local smoke = xPlayer.getInventoryItem('weed_pooch').count
    local smoke2 = xPlayer.getInventoryItem('weedindica_pooch').count
    local zapalniczka = xPlayer.getInventoryItem('zapalniczka').count
    if smoke > 0 then
        xPlayer.removeInventoryItem('bletka', 1)
        xPlayer.removeInventoryItem('weed_pooch', 1)
        TriggerClientEvent('esx:showNotification', source, 'Zaczynasz kręcic jointa z marihuany!')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Zaczyna kręcic jointa z marihuany...', source)
        TriggerClientEvent('robienie', source, true)
        Citizen.Wait(10000)
        TriggerClientEvent('esx:showNotification', source, 'Skręciłeś jointa z marihuany!')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Chowa skręconego jointa do kieszeni', source)
        xPlayer.addInventoryItem('joint', 1)
        TriggerClientEvent('robienie', source, false)
    elseif smoke2 > 0 then
        xPlayer.removeInventoryItem('bletka', 1)
        xPlayer.removeInventoryItem('weedindica_pooch', 1)
        TriggerClientEvent('esx:showNotification', source, 'Zaczynasz kręcic jointa z marihuany!')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Zaczyna kręcic jointa z marihuany...', source)
        TriggerClientEvent('robienie', source, true)
        Citizen.Wait(10000)
        TriggerClientEvent('esx:showNotification', source, 'Skręciłeś jointa z marihuany!')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'Chowa skręconego jointa do kieszeni', source)
        xPlayer.addInventoryItem('jointindica', 1)
        TriggerClientEvent('robienie', source, false)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie masz nic do skręcenia!')
    end
end)

ESX.RegisterUsableItem('joint', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zapalniczka = xPlayer.getInventoryItem('zapalniczka').count
    if zapalniczka > 0 then
        TriggerClientEvent('esx_drugeffects:onMarijuana', _source)
        TriggerClientEvent('esx:showNotification', _source, 'zapalasz skręta')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'zapala skręta', _source)
        xPlayer.removeInventoryItem('joint', 1)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz zapalniczki!')
    end
end)

ESX.RegisterUsableItem('jointindica', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zapalniczka = xPlayer.getInventoryItem('zapalniczka').count
    if zapalniczka > 0 then
        TriggerClientEvent('sandy_scratchcard:lemonhazeblunt', _source)
        TriggerClientEvent('esx:showNotification', _source, 'zapalasz skręta')
        TriggerClientEvent('3dme:triggerDisplay', -1, 'zapala skręta', _source)
        xPlayer.removeInventoryItem('jointindica', 1)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz zapalniczki!')
    end
end)

ESX.RegisterUsableItem('opium_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('opium_pooch', 1)

	TriggerClientEvent('esx_drugeffects:onOpium', source)
end)

ESX.RegisterUsableItem('meth_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('meth_pooch', 1)

	TriggerClientEvent('esx_drugeffects:onMeth', source)
end)

ESX.RegisterUsableItem('coke_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke_pooch', 1)

	TriggerClientEvent('esx_drugeffect:runMan', source)
end)

ESX.RegisterUsableItem('crack_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('crack_pooch', 1)

	TriggerClientEvent('esx_drugeffects:onCrack', source)
end)

RegisterServerEvent('orchard:job1a')
AddEventHandler('orchard:job1a', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local total = math.random(0, 10)
	apple = xPlayer.getInventoryItem('apple')

	if apple.count >= 40 then
		TriggerClientEvent('esx:showNotification', _source, 'Masz juz maksymalna ilosc!')
	else
		if apple.count >= 30 then
			quickmafs = math.abs(apple.count - 40) 
			xPlayer.addInventoryItem('apple', quickmafs)
		else 
			xPlayer.addInventoryItem('apple', 10)
		end
	end
end)