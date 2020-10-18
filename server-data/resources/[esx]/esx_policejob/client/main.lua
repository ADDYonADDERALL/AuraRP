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
local PlayerData              = {}
local GUI = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = nil
local IsDragged               = false
local IsFirstHandcuffTick     = true
local hasAlreadyJoined        = false
local myIdentifier    = nil
local blipsCops = {}
local CurrentTask             = {}
local prop
local isindressingmenu = false

ESX                           = nil
GUI.Time = 0



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

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 1,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

Citizen.CreateThread(function()
  local Interior = GetInteriorAtCoords(440.84, -983.14, 30.69)
  LoadInterior(Interior)
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function isHandcuffed()
  return IsHandcuffed
end

-- BACKUP CODE

function playCode99Sound()
  PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  Wait(900)
  PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
  Wait(900)
  PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
end

RegisterNetEvent('rich:ShowInfo')
AddEventHandler('rich:ShowInfo', function(notetext)
  ESX.ShowNotification(notetext)
end)

RegisterNetEvent('rich:BackupReq')
AddEventHandler('rich:BackupReq', function(bk, s)
  if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
    local src = s
    local bkLvl = bk
    local bkLvlTxt = "N/A"
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local streetName = (GetStreetNameFromHashKey(street1))

    if bkLvl == "0" then
      bkLvlTxt = "~r~~h~KOD 0"
    elseif bkLvl == "1" then
      bkLvlTxt = "~b~KOD 1"
    elseif bkLvl == "2" then
      bkLvlTxt = "~y~KOD 2"
    elseif bkLvl == "3" then
      bkLvlTxt = "~r~KOD 3"
      PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
    elseif bkLvl == "99" then
      bkLvlTxt = "~r~~h~KOD 99"
    end

    ESX.ShowNotification("Oficer potrzebuje pomocy " .. bkLvlTxt .. "~s~ | ~o~Lokalizacja: ~s~" .. streetName .. "")
    if bkLvl == "99" or bkLvl == "0" then
      playCode99Sound()
      SetNewWaypoint(coords.x, coords.y)
    end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(blip,  280)
		SetBlipColour(blip,  1)
		SetBlipAlpha(blip, 250)
		SetBlipScale(blip, 1.2)
	  BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('# KOD: '..bkLvl..'')
    EndTextCommandSetBlipName(blip)
    Citizen.Wait(30000)
    RemoveBlip(blip)
  end
end)

-- BACKUP CODE

-- MENU SKIN POLICJI

local MiejsceSkin = {x = 455.84, y = -993.16, z = 30.68}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false) 
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z)
    if not isindressingmenu then
  		if dist <= 10.0 then	
  			DrawMarker(25, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z-0.95, 0, 0, 0, 0, 0, 0, 1.01, 1.01, 0.6001, 0, 205, 250, 200, 0, 0, 0, 0)
      		if dist <= 1.0 then
       			if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
         		 		ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby ~y~dopasować mundur!')
  		        	if IsControlJustPressed(0, 38) then
  		          		TriggerEvent("esx_skin:openSaveableMenu")
                    isindressingmenu = true
  		        	end
  		        end
  		    end
  		end
    end
	end
end)

-- MENU SKIN POLICJI

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'bullet_wear' then
        SetPedArmour(playerPed, 50)
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'bullet_wear' then
        SetPedArmour(playerPed, 50)
      end
    end

  end)
end

local dostep = {
  'steam:110000103355131',     -- SANDY
  'steam:110000115d1e917',     -- Lisek
  'steam:11000013338bf5d',     -- Pablo Buczo
  'steam:110000118613ee8',     -- Luke Harris
  'steam:11000011a18962d',     -- Felipe Angello
  'steam:11000010e737c03',     -- Caroline Morgan
  'steam:110000105fbb92b',     -- Lenny Belardo
  'steam:1100001132211a1',     -- Mercy
  'steam:11000010688A229',     -- Huan Ciong
  'steam:110000111b2ad15',     -- Kevin Toss
  'steam:110000106f13235'	   -- Stivo Margera
}

local dostepgu = {
  'steam:110000103355131',     -- SANDY
}

local dostepm = {
  'steam:110000103355131',     -- SANDY
}

local madostep = false
local madostepgu = false
local madostepm = false

