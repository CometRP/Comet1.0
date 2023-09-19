Components.Flags = Components.Flags or {}

RegisterNetEvent("comet-base:flags:get")
AddEventHandler("comet-base:flags:get", function(callID, netID, entityType, flagType)
    local flags, entity = 0

    if entityType == "player" then
        entity = GetPlayerPed(GetPlayerFromServerId(netID))
    else
        entity = NetworkGetEntityFromNetworkId(netID)
    end

    if DoesEntityExist(entity) then
        flags = DecorGetInt(entity, flagType)
    end

    TriggerServerEvent("comet-base:flags:set", callID, netID, flagType, flags)
end)

RegisterNetEvent("comet-base:flags:set")
AddEventHandler("comet-base:flags:set", function(netID, entityType, flagType, flags)
    local entity = nil

    if entityType == "player" then
        entity = GetPlayerPed(GetPlayerFromServerId(netID))
    else
        entity = NetworkGetEntityFromNetworkId(netID)
    end

    if DoesEntityExist(entity) then
        DecorSetInt(entity, flagType, flags)
    end
end)

function NotifyChange(pType, pEntity, pFlag, pState)
    local event = ('comet-base:flags:%s:stateChanged'):format(pType)
    local netId = NetworkGetNetworkIdFromEntity(pEntity)

    -- fml... Maybe we should move player flags to its own category?
    if pType == 'ped' and IsPedAPlayer(pEntity) then
        netId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(pEntity))
    end

    TriggerEvent(event, pEntity, pFlag, pState)
    TriggerServerEvent(event, netId, pFlag, pState)
end

DecorRegister("PedFlags", 3)
DecorRegister("ObjectFlags", 3)
DecorRegister("VehicleFlags", 3)

Components.Flags.SetVehicleFlag = function(vehicle, flag, enabled)
    local mask = Flags["VehicleFlags"][flag]

    if mask ~= nil and DoesEntityExist(vehicle) then
        local field = DecorGetInt(vehicle, "VehicleFlags")

        Components.Sync.DecorSetInt(vehicle, "VehicleFlags", enabled and field | mask or field &~ mask)
        -- DecorSetInt(vehicle, "VehicleFlags", enabled and field | mask or field &~ mask)
        NotifyChange('vehicle', vehicle, flag, enabled)
    end
end

Components.Flags.HasVehicleFlag = function(vehicle, flag)
    local mask = Flags["VehicleFlags"][flag]

    if mask ~= nil and DoesEntityExist(vehicle) then
        local field = DecorGetInt(vehicle, "VehicleFlags")

        return (field & mask) > 0
    end
end

Components.Flags.GetVehicleFlags = function(vehicle)
    local field = DecorGetInt(vehicle, "VehicleFlags")
    local flags = {}

    if field and field >= 0 then
        for flag, mask in pairs(Flags["VehicleFlags"]) do
            flags[flag] = (field & mask) > 0
        end
    end

    return flags
end

Components.Flags.SetVehicleFlags = function(vehicle, flags)
    local field = DecorGetInt(vehicle, "VehicleFlags")

    for flag, enabled in pairs(flags) do
        local mask = Flags["VehicleFlags"][flag]

        if (mask) then
            field = enabled and field | mask or field &~ mask
        end
    end

    Components.Sync.DecorSetInt(vehicle, "VehicleFlags", field)
    -- DecorSetInt(vehicle, "VehicleFlags", field)
end

Components.Flags.SetObjectFlag = function(object, flag, enabled)
    local mask = Flags["ObjectFlags"][flag]

    if mask ~= nil and DoesEntityExist(object) then
        local field = DecorGetInt(object, "ObjectFlags")

        Components.Sync.DecorSetInt(object, "ObjectFlags", enabled and field | mask or field &~ mask)
        NotifyChange('object', object, flag, enabled)
    end
end

Components.Flags.HasObjectFlag = function(object, flag)
    local mask = Flags["ObjectFlags"][flag]

    if mask ~= nil and DoesEntityExist(object) then
        local field = DecorGetInt(object, "ObjectFlags")

        return (field & mask) > 0
    end
end

Components.Flags.GetObjectFlags = function(object)
    local field = DecorGetInt(object, "ObjectFlags")
    local flags = {}

    if field and field >= 0 then
        for flag, mask in pairs(Flags["ObjectFlags"]) do
            flags[flag] = (field & mask) > 0
        end
    end

    return flags
end

Components.Flags.SetObjectFlags = function(object, flags)
    local field = DecorGetInt(object, "ObjectFlags")

    for flag, enabled in pairs(flags) do
        local mask = Flags["ObjectFlags"][flag]

        if (mask) then
            field = enabled and field | mask or field &~ mask
        end
    end

    Components.Sync.DecorSetInt(object, "ObjectFlags", field)
end

Components.Flags.SetPedFlag = function(ped, flag, enabled)
    local mask = Flags["PedFlags"][flag]

    if mask ~= nil and DoesEntityExist(ped) then
        local field = DecorGetInt(ped, "PedFlags")

        DecorSetInt(ped, "PedFlags", enabled and field | mask or field &~ mask)
        NotifyChange('ped', ped, flag, enabled)
    end
end

Components.Flags.HasPedFlag = function(ped, flag)
    local mask = Flags["PedFlags"][flag]

    if mask ~= nil and DoesEntityExist(ped) then
        local field = DecorGetInt(ped, "PedFlags")
        return (field & mask) > 0
    end
end

Components.Flags.GetPedFlags = function(ped)
    local field = DecorGetInt(ped, "PedFlags")
    local flags = {}

    if field and field >= 0 then
        for flag, mask in pairs(Flags["PedFlags"]) do
            flags[flag] = (field & mask) > 0
        end
    end

    return flags
end

Components.Flags.SetPedFlags = function(ped, flags)
    local field = DecorGetInt(ped, "PedFlags")

    for flag, enabled in pairs(flags) do
        local mask = Flags["PedFlags"][flag]

        if (mask) then
            field = enabled and field | mask or field &~ mask
        end
    end

    DecorSetInt(ped, "PedFlags", field)
end