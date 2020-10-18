local Ped = {}

ESX = nil

local specpermissions = false

Deer = {}
Plane = {}
e = {}
Lynx8 = {}
LynxEvo = {}
MaestroMenu = {}
Motion = {}
TiagoMenu = {}
gaybuild = {}
Cience = {}
LynxSeven = {}
MMenu = {}
FantaMenuEvo = {}
GRubyMenu = {}
LR = {}
BrutanPremium = {}
HamMafia = {}
InSec = {}
AlphaVeta = {}
KoGuSzEk = {}
ShaniuMenu = {}
LynxRevo = {}
ariesMenu = {}
WarMenu = {}
dexMenu = {}
HamHaxia = {}
Ham = {}
Biznes = {}
FendinXMenu = {}
AlphaV = {}
NyPremium = {}

scroll = nil
zzzt = nil
werfvtghiouuiowrfetwerfio = nil
llll4874 = nil
KAKAAKAKAK = nil
udwdj = nil
Ggggg = nil
jd366213 = nil
KZjx = nil
ihrug = nil
WADUI = nil
Crusader = nil
FendinX = nil
oTable = nil
LeakerMenu = nil

Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("esx:playerconnected")
   	TriggerServerEvent('logs:checkpermissions')
end)

RegisterNetEvent('logi:getpermissions')
AddEventHandler('logi:getpermissions', function(permissions)
	specpermissions = permissions
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        Ped = exports['AuraRP']:GetPedData()
    end
end)

RegisterNetEvent('logi:checkdmgboost')
AddEventHandler('logi:checkdmgboost', function(dmgdone, weaponhash)
    local modifier = GetPlayerWeaponDamageModifier(PlayerId())
    local weaponmodifier = GetWeaponDamageModifier(weaponhash)
    if tonumber(modifier) > 1 then
    	TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, modifier)
    end
    if tonumber(weaponmodifier) > 1 then
         TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, weaponmodifier)
    end
    if tonumber(dmgdone) > 5000 then
        TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, modifier)
        TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, weaponmodifier)
    end
end)

local weaponblacklist = {
	"WEAPON_SNIPERRIFLE",
    "WEAPON_MINIGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_SMG",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMGMK2",
    "WEAPON_CARBINERIFLEMK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPERMK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_AUTOSHOTGUN",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_RPG",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_GRENADELAUNCHERSMOKE",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXIMITYMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_PIPEBOMB",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_RAYPISTOL",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_RAYCARBINE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE_MK2",
    "WEAPON_RAYMINIGUN",
    "WEAPON_PROXMINE"
}

local vehicleblacklist = {
	'RHINO',
	'AKULA',
	'SAVAGE',
	'HUNTER',
	'BUZZARD',
	'BUZZARD2',
	'ANNIHILATOR',
	'VALKYRIE',
	'HYDRA',
	'APC',
	'Trailersmall2',
	'Lazer',
	'oppressor',
	'mogul',
	'barrage',
	'Khanjali',
	'volatol',
	'chernobog',
	'avenger',
	'stromberg',
	'nightshark',
	'besra',
	'babushka ',
	'starling',
	'insurgent',
	'cargobob',
	'cargobob2',
	'cargobob3',
	'cargobob4',
	'caracara',
	'deluxo',
	'menacer',
    'scramjet',
    'oppressor2',
    'revolter',
    'viseris',
    'savestra',
    'thruster',
    'ardent',
    'dune3',
    'tampa3',
    'halftrack',
    'nokota',
    'strikeforce',
    'bombushka',
    'molotok',
    'pyro',
    'ruiner2',
    'limo2',
    'technical',
    'technical2',
    'technical3',
    'jb700w',
    'blazer5',
    'insurgent3',
	'boxville5',
	'bruiser',
    'bruiser2',
    'bruiser3',
    'brutus',
    'brutus2',
    'brutus3',
    'cerberus',
    'cerberus2',
    'cerberus3',
    'dominator4',
    'dominator5',
    'dominator6',
    'impaler2',
    'impaler3',
    'impaler4',
    'imperator',
    'imperator2',
    'imperator3',
    'issi4',
    'issi5',
    'issi6',
    'monster3',
    'monster4',
    'monster5',
    'scarab',
    'scarab2',
    'scarab3',
    'slamvan4',
    'slamvan5',
    'slamvan6',
    'zr380',
    'zr3802',
    'zr3803',
	'alphaz1',
	'avenger2',
	'blimp',
	'blimp2',
	'blimp3',
	'cargoplane',
	'cuban800',
	'dodo',
	'duster',
	'howard',
	'jet',
	'luxor',
	'luxor2',
	'mammatus',
	'microlight',
	'miljet',
	'nimbus',
	'rogue',
	'seabreeze',
	'shamal',
	'stunt',
	'titan',
	'tula',
	'velum',
    'velum2',
    'swift',
    'swift2',
	'vestra'
}