function OpenCloakroomMenu()

  ESX.TriggerServerCallback('sandy:sprawdzhexa', function(id)
    if id then
      for i=0, #dostep do
        if tostring(id) == tostring(dostep[i]) then
          madostep = true
        end
      end
    end
  end)

  ESX.TriggerServerCallback('sandy:sprawdzhexagu', function(id)
    if id then
      for i=0, #dostepgu do
        if tostring(id) == tostring(dostepgu[i]) then
          madostepgu = true
        end
      end
    end
  end)

  ESX.TriggerServerCallback('sandy:sprawdzhexam', function(id)
    if id then
      for i=0, #dostepgu do
        if tostring(id) == tostring(dostepm[i]) then
          madostepm = true
        end
      end
    end
  end)

  Wait(250)

  local playerPed = PlayerPedId()

  local elements = {
    { label = 'Ubrania z mieszkan', value = 'player_dressing' },
    { label = _U('citizen_wear'), value = 'citizen_wear' },
    { label = _U('bullet_wear'), value = 'bullet_wear' },
	{ label = _U('galowe_wear'), value = 'galowe_wear' },
  }

  if PlayerData.job.grade_name == 'recruit' then
    table.insert(elements, {label = _U('police_wear'), value = 'recruit_wear'})
  end

  if PlayerData.job.grade_name == 'officer' then
    table.insert(elements, {label = _U('police_wear'), value = 'officer_wear'})
    --table.insert(elements, {label = _U('doa_wear'), value = 'doa_wear'})
    table.insert(elements, {label = _U('motocykl_wear'), value = 'motocykl_wear'})
  end

  if PlayerData.job.grade_name == 'sergeant' then
    table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
    --table.insert(elements, {label = _U('doa_wear'), value = 'doa_wear'})
    --table.insert(elements, {label = _U('k9_wear'), value = 'k9_wear'})
    table.insert(elements, {label = _U('motocykl_wear'), value = 'motocykl_wear'})
  end
  
  if PlayerData.job.grade_name == 'lieutenant' then
    table.insert(elements, {label = _U('police_wear'), value = 'lieutenant_wear'})
    --table.insert(elements, {label = _U('doa_wear'), value = 'doa_wear'})
    --table.insert(elements, {label = _U('k9_wear'), value = 'k9_wear'})
    table.insert(elements, {label = _U('motocykl_wear'), value = 'motocykl_wear'})
  end

  if PlayerData.job.grade_name == 'kapitan' then
    table.insert(elements, {label = _U('police_wear'), value = 'kapitan_wear'})
    --table.insert(elements, {label = _U('doa_wear'), value = 'doa_wear'})
    --table.insert(elements, {label = _U('k9_wear'), value = 'k9_wear'})
    table.insert(elements, {label = _U('motocykl_wear'), value = 'motocykl_wear'})
    table.insert(elements, {label = _U('dodatkowy_wear'), value = 'dodatkowy_wear'})
  end
  
  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('police_wear'), value = 'boss_wear'})
    --table.insert(elements, {label = _U('doa_wear'), value = 'doa_wear'})
    --table.insert(elements, {label = _U('k9_wear'), value = 'k9_wear'})
    table.insert(elements, {label = _U('motocykl_wear'), value = 'motocykl_wear'})
    table.insert(elements, {label = _U('dodatkowy_wear'), value = 'dodatkowy_wear'})
  end

  if madostep == true then
    table.insert(elements, {label = _U('swat_wear'), value = 'swat_wear'})
  end
  
  if madostepgu == true then
    table.insert(elements, {label = _U('gu_wear'), value = 'gu_wear'})
  end
  
  if madostepm == true then
    table.insert(elements, {label = _U('m_wear'), value = 'm_wear'})
  end


  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'center',
      elements = elements,
    },
    function(data, menu)

      cleanPlayer(playerPed)

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end

      if
        data.current.value == 'recruit_wear' or
        data.current.value == 'officer_wear' or
        data.current.value == 'sergeant_wear' or
        data.current.value == 'lieutenant_wear' or
        data.current.value == 'k9_wear' or
        data.current.value == 'motocykl_wear' or
        data.current.value == 'doa_wear' or
        data.current.value == 'boss_wear' or
        data.current.value == 'bullet_wear' or
        data.current.value == 'dodatkowy_wear' or
        data.current.value == 'kapitan_wear' or
        data.current.value == 'gilet_wear'
      then
        setUniform(data.current.value, playerPed)
      end
      if data.current.value == 'swat_wear' then
        setUniform(data.current.value, playerPed)
        SetPedArmour(playerPed, 100)
      elseif data.current.value == 'm_wear' then
          setUniform(data.current.value, playerPed)
      elseif data.current.value == 'gu_wear' then
        setUniform(data.current.value, playerPed)
        SetPedArmour(playerPed, 50)
      elseif data.current.value == 'galowe_wear' then
		setUniform(data.current.value, playerPed)
	  end

    if data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
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
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
      end)
    end
      
      if
        data.current.value == 'sheriff_wear_freemode' or
        data.current.value == 'lieutenant_wear_freemode' or
        data.current.value == 'commandant_wear_freemode'
      then
        local model = nil
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          if skin.sex == 0 then
            model = GetHashKey(data.current.maleModel)
          else
            model = GetHashKey(data.current.femaleModel)
          end
        end)
      
        RequestModel(model)
        while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(1000)
        end
      
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then
    ESX.TriggerServerCallback('esx_jobpolice:showdirtymoney', function(dirtymoney)
    local elements = {
      --{label = _U('get_weapon'),     value = 'get_weapon'},
      --{label = _U('put_weapon'),     value = 'put_weapon'},
      {label = _U('remove_object'),  value = 'get_stock'},
      {label = _U('deposit_object'), value = 'put_stock'},
    }

    if PlayerData.job.grade_name == 'boss' then
      table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
    end

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name ~= 'recruit' then
      table.insert(elements, {label = 'Nieopodoatkowana Gotówka: <span style="color:red;">'..dirtymoney..'$',     value = 'dirtymoneyoptions'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'recruit' then
            ESX.ShowNotification('Masz za niską rangę w LSPD! (Poproś wyższej rangi)')
          else
            OpenGetWeaponMenu()
          end
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
          if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'recruit' then
            ESX.ShowNotification('Masz za niską rangę w LSPD! (Poproś wyższej rangi)')
          else
            OpenGetStocksMenu()
          end
        end

        if data.current.value == 'dirtymoneyoptions' then
          OpenDirtyMoneyMenu(dirtymoney)
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )
  end)

  else

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        TriggerServerEvent('esx_jobpolice:giveWeapon', weapon,  200)
      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}

      end
    )
  end
end

function OpenDirtyMoneyMenu(dirtymoney)
  local elements = {
    {label = ('Zdeponuj nieopodatkowane pieniądze'),     value = 'put_dirty_money'}
  }

  if PlayerData.job.grade == 20 then
    table.insert(elements, {label = ('Wyciągnij nieopodatkowane pieniądze'),  value = 'get_dirty_money'})
    table.insert(elements, {label = ('Spal nieopodatkowane pieniądze'),  value = 'burn_dirty_money'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dirtymoneysafe_menu', {
    title    = '<span style="color:red;">'..dirtymoney..'$',
    align    = 'center',
    elements = elements
  }, function(data, menu)
    if data.current.value == 'put_dirty_money' then
      putdirtymenu()
    elseif data.current.value == 'get_dirty_money' then
      if PlayerData.job.grade == 20 then
        takedirtymenu()
      else
        ESX.ShowNotification('Masz za niska range.')
      end
    elseif data.current.value == 'burn_dirty_money' then
      if PlayerData.job.grade == 20 then
        burndirtymenu()
      else
        ESX.ShowNotification('Masz za niska range.')
      end
    end
  end, function(data, menu)
    menu.close()
    OpenArmoryMenu('police')
  end)
end

function putdirtymenu()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dirtymoneysafe_menuput', {
    title = 'amount'
  }, function(data2, menu)
    local quantity = tonumber(data2.value)
    if quantity == nil then
      ESX.ShowNotification('Nie masz takie kwoty.')
    else
      menu.close()
      TriggerServerEvent('esx_jobpolice:putmoney', quantity)
    end
  end, function(data2,menu)
    menu.close()
    OpenArmoryMenu('police')
  end)
