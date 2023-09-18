fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'CometRP Framework'
version '1.0.0'

shared_scripts {
    'shared/sh_base.lua'
}

client_scripts {
    -- '@PolyZone/client.lua',
    -- '@PolyZone/BoxZone.lua',
    -- '@PolyZone/CircleZone.lua',
    -- '@PolyZone/ComboZone.lua',
    -- '@PolyZone/EntityZone.lua',

    'client/cl_base.lua',
    'client/cl_components.lua',
    'client/components/cl_*.lua',
}
server_scripts {
    'server/sv_base.lua',
    'server/sv_components.lua',
    'server/components/sv_*.lua',
}