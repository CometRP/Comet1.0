RegisterServerEvent("comet-base:sync:ready", function()
    -- do nothing
end)

RegisterServerEvent("sync:request", function(native, netID, ...)
    TriggerClientEvent("sync:execute", -1, native, netID, ...)
end)

RegisterServerEvent("sync:execute:aborted", function(native, netID)
    -- do nothing
end)

RegisterServerEvent("comet-base:server:executeSyncNative", function(native, netEntity, options, args)
    TriggerClientEvent("comet-base:client:ExecuteSyncNative", -1, native, netEntity, options, args)
end)