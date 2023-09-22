fx_version 'cerulean'
games { 'gta5' }

client_scripts {
  'client/cl_tattooshop.lua',
  'client/cl_*.lua',
}

shared_script {
  'shared/sh_*.*',
}

server_scripts {
  'server/sv_*.lua',
}

export "CreateHashList"
export "GetTatCategs"
export "GetCustomSkins"
export "isNearClothing"
