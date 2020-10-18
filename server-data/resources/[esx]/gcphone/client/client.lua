--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================
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
-- Configuration
local PlayerData = {}
local SimTab = {}
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}
local KeyOpenClose = 288 -- F3
local KeyTakeCall = 38 -- E
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = true
local callStartTime = nil
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false
local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0
local TokoVoipID = nil
local alert = nil
local alertOwner = nil
local alertkurwa = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  ESX.TriggerServerCallback("route68:getSim", function(result2)
    SimTab = result2
  end)
  ESX.TriggerServerCallback("route68:getCurrentSim", function(result2)
    myPhoneNumber = result2
    TriggerServerEvent("route68:SetNumberWejscie", result2)
  end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('rich-alert:callNumber')
AddEventHandler('rich-alert:callNumber', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  if message == nil then
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
  end
  if message ~= nil and message ~= "" then
    TriggerServerEvent('rich-alert:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
		local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local lokalizacja = ""
    if s2 == 0 then
      lokalizacja = "Lokalizacja: "..street1
    elseif s2 ~= 0 then
      lokalizacja = "Lokalizacja: "..street1.." - "..street2
    end
  end
  
  ESX.ShowNotification('~g~Zgłoszenie wysłane.')
end)

RegisterNetEvent('gln:zaakceptowalizgloszenie')
AddEventHandler('gln:zaakceptowalizgloszenie', function()
  alert = nil	
  alertOwner = nil
end)

RegisterNetEvent('rich-alert:callNumberD')
AddEventHandler('rich-alert:callNumberD', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  
  if message ~= nil and message ~= "" then
    TriggerServerEvent('rich-alert:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    }, GetPlayerServerId(PlayerId()))
  end
  
  ESX.ShowNotification('~g~Zgłoszenie wysłane.')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if alert ~= nil then	
			ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, zaakceptować zgłoszenie')
			if IsControlJustReleased(0, 38) then
				AcceptAlert(alert, alertOwner)		
				Citizen.Wait(10)
				alert = nil	
        alertOwner = nil
        alertkurwa = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
    if alert ~= nil then
      Wait(10000)
      alert = nil
      if alertkurwa ~= true then
        ESX.ShowNotification('~r~Zgłoszenie wygasło')
      end
      alertkurwa = false
    end
  end
end)

function AcceptAlert(data, aO)
	if data.coords then
	ClearGpsPlayerWaypoint()
	SetNewWaypoint(data.coords.x, data.coords.y)
	end
	TriggerServerEvent('rich-alert:acceptedAlert', data, aO)
end

RegisterNetEvent('rich-alert:sendAlert')
AddEventHandler('rich-alert:sendAlert', function(data, id)
	if data.number == 'police' then
		alert = data
		alertOwner = id
		if not HasStreamedTextureDictLoaded('WEB_LOSSANTOSPOLICEDEPT') then
			RequestStreamedTextureDict('WEB_LOSSANTOSPOLICEDEPT', true)
			while not HasStreamedTextureDictLoaded('WEB_LOSSANTOSPOLICEDEPT') do
				Wait(50)
			end
		end
		Notif(data.message, 'WEB_LOSSANTOSPOLICEDEPT', 'LSPD | Centrala', '~o~Zgłoszenie', 2)
		Citizen.Wait(100)
		--SetStreamedTextureDictAsNoLongerNeeded(charimg)
	elseif data.number == 'ambulance' then
		alert = data
		alertOwner = id
		Notif(data.message, 'CHAR_CALL911', 'EMS | Centrala', '~o~Wezwanie', 2)
	elseif data.number == 'mecano' then
		alert = data
		alertOwner = id
		Notif(data.message, 'CHAR_LS_CUSTOMS', "LSC | Centrala", '~o~Wezwanie', 2)
	elseif data.number == 'taxi' then
		alert = data
		alertOwner = id
		Notif(data.message, 'CHAR_TAXI', "Dyspozytornia", '~o~Klient', 2)
	end
end)

function Notif(text, charimg, text2, text3, bgcol)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
	Citizen.InvokeNative(0x92F0DA1E27DB96DC, bgcol)
	Citizen.InvokeNative(0x1E6611149DB3DB6B, charimg, charimg, true, 7, text2, text3, 2.0)
    DrawNotification_4(true, true)
end



--Duzo sim karty + NativeUI

_menuPool = NativeUI.CreatePool()
_menuPool:RefreshIndex()

RegisterNetEvent('route68:syncSim')
AddEventHandler('route68:syncSim', function()
    ESX.TriggerServerCallback("route68:getSim", function(result)
        SimTab = result
    end)
end)

RegisterNetEvent("route68:shownotif")
AddEventHandler("route68:shownotif", function(text, color)

	ESX.ShowAdvancedNotification('Operator', 'Telefon', text, 'CHAR_CHAT_CALL', 1)
	--TriggerEvent('pNotify:SendNotification', {text = text})
    --Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
    --SetNotificationTextEntry("STRING")
    --AddTextComponentString(text)
    --DrawNotification(false, true)
end)

--[[
function OpenMenu()
  _menuPool:CloseAllMenus()
  simCardMenu = NativeUI.CreateMenu("Operator", "Karta Sim", 5, 200)
  _menuPool:Add(simCardMenu)
  menu = simCardMenu
  number = {}
  local index565 = nil
  result = SimTab
  if #result == 0 then

      use = NativeUI.CreateItem("Brak Karty SIM", "")

      menu:AddItem(use)
  end
  for i = 1, #result, 1 do
      table.insert(number, {
          number = result[i].number,
          label = result[i].label,
      })
      local c = _menuPool:AddSubMenu(menu, result[i].label, "Karta SIM: " .. result[i].number, true, true, false)
      use = NativeUI.CreateItem("Aktywuj kartę SIM", "")
      donner = NativeUI.CreateItem("Przekaż kartę SIM", "")
	  off = NativeUI.CreateItem("Odepnij kartę SIM", "")
      jeter = NativeUI.CreateItem("Wyrzuć kartę SIM", "")
      c:AddItem(use)
      c:AddItem(donner)
	  c:AddItem(off)
      c:AddItem(jeter)
      menumbk = menu
      menu.OnItemSelect = function(_, _, Index3)
          --(Index3)
          index565 = Index3
      end
      c.OnItemSelect = function(menu, _, index)
          --(index)
          if index == 1 then
              ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                  if qtty > 0 then
                      TriggerServerEvent("route68:SetNumber", number[index565].number)
                  else
					  ESX.ShowAdvancedNotification('Operator', 'Telefon', 'Nie posiadasz ~r~telefonu', 'CHAR_CHAT_CALL', 1)
					  --TriggerEvent('pNotify:SendNotification', {text = "~r~Nie posiadasz telefonu"})
                  end
              end, 'phone')
              _menuPool:CloseAllMenus()
          end
          if index == 2 then

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              local closestPed = GetPlayerPed(closestPlayer)

              if IsPedSittingInAnyVehicle(closestPed) then
          --TriggerEvent('pNotify:SendNotification', {text = "Nie możesz przekazać karty w pojeździe"})
          ESX.ShowNotification("~r~Nie możesz przekazać karty w pojeździe")
                  return
              end

              if closestPlayer ~= -1 and closestDistance < 3.0 then
                  TriggerServerEvent('route68:GiveNumber', GetPlayerServerId(closestPlayer), number[index565].number)

                  table.remove( SimTab, i )
				   _menuPool:CloseAllMenus()
              else
                  ESX.ShowNotification("~r~Nikogo nie ma w pobliżu")
              end

          end
          if index == 3 then
              TriggerServerEvent('route68:off', number[index565].number,number[index565])
              --table.remove( SimTab, i )
              menumbk:Clear()
              menu:GoBack()
              OpenMenu()
          end
		 
          if index == 4 then
              TriggerServerEvent('route68:Throw', number[index565].number,number[index565])
              table.remove( SimTab, i )
              menumbk:Clear()
              menu:GoBack()
              OpenMenu()
          end
		  
		  RegisterNetEvent('gcphone:zajebkarte')
		  AddEventHandler('gcphone:zajebkarte', function()
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              local closestPed = GetPlayerPed(closestPlayer)


              if closestPlayer ~= -1 and closestDistance < 3.0 then
                  TriggerServerEvent('route68:GiveNumber', GetPlayerServerId(closestPlayer), result[i].number)

                  table.remove( SimTab, i )
				   _menuPool:CloseAllMenus()
              else
                  ESX.ShowNotification("~r~Nikogo nie ma w pobliżu")
              end
		  end)
		  
		  
      end
  end
  menumbk = menu
  _menuPool:RefreshIndex()
  menumbk:Visible(true)
end
--]]
function OpenMenu()
	ESX.UI.Menu.CloseAll()
	number = {}
  	local index565 = nil
  	result = SimTab
  	if #result == 0 then
  		ESX.ShowNotification("~r~Brak karty sim")
  	end
  	for i = 1, #result, 1 do
      table.insert(number, {
          value = result[i].number,
          label = result[i].label,
      })
    end
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'simcards_actions',
    {
        title    = 'Karty SIM',
        align    = 'center',
        elements = number

    }, function(data, menu)
    		Openkurwa2Menu(data.current)
    end, function(data, menu)
    menu.close()
    end)
end

RegisterNetEvent('sandy:idkkurwamozedziala')
AddEventHandler('sandy:idkkurwamozedziala', function(kurwanumber)
  Openkurwa2Menu(kurwanumber)
end)

function Openkurwa2Menu(result)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'simcards_actions2', {
		title    = (result.label),
		align    = 'bottom-right',
		elements =  {
		{label = ('Aktywuj kartę SIM'),     value = '1'},
		{label = ('Przekaż kartę SIM'),     value = '2'},
		{label = ('Odepnij kartę SIM'),     value = '3'},
		{label = ('Wyrzuć kartę SIM'),      value = '4'},
	}
	}, function(data2, menu2)
	
	    if data2.current.value == '1' then
	    	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
            if qtty > 0 then
                TriggerServerEvent("route68:SetNumber", result.value)
            else
				ESX.ShowAdvancedNotification('Operator', 'Telefon', 'Nie posiadasz ~r~telefonu', 'CHAR_CHAT_CALL', 1)
				--TriggerEvent('pNotify:SendNotification', {text = "~r~Nie posiadasz telefonu"})
                end
            end, 'phone')
			menu2.close()
        elseif data2.current.value == '2' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            local closestPed = GetPlayerPed(closestPlayer)
            if IsPedSittingInAnyVehicle(closestPed) then
          		--TriggerEvent('pNotify:SendNotification', {text = "Nie możesz przekazać karty w pojeździe"})
          		ESX.ShowNotification("~r~Nie możesz przekazać karty w pojeździe")
                return
            end
            if closestPlayer ~= -1 and closestDistance < 3.0 then
                TriggerServerEvent('route68:GiveNumber', GetPlayerServerId(closestPlayer), result.value)

                table.remove( SimTab, i )
				menu2.close()
           	else
                ESX.ShowNotification("~r~Nikogo nie ma w pobliżu")
            end
			menu2.close()
		elseif data2.current.value == '3' then
			TriggerServerEvent('route68:off', result.value,result)
            --table.remove( SimTab, i )
            menu2.close()
		elseif data2.current.value == '4' then
      print(result.number)
			TriggerServerEvent('route68:Throw', result.value,result)
            table.remove( SimTab, i )
			     menu2.close()
        end	
	end, function(data2, menu2)
		menu2.close()
	end)
