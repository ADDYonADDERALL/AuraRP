# cryptos_stretcher_bed
Stretcher and Hospital Bed lay/push based off qalle-wheelchair

I didn't plan on releasing this but because of some toxic people I am forced to open source this before it hits the script black market or ends up with the wrong credits.
___

# Installation - Framework free
1. Clone this repository.
2. Extract the zip.
3. Change cryptos_stretcher_bed-master to cryptos_stretcher_bed
3. Put cryptos_stretcher_bed to your resource folder.
4. Add "start cryptos_stretcher_bed" in your "server.cfg".
5. Profit

# Installation - esx_ambulancejob version
1. Clone this repository.
2. Extract the zip.
3. move cryptos_stretcher.lua to esx_ambulancejob/client
4. open the esx_ambulancejob "__resource.lua"
5. Add 'client/cryptos_stretcher.lua'
6. client_scirpts should look something like this
```
client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	'client/job.lua',
	'client/cryptos_stretcher.lua'
}
```
7. Find 
```
if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'top-left',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'}
				}
			}, function(data, menu)
				if IsBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.0 then
					ESX.ShowNotification(_U('no_players'))
				else

					if data.current.value == 'revive' then
```
8. Add 
```{label = _U('place_objects'), value = 'object_spawner'}```
and ```if data.current.value == 'object_spawner' then``` to look like this
```
if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'top-left',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'},
					{label = _U('place_objects'), value = 'object_spawner'}
				}
			}, function(data, menu)
				if IsBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.0 then
					if data.current.value == 'object_spawner' then
   
					   local playerPed = PlayerPedId()
				   
					   if IsPedSittingInAnyVehicle(playerPed) then
						   ESX.ShowNotification(_U('inside_vehicle'))
						   return
					   end
				   
					   ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions_spawn', {
						   title    = 'Spawner',
						   align    = 'top-left',
						   elements = {
							   {label = 'Hospital Bed', value = 'v_med_emptybed'},
							   {label = 'Stretcher',  value = 'prop_ld_binbag_01'}
						   }
					   }, function(data2, menu2)
						   local model   = data2.current.value
						   local coords  = GetEntityCoords(playerPed)
						   local forward = GetEntityForwardVector(playerPed)
						   local x, y, z = table.unpack(coords + forward * 1.0)
				   
						   if model == 'v_med_emptybed' then
							   z = z - 2.0
							   y = y + 1.0
						   elseif model == 'prop_ld_binbag_01' then
							   z = z - 2.0
							   y = y + 1.0
						   end
				   
						   ESX.Game.SpawnObject(model, {
							   x = x,
							   y = y,
							   z = z
						   }, function(obj)
							   SetEntityHeading(obj, GetEntityHeading(playerPed))
							   PlaceObjectOnGroundProperly(obj)
						   end)
				   
					   end, function(data2, menu2)
						   menu2.close()
					   end)
					else
						ESX.ShowNotification(_U('no_players'))
					end
				else

					if data.current.value == 'revive' then
```
9. Profit

# Required resource
- esx_ambulancejob (optional)
- stretcher used: https://www.lcpdfr.com/files/file/18046-body-bags/

# Made by
- CryptoGenics
- Based off qalle-wheelchair https://github.com/qalle-fivem/qalle-wheelchair
