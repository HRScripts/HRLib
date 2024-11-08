fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'HRLib'
author 'HRScripts Development'
description 'A fivem library script used for all HRScripts Development\'s resources'
repository 'https://github.com/HRScripts/HRLib'
version '2.5.6'

shared_scripts {
    'config.lua',
    'translator.lua',
}

client_script 'client/main.lua'

server_script 'server/main.lua'

files {
    'config.lua',
    'client/**/*.*',
    'client/web/features/**/*.*',
    'import.lua',
    'translator.lua'
}

ui_page 'client/web/index.html'