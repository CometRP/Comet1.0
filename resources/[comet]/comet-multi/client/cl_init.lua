LocalPlayer, Events, Util, isPed = nil, nil, nil


RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "LocalPlayer",
        "Events",
        "Util",
        "isPed",
    }, function(pass)
        if not pass then return end
        LocalPlayer = exports['comet-base']:FetchComponent("LocalPlayer")
        Events = exports['comet-base']:FetchComponent("Events")
        Util = exports['comet-base']:FetchComponent("Util")
        isPed = exports['comet-base']:FetchComponent("isPed")
        print(Events)
    end)
end)
