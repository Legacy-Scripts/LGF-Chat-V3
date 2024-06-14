fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ENT510'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'modules/client/bridge/bridge.lua',
    'modules/client/cl_main.lua',
    'modules/client/events.lua',
    'modules/client/editable.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/server/bridge/bridge.lua',
    'modules/server/sv_main.lua',
    'modules/server/dataCommand.lua',
}

ui_page "ui/index.html"

files {
    'utils/utils.lua',
    "utils/locales/*.json",
    "ui/index.html",
    "ui/styles.css",
    "ui/script.js",
}
