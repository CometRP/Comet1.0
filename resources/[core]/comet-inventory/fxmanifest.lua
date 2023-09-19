fx_version "cerulean"
games {"gta5"}

ui_page "nui/ui.html"

files {
	"nui/ui.html",
	"nui/pricedown.ttf",
	"nui/default.png",
	"nui/background.png",
	"nui/weight-hanging-solid.png",
	"nui/hand-holding-solid.png",
	"nui/search-solid.png",
	"nui/invbg.png",
	"nui/styles.css",
	"nui/scripts.js",
	"nui/debounce.min.js",
	"nui/loading.gif",
	"nui/loading.svg",
	"nui/icons/*"
  }


shared_script "shared_list.js"
client_scripts {
	"client/client.js"
	"client/functions.lua"
	"client/cl_attach.lua"
	"client/cl_hotbar.lua"
}
server_scripts {
	"server/sv_functions.lua",
	-- "server/server_degradation.js",
	"server/server.js",
	"server/server_shops.js",
}

exports{
	"hasEnoughOfItem",
	"getQuantity",
	"GetCurrentWeapons",
	"GetItemInfo"
}
