ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Licenses                = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
      Config.Zones[k].Items = v
    end
  end)
end)

RegisterNetEvent('esx_weashop:loadLicenses')
AddEventHandler('esx_weashop:loadLicenses', function(licenses)
  for i = 1, #licenses, 1 do
    Licenses[licenses[i].type] = true
  end
end)

function OpenBuyLicenseMenu (zone)
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_license',
    {
      title = _U('buy_license'),
      elements = {
        { label = _U('yes') .. ' ($' .. Config.LicensePrice .. ')', value = 'yes' },
        { label = _U('no'), value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
        TriggerServerEvent('esx_weashop:buyLicense')
      end

      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end

function OpenShopMenu(zone)

  local elements = {}

  for i=1, #Config.Zones[zone].Items, 1 do

    local item = Config.Zones[zone].Items[i]

    table.insert(elements, {
      label     = item.label .. ' - <span style="color:green;">$' .. item.price .. ' </span>',
      realLabel = item.label,
      value     = item.name,
      price     = item.price
    })

  end


  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop',
    {
      title  = _U('shop'),
      align = 'center',
      elements = elements
    },
    function(data, menu)
    	local ped = GetPlayerPed(-1)
    	local weaponHash = GetHashKey(data.current.value)
		if not HasPedGotWeapon(ped, weaponHash, false) then
      		TriggerServerEvent('esx_weashop:buyItem', data.current.value, data.current.price, zone)
      	else
      		ESX.ShowNotification('Posiadasz juz ta bron!')
      	end
    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'shop_menu'
      CurrentActionMsg  = _U('shop_menu')
      CurrentActionData = {zone = zone}
    end
  )
end

AddEventHandler('esx_weashop:hasEnteredMarker', function(zone)

  CurrentAction     = 'shop_menu'
  CurrentActionMsg  = _U('shop_menu')
  CurrentActionData = {zone = zone}

end)

AddEventHandler('esx_weashop:hasExitedMarker', function(zone)

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()

end)

-- Create Blips
Citizen.CreateThread(function()
  for k,v in pairs(Config.Zones) do
  if v.legal==0 then
    for i = 1, #v.Pos, 1 do
    local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
    SetBlipSprite (blip, 313)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)
    end
    end
  end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 5.0) then
          DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
          isInMarker  = true
          ShopItems   = v.Items
          currentZone = k
          LastZone    = k
        end
      end
    end
    if isInMarker and not HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = true
      TriggerEvent('esx_weashop:hasEnteredMarker', currentZone)
    end
    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_weashop:hasExitedMarker', LastZone)
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0, 38) then

        if CurrentAction == 'shop_menu' then
          if Config.EnableLicense == true then
            if Licenses['weapon'] ~= nil or Config.Zones[CurrentActionData.zone].legal == 1 then
              OpenShopMenu(CurrentActionData.zone)
            else
              ESX.ShowNotification("~r~Nie posiadasz~s~ licencji na broń, wyrób u ~b~LSPD~s~!")
            end
          else
            OpenShopMenu(CurrentActionData.zone)
          end
        end

        CurrentAction = nil

      end

    end
  end
end)

-- thx to Pandorina for script
RegisterNetEvent('esx_weashop:clipcli')
AddEventHandler('esx_weashop:clipcli', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('esx_weashop:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash, math.random(40,55))
      ESX.ShowNotification("Uzyles amunicji")
    else
      ESX.ShowNotification("~r~Nie masz broni w ręku")
    end
  else
    ESX.ShowNotification("~r~Ten rodzaj amunicji nie jest odpowiedni")
  end
end)
--[[
Citizen.CreateThread(function()
  RequestModel(GetHashKey("s_m_y_dealer_01"))
  while not HasModelLoaded(GetHashKey("s_m_y_dealer_01")) do
    Wait(155)
  end

local ped =  CreatePed(4, GetHashKey("s_m_y_dealer_01"), 511.4, -3118.17, 25.57-0.90, 278.21, false, true)
FreezeEntityPosition(ped, true)
SetEntityInvincible(ped, true)
SetBlockingOfNonTemporaryEvents(ped, true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		local ped = PlayerPedId()
		local koordy = GetEntityCoords(ped)

	if GetDistanceBetweenCoords(koordy, 512.28, -3118.15, 25.57, true ) < 25 then
       DrawMarker(25, 512.28, -3118.15, 25.57-0.99, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(koordy, 512.28, -3118.15, 25.57, true ) < 3.0 then
                if IsControlJustReleased(1, 51) then
                    Citizen.Wait(100)
                    TriggerServerEvent("esx_weashop:dajinfo")
                    Citizen.Wait(100)
                end
            end
	end
end
end)
]]--

RegisterNetEvent('esx_weashop:infocorrect')
AddEventHandler('esx_weashop:infocorrect', function()
	ESX.ShowAdvancedNotification("DirtyJoe", "WIADOMOŚĆ", "Uderz do mnie, haslo prowadzhamwik", "CHAR_MP_MERRYWEATHER", 9)
end)