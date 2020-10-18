Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 2500  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = false -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 5 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 20 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(296.4, -582.7, 43.1), heading = 80.4 }

Config.radius = 1.0

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(289.5, -588.4, 43.1),
			coords2 = vector3(1840.7, 3669.8, 33.6),
			coords3 = vector3(-449.63, -340.37, 34.50),
			sprite = 61,
			scale  = 1.0,
			color  = 0
		},

		AmbulanceActions = {
			vector3(-443.47, -310.62, 34.91-0.90),
			vector3(335.42, -575.08, 43.32-0.90),
		},

		Pharmacies = {
			vector3(-456.96, -310.05, 34.91-0.90),
			vector3(1823.0, 3666.5, 34.27-0.90),
			vector3(338.34, -575.32, 43.32-0.90)
		},

		VehicleDeleter = {
			vector3(-459.52, -346.48, 34.36-1.00),
			vector3(351.65, -587.84, 74.16-0.90),
			vector3(293.51, -571.16, 43.15-0.90),
			vector3(1828.36, 3659.75, 33.92-0.90),
		},	

		Vehicles = {
			{
				Spawner = vector3(-454.44, -333.49, 34.36),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(-466.95, -331.45, 34.36), HEADING = 345.75, radius = 4.0 },
				}
			},
			{
				Spawner = vector3(287.73, -587.85, 43.13),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(289.42, -587.93, 43.16), HEADING = 342.80, radius = 4.0 },
				}
			},
			{
				Spawner = vector3(1835.45, 3663.70, 33.76),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1835.45, 3663.70, 33.76), HEADING = 113.20, radius = 4.0 },
				}
			},
		},

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = '1silv', label = 'Silverado', price = 0 },
		{ model = 'AMR_AMBO', label = 'Karetka', price = 0 },
		{ model = 'AMR_TAHOE', label = 'Tahoe', price = 0 },
		{ model = 'floridacharger', label = 'Charger', price = 0 },
	},

	doctor = {
		{ model = '1silv', label = 'Silverado', price = 0 },
		{ model = 'AMR_AMBO', label = 'Karetka', price = 0 },
		{ model = 'AMR_TAHOE', label = 'Tahoe', price = 0 },
		{ model = 'floridacharger', label = 'Charger', price = 0 },
	},

	chief_doctor = {
		{ model = '1silv', label = 'Silverado', price = 0 },
		{ model = 'AMR_AMBO', label = 'Karetka', price = 0 },
		{ model = 'AMR_TAHOE', label = 'Tahoe', price = 0 },
		{ model = 'floridacharger', label = 'Charger', price = 0 },
	},

	boss = {
		{ model = '1silv', label = 'Silverado', price = 0 },
		{ model = 'AMR_AMBO', label = 'Karetka', price = 0 },
		{ model = 'AMR_TAHOE', label = 'Tahoe', price = 0 },
		{ model = 'floridacharger', label = 'Charger', price = 0 },
	}

}

Config.AuthorizedVehicles = {

	{
		model = '1silv',
		label = 'Silverado'
	},

	{
		model = 'AMR_AMBO',
		label = 'Karetka'
	},
	
	{
		model = 'AMR_TAHOE',
		label = 'Tahoe'
	},

	{
		model = 'floridacharger',
		label = 'Charger'
	},


}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {
		{ model = 'supervolito', label = 'Helka Medyczna', price = 1500 }
	},

	chief_doctor = {
		{ model = 'supervolito', label = 'Helka Medyczna', price = 1500 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 30000 }
	},

	boss = {
		{ model = 'supervolito', label = 'Helka Medyczna', price = 1500 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}

}

Config.Zones = {
	VehicleSpawnPoint = {
		Pos	= { x = -466.95, y = -331.45, z = 34.36 },
		Posxd = vector3(-466.95, -331.45, 34.36),
		Type = -1
	},
	VehicleSpawnPoint2 = {
		Pos	= { x = 289.42, y = -587.93, z = 43.16 },
		Posxd = vector3(289.42, -587.93, 43.16),
		Type = -1
	},
	VehicleSpawnPoint3 = {
		Pos	= { x = 1835.45, y = 3663.70, z = 33.76 },
		Posxd = vector3(1835.45, 3663.70, 33.76),
		Type = -1
	}
}