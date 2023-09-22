RegisterNUICallback("updateCamera", function(data)
    exports["comet-clothingUI"]:updateCamera(data)
end)

RegisterNUICallback("rotateCharacter", function(data)
    local ped = PlayerPedId()

    local currentHeading = GetEntityHeading(ped)
    SetEntityHeading(ped, currentHeading + (data*3))
end)


