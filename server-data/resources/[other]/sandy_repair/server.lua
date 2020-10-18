ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sandy_repair:naprawa1')
AddEventHandler('sandy_repair:naprawa1', function()
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local kasa = xPlayer.getMoney()
  local price = 3500
  if kasa >= price then
      xPlayer.removeMoney(price)
	  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		account.addMoney(price * 0.25)
		end)
	  TriggerClientEvent('sandy_repair:enginerepair', _source)
  else
  	TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz tyle pieniedzy!')
  end
end)

RegisterServerEvent('sandy_repair:naprawa2')
AddEventHandler('sandy_repair:naprawa2', function()
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local kasa = xPlayer.getMoney()
  local price = 5000
  if kasa >= price then
      xPlayer.removeMoney(price)
	  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		account.addMoney(price * 0.25)
		end)
	  TriggerClientEvent('sandy_repair:fullrepair', _source)
  else
  	TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz tyle pieniedzy!')
  end
end)

RegisterServerEvent('sandy_healer:baska')
AddEventHandler('sandy_healer:baska', function(yesorno, waytopay)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)
  local account = xPlayer.getMoney()
  local price = 0
  if waytopay == 'gotowka' then
    if yesorno == 'yes' then
      price = 15000
      if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('sandy_healer:healingplayer', _source)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
            account.addMoney(price/2)
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
      end
    elseif yesorno == 'nope' then
      price = 5000
      if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('sandy_healer:healingplayer', _source)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
            account.addMoney(price/2)
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
      end
    end
  elseif waytopay == 'karta' then
    if yesorno == 'yes' then
      price = 15000
      if xPlayer.getBank() >= price then
        xPlayer.removeAccountMoney('bank', price)
        TriggerClientEvent('sandy_healer:healingplayer', _source)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
            account.addMoney(price/2)
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
      end
    elseif yesorno == 'nope' then
      price = 5000
      if xPlayer.getBank() >= price then
        xPlayer.removeAccountMoney('bank', price)
        TriggerClientEvent('sandy_healer:healingplayer', _source)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
            account.addMoney(price/2)
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz '.. price ..'$ pieniędzy!')
      end
    end
  end
end)

RegisterServerEvent('sandy_healer:idkwhatever')
AddEventHandler('sandy_healer:idkwhatever', function()
  local _source = source
  TriggerClientEvent('esx_ambulancejob:revivee', _source)
end)

RegisterServerEvent('sandy_healer:idkwhatever2')
AddEventHandler('sandy_healer:idkwhatever2', function(player)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.job.name == 'veterinary' then
    TriggerClientEvent('esx_ambulancejob:revivee', player)
  else
    TriggerEvent("logsbanCheaterr", _source, "VetREVIVE")
  end
end)