RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2)
  TriggerEvent('chatMessage', "", {205, 205, 0}, "Wyslano do:^0 " .. names2 .."  ".."^0  - " .. tPID)
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
  TriggerEvent('chatMessage', "", {205, 205, 0}, "  ADMIN " .. names3 .."  ".."^0: " .. textmsg)
end)

Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/odp',  'Odpowiedz na Ticketa',  { { name = 'ID zgłoszenia', help = 'Wpisz ID gracza który wysyłał zgłoszenie.' }, { name = 'Wiadomość', help = 'Treść odpowiedzi.' } } )
  TriggerEvent('chat:addSuggestion', '/zglos',   'Wyślij zgłoszenie Administratorowi. (Bezsensowne tickety będą równały się z banem)',   { { name = 'Wiadomość', help = 'Opisz tutaj dokładnie swój problem.' } } )
end)


RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
  TriggerEvent('chatMessage', "", {255, 0, 0}, "Zgłoszono do wszystkich administratorów online!")
  TriggerServerEvent("checkadmin", name, message, id)
  elseif pid ~= myId then
    TriggerServerEvent("checkadmin", name, message, id)
  end
end)


RegisterNetEvent('sendReportToAllAdmins')
AddEventHandler('sendReportToAllAdmins', function(id, name, message, i)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " [Zgloszenie] | [".. i .."]" .. name .."  "..":^0  " .. message)
  end
end)