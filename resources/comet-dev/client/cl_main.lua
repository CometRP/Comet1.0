RegisterCommand("sv", function(source,args)
    local ped = PlayerPedId()
    local hash = GetHashKey(args[1])
    local veh = GetVehiclePedIsUsing(ped)
    if not IsModelInCdimage(hash) then return end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    if IsPedInAnyVehicle(ped) then
        TriggerEvent("wv-keys:remove",GetVehicleNumberPlateText(veh))
        DeleteVehicle(veh)
    end

    local vehicle = CreateVehicle(hash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    SetVehicleModKit(vehicle, 0)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetModelAsNoLongerNeeded(hash)
    TriggerEvent("wv-keys:addNew", vehicle, GetVehicleNumberPlateText(vehicle))
end)

RegisterCommand("ui-test", function()
    local completed = 0

    -- function restart()
    --     goto test
    -- end

    ::test::
    local finished = false
    exports['comet-ui']:MemoryMinigame(function(result)
        if result then 
            finished = true
            completed = completed + 1
        end
    end)
    while not finished do Wait(0) end 
    finished = false
    print(completed)
    if completed < 5 then 
        goto test
    end
   
end)

RegisterCommand("extras", function()
    for i = 1,14 do 
        SetVehicleExtra(GetVehiclePedIsIn(PlayerPedId(), false), i, 0)
    end
end)