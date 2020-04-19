local LastStation, LastPart, LastPartNum, CurrentAction = nil, nil, nil, nil
local IsHandcuffed, IsDragged, HasAlreadyEnteredMarker = false, false, false
local CurrentActionData, CopPed, CurrentActionMsg = {}, '', 0

ESX                             = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function OpenCloakroomMenu()
	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = {
			{ label = _U('citizen_wear'),  value = 'citizen_wear' },
			{ label = _U('vagos_wear'),    value = 'vagos_wear'}
		}}, function(data, menu)
		
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin3', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'vagos_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin3', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
    end)
end

function OpenArmoryMenu(station)
	if Config.EnableArmoryManagement then
		local elements = {
		{label = _U('get_weapon'),  value = 'get_weapon'},
		{label = _U('put_weapon'),  value = 'put_weapon'},
		{label = _U('get_stock'),   value = 'get_stock'},
		{label = _U('put_stock'),   value = 'put_stock'}}

		if ESX.PlayerData.job3.grade_name == 'boss' then
			table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)

        if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
            OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
            OpenGetStocksMenu()
        end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)
	else
		local elements = {}

		for i=1, #Config.VagosStations[station].AuthorizedWeapons, 1 do
			local weapon = Config.VagosStations[station].AuthorizedWeapons[i]
			table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local weapon = data.current.value
			TriggerServerEvent('esx_vagosjob:giveWeapon', weapon,  1000)
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)
	end
end

function OpenVehicleSpawnerMenu(station, partNum)
	local vehicles = Config.VagosStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	if Config.EnableSocietyOwnedVehicles then
		local elements = {}
			ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

		for i=1, #garageVehicles, 1 do
			table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title    = _U('vehicle_menu'),
			align    = 'top-left',
			elements = elements,
        }, function(data, menu)
			menu.close()

			local vehicleProps = data.current.value

			ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				local playerPed = GetPlayerPed(-1)
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			end)
				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'vagos', vehicleProps)
			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)
		end, 'vagos')
	else
		local elements = {}

		for i=1, #Config.VagosStations[station].AuthorizedVehicles, 1 do
			local vehicle = Config.VagosStations[station].AuthorizedVehicles[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title    = _U('vehicle_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			menu.close()

        local model = data.current.value
        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then
			local playerPed = GetPlayerPed(-1)
				if Config.MaxInService == -1 then
					ESX.Game.SpawnVehicle(model, {
						x = vehicles[partNum].SpawnPoint.x,
						y = vehicles[partNum].SpawnPoint.y,
						z = vehicles[partNum].SpawnPoint.z
						}, vehicles[partNum].Heading, function(vehicle)
						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						local numberplate = math.random(1000, 9999)
						SetVehicleNumberPlateText(vehicle," VAGOS  “ .. numberplate .. ”")
						local color = GetIsVehiclePrimaryColourCustom(vehicle)
						SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
					end)
				else
					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if canTakeService then
							ESX.Game.SpawnVehicle(model, {
								x = vehicles[partNum].SpawnPoint.x,
								y = vehicles[partNum].SpawnPoint.y,
								z = vehicles[partNum].SpawnPoint.z
								}, vehicles[partNum].Heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
							end)
						else
							ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
						end
					end, 'vagos')
				end
			else
				ESX.ShowNotification(_U('vehicle_out'))
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}
		end)
	end
end

function OpenVagosActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vagos_actions', {
		title    = _U('map_blip'),
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
		}}, function(data, menu)

		if data.current.value == 'citizen_interaction' then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('id_card'),         value = 'identity_card'},
					{label = _U('search'),          value = 'body_search'},
					{label = _U('handcuff'),        value = 'handcuff'},
					{label = _U('drag'),            value = 'drag'},
					{label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
					{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
					{label = _U('fine'),            value = 'fine'}
				}}, function(data2, menu2)
				
				local player, distance = ESX.Game.GetClosestPlayer()

				if distance ~= -1 and distance <= 3.0 then

					if data2.current.value == 'identity_card' then
						OpenIdentityCardMenu(player)
					end

					if data2.current.value == 'body_search' then
					OpenBodySearchMenu(player)
					end

					if data2.current.value == 'handcuff' then
						TriggerServerEvent('esx_vagosjob:handcuff', GetPlayerServerId(player))
					end

					if data2.current.value == 'drag' then
						TriggerServerEvent('esx_vagosjob:drag', GetPlayerServerId(player))
					end

					if data2.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_vagosjob:putInVehicle', GetPlayerServerId(player))
					end

					if data2.current.value == 'out_the_vehicle' then
						TriggerServerEvent('esx_vagosjob:OutVehicle', GetPlayerServerId(player))
					end

					if data2.current.value == 'fine' then
						OpenFineMenu(player)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'vehicle_interaction' then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('vehicle_info'), value = 'vehicle_infos'},
					{label = _U('pick_lock'),    value = 'hijack_vehicle'},
				}}, function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then
				local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

				if data2.current.value == 'vehicle_infos' then
					OpenVehicleInfosMenu(vehicleData)
				end

				if data2.current.value == 'hijack_vehicle' then
					local playerPed = GetPlayerPed(-1)
					local coords    = GetEntityCoords(playerPed)

					if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
						local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

							if DoesEntityExist(vehicle) then
								Citizen.CreateThread(function()
									TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
									Wait(20000)
									ClearPedTasksImmediately(playerPed)
									SetVehicleDoorsLocked(vehicle, 1)
									SetVehicleDoorsLockedForAllPlayers(vehicle, false)
									TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))
								end)
							end
						end
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
    end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
	if Config.EnableESXIdentity then
		ESX.TriggerServerCallback('esx_vagosjob:getOtherPlayerData', function(data)
			local jobLabel    = nil
			local sexLabel    = nil
			local sex         = nil
			local dobLabel    = nil
			local heightLabel = nil
			local idLabel     = nil

			if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
				jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
				jobLabel = 'Job : ' .. data.job.label
			end
			
			if data.sex ~= nil then
				if (data.sex == 'm') or (data.sex == 'M') then
					sex = 'Male'
				else
					sex = 'Female'
				end
					sexLabel = 'Sex : ' .. sex
				else
					sexLabel = 'Sex : Unknown'
			end
			
			if data.dob ~= nil then
				dobLabel = 'DOB : ' .. data.dob
			else
				dobLabel = 'DOB : Unknown'
			end
			
			if data.height ~= nil then
				heightLabel = 'Height : ' .. data.height
			else
				heightLabel = 'Height : Unknown'
			end

			if data.name ~= nil then
				idLabel = 'ID : ' .. data.name
			else
				idLabel = 'ID : Unknown'
			end

		local elements = {
			{label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
			{label = sexLabel,    value = nil},
			{label = dobLabel,    value = nil},
			{label = heightLabel, value = nil},
			{label = jobLabel,    value = nil},
			{label = idLabel,     value = nil},
		}

			if data.drunk ~= nil then
				table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
			end

			if data.licenses ~= nil then
				table.insert(elements, {label = '--- Licenses ---', value = nil})

			for i=1, #data.licenses, 1 do
					table.insert(elements, {label = data.licenses[i].label, value = nil})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements,
			}, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)

		end, GetPlayerServerId(player))
	else
		ESX.TriggerServerCallback('esx_vagosjob:getOtherPlayerData', function(data)
			local jobLabel = nil

				if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
					jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
				else
					jobLabel = 'Job : ' .. data.job.label
				end

				local elements = {
					{label = _U('name') .. data.name, value = nil},
					{label = jobLabel,                value = nil},
				}

				if data.drunk ~= nil then
					table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
				end

				if data.licenses ~= nil then
					table.insert(elements, {label = '--- Licenses ---', value = nil})

				for i=1, #data.licenses, 1 do
						table.insert(elements, {label = data.licenses[i].label, value = nil})
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
					title    = _U('citizen_interaction'),
					align    = 'top-left',
					elements = elements,
				}, function(data, menu)

			end, function(data, menu)
				menu.close()
			end)
		end, GetPlayerServerId(player))
	end
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_vagosjob:getOtherPlayerData', function(data)
		local elements = {}
		local blackMoney = 0

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' then
				blackMoney = data.accounts[i].money
			end
		end
			table.insert(elements, {
				label          = _U('confiscate_dirty') .. blackMoney,
				value          = 'black_money',
				itemType       = 'item_account',
				amount         = blackMoney
			})
			table.insert(elements, {label = '--- Armes ---', value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.ammo,
			})
		end
			table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					value          = data.inventory[i].name,
					itemType       = 'item_standard',
					amount         = data.inventory[i].count,
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value ~= nil then
				TriggerServerEvent('esx_vagosjob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'),   value = 0},
			{label = _U('minor_offense'),     value = 1},
			{label = _U('average_offense'),   value = 2},
			{label = _U('major_offense'),     value = 3}
		}}, function(data, menu)

		OpenFineCategoryMenu(player, data.current.value)

    end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_vagosjob:getFineList', function(fines)
		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
			label     = fines[i].label .. ' $' .. fines[i].amount,
			value     = fines[i].id,
			amount    = fines[i].amount,
			fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local label  = data.current.fineLabel
			local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_vagos', _U('fine_total') .. label, amount)
        else
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
			OpenFineCategoryMenu(player, category)
        end)

		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_vagosjob:getVehicleInfos', function(infos)
		local elements = {}

			table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

		if infos.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements,
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_vagosjob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			menu.close()

        ESX.TriggerServerCallback('esx_vagosjob:removeArmoryWeapon', function()
			OpenGetWeaponMenu()
        end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
			title    = _U('put_weapon_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			menu.close()

		ESX.TriggerServerCallback('esx_vagosjob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value)
		
	end, function(data, menu)
		menu.close()
    end)
end

function OpenBuyWeaponsMenu(station)
	ESX.TriggerServerCallback('esx_vagosjob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #Config.VagosStations[station].AuthorizedWeapons, 1 do
			local weapon = Config.VagosStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.name then
					count = weapons[i].count
				break
				end
			end
				table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
				title    = _U('buy_weapon_menu'),
				align    = 'top-left',
				elements = elements,
			}, function(data, menu)

			ESX.TriggerServerCallback('esx_vagosjob:buy', function(hasEnoughMoney)

			if hasEnoughMoney then
				ESX.TriggerServerCallback('esx_vagosjob:addArmoryWeapon', function()
					OpenBuyWeaponsMenu(station)
				end, data.current.value)
			else
				ESX.ShowNotification(_U('not_enough_money'))
			end
        end, data.current.price)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_vagosjob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count ~= 0 then
				table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label, 
				value = items[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('vagos_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
              
					TriggerServerEvent('esx_vagosjob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_vagosjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count, 
					type = 'item_standard', 
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
				
					TriggerServerEvent('esx_vagosjob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob3')
AddEventHandler('esx:setJob3', function(job3)
	ESX.PlayerData.job3 = job3
end)

AddEventHandler('esx_vagosjob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end

	if part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end

	if part == 'VehicleSpawner' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end

	if part == 'VehicleDeleter' then
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end

	if part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_vagosjob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_vagosjob:handcuff')
AddEventHandler('esx_vagosjob:handcuff', function()
	IsHandcuffed    = not IsHandcuffed;
	local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()

		if IsHandcuffed then
			RequestAnimDict('mp_arresting')

			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed,  true)
		else
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed,  true)
			FreezeEntityPosition(playerPed, false)
		end
	end)
end)

RegisterNetEvent('esx_vagosjob:drag')
AddEventHandler('esx_vagosjob:drag', function(cop)
	TriggerServerEvent('esx:clientLog', 'starting dragging')
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
	while true do
    Wait(0)
	
    if IsHandcuffed then
		if IsDragged then
			local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
			local myped = GetPlayerPed(-1)
				AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				DetachEntity(GetPlayerPed(-1), true, false)
			end
		end
	end
end)

RegisterNetEvent('esx_vagosjob:putInVehicle')
AddEventHandler('esx_vagosjob:putInVehicle', function()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle,  i) then
					freeSeat = i
				break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
			end
		end
	end
end)

RegisterNetEvent('esx_vagosjob:OutVehicle')
AddEventHandler('esx_vagosjob:OutVehicle', function(t)
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2
	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
    Wait(0)
	
		if IsHandcuffed then
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
    Wait(10)

		if ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' then
			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config.VagosStations) do
				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				if Config.EnablePlayerManagement and ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' and ESX.PlayerData.job3.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
							DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1000)

    if ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' then
		local playerPed      = GetPlayerPed(-1)
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation, currentPart, currentPartNum = nil, nil, nil

		for k,v in pairs(Config.VagosStations) do
			for i=1, #v.Cloakrooms, 1 do
				if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'Cloakroom'
					currentPartNum = i
				end
			end

			for i=1, #v.Armories, 1 do
				if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'Armory'
					currentPartNum = i
				end
			end

			for i=1, #v.Vehicles, 1 do
				if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleSpawner'
					currentPartNum = i
				end

				if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleSpawnPoint'
					currentPartNum = i
				end
			end

			for i=1, #v.VehicleDeleters, 1 do
				if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleDeleter'
					currentPartNum = i
				end
			end

			if Config.EnablePlayerManagement and ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' and ESX.PlayerData.job3.grade_name == 'boss' then
				for i=1, #v.BossActions, 1 do
					if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'BossActions'
						currentPartNum = i
					end
				end
			end
		end

		local hasExited = false
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

				if (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esx_vagosjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end
				
				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum
				TriggerEvent('esx_vagosjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end
		
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_vagosjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
		end
	end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
	local blip = AddBlipForRadius(coords, radius)

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	blip = AddBlipForCoord(coords)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	for k,zone in pairs(Config.CircleZones) do
		CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

	if CurrentAction ~= nil then
		SetTextComponentFormat('STRING')
		AddTextComponentString(CurrentActionMsg)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

		if IsControlJustReleased(0, 38) and ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' then

        if CurrentAction == 'menu_cloakroom' then
			OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
			OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
			OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

			if Config.EnableSocietyOwnedVehicles then
				local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
				TriggerServerEvent('esx_society:putVehicleInGarage', 'vagos', vehicleProps)
			else
				if GetEntityModel(vehicle) == GetHashKey('tornado')  or GetEntityModel(vehicle) == GetHashKey('buccaneer') or GetEntityModel(vehicle) == GetHashKey('peyote') or GetEntityModel(vehicle) == GetHashKey('speedo') then
					TriggerServerEvent('esx_service:disableService', 'vagos')
				end
			end
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			end

		if CurrentAction == 'menu_boss_actions' then
			ESX.UI.Menu.CloseAll()

			TriggerEvent('esx_society:openBossMenu', 'vagos', function(data, menu)
				menu.close()
		  	end, {employees = false, grades = false, salesform = false})

				CurrentAction     = 'menu_boss_actions'
				CurrentActionMsg  = _U('open_bossmenu')
				CurrentActionData = {}
			end
				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, 56) and ESX.PlayerData.job3 ~= nil and ESX.PlayerData.job3.name == 'vagos' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'vagos_actions') then
			OpenVagosActionsMenu()
		end
	end
end)