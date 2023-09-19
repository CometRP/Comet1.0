Components.Spawn =Components.Spawn or {}

function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)

    for _, v in pairs(identifiers) do
        -- if string.find(v, "steam") then
        if string.find(v, "license") then
            steamIdentifier = v
            break
        end
    end

    if steamIdentifier then
        exports.oxmysql:execute("SELECT * FROM user_bans WHERE steam_id = ?", {steamIdentifier}, function(data)
            if data[1] then
                local reason = data[1].reason
                if reason == "" then
                    reason = "No Reason Specified"
                end

                deferrals.done("You have been permanently banned | Reason: " .. string.upper(reason));
                CancelEvent()
            else
                -- deferrals.done();
                if GetConvarInt('logs_enabled', 0) == 1 then
                    -- local LogInfo =  GetPlayerName(player).. " is loading into the server"
                    -- exports['comet-base']:DiscordLog("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", player, "Player Joining", "", LogInfo)
                end
            end
        end)
    else

    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