end

function takedirtymenu()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dirtymoneysafe_menutake', {
    title = 'amount'
  }, function(data2, menu)
    local quantity = tonumber(data2.value)
    if quantity == nil then
      ESX.ShowNotification('Nie masz takie kwoty.')
    else
      menu.close()
      TriggerServerEvent('esx_jobpolice:takemoney', quantity)
    end
  end, function(data2,menu)
    menu.close()
    OpenArmoryMenu('police')
  end)
end

function burndirtymenu()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dirtymoneysafe_menuburn', {
    title = 'amount'
  }, function(data2, menu)
    local quantity = tonumber(data2.value)
      menu.close()
      TriggerServerEvent('esx_jobpolice:burnmoney', quantity)
  end, function(data2,menu)
    menu.close()
    OpenArmoryMenu('police')
  end)
end

function AddVehicleKeys(vehicle)
  local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
  if localVehPlateTest ~= nil then
    local localVehPlate = string.lower(localVehPlateTest)
    TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
    TriggerEvent("ls:notify", "Otrzymałeś kluczki do pojazdu ~b~LSPD")
  end
end

function OpenVehicleSpawnerMenu(station, partNum)

  ESX.TriggerServerCallback('sandy:sprawdzhexa', function(id)
    if id then
      for i=0, #dostep do
        if tostring(id) == tostring(dostep[i]) then
          madostep = true
        end
      end
    end
  end)


  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  local elements = {}
  for grupki, grupy in ipairs(Config.grupy) do
    if (grupki ~= 7) or (grupki == 7 and madostep) then
			local elements2 = {}
			for _, vehicle in ipairs(Config.AuthorizedVehicles) do
        for _, grupy in ipairs(vehicle.grupy) do
          if grupy == grupki then 
          table.insert(elements2, { label = vehicle.label, model = vehicle.model, rejkakurwa = vehicle.rejkakurwa})
					end
        end
      end

      table.insert(elements, { label = grupy, value = elements2, grupy = grupki })
    end
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'center',
        elements = elements,
      },
    function(data, menu)
        menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.grupy, {
			  title    = data.current.label,
			  align    = 'center',
			  elements = data.current.value
      }, function(data2, menu2)
        local model = data2.current.model
        if model and (GetGameTimer() - GUI.Time) > 2000 then
    				local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
    				if not DoesEntityExist(vehicle) then
    					local playerPed = PlayerPedId()
              ESX.Game.SpawnVehicle(model, {
                x = vehicles[partNum].SpawnPoint.x,
                y = vehicles[partNum].SpawnPoint.y,
                z = vehicles[partNum].SpawnPoint.z
              }, vehicles[partNum].Heading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                SetVehicleMaxMods(vehicle)
    					  if data2.current.rejkakurwa == nil then
                  local rejka = "LSPD " .. GetRandomIntInRange(100,999)
                  SetVehicleNumberPlateText(vehicle, rejka)
                end
                SetVehicleDirtLevel(vehicle, 0.0000000001)
                SetVehicleUndriveable(vehicle, false)
                AddVehicleKeys(vehicle)
               	local maxIndex = GetVehicleMaxNumberOfPassengers(vehicle) - 1
				for i=-1,maxIndex do
					local ped = GetPedInVehicleSeat(vehicle, i)
					if not IsPedAPlayer(ped) then
						local model = GetEntityModel(ped)
						DeletePed(ped)
						SetEntityAsNoLongerNeeded(ped)
						SetModelAsNoLongerNeeded(model)
					end
				end
              end)
            else
    				  ESX.ShowNotification(_U('vehicle_out'))
    				end
          GUI.Time = GetGameTimer()
      else
         ESX.ShowNotification('Musisz poczekac 2 sekundy')
      end
			end,
			function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(station, partNum)
			end)
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_vehicle_spawner'
      CurrentActionMsg  = _U('vehicle_spawner')
      CurrentActionData = {station = station, partNum = partNum}
    end)