end

RegisterNetEvent('gcphone:zajebkarte')
AddEventHandler('gcphone:zajebkarte', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local closestPed = GetPlayerPed(closestPlayer)

    if closestPlayer ~= -1 and closestDistance < 3.0 then
        TriggerServerEvent('route68:GiveNumber', GetPlayerServerId(closestPlayer), result[i].number)
        table.remove( SimTab, i )
    else
        ESX.ShowNotification("~r~Nikogo nie ma w pobliżu")
    end
end)


RegisterNetEvent('kartasim')
AddEventHandler('kartasim', function()

ESX.TriggerServerCallback("route68:getSim", function(result2)
    SimTab = result2
    OpenMenu()
end)

end)

RegisterNetEvent('telefon')
AddEventHandler('telefon', function()

TooglePhone()
end)

RegisterNetEvent('kartasimsteel')
AddEventHandler('kartasimsteel', function()
  local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
			TriggerServerEvent('gcphone:zabierz', GetPlayerServerId(closestPlayer))
		else
			ESX.ShowNotification("~g~W poblizu nie ma zadnego ~r~Obywatela")
	end
end)

--====================================================================================
--  Check si le joueurs poséde un téléphone
--  Callback true or false
--====================================================================================
function hasPhone (cb)
  cb(true)
