local PlayerData, CurrentAction = {}
local GUI = {}
ESX = nil
GUI.Time = 0
local startthedrugjob = false
local drugblip = nil
local currentdrugemp = nil
local previousjoblocation = nil
local currentjoblocation = nil
local canselldrugs = false
local CurrentCustomerPed = nil
local CurrentCustomerSpawned = nil
local sellingdrugs = false
local drugjobdone = false
local isondrugjob = false
local block = false
local timer = Config.DrugSellTime
local currentscenario = nil
local drugcluster = {}
local drugclusterstolen = {}
local timer2 = 12

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlPressed(0, 168) and PlayerData.job2 and Config.Organizacje[PlayerData.job2.name] and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'organisation_actions') then
        OpenOrganisationActionsMenu()
       end
    end
end)

function OpenOrganisationActionsMenu()
    ESX.UI.Menu.CloseAll()

   	local elements = {
      	{label = 'Kajdanki', value = 'citizen_interaction'},
      	{label = 'Lornetka',        value = 'lornetka'}
    }

    if PlayerData.job2.grade >= 1 then
    	table.insert(elements, {label = 'Daj Zlecenie', value = 'drugrun'})
    	table.insert(elements, {label = 'Zatrzymaj Zlecenie', value = 'stopdrugrun'})
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = 'Organizacja',
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'drugrun' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    		if closestPlayer ~= -1 and closestDistance <= 2.0 then
     			local noofpolice = exports['esx_scoreboard']:counter('police')
     			if noofpolice >= Config.Police then
     				TriggerServerEvent('sandy_org:setdrugjob', GetPlayerServerId(closestPlayer), PlayerData.job2.name)
     			else
     				ESX.ShowNotification('~r~Nie ma wystarczajacej ilosci policji!')
     			end
     		else
     			ESX.ShowNotification('Brak graczy w pobliżu!')
     		end
			menu.close()
		end
		if data.current.value == 'stopdrugrun' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    		if closestPlayer ~= -1 and closestDistance <= 2.0 then
     			TriggerServerEvent('sandy_org:removedrugjob', GetPlayerServerId(closestPlayer), PlayerData.job2.name)
     		else
     			ESX.ShowNotification('Brak graczy w pobliżu!')
     		end
			menu.close()
		end
		if data.current.value == 'lornetka' then
			TriggerEvent('jumelles:Active')
			menu.close()
		end
        if data.current.value == 'citizen_interaction' then
        	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                if qtty > 0 then
					local elements = {
						{label = 'Skuj / Rozkuj',		value = 'handcuff'},
						{label = 'Przeszukaj',			value = 'body_search'},
						{label = 'Chwyc / Puść',			value = 'drag'},
						{label = 'Wloz do pojazdu',	value = 'put_in_vehicle'},
						{label = 'Wyjmij z pojazdu',	value = 'out_the_vehicle'}

					}
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = 'Kajdanki',
						align    = 'center',
						elements = elements
					}, function(data2, menu2)
                		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        				if closestPlayer ~= -1 and closestDistance <= 2.0 then
         					local closestPed = GetPlayerPed(closestPlayer)
                			local action = data2.current.value
          					if action == 'body_search' then
            					if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
              						if IsPedCuffed(closestPed) then
                						if not exports['esx_property']:isInProperty() then
                  							TriggerServerEvent('esx_jobpolice:przeszukaj', GetPlayerServerId(closestPlayer))
                						else
                  							ESX.ShowNotification('Nie możesz przeszukiwać w mieszkaniu!')
                						end
             						end
            					else
              						ESX.ShowNotification('Nie możesz przeszukiwać w ruchu!')
            					end
          					elseif action == 'handcuff' then
            					if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
									if not exports['esx_property']:isInProperty() then
										TriggerServerEvent('esx_jobpolice:handcuff', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('Nie możesz tego robić w mieszkaniu!')
									end
								else
									ESX.ShowNotification('Nie możesz zakuwać w ruchu!')
								end
							elseif action == 'drag' then
								if IsPedCuffed(closestPed) then
									TriggerServerEvent('esx_jobpolice:drag', GetPlayerServerId(closestPlayer))
								else
									ESX.ShowNotification("Najpierw musisz zakuć obywatela.")
								end
							elseif action == 'put_in_vehicle' then
								TriggerServerEvent('esx_jobpolice:putInVehicle', GetPlayerServerId(closestPlayer))
							elseif action == 'out_the_vehicle' then
								TriggerServerEvent('esx_jobpolice:OutVehicle', GetPlayerServerId(closestPlayer))
							end
                		else
                    		ESX.ShowNotification('Brak graczy w pobliżu!')
                		end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					ESX.ShowNotification('~r~Nie posiadasz kajdanek!')
        		end
    		end, 'handcuffs')
		end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('sandy_org:setdrugblip')
