Config              = {}
Config.JailBlip     = {x = 1855.00, y = 2605.00, z = 45.64}
Config.JailLocation = {x = 1664.64, y = 2534.08, z = 45.56}
Config.JailJobs = {
	{x = 1664.101, y = 2493.124, z = 45.56},
	{x = 1654.101, y = 2502.124, z = 45.56},
	{x = 1643.101, y = 2511.124, z = 45.56},
	{x = 1634.101, y = 2519.124, z = 45.56}
}
Config.Locale       = 'pl'
Config.Notify       = false

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 237, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 5,   ['arms_2'] = 0,
			['pants_1']  = 3,   ['pants_2']  = 7,
			['shoes_1']  = 12,  ['shoes_2']  = 12
		},
		female = {
			['tshirt_1'] = 14,   ['tshirt_2'] = 0,
			['torso_1']  = 68,  ['torso_2']  = 16,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 14,   ['arms_2'] = 0,
			['pants_1']  = 2,   ['pants_2']  = 2,
			['shoes_1']  = 27,  ['shoes_2']  = 0
		}
	}
}

Config.Jobs = {
	Marker = {
		Color = {r = 204, g = 204, b = 0},
		Size  = {x = 3.0, y = 3.0, z = 1.0}, 
		Type  = 1
	},
	List = {
		{
			Pos = {x = 1689.326, y = 2551.525, z = 44.564},
			Name = '#1'
		},
		{
			Pos = {x = 1700.200, y = 2474.780, z = 44.564},
			Name = '#2'
		},
		{
			Pos = {x = 1609.010, y = 2566.986, z = 44.564},
			Name = '#3'
		},
		{
			Pos = {x = 1717.449, y = 2567.409, z = 44.564},
			Name = '#4'
		},
		{
			Pos = {x = 1772.111, y = 2546.052, z = 44.586},
			Name = '#5'
		}
	}
}

Config.Cutscene = {
	["PhotoPosition"] = { ["x"] = 402.91567993164, ["y"] = -996.75970458984, ["z"] = -99.000259399414, ["h"] = 186.22499084473 },

	["CameraPos"] = { ["x"] = 402.88830566406, ["y"] = -1003.8851318359, ["z"] = -97.419647216797, ["rotationX"] = -15.433070763946, ["rotationY"] = 0.0, ["rotationZ"] = -0.31496068835258, ["cameraId"] = 0 },

	["PolicePosition"] = { ["x"] = 402.91702270508, ["y"] = -1000.6376953125, ["z"] = -99.004028320313, ["h"] = 356.88052368164 }
}
