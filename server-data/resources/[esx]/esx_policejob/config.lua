Config                            = {}


Config.DrawDistance			    = 100.0
Config.MarkerType			    = 1
Config.MarkerSize			    = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor			    = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = true  -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true 

Config.EnableJobBlip              = true -- only turn this on if you are using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale = 'pl'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Pos     = { x = 444.45, y = -983.82, z = 31.72 },
			Sprite  = 60,
			Display = 4,
			Scale   = 1.5,
			Colour  = 63,
		},

		Info = {
			{ x = 437.610, y = -986.108, z = 29.7396 }
		},
         
			AuthorizedWeapons = {
			{ label = 'Combat Pistol', name = 'combatpistol', price = 25000 },
			{ label = 'Heavy Pistol', name = 'heavypistol', price = 70000 },
			{ label = 'Tazer', name = 'stungun', price = 5000 },
			{ label = 'Palka', name = 'nightstick', price = 5000 },
			{ label = 'Latarka', name = 'flashlight', price = 5000 },
			{ label = 'Flara', name = 'flare', price = 10000},
			--{ label = 'Pump Shotgun', name = 'pumpshotgun', price = 1000000},
			--{ label = 'Combat PDW', name = 'combatpdw', price = 500000},
			--{ label = 'SMG MK2', name = 'smg_mk2', price = 1000000},
			--{ label = 'Assault SMG', name = 'assaultsmg', price = 1000000},
			--{ label = 'Bullpup Shotgun', name = 'bullpupshotgun', price = 1000000},
			--{ label = 'Carbine Rifle', name = 'carbinerifle', price = 1000000},
			--{ label = 'Special Carbine', name = 'specialcarbine', price = 1000000},
			{ label = 'Tazer Ammo', name = 'stungun_ammo', price = 2500 },
			{ label = 'Pistol Ammo', name = 'pistol_ammo', price = 5000 },
			--{ label = 'Shotgun Ammo', name = 'shotgun_ammo', price = 10000 },
			--{ label = 'SMG Ammo', name = 'smg_ammo', price = 10000 },
			--{ label = 'Rifle Ammo', name = 'rifle_ammo', price = 10000 },
		},

		Cloakrooms = {
			{ x = 450.88, y = -992.5, z = 29.70 },			--Mission Row
			{ x = 618.73, y = 14.20, z = 82.77-0.90 },		--Vinewood
			
		},

		Armories = {
			{ x = 460.93, y = -982.21, z = 30.68-0.90 },	--Mission Row
			{ x = 625.79, y = -23.19, z = 82.77-0.90 },		--Vinewood
		},
		
		Vehicles = {
			{
				Spawner	= { x = 436.4621, y = -997.639, z = 24.8066 },		--Mission Row
				SpawnPoint = { x = 436.7534, y = -1015.1091, z = 27.7724 },
				Heading	= 178.66
			},
			{
				Spawner	= { x = 538.26, y = -38.91, z = 70.75-0.90 },		--Vinewood
				SpawnPoint = { x = 543.89, y = -47.90, z = 70.91-0.90 },
				Heading	= 221.57
			}
		},

		Helicopters = {
			{
				Spawner    = { x = 449.31, y = -981.57, z = 42.691 },
				SpawnPoint = { x = 449.31, y = -981.57, z = 42.691},
				Heading    = 0.0,
			},
            {
				Spawner    = { x = 1867.44, y = 3646.84, z = 35.82 },
				SpawnPoint = { x = 1867.44, y = 3646.84, z = 35.82 },
                Heading    = 0.0,
			}

		},

		VehicleDeleters = {
			{ x = 455.6361, y = -1024.5342, z = 27.5099 },		--Mission Row
			{ x = -1828.673, y = 3016.278, z = 32.81-0.90 },	--Fort Zancudo
			{ x = 468.504, y = -1025.366, z = 27.30 },			--Mission Row Back
			{ x = 532.35, y = -27.91, z = 70.63-0.90 },			--Vinewood
		},


		BossActions = {
			{ x = 451.05, y = -973.32, z = 30.38 },				--Mission Row
			{ x = 628.87, y = -8.84, z = 82.77 },				--Vinewood
                        
		},

	},

}