AddEventHandler('sandy_org:setdrugblip', function()
    if currentjoblocation ~= nil then
        RemoveBlip(drugblip)
        drugblip = AddBlipForCoord(currentjoblocation)
        BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Zlecenie')
		EndTextCommandSetBlipName(drugblip)
        SetBlipColour(drugblip, 1)
        SetBlipCategory(drugblip, 3)
        SetBlipRoute(drugblip, true)
    end
end)

RegisterNetEvent('sandy_org:setdrugjob')
AddEventHandler('sandy_org:setdrugjob', function(org)
	currentdrugemp = org
	startthedrugjob = true
	rolldrugjob()
end)

RegisterNetEvent('sandy_org:removedrugjob')
AddEventHandler('sandy_org:removedrugjob', function(org)
	if org == currentdrugemp then
		currentdrugemp = nil
		startthedrugjob = false
		stopdrugjob()
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if not sellingdrugs and drugjobdone then
	        if IsPedDeadOrDying(PlayerPedId(), 1) then
		       	stopdrugjob()
		    end
		end
        if isondrugjob and not drugjobdone then
            local Player = GetPlayerPed(-1)
            local PlayerPos = GetEntityCoords(Player)
            local Distance = GetDistanceBetweenCoords(PlayerPos, currentjoblocation.x, currentjoblocation.y, currentjoblocation.z, true)
            if Distance <= 40.0 and not sellingdrugs then
		        CurrentCustomerPed = Config.PedModels[GetRandomIntInRange(1, #Config.PedModels)]
		    	while not HasModelLoaded(GetHashKey(CurrentCustomerPed)) do
					RequestModel(GetHashKey(CurrentCustomerPed))
					Wait(100)
				end
				if CurrentCustomerSpawned == nil then
					CurrentCustomerSpawned =  CreatePed(4, GetHashKey(CurrentCustomerPed), currentjoblocation.x, currentjoblocation.y, currentjoblocation.z, 45.1, false, true)
					SetEntityInvincible(CurrentCustomerSpawned, true)
					ClearPedTasksImmediately(CurrentCustomerSpawned)
					SetBlockingOfNonTemporaryEvents(CurrentCustomerSpawned, true)
					Wait(1000)
				end
                if Distance <= 2.0 and not sellingdrugs then
                    canselldrugs = true
                end
	            if Distance <= 25 and not sellingdrugs then
	                if Distance <= 2.0 and canselldrugs then
		                ESX.ShowHelpNotification('Nacisnij ~o~~INPUT_PICKUP~~s~ aby dostarczyc ~y~Narkotyki')
	                    if IsControlJustReleased(0, 38) and (GetGameTimer() - GUI.Time) > 60000 then
				            local noofpolice = exports['esx_scoreboard']:counter('police')
			     			if noofpolice >= Config.Police then
				     			GUI.Time = GetGameTimer() 
		                    	rolldrugscenario(noofpolice)
		                    	makeEntityFaceEntity(CurrentCustomerSpawned, Player)
		                    	canselldrugs = false
		                    	timer = Config.DrugSellTime
		                    	block = true
			     			else
			     				ESX.ShowNotification('~r~Nie ma wystarczajacej ilosci policji!')
			     			end
	                    end
	                end
	            end
            end
        end
    end
end)

function makeEntityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity1,heading)
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if block then
			while (timer ~= 0) do
				Wait(1000)
				local Player = GetPlayerPed(-1)
	            local PlayerPos = GetEntityCoords(Player)
	            local Distance = GetDistanceBetweenCoords(PlayerPos, currentjoblocation.x, currentjoblocation.y, currentjoblocation.z, true)
				if Distance <= 5.0 then
	    			timer = timer - 1
	    			ESX.ShowNotification('Trwaja negocjacje ~g~'..timer..'~w~s')
	    			if timer == 0 then
	    				timer = 0
	    				usedrugscenario()
	    				break
	    			end
    			else
    				timer = 0
    				ESX.ShowNotification('Przerwales negocjacje\nPoczekaj 10 sekund na nowe zlecenie')
    				block = false
    				sellingdrugs = false
    				Wait(10000)
					rolldrugjob()
					break
    			end
			end
			block = false
		end
	end
end)