end
--====================================================================================
--  Que faire si le joueurs veut ouvrir sont téléphone n'est qu'il en a pas ?
--====================================================================================
function ShowNoPhoneWarning ()
end

ESX = nil
  Citizen.CreateThread(function()
      while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
    end
  end)
  
  function hasPhone (cb)
    if (ESX == nil) then return cb(0) end
    ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
      cb(qtty > 0)
    end, 'phone')
  end
  function ShowNoPhoneWarning ()
    if (ESX == nil) then return end
    ESX.ShowNotification("Nie masz przy sobie ~r~telefonu!")
  end


--====================================================================================
--  
--====================================================================================
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    _menuPool:ProcessMenus()
    --[[
    if IsControlJustPressed(1, Keys['F7']) then
      ESX.TriggerServerCallback("route68:getSim", function(result2)
        SimTab = result2
        OpenMenu()
      end)
    end
    ]]--
    if IsControlJustPressed(1, Keys['F1']) then
      ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
        if tonumber(myPhoneNumber) ~= nil then
            if qtty > 0 then
              TooglePhone()
              TriggerServerEvent("gcPhone:allUpdate")
            else
              ESX.ShowAdvancedNotification('AuraLTE 4G', 'Telefon', 'Nie posiadasz ~r~telefonu', 'CHAR_CHAT_CALL', 1)
              --TriggerEvent('pNotify:SendNotification', {text = "Nie posiadasz <font color='red'>telefonu</font>"})
            end
        else
            ESX.ShowAdvancedNotification('AuraLTE 4G', 'Telefon', 'Nie posiadasz podlaczonej ~r~karty sim', 'CHAR_CHAT_CALL', 1)
          --TriggerEvent('pNotify:SendNotification', {text = "Nie posiadasz podlaczonej <font color='red'>karty sim</font>"})
        end
      end, 'phone')

    end

    if menuIsOpen == true then
      DeadCheck()
      if menuIsOpen == true then
        for _, value in ipairs(KeyToucheCloseEvent) do
          if IsControlJustPressed(1, value.code) then
            SendNUIMessage({keyUp = value.event})
          end
        end
        hasFocus = false
      else
        if hasFocus == true then
          hasFocus = false
        end
      end
    end
  end


