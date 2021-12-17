fx_version 'cerulean'
game 'gta5'

author 'Flawws & Flakey'
description 'This is the EchoRP Dispatch System'
version '1.0.0'

lua54 'yes'

client_script '@PolyZone/client.lua'
server_script 'sv_main.lua'
client_script 'cl_main.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/app.js',
    'ui/style.css',
}