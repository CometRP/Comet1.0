local plyPed = PlayerPedId()
local xhairActive = false
local disableXhair = true

exports("usingXHair", function() return disableXhair end)

RegisterNUICallback('hideReticle', function()
    Wait(50)
    disableXhair = not disableXhair
end) 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        plyPed = PlayerPedId()
        isArmed = IsPedArmed(plyPed, 7)

        if isArmed and disableXhair then
            if IsPlayerFreeAiming(PlayerId()) then
                if not xhairActive then
                    SendNUIMessage({action = "xhairShow"})
                    xhairActive = true
                end
            elseif xhairActive then
                SendNUIMessage({action = "xhairHide"})
                xhairActive = false
            end
        elseif IsPedInAnyVehicle(plyPed, false) then
            if xhairActive then
                SendNUIMessage({action = "xhairHide"})
                xhairActive = false
            end
        else
            if xhairActive then
                SendNUIMessage({action = "xhairHide"})
                xhairActive = false
            end
        end
    end
end)