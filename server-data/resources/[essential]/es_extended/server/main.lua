AddEventHandler('es:playerLoaded', function(source, _player)
	local _source = source
	local tasks   = {}

	local userData = {
		accounts     = {},
		inventory    = {},
		job          = {},
		job2		 = {},
		loadout      = {},
		playerName   = GetPlayerName(_source),
		lastPosition = nil
	}

	TriggerEvent('es:getPlayerFromId', _source, function(player)
	
		-- Update user name in DB
		table.insert(tasks, function(cb)
			MySQL.Async.execute('UPDATE `users` SET `name` = @name WHERE `identifier` = @identifier', {
				['@identifier'] = player.getIdentifier(),
				['@name']       = userData.playerName
			}, function(rowsChanged)
				cb()
			end)
		end)

		-- Get accounts
		table.insert(tasks, function(cb)
			MySQL.Async.fetchAll('SELECT * FROM `user_accounts` WHERE `identifier` = @identifier', {
				['@identifier'] = player.getIdentifier()
			}, function(accounts)

				for i=1, #Config.Accounts, 1 do
					for j=1, #accounts, 1 do
						if accounts[j].name == Config.Accounts[i] then
							table.insert(userData.accounts, {
								name  = accounts[j].name,
								money = accounts[j].money,
								label = Config.AccountLabels[accounts[j].name]
							})
						end
					end
				end

				cb()
			end)
		end)

		-- Get inventory
		table.insert(tasks, function(cb)

			MySQL.Async.fetchAll('SELECT * FROM `user_inventory` WHERE `identifier` = @identifier', {
				['@identifier'] = player.getIdentifier()
			}, function(inventory)

				local tasks2 = {}

				for i=1, #inventory, 1 do
					local debug = false -- Debugowanie przedmiotów
					if debug then
						print("Przedmiot: " .. inventory[i].item)
						print("Label: " .. ESX.Items[inventory[i].item].label)
						print("---------------------------")
					end
					table.insert(userData.inventory, {
						name = inventory[i].item,
						count = inventory[i].count,
						label = ESX.Items[inventory[i].item].label,
						limit = ESX.Items[inventory[i].item].limit,
						usable = ESX.UsableItemsCallbacks[inventory[i].item] ~= nil,
						rare = ESX.Items[inventory[i].item].rare,
						canRemove = ESX.Items[inventory[i].item].canRemove
					})
				end

				for k,v in pairs(ESX.Items) do
					local found = false

					for j=1, #userData.inventory, 1 do
						if userData.inventory[j].name == k then
							found = true
							break
						end
					end

					if not found then

						table.insert(userData.inventory, {
							name = k,
							count = 0,
							label = ESX.Items[k].label,
							limit = ESX.Items[k].limit,
							usable = ESX.UsableItemsCallbacks[k] ~= nil,
							rare = ESX.Items[k].rare,
						})

						local scope = function(item, identifier)

							table.insert(tasks2, function(cb2)
								MySQL.Async.execute('INSERT INTO user_inventory (identifier, item, count) VALUES (@identifier, @item, @count)', {
									['@identifier'] = identifier,
									['@item'] = item,
									['@count'] = 0
								}, function(rowsChanged)
									cb2()
								end)
							end)

						end

						scope(k, player.getIdentifier())

					end

				end

				Async.parallelLimit(tasks2, 5, function(results) end)

				table.sort(userData.inventory, function(a,b)
					return a.label < b.label
				end)

				cb()
			end)

		end)

		-- Get job and loadout
		table.insert(tasks, function(cb)

			local tasks2 = {}

			-- Get job name, grade and last position
			table.insert(tasks2, function(cb2)

				MySQL.Async.fetchAll('SELECT job, job_grade, loadout, position FROM `users` WHERE `identifier` = @identifier', {
					['@identifier'] = player.getIdentifier()
				}, function(result)
					local job, grade = result[1].job, tostring(result[1].job_grade)

					if ESX.DoesJobExist(job, grade) then
							local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

							userData.job = {}

							userData.job.id    = jobObject.id
							userData.job.name  = jobObject.name
							userData.job.label = jobObject.label

							userData.job.grade        = tonumber(grade)
							userData.job.grade_name   = gradeObject.name
							userData.job.grade_label  = gradeObject.label
							userData.job.grade_salary = gradeObject.salary

							userData.job.skin_male    = {}
							userData.job.skin_female  = {}

							if gradeObject.skin_male ~= nil then
								userData.job.skin_male = json.decode(gradeObject.skin_male)
							end

							if gradeObject.skin_female ~= nil then
									userData.job.skin_female = json.decode(gradeObject.skin_female)
							end
							else
							print(('es_extended: %s had an unknown job [job: %s, grade: %s], setting as unemployed!'):format(player.getIdentifier(), job, grade))

							local job, grade = 'unemployed', '0'
							local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

							userData.job = {}

							userData.job.id    = jobObject.id
							userData.job.name  = jobObject.name
							userData.job.label = jobObject.label

							userData.job.grade        = tonumber(grade)
							userData.job.grade_name   = gradeObject.name
							userData.job.grade_label  = gradeObject.label
							userData.job.grade_salary = gradeObject.salary

							userData.job.skin_male    = {}
							userData.job.skin_female  = {}
					end
					cb2()
				end)

			end)

			-- SECONDJOB
			table.insert(tasks2, function(cb2)

				MySQL.Async.fetchAll('SELECT job2, job2_grade, loadout, position FROM `users` WHERE `identifier` = @identifier', {
					['@identifier'] = player.getIdentifier()
				}, function(result)
					local job2, grade2 = result[1].job2, tostring(result[1].job2_grade)

					if ESX.DoesJobExist(job2, grade2) then
							local job2Object, grade2Object = ESX.Jobs[job2], ESX.Jobs[job2].grades[grade2]

							userData.job2 = {}

							userData.job2.id    = job2Object.id
							userData.job2.name  = job2Object.name
							userData.job2.label = job2Object.label

							userData.job2.grade        = tonumber(grade2)
							userData.job2.grade_name   = grade2Object.name
							userData.job2.grade_label  = grade2Object.label
							userData.job2.grade_salary = grade2Object.salary

							userData.job2.skin_male    = {}
							userData.job2.skin_female  = {}

							if grade2Object.skin_male ~= nil then
								userData.job2.skin_male = json.decode(grade2Object.skin_male)
							end

							if grade2Object.skin_female ~= nil then
									userData.job2.skin_female = json.decode(grade2Object.skin_female)
							end
							else
							print(('es_extended: %s had an unknown job [job: %s, grade: %s], setting as unemployed!'):format(player.getIdentifier(), job, grade))

							local job2, grade2 = 'unemployed2', '0'
							local job2Object, grade2Object = ESX.Jobs[job2], ESX.Jobs[job2].grades[grade2]

							userData.job2 = {}

							userData.job2.id    = job2Object.id
							userData.job2.name  = job2Object.name
							userData.job2.label = job2Object.label

							userData.job2.grade        = tonumber(grade2)
							userData.job2.grade_name   = grade2Object.name
							userData.job2.grade_label  = grade2Object.label
							userData.job2.grade_salary = grade2Object.salary

							userData.job2.skin_male    = {}
							userData.job2.skin_female  = {}
						end

						if result[1].loadout ~= nil then
							userData.loadout = json.decode(result[1].loadout)

						-- Compatibility with old loadouts prior to components update
						for k,v in ipairs(userData.loadout) do
							if v.components == nil then
								v.components = {}
							end
						end
					end

						if result[1].position ~= nil then
							userData.lastPosition = json.decode(result[1].position)
						end

					cb2()
				end)

			end)

		-- Get job and loadout

			Async.series(tasks2, cb)

		end)

		-- Run Tasks
		Async.parallel(tasks, function(results)

			local xPlayer = CreateExtendedPlayer(player, userData.accounts, userData.inventory, userData.job, userData.job2, userData.loadout, userData.playerName, userData.lastPosition)

			xPlayer.getMissingAccounts(function(missingAccounts)

				if #missingAccounts > 0 then

					for i=1, #missingAccounts, 1 do
						table.insert(xPlayer.accounts, {
							name  = missingAccounts[i],
							money = 0,
							label = Config.AccountLabels[missingAccounts[i]]
						})
					end

					xPlayer.createAccounts(missingAccounts)
				end

				ESX.Players[_source] = xPlayer

				TriggerEvent('esx:playerLoaded', _source, xPlayer)

				TriggerClientEvent('esx:playerLoaded', _source, {
					identifier   = xPlayer.identifier,
					accounts     = xPlayer.getAccounts(),
					inventory    = xPlayer.getInventory(),
					job2 		 = xPlayer.getJob2(),
					job          = xPlayer.getJob(),
					loadout      = xPlayer.getLoadout(),
					lastPosition = xPlayer.getLastPosition(),
					money        = xPlayer.getMoney()
				})

				xPlayer.displayMoney(xPlayer.getMoney())

			end)

		end)

	end)

end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		TriggerEvent('esx:playerDropped', _source, reason)

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[_source]        = nil
			ESX.LastPlayerData[_source] = nil
		end)
	end
