Components.Events = Components.Events or {}
Components.Events.Total = 0
Components.Events.Active = {}

function Components.Events.Trigger(self, event, args, callback)
    local id = Components.Events.Total + 1
    Components.Events.Total = id

    id = event .. ":" .. id

    if Components.Events.Active[id] then return end

    Components.Events.Active[id] = {cb = callback}
    
    TriggerServerEvent("comet-events:listenEvent", id, event, args)
end

RegisterNetEvent("comet-events:listenEvent")
AddEventHandler("comet-events:listenEvent", function(id, data)
    local ev = Components.Events.Active[id]
    
    if ev then
        ev.cb(data)
        Components.Events.Active[id] = nil
    end
end)