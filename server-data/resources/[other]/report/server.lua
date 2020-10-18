--[[

  Made with love by Cheleber, you can join my RP Server here: www.grandtheftlusitan.com
  Just add your admins steam id!

--]]

--- ADD STEAM ID OR LICENSE FROM YOUR ADMINS!
local admins = {
	'steam:110000103355131',
	'steam:110000115d1e917',
	'steam:11000011169c966',
	'steam:110000114ded6e8',
	'steam:110000135fad0b2',
	'steam:110000105afc9b1',
	'steam:11000010f5f8359',
	'steam:110000111821dcb',
	'steam:11000010e737c03',
	'steam:1100001063c2c06',
	'steam:110000111bd8cec',
	'steam:11000010e45bad7',
	'steam:110000106f13235',
	'steam:1100001152a476f',
	'steam:11000010e1eef7e',
	'steam:1100001173f7221',
	'steam:110000119c852a1',
	'steam:110000110df8fe4',
	'steam:110000132ec55e7',
	'steam:11000010b4d8ffc',
	'steam:11000010b04cba5',
	'steam:110000111c0d620',
	'steam:1100001056faea2',
	'steam:11000011908c90d'
}

function isAdmin(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end


AddEventHandler('chatMessage', function(source, color, msg)
	cm = stringsplit(msg, " ")
	if cm[1] == "/odp" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~= 2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
		    if isAdmin(source) then
			    TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
			    TriggerClientEvent('textsent', source, tPID, names2)
		    else
			    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insuficient Premissions!")
			end
		end
	end	
	
	if cm[1] == "/zglos" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local names1 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
		    TriggerClientEvent("sendReport", -1, source, names1, textmsg)
		end
	end	
	
end)

RegisterServerEvent('checkadmin')
AddEventHandler('checkadmin', function(n1, tmsg, ii)
	local id = source
	if isAdmin(id) then
		TriggerClientEvent("sendReportToAllAdmins", -1, source, n1, tostring(tmsg), ii)
	else
	end
end)


function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end



function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end