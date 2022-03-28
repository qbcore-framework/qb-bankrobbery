fx_version 'cerulean'
game 'gta5'

description 'Bankrobbery for QB-Core'
version '1.1.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/fleeca.lua',
    'client/pacific.lua',
    'client/powerstation.lua',
    'client/doors.lua',
    'client/paleto.lua',
}

server_script 'server/main.lua'

files {
    'html/*',
}

dependency 'PolyZone'

lua54 'yes'
