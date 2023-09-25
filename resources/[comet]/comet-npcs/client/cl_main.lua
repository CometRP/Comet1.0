_handler = _npcsHandler:new()

Citizen.CreateThread(function()
    _handler:startThread(500)
end)

-- TODO: Better integration with external scripts and animation handler

function GetNPC(id)
    if not _handler:npcExists(id) then return end
    return _handler.npcs[id]['npc']
end

exports('GetNPC', GetNPC)

function RegisterNPC(data)
    if not _handler:npcExists(data.id) then
        local npc = _npcNPC:new(data.id, data.pedType, data.model, data.position, (type(data.appearance) == 'string' and json.decode(data.appearance) or data.appearance), data.animation, data.networked, data.settings, data.flags, data.scenario, data.blip, data.target)

        _handler:addNPC(npc, data.distance)

        return npc
    else
        _handler.npcs[data.id]['npc']['position'] = data.position

        return _handler.npcs[data.id]['npc']
    end
end

exports('RegisterNPC', RegisterNPC)

function RemoveNPC(id)
    if not _handler:npcExists(id) then return end
    _handler:removeNPC(id)
end

exports('RemoveNPC', RemoveNPC)

function DisableNPC(id)
    if not _handler:npcExists(id) then return end
    _handler:disableNPC(id)
end

exports('DisableNPC', DisableNPC)

function EnableNPC(id)
    if not _handler:npcExists(id) then return end
    _handler:enableNPC(id)
end

exports('EnableNPC', EnableNPC)

function UpdateNPCData(id, key, value)
    if not _handler:npcExists(id) then return end
    _handler.npcs[id]['npc'][key] = value
end

exports('UpdateNPCData', UpdateNPCData)

function FindNPCByHash(hash)
    local found, npc = false

    for _, data in pairs(_handler.npcs) do
        if GetHashKey(data.npc.id) == hash then
            found, npc = true, data.npc
            break
        end
    end

    return found, npc
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for _, data in pairs(_handler.npcs) do
        data['npc']:delete()
    end
end)