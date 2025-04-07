fx_version 'cerulean'
author 'K1anFromDK'
lua54 'yes'
game 'gta5'


client_scripts { 
    'client/main.lua' 
}

server_scripts { 
    'server/server.lua' 
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

ui_page 'html/index.html'
files { 
    'html/index.html',
    'html/**/*'
}

dependencies {
    'ox_lib'
}