end
function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'LSPD',
		align    = 'center',
		elements = {
      {label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
      {label = _U('object_spawner'),		value = 'object_spawner'},
      {label = 'Lornetka',		value = 'lornetka'},
      {label = 'Dodatki',     value = 'Dodatki'},
      {label = "Pokaż odznake",			value = 'odznaka'}
		}
  }, function(data, menu)
    
    if data.current.value == 'lornetka' then
      TriggerEvent('jumelles:Active')
      menu.close()
    end

    if data.current.value == 'odznaka' then
      TriggerServerEvent('esx_jobpolice:ShowPlate', GetPlayerServerId(closestPlayer))
      menu.close()
    end

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'),			value = 'body_search'},
				{label = _U('handcuff'),		value = 'handcuff'},
				{label = _U('drag'),			value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
				{label = 'Wydaj licencje', value = 'license1'},
        {label = _U('license_check'), value = 'license'},
        {label = "Test prochu",			value = 'gsr_test'}

			}
								
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 2.0 then
          local closestPed = GetPlayerPed(closestPlayer)
				local action = data2.current.value
				  if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
          elseif action == 'body_search' then
            if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
              if IsPedCuffed(closestPed) then
                if not exports['esx_property']:isInProperty() then
                  TriggerServerEvent('esx_jobpolice:przeszukaj', GetPlayerServerId(closestPlayer))
                else
                  ESX.ShowNotification('~r~Nie możesz przeszukiwać w mieszkaniu!')
                end
              end
            else
              ESX.ShowNotification('~r~Nie możesz przeszukiwać w ruchu!')
            end
          elseif action == 'handcuff' then
            if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
              if not exports['esx_property']:isInProperty() then
                TriggerServerEvent('esx_jobpolice:handcuff', GetPlayerServerId(closestPlayer))
              else
                ESX.ShowNotification('~r~Nie możesz tego robić w mieszkaniu!')
              end
            else
              ESX.ShowNotification('~r~Nie możesz zakuwać w ruchu!')
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
					elseif action == 'jail' then
						JailPlayer(GetPlayerServerId(closestPlayer))
						if data2.current.value == 'identity_card' then
 					   OpenIdentityCardMenu(player)
						end
					elseif action == 'license' then
					ShowPlayerLicense(closestPlayer)
					elseif action == 'license1' then
            if PlayerData.job.name == 'police' and PlayerData.job.grade >= 16 then
              TriggerServerEvent('esx_jobpolice:DajLicencje', GetPlayerServerId(closestPlayer))
              Citizen.Wait(1000)
              TriggerServerEvent('esx_weashop:ladujlicke', GetPlayerServerId(closestPlayer))
            else
              ESX.ShowNotification("~r~Nie mozesz wydawac licencji")
            end
          elseif action == 'gsr_test' then
            if IsPedCuffed(GetPlayerPed(closestPlayer)) then
              ESX.ShowNotification("~y~Sprawdzanie dłoni pod kątem prochu...")
              Citizen.Wait(1000)
              TriggerServerEvent('esx_gsr:Check', GetPlayerServerId(closestPlayer))
            else
              ESX.ShowNotification("~r~Najpierw musisz zakuć obywatela.")
            end
					end
				else
					ESX.ShowNotification('Brak graczy w ~r~pobliżu!')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			
			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				--table.insert(elements, {label = _U('impound'),		value = 'impound'})
      end
			
			--table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = _U('vehicle_interaction'),
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				coords    = GetEntityCoords(playerPed)
				vehicle   = ESX.Game.GetVehicleInDirection()
				action    = data2.current.value
				
				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if action == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)
						
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
            end
					elseif action == 'impound' then
						-- is the script busy?
						if CurrentTask.Busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							TriggerEvent('esx_jobpolice:takeVehicle')
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end
      )

    elseif data.current.value == 'Dodatki' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = 'Dodatki do broni',
				align    = 'center',
				elements = {
					{label = 'Latarka taktyczna',		value = 'Latarka'},
				}
			}, function(data2, menu2)
				local model     = data2.current.value

				if model == 'Latarka' then
          TriggerEvent('esx_attachments_bleiker:flashlight')
          menu2.close()
        end
      end)

		elseif data.current.value == 'object_spawner' then
			menu.close()
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('traffic_interaction'),
				align    = 'center',
				elements = {
					{label = _U('cone'),		value = 'prop_roadcone02a'},
					{label = _U('barrier'),		value = 'prop_barrier_work05'},
					{label = _U('spikestrips'),	value = 'p_ld_stinger_s'}
				}
			}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				local model     = data2.current.value
				if model == 'prop_roadcone02a' then
					z = z - 1.0
				end

				ESX.Game.SpawnObject(model, {
					x = x,
					y = y,
					z = z
				}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
          PlaceObjectOnGroundProperly(obj)
          if model == 'prop_barrier_work05' then
						FreezeEntityPosition(obj, true)
					end
				end)

			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_jobpolice:playAnim')
AddEventHandler('esx_jobpolice:playAnim', function(dict, anim)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
end)

function OpenBodySearchMenu(player)
if not IsPedDeadOrDying(GetPlayerPed(player), 1) then
  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
    if data.F then
      ESX.ShowNotification("Ta osoba jest już ~r~przeszukiwana") 
      return
    end

    disable = true

    local elements = {}
    for i=1, #data.accounts, 1 do
      if data.accounts[i].money > 0 then
        if data.accounts[i].name == 'black_money' then
          table.insert(elements, {
            label    = 'Skonfiskuj ' .. data.accounts[i].money .. ' brudnej gotówki',
            value    = 'black_money',
            itemType = 'item_account',
            amount   = data.accounts[i].money
          })
          break
        end
      end
    end
    --[[
    table.insert(elements, {label = _U('guns_label'), value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.weapons[i].ammo
      })
    end
    ]]--

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount
        
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        local playerCoords2 = GetEntityCoords(GetPlayerPed(player))
    
        if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, playerCoords2.x, playerCoords2.y, playerCoords2.z) <= 3.0 then
          if data.current.value ~= nil then
            TriggerServerEvent('esx_jobpolice:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
            OpenBodySearchMenu(player)
          end
        else
          ESX.ShowNotification( "Jestes za daleko by zabrac przedmiot")
    
        end
        ESX.UI.Menu.CloseAll()
        TMM_delete(player)
      Citizen.Wait(200)	
        OpenBodySearchMenu(player)
      end, function(data, menu)
        if IsEntityPlayingAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 3 ) then
          StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 1.0)
        end
        menu.close()
        TMM_delete(player)
  
      end)
  
    end, GetPlayerServerId(player))
end
end

function TMM_delete(player)
  TriggerServerEvent('esx_inventory_TMM:delete', GetPlayerServerId(player))
  disable = false
end

function LookupVehicle()
	ESX.UI.Menu.Open(
	'dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function (data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 8 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_jobpolice:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function (data, menu)
		menu.close()
	end
	)
end

function ShowPlayerLicense(player)
	local elements = {}
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
    
    local targetName = data.firstname .. ' ' .. data.lastname
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'center',
			elements = elements,
		},
		function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_jobpolice:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
			
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end,
		function(data, menu)
			menu.close()
		end
		)

	end, GetPlayerServerId(player))
end
function DajLicencje(player)

		TriggerServerEvent('esx_jobpolice:DajLicencje')


end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_jobpolice:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate', infos.plate), value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner', infos.owner), value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'center',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_jobpolice:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_jobpolice:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = PlayerPedId()
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      --local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'center',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_jobpolice:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value, true)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

    local elements = {}

    for i=1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, {label = weapon.label, price = weapon.price, value = weapon.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = _U('buy_weapon_menu'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_jobpolice:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            TriggerServerEvent('esx_jobpolice:putStockItems2', data.current.value)
            OpenBuyWeaponsMenu(station)
          else
            ESX.ShowNotification(_U('not_enough_money'))
          end

        end, data.current.price)

      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_jobpolice:getStockItems', function(items)


    local elements = {}

    for i=1, #items, 1 do
      if items[i].count > 0 then
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('police_stock'),
        align = 'center',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_jobpolice:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_jobpolice:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        align = 'center',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_jobpolice:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
	TriggerServerEvent('esx_jobpolice:forceBlip')
end)