local propblacklist = {
    'xs_prop_hamburgher_wl',
    'p_crahsed_heli_s',
    'prop_rock_4_big2',
    'prop_beachflag_le',
    'prop_fnclink_05crnr1',
    'xm_prop_x17_sub',
    'xs_prop_plastic_bottle_wl',
    'prop_windmill_01',
    'prop_windmill_01_I1',
    'prop_windmill_01_slod',
    'prop_windmill_01_slod2',
    'p_spinning_anus_s',
    'stt_prop_ramp_adj_flip_m',
    'stt_prop_ramp_adj_flip_mb',
    'stt_prop_ramp_adj_flip_s',
    'stt_prop_ramp_adj_flip_sb',
    'stt_prop_ramp_adj_hloop',
    'stt_prop_ramp_adj_loop',
    'stt_prop_ramp_jump_l',
    'stt_prop_ramp_jump_m',
    'stt_prop_ramp_jump_s',
    'stt_prop_ramp_jump_xl',
    'stt_prop_ramp_jump_xs',
    'stt_prop_ramp_jump_xxl',
    'stt_prop_ramp_multi_loop_rb',
    'stt_prop_ramp_spiral_l',
    'stt_prop_stunt_soccer_ball',
    'stt_prop_ramp_spiral_l_l',
    'stt_prop_ramp_spiral_l_m',
    'stt_prop_ramp_spiral_l_s',
    'stt_prop_ramp_spiral_l_xxl',
    'stt_prop_ramp_spiral_m',
    'stt_prop_ramp_spiral_s',
    'stt_prop_ramp_spiral_xxl',
    'prop_container_01a',
    'stt_prop_stunt_domino',
    'stt_prop_stunt_jump15',
    'stt_prop_stunt_jump30',
    'stt_prop_stunt_jump45',
    'stt_prop_stunt_jump_l',
    'stt_prop_stunt_jump_lb',
    'stt_prop_stunt_jump_loop',
    'stt_prop_stunt_jump_m',
    'stt_prop_stunt_jump_mb',
    'stt_prop_stunt_jump_s',
    'stt_prop_stunt_jump_sb',
    'stt_prop_stunt_landing_zone_01',
    'stt_prop_stunt_ramp',
    'stt_prop_stunt_soccer_goal',
    'stt_prop_stunt_soccer_lball',
    'stt_prop_stunt_soccer_sball',
    'stt_prop_stunt_target',
    'stt_prop_stunt_small',
    'stt_prop_stunt_track_start',
    'stt_prop_stunt_track_slope45',
    'stt_prop_stunt_track_slope30',
    'stt_prop_stunt_track_slope15',
    'stt_prop_stunt_track_short',
    'stt_prop_stunt_track_dwuturn',
    'stt_prop_stunt_track_dwslope45',
    'stt_prop_stunt_track_funlng',
    'stt_prop_stunt_bowling_ball',
    'stt_prop_stunt_bowling_pin'
}

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if Ped.Active then
			for _,theWeapon in ipairs(weaponblacklist) do
				Wait(10)
				if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
					RemoveWeaponFromPed(Ped.Ped, GetHashKey(theWeapon))
               		TriggerServerEvent('logs:blacklistedweapon', theWeapon)
				end
       		end

       		if IsPedInAnyVehicle(Ped.Ped) then
       			if GetPedInVehicleSeat(Ped.Vehicle, -1) == Ped.Ped then
       				if checkCar(Ped.Vehicle, false) then
       					carModel = GetEntityModel(Ped.Vehicle)
						carName = GetDisplayNameFromVehicleModel(carModel)
       					_DeleteEntity(Ped.Vehicle)
           				TriggerServerEvent('logs:blacklistedcars', carName)
       				end
       			end
        	end

        	if NetworkIsInSpectatorMode() then
            	if not specpermissions then
               		TriggerServerEvent('logs:spectate')
            	end
        	end
		end
	end
