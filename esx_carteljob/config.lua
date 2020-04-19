Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 3
Config.MarkerSize                 = { x = 1.0, y = 2.0, z = 1.0 }
Config.MarkerColor                = { r = 129, g = 75, b = 1 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = false
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.CircleZones = {
    DrugDealer = {coords = vector3(2442.90, 4975.27, 46.81), name = _U('map_blip'), color = 21, sprite = 119, radius = 110.0},
}

Config.CartelStations = {
	Cartel = {

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
			{ name = 'Kamacho',     label = '4X4' },
			{ name = 'Mesa',  		label = 'Jeep' },
			{ name = 'Rebel',       label = 'Rebel' },
			{ name = 'speedo',      label = 'Cammionette' },
		},

		Cloakrooms = {
			{ x = 2438.745, y = 4963.819, z = 46.810 },
		},

		Armories = {
			{ x = 2444.117, y = 4965.950, z = 46.810 },
		},

		Vehicles = {
		{
			Spawner    = { x = 2451.135, y = 4969.503, z = 46.571 },
			SpawnPoint = { x = 2449.618, y = 4958.222, z = 44.712 },
			Heading    = 211.314,
		}
			},

		VehicleDeleters = {
			{ x = 2445.463, y = 4953.544, z = 45.095 },
		},

		BossActions = {
			{ x = 2456.036, y = 4982.277, z = 46.809 }
		},
	},
}