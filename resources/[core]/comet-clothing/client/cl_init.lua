LocalPlayer, PolyZone = nil, nil
RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "LocalPlayer",
        "PolyZone",
    }, function(pass)
        if not pass then return end
        LocalPlayer = exports['comet-base']:FetchComponent("LocalPlayer")
        PolyZone = exports['comet-base']:FetchComponent("PolyZone")
    end)
end)