function rolldrugscenario(cops)
	local chance = math.random(1, 100)
	if chance > 30 then
		sellingdrugs = true
		currentscenario = 'customerpay'
	elseif chance < 30 and chance > 25 then
		sellingdrugs = true
		currentscenario = 'customerattack'
	elseif chance < 25 and chance > 20 then
		sellingdrugs = true
		currentscenario = 'customerrunaway'
	elseif chance < 20 and chance > 0 then
		sellingdrugs = true
		currentscenario = 'customerpaypolice'
		TriggerServerEvent('sandy_org:drugsNotify')
	end
end

function usedrugscenario()
	if currentscenario == 'customerpay' then
		customerpay()
	elseif currentscenario == 'customerattack' then
		customerattack()
		TriggerServerEvent('sandy_org:drugsNotify')
	elseif currentscenario == 'customerrunaway' then
		customerrunaway()
		TriggerServerEvent('sandy_org:drugsNotify')
	elseif currentscenario == 'customerpaypolice' then
		customerpaypolice()
	end
end

RegisterNetEvent('sandy_org:playerstolendrugs')
AddEventHandler('sandy_org:playerstolendrugs', function(drugtype2)
	drugclusterstolen = drugtype2
end)

RegisterNetEvent('sandy_org:playerhasdrugs')
AddEventHandler('sandy_org:playerhasdrugs', function(drugtype)
	drugcluster = drugtype
end)

RegisterNetEvent('sandy_org:drugsEnable')
AddEventHandler('sandy_org:drugsEnable', function()
	local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
    DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
	TriggerServerEvent('sandy_org:drugsInProgressPos', plyPos.x, plyPos.y, plyPos.z)
end)

RegisterNetEvent('sandy_org:drugsPlace')
AddEventHandler('sandy_org:drugsPlace', function(x,y,z,id,msg)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local street = GetStreetNameAtCoord(x, y, z)
		local droga = GetStreetNameFromHashKey(street)
		local pid = GetPlayerFromServerId(id)
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
		ESX.ShowAdvancedNotification('Alarm policyjny', '~r~Sprzedaż Narkotyków', msg, mugshotStr, 1)
  		UnregisterPedheadshot(mugshot)

        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
		
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip,  403)
		SetBlipColour(blip,  1)
		SetBlipAlpha(blip, 250)
		SetBlipScale(blip, 1.2)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('# Sprzedaz narkotykow')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(50000)
        RemoveBlip(blip)
	end
end)

RegisterNetEvent('sandy_org:drugsPlace')
AddEventHandler('sandy_org:drugsPlace', function(x, y, z)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local street = GetStreetNameAtCoord(x, y, z)
		local droga = GetStreetNameFromHashKey(street)
		local pid = GetPlayerFromServerId(id)

        PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
		
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip,  403)
		SetBlipColour(blip,  1)
		SetBlipAlpha(blip, 250)
		SetBlipScale(blip, 1.2)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('# Sprzedaz narkotykow')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(50000)
        RemoveBlip(blip)
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function customerpaypolice()
	ClearPedTasks(CurrentCustomerSpawned)
	Wait(50)
	FreezeEntityPosition(PlayerPedId(), true)
	weed_bag = CreateObject(GetHashKey('prop_meth_bag_01'), 0, 0, 0, true)
	AttachEntityToEntity(weed_bag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	loadAnimDict('mp_common')
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 0, false, false, false)
	cashprop = CreateObject(GetHashKey('prop_anim_cash_pile_01'), 0, 0, 0, true)
	AttachEntityToEntity(cashprop, CurrentCustomerSpawned, GetPedBoneIndex(PlayerPedId(),  60309), 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1, 0, 1)
	loadAnimDict('mp_common')
	TaskPlayAnim(CurrentCustomerSpawned, 'mp_common', 'givetake2_b', 8.0, 8.0, -1, 0, 0, false, false, false)
	Wait(2000)
	FreezeEntityPosition(PlayerPedId(), false)	
	DeleteEntity(cashprop)
    DeleteEntity(weed_bag)
    showpoliceplate(CurrentCustomerSpawned)
    weed_bag = nil 
	cashprop = nil
	sellingdrugs = false
	drugjobdone = true
	local noofpolice = exports['esx_scoreboard']:counter('police')
	if noofpolice >= Config.Police then
		TriggerServerEvent('sandy_org:rolldrugtosell')
		Wait(1500)
		if drugcluster.bCCP8 ~= 'nomore' then
			TriggerServerEvent('sandy_org:selldrug', drugcluster, noofpolice, currentdrugemp)
		else
			stopdrugjob()
		end
	end
	SetEntityInvincible(CurrentCustomerSpawned, false)
	SetPedAsEnemy(CurrentCustomerSpawned, true)
	ClearPedTasks(CurrentCustomerSpawned)
	TaskCombatPed(CurrentCustomerSpawned, PlayerPedId(), 0, 16)
	GiveWeaponToPed(CurrentCustomerSpawned, GetHashKey("weapon_pistol"), 100, false, true)
	SetCurrentPedWeapon(CurrentCustomerSpawned, GetHashKey("weapon_pistol"), true)
	ESX.ShowNotification('~r~Klient okazal sie policjantem!')
	Citizen.CreateThread(function()
   	 	while true do
        Citizen.Wait(5000)
	        if IsPedDeadOrDying(CurrentCustomerSpawned, 1) then
	        	ESX.ShowNotification('Poczekaj 10 sekund na nowe zlecenie')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
	        timer2 = timer2 - 1
	        if timer2 == 0 then
	        	ESX.ShowNotification('~r~Tranzakcja trwala za dlugo!')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
    	end
	end)
