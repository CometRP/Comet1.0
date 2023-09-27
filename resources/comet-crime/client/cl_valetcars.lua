--[[
    Plan:
    - sign on to job

--]]

ValetCrime = ValetCrime or {}
ValetCrime.vehicle = nil

RegisterNetEvent("comet-crime:valet:signin", function()
    CurrentCrime.job = "valet"
    InitValet()
end)

function InitValet()
    CreateThread(function()
        local isNearCheck = false
        local sleep = 60000
        while CurrentCrime.job == "valet" do
            local coords = GetEntityCoords(PlayerPedId())
            local valetPlace = vector3(-1216.24, -190.17, 38.53)
            local dist = #(coords - valetPlace)
            if dist <= 40.0 then 
                if not isNearCheck then 
                    sleep = 60000
                    isNearCheck = true

                    -- print("cont")
                    exports['comet-ui']:Notify("valet", "Stay around here, don't be suspicous..", "success")
                    -- exports['comet-assets']:SetDensity('Vehicle', 0.8)
                end
            elseif isNearCheck then 
                sleep = 50
                isNearCheck = false
                -- print("cont222")
                exports['comet-ui']:Notify("valet", "You went too far away, please return..", "error")
                -- exports['comet-assets']:SetDensity('Vehicle', 0.55)
            end

            if not ValetCrime.vehicle and isNearCheck then 
                local Random = math.random(1, 100)
                if Random <= 75 then
                    exports['comet-ui']:Notify("valet", "You got a car coming", "success")
                    TriggerServerEvent('comet-crime:valet:spawn')
                end
            end
         
            Wait(sleep)
        end
    end)
end


RegisterNetEvent("baseevents:enteredVehicle", function(vehicle, CurrentSeat, name, class, model)
    print(model)
    local model2 = GetEntityModel(vehicle)
    -- if model2 ~= GetHashKey("bison") then return end
    ValetCrime.vehicle = vehicle
end)

RegisterCommand("getjob", function()
    print(CurrentCrime.job)
    exports['comet-ui']:Notify("valet", "You got a car coming", "success")
    TriggerServerEvent('comet-crime:valet:spawn')
end)

RegisterNetEvent('comet-crime:valet:set-veh-data', function(NetId, Clear)
    if Clear then
        ValetCrime.vehicle = nil
    else
        while not NetworkDoesEntityExistWithNetworkId(NetId) do
            Citizen.Wait(300)
        end

        local Vehicle = NetworkGetEntityFromNetworkId(NetId)
        ValetCrime.vehicle = Vehicle

        Citizen.SetTimeout(20000, function()
            if ValetCrime.vehicle == Vehicle then
                -- exports['comet-ui']:Notify("valet", "Yo you taking too long bro..", "error")
                -- ValetCrime.vehicle = nil
                local Ped = GetPedInVehicleSeat(Vehicle, -1)
                -- TaskVehicleDriveWander(Ped, Vehicle, 30.0, 786603)
                TaskGoStraightToCoord(Ped, -1208.94, -193.62, 39.32, 1, -1, 236.99, 0.0)
                Citizen.SetTimeout(20000, function()
                    DeletePed(Ped)
                end)
            end
        end)
    end
end)

local inZone = false
AddEventHandler("comet-base:polyzone:enter", function(pZone, pData)
    if pZone == "valetdropoff" then
        if not inZone then 
            inZone = true
            if GetVehiclePedIsUsing(PlayerPedId()) == ValetCrime.vehicle then
                exports['comet-ui']:Notify("valet", "Leave the vehicle here, You'll get paid", "success")
                print("Leave the vehicle here, You'll get paid")
            end
        end
    end
end)

AddEventHandler("comet-base:polyzone:exit", function(pZone, pData)
    if pZone == "valetdropoff" then
        if inZone then 
            if GetVehiclePedIsUsing(PlayerPedId()) == ValetCrime.vehicle then
                exports['comet-ui']:Notify("valet", "i thought u was leaving da vehicle..?", "error")
                print("testtest")
            end
            inZone = false
        end
    end
end)

RegisterNetEvent('baseevents:leftVehicle', function(PreviousVehicle, PreviousSeat, name, class, model)
    if ValetCrime.vehicle then 
        print(PreviousVehicle == ValetCrime.vehicle)
        if PreviousVehicle == ValetCrime.vehicle then
            print("test", inZone)
            if inZone then
                SetVehicleDoorsLocked(ValetCrime.vehicle, 2)
                exports['comet-ui']:Notify("valet", "Payment coming through.", "success")
                Citizen.SetTimeout(20000, function()
                    SetEntityAsMissionEntity(ValetCrime.vehicle, true, true)
                    DeleteVehicle(ValetCrime.vehicle)
                    TriggerServerEvent("NetworkGetNetworkIdFromEntity(Entity)")
                end)
            end
        end
    end
end)

RegisterNetEvent('comet-crime:valet:veh-drive-to-coord', function(NetId, Coords)
    while not NetworkDoesEntityExistWithNetworkId(NetId) do
        Citizen.Wait(300)
    end

    Citizen.SetTimeout(2000, function()
        local Vehicle = NetworkGetEntityFromNetworkId(NetId)
        local Ped = GetPedInVehicleSeat(Vehicle, -1)
        TaskVehicleDriveToCoord(Ped, Vehicle, Coords.x, Coords.y, Coords.z, 10.0, 1, GetEntityModel(Vehicle), 786603, 2.0, true)
    end)
end)

CreateThread(function()
    TriggerServerEvent("comet-crime:valet:requestConfig")
end)

local inputOptions

RegisterNetEvent("comet-crime:valet:config", function(config)
    inputOptions = config
end)

RegisterNetEvent("comet-crime:valet:reqeust", function()
    local dialog = exports['comet-input']:ShowInput({
        header = "Illegal Car Dealer",
        submitText = "Request Vehicle",
        inputs = {
            {
                text = "Some Select",
                name = "veh",
                type = "select",
                options = inputOptions,
                -- default = 'other3', -- Default select option, must match a value from above, this is optional
            }
        },
    })

    if dialog ~= nil then
        TriggerServerEvent("comet-crime:valet:requestVehicle", dialog.veh)
        for k,v in pairs(dialog) do
            print(k .. " : " .. v)
        end
    end
end)