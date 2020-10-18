ESX = nil
local hasShot = false
local ignoreShooting = false
local Ped = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        Ped = exports['AuraRP']:GetPedData()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Ped.Active then
            if IsPedShooting(Ped.Id) then
                local currentWeapon = GetSelectedPedWeapon(Ped.Id)
                for _,k in pairs(Config.weaponChecklist) do
                    if currentWeapon == k then
                        ignoreShooting = true
                        break
                    end
                end
                
                if not ignoreShooting then
                    TriggerServerEvent('GSR:SetGSR', timer)
                    hasShot = true
                    ignoreShooting = false
                    Citizen.Wait(Config.gsrUpdate)
                end
    			ignoreShooting = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        if hasShot then
            if Ped.Active then
    			Wait(600000)
                TriggerServerEvent('GSR:Remove')
            end
        end
    end
end)

function status()
    if hasShot then
        ESX.TriggerServerCallback('GSR:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
end

function updateStatus()
    status()
    SetTimeout(Config.gsrUpdateStatus, updateStatus)
end

updateStatus()
