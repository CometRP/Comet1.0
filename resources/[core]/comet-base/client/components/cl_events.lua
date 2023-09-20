-- Player load and unload handling
-- New method for checking if logged in across all scripts (optional)
-- if LocalPlayer.state['isLoggedIn'] then

-- QBCore:Client:OnPlayerLoaded
RegisterNetEvent('comet-base:playerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    if not QBConfig.Server.PVP then return end
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end)

-- QBCore:Client:OnPlayerUnload
RegisterNetEvent('comet-base:playerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

-- QBCore:Client:PvpHasToggled
RegisterNetEvent('comet-base:pvpToggle', function(pvp_state)
    SetCanAttackFriendly(PlayerPedId(), pvp_state, false)
    NetworkSetFriendlyFireOption(pvp_state)
end)

-- QBCore:Player:SetPlayerData
RegisterNetEvent('comet-base:setPlayerData', function(val)
    Components.PlayerData = val
end)

-- QBCore:Player:UpdatePlayerData
RegisterNetEvent('comet-base:updatePlayerData', function()
    -- TriggerServerEvent('QBCore:UpdatePlayer')
    TriggerServerEvent('comet-base:updatePlayer')
end)

-- Teleport Commands

RegisterNetEvent('comet-base:teleportToPlayer', function(coords)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('comet-base:teleportToCoords', function(x, y, z, h)
    local ped = PlayerPedId()
    SetPedCoordsKeepVehicle(ped, x, y, z)
    SetEntityHeading(ped, h or GetEntityHeading(ped))
end)

RegisterNetEvent('comet-base:goToMarker', function()
    local ped = PlayerPedId()
    local blip = GetFirstBlipInfoId(8)
    if DoesBlipExist(blip) then
        local blipCoords = GetBlipCoords(blip)
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(ped, blipCoords.x, blipCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(blipCoords.x, blipCoords.y, height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(ped, blipCoords.x, blipCoords.y, height + 0.0)
                break
            end
            Wait(0)
        end
    end
end)

RegisterNetEvent('comet-base:spawnVehicle', function(model)
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local w = GetEntityHeading(ped)
    local netId = Components.Callback.Execute("comet-vehicles:SpawnVehicle", model, vector4(x, y, z, w), true)
    local veh = NetToVeh(netId)
end)

RegisterNetEvent('comet-base:deleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        SetEntityAsMissionEntity(veh, true, true)
        Components.Sync.DeleteVehicle(veh)
    else
        local entity = Components.Player.GetEntityInFront(5.0, ped)

        if DoesEntityExist(entity) then
            Components.Sync.DeleteVehicle(entity)
    
            print(("[COMET-BASE] Delete Vehicle | Entity: %s"):format(entity))
        end
    end
end)