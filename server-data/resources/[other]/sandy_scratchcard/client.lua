local GUI = {}
ESX = nil
GUI.Time = 0
Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end) 

RegisterNetEvent('sandy_scratchcard:anim')
AddEventHandler('sandy_scratchcard:anim', function()
 	local ad = "amb@code_human_wander_texting@male@base"
	local anim = "base"
	local player = PlayerPedId()


	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then 
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 0.2, 48, 0, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			SetCurrentPedWeapon( player, GetHashKey("WEAPON_UNARMED"), equipNow)
			Citizen.Wait(50) 
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 0.2, 48, 0, 0, 0, 0 )
		end       
	end
end)

RegisterNetEvent('sandy_scratchcard:Sound')
AddEventHandler('sandy_scratchcard:Sound', function(sound1, sound2)
  PlaySoundFrontend(-1, sound1, sound2)
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent('esx_cigarette:startSmoke')
AddEventHandler('esx_cigarette:startSmoke', function(source)
	SmokeAnimation()
end)

RegisterNetEvent('robienie')
AddEventHandler('robienie', function(status)
	if status == true then
		TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, false)
		exports["taskbar"]:taskBar(10000,"Kręcenie jointa")
	else
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end
end)

function SmokeAnimation()
	local playerPed = GetPlayerPed(-1)
	
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)               
	end)
end

RegisterNetEvent('esx_drugeffects:onMarijuana')
AddEventHandler('esx_drugeffects:onMarijuana', function()
  local playerPed = GetPlayerPed(-1)

    RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@hipster@a", true)

    --Efects
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.3)

    Wait(180000)

    SetRunSprintMultiplierForPlayer(player, 1.0)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    --ResetPedMovementClipset(playerPed, 0) <- it might cause the push of the vehicles
    SetPedMotionBlur(playerPed, false)		
end)

--Opium
RegisterNetEvent('esx_drugeffects:onOpium')
AddEventHandler('esx_drugeffects:onOpium', function()
  local playerPed = GetPlayerPed(-1)
  
        RequestAnimSet("move_m@drunk@moderatedrunk") 
    while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

    --Efects
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.2)
    SetSwimMultiplierForPlayer(player, 1.3)

    Wait(180000)

    SetRunSprintMultiplierForPlayer(player, 1.0)
    SetSwimMultiplierForPlayer(player, 1.0)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    --ResetPedMovementClipset(playerPed, 0) <- it might cause the push of the vehicles
    SetPedMotionBlur(playerPed, false)
 end)

--Meth
RegisterNetEvent('esx_drugeffects:onMeth')
AddEventHandler('esx_drugeffects:onMeth', function()
  local playerPed = GetPlayerPed(-1)
  local maxHealth = GetEntityMaxHealth(playerPed)

        RequestAnimSet("move_injured_generic") 
    while not HasAnimSetLoaded("move_injured_generic") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_injured_generic", true)

   --Efects
    local player = PlayerId()  
    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth , math.floor(health + maxHealth/8))
    SetEntityHealth(playerPed, newHealth)

    Wait(180000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    --ResetPedMovementClipset(playerPed, 0) <- it might cause the push of the vehicles
    SetPedMotionBlur(playerPed, false)
end)

--Coke
RegisterNetEvent('esx_drugeffect:runMan')
AddEventHandler('esx_drugeffect:runMan', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
	count = 0
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetTimecycleModifier("spectator5")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    DoScreenFadeIn(1000)
	repeat
		ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
		Citizen.Wait(10000)
		count = count  + 1
	until count == 6
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    --ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetPedMotionBlur(GetPlayerPed(-1), false)
end)

--Crack
RegisterNetEvent('esx_drugeffects:onCrack')
AddEventHandler('esx_drugeffects:onCrack', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
  count = 0
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetTimecycleModifier("spectator5")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    DoScreenFadeIn(1000)
  repeat
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    Citizen.Wait(10000)
    count = count  + 1
  until count == 3
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    --ResetPedMovementClipset(GetPlayerPed(-1), 0)
  SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetPedMotionBlur(GetPlayerPed(-1), false)
 end)