AddEventHandler('esx_jobpolice:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Info' then
    CurrentAction     = 'menu_info'
    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby zobaczyć tablicę informacyjną'
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleDeleter' then

    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_jobpolice:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('esx_jobpolice:handcuff')
AddEventHandler('esx_jobpolice:handcuff', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()
  	Citizen.CreateThread(function()
    if IsHandcuffed then
      if not IsPedDeadOrDying(playerPed, 1) then
      	if IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_enter', 3) then
  	   		ESX.UI.Menu.CloseAll()      
  		    local x,y,z = table.unpack(GetEntityCoords(playerPed))
  		   	Citizen.Wait(100)
    			SetEnableHandcuffs(playerPed, true)
    			DisablePlayerFiring(playerPed, true)
    			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
    			SetPedCanPlayGestureAnims(playerPed, false)
    			FreezeEntityPosition(playerPed, false)
    		    DisplayRadar(false)
    		    TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'Cuff', 0.3)
    		  if Config.EnableHandcuffTimer then
    				StartHandcuffTimer()
    			end
        elseif IsPedBeingStunned(playerPed, 0) then
          ESX.UI.Menu.CloseAll()      
          local x,y,z = table.unpack(GetEntityCoords(playerPed))
          Citizen.Wait(100)
          SetEnableHandcuffs(playerPed, true)
          DisablePlayerFiring(playerPed, true)
          SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
          SetPedCanPlayGestureAnims(playerPed, false)
          FreezeEntityPosition(playerPed, false)
            DisplayRadar(false)
            TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'Cuff', 0.3)
          if Config.EnableHandcuffTimer then
            StartHandcuffTimer()
          end
  		  else
  			 IsHandcuffed = not IsHandcuffed
  		  end
      else
        ESX.UI.Menu.CloseAll()      
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        Citizen.Wait(100)
        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed, false)
          DisplayRadar(false)
          TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'Cuff', 0.3)
        if Config.EnableHandcuffTimer then
          StartHandcuffTimer()
        end
      end
	else
    	TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 1.0, -1, -1, 50, 0, 0, 0, 0)
    	TriggerServerEvent('SANDY_InteractSound_SV:PlayWithinDistance', 3.0, 'Uncuff', 0.3)
    	Citizen.Wait(100)
    	ClearPedSecondaryTask(playerPed)
    	if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
     	DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('esx_jobpolice:unrestrain')
AddEventHandler('esx_jobpolice:unrestrain', function()
  local playerPed = PlayerPedId()
    
  Citizen.CreateThread(function()
    if IsHandcuffed then

      IsHandcuffed = false

      local x,y,z = table.unpack(GetEntityCoords(playerPed))
      ClearPedSecondaryTask(playerPed)
      if Config.EnableHandcuffTimer and HandcuffTimer then
        ESX.ClearTimeout(HandcuffTimer)
      end
		  SetEnableHandcuffs(playerPed, false)
		  DisablePlayerFiring(playerPed, false)
		  SetPedCanPlayGestureAnims(playerPed, true)
		  FreezeEntityPosition(playerPed, false)
		  DisplayRadar(true)

		end
  end)
  
end)

RegisterNetEvent('esx_jobpolice:animacja')
AddEventHandler('esx_jobpolice:animacja', function()
  RequestAnimDict('mp_arresting')
  while not HasAnimDictLoaded('mp_arresting') do
      Citizen.Wait(0)
  end
  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 1.0, -3.0, 1500, 0, 0, false, false, false)
end)