end

function showpoliceplate(ped)
	local plateModel = "prop_fib_badge"
	local animDict = "paper_1_rcm_alt1-9"
	local animName = "player_one_dual-9"

	RequestModel(GetHashKey(plateModel))
	while not HasModelLoaded(GetHashKey(plateModel)) do
	Citizen.Wait(100)
	end

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
	Citizen.Wait(100)
	end

	local pedCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
	local platespawned = CreateObject(GetHashKey(plateModel), pedCoords.x, pedCoords.y, pedCoords.z, 1, 1, 1)
	Citizen.Wait(1000)
	TaskPlayAnim(ped, animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
	AttachEntityToEntity(platespawned, ped, GetPedBoneIndex(ped, 28422), 0.115, -0.011, -0.045, 90.0, 90.0, 60.0, true, true, false, false, 2, true)
	Citizen.Wait(3000)
	ClearPedSecondaryTask(ped)
	DeleteObject(platespawned)
end

function customerpay()
	ClearPedTasks(CurrentCustomerSpawned)
	Wait(50)
	FreezeEntityPosition(PlayerPedId(), true)
	weed_bag = CreateObject(GetHashKey('prop_meth_bag_01'), 0, 0, 0, true)
	AttachEntityToEntity(weed_bag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
	loadAnimDict('mp_common')
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 0, false, false, false)
	cashprop = CreateObject(GetHashKey('prop_anim_cash_pile_01'), 0, 0, 0, true)
	AttachEntityToEntity(cashprop, CurrentCustomerSpawned, GetPedBoneIndex(PlayerPedId(),  60309), 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1, 0, 1)
	loadAnimDict('mp_common')
	TaskPlayAnim(CurrentCustomerSpawned, 'mp_common', 'givetake2_b', 8.0, 8.0, -1, 0, 0, false, false, false)
	Wait(2000)
	FreezeEntityPosition(PlayerPedId(), false)	
	DeleteEntity(cashprop)
    DeleteEntity(weed_bag)
    weed_bag = nil 
	cashprop = nil
	sellingdrugs = false
	drugjobdone = true
	TaskWanderStandard(CurrentCustomerSpawned, 10.00, 10)
	SetEntityInvincible(CurrentCustomerSpawned, false)
	local noofpolice = exports['esx_scoreboard']:counter('police')
	if noofpolice >= Config.Police then
		TriggerServerEvent('sandy_org:rolldrugtosell')
		Wait(1500)
		if drugcluster.bCCP8 ~= 'nomore' then
			TriggerServerEvent('sandy_org:selldrug', drugcluster, noofpolice, currentdrugemp)
			ESX.ShowNotification('Poczekaj 10 sekund na nowe zlecenie')
			Wait(10000)
			rolldrugjob()
		else
			stopdrugjob()
		end
	end
end

function customerattack()
    PlayAmbientSpeech1(CurrentCustomerSpawned, "Generic_Fuck_You", "Speech_Params_Force")
    SetPedAsEnemy(CurrentCustomerSpawned, true)
	ClearPedTasks(CurrentCustomerSpawned)
	TaskCombatPed(CurrentCustomerSpawned, PlayerPedId(), 0, 16)
	GiveWeaponToPed(CurrentCustomerSpawned, GetHashKey("weapon_knife"), 1, false, true)
	SetCurrentPedWeapon(CurrentCustomerSpawned, GetHashKey("weapon_knife"), true)
	sellingdrugs = false
	drugjobdone = true
	ESX.ShowNotification('~r~Klient wyciagnal bron i grozi ci zyciem!')
	SetEntityInvincible(CurrentCustomerSpawned, false)
	Citizen.CreateThread(function()
   	 	while true do
        Citizen.Wait(5000)
	        if IsPedDeadOrDying(CurrentCustomerSpawned, 1) then
	        	ESX.ShowNotification('Poczekaj 10 sekund na nowe zlecenie')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
	        timer2 = timer2 - 1
	        if timer2 == 0 then
	        	ESX.ShowNotification('~r~Tranzakcja trwala za dlugo!')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
    	end
	end)
end

function customerrunaway()
	local Player = GetPlayerPed(-1)
    SetPedAsEnemy(CurrentCustomerSpawned, true)
	ClearPedTasks(CurrentCustomerSpawned)
	TaskReactAndFleePed(CurrentCustomerSpawned, Player)
	sellingdrugs = false
	drugjobdone = true
	ESX.ShowNotification('~r~Klient ukradl towar i probuje uciec!')
	SetEntityInvincible(CurrentCustomerSpawned, false)
	local noofpolice = exports['esx_scoreboard']:counter('police')
	if noofpolice >= Config.Police then
		TriggerServerEvent('sandy_org:rolldrugtosell')
		Wait(1500)
		if drugcluster.bCCP8 ~= 'nomore' then
			TriggerServerEvent('sandy_org:stealdrug', drugcluster)
			while drugclusterstolen.bCCP8 == nil do
				Wait(100)
			end
		else
			stopdrugjob()
		end
	end
	Citizen.CreateThread(function()
   	 	while true do
        Citizen.Wait(5000)
	        if IsPedDeadOrDying(CurrentCustomerSpawned, 1) then
	        	TriggerServerEvent('sandy_org:getdrugback', drugclusterstolen)
	        	ESX.ShowNotification('Odzyskales swoje narkotyki!\nPoczekaj 10 sekund na nowe zlecenie')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
	       	timer2 = timer2 - 1
	        if timer2 == 0 then
	        	ESX.ShowNotification('~r~Tranzakcja trwala za dlugo!')
	        	Wait(10000)
	        	rolldrugjob()
	        	break
	        end
    	end
	end)
end

function stopdrugjob()
	timer2 = 12
	ESX.ShowNotification('~y~Przerwales swoje zlecenia!')
	if CurrentCustomerSpawned ~= nil then
		DeleteEntity(CurrentCustomerSpawned)
		SetModelAsNoLongerNeeded(GetHashKey(CurrentCustomerPed))
		CurrentCustomerSpawned = nil
	end
	currentdrugemp = nil
	isondrugjob = false
	drugcluster = {}
	drugclusterstolen = {}
	currentjoblocation = nil
	previousjoblocation = nil
	startthedrugjob = false
	RemoveBlip(drugblip)
end

function rolldrugjob()
	if startthedrugjob then
		timer2 = 12
		if currentjoblocation ~= nil then
			previousjoblocation = currentjoblocation
		end
		ESX.ShowNotification('~g~Dostales wlasnie nowe zlecenie!')
		drugjobdone = false
		if CurrentCustomerSpawned ~= nil then
			DeleteEntity(CurrentCustomerSpawned)
			SetModelAsNoLongerNeeded(GetHashKey(CurrentCustomerPed))
			CurrentCustomerSpawned = nil
		end
		currentjoblocation = Config.Druglocations[GetRandomIntInRange(1, #Config.Druglocations)]
		while currentjoblocation == previousjoblocation do
			currentjoblocation = Config.Druglocations[GetRandomIntInRange(1, #Config.Druglocations)]
			Wait(100)
		end
		TriggerEvent('sandy_org:setdrugblip')
		isondrugjob = true
	end
end

function OpenGetWeaponMenu(station)

	ESX.TriggerServerCallback('sandy_org:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #weapons, 1 do
		if weapons[i] then
		  local ammo = weapons[i].ammo
		  if not ammo then
			ammo = 1
		  end
  
		  table.insert(elements, {label = ESX.GetWeaponLabel(weapons[i].name) .. ' [' .. ammo .. ']', value = weapons[i]})
		end
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_get_weapon',
		{
		  title    = 'Wyciąganie broni',
		  align    = 'center',
		  elements = elements
		},
		function(data, menu)
  
		  menu.close()
  
		  ESX.TriggerServerCallback('sandy_org:removeArmoryWeapon', function()
			OpenGetWeaponMenu(station)
		  end, data.current.value.name, station, data.current.value.ammo)
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end, station)
  
  end

function OpenPutWeaponMenu(station)
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = weaponList[i].label .. ' [' .. ammo .. ']', value = weaponList[i].name, ammo = ammo})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = ('Chowanie broni'),
		align    = 'center',
		elements = elements
	  },
	  function(data, menu)
  
		if data.current.ammo > 0 then
		  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'armory_put_weapon_count', {
			  title = 'Ilość',
		  }, function(data2, menu2)
			  menu2.close()
  
			  local quantity = tonumber(data2.value)
			  if not quantity or quantity > data.current.ammo then
				  ESX.ShowNotification('Nieprawidłowa ilość')
			  else
				  menu.close()
				  ESX.TriggerServerCallback('sandy_org:addArmoryWeapon', function()
					  OpenPutWeaponMenu(station)
				  end, data.current.value, true, station, quantity)
			  end
		  end, function(data2, menu2)
			  menu2.close()
		  end)
		else
		  menu.close()
		  ESX.TriggerServerCallback('sandy_org:addArmoryWeapon', function()
			OpenPutWeaponMenu(station)
		  end, data.current.value, true, station, 0)
		end
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  end

function OpenGetStocksMenu(station)
	ESX.TriggerServerCallback('sandy_org:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Wyciągnij przedmiot'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Nieprawidłowa ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sandy_org:getStockItem', station, itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, station)
end

function OpenPutStocksMenu(station)
	ESX.TriggerServerCallback('sandy_org:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Twoje kieszenie'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Błędna ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('sandy_org:putStockItems', station, itemName, count)
					Citizen.Wait(300)
					OpenPutStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = ('Stan konta'),     value = 'account'},
		{label = ('Zdeponuj nieopodatkowane pieniądze'),     value = 'put_dirty_money'},
		{label = ('Wyciągnij nieopodatkowane pieniądze'),  value = 'get_dirty_money'},
		--{label = ('Wyciągnij broń'), value = 'get_weapon'},
		--{label = ('Odłóż broń'),     value = 'put_weapon'},
		{label = ('Wyciągnij przedmiot'),  value = 'get_stock'},
		{label = ('Schowaj przedmiot'), value = 'put_stock'},
	}


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = ('Zbrojownia'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'account' then
			TriggerServerEvent('sandy_org:showmoney', station)
		elseif data.current.value == 'put_dirty_money' then
			putdirtymenu(station)
		elseif data.current.value == 'get_dirty_money' then
			if PlayerData.job2.grade_name == 'boss' then
				takedirtymenu(station)
			else
				ESX.ShowNotification('Masz za niska range.')
			end
		elseif data.current.value == 'get_weapon' then
			if PlayerData.job2.grade_name == 'boss' then
				OpenGetWeaponMenu(station)
			else
				ESX.ShowNotification('Masz za niska range.')
			end
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu(station)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu(station)
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu(station)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć zbrojownie.')
		CurrentActionData = {station = station}
	end)
end

function putdirtymenu(org)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'xxxx', {
		title = 'amount'
	}, function(data2, menu)

		local quantity = tonumber(data2.value)
		if quantity == nil then
			ESX.ShowNotification('Nie masz takie kwoty.')
		else
			menu.close()

			TriggerServerEvent('sandy_org:putmoney', org, quantity)
		end

	end, function(data2,menu)
		menu.close()
	end)
