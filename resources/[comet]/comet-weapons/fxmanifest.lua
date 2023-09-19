games {"gta5"}

fx_version "cerulean"

description "Weapons"

client_scripts {
  -- "init.lua",
  "modes.lua",
  "melee.lua",
  "pickups.lua"
}

server_scripts {
  "server.lua"
}

server_export "getWeaponMetaData"
server_export "updateWeaponMetaData"

exports {
  "toName",
  "findModel"
}
