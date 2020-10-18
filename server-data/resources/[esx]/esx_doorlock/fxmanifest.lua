fx_version 'adamant'
game 'gta5'


description 'ESX door lock'

version '1.3.0'

server_scripts {
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

dependency 'es_extended'