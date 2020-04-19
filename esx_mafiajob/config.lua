Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 41
Config.MarkerSize                 = { x = 1.0, y = 2.0, z = 1.0 }
Config.MarkerColor                = { r = 105, g = 105, b = 105 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = false
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.CircleZones = {
    DrugDealer = {coords = vector3(-2675.40, 1319.88, 156.93), name = _U('map_blip'), color = 55, sprite = 310, radius = 110.0},
}

Config.MafiaStations = {
	Mafia = {

		AuthorizedWeapons = {
			{ name = 'WEAPON_COMBATPISTOL',     price = 4000 },
			{ name = 'WEAPON_ASSAULTSMG',       price = 15000 },
			{ name = 'WEAPON_ASSAULTRIFLE',     price = 25000 },
			-- { name = 'WEAPON_PUMPSHOTGUN',      price = 9000 },
			-- { name = 'WEAPON_STUNGUN',          price = 250 },
			{ name = 'WEAPON_FLASHLIGHT',       price = 50 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 50 },
			-- { name = 'WEAPON_FLAREGUN',         price = 3000 },
			{ name = 'GADGET_PARACHUTE',        price = 2000 },
			-- { name = 'WEAPON_SNIPERRIFLE',      price = 50000 },
			-- { name = 'WEAPON_FIREWORK',         price = 5000 },
			-- { name = 'WEAPON_BZGAS',            price = 8000 },
			-- { name = 'WEAPON_SMOKEGRENADE',     price = 8000 },
			{ name = 'WEAPON_APPISTOL',         price = 12000 },
			{ name = 'WEAPON_CARBINERIFLE',     price = 25000 },
			-- { name = 'WEAPON_HEAVYSNIPER',      price = 100000 },
			{ name = 'WEAPON_FLARE',            price = 8000 },
			{ name = 'WEAPON_SWITCHBLADE',      price = 500 },
			{ name = 'WEAPON_REVOLVER',         price = 6000 },
			{ name = 'WEAPON_POOLCUE',          price = 100 },
			-- { name = 'WEAPON_GUSENBERG',        price = 17500 },
		},

		AuthorizedVehicles = {
			{ name = 'tornado',    label = 'Tornado' },
			{ name = 'buccaneer',  label = 'Buccaneer' },
			{ name = 'peyote',     label = 'Peyote' },
			{ name = 'speedo',     label = 'Cammionette' },
		},

		Cloakrooms = {
			{ x = -2676.700, y = 1311.002, z = 152.040 },
		},

		Armories = {
			{ x = -2675.449, y = 1327.426, z = 140.881 },
		},

		Vehicles = {
			{
				Spawner    = { x = -2675.844, y = 1307.619, z = 147.163 },
				SpawnPoint = { x = -2661.644, y = 1307.258, z = 147.183 },
				Heading    = 270.041,
			}
		},

		VehicleDeleters = {
			{ x = -2669.178, y = 1305.187, z = 147.118 },
			{ x = -2669.040, y = 1309.677, z = 147.118 },
		},

		BossActions = {
			{ x = -2679.146, y = 1336.733, z = 152.013 }
		},
	},
}