local GUI = {}
ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local animations = {
	{ dictionary = "creatures@rottweiler@amb@sleep_in_kennel@", animation = "sleep_in_kennel", name = "Spanie", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_barking@idle_a", animation = "idle_a", name = "Szczekanie", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@base", animation = "base", name = "Siedzenie", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@idle_a", animation = "idle_a", name = "Drapanie się", },
	{ dictionary = "creatures@rottweiler@indication@", animation = "indicate_high", name = "Przyciągnij uwagę", },
	{ dictionary = "creatures@rottweiler@melee@", animation = "dog_takedown_from_back", name = "Atak", },
	{ dictionary = "creatures@rottweiler@melee@streamed_taunts@", animation = "taunt_02", name = "Rzucanie się", },
	{ dictionary = "creatures@rottweiler@swim@", animation = "swim", name = "Pływanie", },
}

local dogModels = {
	"a_c_shepherd", "a_c_rottweiler", "a_c_husky", "a_c_chop", "a_c_retriever"
}

local emotePlaying = false

function isDog()
	local playerModel = GetEntityModel(GetPlayerPed(-1))
	for i=1, #dogModels, 1 do
		if GetHashKey(dogModels[i]) == playerModel then
			return true
		end
	end
	return false
end

function cancelEmote()
	ClearPedTasksImmediately(GetPlayerPed(-1))
	emotePlaying = false
end

function playAnimation(dictionary, animation)
	if emotePlaying then
		cancelEmote()
	end
	RequestAnimDict(dictionary)
	while not HasAnimDictLoaded(dictionary) do
		Wait(1)
	end
	TaskPlayAnim(GetPlayerPed(-1), dictionary, animation, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	emotePlaying = true
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsControlJustReleased(0, 11) and isDog() and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'dogmenu_actions') and (GetGameTimer() - GUI.Time) > 1000 then
			OpenDogEmotesMenu()
			GUI.Time = GetGameTimer()
		end		
		if emotePlaying then
            if (IsControlPressed(0, 252)) then
                cancelEmote()
            end
        end
	end
end)

function OpenDogEmotesMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ dictionary = "creatures@rottweiler@amb@sleep_in_kennel@", animation = "sleep_in_kennel", label = "Spanie", },
		{ dictionary = "creatures@rottweiler@amb@world_dog_barking@idle_a", animation = "idle_a", label = "Szczekanie", },
		{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@base", animation = "base", label = "Siedzenie", },
		{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@idle_a", animation = "idle_a", label = "Drapanie się", },
		{ dictionary = "creatures@rottweiler@indication@", animation = "indicate_high", label = "Przyciągnij uwagę", },
		{ dictionary = "creatures@rottweiler@melee@", animation = "dog_takedown_from_back", label = "Atak", },
		{ dictionary = "creatures@rottweiler@melee@streamed_taunts@", animation = "taunt_02", label = "Rzucanie się", },
		{ dictionary = "creatures@rottweiler@swim@", animation = "swim", label = "Pływanie", },
		}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dogmenu_actions',
	{
		title    = 'Menu Animacji (Pies)',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		playAnimation(data.current.dictionary, data.current.animation)
	end, function(data, menu)
		menu.close()
	end)
end