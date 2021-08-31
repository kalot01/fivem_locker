fx_version 'cerulean'
game 'gta5'
author 'Kal'
version '1.0.0'

dependencies {
	'es_extended'
}

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}