end

function takedirtymenu(org)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'xxxxxx', {
		title = 'amount'
	}, function(data2, menu)

		local quantity = tonumber(data2.value)
		if quantity == nil then
			ESX.ShowNotification('Nie masz takie kwoty.')
		else
			menu.close()

			TriggerServerEvent('sandy_org:takemoney', org, quantity)
		end

	end, function(data2,menu)
		menu.close()
	end)
end

RegisterNetEvent('sandy_org:safe')
AddEventHandler('sandy_org:safe', function(dirty)
	Safe(dirty)
end)

function Safe(dirty)
	
	local elements = {}

	table.insert(elements, {label = 'Nieopodoatkowana Gotówka: <span style="color:red;">'..dirty..'$',     value = '1'})


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Safe',
	{
		title    = 'Sejf',
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			menu.close()
		end

	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('sandy_org:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć zbrojownie.')
		CurrentActionData = {station = station}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu szefa.')
		CurrentActionData = {}
	elseif part == 'Parking' then
		CurrentAction     = 'parking_actions'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć garaz.')
		CurrentActionData = {}
	elseif part == 'Narkotyki' then
		CurrentAction     = 'drugs_actions'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu narkotykow.')
		CurrentActionData = {}
	end
end)

AddEventHandler('sandy_org:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(Config.Organizacje) do
			if PlayerData.job2 and PlayerData.job2.name == v.praca then
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local isInMarker, hasExited, letSleep = false, false, true
				local currentStation, currentPart, currentPartNum
				
				for i=1, #v.Szafka, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Szafka[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, v.Szafka[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				for i=1, #v.Przebieralnia, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Przebieralnia[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, v.Przebieralnia[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
					end
				end

				for i=1, #v.Narko, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Narko[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(1, v.Narko[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Narkotyki', i
					end
				end
				
				if PlayerData.job2.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(1, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 150, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end

				if currentjoblocation ~= nil then
            		if (GetDistanceBetweenCoords(coords, currentjoblocation.x, currentjoblocation.y, currentjoblocation.z, true) < 20) then
            			isInMarker = true
            		end
            	end

				if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
					if
						(LastStation and LastPart and LastPartNum) and
						(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
					then
						TriggerEvent('sandy_org:hasExitedMarker', LastStation, LastPart, LastPartNum)
						hasExited = true
					end

					HasAlreadyEnteredMarker = true
					LastStation             = currentStation
					LastPart                = currentPart
					LastPartNum             = currentPartNum

					TriggerEvent('sandy_org:hasEnteredMarker', currentStation, currentPart, currentPartNum)
				end

				if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('sandy_org:hasExitedMarker', LastStation, LastPart, LastPartNum)
				end

				if letSleep then
					Citizen.Wait(500)
				end
			end
		end
	end
end)

function OpenCloakroomMenu(station)
	local playerPed = PlayerPedId()

	local elements = {
		{ label = ('Ubrania'), value = 'player_dressing' },
		{ label = ('Przeglądaj ubrania'), value = 'przegladaj_ubrania' }
	}
	ESX.UI.Menu.CloseAll()
	if PlayerData.job2.grade_name == 'boss' then
		table.insert(elements, {
			label = ('Dodaj ubranie'),
			value = 'zapisz_ubranie' 
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = ('Ubrania'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'przegladaj_ubrania' then
			ESX.TriggerServerCallback('sandy_org:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
					}
					if PlayerData.job2.grade_name == 'boss' then
						table.insert(elements2, {
							label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
							value = 'usun_ubranie' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
					title    = ('Ubrania'),
					align    = 'center',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'ubierz_sie' then
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('sandy_org:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, station)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							TriggerServerEvent('sandy_org:removeOutfit', data2.current.value, station)
							ESX.ShowNotification('Pomyślnie usunąłeś ubiór o nazwie: ' .. data2.current.label)
						end
					end, function(data3, menu3)
						menu3.close()
						
						CurrentAction     = 'menu_cloakroom'
						CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
						CurrentActionData = {}
					end)
					
				end, function(data2, menu2)
					menu2.close()
					
					CurrentAction     = 'menu_cloakroom'
					CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
					CurrentActionData = {}
				end)
			end, station)
		end
		if data.current.value == 'player_dressing' then

            ESX.TriggerServerCallback('root_property:getPlayerDressing', function(dressing)
                local elements = {}

                for i=1, #dressing, 1 do
                    table.insert(elements, {
                        label = dressing[i],
                        value = i
                    })
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
                    title    = 'Ubrania z mieszkań',
                    align    = 'center',
                    elements = elements
                }, function(data2, menu2)
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        ESX.TriggerServerCallback('root_property:getPlayerOutfit', function(clothes)
                            TriggerEvent('skinchanger:loadClothes', skin, clothes)
                            TriggerEvent('esx_skin:setLastSkin', skin)

                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                        end, data2.current.value)
                    end)
                end, function(data2, menu2)
                	menu2.close()
				
					CurrentAction     = 'menu_cloakroom'
					CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
					CurrentActionData = {}
                end)
      		end)
   		end
		if data.current.value == 'zapisz_ubranie' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
				title = ('Nazwa ubioru')
			}, function(data2, menu2)
				ESX.UI.Menu.CloseAll()

				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('sandy_org:saveOutfit', data2.value, skin, station)
					ESX.ShowNotification('Pomyślnie zapisano ubiór o nazwie: ' .. data2.value)
				end)
				
				CurrentAction     = 'menu_cloakroom'
				CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
				CurrentActionData = {}
			end, function(data2, menu2)
				menu2.close()
				
				CurrentAction     = 'menu_cloakroom'
				CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
				CurrentActionData = {}
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	end)
end

