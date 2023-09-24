fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_scripts {
    -- '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    -- '@ox_core/imports/client.lua',
    'client/cl_*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- '@ox_core/imports/server.lua',
    'server/sv_*.lua',
}