end)

RegisterNetEvent('gcPhone:ekwipunek')
AddEventHandler('gcPhone:ekwipunek', function()
if takePhoto ~= true then
    hasPhone(function (hasPhone)
      if hasPhone == true then
        TooglePhone()
      else
        ShowNoPhoneWarning()
      end
    end)
  if menuIsOpen == true then
    for _, value in ipairs(KeyToucheCloseEvent) do
      if IsControlJustPressed(1, value.code) then
        SendNUIMessage({keyUp = value.event})
      end
    end
    hasFocus = false
  else
    if hasFocus == true then
      hasFocus = false
    end
  end
end
end)


function DeadCheck() 
  local dead = IsEntityDead(GetPlayerPed(-1))
  if dead ~= isDead then 
    isDead = dead
    SendNUIMessage({event = 'updateDead', isDead = isDead})
  end
end

RegisterNetEvent('gcPhone:nowyPost')
AddEventHandler('gcPhone:nowyPost', function()
  hasPhone(function (hasPhone)
    if hasPhone == true then
      TriggerEvent('pNotify:SendNotification', {text = "Nowy wpis na Twitterze!", timeout=2000})
    end
  end)
end)

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
  local number = ''
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    number =  GetOnscreenKeyboardResult()
  end
  if number ~= '' then
    TriggerEvent('gcphone:autoCall', number, {
      useNumber = fixeNumber
    })
    PhonePlayCall(true)
  end
end

function TakeAppel (infoCall)
  TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

