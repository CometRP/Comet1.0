LocalPlayer, Events, Util = nil, nil, nil


RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "LocalPlayer",
        "Events",
        "Util",
    }, function(pass)
        if not pass then return end
        LocalPlayer = exports['comet-base']:FetchComponent("LocalPlayer")
        Events = exports['comet-base']:FetchComponent("Events")
        Util = exports['comet-base']:FetchComponent("Util")
    end)
end)
