local a={}

RegisterNetEvent('dowod:loadLicenses')
AddEventHandler('dowod:loadLicenses',function(b)
	a={}
	for c=1,#b,1 do 
		a[b[c].type]=true 
	end 
end)

RegisterNetEvent('dowod:DisplayId')
AddEventHandler('dowod:DisplayId',function(d,e,f,g,h,i,j)
	local k=PlayerId()
	local l=GetPlayerFromServerId(d)
	if l==k then 
		TriggerEvent("pNotify:SendNotification",{text="<font style='font-size: 13px'><div style='min-width: 403px; min-height: 200px; background-image: url(https://i.imgur.com/CfThsJI.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: absolute; top: 87px; left: 85px; color:#094a7d; text-shadow: 1px 1px 2px rgba(0,0,0,0.2);font-family: courier;font-size: 13px'><table><tr><td align='right'><B><font style='font-size: 13px;color:#0d0d0d;'>Imie:<BR>Nazwisko:<BR>Zawód:<BR><BR>Prawo jazdy:<BR>Ubezpieczenie:<BR>Pozwolenie na bron:</td><td><B><font style='font-size: 13px;color:#4C4C4C;'>"..e.."<BR>"..f.."<BR>"..i.."<BR><BR>"..g.."<BR>"..j.."<BR>"..h.."</td></tr></table>  </div>",type="mint",queue="global",timeout=10000,layout="centerLeft"})
		chowajbron()
		animacja()
		prop()
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(k)),GetEntityCoords(GetPlayerPed(l)),true)<3.9999 then 
		TriggerEvent("pNotify:SendNotification",{text="<font style='font-size: 13px'><div style='min-width: 403px; min-height: 200px; background-image: url(https://i.imgur.com/CfThsJI.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: absolute; top: 87px; left: 85px; color:#094a7d; text-shadow: 1px 1px 2px rgba(0,0,0,0.2);font-family: courier;font-size: 13px'><table><tr><td align='right'><B><font style='font-size: 13px;color:#0d0d0d;'>Imie:<BR>Nazwisko:<BR><BR>Prawo jazdy:<BR>Ubezpieczenie:<BR>Pozwolenie na bron:</td><td><B><font style='font-size: 13px;color:#4C4C4C;'>"..e.."<BR>"..f.."<BR><BR>"..g.."<BR>"..j.."<BR>"..h.."</td></tr></table>  </div>",type="mint",queue="global",timeout=10000,layout="centerLeft"})
	end 
end)

RegisterNetEvent('aurarp:wizytowka')
AddEventHandler('aurarp:wizytowka', function(id, playerName, phone_number, bankaccount)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
  TriggerEvent("pNotify:SendNotification", {
          text = "<font style='font-size: 14px'><div style='margin-left: -30px; min-width: 400px; min-height: 200px; background-image: url(https://i.imgur.com/9cO4YTo.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: absolute; top: 65px; left: 200px; color:#000000; text-shadow: 0px 0px 5px rgba(0, 0, 0, 1); font-family: 'Roboto Condensed', sans-serif;'><B>Imię:</b> <BR>" ..playerName.." <BR><BR><B>Numer Telefonu:</B> <BR>".. phone_number .. "<BR><BR><B>Numer Konta:</B> <BR>".. bankaccount .. "<BR></div>",
          type = "mint",
          queue = "global",
          timeout = 15000,
          layout = "centerLeft"
        }) 
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 3.9999 then
       TriggerEvent("pNotify:SendNotification", {
          text = "<font style='font-size: 14px'><div style='margin-left: -30px; min-width: 400px; min-height: 200px; background-image: url(https://i.imgur.com/9cO4YTo.png); background-size: contain; background-position: center;  background-repeat: no-repeat;'><div style='position: absolute; top: 65px; left: 200px; color:#000000; text-shadow: 0px 0px 5px rgba(0, 0, 0, 1); font-family: 'Roboto Condensed', sans-serif;'><B>Imię:</b> <BR>" ..playerName.." <BR><BR><B>Numer Telefonu:</B> <BR>".. phone_number .. "<BR><BR><B>Numer Konta:</B> <BR>".. bankaccount .. "<BR></div>",
          type = "mint",
          queue = "global",
          timeout = 15000,
          layout = "centerLeft"
        })
  end
end)

function chowajbron()
	if not IsPedInAnyVehicle(PlayerPedId(),false)and not IsPedCuffed(PlayerPedId())then 
		SetCurrentPedWeapon(PlayerPedId(),-1569615261,true)
		Citizen.Wait(1)
	end 
end

function animacja()
	if not IsPedInAnyVehicle(PlayerPedId(),false)and not IsPedCuffed(PlayerPedId())then 
		RequestAnimDict("random@atmrobberygen")
		while not HasAnimDictLoaded("random@atmrobberygen")do 
			Citizen.Wait(0)
		end
		TaskPlayAnim(PlayerPedId(),"random@atmrobberygen","a_atm_mugging",8.0,3.0,2000,0,1,false,false,false)
	end 
end

function prop()
	if not IsPedInAnyVehicle(PlayerPedId(),false)and not IsPedCuffed(PlayerPedId())then 
		usuwanieprop()
		portfel=CreateObject(GetHashKey('prop_ld_wallet_01'),GetEntityCoords(PlayerPedId()),true)AttachEntityToEntity(portfel,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),0x49D9),0.17,0.0,0.019,-120.0,0.0,0.0,1,0,0,0,0,1)
		Citizen.Wait(500)
		dowod=CreateObject(GetHashKey('prop_michael_sec_id'),GetEntityCoords(PlayerPedId()),true)AttachEntityToEntity(dowod,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),0xDEAD),0.150,0.045,-0.015,0.0,0.0,180.0,1,0,0,0,0,1)
		Citizen.Wait(1300)
		usuwanieportfelprop()
	end 
end

function usuwanieportfelprop()
	DeleteEntity(dowod)
	Citizen.Wait(200)
	DeleteEntity(portfel)
end
	
function usuwanieprop()
	DeleteEntity(dowod)
	DeleteEntity(portfel)
end

local opisy = {}

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov*0.6
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(3, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        sleep = true
        for _, player in ipairs(GetActivePlayers()) do
            local playerserverid = GetPlayerServerId(player)
            if opisy[playerserverid] ~= nil and tostring(opisy[playerserverid]) ~= '' then
                local playercoords =  GetEntityCoords(GetPlayerPed(player))
                distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), playercoords,  true)
                if distance < 10.0 then
                    sleep = false
                    DrawText3D(playercoords.x, playercoords.y, playercoords.z, opisy[playerserverid])
                end
            end
        end
        if sleep then
            Wait(2000)
        end
    end
end)

RegisterNetEvent('identification:opis')
AddEventHandler('identification:opis', function(player, opis)
    opisy[player] = opis
end)