local GUI = {}
ESX = nil
GUI.Time = 0
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local collecting = false
local PodczasSluzby = false
local Zatrudniony = false
local BlipCelu = nil
local BlipZakonczenia = nil
local BlipAnulowania = nil
local PozycjaCelu = nil
local MaPaczke = false
local ObokVana = false
local OstatniCel = 0
local LiczbaDostaw = 0
local Rozwieziono = false
local xxx = nil
local yyy = nil
local zzz = nil
local Blipy = {}
local DostarczaPaczke = false
local posiadaVana = false
local block = false
local cooldown = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'vineyard' then 
			pCoords = GetEntityCoords(PlayerPedId())
            if not cooldown then
    			if(GetDistanceBetweenCoords(pCoords, Config.collectgrapes.x, Config.collectgrapes.y, Config.collectgrapes.z, true) < 50) then
    				DrawMarker(1, Config.collectgrapes.x, Config.collectgrapes.y, Config.collectgrapes.z-3.50, 0, 0, 0, 0, 0, 0, 15.0, 15.0, 4.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
    				if(GetDistanceBetweenCoords(pCoords, Config.collectgrapes.x, Config.collectgrapes.y, Config.collectgrapes.z, true) < 10) then
    					if not collecting then
    						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby zbierac winogron')
    						if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 20000 then
    							GUI.Time = GetGameTimer()
    							if IsPedInAnyVehicle(PlayerPedId(), true) then
    								HelpText("Nie mozesz zbierac winogron z samochodu")
    							else
    		                        TriggerServerEvent("sandy_vineyard:collectgrapes")
    							end
    						end
    					end
    				end
    			end
            end
			if(GetDistanceBetweenCoords(pCoords, Config.delivergrapes.x, Config.delivergrapes.y, Config.delivergrapes.z, true) < 20) then
				DrawMarker(1, Config.delivergrapes.x, Config.delivergrapes.y, Config.delivergrapes.z-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
				if(GetDistanceBetweenCoords(pCoords, Config.delivergrapes.x, Config.delivergrapes.y, Config.delivergrapes.z, true) < 3) then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby oddac winogron')
					if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 20000 then
						GUI.Time = GetGameTimer()
						if IsPedInAnyVehicle(PlayerPedId(), true) then
							HelpText("Nie mozesz oddawac winogron z samochodu")
						else
	                        TriggerServerEvent("sandyrp:savexpwiniarz")
						end
					end
				end
			end
            if (GetDistanceBetweenCoords(pCoords, Config.Strefy.Pojazd.Pos.x, Config.Strefy.Pojazd.Pos.y, Config.Strefy.Pojazd.Pos.z, true) < 10) then
                DrawMarker(1, -1921.99, 2053.76, 140.13-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
                if (GetDistanceBetweenCoords(pCoords, Config.Strefy.Pojazd.Pos.x, Config.Strefy.Pojazd.Pos.y, Config.Strefy.Pojazd.Pos.z, true) < 2) then
                    ESX.ShowHelpNotification('Nacisnij ~INPUT_CONTEXT~ aby wybrac pojazd VAN')
                    if (GetDistanceBetweenCoords(pCoords, Config.Strefy.Pojazd.Pos.x, Config.Strefy.Pojazd.Pos.y, Config.Strefy.Pojazd.Pos.z, true) < 3) then
                        if IsControlPressed(0, 54) and (GetGameTimer() - GUI.Time) > 20000 then
                            GUI.Time = GetGameTimer()
                            WyciagnijPojazd()
                        end
                    end
                end
            end
		end
	end
end)

Citizen.CreateThread(function()
    while block do
        Citizen.Wait(1)
        DisableControlAction(0, 73, true)               -- x
        DisableControlAction(0, 105, true)              -- x
        DisableControlAction(0, 120, true)              -- x
        DisableControlAction(0, 154, true)              -- x
        DisableControlAction(0, 186, true)              -- x
        DisableControlAction(0, 252, true)              -- x
        DisableControlAction(0, 323, true)              -- x
        DisableControlAction(0, 337, true)              -- x
        DisableControlAction(0, 354, true)              -- x
        DisableControlAction(0, 357, true)              -- x
        DisableControlAction(0, 20, true)               -- z
        DisableControlAction(0, 48, true)               -- z
        DisableControlAction(0, 32, true)               -- w
        DisableControlAction(0, 33, true)               -- s
        DisableControlAction(0, 34, true)               -- a
        DisableControlAction(0, 35, true)               -- d
    end
end)

RegisterNetEvent('sandy_vineyard:freezeplayer')
AddEventHandler('sandy_vineyard:freezeplayer', function(takczychujwie)
    local ped = PlayerPedId()
    if takczychujwie == false then
        collecting = false
        --FreezeEntityPosition(ped, false)
        block = false
    elseif takczychujwie == true then
        collecting = true
        --FreezeEntityPosition(ped, true)
        block = true
    end
end)

Citizen.CreateThread(function()
	while true do
    Wait(10)
	    local coords      = GetEntityCoords(GetPlayerPed(-1))
	    local isInMarker  = false
	    local currentZone = nil

	    if(GetDistanceBetweenCoords(coords, Config.collectgrapes.x, Config.collectgrapes.y, Config.collectgrapes.z, true) < 10) then
	    	isInMarker  = true
	    end

	    if isInMarker and not HasAlreadyEnteredMarker then
	      HasAlreadyEnteredMarker = true
	    end
	    if not isInMarker and HasAlreadyEnteredMarker then
    	   HasAlreadyEnteredMarker = false
    		ESX.UI.Menu.CloseAll()
    		TriggerServerEvent('sandy_vineyard:stopgather')
            cooldown = true
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if PlayerData.job ~= nil and PlayerData.job.name == 'vineyard' then
            if cooldown then
                block = false
                ESX.ShowNotification('Poczekaj 5 sekund przed ponownym zbieraniem')
                Wait (5000)
                cooldown = false
            end
        end
    end
end)

RegisterNetEvent('sandy_vineyard:zaduzo')
AddEventHandler('sandy_vineyard:zaduzo', function()
    HelpText("Posiadasz maksymalną ilosc winogron")
end)

RegisterNetEvent('sandy_vineyard:zamalo')
AddEventHandler('sandy_vineyard:zamalo', function()
    HelpText("Nie masz wystarczajaco winogron")  
end)

function HelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

-- PART 2

function AddVehicleKeys(vehicle)
    local localVehPlateTest = GetVehicleNumberPlateText(vehicle)
    if localVehPlateTest ~= nil then
        local localVehPlate = string.lower(localVehPlateTest)
        TriggerEvent("ls:newVehicle", localVehPlate, localVehId, localVehLockStatus)
        TriggerEvent("ls:notify", "Otrzymałeś kluczki swojego do pojazdu")
    end
end

function WyciagnijPojazd()
    if ESX.Game.IsSpawnPointClear(Config.Strefy.Spawn.Pos, 3) then
        if posiadaVana == true then
            ESX.ShowNotification('Wypożyczyłeś/aś już pojazd! Anuluj  lub zakończ aktualne zlecenie, aby otrzymać nowy!')
        elseif posiadaVana == false then
            local veh = "burrito3"
            ESX.Game.SpawnVehicle(veh, {
                x = -1914.68,
                y = 2042.86,
                z = 140.73
            }, 229.66, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
            local rejka = "VIN " .. GetRandomIntInRange(100,999)
            SetVehicleNumberPlateText(vehicle, rejka)
            SetVehicleDirtLevel(vehicle, 0.0000000001)
            SetVehicleUndriveable(vehicle, false)
            AddVehicleKeys(vehicle)
            end)
            PodczasSluzby = true
            LosujCel()
            DodajBlipaAnulowania()
            posiadaVana = true
        end
    else
        ESX.ShowNotification('Miejsce parkingowe jest już zajęte przez inny pojazd!')
    end
end

function LosujCel()
    local LosowyPunkt = math.random(1, 21)
    if LiczbaDostaw == 10 then
        ESX.ShowNotification('Dostarczono już wszystkie paczki! Wróć na winiarnie!')
        UsunBlipaAnulowania()
        SetBlipRoute(BlipCelu, false)
        DodajBlipaZakonczenia()
        Rozwieziono = true
				xxx = nil
				yyy = nil
				zzz = nil
    else
        if OstatniCel == LosowyPunkt then
            LosujCel()
        else
            if LosowyPunkt == 1 then
								xxx =85.003
								yyy =561.640
								zzz =182.773
                OstatniCel = 1
            elseif LosowyPunkt == 2 then
								xxx =-717.825
								yyy =448.643
								zzz =106.909
                OstatniCel = 2
            elseif LosowyPunkt == 3 then
								xxx =-588.048
								yyy =-783.517
								zzz =25.200
                OstatniCel = 3
            elseif LosowyPunkt == 4 then
								xxx =20.470
								yyy =-1505.479
								zzz =31.850
                OstatniCel = 4
            elseif LosowyPunkt == 5 then
								xxx =389.979
								yyy =-1433.028
								zzz =29.431
                OstatniCel = 5
            elseif LosowyPunkt == 6 then
								xxx =467.080
								yyy =-1590.276
								zzz =32.792
                OstatniCel = 6
            elseif LosowyPunkt == 7 then
								xxx =-339.067
								yyy =21.460
								zzz =47.858
                OstatniCel = 7
            elseif LosowyPunkt == 8 then
								xxx =-333.027
								yyy =56.902
								zzz =54.429
                OstatniCel = 8
            elseif LosowyPunkt == 9 then
								xxx =1245.260
								yyy =-1626.665
								zzz =53.282
                OstatniCel = 9
            elseif LosowyPunkt == 10 then
								xxx =1214.374
								yyy =-1644.1259
								zzz =48.6459
                OstatniCel = 10
            elseif LosowyPunkt == 11 then
								xxx =437.141
								yyy =-978.651
								zzz =30.689
                OstatniCel = 11
            elseif LosowyPunkt == 12 then
								xxx =198.235
								yyy =-1725.741
								zzz =29.663
                OstatniCel = 12
            elseif LosowyPunkt == 13 then
								xxx =-991.454
								yyy =-1103.863
								zzz =2.150
                OstatniCel = 13
            elseif LosowyPunkt == 14 then
								xxx =-298.028
								yyy =-1332.733
								zzz =31.296
                OstatniCel = 14
            elseif LosowyPunkt == 15 then
								xxx =-27.885
								yyy =-1103.904
								zzz =26.422
                OstatniCel = 15
            elseif LosowyPunkt == 16 then
								xxx =344.731
								yyy =-205.027
								zzz =58.019
                OstatniCel = 16
            elseif LosowyPunkt == 17 then
								xxx =340.956
								yyy =-214.876
								zzz =58.019
                OstatniCel = 17
            elseif LosowyPunkt == 18 then
								xxx =337.132
								yyy =-224.712
								zzz =58.019
                OstatniCel = 18
            elseif LosowyPunkt == 19 then
								xxx =331.373
								yyy =-225.865
								zzz =58.019
                OstatniCel = 19
            elseif LosowyPunkt == 20 then
								xxx =337.158
								yyy =-224.729
								zzz =54.221
                OstatniCel = 20
            elseif LosowyPunkt == 21 then
								xxx =-386.907
								yyy =504.108
								zzz =120.412
                OstatniCel = 21
            end
		    DodajBlipaDoCelu(PozycjaCelu)
		    ESX.ShowNotification('Zawieź paczkę do odbiorcy! Jedź ostrożnie i nie śpiesz się!')
        end
    end
end

function DodajBlipaDoCelu(PozycjaCelu)
    Blipy['cel'] = AddBlipForCoord(xxx, yyy, zzz)
    SetBlipRoute(Blipy['cel'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Odbiorca Paczki')
	EndTextCommandSetBlipName(Blipy['cel'])
end

-- Blip anulowania pracy
function DodajBlipaAnulowania()
    Blipy['anulowanie'] = AddBlipForCoord(-1923.49, 2048.49, 140.73)
		SetBlipColour(Blipy['anulowanie'], 59)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Anuluj Zlecenia')
	EndTextCommandSetBlipName(Blipy['anulowanie'])
end

-- Blip zakonczenia pracy
function DodajBlipaZakonczenia()
    Blipy['zakonczenie'] = AddBlipForCoord(-1924.80, 2041.51, 140.73)
		SetBlipColour(Blipy['zakonczenie'], 2)
    SetBlipRoute(Blipy['zakonczenie'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Zakończ Pracę')
	EndTextCommandSetBlipName(Blipy['zakonczenie'])
end

function UsunBlipaCelu()
    RemoveBlip(Blipy['cel'])
end

function UsunBlipaAnulowania()
    RemoveBlip(Blipy['anulowanie'])
end

function UsunWszystkieBlipy()
    RemoveBlip(Blipy['cel'])
    RemoveBlip(Blipy['anulowanie'])
    RemoveBlip(Blipy['zakonczenie'])
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local Gracz = GetPlayerPed(-1)
        local Pozycja = GetEntityCoords(Gracz)
        local Dystans = GetDistanceBetweenCoords(Pozycja, xxx, yyy, zzz, true)
        if Dystans <= 40.0 and (not MaPaczke) then
            local PozycjaDostawy = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            ESX.Game.Utils.DrawText3D(PozycjaDostawy, "ZABIERZ ~y~WINO~s~ Z ~b~VANA~s~!", 0.6)
            local pojazd = GetClosestVehicle(Pozycja, 6.0, 0, 70)
            if IsVehicleModel(pojazd, GetHashKey('burrito3')) then
                local pozycjaPojazdu = GetEntityCoords(pojazd)
								local Odleglosc = GetDistanceBetweenCoords(Pozycja, pozycjaPojazdu, true)
                ESX.Game.Utils.DrawText3D(pozycjaPojazdu, "NACIŚNIJ [~g~E~s~] ABY WYCIĄGNĄĆ ~y~WINO", 1.0, 5.0, "~b~VAN", 1.15)
								if Dystans >= 4 and Odleglosc <= 5 then
                	                ObokVana = true
								end
            end
        elseif Dystans <= 25 and MaPaczke then
            local PozycjaDostawy = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            ESX.Game.Utils.DrawText3D(PozycjaDostawy, "NACIŚNIJ [~g~E~s~] ABY DOSTARCZYĆ ~y~WINO", 0.55, 1.5, "~b~DOSTAWA", 0.7)
            if Dystans <= 3 then
                if IsControlJustReleased(0, 38) then
                    WezPaczke()
                    DostarczPaczke()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if (not MaPaczke) and ObokVana then
            if IsControlJustReleased(0, 38) then
                Citizen.Wait(100)
                WezPaczke()
                ObokVana = false
			end
		end
	end
end)

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function WezPaczke()
    local player = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'hei_prop_heist_box'
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
            loadAnimDict( ad )
            if MaPaczke then
                TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0 )
                DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                Wait(1000)
                ClearPedSecondaryTask(PlayerPedId())
                MaPaczke = false
            else
                local x,y,z = table.unpack(GetEntityCoords(player))
                prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                TaskPlayAnim( player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                MaPaczke = true
            end
        end
    end
end

function DostarczPaczke()
    if not DostarczaPaczke then
        DostarczaPaczke = true
        LiczbaDostaw = LiczbaDostaw + 1
        UsunBlipaCelu()
        SetBlipRoute(BlipCelu, false)
        MaPaczke = false    
        KolejnaDostawa()
        Citizen.Wait(2500)
        DostarczaPaczke = false
    end
end

function KolejnaDostawa()
    Citizen.Wait(300)
    LosujCel()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local Gracz = GetPlayerPed(-1)
        local Pozycja = GetEntityCoords(Gracz)
        local DystansOdStrefyZakonczenia = GetDistanceBetweenCoords(Pozycja, -1924.80, 2041.51, 140.73, true)
        local DystansOdStrefyAnulowania = GetDistanceBetweenCoords(Pozycja, -1923.49, 2048.49, 140.73, true)
        if PodczasSluzby then
            if Rozwieziono then
                if DystansOdStrefyZakonczenia <= 5 then
					DrawMarker(1, -1924.80, 2041.51, 140.13-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
					if DystansOdStrefyZakonczenia <= 1 then
					HelpText("Nacisnij ~INPUT_CONTEXT~ aby zakonczyc prace")
					end
                    if DystansOdStrefyZakonczenia <= 2 then
                        if IsControlJustReleased(0, 38) then
                            ESX.ShowNotification('Zakończono pracę! Odpocznij chwilę, kolejne przesyłki już czekają!')
                            KoniecPracy()
                        end
                    end
                end
            else
                if DystansOdStrefyAnulowania <= 5 then
					DrawMarker(1, -1923.49, 2048.49, 140.13-0.90, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 50, 155, 0, 0, 2, 0, 0, 0, 0)
					if DystansOdStrefyAnulowania <= 1 then
					HelpText("Nacisnij ~INPUT_CONTEXT~ aby anulowac prace")
					end
                    if DystansOdStrefyAnulowania <= 2 then
                        if IsControlJustReleased(0, 38) then
                            ESX.ShowNotification('Anulowano zlecenie!')
							KoniecPracy()
                        end
                    end
                end
            end
        end
    end
end)

function KoniecPracy()
    UsunWszystkieBlipy()
    local Gracz = GetPlayerPed(-1)
    if IsPedInAnyVehicle(Gracz, false) then
        local Van = GetVehiclePedIsIn(Gracz, false)
        if IsVehicleModel(Van, GetHashKey('burrito3')) then
            ESX.Game.DeleteVehicle(Van)
            if Rozwieziono == true then
                TriggerServerEvent("sandyrp:savexpwiniarz2", 'zakonczenie')
            end
            PodczasSluzby = false
            BlipCelu = nil
            BlipZakonczenia = nil
            BlipAnulowania = nil
            PozycjaCelu = nil
            MaPaczke = false
            OstatniCel = nil
            LiczbaDostaw = 0
            xxx = nil
            yyy = nil
            zzz = nil
            posiadaVana = false
            Rozwieziono = false
        else
            ESX.ShowNotification('Musisz zwrócić pojazd!')
            ESX.ShowNotification('Jeśli straciłeś Vana, wyjdź z pojazdu i anuluj pracę pieszo!')
        end
    else
        ESX.ShowNotification('Kaucja nie została zwrócona!')
        PodczasSluzby = false
        BlipCelu = nil
        BlipZakonczenia = nil
        BlipAnulowania = nil
        PozycjaCelu = nil
        MaPaczke = false
        OstatniCel = nil
        LiczbaDostaw = 0
        xxx = nil
        yyy = nil
        zzz = nil
        posiadaVana = false
        Rozwieziono = false
    end
end