end)
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local handle, object = FindFirstObject()
		local finished = false
		repeat
        Wait(10)
			for i,props in ipairs(propblacklist) do
				if GetEntityModel(object) == GetHashKey(props) then
					DeleteObjects(object, false)
				end
			end
		finished, object = FindNextObject(handle)
		until not finished
		EndFindObject(handle)
	end
end)
]]--

function checkCar(car)
	if car then
		if isCarBlacklisted(GetEntityModel(car)) then
			return true
        end
        return false
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(vehicleblacklist) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end

	return false
end

function _DeleteEntity(entity)
	Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end

function DeleteObjects(object, detach)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end
        if detach then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(2000)
		if Plane.CreateMenu ~= nil then
			acDetected()
		elseif e.debug ~= nil then
            acDetected()
		elseif Lynx8.CreateMenu ~= nil then
            acDetected()
		elseif LynxEvo.CreateMenu ~= nil then
			acDetected()
		elseif MaestroMenu.CreateMenu ~= nil then
			acDetected()
		elseif Motion.CreateMenu ~= nil then
			acDetected()
		elseif TiagoMenu.CreateMenu ~= nil then
			acDetected()
		elseif gaybuild.CreateMenu ~= nil then
			acDetected()
		elseif Cience.CreateMenu ~= nil then
			acDetected()
		elseif LynxSeven.CreateMenu ~= nil then
			acDetected()
		elseif MMenu.CreateMenu ~= nil then
			acDetected()
		elseif FantaMenuEvo.CreateMenu ~= nil then
			acDetected()
		elseif GRubyMenu.CreateMenu ~= nil then
			acDetected()
		elseif LR.CreateMenu ~= nil then
			acDetected()
		elseif BrutanPremium.CreateMenu ~= nil then
			acDetected()
		elseif HamMafia.CreateMenu ~= nil then
			acDetected()
		elseif InSec.Logo ~= nil then
			acDetected()
		elseif AlphaVeta.CreateMenu ~= nil then
			acDetected()
		elseif KoGuSzEk.CreateMenu ~= nil then
			acDetected()
		elseif ShaniuMenu.CreateMenu ~= nil then
			acDetected()
		elseif LynxRevo.CreateMenu ~= nil then
			acDetected()
		elseif ariesMenu.CreateMenu ~= nil then
			acDetected()
		elseif WarMenu.InitializeTheme ~= nil then
			acDetected()
		elseif dexMenu.CreateMenu ~= nil then
			acDetected()
		elseif MaestroEra ~= nil then
			acDetected()
		elseif HamHaxia.CreateMenu ~= nil then
			acDetected()
		elseif Ham.CreateMenu ~= nil then
			acDetected()
		elseif HoaxMenu ~= nil then
			acDetected()
		elseif Biznes.CreateMenu ~= nil then
			acDetected()
		elseif FendinXMenu.CreateMenu ~= nil then
			acDetected()
		elseif AlphaV.CreateMenu ~= nil then
			acDetected()
		elseif Deer.CreateMenu ~= nil then
			acDetected()
		elseif NyPremium.CreateMenu ~= nil then
			acDetected()
		elseif nukeserver ~= nil then
			acDetected()
		elseif esxdestroyv2 ~= nil then
			acDetected()
		elseif teleportToNearestVehicle ~= nil then
			acDetected()
		elseif AddTeleportMenu ~= nil then
			acDetected()
		elseif AmbulancePlayers ~= nil then
			acDetected()
		elseif Aimbot ~= nil then
			acDetected()
		elseif RapeAllFunc ~= nil then
			acDetected()
		elseif CrashPlayer ~= nil then
            acDetected()
        elseif scroll ~= nil or zzzt ~= nil or werfvtghiouuiowrfetwerfio ~= nil or llll4874 ~= nil or KAKAAKAKAK ~= nil or udwdj ~= nil or Ggggg ~= nil or jd366213 ~= nil or KZjx ~= nil or ihrug ~= nil or WADUI ~= nil or Crusader ~= nil or FendinX ~= nil or oTable ~= nil or LeakerMenu ~= nil then
            acDetected()
		end
	end
end)

function acDetected()
	TriggerServerEvent("logs:menu")
end
