Config = {}

Config.DiscordServerID = 
Config.DiscordBotToken = ""
Config.maxServerSlots = 100

Config.Roles = {
    Wlasciciel = {
        roleID = "738511963310653601",
        points = 5000,
        name = "Wlasciciel"
    },
    Zarzad = {
        roleID = "738512147176488961",
        points = 2500,
        name = "Zarzad"
    },
    HeadAdmin = {
        roleID = "738512222942134403",
        points = 2000,
        name = "Head Admin"
    },
    Admin = {
        roleID = "738512344274960425",
        points = 1500,
        name = "Admin"
    },
    Moderator = {
        roleID = "738512457860907008",
        points = 1250,
        name = "Moderator"
    },
    Support = {
        roleID = "738512877962395678",
        points = 1000,
        name = "Support"
    },
    Donatorplusplus = {
        roleID = "739902046773444608",
        points = 700,
        name = "Donator++"
    },
    HonorowyObywatel = {
        roleID = "741219276429459547",
        points = 500,
        name = "Honorowy Obywatel"
    },
    Partner = {
        roleID = "741218848790806541",
        points = 500,
        name = "Partner"
    },
    Donatorplus = {
        roleID = "739901874182029383",
        points = 450,
        name = "Donator+"
    },
    LSPD = {
        roleID = "738581856827473920",
        points = 200,
        name = "LSPD"
    },
    EMS = {
        roleID = "738582174005198968",
        points = 200,
        name = "EMS"
    },
    LSC = {
        roleID = "738582295010738178",
        points = 200,
        name = "LSC"
    },
    Donator = {
        roleID = "738583187894042695",
        points = 100,
        name = "Donator"
    } 
}

Config.Colors = {
    "good",
    "light",
    "default",
    "attention",
}

Config.NoDiscord = "Nie wykryto Discord."
Config.NoSteam = "Nie wykryto Steam."
Config.Error = "Error, Sprobuj ponownie."
Config.HandshakingWith = "Ladowanie kolejki..."

local playersInfo, connectingInfo = {}, {} 
local jsonCard = json.decode(LoadResourceFile(GetCurrentResourceName(), 'presentCard.json'))[1]
local charactercard = {
    ["type"] = "AdaptiveCard",
    ["minHeight"] = "100px",
    ["body"] = {
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["horizontalAlignment"] = "Left",
                    ["text"] = "Wybierz Obywatela",
                },
                {
                  ["type"] = "Input.ChoiceSet",
                  ["id"] = "input",
                  ["horizontalAlignment"] = "Left",
                  ["style"] = "expanded",
                  ["isMultiSelect"] = false,
                  ["label"] = "Wybierz postac",
                  ["isVisible"] = false,
                  ["choices"] = {
                    {
                      ["title"] = "Obywatel 1",
                      ["value"] = "1"
                    },
                    {
                      ["title"] = "Obywatel 2",
                      ["value"] = "2"
                    },
                  }
                },
                {
                  ["type"] = "Input.ChoiceSet",
                  ["id"] = "input2",
                  ["horizontalAlignment"] = "Left",
                  ["style"] = "expanded",
                  ["isMultiSelect"] = false,
                  ["label"] = "Wybierz postac",
                  ["isVisible"] = false,
                  ["choices"] = {
                    {
                      ["title"] = "Obywatel 1",
                      ["value"] = "1"
                    },
                    {
                      ["title"] = "Obywatel 2",
                      ["value"] = "2"
                    },
                    {
                      ["title"] = "Obywatel 3",
                      ["value"] = "3"
                    },
                    {
                      ["title"] = "Obywatel 4",
                      ["value"] = "4"
                    },
                  }
                },
                {
                    ["type"] = "TextBlock",
                    ["horizontalAlignment"] = "Left",
                    ["text"] = "Wybierz Lokacje",
                },
                {
                  ["type"] = "Input.ChoiceSet",
                  ["id"] = "input3",
                  ["horizontalAlignment"] = "Left",
                  ["style"] = "expanded",
                  ["isMultiSelect"] = false,
                  ["label"] = "Wybierz Lokacje",
                  ["isVisible"] = true,
                  ["choices"] = {
                    {
                      ["title"] = "Poprzednia lokacja",
                      ["value"] = "5"
                    },
                    {
                      ["title"] = "Lotnisko",
                      ["value"] = "6"
                    },
                  }
                },
                {
                    ["type"] = "TextBlock",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "small",
                    ["text"] = "Karta refreszuje sie co 15s"
                },
            }
        }
    },
    ["actions"] = {
        {
            ["type"] = "Action.Submit",
            ["title"] = "Pobierz Bilet"
        }
    },
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.2"
}

