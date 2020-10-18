resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Identity'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/js/script.js',
	'html/css/bootstrap.min.css',
	'html/css/bootstrap-extend.css',
	'html/css/master_style.css',
	'html/css/master_style_dark.css',
	'html/css/master_style_rtl.css',
	'html/images/bg.jpg',
	'html/images/logoFivem.png',
}

dependency 'es_extended'