Citizen.CreateThread(function()
	while true do
		local fps = true
		Citizen.Wait(1)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			for k,v in pairs(Config.Organizacje) do
				fps = false
				if IsControlJustReleased(0, 38) and PlayerData.job2 and PlayerData.job2.name == v.praca then
					if CurrentAction == 'menu_armory' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestDistance > 3 or closestPlayer == -1 then
							OpenArmoryMenu(CurrentActionData.station)
						else
							ESX.ShowNotification('Stoisz za blisko innego gracza!')
						end
					elseif CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu(v.praca)
					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent('esx_societycrime:openBossMenu', v.praca, function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu szefa.')
							CurrentActionData = {}
						end, { wash = false, grades = false })	
					elseif CurrentAction == 'drugs_actions' then
						OpenDrugsMenu()
					end
					CurrentAction = nil
				end
			end
		end
		if fps then
			Wait(100)
		end
	end		
end)

function OpenDrugsMenu()
	local ped = PlayerPedId()
	local elements = {
		{label = ('Kokaina 100g = 1 Cegla Kokainy'),     value = 'coke'},
		{label = ('Opium 100g = 1 Cegla Opium'),     value = 'opium'},
		{label = ('Meta 100g = 1 Cegla Mety'),  value = 'meta'},
		{label = ('Crack 100g = 1 Cegla Cracku'),  value = 'crack'},
	}


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'narko', {
		title    = ('Narkotyki'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'coke' and (GetGameTimer() - GUI.Time) > 60000 then
			GUI.Time = GetGameTimer()
			TriggerServerEvent('sandy_org:makebrick', "coke")
			FreezeEntityPosition(ped, true)
			blokada = true
            blokada_przycisk()
			Citizen.Wait(60000)
			FreezeEntityPosition(ped, false)
			blokada = false
		elseif data.current.value == 'opium' and (GetGameTimer() - GUI.Time) > 60000 then
			GUI.Time = GetGameTimer()
			TriggerServerEvent('sandy_org:makebrick', "opium")
			FreezeEntityPosition(ped, true)
			blokada = true
            blokada_przycisk()
			Citizen.Wait(60000)
			FreezeEntityPosition(ped, false)
			blokada = false
		elseif data.current.value == 'meta' and (GetGameTimer() - GUI.Time) > 60000 then
			GUI.Time = GetGameTimer()
			TriggerServerEvent('sandy_org:makebrick', "meta")
			FreezeEntityPosition(ped, true)
			blokada = true
            blokada_przycisk()
			Citizen.Wait(60000)
			FreezeEntityPosition(ped, false)
			blokada = false
		elseif data.current.value == 'crack' and (GetGameTimer() - GUI.Time) > 60000 then
			GUI.Time = GetGameTimer()
			TriggerServerEvent('sandy_org:makebrick', "crack")
			FreezeEntityPosition(ped, true)
			blokada = true
            blokada_przycisk()
			Citizen.Wait(60000)
			FreezeEntityPosition(ped, false)
			blokada = false
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_drugs'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu narkotykow.')
		CurrentActionData = {station = station}
	end)
