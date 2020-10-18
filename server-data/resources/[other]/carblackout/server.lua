RegisterNetEvent('sandy_dzwon:dzwon')
AddEventHandler('sandy_dzwon:dzwon', function(dupa, cipa)
	local sors
	for k, v in pairs(dupa) do
        sors = v
        TriggerClientEvent('sandy_dzwon:dzwon', sors, cipa)
    end
end)

RegisterNetEvent('sandy_dzwon:dzwon2')
AddEventHandler('sandy_dzwon:dzwon2', function(damage)
    TriggerClientEvent('sandy_dzwon:dzwon', source, damage)
end)