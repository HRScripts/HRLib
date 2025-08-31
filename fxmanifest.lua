fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'HRLib'
author 'HRScripts Development'
description 'A fivem library script used for each HRScripts\' resource'
repository 'https://github.com/HRScripts/HRLib'
version '3.2.2'

shared_script 'main.lua'

files {
    'web/*.*',
    'web/features/**/*.*',
    'modules/*.*',
    'modules/**/*.*',
    'translator.lua',
    'config.lua',
    'import.lua'
}

ui_page 'web/index.html'

dependency '/onesync'