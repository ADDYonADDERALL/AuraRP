fx_version 'adamant'
game 'gta5'

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
this_is_a_map 'rrerr'

files {
	'events.meta',
	'relationships.dat'
}

client_script 'client.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
  	'config.lua',
  	'server.lua',
}

exports {
	'GetPedData'
}