Config.grupy = {
	--[[
	'ADAM', -- 1
	'BOY', -- 2
	'EDWARD', -- 3
	'KILO', -- 4
	]]--
	'Task', -- 5
}

-- https://wiki.fivem.net/wiki/Vehicles
Config.AuthorizedVehicles = {
	--[[
	{
		model = '1raptor',
		label = 'Raptor',
		grupy = {3},
	},
	{
		model = '14awd',
		label = 'Dodge 14',
		grupy = {1},
	},	
	{
		model = '17fusionrb',
		label = 'Ford Fusion',
		grupy = {4},
		rejkakurwa = false,
	},
	{
		model = '17zr2',
		label = 'Colorado',
		grupy = {2},
	},
	{
		model = '20f350',
		label = 'Ford F350',
		grupy = {4},
		rejkakurwa = false,
	},	
	{
		model = '20silv',
		label = 'Silverado',
		grupy = {2},
	},	
	{
		model = 'challenger18',
		label = 'Challanger 18',
		grupy = {4},
	},	
	{
		model = 'charger1',
		label = 'Dodge 16',
		grupy = {1},
	},	
	{
		model = 'charger14',
		label = 'Dodge Charger 14 UC',
		grupy = {4},
		rejkakurwa = false,
	},	
	{
		model = 'cvpi',
		label = 'Victoria',
		grupy = {1},
	},	
	{
		model = 'demonrb',
		label = 'Challanger',
		grupy = {4},
		rejkakurwa = false,
	},
	{
		model = 'explorer1',
		label = 'Explorer',
		grupy = {2},
	},
	{
		model = 'fpiu',
		label = 'Explorer',
		grupy = {4},
		rejkakurwa = false,
	},
	{
		model = 'fr',
		label = 'Tahoe',
		grupy = {2},
	},
	{
		model = 'gmc',
		label = 'GMC',
		grupy = {2},
	},
	{
		model = 'heat2',
		label = 'Dodge Charger',
		grupy = {3},
	},
	{
		model = 'hellcatred',
		label = 'Dodge SRT Hellcat',
		grupy = {3},
	},
	{
		model = 'mustang19',
		label = 'Mustang',
		grupy = {3},
	},
	{
		model = 'polram1',
		label = 'Dodge Ram',
		grupy = {3},
	},
	{
		model = 'poljeep1',
		label = 'Jeep',
		grupy = {3},
	},
	{
		model = 'river01',
		label = 'Dodge Ram',
		grupy = {4},
	},
	{
		model = 'sp1',
		label = 'Taurus',
		grupy = {1},
	},
	{
		model = 'suburbanpd',
		label = 'Suburban',
		grupy = {2},
	},
	]]--
	{
		model = 'uctaxi',
		label = 'Taxi',
		grupy = {1},
	},
	{
		model = 'pbus',
		label = 'Bus',
		grupy = {1},
	},
	{
		model = 'policat',
		label = 'Transporter',
		grupy = {1},
	},
	{
		model = 'riot',
		label = 'Riot',
		grupy = {1},
	},
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 49,  ['tshirt_2'] = 0,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 52,   ['pants_2'] = 1,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 8,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 1,
			['arms'] = 31,
			['pants_1'] = 61,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0,
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 39,  ['tshirt_2'] = 0,
			['torso_1'] = 93,  ['torso_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 6,
			['chain_1']	= 6,
		},
		female = {
			['tshirt_1'] = 8,  ['tshirt_2'] = 0,
			['torso_1'] = 192,   ['torso_2'] = 1,
			['arms'] = 31,
			['pants_1'] = 61,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
		}
	},

	k9_wear = {
		male = {
			['tshirt_1'] = 39,  ['tshirt_2'] = 0,
			['torso_1'] = 102,   ['torso_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 1,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['bproof_1'] = 13,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 34,  ['tshirt_2'] = 0,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 54,   ['pants_2'] = 1,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 13,  ['bproof_2'] = 0
		},
	},

	sergeant_wear = {
		male = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 111,   ['torso_2'] = 3,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['arms'] = 4,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 6,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['bproof_1'] = 18,  ['bproof_2'] = 0,
			['glasses_1'] = 8, ['glasses_2'] = 6,
		},
	female = {
		['tshirt_1'] = 34,  ['tshirt_2'] = 0,
		['torso_1'] = 84,   ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 31,
		['pants_1'] = 54,   ['pants_2'] = 1,
		['shoes_1'] = 25,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 3,    ['chain_2'] = 0,
		['ears_1'] = 0,     ['ears_2'] = 0,
		},
	},

	lieutenant_wear = {
		male = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 52,   ['torso_2'] = 2,
			['arms'] = 35,
			['pants_1'] = 59,   ['pants_2'] = 1,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 6,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['bproof_1'] = 27,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 92,   ['torso_2'] = 0,
			['arms'] = 27,
			['pants_1'] = 61,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 4,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['bproof_1'] = 22,  ['bproof_2'] = 0
		},
	},

	kapitan_wear = {
		male = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0,
			['torso_1'] = 52,   ['torso_2'] = 3,
			['arms'] = 35,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 28,  ['helmet_2'] = 1,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['bproof_1'] = 27,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 103,   ['torso_2'] = 0,
			['arms'] = 27,
			['pants_1'] = 90,   ['pants_2'] = 11,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 6,
			['bproof_1'] = 14,  ['bproof_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
		},
	},

	boss_wear = {
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 101,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 28,  ['helmet_2'] = 1,
			['chain_1'] = 128,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bags_1'] = 47, ['bags_2'] = 0,
			['bproof_1'] = 13,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 34,  ['tshirt_2'] = 0,
			['torso_1'] = 84,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 54,   ['pants_2'] = 1,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
		},
	},

	doa_wear = {
		male = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 111,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['helmet_1'] = 44,  ['helmet_2'] = 1,
			['arms'] = 33,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['mask_1'] = 35,  	['mask_2'] = 0,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 18,  ['bproof_2'] = 9
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	swat_wear = {
		male = {
			['tshirt_1'] = 54,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 2,
			['bproof_1'] = 4,  ['bproof_2'] = 0,
			['arms'] = 42,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 75,  ['helmet_2'] = 0,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['mask_1'] = 52,  ['mask_2'] = 0,
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},

	dodatkowy_wear = {
		male = {
			['tshirt_1'] = 53,  ['tshirt_2'] = 0,
			['torso_1'] = 52,   ['torso_2'] = 1,
			['bproof_1'] = 27,  ['bproof_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 52,   ['pants_2'] = 1,
			['helmet_1'] = 7,  ['helmet_2'] = 6,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['chain_1'] = 3,    ['chain_2'] = 0
		}
	},

	m_wear = {
		male = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 1,
			['torso_1'] = 3,   ['torso_2'] = 0,
			['bproof_1'] = 27,  ['bproof_2'] = 5,
			['arms'] = 27,
			['pants_1'] = 59,   ['pants_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 5,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0
		}
	},

	gu_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 221,   ['torso_2'] = 5,
			['mask_1'] = 52,  ['mask_2'] = 10,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 87,   ['pants_2'] = 5,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 13,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bags_1'] = 45,	['bags_2'] = 0,
			['bproof_1'] = 15,  ['bproof_2'] = 2
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 231,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 52,  ['mask_2'] = 10,
			['arms'] = 23,
			['pants_1'] = 90,   ['pants_2'] = 5,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 2,
			['chain_1'] = 3,    ['chain_2'] = 0,
			['bags_1'] = 44,	['bags_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 17,  ['bproof_2'] = 2,
		},
	},
	motocykl_wear = {
		male = {
			['tshirt_1'] = 38,  ['tshirt_2'] = 1,
			['torso_1'] = 139,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 32,   ['pants_2'] = 1,
			['shoes_1'] = 33,   ['shoes_2'] = 0,
			['helmet_1'] = 17,  ['helmet_2'] = 1,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 13,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	galowe_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 220,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 77,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['glasses_1'] = 5, ['glasses_2'] = 1,
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 3
		},
		female = {
			['bproof_1'] = 11,  ['bproof_2'] = 3
		}
	},
	gilet_wear = {
		male = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 10,  ['bproof_2'] = 0
		}
	}
}