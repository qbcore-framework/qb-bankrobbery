fx_version 'cerulean'
game 'gta5'

description 'QB-BankRobbery'
version '1.0.0'

ui_page "html/index.html"

client_scripts {
    'client/fleeca.lua',
    'client/pacific.lua',
    'client/powerstation.lua',
    'client/doors.lua',
    'client/paleto.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'config.lua',
}

files {
    'html/*',
}