RegisterNetEvent('esx_jobpolice:drag')
AddEventHandler('esx_jobpolice:drag', function(cop)
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsHandcuffed then
			if IsDragged then
				local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
				local myped = PlayerPedId()
				AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				DetachEntity(PlayerPedId(), true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_jobpolice:putInVehicle')
AddEventHandler('esx_jobpolice:putInVehicle', function()
  if IsHandcuffed then
    local playerPed = PlayerPedId()

	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			local coords = GetEntityCoords(playerPed, false)
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end

	if vehicle and vehicle ~= 0 then
	    local maxSeats = math.min(4, GetVehicleMaxNumberOfPassengers(vehicle))
		if maxSeats >= 0 then
			local freeSeat
			for i = (maxSeats - 2), 0, -1 do
			  if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			  end
			end

			if freeSeat ~= nil then
			  TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			  IsDragged = false
			end
		end
    end
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsHandcuffed then
			if IsFirstHandcuffTick then
				IsFirstHandcuffTick = false
				ESX.UI.Menu.CloseAll()
			end

			--DisableControlAction(2, 1, true) -- Disable pan
			--DisableControlAction(2, 2, true) -- Disable tilt
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['X'], true) -- Hands up
			DisableControlAction(2, Keys['Y'], true) -- Turn off vehicle
			DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
			DisableControlAction(2, Keys['B'], true) -- Pointing
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F6'], true) -- Fraction actions
			DisableControlAction(2, Keys['V'], true) -- Disable changing view
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee

			local playerPed = PlayerPedId()
			if IsPedInAnyPoliceVehicle(playerPed) then
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle
			end

			RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end

            if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            end
		else
			IsFirstHandcuffTick = true
			Citizen.Wait(500)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(5)

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Info, 1 do
          if GetDistanceBetweenCoords(coords,  v.Info[i].x,  v.Info[i].y,  v.Info[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Info[i].x, v.Info[i].y, v.Info[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

          for i=1, #v.Cloakrooms, 1 do
            if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

          for i=1, #v.Armories, 1 do
            if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

          for i=1, #v.Vehicles, 1 do
            if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 163, 10, 100, false, true, 2, false, false, false, false)
            end
          end

          for i=1, #v.VehicleDeleters, 1 do
            if IsPedInAnyVehicle(playerPed,  false) then
              if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.5, 211, 14, 4, 100, false, true, 2, false, false, false, false)
              end
            end
          end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(21, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 219, 215, 0, 100, 1, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end

  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(5)

      local playerPed      = PlayerPedId()
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Info, 1 do
          if GetDistanceBetweenCoords(coords,  v.Info[i].x,  v.Info[i].y,  v.Info[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Info'
            currentPartNum = i
          end
        end

        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if(GetDistanceBetweenCoords(coords, MiejsceSkin.x, MiejsceSkin.y, MiejsceSkin.z, true) < 1.0) then
          isInMarker  = true
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_jobpolice:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_jobpolice:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_jobpolice:hasExitedMarker', LastStation, LastPart, LastPartNum)
        isindressingmenu = false
      end

    end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
  while true do
    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
      local playerPed = PlayerPedId()
	  if not IsPedInAnyVehicle(playerPed, false) then
        local coords = GetEntityCoords(playerPed)

        local found = false
	    for _, prop in ipairs({
          'prop_roadcone02a',
          'prop_barrier_work05',
          'p_ld_stinger_s'
        }) do
          local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  GetHashKey(prop), false, false, false)
          if DoesEntityExist(object) then
            CurrentAction     = 'remove_entity'
            CurrentActionMsg  = _U('remove_prop')
            CurrentActionData = {entity = object}
		    found = true
		    break
          end
        end

	    if not found and CurrentAction == 'remove_entity' then
          CurrentAction = nil
        end

	    Citizen.Wait(100)
      else
        Citizen.Wait(1000)
	  end
    else
      Citizen.Wait(1000)
    end
  end
end)

Citizen.CreateThread(function()
	local object
	while true do
		Citizen.Wait(200)
		local coords = GetEntityCoords(PlayerPedId())

		local pass = false
		if not object or object == 0 then
			pass = true
		elseif not DoesEntityExist(object) or #(coords - GetEntityCoords(object)) > 30.0 then
			pass = true
		end

		if pass then
			object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 30.0, 'p_ld_stinger_s', false, false, false)
		end

		if object and object ~= 0 then
			for _, vehicle in ipairs(ESX.Game.GetVehicles()) do
				local position = GetEntityCoords(vehicle)
				if #(position - coords) <= 30.0 then
					local closest = GetClosestObjectOfType(position.x, position.y, position.z, 1.5, 'p_ld_stinger_s', false, false, false)
					if closest and closest ~= 0 then
						for i = 0, 7 do
							if not IsVehicleTyreBurst(vehicle, i, true) then
								SetVehicleTyreBurst(vehicle, i, true, 1000)
							end
						end
					end
				end
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
  local timer = GetGameTimer()
	while true do

		Citizen.Wait(1)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    
      if IsControlJustReleased(0, Keys['E']) then
        if CurrentAction == 'menu_info' then
          local count = exports['esx_scoreboard']:counter('police')
          ShowAboveRadarMessage('~b~Ilość funkcjonariuszy na służbie: ~w~' .. count)
        elseif PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
          if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
          elseif (PlayerData.job.name == 'police' or (PlayerData.job.name == 'offpolice' and PlayerData.job.grade_name == 'boss')) and CurrentAction == 'menu_boss_actions' then
            ESX.UI.Menu.CloseAll()
            bossmenubotak()
          elseif CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
            elseif CurrentAction == 'delete_vehicle' then
              ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
          elseif PlayerData.job.name == 'police' then
            if CurrentAction == 'menu_armory' then
              OpenArmoryMenu(CurrentActionData.station)
            elseif CurrentAction == 'remove_entity' then
              ESX.Game.DeleteObject(CurrentActionData.entity)
            end
          end
        end
        
        CurrentAction = nil
      end
    end
		
		if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
			OpenPoliceActionsMenu()
    end
    
		if IsControlPressed(0, Keys['LEFTSHIFT']) and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead and PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
			DisableControlAction(2, Keys['H'], true)
			if IsDisabledControlJustPressed(2, Keys['H']) and timer < GetGameTimer() then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent('esx_jobpolice:drag', GetPlayerServerId(closestPlayer))
				end

				timer = GetGameTimer() + 500
			end
    end
    
    if IsControlJustReleased(0, Keys['M']) and not isDead and PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
      TriggerServerEvent('ceba:ShowPlate')
    end
		
		if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())
			
			CurrentTask.Busy = false
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_jobpolice:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_jobpolice:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_jobpolice:unrestrain')
	end
end)

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
  CurrentTask.Task = false
  CurrentTask.Busy = false
end

RegisterNetEvent('esx_jobpolice:kajdanki')
AddEventHandler('esx_jobpolice:kajdanki', function()
  menu()
end)

RegisterNetEvent('esx_jobpolice:przeszukaj')
AddEventHandler('esx_jobpolice:przeszukaj', function()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local rped2 = GetClosestPed(pos['x'], pos['y'], pos['z'], 20.05, 1, 0, 0, 0, -1)
  local closestPlayer = ESX.Game.GetClosestPlayer()
  if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mp_arresting", "idle", 3) or IsEntityDead(GetPlayerPed(closestPlayer)) then
    OpenBodySearchMenu(closestPlayer)
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if IsEntityPlayingAnim(closestPlayerPed, "mp_arresting", "idle", 3 ) then
      TriggerEvent('esx_jobpolice:playAnim', 'anim@gangops@facility@servers@bodysearch@', 'player_search')
    end
  end
end)

RegisterNetEvent('esx_jobpolice:takeVehicle')
AddEventHandler('esx_jobpolice:takeVehicle', function()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
        ImpoundVehicle(vehicle)
        TriggerServerEvent('esx_jobpolice:takeVehicle', vehicleData.plate)
    else
        ESX.ShowNotification("Brak pojazdów w pobliżu")
    end
end)

RegisterNetEvent('esx_jobpolice:OutVehicle')
AddEventHandler('esx_jobpolice:OutVehicle', function()
  if IsHandcuffed then
    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      TaskLeaveVehicle(playerPed, vehicle, 16)
      RequestAnimDict('mp_arresting')
      while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(0)
      end
      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0.0, 0, 0, 0)
	  end
  end
end)

RegisterNetEvent('esx_jobpolice:putouttrunk')
AddEventHandler('esx_jobpolice:putouttrunk', function()
		local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true)
	vehicleTrunk = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
	PlayerIsInTrunk = not PlayerIsInTrunk

--if not IsHandcuffed then
--TriggerEVent('esx_jobpolice:handcuff')
--end
	SetVehicleDoorOpen(vehicleTrunk, 5, false, false)
Wait(300)
		SetVehicleDoorShut(vehicleTrunk, 5, false)
if not PlayerIsInTrunk then
	DetachEntity(playerPed, 0, true)
	SetEntityVisible(playerPed, true)
DisplayRadar(true)
end
end
end)

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(5)

           if PlayerIsInTrunk then

           local playerPed = PlayerPedId()
            local boneName = GetEntityBoneIndexByName(vehicleTrunk, 'boot')
       if currentView ~= 4 then
           SetFollowPedCamViewMode(4)
           Citizen.Trace(GetFollowPedCamViewMode())
       end
