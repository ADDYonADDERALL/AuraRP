ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}
	local fractionAccount = 0
    local moneyLoaded = false

	ESX.TriggerServerCallback('esx_societymordo:getSocietyMoney', function(money)
		fractionAccount = money
		moneyLoaded = true
	end, ESX.PlayerData.job.name)

	while not moneyLoaded do
		Citizen.Wait(100)
	end

	ESX.TriggerServerCallback('esx_societymordo:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		showmoney = true,
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		grades    = true
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.showmoney then
        table.insert(elements, {label = 'Stan konta frakcji: <span style="color:green;">$'..fractionAccount , value = 'none'})
    end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_societymordo:withdrawMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_societymordo:depositMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenManageEmployeesMenu(society)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	if society == 'police' or society == 'ambulance' or society == 'mecano' then
		table.insert(elements, {label = _U('employee_list'), value = 'employee_list'})
		table.insert(elements, {label = 'Lista pracowników (poza służba)', value = 'employee_listoff'})
		table.insert(elements, {label = _U('recruit'), value = 'recruit'})
	else
		table.insert(elements, {label = _U('employee_list'), value = 'employee_list'})
		table.insert(elements, {label = _U('recruit'), value = 'recruit'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'employee_listoff' then
			OpenEmployeeList('off'..society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList(society)

	ESX.TriggerServerCallback('esx_societymordo:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_societymordo:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(society)
		end)

	end, society)

end

function OpenRecruitMenu(society)
	local pid, cId, sId = PlayerId(), ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), false), 15.0), {}
	for _, player in ipairs(cId) do
	  if player ~= pid then
		table.insert(sId, GetPlayerServerId(player))
	  end
	end
  
	if #sId > 0 then
	  ESX.TriggerServerCallback('esx_societymordo:getPlayersInArea', function(players)
		  local elements = {}
		  for _, player in pairs(players) do
			if player.job.name ~= society then
			  table.insert(elements, {label = "ID: " .. player.source, value = player.source, name = player.name, identifier = player.identifier})
			end
		  end
  
		  if #elements > 0 then
			  ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'recruit_' .. society,
				{
				  title    = _U('recruiting'),
				  align    = 'center',
				  elements = elements
				},
				function(data, menu)
				  ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'recruit_confirm_' .. society,
					{
					  title    = _U('do_you_want_to_recruit', 'ID: ' .. data.current.value),
					  align    = 'center',
					  elements = {
						{label = _U('yes'), value = 'yes'},
						{label = _U('no'),  value = 'no'}
					  }
					},
					function(data2, menu2)
					  menu2.close()
					  if data2.current.value == 'yes' then
						local job = society
						if job == 'police' or job == 'ambulance' or job == 'mecano' then
						  job = 'off' .. job
						end
  
						TriggerEvent('esx:showNotification', _U('you_have_hired', 'ID: ' .. data.current.value))
						ESX.TriggerServerCallback('esx_societymordo:setJob', function()
							OpenRecruitMenu(society)
						end, data.current.identifier, society, 0, 'hire')
					  end
					end,
					function(data2, menu2)
					  menu2.close()
					end
				  )
				end,
				function(data, menu)
				  menu.close()
				end
			  )
		  else
			  ESX.ShowNotification('~r~Brak obywateli w pobliżu')
		  end
	  end, sId)
	else
	  ESX.ShowNotification('~r~Brak obywateli w pobliżu')
	end
  end

function OpenPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esx_societymordo:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_societymordo:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

AddEventHandler('esx_societymordo:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

--- CRIME


function OpenBossMenuCRIME(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}
	local fractionAccount = 0
    local moneyLoaded = false

	ESX.TriggerServerCallback('esx_societycrime:getSocietyMoney', function(money)
		fractionAccount = money
		moneyLoaded = true
	end, ESX.PlayerData.job2.name)

	while not moneyLoaded do
		Citizen.Wait(100)
	end

	ESX.TriggerServerCallback('esx_societycrime:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(100)
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		showmoney = true,
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		grades    = true
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.showmoney then
        table.insert(elements, {label = 'Stan konta frakcji: <span style="color:green;">$'..fractionAccount , value = 'none'})
    end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_societycrime:withdrawMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_societycrime:depositMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenuCRIME(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenManageEmployeesMenuCRIME(society)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	table.insert(elements, {label = _U('employee_list'), value = 'employee_list'})
	table.insert(elements, {label = _U('recruit'), value = 'recruit'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeListCRIME(society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenuCRIME(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeListCRIME(society)

	ESX.TriggerServerCallback('esx_societycrime:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job2.grade_label == '' and employees[i].job2.label or employees[i].job2.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenuCRIME(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_societycrime:setJob', function()
					OpenEmployeeListCRIME(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenuCRIME(society)
		end)

	end, society)

end

function OpenRecruitMenuCRIME(society)
	local pid, cId, sId = PlayerId(), ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), false), 15.0), {}
	for _, player in ipairs(cId) do
	  if player ~= pid then
		table.insert(sId, GetPlayerServerId(player))
	  end
	end
  
	if #sId > 0 then
	  ESX.TriggerServerCallback('esx_societycrime:getPlayersInArea', function(players)
		  local elements = {}
		  for _, player in pairs(players) do
			if player.job2.name ~= society then
			  table.insert(elements, {label = "ID: " .. player.source, value = player.source, name = player.name, identifier = player.identifier})
			end
		  end
  
		  if #elements > 0 then
			  ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'recruit_' .. society,
				{
				  title    = _U('recruiting'),
				  align    = 'center',
				  elements = elements
				},
				function(data, menu)
				  ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'recruit_confirm_' .. society,
					{
					  title    = _U('do_you_want_to_recruit', 'ID: ' .. data.current.value),
					  align    = 'center',
					  elements = {
						{label = _U('yes'), value = 'yes'},
						{label = _U('no'),  value = 'no'}
					  }
					},
					function(data2, menu2)
					  menu2.close()
					  if data2.current.value == 'yes' then
						local job = society
						if job == 'police' or job == 'ambulance' or job == 'mecano' then
						  job = 'off' .. job
						end
  
						TriggerEvent('esx:showNotification', _U('you_have_hired', 'ID: ' .. data.current.value))
						ESX.TriggerServerCallback('esx_societycrime:setJob', function()
							OpenRecruitMenuCRIME(society)
						end, data.current.identifier, society, 0, 'hire')
					  end
					end,
					function(data2, menu2)
					  menu2.close()
					end
				  )
				end,
				function(data, menu)
				  menu.close()
				end
			  )
		  else
			  ESX.ShowNotification('~r~Brak obywateli w pobliżu')
		  end
	  end, sId)
	else
	  ESX.ShowNotification('~r~Brak obywateli w pobliżu')
	end
  end

function OpenPromoteMenuCRIME(society, employee)

	ESX.TriggerServerCallback('esx_societycrime:getJob', function(job2)

		local elements = {}

		for i=1, #job2.grades, 1 do
			local gradeLabel = (job2.grades[i].label == '' and job2.label or job2.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job2.grades[i].grade,
				selected = (employee.job2.grade == job2.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_societycrime:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeListCRIME(society)
		end)

	end, society)

end

AddEventHandler('esx_societycrime:openBossMenu', function(society, close, options)
	OpenBossMenuCRIME(society, close, options)
end)

