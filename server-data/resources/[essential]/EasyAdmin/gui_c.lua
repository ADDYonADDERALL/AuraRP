------------------------------------
------------------------------------
---- DONT TOUCH ANY OF THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
---- THESE ARE **NOT** CONFIG VALUES, USE THE CONVARS IF YOU WANT TO CHANGE SOMETHING
------------------------------------
------------------------------------

isAdmin = false
showLicenses = false

settings = {
	button = 289,
	forceShowGUIButtons = false,
}

permissions = {
	ban = false,
	kick = false,
	spectate = false,
	unban = false,
	teleport = false,
	manageserver = false,
	slap = false,
	freeze = false,
	screenshot = false,
	immune = false,
	anon = false,
	mute = false,
}

noClipSpeeds = {}
noclip = true
noClip = false
noClipSpeed = 0
noClipLabel = nil
playerblips = false
godmode = false
rainbowcar = false
carisrainbow = false
speed = 0.75

_menuPool = NativeUI.CreatePool()

-- generate "slap" table once
local SlapAmount = {}
for i=1,20 do
	table.insert(SlapAmount,i)
end

function handleOrientation(orientation)
	if orientation == "right" then
		return 1320
	elseif orientation == "middle" then
		return 730
	elseif orientation == "left" then
		return 0
	end
end

playlist = nil

Citizen.CreateThread(function()
	TriggerServerEvent("EasyAdmin:amiadmin")
	TriggerServerEvent("EasyAdmin:requestBanlist")
	TriggerServerEvent("EasyAdmin:requestCachedPlayers")
	if not GetResourceKvpString("ea_menuorientation") then
		SetResourceKvp("ea_menuorientation", "right")
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
		menuOrientation = handleOrientation("right")
	else
		menuWidth = GetResourceKvpInt("ea_menuwidth")
		menuOrientation = handleOrientation(GetResourceKvpString("ea_menuorientation"))
	end 
	mainMenu = NativeUI.CreateMenu("AuraRP", "~o~Admin Menu", menuOrientation, 0)
	_menuPool:Add(mainMenu)
	
		mainMenu:SetMenuWidthOffset(menuWidth)	
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
		
	while true do
		if _menuPool then
			_menuPool:ProcessMenus()
		end
		if (IsControlJustReleased(0, settings.button) and GetLastInputMethod( 0 ) ) and isAdmin == true then --M by default
			-- clear and re-create incase of permission change+player count change
			playerlist = nil
			TriggerServerEvent("EasyAdmin:GetInfinityPlayerList") -- shitty fix for bigmode
			repeat
				Wait(100)
			until playerlist

			if strings then
				banLength = {
					{label = GetLocalisedText("permanent"), time = 10444633200},
					{label = GetLocalisedText("oneday"), time = 86400},
					{label = GetLocalisedText("threedays"), time = 259200},
					{label = GetLocalisedText("oneweek"), time = 518400},
					{label = GetLocalisedText("twoweeks"), time = 1123200},
					{label = GetLocalisedText("onemonth"), time = 2678400},
					{label = GetLocalisedText("oneyear"), time = 31536000},
				}
				if mainMenu:Visible() then
					mainMenu:Visible(false)
					_menuPool:Remove()
					collectgarbage()
				else
					GenerateMenu()
					mainMenu:Visible(true)
				end
			else
				TriggerServerEvent("EasyAdmin:amiadmin")
			end
		end
		
		Citizen.Wait(1)
	end
end)

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end