end)

RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.loadout = loadout
end)

RegisterServerEvent('esx:updateLastPosition')
AddEventHandler('esx:updateLastPosition', function(position)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setLastPosition(position)
end)

RegisterServerEvent('esx:giveInventoryItemasek')
AddEventHandler('esx:giveInventoryItemasek', function(target, type, itemName, itemCount)
	local _source = source
	local _target = target
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == 'item_standard' then

		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then

			if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('ex_inv_lim', _target))
			else
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem   (itemName, itemCount)

				TriggerClientEvent('esx:showNotification', _source, _U('gave_item', itemCount, ESX.Items[itemName].label, _target))
				TriggerClientEvent('esx:showNotification', target,  _U('received_item', itemCount, ESX.Items[itemName].label, _source))
				TriggerEvent("logs:giveitem",_source, sourceXPlayer.name, target, targetXPlayer.name,ESX.Items[itemName].label,itemCount)
			end

		else
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
		end

	elseif type == 'item_money' then

		if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then

			sourceXPlayer.removeMoney(itemCount)
			targetXPlayer.addMoney   (itemCount)

			TriggerClientEvent('esx:showNotification', _source, _U('gave_money', ESX.Math.GroupDigits(itemCount), _target))
			TriggerClientEvent('esx:showNotification', target,  _U('received_money', ESX.Math.GroupDigits(itemCount), _source))
			TriggerEvent("logs:givemoney",_source, sourceXPlayer.name, target, targetXPlayer.name,itemCount)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
		end

	elseif type == 'item_account' then

		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then

			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney   (itemName, itemCount)

			TriggerClientEvent('esx:showNotification', _source, _U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.AccountLabels[itemName], _target))
			TriggerClientEvent('esx:showNotification', target,  _U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.AccountLabels[itemName], _source))
			TriggerEvent("logs:givemoneyblack",_source, sourceXPlayer.name, target, targetXPlayer.name,itemCount)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
		end

	elseif type == 'item_weapon' then

		if not targetXPlayer.hasWeapon(itemName) then

			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)

			local weaponLabel = ESX.GetWeaponLabel(itemName)

			if itemCount > 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('gave_weapon_ammo', weaponLabel, itemCount, _target))
				TriggerClientEvent('esx:showNotification', target,  _U('received_weapon_ammo', weaponLabel, itemCount, _source))
				TriggerEvent("logs:giveweapon",_source, sourceXPlayer.name, target, targetXPlayer.name,weaponLabel) 
			else
				TriggerClientEvent('esx:showNotification', _source, _U('gave_weapon', weaponLabel, _target))
				TriggerClientEvent('esx:showNotification', target,  _U('received_weapon', weaponLabel, _target))
				TriggerEvent("logs:giveweapon",_source, sourceXPlayer.name, target, targetXPlayer.name,weaponLabel) 
			end

		else
			TriggerClientEvent('esx:showNotification', _source, _U('gave_weapon_hasalready', _target, weaponLabel))
			TriggerClientEvent('esx:showNotification', _source, _U('received_weapon_hasalready', _source, weaponLabel))
		end

	end

