fx_version 'cerulean'
games { 'gta5' }

version 'v1.2.0' -- Do not modify
lua54 'yes'

author 'Nullified'

shared_scripts {
	'config.lua',
	'shared/*.lua'
}

client_script 'client/*.lua'

dependencies {
	'/onesync'
}