local IdentifierTables = {
    {table = "users", column = "identifier"},
    {table = "owned_vehicles", column = "owner"},
    {table = "owned_vehiclesEMG", column = "identifier"},
    {table = "user_accounts", column = "identifier"},
    {table = "owned_properties", column = "owner"},
    {table = "user_licenses", column = "owner"},
    {table = "jail", column = "identifier"},
    {table = "phone_users_contacts", column = "identifier"},
    {table = "user_inventory", column = "identifier"},
    {table = "characters", column = "identifier"},
    {table = "datastore_data", column = "owner"},
    {table = "user_sim", column = "identifier"},
    {table = "addon_inventory_items", column = "owner"},
    {table = "addon_account_data", column = "owner"},
    {table = "expsystem", column = "identifier"},
    {table = "lspd_mdc_user_notes", column = "userId"},
    {table = "lspd_user_judgments", column = "userId"},
    {table = "owned_keys", column = "identifier"},
}

local os_time = os.time

StopResource('hardcap')

AddEventHandler("playerConnecting", function(name, reject, d)
    local _source = source
    local currentSteamID, currentDiscordID
    d.defer()
    Wait(50)
    d.update(Config.HandshakingWith)
    Wait(250)
    d.update(string.format("[Stage 1] AuraRP Anty Flood 5s"))
    Wait(1000)
    d.update(string.format("[Stage 1] AuraRP Anty Flood 4s"))
    Wait(1000)
    d.update(string.format("[Stage 1] AuraRP Anty Flood 3s"))
    Wait(1000)
    d.update(string.format("[Stage 1] AuraRP Anty Flood 2s"))
    Wait(1000)
    d.update(string.format("[Stage 1] AuraRP Anty Flood 1s"))
    Wait(1000)

    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            currentDiscordID = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            currentSteamID = v
        end
    end

    if not currentDiscordID then
        reject(Config.NoDiscord)
        CancelEvent()
        return
    end

    if not currentSteamID then
        reject(Config.NoSteam)
        CancelEvent()
        return
    end

    if not ProccessQueue(currentSteamID, currentDiscordID, d, _source) then
        CancelEvent()
    end
end)

