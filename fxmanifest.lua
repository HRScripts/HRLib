fx_version 'cerulean'
game 'gta5'

name 'HRLib'
author 'HRScripts Development'
repository 'https://github.com/HRScripts/HRLib'
version '1.0.0'
lua54 'yes'


shared_scripts {
    'config.lua',
    'translator.lua'
}

client_scripts {
    'client/global.lua',
    'client/*.lua'
}

server_scripts {
    'server/global.lua',
    'server/*.lua'
}
