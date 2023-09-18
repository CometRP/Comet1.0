fx_version "adamant"
games {"gta5", "rdr3"}
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."

dependency "httpmanager"

shared_scripts {
	"config.lua",
	"common.lua"
}

server_script "server.lua"

files {
	"ui/index.html",
	"ui/style.css",
	"ui/script.js",
	"ui/mediaelement.min.js",
	"ui/chineserocks.ttf",
	"ui/loading.svg",
	"ui/wave.js"
}

ui_page "ui/index.html"

client_scripts {
	"dui.lua",
	"staticEmitters.lua",
	"client.lua"
}