end

RegisterNetEvent('sandy_org:timer')
AddEventHandler('sandy_org:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(600)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do  
        Citizen.Wait(5)

        local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
			ESX.Game.Utils.DrawText3D(coords, ('~g~' .. timer .. '%'), 0.7)
		if timer == 100 then
           	break
        end
    end
    end)
end)

function blokada_przycisk()
	Citizen.CreateThread(function()
		while blokada do
			Citizen.Wait(10)
			DisableControlAction(0, 73, true) 				-- x
			DisableControlAction(0, 105, true) 				-- x
			DisableControlAction(0, 120, true) 				-- x
			DisableControlAction(0, 154, true) 				-- x
			DisableControlAction(0, 186, true) 				-- x
            DisableControlAction(0, 252, true) 				-- x
            DisableControlAction(0, 323, true) 				-- x
            DisableControlAction(0, 337, true) 				-- x
            DisableControlAction(0, 354, true) 				-- x
            DisableControlAction(0, 357, true) 				-- x
            DisableControlAction(0, 20, true) 				-- z
            DisableControlAction(0, 48, true) 				-- z
            DisableControlAction(0, 32, true) 				-- w
            DisableControlAction(0, 33, true) 				-- s
            DisableControlAction(0, 34, true) 				-- a
            DisableControlAction(0, 35, true) 				-- d
		end
	end)
end