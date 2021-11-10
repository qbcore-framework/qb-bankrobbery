fx_version 'cerulean'
game 'gta5'

description 'QB-BankRobbery'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'

client_scripts {
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

lua54 'yes'