DisplayRadar(false)
 DisableControlAction(0, 322, true) -- Animations
 DisableControlAction(0, 177, true) -- Animations
 DisableControlAction(0, 200, true) -- Animations
 DisableControlAction(0, 202, true) -- Animations
 DisableControlAction(0, Keys['P'], true) -- Job
 DisableControlAction(0, 1, true) -- Disable pan
 DisableControlAction(0, 2, true) -- Disable tilt
 DisableControlAction(0, 24, true) -- Attack
 DisableControlAction(0, 257, true) -- Attack 2
 DisableControlAction(0, 25, true) -- Aim
 DisableControlAction(0, 263, true) -- Melee Attack 1
 DisableControlAction(0, Keys['W'], true) -- W
 DisableControlAction(0, Keys['A'], true) -- A
 DisableControlAction(0, 31, true) -- S (fault in Keys table!)
 DisableControlAction(0, 30, true) -- D (fault in Keys table!)

 DisableControlAction(0, Keys['R'], true) -- Reload
 DisableControlAction(0, Keys['SPACE'], true) -- Jump
 DisableControlAction(0, Keys['Q'], true) -- Cover
 DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
 DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

 DisableControlAction(0, Keys['F1'], true) -- Disable phone
 DisableControlAction(0, Keys['F2'], false) -- Inventory
 DisableControlAction(0, Keys['F3'], true) -- Animations
 DisableControlAction(0, Keys['F6'], true) -- Job

 DisableControlAction(0, Keys['V'], true) -- Disable changing view
 DisableControlAction(0, Keys['C'], true) -- Disable looking behind
 DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
 DisableControlAction(2, Keys['P'], true) -- Disable pause screen

 DisableControlAction(0, 59, true) -- Disable steering in vehicle
 DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
 DisableControlAction(0, 72, true) -- Disable reversing in vehicle

 DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

 DisableControlAction(0, 47, true)  -- Disable weapon
 DisableControlAction(0, 264, true) -- Disable melee
 DisableControlAction(0, 257, true) -- Disable melee
 DisableControlAction(0, 140, true) -- Disable melee
 DisableControlAction(0, 141, true) -- Disable melee
 DisableControlAction(0, 142, true) -- Disable melee
 DisableControlAction(0, 143, true) -- Disable melee
 DisableControlAction(0, 75, true)  -- Disable exit vehicle
 DisableControlAction(27, 75, true) -- Disable exit vehicle
--bag = CreateObject(GetHashKey("prop_beach_punchbag"), 0, 0, 0, true, true, true)

            AttachEntityToEntity(playerPed, vehicleTrunk, boneName, 0.1, 0, -0.75, 0, 0, 0, 0, true, false, true , 0, false)

           -- AttachEntityToEntity(bag, vehicleTrunk, boneName, 0, 0, 0, 0, 0, 0, 0, true, false, true , 0, false)
SetEntityVisible(playerPed, false)
end
end
end)


function SearchPhone(player)
	local elements = {}
  local cards = {}
  local gracz = GetPlayerServerId(player)
	ESX.TriggerServerCallback('route68:stealsimsy', function(cards)
		for _,v in pairs(cards) do
			local cardNummer = v.number
    	local lejbel = 'SIM #' .. cardNummer
			table.insert(elements, {label = lejbel , value = v})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'search_telefon',
		{
			title    = 'Telefon',
			align    = 'center',
			elements = elements,
		},
		function(data, menu)
      TriggerServerEvent('sandy:zajebnumber', gracz, data.current.value.number)
      menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)	
	end, gracz)
end

function menu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
  {
    title = 'Kajdanki',
    align = 'center',
    elements = {
		{label = 'Skuj / Rozkuj',		value = 'handcuff'},
    {label = 'Przeszukaj',			value = 'body_search'},
		{label = 'Chwyc / Puść',			value = 'drag'},
		{label = 'Wloz do pojazdu',	value = 'put_in_vehicle'},
    {label = 'Wyjmij z pojazdu',	value = 'out_the_vehicle'},
    {label = 'Karty SIM',  value = 'sim'}
	}
  }, function(data, menu)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 2.0 then
          local closestPed = GetPlayerPed(closestPlayer)
          local action = data.current.value
          if data.current.value == 'body_search' then
            if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
              if IsPedCuffed(closestPed) then
                if not exports['esx_property']:isInProperty() then
                  TriggerServerEvent('esx_jobpolice:przeszukaj', GetPlayerServerId(closestPlayer))
                else
                  ESX.ShowNotification('~r~Nie możesz przeszukiwać w mieszkaniu!')
                end
              end
            else
              ESX.ShowNotification('~r~Nie możesz przeszukiwać w ruchu!')
            end
            elseif data.current.value == 'handcuff' then
              if not IsPedSprinting(PlayerPedId()) and not IsPedWalking(PlayerPedId()) then
                if not exports['esx_property']:isInProperty() then
                  	TriggerServerEvent('esx_jobpolice:handcuff', GetPlayerServerId(closestPlayer))
                else
                  ESX.ShowNotification('~r~Nie możesz zakuwać w mieszkaniu!')
                end
              else
                ESX.ShowNotification('~r~Nie możesz zakuwać w ruchu!')
              end
            elseif action == 'sim' then
              if IsPedCuffed(closestPed) then
                TriggerServerEvent('esx_jobpolice:message', GetPlayerServerId(closestPlayer), 'Twój telefon jest PRZESZUKIWANY!')
                SearchPhone(closestPlayer)
              else
                ESX.ShowNotification('~r~Najpierw zakuj obywatela')
              end
            elseif data.current.value == 'drag' then
				      if IsPedCuffed(closestPed) then
                TriggerServerEvent('esx_jobpolice:drag', GetPlayerServerId(closestPlayer))
              else
                ESX.ShowNotification("~r~Najpierw musisz zakuć obywatela.")
				      end
            elseif data.current.value == 'put_in_vehicle' then
              TriggerServerEvent('esx_jobpolice:putInVehicle', GetPlayerServerId(closestPlayer))
            elseif data.current.value == 'out_the_vehicle' then
              TriggerServerEvent('esx_jobpolice:OutVehicle', GetPlayerServerId(closestPlayer))
            end
        else
            ESX.ShowNotification('Brak graczy w ~r~pobliżu')
        end
    end, function(data, menu)
		menu.close()
	end)
