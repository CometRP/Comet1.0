Components.Player = Components.Player or {}
Components.LocalPlayer = Components.LocalPlayer or {}

local function GetUser()
    return Components.LocalPlayer
end

function Components.LocalPlayer.setVar(self, var, data)
    GetUser()[var] = data
end

function Components.LocalPlayer.getVar(self, var)
    return GetUser()[var]
end

function Components.LocalPlayer.setCurrentCharacter(self, data)
    if not data then return end
    GetUser():setVar("character", data)
end

function Components.LocalPlayer.getCurrentCharacter(self)
    return GetUser():getVar("character")
end

RegisterNetEvent("comet-base:networkVar")
AddEventHandler("comet-base:networkVar", function(var, val)
    Components.LocalPlayer:setVar(var, val)
end)

