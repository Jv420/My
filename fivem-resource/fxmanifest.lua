fx_version 'cerulean'
game 'gta5'

name 'jv-fivem-shop'
author 'Jv420 + ChatGPT'
description 'Stripe webshop auto delivery voor ESX en QBCore'
version '1.0.0'

lua54 'yes'

shared_scripts {
  'config.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/framework.lua',
  'server/delivery.lua',
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}
