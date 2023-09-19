LocalPlayer = nil
RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "LocalPlayer",
    }, function(pass)
        if not pass then return end
        LocalPlayer = exports['comet-base']:FetchComponent("LocalPlayer")
    end)
end)
