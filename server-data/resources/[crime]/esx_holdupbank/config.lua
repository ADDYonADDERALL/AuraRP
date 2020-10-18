Config = {}
Config.Locale = 'en'
Config.TimerBeforeNewRob = 7200

Banks = {
    ["blainecounty_savings"] = {
        position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
        reward = math.random(400000,800000),
        nameofbank = "Bank Blaine County",
        secondsRemaining = 500, -- seconds
        lastrobbed = 0,
        pd = 4,
        blip = 'Napad na bank',
        ikonka = 255,
        kolor = 1,
    },
	["fleecahighway_savings"] = {
        position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
        reward = math.random(400000,800000),
        nameofbank = "Fleeca Bank \"Autostrada\"",
        secondsRemaining = 500, -- seconds
        lastrobbed = 0,
        pd = 4,
        blip = 'Napad na bank',
        ikonka = 255,
        kolor = 1,
    },
    ["fleecahighway_savings"] = {
        position = { ['x'] = 1176.44, ['y'] = 2711.70, ['z'] = 38.097 },
        reward = math.random(400000,800000),
        nameofbank = "Fleeca Bank na \"Route 68\"",
        secondsRemaining = 500, -- seconds
        lastrobbed = 0,
        pd = 4,
        blip = 'Napad na bank',
        ikonka = 255,
        kolor = 1,
    },
    ["fleecacentre_savings"] = {
        position = { ['x'] =  147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605},
        reward = math.random(400000,800000),
        nameofbank = "Fleeca Bank \"Centrum Miasta\"",
        secondsRemaining = 500, -- seconds
        lastrobbed = 0,
        pd = 4,
        blip = 'Napad na bank',
        ikonka = 255,
        kolor = 1,
    },
    ["muzeum"] = {
		position = { ['x']= -610.72, ['y'] = -605.98, ['z'] = -2.45 },
		reward = math.random(600000, 1200000),
		nameofbank = "Muzeum",
		secondsRemaining = 500, -- seconds
		blip = 'Napad na Muzeum',
		ikonka = 255,
		kolor = 1,
		pd = 8,
		lastrobbed = 0,
	},
    ["yacht"] = {
        position = { ['x']= -2031.47, ['y'] = -1037.98, ['z'] = 2.56 },
        reward = math.random(800000, 1400000),
        nameofbank = "Jacht",
        secondsRemaining = 500, -- seconds
        blip = 'Napad na Jacht',
        ikonka = 455,
        kolor = 1,
        pd = 8,
        lastrobbed = 0,
    },
    ["mazebank"] = {
        position = { ['x']= -1310.04, ['y'] = -811.04, ['z'] = 17.14 },
        reward = math.random(1200000, 1800000),
        nameofbank = "Muzeum",
        secondsRemaining = 500, -- seconds
        blip = 'Napad na MazeBank',
        ikonka = 255,
        kolor = 1,
        pd = 10,
        lastrobbed = 0,
    },
    ["humane"] = {
        position = { ['x'] = 3537.8774414063, ['y'] = 3659.7934570313, ['z'] = 28.121873855591 },
        reward = math.random(1200000,2400000),
        nameofbank = "Laboratorium Humane Labs",
        secondsRemaining = 600, -- seconds
        lastrobbed = 0,
        pd = 10,
        blip = 'Napad na Humane Labs',
        ikonka = 499,
        kolor = 3,
    }
}