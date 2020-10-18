nESX				= nil
local DoorInfo	= {}
local doors = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_doorlock:updateState')
AddEventHandler('esx_doorlock:updateState', function(id, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	doors[id].locked = state 
	TriggerClientEvent('esx_doorlock:update', -1, id, state)
end)

ESX.RegisterServerCallback('esx_door:get', function(source, cb)
	doors = {
	--BRAMA LSPD
	
	[1] = { objects = { 
		[1] = {
			object = 'prop_gate_military_01',
			x = 413.8691,
			y = -1025.326,
			z = 28.31443
		} 
	},
	position = vector3(413.54, -1028.67, 30.43),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},

	--KOMENDA KURWA JEBANA MAC
	[2] = { objects = {
		[1] = {
			object = 'v_ilev_ph_door01',
			x = 434.7479, 
			y = -980.6184, 
			z = 30.83926
		},
		[2] = {
			object = 'v_ilev_ph_door002',
			x = 434.7479, 
			y = -983.2151, 
			z = 30.83926
		},
	},
	position = vector3(434.8048, -981.8533, 30.83926),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = false,distance = 1.5,size = 0.6, can = false, draw = true},

	[3] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor002',
			x = 446.5728, 
			y = -980.0106, 
			z = 30.8393
		},
	},
	position = vector3(447.2612, -980.0457, 30.8393),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[4] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 453.0938, 
			y = -983.2294,
			z = 30.83926
		},
	},
	position = vector3(453.0888, -982.6069, 30.83926),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},	

	[5] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor004',
			x = 450.1041, 
			y = -985.7384,
			z = 30.8393
		},
	},
	position = vector3(450.2011, -986.372, 30.8393),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},		

	[6] = { objects = {
		[1] = {
			object = 'slb2k11_secdoor',
			x = 464.1583, 
			y = -1011.26,
			z = 33.0112
		},
	},
	position = vector3(463.516, -1011.26, 33.0112),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},
	
	[7] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 463.6999, 
			y = -983.379,
			z = 35.99437
		},
	},
	position = vector3(463.6825, -983.9447, 35.99437),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[8] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor02',
			x = 464.3613, 
			y = -984.678,
			z = 43.83443
		},
	},
	position = vector3(464.3613, -984.0372, 43.83443),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},	
	
	[9] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor005',
			x = 446.0079, 
			y = -989.4454,
			z = 30.8393
		},
		[2] = {
			object = 'v_ilev_ph_gendoor005',
			x = 443.4078, 
			y = -989.4454,
			z = 30.8393
		},
	},
	position = vector3(444.6676, -989.2844, 30.8393),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[10] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 443.0298, 
			y = -994.5412,
			z = 30.8393
		},
		[2] = {
			object = 'v_ilev_ph_gendoor006',
			x = 443.0298,
			y = -991.941,
			z = 30.8393
		},
	},
	position = vector3(443.0849, -993.202, 30.8393),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[11] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 444.6212, 
			y = -999.001,
			z = 30.78866
		},
		[2] = {
			object = 'v_ilev_gtdoor',
			x = 447.2184,
			y = -999.0023,
			z = 30.78942
		},
	},
	position = vector3(445.8757, -998.9, 30.78866),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[12] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor003',
			x = 438.4709, 
			y = -979.553,
			z = 26.82234
		},
	},
	position = vector3(439.0276, -979.5112, 26.82234),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[13] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor003',
			x = 450.7893, 
			y = -983.8871,
			z = 26.84485
		},
		[2] = {
			object = 'v_ilev_ph_gendoor003',
			x = 453.3887, 
			y = -983.8871,
			z = 26.84485
		},
	},

	position = vector3(452.0659, -983.8757, 26.84485),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	[14] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 442.0476, 
			y = -986.6128,
			z = 26.81976
		},
	},
	position = vector3(441.8929, -986.0573, 26.81976),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},	
	
	[15] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 442.6625, 
			y = -988.2413,
			z = 26.81976
		},
	},
	position = vector3(443.2353, -988.2828, 26.81976),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[16] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 467.5936, 
			y = -977.9933,
			z = 25.05795
		},
	},
	position = vector3(468.1731, -978.0548, 25.05795),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},	
	
	[17] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
			x = 463.6146, 
			y = -980.5814,
			z = 25.05795
		},
	},
	position = vector3(463.662, -981.2595, 25.05795),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},	

	[18] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 464.5701, 
			y = -992.6641,
			z = 25.06443
		},
	},
	position = vector3(463.806, -992.6476, 25.06443),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},	
	
	[19] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 461.8065, 
			y = -994.4086,
			z = 25.06443
		},
	},
	position = vector3(461.8593, -993.6782, 25.06443),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[20] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 461.8065, 
			y = -997.6584,
			z = 25.06443
		},
	},
	position = vector3(461.8255, -998.3372, 25.06443),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[21] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 461.7661, 
			y = -1001.8785,
			z = 23.9647
		},
	},
	position = vector3(461.7661, -1001.8785, 25.06443),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[22] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 463.4782, 
			y = -1003.538,
			z = 23.9647
		},
	},
	position = vector3(464.1603, -1003.538, 25.00599),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[23] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 468.4872, 
			y = -1003.548,
			z = 23.9647
		},
	},
	position = vector3(467.8688, -1003.548, 25.01314),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[24] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 471.4746, 
			y = -1003.538,
			z = 23.9647
		},
	},
	position = vector3(472.1814, -1003.538, 25.01222),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[25] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 477.0496, 
			y = -1003.538,
			z = 23.9647
		},
	},
	position = vector3(476.4406, -1003.553, 25.01203),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[26] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 480.03, 
			y = -1003.538,
			z = 23.9647
		},
	},
	position = vector3(480.7007, -1003.553, 25.01203),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[27] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 467.1921, 
			y = -996.4594,
			z = 25.00599
		},
	},
	position = vector3(467.8575, -996.4594, 25.00599),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[28] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 475.7542, 
			y = -996.4594,
			z = 25.00599
		},
	},
	position = vector3(476.4332, -996.4594, 25.00599),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[29] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 471.4755, 
			y = -996.4594,
			z = 25.00599
		},
	},
	position = vector3(472.0969, -996.4594, 25.00599),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[30] = { objects = {
		[1] = {
			object = 'v_ilev_gtdoor',
			x = 480.03, 
			y = -996.4594,
			z = 25.00599
		},
	},
	position = vector3(480.6529, -996.4594, 25.00599),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[31] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 467.3716, 
			y = -1014.452,
			z = 26.53623
		},
		[2] = {
			object = 'v_ilev_rc_door2',
			x = 469.9679,
			y = -1014.452,
			z = 26.53623,
		}
	},
	position = vector3(468.6913, -1014.536, 26.53623),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[32] = { objects = {
		[1] = {
			object = 'hei_prop_station_gate',
			x = 488.8948, 
			y = -1017.212,
			z = 28.54935
		},
	},
	position = vector3(489.0454, -1020.0048, 28.54935),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 10.0,size = 0.6, can = false, draw = true, gate = true},

	[33] = { objects = {
		[1] = {
			object = 'v_ilev_shrfdoor',
			x = 1854.79, 
			y = 3683.36,
			z = 34.27
		},
	},
	position = vector3(1855.0742, 3683.6052, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = false, distance = 1.50,size = 0.6, can = false, draw = true},
	
	[34] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 1856.34, 
			y = 3689.77,
			z = 34.27
		},
	},
	position = vector3(1856.83, 3689.669, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	[35] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 1850.11, 
			y = 3683.96,
			z = 34.27
		},
	},
	position = vector3(1850.691, 3682.841, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[36] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 1849.25, 
			y = 3691.02,
			z = 34.27
		},
	},
	position = vector3(1848.261, 3690.434, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[37] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 1851.96, 
			y = 3695.08,
			z = 34.27
		},
	},
	position = vector3(1852.389, 3694.638, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[38] = { objects = {
		[1] = {
			object = 'v_ilev_shrfdoor',
			x = 1859.79, 
			y = 3691.87,
			z = 34.27
		},
	},
	position = vector3(1860.1058, 3692.1274, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	[39] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = 1848.47, 
			y = 3683.8,
			z = 30.26
		},
		[2] = {
			object = 'v_ilev_rc_door2',
			x = 1846.63, 
			y = 3682.72,
			z = 30.26
		},
	},
	position = vector3(1847.557, 3683.2268, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},	

	[40] = { objects = {
		[1] = {
			object = 'v_ilev_arm_secdoor',
			x = 1852.12, 
			y = 3685.8,
			z = 30.26
		},
	},
	position = vector3(1852.3867, 3686.02, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[41] = { objects = {
		[1] = {
			object = 'v_ilev_arm_secdoor',
			x = 1855.3, 
			y = 3687.66,
			z = 30.26
		},
	},
	position = vector3(1855.6438, 3687.8459, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[42] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 1847.0429, 
			y = 3685.0725,
			z = 34.2603
		},
	},
	position = vector3(1847.0429, 3685.0725, 34.4603),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[43] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = 1845.2579, 
			y = 3687.9915,
			z = 34.2593
		},
	},
	position = vector3(1845.2579, 3687.9915, 34.4603),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

    -- KOMENDA PALETO KURWAAAAAAAAAAAAAAA

	-- wejscie przod

	[44] = { objects = {
		[1] = {
			object = 'v_ilev_shrf2door',
			x = -443.1, 
			y = 6015.6,
			z = 31.7
		},
		[2] = {
			object = 'v_ilev_shrf2door',
			x = -443.9, 
			y = 6016.6,
			z = 31.7
		},
	},
	position = vector3(-443.5, 6016.3, 32.0),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	-- wejscie tyl

	[45] = { objects = {
		[1] = {
			object = 'v_ilev_gc_door01',
			x = -451.5, 
			y = 6006.6,
			z = 31.7
		},
	},
	position = vector3(-451.5, 6006.6, 31.7),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- wejscie tyl 2

	[46] = { objects = {
		[1] = {
			object = 'v_ilev_gc_door01',
			x = -446.5, 
			y = 6001.8,
			z = 31.7
		},
	},
	position = vector3(-446.8, 6001.81, 31.7),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- wejscie do cel

	[47] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = -432.9, 
			y = 5992.5,
			z = 31.7
		},
	},
	position = vector3(-432.9, 5992.5, 31.7),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- cele 1

	[48] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = -428.5, 
			y = 5997.1,
			z = 31.7
		},
	},
	position = vector3(-428.5, 5997.1, 31.7),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- cele 1

	[49] = { objects = {
		[1] = {
			object = 'v_ilev_ph_cellgate',
			x = -431.7, 
			y = 6000.2,
			z = 31.7
		},
	},
	position = vector3(-431.7, 6000.2, 31.7),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- WEJSCIE OBOK CEL NA MR

	[50] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor003',
			x = 465.587,  
			y = -989.248,
			z = 24.914
		},
		[2] = {
			object = 'v_ilev_ph_gendoor003',
			x = 465.698, 
			y = -990.612,
			z = 24.914
		},
	},

	position = vector3(465.439, -990.037, 24.914),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = false,},locked = true,distance = 1.5,size = 0.6, can = false, draw = true},

	-- SZPITAL LS

	-- WEJSCIE DO SZATNI 1

	[51] = { objects = {
		[1] = {
			object = 'gabz_pillbox_singledoor',
			x = -669.70, 
			y = 333.17,
			z = 83.1
		},
	},
	position = vector3(-669.70, 333.17, 83.1),jobs = { ['ambulance'] = true, ['offambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- WEJSCIE DO SZATNI 2

	[52] = { objects = {
		[1] = {
			object = 'gabz_pillbox_singledoor',
			x = -667.14, 
			y = 328.85,
			z = 83.12
		},
	},
	position = vector3(-667.14, 328.85, 83.12),jobs = { ['ambulance'] = true, ['offambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	-- SZKLANE WEJSCIE DO SAL OPERACYJNYCH

	[53] = { objects = {
		[1] = {
			object = 'gabz_pillbox_doubledoor_l',
			x = -693.05,  
			y = 326.82,
			z = 83.13
		},
		[2] = {
			object = 'gabz_pillbox_doubledoor_r',
			x = -693.05,  
			y = 326.82,
			z = 83.13
		},
	},

	position = vector3(-693.05, 326.82, 83.13),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	-- 2 WEJSCIE DO SAL OPERACYJNYCH

	[54] = { objects = {
		[1] = {
			object = 'gabz_pillbox_doubledoor_l',
			x = -692.51,  
			y = 332.99,
			z = 83.12
		},
		[2] = {
			object = 'gabz_pillbox_doubledoor_r',
			x = -692.51,  
			y = 332.99,
			z = 83.12
		},
	},

	position = vector3(-692.51, 332.99, 83.12),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- WEJSCIE DO SAL 3

	[55] = { objects = {
		[1] = {
			object = 'gabz_pillbox_doubledoor_l',
			x = -691.96, 
			y = 338.84,
			z = 83.12
		},
		[2] = {
			object = 'gabz_pillbox_doubledoor_r',
			x = -691.96, 
			y = 338.84,
			z = 83.12
		},
	},
		
	position = vector3(-691.96, 338.84, 83.12),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- WEJSCIE do pokoju

	[56] = { objects = {
		[1] = {
			object = 'gabz_pillbox_singledoor',
			x = -690.87,  
			y = 352.04,
			z = 83.12
		},
	},
		
	position = vector3(-690.89, 351.82, 84.12-0.90),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	-- WEJSCIE NA GÓRZE 2

	[57] = { objects = {
		[1] = {
			object = 'gabz_pillbox_singledoor',
			x = -690.48,  
			y = 356.73,
			z = 83.12
		},
	},
			
	position = vector3(-690.48, 356.73, 84.12-0.90),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[58] = { objects = {
		[1] = {
			object = 'gabz_pillbox_singledoor',
			x = -689.93,  
			y = 363.20,
			z = 84.12
		},
	},
			
	position = vector3(-689.93, 363.20, 84.12-0.90),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},
	
	-- SZPITAL SANDY

	[59] = { objects = {
		[1] = {
			object = 'v_ilev_cor_doorglassa',
			x = 1826.2,  
			y = 3681.7,
			z = 34.2
		},
		[2] = {
			object = 'v_ilev_cor_doorglassb',
			x = 1825.6,
			y = 3681.6,
			z = 34.2
		},
	},
				
	position = vector3(1826.1, 3681.4, 34.7),jobs = { ['ambulance'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- ndrangheta ldowka

	[60] = { objects = {
		[1] = {
		    object = 'v_ilev_ra_door4r',
			x = 1406.93,
			y = 1128.45,
			z = 114.333
		},
	},
					
	position  = vector3(1406.93, 1128.45, 114.333),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

    -- MECHANIK

    -- BRAMA

	-- POKÓJ PRZÓD

	[61] = { objects = {
		[1] = {
			object = 'v_ilev_roc_door3',
			x = 948.3,  
			y = -964.9,
			z = 39.5
		},
	},
					
	position = vector3(948.3, -964.7, 39.5),jobs = { ['mecano'] = true, ['offmecano'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- POKÓJ TYL

	[62] = { objects = {
		[1] = {
			object = 'v_ilev_roc_door3',
			x = 954.5,  
			y = -972.3,
			z = 39.5
		},
	},
						
	position = vector3(954.5, -972.3, 39.5),jobs = { ['mecano'] = true, ['offmecano'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	-- ORGANIZACJE --

	-- WINIARNIA

	[63] = { objects = {
		[1] = {
			object = 'ball_fridge_mafia_l',
			x = -1864.1,  
			y = 2060.7,
			z = 141.1
		},
		[2] = {
			object = 'ball_fridge_mafia_r',
			x = -1864.1,  
			y = 2060.7,
			z = 141.1
		},
	},
				
	position = vector3(-1864.1, 2060.55, 141.1),jobs = { ['vineyard'] = true,}, locked = true, distance = 1.50,size = 0.6, can = false, draw = true},

	[64] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1888.44, 
			y = 2051.73,
			z = 140.03
		},
		
		[2] = {
			object = 1077118233,
			x = -1889.54, 
			y = 2052.00,
			z = 140.05
		},
		
	},
	position  = vector3(-1889.02, 2051.83, 141.05),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[65] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1885.72, 
			y = 2050.64,
			z = 140.03
		},
		
		[2] = {
			object = 1077118233,
			x = -1886.87, 
			y = 2050.98,
			z = 140.05
		},
		
	},
	position  = vector3(-1886.30, 2050.90, 141.05),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[66] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1860.9155, 
			y = 2053.9917,
			z = 140.06
		},
		
		[2] = {
			object = 1077118233,
			x = -1859.97, 
			y = 2054.13,
			z = 140.06
		},
		
	},
	position  = vector3(-1860.43, 2054.08, 141.05),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[67] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1873.86, 
			y = 2069.29,
			z = 140.04
		},
		
		[2] = {
			object = 1077118233,
			x = -1875.02, 
			y = 2069.90,
			z = 140.05
		},
		
	},
	position  = vector3(-1874.47, 2069.62, 141.04),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[68] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1885.57, 
			y = 2073.60,
			z = 140.04
		},
		
		[2] = {
			object = 1077118233,
			x = -1886.73, 
			y = 2074.04,
			z = 140.04
		},
		
	},
	position  = vector3(-1886.13, 2073.83, 141.04),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[69] = { objects = {
		[1] = {
			object = 1077118233,
			x = -1893.31, 
			y = 2074.70,
			z = 140.05
		},
		
		[2] = {
			object = 1077118233,
			x = -1894.27, 
			y = 2075.59,
			z = 140.06
		},
		
	},
	position  = vector3(-1893.90, 2075.03, 141.05),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[70] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1899.03, 
			y = 2083.23,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1899.95, 
			y = 2084.14,
			z = 139.45
		},
		
	},
	position  = vector3(-1899.51, 2083.66, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[71] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1901.41, 
			y = 2085.34,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1902.51, 
			y = 2086.01,
			z = 139.45
		},
		
	},
	position  = vector3(-1901.94, 2085.74, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[72] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1906.33, 
			y = 2085.07,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1907.07, 
			y = 2084.07,
			z = 139.45
		},
		
	},
	position  = vector3(-1906.72, 2084.64, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[73] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1910.56, 
			y = 2080.04,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1911.33, 
			y = 2079.22,
			z = 139.45
		},
		
	},
	position  = vector3(-1910.99, 2079.76, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	
	[74] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1911.56, 
			y = 2075.16,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1910.54, 
			y = 2074.24,
			z = 139.44
		},
		
	},
	position  = vector3(-1911.07, 2074.74, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[75] = { objects = {
		[1] = {
			object = 1843224684,
			x = -1909.04, 
			y = 2073.24,
			z = 139.45
		},
		
		[2] = {
			object = 1843224684,
			x = -1908.11, 
			y = 2072.33,
			z = 139.45
		},
		
	},
	position  = vector3(-1908.60, 2072.75, 140.45),jobs = {['vineyard'] = true},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

    -- michoacana

	[76] = { objects = {
		[1] = {
			object = 'ball_fridge_mafia_l',
			x = -1526.87, 
			y = 118.49,
			z = 55.73
		},
		
		[2] = {
			object = 'ball_fridge_mafia_r',
			x = -1526.87, 
			y = 118.49,
			z = 55.73
		},
		
	},
	position  = vector3(-1526.87, 118.49, 55.73),jobs = {['michoacana'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[77] = { objects = {
		[1] = {
			object = 'V_ILev_MM_Door',
			x = -1500.78, 
			y = 103.58,
			z = 55.67
		},
	},
	
	position  = vector3(-1500.78, 103.58, 55.67),jobs = {['michoacana'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[78] = { objects = {
		[1] = {
			object = 'prop_doormaf',
			x = -1536.49, 
			y = 131.1,
			z = 57.37
		},
	},
	
	position  = vector3(-1536.49, 131.11, 57.37),jobs = {['michoacana'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[79] = { objects = {
		[1] = {
			object = 'V_ILev_MM_Door',
			x = -1522.56, 
			y = 143.15,
			z = 55.72
		},
	},
	
	position  = vector3(-1522.56, 143.15, 55.72),jobs = {['michoacana'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

    -- casablanca

	[80] = { objects = {
		[1] = {
			object = 'Prop_Control_Rm_door_01',
			x = -683.39,
			y = -875.93,
			z = 24.51
		},
	},

	position  = vector3(-683.39, -875.93, 24.51),jobs = {['casablanca'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[81] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 336.4,
			y = -2021.3,
			z = 22.3
		},
	},
	
	position  = vector3(336.4, -2021.3, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[82] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 345.0,
			y = -2028.7,
			z = 22.3
		},
	},
	
	position  = vector3(345.0, -2028.7, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[83] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 352.2,
			y = -2034.6,
			z = 22.3
		},
	},
	
	position  = vector3(352.2, -2034.6, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[84] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 343.5,
			y = -2027.1,
			z = 22.3
		},
	},
	
	position  = vector3(343.5, -2027.1, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[85] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 336.4,
			y = -2021.3,
			z = 22.3
		},
	},
	
	position  = vector3(336.4, -2021.3, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[86] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 345.0,
			y = -2028.7,
			z = 22.3
		},
	},
	
	position  = vector3(345.0, -2028.7, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[87] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 352.2,
			y = -2034.6,
			z = 22.3
		},
	},
	
	position  = vector3(352.2, -2034.6, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[88] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 343.5,
			y = -2027.1,
			z = 22.3
		},
	},
	
	position  = vector3(343.5, -2027.1, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[89] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 332.9,
			y = -2018.2,
			z = 22.3
		},
	},
	
	position  = vector3(332.9, -2018.2, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[90] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 336.4,
			y = -2021.3,
			z = 22.3
		},
	},
	
	position  = vector3(336.4, -2021.3, 22.3),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	-- tabasco

	[91] = { objects = {
		[1] = {
			object = 'tor_door_main_r',
			x = -1516.8,
			y = 851.1,
			z = 181.5
		},
		[2] = {
			object = 'tor_door_main_l',
			x = -1516.8,
			y = 851.1,
			z = 181.5
		},
	},
	
	position  = vector3(-1516.8, 851.1, 181.5),jobs = {['tabasco'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	[92] = { objects = {
		[1] = {
			object = 'prop_lrggate_01_r',
			x = -1477.58,
			y = 886.81,
			z = 182.83
		},
		[2] = {
			object = 'prop_lrggate_01_l',
			x = -1478.17,
			y = 883.55,
			z = 182.88
		},
	},
	
	position  = vector3(-1477.71, 884.71, 182.87),jobs = {['tabasco'] = true,},locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},

	[93] = { objects = {
		[1] = {
			object = 'V_ILev_PH_CELLGATE',
			x = -1494.42,
			y = 840.27,
			z = 178.70
		},
	},
	
	position  = vector3(-1494.42, 840.27, 178.70),jobs = {['tabasco'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	[94] = { objects = {
		[1] = {
			object = 'V_ILev_PH_CELLGATE',
			x = -1491.66,
			y = 834.67,
			z = 178.70
		},
	},
	
	position  = vector3(-1491.66, 834.67, 178.70),jobs = {['tabasco'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

    -- SHAPESHIFTERS

	[95] = { objects = {
		[1] = {
			object = 'Prop_LrgGate_01c_R',
			x = -2652.53,
			y = 1326.54,
			z = 147.04
		},
	},
	
	position  = vector3(-2652.53, 1326.54, 147.84),jobs = {['shapeshifters'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	[96] = { objects = {
		[1] = {
			object = 'apa_p_mp_Yacht_Door_01',
			x = -2667.56,
			y = 1326.48,
			z = 147.44
		},
	},
	
	position  = vector3(-2667.56, 1326.48, 147.44),jobs = {['shapeshifters'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	[97] = { objects = {
		[1] = {
			object = 'xm_Prop_IAA_BASE_Door_01',
			x = -2666.86,
			y = 1330.15,
			z = 147.46
		},
	},
	
	position  = vector3(-2666.86, 1330.15, 147.46),jobs = {['shapeshifters'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	[98] = { objects = {
		[1] = {
			object = 'apa_Prop_SS1_MPint_Garage2',
			x = -2652.06,
			y = 1307.19,
			z = 146.61
		},
	},
	
	position  = vector3(-2652.06, 1307.19, 146.61),jobs = {['shapeshifters'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},

	-- blackrose

	[99] = { objects = {
		[1] = {
			object = 'apa_p_mp_Yacht_Door_01',
			x = -112.40,
			y = 986.22,
			z = 235.78
		},
	},
	
	position  = vector3(-112.40, 986.22, 235.78),jobs = {['blackrose'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[100] = { objects = {
		[1] = {
			object = 'apa_p_mp_Yacht_Door_01',
			x = -62.30,
			y = 998.40,
			z = 234.75
		},
	},
	
	position  = vector3(-62.30, 998.40, 234.75),jobs = {['blackrose'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[101] = { objects = {
		[1] = {
			object = 'apa_p_mp_Yacht_Door_01',
			x = -76.05,
			y = 994.694,
			z = 234.50
		},
	},
	
	position  = vector3(-76.05, 994.694, 234.50),jobs = {['blackrose'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[102] = { objects = {
		[1] = {
			object = 'V_ILev_Tort_Door',
			x = 2566.68,
			y = 4651.757,
			z = 34.07
		},
	},
	
	position  = vector3(2566.68, 4651.757, 34.07),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[103] = { objects = {
		[1] = {
			object = 'V_ILev_Tort_Door',
			x = 2555.88,
			y = 4651.807,
			z = 34.07
		},
	},
	
	position  = vector3(2555.88, 4651.807, 34.07),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	-- BALLAS 

	[104] = { objects = {
		[1] = {
			object = 'V_ILev_Tort_Door',
			x = 114.18,
			y = -1961.51,
			z = 21.33
		},
	},
	
	position  = vector3(114.18, -1961.51, 21.33),jobs = {['ballas'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},


	[105] = { objects = {
		[1] = {
			object = 'ball_prop_sync_door03_l',
			x = 113.25,
			y = -1973.78,
			z = 21.33
		},
	},
		
	position  = vector3(113.25, -1973.78, 21.33),jobs = {['ballas'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},


	[106] = { objects = {
		[1] = {
			object = 'ball_prop_sync_door03m_r',
			x = 118.4,
			y = -1973.9,
			z = 21.32
		},
		[2] = {
			object = 'ball_prop_sync_door03m_l',
			x = 117.7,
			y = -1974.1,
			z = 21.32
		},
	},
	
	position  = vector3(118.06, -1974.0, 21.3),jobs = {['ballas'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},


	[107] = { objects = {
		[1] = {
			object = 'prop_garagel_door_01m_r',
			x = 108.1,
			y = -1975.8,
			z = 20.96
		},
		[2] = {
			object = 'prop_garagel_door_01m_l',
			x = 108.1,
			y = -1975.8,
			z = 20.96
		},
	},
		
	position  = vector3(107.85, -1975.86, 20.97),jobs = {['ballas'] = true,},locked = true, distance = 4.0,size = 0.6, can = false, draw = true},


	[108] = { objects = {
		[1] = {
			object = 'ball_prop_sync_door03_r',
			x = 111.12,
			y = -1978.62,
			z = 20.97
		},
	},
		
	position  = vector3(111.12, -1978.62, 20.97),jobs = {['ballas'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	

	[109] = { objects = {
		[1] = {
			object = 'ball_prop_sync_door03g_r',
			x = 105.31,
			y = -1977.01,
			z = 20.97
		},
	},
			
	position  = vector3(105.31, -1977.01, 20.97),jobs = {['ballas'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	--blatino

	[110] = { objects = {
		[1] = {
			object = 'v_ilev_mm_doorm_l',
			x = -816.46, 
			y = 178.22,
			z = 72.22
		},
		[2] = {
			object = 'v_ilev_mm_doorm_r',
			x = -816.46, 
			y = 178.22,
			z = 72.22
		},
	},
	
	position  = vector3(-816.46, 178.22, 72.22),jobs = {['blatino'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[111] = { objects = {
		[1] = {
			object = 'prop_bh1_48_backdoor_l',
			x = -795.58, 
			y = 177.75,
			z = 72.83
		},
		[2] = {
			object = 'prop_bh1_48_backdoor_r',
			x = -795.58, 
			y = 177.75,
			z = 72.83
		},
	},
	
	position  = vector3(-795.58, 177.75, 72.83),jobs = {['blatino'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[112] = { objects = {
		[1] = {
			object = 'prop_bh1_48_backdoor_l',
			x = -793.59, 
			y = 181.57,
			z = 72.83
		},
		[2] = {
			object = 'prop_bh1_48_backdoor_r',
			x = -793.59, 
			y = 181.57,
			z = 72.83
		},
	},
	
	position  = vector3(-793.59, 181.57, 72.83),jobs = {['blatino'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[113] = { objects = {
		[1] = {
			object = 'v_ilev_mm_door',
			x = -806.77,
			y = 185.61,
			z = 72.48
		},
	},
			
	position  = vector3(-806.77, 185.61, 72.48),jobs = {['blatino'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},


	-- KONIEC ORGANIZACJI 
	-- JAK COS "SEGREGUJCIE" TO ROBCIE TAK JAK JA KC <3

	[114] = { objects = {
		[1] = {
			object = 'kt1_11_mp_door',
			x = -662.52,
			y = -854.55,
			z = 24.51
		},
	},
			
	position  = vector3(-662.52, -854.55, 24.51),jobs = {[''] = false,},locked = true, distance = 1.5,size = 0.6, can = false, draw = false},

	
    [115] = { objects = {
	    [1] = {
		    object = 'v_ilev_fh_frontdoor',
		    x = 7.51,
		    y = 539.52,
		    z = 176.17
	    },
    },
		
    position  = vector3(7.51, 539.52, 176.17),jobs = {['ass'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

    [116] = { objects = {
	    [1] = {
		    object = 'v_ilev_fa_frontdoor',
		    x = -14.36,
		    y = -1441.52,
		    z = 31.10
	    },
    },
		
    position  = vector3(-14.36, -1441.52, 31.10),jobs = {['groove'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

   	[117] = { objects = {
	    [1] = {
		    object = 'prop_biolab_g_door',
		    x = 531.83,
		    y = -22.01,
		    z = 70.63
	    },
	   	[2] = {
		    object = 'prop_biolab_g_door',
		    x = 527.40,
		    y = -24.71,
		    z = 70.63
	    },
    },
		
    position  = vector3(529.82, -23.54, 70.63),jobs = {[''] = false,},locked = true, distance = 1.5,size = 0.6, can = false, draw = false},

	[118] = { objects = {
	    [1] = {
		    object = 'prop_ch1_07_door_02l',
		    x = 245.20,
		    y = -1074.83,
		    z = 29.28
	    },
	   	[2] = {
		    object = 'prop_ch1_07_door_02l',
		    x = 242.27,
		    y = -1074.79,
		    z = 29.29
	    },
    },
		
    position  = vector3(243.22, -1074.19, 29.28),jobs = {[''] = false,},locked = true, distance = 1.5,size = 0.6, can = false, draw = false},

    [119] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 353.48,
			y = -2036.19,
			z = 22.35
		},
	},
	
	position  = vector3(353.48, -2036.19, 22.35),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[120] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 361.04,
			y = -2042.29,
			z = 22.35
		},
	},
	
	position  = vector3(361.04, -2042.29, 22.35),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[121] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 364.63,
			y = -2045.43,
			z = 22.35
		},
	},
	
	position  = vector3(364.63, -2045.43, 22.35),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[122] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 371.31,
			y = -2040.59,
			z = 22.19
		},
	},
	
	position  = vector3(371.31, -2040.59, 22.19),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[123] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 336.38,
			y = -2011.27,
			z = 22.39
		},
	},
	
	position  = vector3(336.38, -2011.27, 22.39),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[124] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 344.95,
			y = -2016.22,
			z = 22.39
		},
	},
	
	position  = vector3(344.95, -2016.22, 22.39),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[125] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 353.34,
			y = -2023.26,
			z = 22.40
		},
	},
	
	position  = vector3(353.34, -2023.26, 22.40),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[126] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 356.22,
			y = -2025.38,
			z = 22.39
		},
	},
	
	position  = vector3(356.22, -2025.38, 22.39),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[127] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 362.04,
			y = -2029.68,
			z = 22.39
		},
	},
	
	position  = vector3(362.04, -2029.68, 22.39),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	

	[128] = { objects = {
		[1] = {
			object = 'prop_door_vagos_gang',
			x = 364.73,
			y = -2032.34,
			z = 22.39
		},
	},
	
	position  = vector3(364.73, -2032.34, 22.39),jobs = {['vagos'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},


---LOST---
	
	[129] = { objects = {
		[1] = {
			object = 'lost_mc_gate',
			x = 957.55,
			y = -138.75,
			z = 74.49
		},
	},
	
	position  = vector3(959.39, -140.28, 74.49),jobs = {['lost'] = true,},locked = true, distance = 6.0,size = 0.6, can = false, draw = true},
	
	[130] = { objects = {
		[1] = {
			object = 'lost_mc_door_01',
			x = 982.44,
			y = -125.49,
			z = 74.05
		},
	},
	
	position  = vector3(982.44, -125.49, 74.05),jobs = {['lost'] = true,},locked = true, distance = 6.0,size = 0.6, can = false, draw = true},
	
	[131] = { objects = {
		[1] = {
			object = 'v_ilev_ss_door5_r',
			x = 958.59,
			y = -121.06,
			z = 75.01
		},
	},
	
	position  = vector3(958.59, -121.06, 75.01),jobs = {['lost'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true}, 
	
	[132] = { objects = {
		[1] = {
			object = 'v_ilev_carmod3door',
			x = 968.24,
			y = -112.12,
			z = 74.36
		},
	},
	
	position  = vector3(968.24, -112.12, 74.36),jobs = {['lost'] = true,},locked = true, distance = 6.0,size = 0.6, can = false, draw = true},
	
	[133] = { objects = {
		[1] = {
			object = 'v_ilev_carmod3door',
			x = 962.88,
			y = -117.40,
			z = 74.36
		},
	},
	
	position  = vector3(962.88, -117.40, 74.36),jobs = {['lost'] = true,},locked = true, distance = 6.0,size = 0.6, can = false, draw = true},
	
	[134] = { objects = {
		[1] = {
			object = 'v_ilev_lostdoor',
			x = 981.64,
			y = -103.05,
			z = 74.84
		},
	},
	
	position  = vector3(981.64, -103.05, 74.84),jobs = {['lost'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

	[135] = { objects = {
		[1] = {
			object = 'v_ilev_ss_door04',
			x = 991.55,
			y = -133.27,
			z = 74.08
		},
	},
	
	position  = vector3(991.55, -133.27, 74.08),jobs = {['lost'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	
	----MAFIA----
	
	[136] = { objects = {
		[1] = {
			object = 'prop_rebel_door_r',
		    x = 732.00,
		    y = 2522.84,
		    z = 73.50
		},
		[2] = {
			object = 'prop_rebel_door_r',
		    x = 732.01,
		    y = 2524.12,
		    z = 73.50
		},
	},
	position = vector3(732.06, 2523.44, 73.50),jobs = {['mafia'] = true,},locked = true	,distance = 1.5,size = 0.6, can = false, draw = true},
	
	[137] = { objects = {
		[1] = {
			object = 'int_rebel_door03',
			x = 721.84,
			y = 2520.22,
			z = 73.50
		},
	},
	
	position  = vector3(721.84, 2520.22, 73.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[138] = { objects = {
		[1] = {
			object = 'int_rebel_door03',
			x = 721.67,
			y = 2524.40,
			z = 73.50
		},
	},
	
	position  = vector3(721.67, 2524.40, 73.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[139] = { objects = {
		[1] = {
			object = 'int_rebel_door03',
			x = 724.44,
			y = 2530.03,
			z = 73.50
		},
	},
	
	position  = vector3(724.44, 2530.03, 73.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[140] = { objects = {
		[1] = {
			object = 'int_rebel_door03',
			x = 715.28,
			y = 2531.01,
			z = 73.50
		},
	},
	
	position  = vector3(715.28, 2531.01, 73.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[141] = { objects = {
		[1] = {
			object = 'prop_rebel_door04_r',
			x = 712.79,
			y = 2532.81,
			z = 73.50
		},
	},
	
	position  = vector3(712.79, 2532.81, 73.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[142] = { objects = {
		[1] = {
			object = 'int_rebel_door03',
			x = 739.61,
			y = 2584.23,
			z = 75.50
		},
	},
	
	position  = vector3(739.61, 2584.23, 75.50),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[143] = { objects = { 
		[1] = {
			object = 'Prop_FacGate_07b',
			x = -3136.58500000,
			y = 798.95240000,
			z = 16.35332000
		} 
	},
	position = vector3(-3135.57, 795.94, 17.31),jobs = { ['mafia'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[144] = { objects = {
		[1] = {
			object = 'Prop_Burto_Gate_01',
		    x = -3221.66400000,
		    y = 837.35990000,
		    z = 8.71796000
		},
		[2] = {
			object = 'Prop_Burto_Gate_01',
		    x = -3219.79700000,
		    y = 838.55150000,
		    z = 8.71796000
		},
	},
	
	position  = vector3(-3220.83, 837.99, 8.93),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[145] = { objects = { 
		[1] = {
			object = 'Prop_CH_025c_G_door_01',
			x = -3208.50900000,
			y = 840.44710000,
			z = 9.27735500
		} 
	},
	position = vector3(-3208.50900000, 840.44710000, 9.27735500),jobs = { ['mafia'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[146] = { objects = { 
		[1] = {
			object = 'Prop_CH_025c_G_door_01',
			x = -3204.35000000,
			y = 833.91300000,
			z = 9.28017000
		} 
	},
	position = vector3(-3204.35000000, 833.91300000, 9.28017000),jobs = { ['mafia'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[147] = { objects = { 
		[1] = {
			object = 'V_ILev_FH_FrontDoor',
			x = -3199.38100000,
			y = 826.19300000,
			z = 9.08010600
		} 
	},
	position = vector3(-3199.38100000, 826.81300000, 9.08010600),jobs = { ['mafia'] = true,}, locked = true, distance = 1.5,size = 1.5, can = false, draw = true},
	
	[148] = { objects = { 
		[1] = {
			object = 'V_ILev_FH_FrontDoor',
			x = -3217.28300000,
			y = 816.32680000,
			z = 9.07710500
		} 
	},
	position = vector3(-3217.28300000, 816.32680000, 9.07710500),jobs = { ['mafia'] = true,}, locked = true, distance = 1.5,size = 1.5, can = false, draw = true},
	
	[149] = { objects = {
		[1] = {
			object = 'Prop_Burto_Gate_01',
		    x = -3197.21100000,
		    y = 764.51510000,
		    z = 8.71796000
		},
		[2] = {
			object = 'Prop_Burto_Gate_01',
		    x = -3199.07600000,
		    y = 763.31950000,
		    z = 8.71796000
		},
	},
	
	position  = vector3(-3198.10, 764.03, 8.93),jobs = {['mafia'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
--La Fuenta---	
	[150] = { objects = {
		[1] = {
			object = 'V_ILev_RA_Door1_R',
		    x = 1400.21100000,
		    y = 1128.51510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'V_ILev_RA_Door1_L',
		    x = 1401.07600000,
		    y = 1128.31950000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1400.57600000, 1128.31950000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[151] = { objects = {
		[1] = {
			object = 'V_ILev_RA_Door1_R',
		    x = 1390.21100000,
		    y = 1131.71510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'V_ILev_RA_Door1_L',
		    x = 1390.07600000,
		    y = 1132.31950000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1390.57600000, 1132.31950000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[152] = { objects = {
		[1] = {
			object = 'v_ilev_ra_door4l',
		    x = 1395.86100000,
		    y = 1142.35510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'v_ilev_ra_door4r',
		    x = 1395.98600000,
		    y = 1141.410000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1395.86600000, 1141.93950000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[153] = { objects = {
		[1] = {
			object = 'V_ILev_RA_Door1_R',
		    x = 1390.54100000,
		    y = 1161.83510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'V_ILev_RA_Door1_L',
		    x = 1390.98600000,
		    y = 1162.410000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1390.54100000, 1162.38510000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[154] = { objects = {
		[1] = {
			object = 'V_ILev_RA_Door1_R',
		    x = 1408.54100000,
		    y = 1159.83510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'V_ILev_RA_Door1_L',
		    x = 1408.98600000,
		    y = 1160.410000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1408.54100000, 1160.28510000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[155] = { objects = {
		[1] = {
			object = 'V_ILev_RA_Door1_R',
		    x = 1408.54100000,
		    y = 1164.83510000,
		    z = 114.71796000
		},
		[2] = {
			object = 'V_ILev_RA_Door1_L',
		    x = 1408.98600000,
		    y = 1165.410000,
		    z = 114.71796000
		},
	},
	
	position  = vector3(1408.54100000, 1164.78510000, 114.71796000),jobs = {['ndrangheta'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

--- Playboy Bramy ---	
	[156] = { objects = { 
		[1] = {
			object = 'prop_lrggate_02_ld',
			x = -1615.89000000,
			y = 79.91300000,
			z = 61.28017000
		} 
	},
	position = vector3(-1613.53300000, 78.91300000, 61.28017000),jobs = { ['michoacana'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[157] = { objects = { 
		[1] = {
			object = 'prop_lrggate_02_ld',
			x = -1473.62000000,
			y = 68.31300000,
			z = 53.28017000
		} 
	},
	position = vector3(-1471.53300000, 67.78300000, 53.28017000),jobs = { ['michoacana'] = true,}, locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},

--- Richmanmafia
	[158] = { objects = {
		[1] = {
			object = 'Prop_LrgGate_01_pst',
		    x = -1159.51300000,
		    y = 309.50270000,
		    z = 68.71733000
		},
		[2] = {
			object = 'Prop_LrgGate_01_R',
		    x = -1162.08600000,
		    y = 314.43180000,
		    z = 68.71733000
		},
	},
	
	position  = vector3(-1160.797, 311.9988, 68.44),jobs = {['affls'] = true,},locked = true, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[159] = { objects = {
		[1] = {
			object = 'tor_cartel_door_1',
		    x = -1190.65,
		    y = 292.50,
		    z = 69.89
		},
		[2] = {
			object = 'tor_cartel_door_2',
		    x = -1189.33600000,
		    y = 292.760000,
		    z = 69.89796000
		},
	},
	
	position  = vector3(-1190.13100000, 292.52510000, 69.89796000),jobs = {['affls'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[160] = { objects = {
		[1] = {
			object = 'tor_door_l',
		    x = -1193.69,
		    y = 300.50,
		    z = 69.87
		},
		[2] = {
			object = 'tor_door_r',
		    x = -1192.33600000,
		    y = 300.500000,
		    z = 69.89796000
		},
	},
	
	position  = vector3(-1193.20100000, 300.93510000, 69.89796000),jobs = {['affls'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[161] = { objects = {
		[1] = {
			object = 'v_ilev_ra_door2',
			x = -1199.22,
			y = 297.00,
			z = 69.72
		},
	},
	
	position  = vector3(-1199.22, 297.00, 69.72),jobs = {['affls'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	---Bahamas---
	
	[162] = { objects = {
		[1] = {
			object = 'v_ilev_ph_gendoor006',
		    x = -1393.12,
		    y = -591.77,
		    z = 30.31
		},
		[2] = {
			object = 'v_ilev_ph_gendoor006',
		    x = -1392.47600000,
		    y = -592.580000,
		    z = 30.32796000
		},
	},
	
	position  = vector3(-1392.73000000, -592.13000000, 30.32796000),jobs = {['bahamas'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

---Szpital Fonah	

---Sale Operacyjne---
	[163] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -448.28,
			y = -316.69,
			z = 34.91
		},
	},
	
	position  = vector3(-448.28,-316.69, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[164] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -449.42,
			y = -313.89,
			z = 34.91
		},
	},
	
	position  = vector3(-449.42,-313.89, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[165] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -451.81,
			y = -308.43,
			z = 34.91
		},
	},
	
	position  = vector3(-451.81,-308.43, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[166] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -453.05,
			y = -305.36,
			z = 34.91
		},
	},
	
	position  = vector3(-453.05,-305.36, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[167] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -455.19,
			y = -299.82,
			z = 34.91
		},
	},
	
	position  = vector3(-455.19,-299.82, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[168] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -457.43,
			y = -294.56,
			z = 34.91
		},
	},
	
	position  = vector3(-457.43,-294.56, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
		[169] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -443.02,
			y = -316.44,
			z = 34.91
		},
	},
	
	position  = vector3(-443.02,-316.44, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[170] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -447.01,
			y = -306.18,
			z = 34.91
		},
	},
	
	position  = vector3(-447.01,-306.18, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[171] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -449.36,
			y = -300.51,
			z = 34.91
		},
	},
	
	position  = vector3(-449.36,-300.51, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[172] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -452.87,
			y = -292.28,
			z = 34.91
		},
	},
	
	position  = vector3(-452.87,-292.28, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
---Przebieralnia / Recepcja----	

	[173] = { objects = {
		[1] = {
			object = 'gus_hos_door',
			x = -440.57,
			y = -322.28,
			z = 34.91
		},
	},
	
	position  = vector3(-440.57,-322.28, 34.91),jobs = { ['ambulance'] = true, ['offambulance'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
---MEchanik--- Bramy

	[174] = { objects = { 
		[1] = {
			object = 'prop_com_ls_door_01',
			x = -355.64900000,
			y = -134.87710000,
			z = 39.00735500
		} 
	},
	position = vector3(-355.64940000, -134.8710000, 39.00735500),jobs = { ['mecano'] = true,  ['offmecano'] = true,}, locked = false, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},
	
	[175] = { objects = { 
		[1] = {
			object = 'prop_com_ls_door_01',
			x = -350.27900000,
			y = -116.65710000,
			z = 39.00735500
		} 
	},
	position = vector3(-350.27940000, -116.6510000, 39.00735500),jobs = { ['mecano'] = true,  ['offmecano'] = true,}, locked = false, distance = 15.0,size = 1.5, can = false, draw = true, gate = true},

---Zaplecze Mechanik----
	[176] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = -316.19,
			y = -135.42,
			z = 39.00
		},
	},
	
	position  = vector3(-316.19,-135.42, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[177] = { objects = {
		[1] = {
			object = 'v_ilev_rc_door2',
			x = -312.50,
			y = -124.39,
			z = 39.00
		},
	},
	
	position  = vector3(-312.50,-124.39, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[178] = { objects = {
		[1] = {
			object = 'apa_V_ILev_SS_Door8',
			x = -312.18,
			y = -115.87,
			z = 39.00
		},
	},
	
	position  = vector3(-312.18,-115.87, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[179] = { objects = {
		[1] = {
			object = 'apa_V_ILev_SS_Door7',
			x = -320.68,
			y = -138.20,
			z = 39.00
		},
	},
	
	position  = vector3(-320.68,-138.20, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[180] = { objects = {
		[1] = {
			object = 'apa_V_ILev_SS_Door8',
			x = -347.83,
			y = -133.54,
			z = 39.00
		},
	},
	
	position  = vector3(-347.83,-133.54, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[181] = { objects = {
		[1] = {
			object = 'apa_V_ILev_SS_Door7',
			x = -345.73 ,
			y = -122.64,
			z = 39.00
		},
	},
	
	position  = vector3(-345.73,-122.64, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},
	
	[182] = { objects = {
		[1] = {
			object = 'apa_V_ILev_SS_Door8',
			x = -354.19 ,
			y = -128.37,
			z = 39.00
		},
	},
	
	position  = vector3(-354.19,-128.37, 39.00),jobs = { ['mecano'] = true,  ['offmecano'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},


	
}
	cb(doors)
end)

function IsAuthorized(jobName, doorID)
	for i=1, #doorID.authorizedJobs, 1 do
		if doorID.authorizedJobs[i] == jobName then
			return true
		end
	end
	return false
end