game 'gta5'
fx_version 'cerulean'
lua54 'yes'

name 'NebulaBan'
description 'NebulaBan - A powerful ban management resource for FiveM'
author 'Marsou'
repository 'https://github.com/Marsou/NebulaBan'

shared_scripts {
    'shared/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}