local banlistPage = 1
function GenerateMenu() -- this is a big ass function
	TriggerServerEvent("EasyAdmin:requestCachedPlayers")
	_menuPool:Remove()
	_menuPool = NativeUI.CreatePool()
	collectgarbage()
	if not GetResourceKvpString("ea_menuorientation") then
		SetResourceKvp("ea_menuorientation", "right")
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
		menuOrientation = handleOrientation("right")
	else
		menuWidth = GetResourceKvpInt("ea_menuwidth")
		menuOrientation = handleOrientation(GetResourceKvpString("ea_menuorientation"))
	end 
	
	mainMenu = NativeUI.CreateMenu("AuraRP", "~o~Admin Menu", menuOrientation, 0)
	_menuPool:Add(mainMenu)
	
		mainMenu:SetMenuWidthOffset(menuWidth)	
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
	playermanagement = _menuPool:AddSubMenu(mainMenu, GetLocalisedText("playermanagement"),"",true)
	servermanagement = _menuPool:AddSubMenu(mainMenu, GetLocalisedText("servermanagement"),"",true)
	AdminMenu = _menuPool:AddSubMenu(mainMenu, '~o~Admin Menu',"",true)
	settingsMenu = _menuPool:AddSubMenu(mainMenu, GetLocalisedText("settings"),"",true)

	mainMenu:SetMenuWidthOffset(menuWidth)	
	playermanagement:SetMenuWidthOffset(menuWidth)	
	servermanagement:SetMenuWidthOffset(menuWidth)	
	settingsMenu:SetMenuWidthOffset(menuWidth)	

	-- util stuff
	players = {}
	local localplayers = playerlist
	local temp = {}
	--table.sort(localplayers)
	for i,thePlayer in pairs(localplayers) do
		table.insert(temp, thePlayer.id)
	end
	table.sort(temp)
	for i, thePlayerId in pairs(temp) do
		for _, thePlayer in pairs(localplayers) do
			if thePlayerId == thePlayer.id then
				players[i] = thePlayer
			end
		end
	end
	temp=nil
		

	for i,thePlayer in pairs(players) do

		thisPlayer = _menuPool:AddSubMenu(playermanagement,"["..thePlayer.id.."] "..thePlayer.name,"",true)
		thisPlayer:SetMenuWidthOffset(menuWidth)
		-- generate specific menu stuff, dirty but it works for now
		if permissions.kick then
			local thisKickMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("kickplayer"),"",true)
			thisKickMenu:SetMenuWidthOffset(menuWidth)
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("kickreasonguide"))
			thisKickMenu:AddItem(thisItem)
			KickReason = GetLocalisedText("noreason")
			thisItem:RightLabel(KickReason)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
				
				local result = GetOnscreenKeyboardResult()
				
				if result and result ~= "" then
					KickReason = result
					thisItem:RightLabel(result) -- this is broken for now
				else
					KickReason = GetLocalisedText("noreason")
				end
			end
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmkick"),GetLocalisedText("confirmkickguide"))
			thisKickMenu:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if KickReason == "" then
					KickReason = GetLocalisedText("noreason")
				end
				TriggerServerEvent("EasyAdmin:kickPlayer", thePlayer.id, KickReason)
				BanTime = 1
				BanReason = ""
				_menuPool:CloseAllMenus()
				Citizen.Wait(800)
				GenerateMenu()
				playermanagement:Visible(true)
			end	
		end
		
		if permissions.ban then
			local thisBanMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("banplayer"),"",true)
			thisBanMenu:SetMenuWidthOffset(menuWidth)
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("banreasonguide"))
			thisBanMenu:AddItem(thisItem)
			BanReason = GetLocalisedText("noreason")
			thisItem:RightLabel(BanReason)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
				
				local result = GetOnscreenKeyboardResult()
				
				if result and result ~= "" then
					BanReason = result
					thisItem:RightLabel(result) -- this is broken for now
				else
					BanReason = GetLocalisedText("noreason")
				end
			end
			local bt = {}
			for i,a in ipairs(banLength) do
				table.insert(bt, a.label)
			end
			
			local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlength"),bt, 1,GetLocalisedText("banlengthguide") )
			thisBanMenu:AddItem(thisItem)
			local BanTime = 1
			thisItem.OnListChanged = function(sender,item,index)
				BanTime = index
			end
		
			local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmban"),GetLocalisedText("confirmbanguide"))
			thisBanMenu:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if BanReason == "" then
					BanReason = GetLocalisedText("noreason")
				end
				TriggerServerEvent("EasyAdmin:banPlayer", thePlayer.id, BanReason, banLength[BanTime].time, thePlayer.name )
				BanTime = 1
				BanReason = ""
				_menuPool:CloseAllMenus()
				Citizen.Wait(800)
				GenerateMenu()
				playermanagement:Visible(true)
			end	
			
		end
		
		if permissions.mute then			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("mute"),GetLocalisedText("muteguide"))
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:mutePlayer", thePlayer.id)
			end
		end

		if permissions.spectate then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("spectateplayer"), "")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:requestSpectate",thePlayer.id)
			end
		end
		
		if permissions.teleport then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("teleporttoplayer"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(thePlayer.id)),true))
				local heading = GetEntityHeading(GetPlayerPed(player))
				SetEntityCoords(PlayerPedId(), x,y,z,0,0,heading, false)
			end
		end
		
		if permissions.teleport then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("teleportplayertome"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(),true))
				TriggerServerEvent("EasyAdmin:TeleportPlayerToCoords", thePlayer.id, px,py,pz)
			end
		end
		
		if permissions.slap then
			local thisItem = NativeUI.CreateSliderItem(GetLocalisedText("slapplayer"), SlapAmount, 20, false, false)
			thisPlayer:AddItem(thisItem)
			thisItem.OnSliderSelected = function(index)
				TriggerServerEvent("EasyAdmin:SlapPlayer", thePlayer.id, index*10)
			end
		end

		if permissions.freeze then
			local sl = {GetLocalisedText("on"), GetLocalisedText("off")}
			local thisItem = NativeUI.CreateListItem(GetLocalisedText("setplayerfrozen"), sl, 1)
			thisPlayer:AddItem(thisItem)
			thisPlayer.OnListSelect = function(sender, item, index)
					if item == thisItem then
							i = item:IndexToItem(index)
							if i == GetLocalisedText("on") then
								TriggerServerEvent("EasyAdmin:FreezePlayer", thePlayer.id, true)
							else
								TriggerServerEvent("EasyAdmin:FreezePlayer", thePlayer.id, false)
							end
					end
			end
		end
	
		if permissions.spectate then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("takescreenshot"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:TakeScreenshot", thePlayer.id)
			end
		end

		if permissions.spectate then
			local thisItem = NativeUI.CreateItem("Ulecz", "")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:requestrevive",thePlayer.id)
			end
		end
		
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)
	end
	
	--[[
	thisPlayer = _menuPool:AddSubMenu(playermanagement,GetLocalisedText("allplayers"),"",true)
	thisPlayer:SetMenuWidthOffset(menuWidth)
	if permissions.teleport then
		-- "all players" function
		local thisItem = NativeUI.CreateItem(GetLocalisedText("teleporttome"), GetLocalisedText("teleporttomeguide"))
		thisPlayer:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId(),true))
			TriggerServerEvent("EasyAdmin:TeleportPlayerToCoords", -1, px,py,pz)
		end
	end
	]]--

	CachedList = _menuPool:AddSubMenu(playermanagement,GetLocalisedText("cachedplayers"),"",true)
	CachedList:SetMenuWidthOffset(menuWidth)
	if permissions.ban then
		for i, cachedplayer in pairs(cachedplayers) do
			if cachedplayer.droppedTime and not cachedplayer.immune then
				thisPlayer = _menuPool:AddSubMenu(CachedList,"["..cachedplayer.id.."] "..cachedplayer.name,"",true)
				thisPlayer:SetMenuWidthOffset(menuWidth)
				local thisBanMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("banplayer"),"",true)
				thisBanMenu:SetMenuWidthOffset(menuWidth)
				
				local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("banreasonguide"))
				thisBanMenu:AddItem(thisItem)
				BanReason = GetLocalisedText("noreason")
				thisItem:RightLabel(BanReason)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
					
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
					
					local result = GetOnscreenKeyboardResult()
					
					if result and result ~= "" then
						BanReason = result
						thisItem:RightLabel(result) -- this is broken for now
					else
						BanReason = GetLocalisedText("noreason")
					end
				end
				local bt = {}
				for i,a in ipairs(banLength) do
					table.insert(bt, a.label)
				end
				
				local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlength"),bt, 1,GetLocalisedText("banlengthguide") )
				thisBanMenu:AddItem(thisItem)
				local BanTime = 1
				thisItem.OnListChanged = function(sender,item,index)
					BanTime = index
				end
			
				local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmban"),GetLocalisedText("confirmbanguide"))
				thisBanMenu:AddItem(thisItem)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					if BanReason == "" then
						BanReason = GetLocalisedText("noreason")
					end
					TriggerServerEvent("EasyAdmin:offlinebanPlayer", cachedplayer.id, BanReason, banLength[BanTime].time, cachedplayer.name)
					BanTime = 1
					BanReason = ""
					_menuPool:CloseAllMenus()
					Citizen.Wait(800)
					GenerateMenu()
					playermanagement:Visible(true)
				end	
			end
		end
	end

	if permissions.manageserver then
		local thisItem = NativeUI.CreateItem(GetLocalisedText("setgametype"), GetLocalisedText("setgametypeguide"))
		servermanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 32 + 1)
			
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
			
			local result = GetOnscreenKeyboardResult()
			
			if result then
				TriggerServerEvent("EasyAdmin:SetGameType", result)
			end
		end
		
		local thisItem = NativeUI.CreateItem(GetLocalisedText("setmapname"), GetLocalisedText("setmapnameguide"))
		servermanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 32 + 1)
			
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
			
			local result = GetOnscreenKeyboardResult()
			
			if result then
				TriggerServerEvent("EasyAdmin:SetMapName", result)
			end
		end
		
		local thisItem = NativeUI.CreateItem(GetLocalisedText("startresourcebyname"), GetLocalisedText("startresourcebynameguide"))
		servermanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 32 + 1)
			
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
			
			local result = GetOnscreenKeyboardResult()
			
			if result then
				TriggerServerEvent("EasyAdmin:StartResource", result)
			end
		end
		
		local thisItem = NativeUI.CreateItem(GetLocalisedText("stopresourcebyname"), GetLocalisedText("stopresourcebynameguide"))
		servermanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 32 + 1)
			
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
			
			local result = GetOnscreenKeyboardResult()
			
			if result then
				if result ~= GetCurrentResourceName() and result ~= "NativeUI" then
					TriggerServerEvent("EasyAdmin:StopResource", result)
				else
					TriggerEvent("chat:addMessage", { args = { "EasyAdmin", GetLocalisedText("badidea") } })
				end
			end
		end
		
	end
	
	if permissions.unban then
		unbanPlayer = _menuPool:AddSubMenu(servermanagement,GetLocalisedText("unbanplayer"),"",true)
		unbanPlayer:SetMenuWidthOffset(menuWidth)
		local reason = ""
		local identifier = ""

		for i,theBanned in ipairs(banlist) do
			if i<(banlistPage*10)+1 and i>(banlistPage*10)-10 then
				if theBanned then
					reason = theBanned.reason or "No Reason"
					local thisItem = NativeUI.CreateItem(reason, GetLocalisedText("unbanplayerguide"))
					unbanPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						TriggerServerEvent("EasyAdmin:unbanPlayer", theBanned.banid)
						TriggerServerEvent("EasyAdmin:requestBanlist")
						_menuPool:CloseAllMenus()
						Citizen.Wait(800)
						GenerateMenu()
						unbanPlayer:Visible(true)
					end	
				end
			end
		end


		if #banlist > (banlistPage*10) then 
			local thisItem = NativeUI.CreateItem(GetLocalisedText("lastpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage = math.ceil(#banlist/10)
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end

		if banlistPage>1 then 
			local thisItem = NativeUI.CreateItem(GetLocalisedText("firstpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage = 1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
			local thisItem = NativeUI.CreateItem(GetLocalisedText("previouspage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage=banlistPage-1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end
		if #banlist > (banlistPage*10) then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("nextpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage=banlistPage+1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end 


	end
	


	if permissions.unban then
		local sl = {GetLocalisedText("unbanreasons"), GetLocalisedText("unbanlicenses")}
		local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlistshowtype"), sl, 1,GetLocalisedText("banlistshowtypeguide"))
		settingsMenu:AddItem(thisItem)
		settingsMenu.OnListChange = function(sender, item, index)
				if item == thisItem then
						i = item:IndexToItem(index)
						if i == GetLocalisedText(unbanreasons) then
							showLicenses = false
						else
							showLicenses = true
						end
				end
		end
	end
	
	
	if permissions.unban then
		local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshbanlist"), GetLocalisedText("refreshbanlistguide"))
		settingsMenu:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:updateBanlist")
		end
	end

	if permissions.ban then
		local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshcachedplayers"), GetLocalisedText("refreshcachedplayersguide"))
		settingsMenu:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:requestCachedPlayers")
		end
	end
	
	local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshpermissions"), GetLocalisedText("refreshpermissionsguide"))
	settingsMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		TriggerServerEvent("amiadmin")
	end
	
	local sl = {GetLocalisedText("left"), GetLocalisedText("middle"), GetLocalisedText("right")}
	local thisItem = NativeUI.CreateListItem(GetLocalisedText("menuOrientation"), sl, 1, GetLocalisedText("menuOrientationguide"))
	settingsMenu:AddItem(thisItem)
	settingsMenu.OnListChange = function(sender, item, index)
			if item == thisItem then
					i = item:IndexToItem(index)
					if i == GetLocalisedText("left") then
						SetResourceKvp("ea_menuorientation", "left")
					elseif i == GetLocalisedText("middle") then
						SetResourceKvp("ea_menuorientation", "middle")
					else
						SetResourceKvp("ea_menuorientation", "right")
					end
			end
	end
	local sl = {}
	for i=0,150,10 do
		table.insert(sl,i)
	end
	local thisi = 0
	for i,a in ipairs(sl) do
		if menuWidth == a then
			thisi = i
		end
	end
	local thisItem = NativeUI.CreateSliderItem(GetLocalisedText("menuOffset"), sl, thisi, GetLocalisedText("menuOffsetguide"), false)
	settingsMenu:AddItem(thisItem)
	thisItem.OnSliderSelected = function(index)
		i = thisItem:IndexToItem(index)
		SetResourceKvpInt("ea_menuwidth", i)
		menuWidth = i
	end
	thisi = nil
	sl = nil


	local thisItem = NativeUI.CreateItem(GetLocalisedText("resetmenuOffset"), "")
	settingsMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
	end
	
	if permissions.anon then
		local thisItem = NativeUI.CreateCheckboxItem(GetLocalisedText("anonymous"), anonymous or false, GetLocalisedText("anonymousguide"))
		settingsMenu:AddItem(thisItem)
		settingsMenu.OnCheckboxChange = function(sender, item, checked_)
			if item == thisItem then
				anonymous = checked_
				TriggerServerEvent("EasyAdmin:SetAnonymous", checked_)
			end
		end
	end

	if permissions.anon then
		local thisItem = NativeUI.CreateCheckboxItem("Niewidzialnosc", not IsEntityVisible(GetPlayerPed(-1)), "")
		AdminMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				local pid = PlayerPedId()
				SetEntityVisible(pid, not IsEntityVisible(pid))
				if not IsEntityVisible(GetPlayerPed(-1)) then
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'invisible')
				else
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'invisibleoff')
				end
			end
		end
	end

	if permissions.anon then

		AdminMenu:AddInstructionButton({GetControlInstructionalButton(0, 21, 0), "Zmień prędkość"})
		AdminMenu:AddInstructionButton({GetControlInstructionalButton(0, 31, 0), "Do przodu/tyłu"})
		AdminMenu:AddInstructionButton({GetControlInstructionalButton(0, 30, 0), "W lewo/prawo"})
		AdminMenu:AddInstructionButton({GetControlInstructionalButton(0, 44, 0), "Do góry"})
		AdminMenu:AddInstructionButton({GetControlInstructionalButton(0, 356, 0), "W dół"})

		local thisItem = NativeUI.CreateCheckboxItem("Noclip", noClip, "")
		AdminMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				noClip = not noClip
				if not noClip then
					noClipLabel = nil
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'noclipoff')
				else
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'noclipon')
				end
			end
		end

		noClipLabel = NativeUI.CreateItem(strings.noclipspeed, "")
		noClipLabel:RightLabel(noClipSpeeds[noClipSpeed + 1])

		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)
	end

	if permissions.anon then
		local thisItem = NativeUI.CreateCheckboxItem("Blipy Graczy", playerblips, "")
		AdminMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				playerblips = not playerblips
				if playerblips then
				TriggerServerEvent('EasyAdmin:AdminMonitor', 'playerblipson')
		        local plist = GetActivePlayers()
		            for i = 1, #plist do
		                local id = plist[i]
		                local ped = GetPlayerPed(id)
		                if ped ~= PlayerPedId() then
		                    local blip = GetBlipFromEntity(ped)

		                    if not DoesBlipExist(blip) then -- Add blip and create head display on player
		                        blip = AddBlipForEntity(ped)
		                        SetBlipSprite(blip, 1)
		                        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
		                    else -- update blip
		                        local veh = GetVehiclePedIsIn(ped, false)
		                        local blipSprite = GetBlipSprite(blip)

		                        if GetEntityHealth(ped) == 0 then -- dead
		                            if blipSprite ~= 274 then
		                                SetBlipSprite(blip, 274)
		                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator
		                            end
		                        elseif veh then
		                            local vehClass = GetVehicleClass(veh)
		                            local vehModel = GetEntityModel(veh)
		                            if vehClass == 15 then -- Helicopters
		                                if blipSprite ~= 422 then
		                                    SetBlipSprite(blip, 422)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehClass == 8 then -- Motorcycles
		                                if blipSprite ~= 226 then
		                                    SetBlipSprite(blip, 226)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehClass == 16 then -- Plane
		                                if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer") then -- Jets
		                                    if blipSprite ~= 424 then
		                                        SetBlipSprite(blip, 424)
		                                        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                    end
		                                elseif blipSprite ~= 423 then
		                                    SetBlipSprite(blip, 423)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehClass == 14 then -- Boat
		                                if blipSprite ~= 427 then
		                                    SetBlipSprite(blip, 427)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("insurgent3") then -- Insurgent, Insurgent Pickup & Insurgent Pickup Custom
		                                if blipSprite ~= 426 then
		                                    SetBlipSprite(blip, 426)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("limo2") then -- Turreted Limo
		                                if blipSprite ~= 460 then
		                                    SetBlipSprite(blip, 460)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("rhino") then -- Tank
		                                if blipSprite ~= 421 then
		                                    SetBlipSprite(blip, 421)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("trash") or vehModel == GetHashKey("trash2") then -- Trash
		                                if blipSprite ~= 318 then
		                                    SetBlipSprite(blip, 318)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("pbus") then -- Prison Bus
		                                if blipSprite ~= 513 then
		                                    SetBlipSprite(blip, 513)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("seashark") or vehModel == GetHashKey("seashark2") or vehModel == GetHashKey("seashark3") then -- Speedophiles
		                                if blipSprite ~= 471 then
		                                    SetBlipSprite(blip, 471)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("cargobob") or vehModel == GetHashKey("cargobob2") or vehModel == GetHashKey("cargobob3") or vehModel == GetHashKey("cargobob4") then -- Cargobobs
		                                if blipSprite ~= 481 then
		                                    SetBlipSprite(blip, 481)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("technical") or vehModel == GetHashKey("technical2") or vehModel == GetHashKey("technical3") then -- Technical
		                                if blipSprite ~= 426 then
		                                    SetBlipSprite(blip, 426)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("taxi") then -- Cab/ Taxi
		                                if blipSprite ~= 198 then
		                                    SetBlipSprite(blip, 198)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif vehModel == GetHashKey("fbi") or vehModel == GetHashKey("fbi2") or vehModel == GetHashKey("police2") or vehModel == GetHashKey("police3") -- Police Vehicles
		                                or vehModel == GetHashKey("police") or vehModel == GetHashKey("sheriff2") or vehModel == GetHashKey("sheriff")
		                                or vehModel == GetHashKey("policeold2") then
		                                if blipSprite ~= 56 then
		                                    SetBlipSprite(blip, 56)
		                                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                                end
		                            elseif blipSprite ~= 1 then -- default blip
		                                SetBlipSprite(blip, 1)
		                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
		                            end

		                            -- Show number in case of passangers
		                            local passengers = GetVehicleNumberOfPassengers(veh)

		                            if passengers > 0 then
		                                if not IsVehicleSeatFree(veh, -1) then
		                                    passengers = passengers + 1
		                                end
		                                ShowNumberOnBlip(blip, passengers)
		                            else
		                                HideNumberOnBlip(blip)
		                            end
		                        else
		                            -- Remove leftover number
		                            HideNumberOnBlip(blip)

		                            if blipSprite ~= 1 then -- default blip
		                                SetBlipSprite(blip, 1)
		                                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true) -- Player Blip indicator

		                            end
		                        end

		                        SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) -- update rotation
		                        SetBlipNameToPlayerName(blip, id) -- update blip name
		                        SetBlipScale(blip,  0.85) -- set scale

		                        -- set player alpha
		                        if IsPauseMenuActive() then
		                            SetBlipAlpha( blip, 255 )
		                        else
		                            x1, y1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
		                            x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
		                            distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
		                            -- Probably a way easier way to do this but whatever im an idiot

		                            if distance < 0 then
		                                distance = 0
		                            elseif distance > 255 then
		                                distance = 255
		                            end
		                            SetBlipAlpha(blip, distance)
		                        end
		                    end
		                end
		            end
				else
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'playerblipsoff')
		            local plist = GetActivePlayers()
		            for i = 1, #plist do
		                local id = plist[i]
		                local ped = GetPlayerPed(id)
		                local blip = GetBlipFromEntity(ped)
		                if DoesBlipExist(blip) then -- Removes blip
		                    RemoveBlip(blip)
		                end
		            end
				end
			end
		end
	end

	if permissions.anon then
		local thisItem = NativeUI.CreateCheckboxItem("GODMODE", godmode, "")
		AdminMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				godmode = not godmode
				if godmode then
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'godmodeon')
					SetPlayerInvincible(PlayerId(), true)
       				SetEntityInvincible(PlayerPedId(), true)
				else
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'godmodeoff')
					SetPlayerInvincible(PlayerId(), false)
       				SetEntityInvincible(PlayerPedId(), false)
				end
			end
		end
	end

	if permissions.anon then
		local thisItem = NativeUI.CreateCheckboxItem("RAINBOW CAR", rainbowcar, "")
		AdminMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				rainbowcar = not rainbowcar
				if rainbowcar then
					carisrainbow = true
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'rainbowcaron')
				else
					carisrainbow = false
					TriggerServerEvent('EasyAdmin:AdminMonitor', 'rainbowcaroff')
				end
			end
		end
	end

	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
	_menuPool:RefreshIndex() -- refresh indexes
