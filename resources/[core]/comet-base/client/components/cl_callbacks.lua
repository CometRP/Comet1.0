Components.Callback = {}

local res, promises, functions, callIden = GetCurrentResourceName(), {}, {}, 0

paramPacker = function(...)
    local params, pack = {...}, {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end
    return pack
end

paramUnpacker = function(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]['param'], paramUnpacker(params, idx + 1)
    end
end

unpacker = function(params, index)
    local idx = index or 1

    if idx <= 15 then return params[idx]['param'], unpacker(params, idx + 1) end
end

clearPromise = function(callId)
    Citizen.SetTimeout(5000, function()
        promises[callId] = nil
    end)
end

Components.Callback.Execute = function(name, ...)
    local callId, solved = callIden, false
    callIden = callIden + 1

    promises[callId] = promise:new()
    TriggerServerEvent('comet-base:server:callback', res, name, callId, paramPacker(...))

    Citizen.SetTimeout(20000, function()
        if not solved then
            promises[callId]:resolve({nil})
        end
    end)
    local response = Citizen.Await(promises[callId])
    solved = true
    clearPromise(callId)

    return paramUnpacker(response)
end

RegisterNetEvent('comet-base:client:callback', function(origin, callId, response)
    if res == origin and promises[callId] then
        promises[callId]:resolve(response)
    end
end)