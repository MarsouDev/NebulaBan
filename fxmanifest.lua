game 'gta5'
fx_version 'cerulean'
lua54 'yes'

name 'NebulaBan'
description 'A professional ban management resource for FiveM'
author 'MarsouDev'
version '2.0.0'
repository 'https://github.com/MarsouDev/NebulaBan'

shared_scripts {
    'shared/config.lua',
    'locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/utils.lua',
    'server/sv_main.lua',
    'server/commands.lua',
    'server/test.lua', -- Remove this line after testing
}