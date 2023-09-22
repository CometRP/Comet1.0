fx_version 'cerulean'
game 'gta5'
 
lua54 'yes' -- Add in case you want to use lua 5.4 (https://www.lua.org/manual/5.4/manual.html)

shared_script "config.lua"

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',
    'game/dist/index.js',
    "client/names.json",
    "client/customfunctions.js",
    'client/*.lua', -- Globbing method for multiple files
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "client/names.json",
    'server.lua', -- Globbing method for multiple files
    'sv_menu.lua' -- Globbing method for multiple files
}

ui_page 'web/build/index.html'
 
files {
    'web/build/index.html',
    'web/build/**/*',
    'peds.json',
}

escrow_ignore {
    'config.lua',
}