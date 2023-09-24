local logs = "https://discord.com/api/webhooks/1155475588937699358/ALlNCSow0-NUKX4QqB0REw9G7W-BucAg3D8hO9mxdq3jV2yr5ydBFjesu98Y6-1jP6vT"

local kick_msg = "Hmm, what you wanna do in this inspector?"
local discord_msg = '`Player try to use nui_devtools`\n`and he got a kick`\n`ANTI NUI_DEVTOOLS`'
local color_msg = 16767235

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end


function sendToDiscord(source,message,color,identifier)
    
    local name = GetPlayerName(source)
    if not color then
        color = color_msg
    end
    local sendD = {
        {
            ["color"] = color,
            ["title"] = message,
            ["description"] = "`Player`: **"..name.."**\nSteam: **"..identifier.steam.."** \nIP: **"..identifier.ip.."**\nDiscord: **"..identifier.discord.."**\nFivem: **"..identifier.license.."**",
            ["footer"] = {
                ["text"] = os.date("%x %X %p")
            },
        }
    }

    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Anti nui_devtools", embeds = sendD}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local _source = source
    local identifier = ExtractIdentifiers(_source)
    if not IsPlayerAceAllowed(_source, 'nui_devtools') then
        sendToDiscord(_source, discord_msg, color_msg,identifier)
        DropPlayer(_source, kick_msg)	
    end
end)