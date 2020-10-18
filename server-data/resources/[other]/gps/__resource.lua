resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
	'client.lua',
   	'MinimapValues.lua',
   	'RadarWhileDriving.lua',
}

server_scripts {
  	'@mysql-async/lib/MySQL.lua',
  	'server.lua',
}