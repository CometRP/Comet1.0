fx_version 'cerulean'
game 'gta5'

author 'CometRP'
description 'Voice'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@comet-assets/client/cl_errorlog.lua',
    'client/classes/cl_*.lua',
    'client/cl_*.lua',
}

server_script {
    '@comet-assets/server/sv_errorlog.lua',
    'server/sv_*.lua',
}

dependency 'comet-ui'

lua54 'yes'