RegisterNetEvent("gcPhone:notifyFixePhoneChange")
AddEventHandler("gcPhone:notifyFixePhoneChange", function(_PhoneInCall)
  PhoneInCall = _PhoneInCall
end)

function PlaySoundJS (sound, volume)
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS (sound, volume)
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  SendNUIMessage({ event = 'stopSound', sound = sound})
end



RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TooglePhone()
  end
end)
 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("gcphone:myPhoneNumber")
AddEventHandler("gcphone:myPhoneNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  TriggerServerEvent("gcPhone:allUpdate")
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = _myPhoneNumber})
end)

RegisterNetEvent("route68:UpdateNumber")
AddEventHandler("route68:UpdateNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  TriggerServerEvent("gcPhone:allUpdate")
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)

RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message, sender)
  -- SendNUIMessage({event = 'updateMessages', messages = messages})
  SendNUIMessage({event = 'newMessage', message = message})
  if message.owner == 0 then
  ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
	  if qtty > 0 then
		Citizen.CreateThread(function()
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
			Citizen.Wait(300)
			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
			Citizen.Wait(300)

			PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
				local sourceKnown = nil
				for _, contact in pairs(contacts) do
					if contact.number == message.transmitter then
						sourceKnown = contact.display
						break
					end
				end

				local transmitter = 'Anonim'
				if message.transmitter ~= 'Anonim' then
					transmitter = tonumber(message.transmitter)
				end
					local pic = 'CHAR_HUMANDEFAULT'
          if not transmitter then
            return
					elseif sourceKnown then
						transmitter = message.transmitter
							local playerId = GetPlayerFromServerId(sender)
							local playerPed = GetPlayerPed(playerId)

							local headshot = RegisterPedheadshot(playerPed)
							while not IsPedheadshotReady(headshot) do
								Citizen.Wait(100)
							end

							pic = GetPedheadshotTxdString(headshot)
					end

          ESX.ShowAdvancedNotification((transmitter and (transmitter ~= 'Anonim' and '#' or '~r~') .. transmitter or message.transmitter), sourceKnown, message.message, pic, 1)

					if transmitter and sourceKnown then
						UnregisterPedheadshot(pic)
					end
		end)
	  end
	end, 'phone')
  end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gcPhone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
  SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
 
  if initiator == true then
    PhonePlayCall()
    if menuIsOpen == false then
      TooglePhone()
    end
  end
  
end)

  AddEventHandler('gcPhone:inCall', function(cb)
    return inCall ~= nil
  end)

  RegisterNetEvent("gcPhone:acceptCall")
  AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
    if inCall == false then
      inCall = true    
      NetworkSetTalkerProximity(3.0)
    end
  
    if not menuIsOpen then
      TooglePhone()
    end
  
    PhonePlayCall()
    SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
  end)
  
  RegisterNetEvent("gcPhone:rejectCall")
  AddEventHandler("gcPhone:rejectCall", function(infoCall)
    local callEndTime = GetCloudTimeAsInt()
    if inCall == true then
      inCall = false
      Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(10.0)
      if callStartTime ~= nil then
        TriggerServerEvent('gcphone:billCall', callEndTime - callStartTime)
        callStartTime = nil
      end
    else
      callStartTime = nil
    end
  
    if menuIsOpen then
      PhonePlayText()
    end
    SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
  end)


RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function startCall (phone_number, rtcOffer, extraData)
  callStartTime = GetCloudTimeAsInt()
  TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(3.0)
  end
  cb()
end)

RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
  cb()
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
  TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)





























































--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)

RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)

--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.message = 'GPS: ' .. string.format("%.2f", myPos.x) .. ', ' .. string.format("%.2f", myPos.y)
  end
  TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)
RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gcPhone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb) 
  local eventName = data.eventName or '' 
    if data.data ~= nil then  
      TriggerEvent(data.eventName, data.data) 
    else 
      TriggerEvent(data.eventName) 
    end 
  cb() 
end) 
RegisterNUICallback('useMouse', function(um, cb)
  useMouse = um
end)
RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gcPhone:deleteALL')
  cb()
end)

function TooglePhone() 
	menuIsOpen = not menuIsOpen
	SendNUIMessage({show = menuIsOpen})
	if menuIsOpen then 
		PhonePlayIn()
	else
		PhonePlayOut()
	end
