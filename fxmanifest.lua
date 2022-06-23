fx_version 'cerulean'
game 'gta5'

description 'Bankrobbery for QB-Core'
version '1.1.2'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua' -- Change this to your preferred language
}

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
use_fxv2_oal 'yes'