RegisterNetEvent('sandy_scratchcard:lemonhazeblunt')
AddEventHandler('sandy_scratchcard:lemonhazeblunt', function()
	local playerPed = GetPlayerPed(-1)

    RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
	DoScreenFadeOut(600)
	Citizen.Wait(2000)
    ClearPedTasksImmediately(playerPed)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@hipster@a", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)

    local player = PlayerId()
    --SetRunSprintMultiplierForPlayer(player, 0.5)
	
	DoScreenFadeIn(600)
	DoAcid(189000)

    Wait(1000)
	
    ResetScenarioTypesEnabled()
    -- ResetPedMovementClipset(playerPed, 0) -- <- it might cause the push of the vehicles
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(playerPed, false)

    --SetRunSprintMultiplierForPlayer(player, 1.0)
	
	DoEffects = false
end)

local Mario = {
  cols = {
    [16] =  {r=55,  g=55,   b=55},
    [18] =  {r=55,  g=55,   b=135},
    [24] =  {r=55,  g=95,   b=135},
    [52] =  {r=95,  g=55,   b=55},
    [67] =  {r=95,  g=135,  b=175},
    [88] =  {r=135, g=55,   b=55},
    [95] =  {r=135, g=95,   b=95},
    [124] = {r=175, g=55,   b=55},
    [133] = {r=175, g=95,   b=175},
    [173] = {r=215, g=135,  b=95},
    [203] = {r=255, g=95,   b=95},
    [210] = {r=255, g=135,  b=135},
    [216] = {r=255, g=175,  b=135},
    [222] = {r=255, g=215,  b=135},
    [231] = {r=255, g=255,  b=255},
  },
  bits = {
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,95,95,24,18,88,88,88,18,18,88,88,88,133,133,
      133,95,231,24,18,124,124,124,18,24,203,203,203,124,88,133,
      95,231,222,18,124,203,203,18,24,124,95,95,95,203,124,88,
      95,222,222,18,124,124,124,18,24,95,231,231,231,95,124,88,
      133,95,18,24,18,18,18,24,95,231,231,231,231,222,95,88,
      133,133,18,222,67,67,222,222,95,231,231,231,222,222,95,133,
      133,52,52,222,67,67,222,222,67,95,222,222,222,95,133,133,
      52,173,173,52,24,67,67,67,67,24,95,95,95,52,133,133,
      52,95,95,173,52,67,24,24,67,67,24,24,18,95,52,133,
      52,52,95,95,52,24,24,18,24,67,67,67,18,95,52,52,
      52,52,95,95,52,24,18,18,18,24,24,67,18,95,95,52,
      133,52,52,95,52,18,133,133,133,18,18,24,18,173,95,52,
      133,52,52,52,133,133,133,133,133,133,133,18,18,173,95,52,
      133,133,133,133,133,133,133,133,133,133,133,133,133,52,52,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,203,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,216,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,216,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,88,88,18,18,88,88,88,133,133,133,
      133,133,95,18,124,124,124,18,95,95,95,203,203,88,133,133,
      133,95,231,18,124,203,203,95,231,231,231,95,203,203,88,133,
      133,95,222,18,124,124,95,231,231,231,231,222,95,124,88,133,
      133,95,18,24,18,18,95,231,231,231,222,222,95,124,88,133,
      133,133,18,222,67,67,222,95,222,222,222,95,88,88,133,133,
      133,133,18,222,67,67,222,222,95,95,95,24,24,18,133,133,
      133,18,24,24,67,67,24,24,67,67,24,24,18,133,133,133,
      133,52,52,24,24,24,24,18,24,67,67,24,18,52,133,133,
      52,173,173,52,24,24,24,18,24,24,24,24,52,95,52,133,
      52,95,95,173,52,24,18,133,18,24,24,24,52,95,52,133,
      133,52,95,95,95,52,133,133,133,52,52,52,173,95,52,133,
      133,133,52,95,95,52,133,133,52,173,173,95,95,52,133,133,
      133,133,133,52,52,52,133,133,52,52,52,52,52,133,133,133
    },
    {
      133,133,133,133,88,88,88,88,88,88,133,133,133,133,133,133,
      133,133,133,88,124,222,222,124,124,124,88,133,133,133,133,133,
      133,133,133,88,124,231,231,203,203,203,124,88,133,133,133,133,
      133,133,88,88,88,88,88,88,88,124,203,124,88,88,133,133,
      133,88,124,203,203,203,203,124,124,88,203,203,124,124,88,133,
      133,88,88,88,88,88,88,88,88,88,124,203,203,124,88,133,
      133,133,133,95,231,231,210,231,231,210,88,88,88,88,88,133,
      133,133,133,95,231,67,216,67,231,210,210,52,52,95,133,133,
      133,133,133,95,231,16,216,16,231,216,210,52,52,210,95,133,
      133,133,95,216,216,216,216,216,216,216,52,52,52,210,95,133,
      133,133,16,210,216,216,210,210,16,216,216,52,210,95,133,133,
      133,16,16,16,210,210,16,16,16,16,216,210,210,52,52,133,
      133,133,133,16,16,16,16,16,216,216,210,210,52,52,133,133,
      133,133,133,133,95,210,210,210,210,210,210,95,133,133,133,133,
      133,133,133,133,18,88,95,95,95,88,88,88,88,133,133,133,
      133,133,133,18,88,95,231,231,231,95,203,203,124,88,133,133,
      133,133,133,18,95,231,231,231,231,222,95,203,203,88,133,133,
      133,133,18,88,95,231,231,231,222,222,95,203,124,88,133,133,
      133,133,18,18,18,95,222,222,222,95,124,124,124,88,133,133,
      133,133,18,222,67,222,95,95,95,88,88,88,88,18,133,133,
      133,133,18,222,67,222,222,67,24,24,24,24,24,18,133,133,
      133,133,133,18,67,67,67,67,67,24,24,24,18,133,133,133,
      133,133,133,18,24,18,67,67,67,24,24,24,18,133,133,133,
      133,133,133,133,18,24,18,67,24,24,24,18,133,133,133,133,
      133,133,133,133,18,18,18,18,18,18,18,18,133,133,133,133,
      133,133,133,133,52,95,52,173,173,95,95,52,133,133,133,133,
      133,133,133,52,95,52,173,173,95,95,95,52,133,133,133,133,
      133,133,133,52,52,52,52,52,52,52,52,52,133,133,133,133
    },
  },
}