end

RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  disableChat = false
  menuIsOpen = false
  SendNUIMessage({show = false})
  PhonePlayOut()
  Citizen.Wait(100)
  DisableControlAction(0, 245, false)
  EnableControlAction(0, 245, true)
  cb()
end)

----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------
AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "gcphone" then
      TriggerServerEvent('gcPhone:allUpdate')
  end
end)


RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb()
end)

RegisterNUICallback('takePhoto', function(data, cb)
	CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  Citizen.Wait(0)
  if hasFocus == true then
    hasFocus = false
  end
  local unload = false
	while takePhoto do
    Citizen.Wait(0)

		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      break
    elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
      local CLIENT_ID = '1f7e9c8bf314142'

      Citizen.InvokeNative(0xABA17D7CE615ADBF, "FMMC_PLYLOAD")
      Citizen.InvokeNative(0xBD12F8228410D9B4, 4)

      PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

      TriggerEvent('radar:setHidden', true)

      exports['screenshot-basic']:requestScreenshotUpload('https://api.imgur.com/3/image', 'imgur', {
          headers = {
              ['authorization'] = string.format('Client-ID %s', CLIENT_ID),
              ['content-type'] = 'multipart/form-data'
          }
      }, function(data)
        local resp = json.decode(data)
        DestroyMobilePhone()
        CellCamActivate(false, false)
        PhonePlayAnim('text', false, true)
        cb(json.encode({ url = resp.data.link  }))
        unload = true
      end)
      Citizen.Wait(3000)
			Citizen.InvokeNative(0x10D373323E5B9C0D)
			unload = false
      takePhoto = false
      TriggerEvent('radar:setHidden', false)
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
  end
end)

function getMenuIsOpen()
  return menuIsOpen
end

function openPhone()
  ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
    if tonumber(myPhoneNumber) ~= nil then
      
      if qtty > 0 then
        TooglePhone()
        TriggerServerEvent("gcPhone:allUpdate")
      else
        TriggerEvent('pNotify:SendNotification', {text = "Nie posiadasz <font color='red'>telefonu</font>"})
      end
    else
      TriggerEvent('pNotify:SendNotification', {text = "Nie posiadasz podlaczonej <font color='red'>karty sim</font>"})
    end
  end, 'phone')
end

function blockkarta()
  local elements = {}
  local cards = {}

  ESX.TriggerServerCallback('sandy:getoriginalkartas', function(cards)
    for _,v in pairs(cards) do
      local cardNummer = v.number
      local lejbel = 'SIM #' .. cardNummer
      table.insert(elements, {label = lejbel , value = cardNummer})
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'delete_numeros',
    {
      title    = 'Zablokuj Karte & Duplikat',
      align    = 'center',
      elements = elements,
    },
    function(data, menu)
      TriggerServerEvent('sandy:blockkarta', data.current.value)
    end,
    function(data, menu)
      menu.close()
    end
  ) 
  end)
end

local MiejsceSklepu = {x = -1081.74, y = -248.39, z = 37.76}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false) 
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, MiejsceSklepu.x, MiejsceSklepu.y, MiejsceSklepu.z)

		if dist <= 10.0 then
			DrawMarker(1, MiejsceSklepu.x, MiejsceSklepu.y, MiejsceSklepu.z-0.95, 0, 0, 0, 0, 0, 0, 1.301, 1.3001, 0.7001, 0, 205, 250, 200, 0, 0, 0, 0)
		else
			Citizen.Wait(1500)
		end
		
		if dist <= 1.0 then
			DrawText3D(MiejsceSklepu.x, MiejsceSklepu.y, MiejsceSklepu.z, "~g~[E]~w~ Aby wyrobić duplikat karty!")
			if IsControlJustPressed(0, Keys['E']) then
				blockkarta()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		if(GetDistanceBetweenCoords(coords, MiejsceSklepu.x, MiejsceSklepu.y, MiejsceSklepu.z, true) < 1.0) then
			isInMarker  = true
		end
			
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
		end
		if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      ESX.UI.Menu.CloseAll()
		end
	end
end)

function DrawText3D(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x, y, z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end