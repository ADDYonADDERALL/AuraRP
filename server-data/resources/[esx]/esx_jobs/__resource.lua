dependency 'es_extended'

client_script {
  '@es_extended/locale.lua',
  'client.lua'
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'server.lua'
}
