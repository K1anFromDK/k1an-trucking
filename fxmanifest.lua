fx_version 'cerulean'
author 'K1an'
lua54 'yes'
game 'gta5'


client_scripts { 
    'client/*.lua' 
}

server_scripts { 
    'server/*.lua', 
    'bridge/server/*.lua'
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
