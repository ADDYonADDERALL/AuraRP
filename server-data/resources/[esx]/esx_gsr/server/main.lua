ESX = nil
gsrData = {}

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

AddEventHandler('esx:playerDropped', function(source)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterNetEvent("esx_gsr:Check")
AddEventHandler("esx_gsr:Check", function(player)
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(Source)
    local identifier = GetPlayerIdentifiers(player)[1]
    if identifier ~= nil and xPlayer.job.name == 'police' then
        gsrcheck(source, identifier)
    end
end)

RegisterNetEvent("GSR:Remove")
AddEventHandler("GSR:Remove", function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterServerEvent('GSR:SetGSR')
AddEventHandler('GSR:SetGSR', function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    gsrData[identifier] = os.time(os.date("!*t")) + Config.gsrTime
end)

function gsrcheck(source, identifier)
    local Source = source
    local identifier = identifier
    if gsrData[identifier] ~= nil then
        TriggerClientEvent('esx:showNotification', Source, 'Test Pozytywny')
    else
        TriggerClientEvent('esx:showNotification', Source, 'Test Negatywny')
    end
end

ESX.RegisterServerCallback('GSR:Status', function(source, cb)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

function removeGSR()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

function gsrTimer()
    removeGSR()
    SetTimeout(Config.gsrAutoRemove, gsrTimer)
end

gsrTimer()
