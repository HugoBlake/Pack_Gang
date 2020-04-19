Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 3
Config.MarkerSize                 = { x = 1.0, y = 2.0, z = 1.0 }
Config.MarkerColor                = { r = 239, g = 224, b = 0 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = false
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.CircleZones = {
    DrugDealer = {coords = vector3(329.95, -2036.40, 20.96), name = _U('map_blip'), color = 46, sprite = 84, radius = 110.0},
}

Config.VagosStations = {
	Vagos = {

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
			{ x = 353.286, y = -2036.662, z = 22.353 },
		},

		Armories = {
			{ x = 351.855, y = -2035.471, z = 22.353 },
		},

		Vehicles = {
			{
				Spawner    = { x = 313.437, y = -2028.472, z = 20.545 },
				SpawnPoint = { x = 329.465, y = -2042.366, z = 20.811 },
				Heading    = 142.937,
			}
		},

		VehicleDeleters = {
			{ x = 325.487, y = -2025.938, z = 21.012 },
		},

		BossActions = {
			{ x = 364.880, y = -2064.508, z = 21.744 }
		},
	},
}