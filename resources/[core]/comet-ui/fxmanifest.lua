fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'nui/index.html'

client_script {
    '@comet-assets/client/cl_errorlog.lua',
    '@comet-polyzone/client/cl_main.lua',
    '@comet-polyzone/client/BoxZone.lua',
    '@comet-polyzone/client/EntityZone.lua',
    '@comet-polyzone/client/CircleZone.lua',
    '@comet-polyzone/client/ComboZone.lua',
    '@comet-base/shared/sh_shared.lua',
    'shared/sh_*.lua',
    'shared/cl_*.lua',
    'config/cl_*.lua',
    'client/*.lua',
}

server_script {
    '@comet-assets/server/sv_errorlog.lua',
    '@comet-base/shared/sh_shared.lua',
    'shared/sh_*.lua',
    'server/*.lua',
}

files {
    'nui/index.html',
    'nui/images/*.png',
    'nui/images/**/*.png',
    'nui/images/*.jpg',
    'nui/images/**/*.jpg',
    'nui/images/*.svg',
    'nui/images/**/*.svg',
    'nui/sounds/*.ogg',
    'nui/fonts/*.woff',
    'nui/fonts/*.woff2',
    'nui/fonts/*.ttf',
    'nui/fonts/*.otf',
    'nui/css/*.css',
    'nui/js/*.js',
    'nui/Apps/**/*.html',
    'nui/Apps/**/css/*.css',
    'nui/Apps/**/js/*.js',
}