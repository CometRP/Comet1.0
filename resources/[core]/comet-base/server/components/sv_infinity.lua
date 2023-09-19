Components.Infinity = {}

pCoordsActivePlayers = {}

RegisterServerEvent('comet-base:infinity:player:ready', function()
    local src = source
    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)
    pCoordsActivePlayers[src] = playerCoords    
    TriggerClientEvent('comet-base:infinity:player:coords', -1, playerCoords)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local putitinmyasspls = GetEntityCoords(source)

        TriggerClientEvent('comet-base:infinity:player:coords', -1, putitinmyasspls)
        -- TriggerEvent("comet-base:updatecoords", putitinmyasspls.x, putitinmyasspls.y, putitinmyasspls.z)

        if #pCoordsActivePlayers > 0 then
            for k,v in pairs(pCoordsActivePlayers) do
                if v ~= nil then
                    local ped = GetPlayerPed(k)
                    local playerCoords = GetEntityCoords(ped)
                    pCoordsActivePlayers[k] = playerCoords
                end
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    if #pCoordsActivePlayers > 0 then
        pCoordsActivePlayers[src] = nil
    end
end)

Components.Infinity.GetPlayerCoords = function(serverid)
    if pCoordsActivePlayers[serverid] then
        return pCoordsActivePlayers[serverid]
    else
        return false
    end
end


Components.Infinity.GetNearbyPlayers = function(pCoords, pDistance)
    local pData = pCoordsActivePlayers
    local returndata = {}
    for pPlayer,COORD in pairs(pData) do
        if #(vector3(pCoords.x,pCoords.y,pCoords.z) - vector3(COORD.x,COORD.y,COORD.z)) < pDistance then
            table.insert( returndata, pPlayer )
        end
    end
    return returndata
end