end)

RegisterServerEvent('esx:startTimeoutPickup')
AddEventHandler('esx:startTimeoutPickup', function(id)
	local _id = id
	TriggerClientEvent('esx:removePickupTimeout', -1, _id)
end)

RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local _source = source

	if type == 'item_standard' then

		if itemCount == nil or itemCount < 1 then
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
		else

			local xPlayer = ESX.GetPlayerFromId(source)
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_quantity'))
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				TriggerClientEvent('esx:showNotification', _source, _U('threw_standard', itemCount, xItem.label))
				TriggerClientEvent("animacjawyrzuc", _source)
				TriggerClientEvent('3dme:triggerDisplay', -1, "Upuścił na ziemię x".. itemCount .." " .. xItem.label .. "", _source)
			end

		end

	elseif type == 'item_money' then

		if itemCount == nil or itemCount < 1 then
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
		else

			local xPlayer = ESX.GetPlayerFromId(source)
			local playerCash = xPlayer.getMoney()

			if (itemCount > playerCash or playerCash < 1) then
				TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
			else
				xPlayer.removeMoney(itemCount)
				TriggerClientEvent('esx:showNotification', _source, _U('threw_money', ESX.Math.GroupDigits(itemCount)))
				TriggerClientEvent("animacjawyrzuc", _source)
				TriggerClientEvent('3dme:triggerDisplay', -1, "Upuścił na ziemię ".. ESX.Math.GroupDigits(itemCount) .."$", _source)
			end

		end

	elseif type == 'item_account' then

		if itemCount == nil or itemCount < 1 then
			TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
		else

			local xPlayer = ESX.GetPlayerFromId(source)
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				TriggerClientEvent('esx:showNotification', _source, _U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))
				TriggerClientEvent("animacjawyrzuc", _source)
				TriggerClientEvent('3dme:triggerDisplay', -1, "Upuścił na ziemię ".. ESX.Math.GroupDigits(itemCount) .."$ " .. string.lower(account.label) .. "", _source)
			end

		end

	elseif type == 'item_weapon' then

		local xPlayer = ESX.GetPlayerFromId(source)
		local loadout = xPlayer.getLoadout()

		for i=1, #loadout, 1 do
			if loadout[i].name == itemName then
				itemCount = loadout[i].ammo
				break
			end
		end

		if xPlayer.hasWeapon(itemName) then
			local weaponLabel, weaponPickup = ESX.GetWeaponLabel(itemName), 'PICKUP_' .. string.upper(itemName)

			xPlayer.removeWeapon(itemName)

			if itemCount > 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('threw_weapon_ammo', weaponLabel, itemCount))
				TriggerClientEvent("animacjawyrzuc", _source)
				TriggerClientEvent('3dme:triggerDisplay', -1, "Upuścił na ziemię [".. itemCount.."] " .. weaponLabel .. "", _source)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('threw_weapon', weaponLabel))
				TriggerClientEvent("animacjawyrzuc", _source)
				TriggerClientEvent('3dme:triggerDisplay', -1, "Upuścił na ziemię [".. itemCount.."] " .. weaponLabel .. "", _source)
			end
		end

	end