local Cubes = {}

local LastPedInteraction = 0
local LastPedTurn
local MarioInit
local PedSpawned

local MarioState = 1
local MarioTimer = 0
local MarioLength = 15
local MarioAlpha = 0
local MarioAdder = 1
local MarioZOff = -20.0
local MarioZAdd = 0.01

DoAcid = function(time)
  
  InitCubes()
  
  DoEffects = true
  
  local step = 0
  local timer = GetGameTimer() 
  local ped = GetPlayerPed(-1)
  local lastPos = GetEntityCoords(ped)

  while GetGameTimer() - timer < time do
    local plyPos = GetEntityCoords(GetPlayerPed(-1))
    local dist = GetVecDist(lastPos,plyPos)
    if dist > 1.0 then
      step = step + 1
      if step == 5 then
        step = 0
        local dir = (lastPos - plyPos)
        local vel = GetEntityVelocity(GetPlayerPed(-1))
      end
      lastPos = GetEntityCoords(GetPlayerPed(-1))
    end

    DrawToons()
    DrawCubes()

    if MarioInit and not PedSpawned then 
      PedSpawned = true
      Citizen.CreateThread(InitPed)
    end
    Wait(0)
  end

  ClearTimecycleModifier()
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)  
  SetPedMotionBlur(GetPlayerPed(-1), false)

  Cubes = {}

  LastPedInteraction = 0
  LastPedTurn = nil
  MarioInit = nil
  PedSpawned = nil

  MarioState = 1
  MarioTimer = 0
  MarioLength = 15
  MarioAlpha = 0
  MarioAdder = 1
  MarioZOff = -20.0
  MarioZAdd = 0.01
