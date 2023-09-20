exports("SetInfo", function(Title, Description)
    exports['comet-ui']:SendUIMessage("Info", "SetInfoData", {
        Title = Title,
        Description = Description,
    })
end)
UiComponents.SetInfo = exports['comet-ui']:SetInfo

exports("HideInfo", function()
    exports['comet-ui']:SendUIMessage("Info", "HideInfo")
end)
UiComponents.HideInfo = exports['comet-ui']:HideInfo

RegisterNetEvent('comet-ui:clien:/ui-reset', function()
    exports['comet-ui']:HideInfo()
end)