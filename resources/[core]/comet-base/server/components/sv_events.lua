Components.Events = Components.Events or {}
Components.Events.Registered = Components.Events.Registered or {}

RegisterServerEvent("comet-events:listenEvent")
AddEventHandler("comet-events:listenEvent", function(id, name, args)
    local src = source

    if not Components.Events.Registered[name] then return end

    Components.Events.Registered[name].f(Components.Events.Registered[name].mod, args, src, function(data)
        TriggerClientEvent("comet-events:listenEvent", src, id, data)
    end)
end)

function Components.Events.AddEvent(self, module, func, name)
    Components.Events.Registered[name] = {
        mod = module,
        f = func
    }
end