function ProccessQueue(steamID, discordID, d, _source)
    local data = {name = nil, queuepts = 0}
    local connectTime = os_time()
	PerformHttpRequest("https://discordapp.com/api/guilds/" .. Config.DiscordServerID .. "/members/"..string.sub(discordID, 9), function(err, text, headers) 
		if text ~= nil then
        	local member = json.decode(text)
        	local memberRoleNames, memberRoleNamesCounter = '', 0
        	for a, b in ipairs(member.roles) do
        	    for _, roleData in pairs(Config.Roles) do
        	        if b == roleData.roleID then
        	            data.queuepts = data.queuepts + roleData.points
        	            if memberRoleNamesCounter == 0 then
        	            	memberRoleNames = roleData.name
        	            	memberRoleNamesCounter = memberRoleNamesCounter + 1
        	            else
        	            	memberRoleNames = memberRoleNames .. ' & ' .. roleData.name
        	            end
        	        end
        	    end
        	end

        	local localname, localdec = "", ""
        	for k, v in pairs(member.user) do
        	    if k == "username" then
        	        localname = v
        	    elseif k == "discriminator" then
        	        localdec = tostring(v)
        	    end
        	end
			data.name = localname .. "#" .. tostring(localdec)
			memberRoleNames = memberRoleNames ~= "" and memberRoleNames or "Member"


        	AddPlayer(steamID, discordID, data.name, data.queuepts, memberRoleNames, _source, d)
		else
        	AddPlayer(steamID, discordID, "Not Found", 0, "None", _source, d)
		end
		
        local stop = false
        repeat
        	for k, v in pairs(connectingInfo) do
        		if v.steamID == steamID then
        			stop = true
        		end
        	end

			for k, v in ipairs(playersInfo) do
				if v.steamID == steamID and (GetPlayerPing(v.source) == 0) then
					dropPlayerFromQueue(steamID, discordID)
					d.done(Config.Error)
					return false
				end
			end

            local currentMessage = GetMessage(connectTime)
            d.presentCard(currentMessage, function(data, rawData) end)
            Wait(0)
        until stop
        d.defer()

        d.update(string.format("[Stage 2] AuraRP Anty Flood 5s"))
        Wait(1000)
        d.update(string.format("[Stage 2] AuraRP Anty Flood 4s"))
        Wait(1000)
        d.update(string.format("[Stage 2] AuraRP Anty Flood 3s"))
        Wait(1000)
        d.update(string.format("[Stage 2] AuraRP Anty Flood 2s"))
        Wait(1000)
        d.update(string.format("[Stage 2] AuraRP Anty Flood 1s"))
        Wait(1000)

        Wait(0)

        local LastCharId = GetLastCharacter(_source)
    	SetIdentifierToChar(GetPlayerIdentifiers(_source)[1], LastCharId)
    	local Chars = GetPlayerCharacters(_source)

        local match = false
        local selected = false

        local function characterCardCallback(data, rawData)

            Wait(0)

            if data then
                if data.input or data.input2 and data.input3 ~= nil then
                    if data.input and data.input3 ~= nil then
                    	selected = true
                    	d.update(string.format("[Stage 3] Wczytywanie postaci..."))
                        if data.input3 == '6' then
                            SetLastCharacter(_source, tonumber(data.input))
                            SetCharToIdentifier(GetPlayerIdentifiers(_source)[1], tonumber(data.input))
                            SetSpawnPos(_source, '6')
                            match = true
                        else
                            SetLastCharacter(_source, tonumber(data.input))
                            SetCharToIdentifier(GetPlayerIdentifiers(_source)[1], tonumber(data.input))
                            match = true
                        end
                    end
                    if data.input2 and data.input3 ~= nil then
                    	selected = true
                    	d.update(string.format("[Stage 3] Wczytywanie postaci..."))
                        if data.input3 == '6' then
                            SetLastCharacter(_source, tonumber(data.input2))
                            SetCharToIdentifier(GetPlayerIdentifiers(_source)[1], tonumber(data.input2))
                            SetSpawnPos(_source, '6')
                            match = true
                        else
                            SetLastCharacter(_source, tonumber(data.input2))
                            SetCharToIdentifier(GetPlayerIdentifiers(_source)[1], tonumber(data.input2))
                            match = true
                        end
                    end
                end
            end

            if not match then
                showCharacterCard(d, characterCardCallback, _source, Chars)
            else
                d.done();
            end
        end
        repeat
        	showCharacterCard(d, characterCardCallback, _source, Chars)
        	Wait(15000)
		until selected
		return true
	end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot " .. Config.DiscordBotToken})
    for k, v in pairs(connectingInfo) do
        if v.steamID == GetPlayerIdentifier(_source) then
            table.remove(connectingInfo, k)
        end
    end
	return false
end

function showCharacterCard(deferrals, callback, src, Chars)
    local card = charactercard

    if IsPlayerAceAllowed(src, "donator.extrachar") then
        card.body[1].items[2].isVisible = false
        card.body[1].items[3].isVisible = true
    else
        card.body[1].items[2].isVisible = true
        card.body[1].items[3].isVisible = false
    end

    if card.body[1].items[2].isVisible then
        if Chars[1] ~= nil then
        	card.body[1].items[2].choices[1].title = Chars[1].firstname..' '..Chars[1].lastname..' | [Gotowka: '..Chars[1].money..'] | [Bank: '..Chars[1].bank..']'
        else
        	card.body[1].items[2].choices[1].title = 'Wolny Slot'
        end
        if Chars[2] ~= nil then
        	card.body[1].items[2].choices[2].title = Chars[2].firstname..' '..Chars[2].lastname..' | [Gotowka: '..Chars[2].money..'] | [Bank: '..Chars[2].bank..']'
    	else
    		card.body[1].items[2].choices[2].title = 'Wolny Slot'
    	end
    end

    if card.body[1].items[3].isVisible then
        if Chars[1] ~= nil then
            card.body[1].items[3].choices[1].title = Chars[1].firstname..' '..Chars[1].lastname..' | [Gotowka: '..Chars[1].money..'] | [Bank: '..Chars[1].bank..']'
        else
            card.body[1].items[3].choices[1].title = 'Wolny Slot'
        end
        if Chars[2] ~= nil then
            card.body[1].items[3].choices[2].title = Chars[2].firstname..' '..Chars[2].lastname..' | [Gotowka: '..Chars[2].money..'] | [Bank: '..Chars[2].bank..']'
        else
            card.body[1].items[3].choices[2].title = 'Wolny Slot'
        end
    	if Chars[3] ~= nil then
        	card.body[1].items[3].choices[3].title = Chars[3].firstname..' '..Chars[3].lastname..' | [Gotowka: '..Chars[3].money..'] | [Bank: '..Chars[3].bank..']'
    	else
    		card.body[1].items[3].choices[3].title = 'Wolny Slot'
    	end
    	if Chars[4] ~= nil then
        	card.body[1].items[3].choices[4].title = Chars[4].firstname..' '..Chars[4].lastname..' | [Gotowka: '..Chars[4].money..'] | [Bank: '..Chars[4].bank..']'
    	else
    		card.body[1].items[3].choices[4].title = 'Wolny Slot'
    	end
    end

    deferrals.presentCard(card, callback)
end

AddEventHandler("playerDropped", function(reason)
    local _source = source
    dropPlayerFromQueue(GetPlayerIdentifier(_source, 1), GetPlayerIdentifier(_source, 3))
end)

RegisterServerEvent('bb-queue:removeConnected')
AddEventHandler('bb-queue:removeConnected', function()
	local _source = source
	for k, v in pairs(connectingInfo) do
		if v.steamID == GetPlayerIdentifier(_source) then
			table.remove(connectingInfo, k)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        CheckConnecting()

        if #playersInfo > 0 and #connectingInfo + #GetPlayers() < Config.maxServerSlots then
            ConnectFirst()
        end
    end
end)

function dropPlayerFromQueue(steamID, discordID, count)
	if count then
		local queueCount = #playersInfo
    	for currentPlayer = count, queueCount do
    		playersInfo[currentPlayer] = playersInfo[currentPlayer + 1]
    	end
	else
		for k, v in pairs(playersInfo) do
			if v.steamID == steamID or v.discordID == discordID then
				local queueCount = #playersInfo
    			local saveCred = nil
    			for currentPlayer = k + 1, queueCount do
    				playersInfo[currentPlayer - 1] = playersInfo[currentPlayer]
    			end
    			playersInfo[queueCount] = nil
    			return
			end
		end
	end
end

function AddPlayer(steamID, discordID, discordName, queuePts, roleNames, source, d)
    local _source = source

    if #playersInfo == 0 then
    	playersInfo[1] = {
    		steamID = steamID,
    		steamName = GetPlayerName(_source),
    		discordID = discordID,
    		discordName = discordName, 
    		points = queuePts,
    		roleNames = roleNames,
    		source = _source
    	}
    else
    	for k, v in pairs(playersInfo) do
    		if v.points < queuePts then
    			local queueCount = #playersInfo
    			local saveCred = nil
    			for currentPlayer = k, queueCount + 1 do
    				if currentPlayer == k then
    					saveCred = playersInfo[currentPlayer + 1]
    					playersInfo[currentPlayer + 1] = playersInfo[currentPlayer]
    				else
    					local currentSaveCred = playersInfo[currentPlayer + 1]
    					playersInfo[currentPlayer + 1] = saveCred
    					saveCred = currentSaveCred
    				end
    			end

    			playersInfo[k] = {
    				steamID = steamID,
    				steamName = GetPlayerName(_source),
    				discordID = discordID,
    				discordName = discordName, 
    				points = queuePts,
    				roleNames = roleNames,
    				source = _source
    			}
    			return
    		end
    	end

    	playersInfo[#playersInfo + 1] = {
    		steamID = steamID,
    		steamName = GetPlayerName(_source),
    		discordID = discordID,
    		discordName = discordName, 
    		points = queuePts,
    		roleNames = roleNames,
    		source = _source
    	}
    end
end

function CheckConnecting()
    for k, v in pairs(playersInfo) do
        if GetPlayerPing(v.source) == 500 then
           	dropPlayerFromQueue(nil, nil, k)
        end
    end

    for k, v in pairs(connectingInfo) do
        if GetPlayerPing(v.source) == -1 then
            if v.errorsNum > 1 then
                table.remove(connectingInfo, k)
            end
            v.errorsNum = v.errorsNum + 1
        end
    end
end

function ConnectFirst()
    if #playersInfo == 0 then 
    	return 
    end
    
    table.insert(connectingInfo, {steamID = playersInfo[1].steamID, source = playersInfo[1].source, errorsNum = 0})
    dropPlayerFromQueue(nil, nil, 1)
end

function GetMessage(connectTime)
    local msg = ""
    local cardd = jsonCard
    local counter = 1
    local queuetime = os_time() - connectTime
    for k, v in pairs(playersInfo) do
    	if counter < 5 then
        	msg = msg .. '['..tostring(k)..'] ' .. v.steamName .. ' (' .. v.discordName .. ') | ' .. v.roleNames .. '\n'
        	counter = counter + 1
        elseif counter == 5 then
        	msg = msg .. 'i ' .. #playersInfo - counter .. ' Graczy.\n'
        	counter = counter + 1
        end
    end

    cardd.body[3].text = msg
    cardd.body[4].text = "Kolejka: " .. tostring(#playersInfo) .. " | Graczy: " .. #GetPlayers() .. "/" .. Config.maxServerSlots .. " | Czas: " .. queuetime.. "s"
    return cardd
end

RegisterCommand('bb-resetConnects', function()
	for k, v in pairs(connectingInfo) do
		table.remove(connectingInfo, k)
	end
end)

function GetPlayerCharacters(source)
    local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
    local Chars = MySQLAsyncExecute("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")
    return Chars
end

function GetLastCharacter(source)
    local LastChar = MySQLAsyncExecute("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        MySQLAsyncExecute("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetPlayerIdentifiers(source)[1].."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    MySQLAsyncExecute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function SetIdentifierToChar(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."' WHERE `"..itable.column.."` = '"..identifier.."'")
    end
end

function SetCharToIdentifier(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = '"..identifier.."' WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function SetSpawnPos(source, loc)
    local position
    if loc == '6' then
        position = '{"x":-1037.7999999998138,"y":-2738.4000000003727,"z":20.19999999999709}'
    end
    MySQL.Async.execute("UPDATE `users` SET `position` = '"..position.."' WHERE `identifier` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('sandycharacter:fetchcharacters', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    ESX.SavePlayers()
    local LastCharId = GetLastCharacter(source)
    SetIdentifierToChar(GetPlayerIdentifiers(source)[1], LastCharId)
    local Chars = GetPlayerCharacters(source)
    cb(Chars)
end)

RegisterServerEvent("sandycharacter:selectcharacter")
AddEventHandler('sandycharacter:selectcharacter', function(charid)
    local src = source
    if tonumber(charid) <= 4 or tonumber(charid) >= 0 then
        SetLastCharacter(src, tonumber(charid))
        SetCharToIdentifier(GetPlayerIdentifiers(src)[1], tonumber(charid))
        TriggerClientEvent('skinchanger:loadDefaultModel', src, true, cb)
        TriggerClientEvent("sandycharacter:spawncharacter", src)
        TriggerClientEvent("esx_status:charSpawnedClient", src)
        TriggerClientEvent("esx_voice:UnlockProx", src)
    else
        TriggerEvent("logsbanCheaterr", src, "KASHACTERS")
    end
end)