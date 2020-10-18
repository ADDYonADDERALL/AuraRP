--ESX INIT--
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--SERVER EVENT--

ESX.RegisterUsableItem('lornetka', function(source) -- Consider the item as usable
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('jumelles:Active', source) --Trigger the event when the player is using the item
end)

RegisterServerEvent('CarryPeople:sync')
AddEventHandler('CarryPeople:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('CarryPeople:sync2')
AddEventHandler('CarryPeople:sync2', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget2', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe2', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('CarryPeople:stop')
AddEventHandler('CarryPeople:stop', function(targetSrc)
	TriggerClientEvent('CarryPeople:cl_stop', targetSrc)
end)

RegisterServerEvent('CarryPeople:request')
AddEventHandler('CarryPeople:request', function(target,animation)
	local _source = source
	TriggerClientEvent('CarryPeople:request', target, animation, _source, target)
end)

RegisterServerEvent('CarryPeople:accept')
AddEventHandler('CarryPeople:accept', function(target,animation)
	local _source = source
	print(animation)
	TriggerClientEvent(animation, target, _source)
end)

RegisterServerEvent('CarryPeople:deny')
AddEventHandler('CarryPeople:deny', function(target)
	local _source = source
	TriggerClientEvent('esx:showNotification', target, '~r~Odrzucil twoja prosbe!')
end)