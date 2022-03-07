fx_version 'cerulean'
game 'gta5'

author 'Flawws & Flakey'
description 'This is the EchoRP Dispatch System'
version '1.0.0'

lua54 'yes'

shared_script{
    "config.lua"
}

client_scripts{
    '@PolyZone/client.lua',
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/app.js',
    'ui/style.css',
}