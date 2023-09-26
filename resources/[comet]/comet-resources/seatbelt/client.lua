local SeatBelt = false

function IsSeatbeltOn()
    return SeatBelt
end
exports("IsSeatbeltOn", IsSeatbeltOn)

local Seatbelt = function(status)
    if status then
        TriggerEvent("seatbelt",true)
        TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",1.0)
    else
        TriggerEvent("seatbelt",false)
        TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",1.0)
    end
    SeatBelt = status
end

RegisterCommand('seatbelt', function()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if veh then
        local curVehicleClass = GetVehicleClass(veh)

        if curVehicleClass ~= 8
        and curVehicleClass ~= 13
        and curVehicleClass ~= 14
        then Seatbelt(not SeatBelt) end
    end
end, false)

RegisterKeyMapping('seatbelt', 'Toggle seatbelt', 'keyboard', 'B')
TriggerEvent('chat:removeSuggestion', '/seatbelt')

-- crashedalready = false
-- function carCrash(veh)
--     local wheels = {0,1,4,5}
--     for i=1, math.random(4) do
--         local wheel = math.random(#wheels)
--         SetVehicleTyreBurst(veh, wheels[wheel], true, 1000)
--         table.remove(wheels, wheel)
--     end
--     if not crashedalready then
--         SetVehicleEngineHealth(veh, 300)
--         SetVehicleEngineOn(veh, true, true, true)
--         crashedalready = true
--     print(crashedalready)
--     elseif crashedalready then
--         SetVehicleEngineHealth(veh, 0)
--         SetVehicleEngineOn(veh, false, true, true)
--         crashedalready = false
--     print(crashedalready)
--     end
-- end

CreateThread(function()
    local sleep = 1000
    local speedBuffer, velBuffer  = {0.0,0.0}, {}

    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            DisplayRadar(true)
            sleep = 1
            local Vehicle = GetVehiclePedIsIn(ped, false)
            -- local Vehicle = GetVehiclePedIsIn(ped, false)
            local VehicleHealth = GetVehicleEngineHealth(Vehicle)
            local Fuel = GetVehicleFuelLevel(Vehicle)
            
        
            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(Vehicle) 

            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(Vehicle)

            if speedBuffer[2] and GetEntitySpeedVector(Vehicle, true).y > 1.0  and speedBuffer[1] > 15 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then			   
                if not SeatBelt then
                    local co = GetEntityCoords(ped)
                    local fw = ForwardValue(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Wait(500)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)                    
                    SeatBelt = false
                end

                local seatPlayerId = {}
                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle)) do
                    if i ~= 1 then
                        if not IsVehicleSeatFree(Vehicle, i-2) then 
                            local otherPlayerId = GetPedInVehicleSeat(Vehicle, i-2) 
                            local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                            local playerServerId = GetPlayerServerId(playerHandle)
                            table.insert(seatPlayerId, playerServerId)
                        end
                    end
                end

                if #seatPlayerId > 0 then TriggerServerEvent("ez-veh:server:EjectPlayer", seatPlayerId, velBuffer[2]) end
                -- carCrash(Vehicle)
                Wait(1000)
            end 
        else
            DisplayRadar(false)
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            sleep = 1000
          
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('seatbelt:client:EjectPlayer')
AddEventHandler('seatbelt:client:EjectPlayer', function(velocity)
    if not SeatBelt then
        local co = GetEntityCoords(Player)
        local fw = Fwv(Player)
        SetEntityCoords(Player, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
        SetEntityVelocity(Player, velocity.x, velocity.y, velocity.z)
        Wait(500)
        SetPedToRagdoll(Player, 1000, 1000, 0, 0, 0, 0)       
        SeatBelt = false  
    end
end)

function ForwardValue(entity)  
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end 