end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count   = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('act_imp'))
	end
end)

RegisterServerEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(id)
	local _source = source
	local pickup  = ESX.Pickups[id]
	local xPlayer = ESX.GetPlayerFromId(_source)

	if pickup.type == 'item_standard' then

		local item      = xPlayer.getInventoryItem(pickup.name)
		local canTake   = ((item.limit == -1) and (pickup.count)) or ((item.limit - item.count > 0) and (item.limit - item.count)) or 0
		local total     = pickup.count < canTake and pickup.count or canTake
		local remaining = pickup.count - total

		TriggerClientEvent('esx:removePickup', -1, id)

		if total > 0 then
			xPlayer.addInventoryItem(pickup.name, total)
		end

		if remaining > 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('cannot_pickup_room', item.label))

			local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(item.label, remaining)
			ESX.CreatePickup('item_standard', pickup.name, remaining, pickupLabel, _source)
		end

	elseif pickup.type == 'item_money' then
		TriggerClientEvent('esx:removePickup', -1, id)
		xPlayer.addMoney(pickup.count)
	elseif pickup.type == 'item_account' then
		TriggerClientEvent('esx:removePickup', -1, id)
		xPlayer.addAccountMoney(pickup.name, pickup.count)
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		job2         = xPlayer.getJob2(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		job2         = xPlayer.getJob2(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

RegisterServerEvent('esx:sandyammo')
AddEventHandler('esx:sandyammo', function(target, item, quantity)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(owner)
	print(target)

	TriggerClientEvent('esx:sandyammokurwa', target, item, quantity)
	TriggerClientEvent('esx:showNotification', target, 'Dostales '..quantity..' ammo')

end)

TriggerEvent("es:addGroup", "jobmaster", "user", function(group) end)

ESX.StartDBSync()
ESX.StartPayCheck()
