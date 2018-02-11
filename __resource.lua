-- https://wiki.fivem.net/wiki/Resource_manifest

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'fivem-idlogs'

version '1.0.0'

-- server scripts
server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua",
}

-- client scripts
client_scripts {
	"client/main.lua",
}