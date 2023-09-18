exports("SetInfo", function(Title, Description)
    exports['comet-ui']:SendUIMessage("Info", "SetInfoData", {
        Title = Title,
        Description = Description,
    })
end)

exports("HideInfo", function()
    exports['comet-ui']:SendUIMessage("Info", "HideInfo")
end)

RegisterNetEvent('comet-ui/client/ui-reset', function()
    exports['comet-ui']:HideInfo()
end)