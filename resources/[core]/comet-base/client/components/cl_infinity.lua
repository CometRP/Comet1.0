Components.Infinity = Components.Infinity or {}

local Promises, PlayerCoords, EntityCoords = {}, {}, {}

TriggerServerEvent("comet-base:infinity:player:ready")

RegisterNetEvent('comet-base:infinity:player:coords', function (pCoords)
    PlayerCoords = pCoords
end)

RegisterNetEvent('comet-base:infinity:entity:coords')
AddEventHandler('comet-base:infinity:entity:coords', function (pNetId, pCoords)
    if Promises[pNetId] then
        Promises[pNetId]:resolve(pCoords)
    end
end)

function FetchEntityCoords(pNetId)
    local result = promise:new()
    local timeout = PromiseTimeout(1000)

    Promises[pNetId] = result

    TriggerServerEvent('comet-base:infinity:entity:coords', pNetId)

    local coords = Citizen.Await(promise.first({ timeout, result }))

    EntityCoords[pNetId] = coords

    Citizen.SetTimeout(1000, function()
        EntityCoords[pNetId] = nil
    end)

    Promises[pNetId] = nil

    return coords
end

Components.Infinity.GetPlayerCoords = function (pServerId)
    return PlayerCoords[tonumber(pServerId)]
end

Components.Infinity.DoesPlayerExist = function (pServerId)
    local playerId = GetPlayerFromServerId(tonumber(pServerId))

    if playerId ~= -1 then
        return true
    end
end

Components.Infinity.IsPlayerActive = function (pServerId)
    return PlayerCoords[tonumber(pServerId)] ~= nil
end

Components.Infinity.GetNetworkedCoords = function (pType, pNetId)
    local coords

    if pType == 'player' then
        local playerIndex = GetPlayerFromServerId(pNetId)
        coords = playerIndex == -1 and PlayerCoords[pNetId] or GetEntityCoords(GetPlayerPed(playerIndex))
    else
        local entity = NetworkGetEntityFromNetworkId(pNetId)

        if DoesEntityExist(entity) then
            coords = GetEntityCoords(entity)
        else
            coords = EntityCoords[pNetId] or FetchEntityCoords(pNetId)
        end
    end

    return coords
end

Components.Infinity.GetLocalEntity = function (pType, pNetId)
    local entity

    if pType == 'player' then
        local playerIndex = GetPlayerFromServerId(pNetId)
        entity = playerIndex ~= -1 and GetPlayerPed(playerIndex) or 0
    else
        entity = NetworkGetEntityFromNetworkId(pNetId)
    end

    return entity
end

function PromiseTimeout(time)
    local timeout = promise:new()

    Citizen.SetTimeout(time or 1000, function ()
        timeout:resolve(false)
    end)

    return timeout
end