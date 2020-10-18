Config = {}

Config.Price = 300

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 211, g = 211, b = 211}
Config.MarkerType   = 27

Config.Locale = 'pl'

Config.Zones = {}

Config.Shops = {
	{x = -814.308,  y = -183.823,  z = 36.6},
	{x = 136.826,   y = -1708.373, z = 28.4},
	{x = -1282.604, y = -1116.757, z = 6.0},
	{x = 1931.513,  y = 3729.671,  z = 31.9},
	{x = 1212.840,  y = -472.921,  z = 65.3},
	{x = -32.885,   y = -152.319,  z = 56.20},
	{x = -278.077,  y = 6228.463,  z = 30.7}
}

for i=1, #Config.Shops, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Shops[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
