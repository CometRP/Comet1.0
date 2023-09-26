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
    local failed = 0

    -- function restart()
    --     goto test
    -- end

    ::continue::
    local finished = false
    exports['comet-ui']:MemoryMinigame(function(result)
        if result then 
            completed = completed + 1
        else 
            failed = failed + 1
        end
        finished = true
    end)
    while not finished do Wait(0) end 
    finished = false
    print(completed)
    print(failed)
    if failed > 2 then return false end
    if completed > 5 then return true end
    goto continue
end)

RegisterCommand("extras", function()
    for i = 1,14 do 
        SetVehicleExtra(GetVehiclePedIsIn(PlayerPedId(), false), i, 0)
    end
end)

CreateThread(function()
    exports['comet-target']:AddBoxZone("MissionRowDutyClipboard", vector3(441.7989, -982.0529, 30.67834), 0.45, 0.35, {
        name = "MissionRowDutyClipboard",
        heading = 11.0,
        debugPoly = false,
        minZ = 30.77834,
        maxZ = 30.87834,
    }, {
        options = {
            {
                type = "client",
                event = "comet-police:clockIn",
                icon = "fas fa-sign-in-alt",
                label = "Sign In",
            },
            {
                type = "client",
                event = "comet-police:clockOut",
                icon = "fas fa-sign-in-alt",
                label = "Sign Out",
            },
            {
                type = "client",
                event = "comet-police:pager",
                icon = "fas fa-sign-in-alt",
                label = "Pager",
            },
        },
        distance = 2.5
    })
end)