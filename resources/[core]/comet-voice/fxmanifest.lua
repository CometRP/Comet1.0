fx_version 'cerulean'
game 'gta5'

author 'CometRP'
description 'Voice'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    'client/classes/cl_*.lua',
    'client/cl_*.lua',
}

server_script {
    'server/sv_*.lua',
}

dependency 'comet-ui'

lua54 'yes'