end

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function openPolice()
  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
    OpenPoliceActionsMenu()
    GUI.Time = GetGameTimer()
  end
end

function getJob()
  if PlayerData.job ~= nil then
	return PlayerData.job.name
  end
end

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer then
		ESX.ClearTimeout(HandcuffTimer)
	end

	HandcuffTimer = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_jobpolice:unrestrain')
	end)
end

function bossmenubotak()
    ESX.UI.Menu.CloseAll()

      ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'extras_actions_actions',
      {
        title    = 'Menu Dodatkow',
        align    = 'center',
        elements = {
          {label = 'Akcje Szefa', value = 'boss'},
          {label = 'Odznaki', value = 'badge'}
        }

      }, function(data, menu)
        if data.current.value == 'boss' then
             TriggerEvent('esx_societymordo:openBossMenu', 'police', function(data, menu)
              menu.close()
              CurrentAction     = 'menu_boss_actions'
              CurrentActionMsg  = _U('open_bossmenu')
              CurrentActionData = {}
            end)
        elseif data.current.value == 'badge' then
          menuodznaka()
          menu.close()
        end

      end, function(data, menu)
        menu.close()
      end)
end

function menuodznaka()

  ESX.TriggerServerCallback('esx_jobpolice:sandyshowodznakas', function(dane)

    local elements = {
      head = {'Funkcjonariusz', 'Numer Odznaki', 'Akcje'},
      rows = {}
    }

    for i=1, #dane, 1 do
      local imieinazwisko = (dane[i].firstname .. ' ' .. dane[i].lastname)

      table.insert(elements.rows, {
        data = dane[i],
        cols = {
          imieinazwisko,
          dane[i].numerodznaki,
          '{{' .. 'Nadaj' .. '|nadaj}} {{' .. 'Usun' .. '|usun}}'
        }
      })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'odznaka_list', elements, function(data, menu)
      local policjant = data.data

      if data.value == 'nadaj' then
      ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'set_numerodznaki',
            {
              title = 'Nadaj Numer Odznaki',
            },
            function(data2, menu)

              local quantity = data2.value

              if quantity == nil then
                ESX.ShowNotification('~r~Nieprawidlowy Numer Odznaki')
              else
                menu.close()
                local policjantimie = (policjant.firstname .. ' ' .. policjant.lastname)
                TriggerServerEvent('esx_jobpolice:sandysetodznaka', policjant.identifier, policjantimie, quantity)
              end
            end,
            function(data2,menu)
              menu.close()
            end
          )
      menu.close()
      elseif data.value == 'usun' then
        local policjantimie = (policjant.firstname .. ' ' .. policjant.lastname)
                TriggerServerEvent('esx_jobpolice:sandyremoveodznaka', policjant.identifier, policjantimie)
            menu.close()
      end
    end, function(data, menu)
      menu.close()
    end)
  end)

end

RegisterNetEvent('esx_jobpolice:DisplayPlate')
AddEventHandler('esx_jobpolice:DisplayPlate', function(id, playerName, job, nrodznaki)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
  TriggerEvent("pNotify:SendNotification", {
          text = "<font style='font-size: 14px'><div style='min-width: 270px; min-height: 350px; background-image: url(https://i.imgur.com/4kOmmVz.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: relative; top:120px; color:#fff; text-shadow: 0px 0px 5px rgba(0, 0, 0, 1); line-height: 5px; font-family: courier;'><CENTER><font style='font-size: 20px; font-family: Impact, Charcoal; margin-left: 2px;'>" ..playerName.."</font><B><p style='font-size: 14px;font-family: Arial, Helvetica; margin-left: 2px;'><br>".. job .. "</font><p style='font-size: 14px;font-family: Arial, Helvetica; margin-left: 2px;'>Numer Odznaki: ".. nrodznaki .."</div>",
          type = "aqua",
          queue = "global",
          timeout = 10000,
          layout = "centerLeft"
        }) 
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 3.9999 then
       TriggerEvent("pNotify:SendNotification", {
          text = "<font style='font-size: 14px'><div style='min-width: 270px; min-height: 350px; background-image: url(https://i.imgur.com/4kOmmVz.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: relative; top:120px; color:#fff; text-shadow: 0px 0px 5px rgba(0, 0, 0, 1); line-height: 5px; font-family: courier;'><CENTER><font style='font-size: 20px; font-family: Impact, Charcoal; margin-left: 2px;'>" ..playerName.."</font><B><p style='font-size: 14px;font-family: Arial, Helvetica; margin-left: 2px;'><br>".. job .. "</font><p style='font-size: 14px;font-family: Arial, Helvetica; margin-left: 2px;'>Numer Odznaki: ".. nrodznaki .."</div>",
          type = "aqua",
          queue = "global",
          timeout = 10000,
          layout = "centerLeft"
        })
  end
end)

local plateModel = "prop_fib_badge"
local animDict = "paper_1_rcm_alt1-9"
local animName = "player_one_dual-9"
local plate_net = nil

RegisterNetEvent("esx_jobpolice:plateanim")
AddEventHandler("esx_jobpolice:plateanim", function()

  RequestModel(GetHashKey(plateModel))
  while not HasModelLoaded(GetHashKey(plateModel)) do
    Citizen.Wait(100)
  end

  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Citizen.Wait(100)
  end

  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
  local platespawned = CreateObject(GetHashKey(plateModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
  Citizen.Wait(1000)
  TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
  AttachEntityToEntity(platespawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.115, -0.011, -0.045, 90.0, 90.0, 60.0, true, true, false, false, 2, true)
  Citizen.Wait(3000)
  ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
  DeleteObject(platespawned)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local myCoords = GetEntityCoords(GetPlayerPed(-1))
    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 624.43,1.71,82.78, true ) < 80 then
      ClearAreaOfPeds(624.43,1.71,82.78, 58.0, 0)
    end
  end
end)