end

InitPed = function()
  local plyPed = GetPlayerPed(-1)
  local pos = GetEntityCoords(plyPed)

  local randomAlt     = math.random(0,359)
  local randomDist    = math.random(50,80)
  local spawnPos      = pos + PointOnSphere(0.0,randomAlt,randomDist)

  while World3dToScreen2d(spawnPos.x,spawnPos.y,spawnPos.z) and not IsPointOnRoad(spawnPos.x,spawnPos.y,spawnPos.z) do 
    randomAlt   = math.random(0,359)
    randomDist  = math.random(50,80)
    spawnPos    = GetEntityCoords(GetPlayerPed(-1)) + PointOnSphere(0.0,randomAlt,randomSphere)
    Citizen.Wait(0)
  end
end

InitCubes = function()
  for i=1,50,1 do
    local r = math.random(5,255)
    local g = math.random(5,255)
    local b = math.random(5,255)
    local a = math.random(50,100)

    local x = math.random(1,180)
    local y = math.random(1,359)
    local z = math.random(15,35)

    Cubes[i] = {pos=PointOnSphere(x,y,z),points={x=x,y=y,z=z},col={r=r, g=g, b=b, a=a}}
  end  

  ShakeGameplayCam('DRUNK_SHAKE', 0.0) 
  SetPedMotionBlur(GetPlayerPed(-1), true)

  local counter = 4000
  local tick = 0
  while tick < counter do
    tick = tick + 1
    local plyPos = GetEntityCoords(GetPlayerPed(-1))
    local adder = 0.1 * (tick/40)
    SetTimecycleModifierStrength(math.min(0.1 * (tick/(counter/40)),1.5))
    ShakeGameplayCam('DRUNK_SHAKE', math.min(0.1 * (tick/(counter/40)),1.5))  
    for k,v in pairs(Cubes) do
      local pos = plyPos + v.pos
      DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
      local points = {x=v.points.x+0.1,y=v.points.y+0.1,z=v.points.z}
      Cubes[k].points = points
      Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
    end
    Wait(0)
  end
end

DrawCubes = function()
  local position = GetEntityCoords(GetPlayerPed(-1))
  local adder = 10
  for k,v in pairs(Cubes) do
    local addX = 0.1
    local addY = 0.1

    if k%4 == 0 then
      addY = -0.1
    elseif k%3 == 0 then
      addX = -0.1
    elseif k%2 == 0 then
      addX = -0.1
      addY = -0.1
    end

    local pos = position + v.pos
    DrawBox(pos.x+adder,pos.y+adder,pos.z+adder,pos.x-adder,pos.y-adder,pos.z-adder, v.col.r,v.col.g,v.col.g,v.col.a)
    local points = {x=v.points.x+addX,y=v.points.y+addY,z=v.points.z}
    Cubes[k].points = points
    Cubes[k].pos = PointOnSphere(points.x,points.y,points.z)
  end
end

DrawToons = function()
  local plyPed = GetPlayerPed(-1)
  local plyPos = GetEntityCoords(plyPed)

  local infront = vector3(plyPos.x+35.0, plyPos.y-8.0,plyPos.z)
  local behind  = vector3(plyPos.x-35.0, plyPos.y-8.0,plyPos.z)

  if (GetGameTimer() - MarioTimer) > 1000 then
    MarioTimer = GetGameTimer()
    MarioState = MarioState + MarioAdder

    if MarioState > #Mario.bits then
      MarioAdder = -1
      MarioState = 2
    elseif MarioState <= 0 then
      MarioState = 2
      MarioAdder = 1
    end
  end

  DrawMario(infront)
  DrawMario(behind)