end

Citizen.CreateThread(function()
	local function RGBRainbow( frequency )
		local result = {}
		local curtime = GetGameTimer() / 1000

		result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
		result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
		result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
		return result
	end
    while true do
    	local rainbow = RGBRainbow( speed )
    	Citizen.Wait(0)
    	if carisrainbow then
    		if IsPedInAnyVehicle(PlayerPedId(), true) then
    			veh = GetVehiclePedIsUsing(PlayerPedId())
    			SetVehicleCustomPrimaryColour(veh, rainbow.r, rainbow.g, rainbow.b)
    			SetVehicleCustomSecondaryColour(veh, rainbow.r, rainbow.g, rainbow.b)
    		else
    			carisrainbow = false
    			rainbowcar = false
    		end
    	end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if noClip then
			local noclipEntity = (IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsUsing(PlayerPedId()) or PlayerPedId())
			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)

			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 20, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)

			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed == 12 then
					noClipSpeed = 0
				end

				if noClipLabel then
					noClipLabel:RightLabel(noClipSpeeds[noClipSpeed + 1])
				end
			end

			if IsDisabledControlPressed(0, 32) then
				yoff = 0.5;
			end

			if IsDisabledControlPressed(0, 33) then
				yoff = -0.5;
			end

			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 3.0)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 3.0)
			end

			if IsDisabledControlPressed(0, 44) then
				zoff = 0.21;
			end

			if IsDisabledControlPressed(0, 356) then
				zoff = -0.21;
			end

			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)

			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)

			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(100)
		end
	end
end)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			-- cheat checks
			local targetPed = GetPlayerPed(drawTarget)
			local targetGod = GetPlayerInvincible(drawTarget)
			if targetGod then
				table.insert(text,GetLocalisedText("godmodedetected"))
			else
				table.insert(text,GetLocalisedText("godmodenotdetected"))
			end
			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text,GetLocalisedText("antiragdoll"))
			end
			-- health info
			table.insert(text,GetLocalisedText("health")..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,GetLocalisedText("armor")..": "..GetPedArmour(targetPed))
			-- misc info
			table.insert(text,GetLocalisedText("wantedlevel")..": "..GetPlayerWantedLevel(drawTarget))
			table.insert(text,GetLocalisedText("exitspectator"))
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if IsControlJustPressed(0,103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
	
				StopDrawPlayerInfo()
				ShowNotification(GetLocalisedText("stoppedSpectating"))
			end
			
		end
	end
end)
