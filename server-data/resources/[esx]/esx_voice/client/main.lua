local voice = {
	whisper = 3.0,
	default = 20.0,
	shout = 50.0,

	current = 2,
	instance = nil,
	channel = nil,

	mute = false,
	isDead = false,

	display = true
}

local showrange = false
local timer = 60

local function DrawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function setVoice(keep)
	if voice.mute then
		NetworkSetTalkerProximity(0.1)
		return -1
	end

	if not keep then
		voice.current = (voice.current + 1) % 3
	end

	if voice.current == 0 then
		NetworkSetTalkerProximity(voice.whisper)
		TriggerEvent("esx_customui:talking", voice.current)
	elseif voice.current == 1 then
		NetworkSetTalkerProximity(voice.default)
		TriggerEvent("esx_customui:talking", voice.current)
	elseif voice.current == 2 then
		if voice.isDead then
			return setVoice(false)
		end
		NetworkSetTalkerProximity(voice.shout)
		TriggerEvent("esx_customui:talking", voice.current)
	end

	if not voice.channel then
		Citizen.InvokeNative(0xE036A705F989E049)
	elseif voice.channel ~= oldChannel then
		NetworkSetVoiceChannel(voice.channel)
	end

	return voice.current
end

function getVoice()
	return voice.current
end

AddEventHandler('esx_voice:setCall', function(target, channel)
	-- ignore, using RTC
end)

AddEventHandler('esx_voice:setMute', function(status)
	voice.mute = status
	setVoice(true)
end)

AddEventHandler('esx_voice:facial', function(facial)
	-- not supported
end)

AddEventHandler('playerSpawned', function()
	voice.isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	voice.isDead = true
	setVoice(true)
end)

AddEventHandler('esx_status:setDisplay', function(val)
	voice.display = tonumber(val) ~= 0
end)

local toggle = false

Citizen.CreateThread(function()
	NetworkSetTalkerProximity(0.1)
	Citizen.Wait(1000)
	setVoice(true)
	while true do
		Citizen.Wait(1)

		if IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166) then
			setVoice(false)
			showrange = true
			timer = 60
		end
		if NetworkIsPlayerTalking(PlayerId()) and not toggle then
			TriggerEvent("esx_customui:istalking", true)
			toggle = true
		elseif not NetworkIsPlayerTalking(PlayerId()) and toggle then
			TriggerEvent("esx_customui:istalking", false)
			toggle = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		while showrange do
			Citizen.Wait(1)
			timer = timer - 1
			local coords = GetEntityCoords(PlayerPedId())
			local size = NetworkGetTalkerProximity()
			DrawMarker(1, coords.x, coords.y, coords.z - 1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, size, size, 1.0, 200,50,100,255, false, true, 2, false, false, false, false)
			if timer == 0 then
				showrange = false
				timer = 60
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not HasAnimDictLoaded("facials@gen_male@base") do
		RequestAnimDict("facials@gen_male@base")
		Citizen.Wait(0)
	end

	while not HasAnimDictLoaded("facials@gen_female@base") do
		RequestAnimDict("facials@gen_female@base")
		Citizen.Wait(0)
	end

	while not HasAnimDictLoaded("mp_facial") do
		RequestAnimDict("mp_facial")
		Citizen.Wait(0)
	end

	local talkingPlayers = {}
	while true do
		Citizen.Wait(200)
		for _, player in ipairs(GetActivePlayers()) do
			if player ~= PlayerId() then
				local boolTalking = NetworkIsPlayerTalking(player)
				if boolTalking then
					PlayFacialAnim(GetPlayerPed(player), "mic_chatter", "mp_facial")
					talkingPlayers[player] = true
				elseif not boolTalking and talkingPlayers[player] then
					local ped, dict = GetPlayerPed(player), "facials@gen_female@base"
					if IsPedMale(ped) then
						dict = "facials@gen_male@base"
					end

					PlayFacialAnim(ped, "mood_normal_1", dict)
					talkingPlayers[player] = nil
				end
			end
		end
	end
end)

function SetInstance(host)
	voice.instance = host
	setVoice(true)
end

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	SetInstance(instance.host)
end)

RegisterNetEvent('instance:onRehost')
AddEventHandler('instance:onRehost', function(instance)
	SetInstance(instance.host)
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(instance)
	SetInstance(nil)
end)

RegisterNetEvent('instance:onClose')
AddEventHandler('instance:onClose', function(instance)
	SetInstance(nil)
end)