games {"gta5"}

fx_version "cerulean"

description "Weapons"


client_scripts {
 -- "client.lua",
  "client/modes.lua",
  "client/melee.lua",
  "client/pickups.lua",
  "client/cl_*.lua",
}

server_scripts {
  "server/server.lua",
  "server/sv_*.lua"
}

server_export "getWeaponMetaData"
server_export "updateWeaponMetaData"

exports {
  "toName",
  "findModel"
}
