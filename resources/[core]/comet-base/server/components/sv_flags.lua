RegisterServerEvent("comet-flags:set")
AddEventHandler("comet-flags:set", function(callID, netID, flagType, flags)
    local src = source
    local entity = NetworkGetEntityFromNetworkId(netID)
    local eType = GetEntityType(entity)
    TriggerClientEvent("comet-flags:set", -1, netID, eType, flagType, flags)
end)