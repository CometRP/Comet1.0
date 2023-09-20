fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'nui/index.html'

client_script {
    'shared/sh_*.lua',
    'shared/cl_*.lua',
    'config/cl_*.lua',
    'client/*.lua',
}

server_script {
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