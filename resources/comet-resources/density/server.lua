RegisterNetEvent("density:peds:rogue")
AddEventHandler("density:peds:rogue", function(toDelete)
    local src = source

    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = exports["comet-base"]:FetchComponent("Infinity").GetNearbyPlayers(coords, 250)

    for i, v in ipairs(players) do
        TriggerClientEvent("density:peds:rogue:delete", v, toDelete)
    end
end)