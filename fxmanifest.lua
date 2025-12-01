fx_version 'cerulean'
author '!TYL3Rk'
game 'gta5'
lua54 'yes'

description 'Vending Script'
version '1.0.0'

client_script {
    'client.lua'
}

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

server_script {
    'server.lua'
}