Components.Commands = Components.Commands or {}

RegisterNetEvent("comet-commands:meCommand")
AddEventHandler("comet-commands:meCommand", function(user, msg)
    if DoesPlayerExist(user) then
        local monid = PlayerId()
        local sonid = GetPlayerFromServerId(user)

        if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 8.0 and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(sonid), 17 ) then
            TriggerEvent('DoHudTextCoords', msg, GetPlayerPed(sonid))
        end
    end
end)