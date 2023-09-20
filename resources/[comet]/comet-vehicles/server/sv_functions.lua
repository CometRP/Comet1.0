Callback = nil
AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback"
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
    end)
end)

Vehicles.SpawnVehicle = function(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

CreateThread(function()
    while not Callback do
        Citizen.Wait(25)
    end
    Callback.Register("comet-vehicles:SpawnVehicle", function(model, coords, warp)
        local veh = Vehicles.SpawnVehicle(source, model, coords, warp)
        return NetworkGetNetworkIdFromEntity(veh)
    end)
end)



-- AddEventHandler("comet-base:refreshComponents", function()
--     exports['comet-base']:LoadComponents({
--         "SQL"
--     }, function(pass)
--         if not pass then return end
--         SQL = exports['comet-base']:FetchComponent("SQL")
--     end)
-- end)


-- function QBCore.Functions.SpawnVehicle(source, model, coords, warp)
--     local ped = GetPlayerPed(source)
--     model = type(model) == 'string' and joaat(model) or model
--     if not coords then coords = GetEntityCoords(ped) end
--     local heading = coords.w and coords.w or 0.0
--     local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
--     while not DoesEntityExist(veh) do Wait(0) end
--     if warp then
--         while GetVehiclePedIsIn(ped) ~= veh do
--             Wait(0)
--             TaskWarpPedIntoVehicle(ped, veh, -1)
--         end
--     end
--     while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
--     return veh
-- end