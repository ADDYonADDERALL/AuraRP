resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'SANDY Cooldown'

version '1.0.0'

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
	'@mysql-async/lib/MySQL.lua',
}