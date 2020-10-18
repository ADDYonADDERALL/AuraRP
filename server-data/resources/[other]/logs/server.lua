ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Config                = {}
Config.green          = 56108
Config.grey           = 8421504
Config.red            = 16711680
Config.orange         = 16744192
Config.blue           = 2061822
Config.purple         = 11750815

RegisterServerEvent("logs:checkpermissions")
AddEventHandler("logs:checkpermissions", function()
  local _source = source
    if IsPlayerAceAllowed(_source, "easyadmin.spectate") then
        TriggerClientEvent('logi:getpermissions', _source, true)
    else
        TriggerClientEvent('logi:getpermissions', _source, false)
    end
end)

function sendToDiscord (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738822308734697504/F26U9uJJ6bVnNyWy9uf3UUSANTBfwe36VduveuEFf5-OBTYRnfHfaMLv41IOz-EjWM29"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-KILL",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord2 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738823330206974155/xITuSDomIy7b4ZCqU4fsLHt9SrRA33ALJ2mfu1wDklnpweABO4GoJCWtMlV3zCtIFj_A"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-ME/DO",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord3 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738826380191727708/VioZXpF0oqEGvIrB7sLQ-fGW0D2k5vBGAoXANsyBJ0ghJjqfx4XgLfxcSofYKOgHzk8d"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-CHAT",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord4 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738829245379510293/jnoDYGySPGlxNLk2rdLq9ieDcUIaPg1ToYjpj_gwHmK0Zsm-XkFFFFEGYSXNe84zbqz1"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-ITEM",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord5 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738833172426391572/cvK4GtUuHUns979FusaTbsmFXpwfSYmt8ciTV1g8hM7KyyjlDyQT0Kjs7HgLI58z-32W"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-LOOTRP",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord6 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738834025568796752/h9vlbbnT8p2HQZMjeLWzjaSMKp5rpXO6KlESttn8lQPLQWaC3SRxCsirjtsSaZfe4xsX"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-FAKTURY",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord7 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738841662742331472/Duob3NfAfULjnyWmFOJ7yvBcd-Ir28gIXksd9-6g98Y_lRDxTojEtOzYei7sSqM3YaoF"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-ZLOM",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord8 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738841892539727942/Ch86XB_T_dxYUD7uavwEVCpN-Rv7nXweuJ6yHm69vbWzTJao2lXZyPtTjukMaYfyNC9I"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-AUTA",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord9 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738842105409175634/hFrClp1_-soXF1KQ9grl-5Gv1Ygj3AM5fzDWZBbUqDmF9UhZqFSoaKeg8TiKtNE_HZV6"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-TUNNING",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord10 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738842391150067922/y-UG16StH35NCokRdu9asdW46Ah5ojF6Yvj-m5d_X1TlhLkMK9Nz1L1i5dXjY_tSgUnd"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-SZAFKA",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord11 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738854335726747819/DNLHXLOah_NeUuqJjnwC9c2wuUTQFPvtvsUesyA61_Ja8i0JZ_3O4BmK8Wbvl1mS3AxY"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-SZAFKAPD",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord12 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738854415515123852/48ewwE0Z2XX7iMsRcodF8p2OE0aUJPyTN_wQwbnrOphpKjqUsmkRXDuRfgPJbcQer8w4"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-SZAFKAORG",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord13 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/743466425037095044/1v8BNuovHHPH0GhBLHqMyj8Oax1pKxsw6J9QW9i670il9QeL2AHPa0bqQfu_XF6TKgg0"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-GARAZORG",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord14 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738856980751319080/HiF9Rkf2LqCkQhL_dYSxKrxbXqiKTEhmUa0Aqw_HMHRek1evjDS2hq32ZiFSlG9BLGmX"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-AMMUNATION",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord15 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738862641967136779/wPDXs9UDsigTv_OiSfi38avOMeI8zT3UkKNnhl_tOA7QWbvHdIyX_2UJE3TVt8HEAm9N"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-BLACKSHOP",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord16 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/738899658931437628/RuLxt1PqMsmRNiE3Cbg7_5o2jg6d9OJYDQCft4rRcx9MTdIsN-Ol6r01CmkYdK751I9b"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-CHEATS",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord17 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/739490189017219154/vqvc6vuDttYBy4mT9cr_afLV3rCXemWdevPJU_NAuhH3cLRAqTclXREQBjfxHU7Al0sv"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-KASA",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord18 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/742780453777440908/eTEHG5SJjJBCatcvvbP1jOiNrdS7DPQH_64zJe7cK6Qxo2M6qK8VlGWfZqjJjpZS5p-7"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-PRALKA",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord19 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/743363320534269963/kyX_S_Euzx-Wlho0FIwji84GVDoLBugmpqqWnRnkPf5rC9dbrUBHK1sTXW1YS-9ouCBi"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-FIRMY",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord20 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/745010834752798781/57hzv5aOzGUoodcswFJqi66uOjpaOIxOTj5LpwWEQ4Em_kzlCLwADd72dsggNkmvCXrW"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-TRIGGER",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord21 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/749268866449932389/30u1W1E2CXQZL16We0pYxTQYDyZCTiHgGqVH3-WRvBNFQhigX1t6sXd-lRZqZYnD73w1"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-TUNNING-LSC",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord22 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/761705249395179560/ht67ULaLw8bUPAx1xcCsj5mwjJ72prxqX05KL6RmrdliG6y2W9o3HEu67c92ZmqVBBYZ"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-SZAFKA-PD",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord23 (name,message,color)
local DiscordWebHook = "https://discordapp.com/api/webhooks/753930771709820928/VXimCe-N-MKNRPzvXqqPXdb7UKz8lBmwGq8dnlUS0tjJIDOBazBt8sP31L3CeQ2ndAsp"
local embeds = {{["title"]=message,["type"]="rich",["color"] =color,["footer"]={["text"]= "AuraRP-KONTO-LSC",},}}
if message == nil or message == '' then return FALSE end
PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("esx:playerconnected")
AddEventHandler('esx:playerconnected', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local steamhex = GetPlayerIdentifier(_source)
    local identifiers = getIdentifiers(_source)
    local discordID = "\nDiscord: <@" .. identifiers.discord .. ">"
    sendToDiscord('CONNECTING', GetPlayerName(source) .." "..'Laczy sie z serwerem'.."\nID: (".._source..")" .."\nHex: ("..steamhex..")"..discordID, Config.green)
end)

AddEventHandler('playerDropped', function(reason,steamhex)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local steamhex = GetPlayerIdentifier(_source)
    local identifiers = getIdentifiers(_source)
    local discordID = "\nDiscord: <@" .. identifiers.discord .. ">"
    sendToDiscord('DISCONNECTING', GetPlayerName(source) .." "..'Wyszedl z serwera'.. "\nPowód: ("..reason..")" .."\nID: (".._source..")" .."\nHex: ("..steamhex..")"..discordID,Config.red)
end)

RegisterServerEvent("logs:me")
AddEventHandler("logs:me", function(name,tresc)
  sendToDiscord2('ME', name .. ' odgrywa przy pomocy komendy /me : ' .. tresc .. ' ', Config.purple)
end)

RegisterServerEvent("logs:do")
AddEventHandler("logs:do", function(name,tresc)
  sendToDiscord2('DO', name .. ' odgrywa przy pomocy komendy /do : ' .. tresc .. ' ', Config.blue)
end)

AddEventHandler('chatMessage', function(author, color, message)
local player = ESX.GetPlayerFromId(author)
  sendToDiscord3('Czat',"ID: (" .. author .. ") Nick: ".. player.name .." : "..message,Config.grey)
end)

RegisterServerEvent("logs:giveitem")
AddEventHandler("logs:giveitem", function(id,name,idtarget,nametarget,itemname,amount)
  sendToDiscord4('Dawanie Itemow','ID : ('.. id ..') Nick :'.. name ..' \nDaje dla \nID : ('..idtarget..') Nick :'..nametarget.." \nIlość: "..amount .." \nPrzedmiot: "..itemname,Config.orange)
end)

RegisterServerEvent("logs:givemoney")
AddEventHandler("logs:givemoney", function(id,name,idtarget,nametarget,amount)
  sendToDiscord4('Dawanie Kasy','ID : ('.. id ..') Nick :'.. name ..' \nDaje dla \nID : ('..idtarget..') Nick :'..nametarget.." \nIlość: "..amount,Config.orange)
end)

RegisterServerEvent("logs:givemoneyblack")
AddEventHandler("logs:givemoneyblack", function(id,name,idtarget,nametarget,amount)
  sendToDiscord4('Dawanie Brudnej Kasy','ID : ('.. id ..') Nick :'.. name ..' \nDaje dla \nID : ('..idtarget..') Nick :'..nametarget.." \nIlość: "..amount,Config.orange)
end)

RegisterServerEvent("logs:givemoneybank")
AddEventHandler("logs:givemoneybank", function(id,name,idtarget,nametarget,amount)
  sendToDiscord4('Przelew Kasy','ID : ('.. id ..') Nick :'.. name ..' \nDaje dla \nID : ('..idtarget..') Nick :'..nametarget.." \nIlość: "..amount,Config.orange)
end)

RegisterServerEvent("logs:giveweapon")
AddEventHandler("logs:giveweapon", function(id,name,idtarget,nametarget,amount)
  sendToDiscord4('Dawanie Broni','ID : ('.. id ..') Nick :'.. name ..' \nDaje dla \nID : ('..idtarget..') Nick :'..nametarget.." \nBron: "..amount,Config.orange)
end)

RegisterServerEvent("logs:takeitem")
AddEventHandler("logs:takeitem", function(name,nametarget,itemname,amount,steamhex,steamhex2)
  sendToDiscord5('Gracz przeszukuje i zabiera', name.. ' (' ..steamhex.. ') zabiera dla ' ..nametarget.." (" ..steamhex2.. ") ilość: "..amount .." przedmiot: "..itemname, Config.orange)
end)

RegisterServerEvent("logs:faktury")
AddEventHandler("logs:faktury", function(kurwapraca,konfidentXPlayer,konfidenthex,konfidentnick,sourceXPlayer,sourceXPlayerhex,sourceXPlayernick,count)
  sendToDiscord6('Faktury', kurwapraca .. '\nID: (' .. konfidentXPlayer .. ') Nick: (' .. konfidentnick .. ') Hex: (' .. konfidenthex .. ') \nWystawil fakture dla \nID: (' .. sourceXPlayer .. ') Nick: (' .. sourceXPlayernick .. ') Hex: (' .. sourceXPlayerhex .. ') \nCena: ' .. count .. '$', Config.green)
end)

RegisterServerEvent("logs:zlom")
AddEventHandler("logs:zlom", function(nick,plate,model,wlasciciel,id,hex)
  sendToDiscord7('Zlomiarz', '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ') \nZezlomowal: ' .. plate .. '\nModel: '..model..'\nWlasciciel: '..wlasciciel..'', Config.red)
end)

RegisterServerEvent("logs:cars")
AddEventHandler("logs:cars", function(name,rej,typ,_source,steamhex)
  sendToDiscord8('Zakupiono Pojazd', name .. ' zakupil pojazd \nRejestracja: '.. rej ..' \nModel pojazdu: '.. typ ..' \nID: ('.._source..')' ..'\nHex: ('..steamhex..') ', Config.purple)
end)

RegisterServerEvent("logs:tunning")
AddEventHandler("logs:tunning", function(name,cena,id,hex)
  sendToDiscord9('Mechanik robi tuning', 'Mechanik: '..name .. ' \nWykonał tuning na kwote: ' .. cena .. ' $\nID: ('..id..')' ..'\nHex: ('..hex..') ', Config.orange)
  sendToDiscord21('Mechanik robi tuning', 'Mechanik: '..name .. ' \nWykonał tuning na kwote: ' .. cena .. ' $\nID: ('..id..')' ..'\nHex: ('..hex..') ', Config.orange)
end)

RegisterServerEvent("logs:szfka")
AddEventHandler("logs:szfka", function(message)
  sendToDiscord10('Szafka Dom', message, Config.orange)
end)

RegisterServerEvent("logs:szafkapolicegive")
AddEventHandler("logs:szafkapolicegive", function(name,ilosc,item)
  sendToDiscord11('Szafka Police ',name.." oddał do szafki policyjnej: "..item.." ilość: ".. ilosc .."",Config.green)
  sendToDiscord22('Szafka Police ',name.." oddał do szafki policyjnej: "..item.." ilość: ".. ilosc .."",Config.green)
end)

RegisterServerEvent("logs:szafkapolicetake")
AddEventHandler("logs:szafkapolicetake", function(name,ilosc,item)
  sendToDiscord11('Szafka Police',name.." zabrał z szafki policyjnej: "..item.." ilość: ".. ilosc .."",Config.red)
  sendToDiscord22('Szafka Police',name.." zabrał z szafki policyjnej: "..item.." ilość: ".. ilosc .."",Config.red)
end)

RegisterServerEvent("logs:szafkaorggetweapon")
AddEventHandler("logs:szafkaorggetweapon", function(nick,hex,id,ilosc,organizacja,item)
  sendToDiscord12('Szafka Org Bron', organizacja .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWyciaga bron: '..item..'\nAmmo: ' .. ilosc, Config.red)
end)

RegisterServerEvent("logs:szafkaorgputweapon")
AddEventHandler("logs:szafkaorgputweapon", function(nick,hex,id,ilosc,organizacja,item)
  sendToDiscord12('Szafka Org Bron', organizacja .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWklada bron: '..item..'\nAmmo: ' .. ilosc, Config.green)
end)

RegisterServerEvent("logs:szafkaorgputitem")
AddEventHandler("logs:szafkaorgputitem", function(nick,hex,id,ilosc,organizacja,item)
  sendToDiscord12('Szafka Org Item', organizacja .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWklada przedmiot: '..item..'\nIlosc: ' .. ilosc, Config.green)
end)

RegisterServerEvent("logs:szafkaorggetitem")
AddEventHandler("logs:szafkaorggetitem", function(nick,hex,id,ilosc,organizacja,item)
  sendToDiscord12('Szafka Org Item', organizacja .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWyciaga przedmiot: '..item..'\nIlosc: ' .. ilosc, Config.red)
end)

RegisterServerEvent("logs:dodajgarazorg")
AddEventHandler("logs:dodajgarazorg", function(kurwapraca,name,plate,twojstary,_source,steamhex)
  sendToDiscord13('Dodano Pojazd', kurwapraca.. '\n' .. name .. '\nDodal pojazd z garazu \nRejestracja: '.. plate ..' \nModel pojazdu: '.. twojstary ..' \nID: ('.._source..')' ..'\nHex: ('..steamhex..')', Config.green)
end)

RegisterServerEvent("logs:usungarazorg")
AddEventHandler("logs:usungarazorg", function(kurwapraca,name,plate,twojstary,_source,steamhex)
  sendToDiscord13('Usunieto Pojazd', kurwapraca.. '\n' .. name .. '\nUsunal pojazd z garazu \nRejestracja: '.. plate ..' \nModel pojazdu: '.. twojstary ..' \nID: ('.._source..')' ..'\nHex: ('..steamhex..')', Config.red)
end)

RegisterServerEvent("logs:weashopblack")
AddEventHandler("logs:weashopblack", function(id, hex, nick, item)
  sendToDiscord14('Blackshop', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nZakupił przedmiot \nPrzedmiot: ' .. item, Config.red)
end)

RegisterServerEvent("logs:weashop")
AddEventHandler("logs:weashop", function(id, hex, nick, item)
  sendToDiscord14('Ammunation', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nZakupił przedmiot \nPrzedmiot: ' .. item, Config.red)
end)

RegisterServerEvent("logs:blackshopitem")
AddEventHandler("logs:blackshopitem", function(hex, id, nick, item)
  sendToDiscord15('Blackshop Item', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nZakupił przedmiot \nPrzedmiot: ' .. item, Config.red)
end)

RegisterServerEvent("logs:blackshopweapon")
AddEventHandler("logs:blackshopweapon", function(hex, id, nick, item)
  sendToDiscord15('Ammunation Weapon', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nZakupił przedmiot \nPrzedmiot: ' .. item, Config.red)
end)

RegisterServerEvent("logs:banksdeposit")
AddEventHandler("logs:banksdeposit", function(id, hex, nick, amount)
  sendToDiscord17('Bank Wplata', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nWplacil na konto :' .. amount, Config.green)
end)

RegisterServerEvent("logs:bankswithdraw")
AddEventHandler("logs:bankswithdraw", function(id, hex, nick, amount)
  sendToDiscord17('Bank Wyplata', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nWyplacil z konta: ' .. amount, Config.red)
end)

RegisterServerEvent("logs:bankssend")
AddEventHandler("logs:bankssend", function(message)
  sendToDiscord10('Bank Przelew', message, Config.orange)
end)

RegisterServerEvent("logs:pranie")
AddEventHandler("logs:pranie", function(nick, amount, id, hex)
  sendToDiscord18('Pralka', '\nID: ' .. id .. ' \nNick: ' .. nick .. ' \nHex: ' .. hex .. '\nPrzepral Kwote: '..amount, Config.orange)
end)

RegisterServerEvent("logs:konafirmyadd")
AddEventHandler("logs:konafirmyadd", function(society,nick,hex,id,amount)
  sendToDiscord19('Konta Firmy', society .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nChowa pieniadze \nKwota: ' .. amount, Config.green)
  if society == 'mecano' then
  	sendToDiscord23('Konta Firmy', society .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nChowa pieniadze \nKwota: ' .. amount, Config.green)
  end
end)

RegisterServerEvent("logs:konafirmyremove")
AddEventHandler("logs:konafirmyremove", function(society,nick,hex,id,amount)
  sendToDiscord19('Konta Firmy', society .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWyciaga pieniadze \nKwota: ' .. amount, Config.red)
  if society == 'mecano' then
  	sendToDiscord23('Konta Firmy', society .. '\nID: (' .. id .. ') \nNick: ' .. nick .. ' \nHex: (' .. hex .. ')\nWyciaga pieniadze \nKwota: ' .. amount, Config.red)
  end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source
  
  WeaponNames = {
  		 [tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'pumpshotgunmk2',

  		 [tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'bullpupshotgun',

  		 [tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'ak-47mk2',

         [tostring(GetHashKey('WEAPON_UNARMED'))] = 'bez broni',

         [tostring(GetHashKey('WEAPON_KNIFE'))] = 'noz',

         [tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'palka policyjna',

         [tostring(GetHashKey('WEAPON_HAMMER'))] = 'mlotek',

         [tostring(GetHashKey('WEAPON_BAT'))] = 'kij do baseballa',

         [tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'kij golfowy',

         [tostring(GetHashKey('WEAPON_CROWBAR'))] = 'lom',

         [tostring(GetHashKey('WEAPON_PISTOL'))] = 'pistolet',

         [tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'pistolet mk2',

         [tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'pistolet bojowy',

         [tostring(GetHashKey('WEAPON_APPISTOL'))] = 'Pistolet przeciwpancerny',

         [tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistolet .50',

         [tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',

         [tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',

         [tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Szturmowe SMG',

         [tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'AK-47',

         [tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'm4',

         [tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Zaawansowany karabin',

         [tostring(GetHashKey('WEAPON_MG'))] = 'Karabin maszynowy',

         [tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Bojowy karabin maszynowy',

         [tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'strzelba pompowa',

         [tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'obrzym',

         [tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'strzelba szturmowa',

         [tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Strzelba bezkolbowa',

         [tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Paralizator',

         [tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Karabin Snajperski',

         [tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Ciężki karabin snajperski',

         [tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',

         [tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Granatnik',

         [tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Granatnik',

         [tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',

         [tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',

         [tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Nalot rakietowy',

         [tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',

         [tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',

         [tostring(GetHashKey('WEAPON_GRENADE'))] = 'Granat',

         [tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Bomba przylepna',

         [tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Gaz lzawiacy',

         [tostring(GetHashKey('WEAPON_BZGAS'))] = 'Gaz bojowy',

         [tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',

         [tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Gasnica',

         [tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',

         [tostring(GetHashKey('OBJECT'))] = 'Obiekt',

         [tostring(GetHashKey('WEAPON_BALL'))] = 'Pilka',

         [tostring(GetHashKey('WEAPON_FLARE'))] = 'Flara',

         [tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Czolg',

         [tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rakieta Kosmiczna',

         [tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',

         [tostring(GetHashKey('AMMO_RPG'))] = 'Rakieta',

         [tostring(GetHashKey('AMMO_TANK'))] = 'Czolg',

         [tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rakieta Kosmiczna',

         [tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',

         [tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',

         [tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Staranowany przez samochód',

         [tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Butelka',

         [tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg',

         [tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'Pukawka',
         
         [tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'Pukawka MK2',

         [tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Pistolet Vintage',

         [tostring(GetHashKey('WEAPON_DAGGER'))] = 'Zabytkowy sztylet',

         [tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Pistolet sygnałowy',

         [tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Ciezki pistolet',

         [tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Karabinek specjalnyk',

         [tostring(GetHashKey('WEAPON_MUSKET'))] = 'Muszkiet',

         [tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Wyrzutnia fajerwerkow',

         [tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Karabin wyborowy',

         [tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Ciezka strzelba',

         [tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Mina zbliżeniowa',

         [tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Wyrzutnia namierzająca',

         [tostring(GetHashKey('WEAPON_HATCHET'))] = 'Topor',

         [tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'PDW',

         [tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Kastety',

         [tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Pistolet wyborowy',

         [tostring(GetHashKey('WEAPON_MACHETE'))] = 'Maczeta',

         [tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Pistolet maszynowy',

         [tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Latarka',

         [tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Dwururka',

         [tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Karabin kompaktowy',

         [tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Noz sprezynowy',

         [tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Ciężki rewolwer',

         [tostring(GetHashKey('WEAPON_FIRE'))] = 'Ogien',

         [tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Helikopter',

         [tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Przejechany przez samochod',

         [tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Trafiony armatka wodna',

         [tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'wyczerpanie',

         [tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'wybuch',

         [tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Elektryczne ogrodzenie',

         [tostring(GetHashKey('WEAPON_BLEEDING'))] = 'wykrwawienie',

         [tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Utoniecie w pojezdzie',

         [tostring(GetHashKey('WEAPON_DROWNING'))] = 'Utoniecie',

         [tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Drut kolczasty',

         [tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Rakieta z samochodu',

         [tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Karabin bezkolbowy',

         [tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',

         [tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',

         [tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',

         [tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',

         [tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Strzelba automatyczna',

         [tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'topor',

         [tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Granatnik kompaktowy',

         [tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',

         [tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Rurobomba',

         [tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Kij bilardowy',

         [tostring(GetHashKey('WEAPON_WRENCH'))] = 'Klucz francuski',

         [tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Sniezka',

         [tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Zwierze',

         [tostring(GetHashKey('WEAPON_COUGAR'))] = 'Puma'

        }
  
  DeathCauseHash = data.deathCause
  Weapon = WeaponNames[tostring(DeathCauseHash)]

    if data.killedByPlayer then
        sendToDiscord('Kill', GetPlayerName(data.killerServerId) .. ' (ID: '..data.killerServerId..') ZABIL ' .. GetPlayerName(data.victim) .. ' (ID: '..data.victim..') \nDystans: ' .. data.distance .. 'm \nBron: ' .. Weapon .. ' ',Config.red)
    else
        sendToDiscord('Kill', GetPlayerName(data.victim) .. ' umarl',Config.red)
    end
end)

AddEventHandler("weaponDamageEvent",  function(source, weapondamage)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local dmgdone = weapondamage["weaponDamage"]
    local weaponhash = weapondamage["weaponType"]
    TriggerClientEvent('logi:checkdmgboost', _source, dmgdone, weaponhash)
end)

RegisterServerEvent("logs:dmgboost")
AddEventHandler("logs:dmgboost", function(dmg,weapon,modifier)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('DMGBOOST', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex..'\nZadal : ' .. dmg .. '\nBron: '..weapon..'\nMOD: '..modifier..'', Config.red)
end)

RegisterServerEvent("logs:godmode")
AddEventHandler("logs:godmode", function(times)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('GODMODE', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex..'\nNumer Wykrycia : ' .. times, Config.red)
end)

RegisterServerEvent("logs:blacklistedweapon")
AddEventHandler("logs:blacklistedweapon", function(weapon)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('BLACKLISTED WEAPON', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex..'\nPosiada : ' .. weapon, Config.red)
end)

RegisterServerEvent("logs:blacklistedcars")
AddEventHandler("logs:blacklistedcars", function(car)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('BLACKLISTED VEHICLE', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex..'\nPosiada : ' .. car, Config.red)
end)

RegisterServerEvent("logs:spectate")
AddEventHandler("logs:spectate", function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('SPECTATE', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex, Config.red)
  TriggerEvent("logsbanCheaterr", _source, "SPECTATE")
end)

RegisterServerEvent("logs:hashchanger")
AddEventHandler("logs:hashchanger", function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('HASHCHANGER', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex, Config.red)
  TriggerEvent("logsbanCheaterr", _source, "HASHCHANGER")
end)

RegisterServerEvent("logs:menu")
AddEventHandler("logs:menu", function()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local steamhex = GetPlayerIdentifier(_source)
  sendToDiscord16('MENU', GetPlayerName(source) .. '\nID: '.._source..'\nHEX: '..steamhex, Config.red)
  TriggerEvent("logsbanCheaterr", _source, "MENU")
end)

local ForbiddenEvents = {
    "esx_jailer:sendToJail",
    "esx_ambulancejob:revive",
    "esx_society:getOnlinePlayers",
    "esx-qalle-jail:jailPlayer",
    "esx-qalle-jail:jailPlayerNew",
    "esx_society:setJob",
    "esx_society:withdrawMoney",
    "esx_society:depositMoney",
    "esx_society:washMoney",
    "esx_societymordo:washMoney",
    "esx_vehicleshop:setVehicleOwnedPlayerId",
    "esx_vehicleshop:setVehicleOwnedSociety",
    "esx_drugs:startHarvestCoke",
    "esx_drugs:startTransformCoke",
    "esx_drugs:startHarvestMeth",
    "esx_drugs:startTransformMeth",
    "esx_drugs:startHarvestWeed",
    "esx_drugs:startTransformWeed",
    "esx_drugs:startHarvestOpium",
    "esx_drugs:startTransformOpium",
    "esx_drugss:startHarvestCoke",
    "esx_drugss:startTransformCoke",
    "esx_drugss:startHarvestMeth",
    "esx_drugss:startTransformMeth",
    "esx_drugss:startHarvestWeed",
    "esx_drugss:startTransformWeed",
    "esx_drugss:startHarvestOpium",
    "esx_drugss:startTransformOpium",
    "sellDrugs",
    "kashactersS:DeleteCharacter",
    "antilynx8r4a:anticheat",
 	  "antilynxr4:detect",
    "tost:zgarnijsiano",
    "'sellDrugs'..drugtype"
}

for i, eventy in ipairs(ForbiddenEvents) do
    RegisterNetEvent(eventy)
    AddEventHandler(
    eventy,
      function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local steamhex = GetPlayerIdentifier(_source)
        sendToDiscord16('EVENTTRIGGER', '**' ..xPlayer.name.. '**(' ..steamhex.. ') Zbanowany za TRIGGER EVENT: '..eventy, Config.red)
        TriggerEvent("logsbanCheaterr", _source, "CHEATY")
      end
    )
end

local LogEvents = {
	"esx_holdupbank:rob",
	"esx_TruckRobbery:missionComplete",
	"tost:jebacrichrp",
	"utk_oh:rewardCash",
	"sandy_blackshop:purchaseweapon",
	"sandy_blackshop:purchaseitem",
	"sandy_blackshop:purchaseweaponmafia",
	"sandy_laundry:getpay",
	"sandy_org:getStockItem",
	"sandy_org:putStockItems",
	"esx:giveInventoryItem",
	"d3x_vehicleshop:setVehicleOwned",
	"sandyrp:savexprybak",
	"sandyrp:rybakpay",
  	"sandyrp:savexpwiniarz",
  	"sandyrp:savexpwiniarz2",
	"esx_ambulancejob:revivee"
}

for i, eventys in ipairs(LogEvents) do
    RegisterNetEvent(eventys)
    AddEventHandler(
    eventys,
      function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local steamhex = GetPlayerIdentifier(_source)
        sendToDiscord20('EVENTS', '**' ..xPlayer.name.. '**(' ..steamhex.. ')\n Uzyl TRIGGER: '..eventys, Config.red)
      end
    )
end

AddEventHandler("explosionEvent",function(sender, ev)
  CancelEvent()
end)

function getIdentifiers(player)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local raw = GetPlayerIdentifier(player, i)
        local tag, value = raw:match("^([^:]+):(.+)$")
        if tag and value then
            identifiers[tag] = value
        end
    end
    return identifiers
end