Config                            = {}
Config.DrawDistance               = 50.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnableOwnedVehicles        = true
Config.ResellPercentage           = 50

Config.Locale                     = 'en'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	
	ShopEntering = {
		Pos   = { x = -796.032, y = -220.145, z = 36.0},
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 36
	},
	ShopOutside = {
		Pos   = { x = -773.004, y = -234.093, z = 37.079},
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 62.11,
		Type  = -1
	},
}