end

DrawMario = function(loc)
  local height = 0
  local width = 0

  if MarioZOff < 0.0 then MarioZOff = MarioZOff + MarioZAdd; end
  for k = #Mario.bits[MarioState],1,-1 do
    local v = Mario.bits[MarioState][k]
    local pos = vector3(loc.x,loc.y+width,loc.z+height)
    local col = Mario.cols[v]    

    if MarioAlpha < 255 then
      if not MarioInit then MarioInit = true; end
      MarioAlpha = MarioAlpha + 0.001
    end

    if v ~= 133 then
      DrawBox(pos.x+0.5,pos.y+0.5,pos.z+0.5 + MarioZOff, pos.x-0.5,pos.y-0.5,pos.z-0.5 + MarioZOff, col.r,col.g,col.b,math.floor(MarioAlpha))
    end

    width = width + 1
    if width > MarioLength then
      width = 0
      height = height + 1
    end
  end
end

GetVecDist = function(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

PointOnSphere = function(alt,azu,radius,orgX,orgY,orgZ)
  local toradians = 0.017453292384744
  alt,azu,radius,orgX,orgY,orgZ = ( tonumber(alt or 0) or 0 ) * toradians, ( tonumber(azu or 0) or 0 ) * toradians, tonumber(radius or 0) or 0, tonumber(orgX or 0) or 0, tonumber(orgY or 0) or 0, tonumber(orgZ or 0) or 0
  if      vector3
  then
      return
      vector3(
           orgX + radius * math.sin( azu ) * math.cos( alt ),
           orgY + radius * math.cos( azu ) * math.cos( alt ),
           orgZ + radius * math.sin( alt )
      )
  end
end

---- SAD
local kordysadu = {x = 351.66, y = 6519.69, z = 28.51}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, kordysadu.x, kordysadu.y, kordysadu.z, true) < 30 then
			if IsControlJustReleased(0, 38) and (GetGameTimer() - GUI.Time) > 2000 then
				gettingapples()
				GUI.Time = GetGameTimer()
			end
		end
	end
end)

function gettingapples()
		if IsPedInAnyVehicle(PlayerPedId()) then
			ESX.ShowHelpNotification("~r~Tej pracy nie możesz wykonywać bedąc w pojezdzie!")
			Citizen.Wait(2000)
		else
			local tree = checktree()
			if tree ~= 0 then
				animacjazbierania()
				FreezeEntityPosition(PlayerPedId(), true)
				procent(150)
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerServerEvent('orchard:job1a')
				Citizen.Wait(3000)
			else
				ESX.ShowHelpNotification('Musisz podejść bliżej drzewa aby coś z niego zebrać.')
				Citizen.Wait(2000)
			end
		end
end

function checktree()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.0, 0.0)
	local radius = 0.5
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, radius, 1, plyPed, 5)
	local _, _, _, _, tree = GetShapeTestResult(rayHandle)
	return tree
end

function animacjazbierania()
	local ad = "amb@prop_human_movie_bulb@base"
	local anim = "base"
	local player = PlayerPedId()


	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			SetCurrentPedWeapon( player, GetHashKey("WEAPON_UNARMED"), equipNow)
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
		end
	end
end

function procent(time)
  TriggerEvent('sadownik:procenty')
  TimeLeft = 0
  repeat
  TimeLeft = TimeLeft + 1
  Citizen.Wait(time)
  until(TimeLeft == 100)
  showPro = false
  cooldownclick = false
  ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('sadownik:procenty')
AddEventHandler('sadownik:procenty', function()
  showPro = true
    while (showPro) do
      Citizen.Wait(5)
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      DisableControlAction(0, 73, true) -- X
      DrawText3D(coords.x, coords.y, coords.z+0.1,'Pracuje...' , 0.4)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
end)

function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end