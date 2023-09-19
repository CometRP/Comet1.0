Components.Sync = Components.Sync or {}

TriggerServerEvent("comet-base:sync:ready")

RegisterNetEvent("comet-base:sync:execute", function(native, netID, ...)
    local entity = NetworkGetEntityFromNetworkId(netID)
    
    if not DoesEntityExist(entity) then
        return TriggerServerEvent('comet-base:sync:execute:aborted', native, netID)
    end

    if Components.Sync[native] then
        Components.Sync[native](entity, ...)
    end
end)

function RequestSyncExecution(native, entity, ...)
    if DoesEntityExist(entity) then
        TriggerServerEvent('sync:request', GetInvokingResource(), native, GetPlayerServerId(NetworkGetEntityOwner(entity)), NetworkGetNetworkIdFromEntity(entity), ...)
    end
end

function SyncedExecution(native, entity, ...)
    if NetworkHasControlOfEntity(entity) then
        Components.Sync[native](entity, ...)
    else
        RequestSyncExecution(native, entity, ...)
    end
end

exports("SyncedExecution", SyncedExecution)

--
-- better sync method
-- prob wanna use this instead
-- onesync needs to be better
--
-- options table:
-- - entity = { 1, 2, 4 }
-- - - table key IDs for network conversion

function syncNative(name, netEntity, options, ...)
    TriggerServerEvent("comet-base:server:executeSyncNative", name, netEntity, options, table.pack(...))
end
exports("syncNative", syncNative)

RegisterNetEvent("comet-base:clinet:executeSyncNative", function(native, netEntity, options, args)
    if options and options.entity then
        for _, v in pairs(options.entity) do
            args[v] = NetworkGetEntityFromNetworkId(args[v])
        end
    end
    if native == "0xB736A491E64A32CF" then
        SetEntityAsNoLongerNeeded(args[1])
        return
    end
    local result = Citizen.InvokeNative(native, table.unpack(args))
end)

Components.Sync.DeleteVehicle = function (vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        DeleteVehicle(vehicle)
    else
        RequestSyncExecution("DeleteVehicle", vehicle)
    end
end

Components.Sync.DeleteEntity = function (entity)
    if NetworkHasControlOfEntity(entity) then
        DeleteEntity(entity)
    else
        RequestSyncExecution("DeleteEntity", entity)
    end
end

Components.Sync.DeletePed = function (ped)
    if NetworkHasControlOfEntity(ped) then
        DeletePed(ped)
    else
        RequestSyncExecution("DeletePed", ped)
    end
end

Components.Sync.DeleteObject = function (object)
    if NetworkHasControlOfEntity(object) then
        DeleteObject(object)
    else
        RequestSyncExecution("DeleteObject", object)
    end
end

Components.Sync.SetVehicleFuelLevel = function (vehicle, level)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleFuelLevel(vehicle, level)
    else
        RequestSyncExecution("SetVehicleFuelLevel", vehicle, level)
    end
end

Components.Sync.SetVehicleTyreBurst = function (vehicle, index, onRim, p3)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyreBurst(vehicle, index, onRim, p3)
    else
        RequestSyncExecution("SetVehicleTyreBurst", vehicle, index, onRim, p3)
    end
end

Components.Sync.SetVehicleDoorShut = function (vehicle, doorIndex, closeInstantly)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
    else
        RequestSyncExecution("SetVehicleDoorShut", vehicle, doorIndex, closeInstantly)
    end
end

Components.Sync.SetVehicleDoorOpen = function (vehicle, doorIndex, loose, openInstantly)
  if NetworkHasControlOfEntity(vehicle) then
      SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
  else
      RequestSyncExecution("SetVehicleDoorOpen", vehicle, doorIndex, loose, openInstantly)
  end
end

Components.Sync.SetVehicleDoorBroken = function (vehicle, doorIndex, deleteDoor)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
    else
        RequestSyncExecution("SetVehicleDoorBroken", vehicle, doorIndex, deleteDoor)
    end
end

Components.Sync.SetVehicleEngineOn = function(vehicle, value, instantly, noAutoTurnOn)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleEngineOn(vehicle, value, instantly, noAutoTurnOn)
    else
        RequestSyncExecution("SetVehicleEngineOn", vehicle, value, instantly, noAutoTurnOn)
    end
end

Components.Sync.SetVehicleUndriveable = function(vehicle, toggle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleUndriveable(vehicle, toggle)
    else
        RequestSyncExecution("SetVehicleUndriveable", vehicle, toggle)
    end
end

Components.Sync.SetVehicleHandbrake = function(vehicle, toggle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleHandbrake(vehicle, toggle)
    else
        RequestSyncExecution("SetVehicleHandbrake", vehicle, toggle)
    end
end

Components.Sync.DecorSetFloat = function (entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetFloat(entity, propertyName, value)
    else
        RequestSyncExecution("DecorSetFloat", entity, propertyName, value)
    end
end

Components.Sync.DecorSetBool = function (entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetBool(entity, propertyName, value)
    else
        RequestSyncExecution("DecorSetBool", entity, propertyName, value)
    end
end

Components.Sync.DecorSetInt = function (entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetInt(entity, propertyName, value)
    else
        RequestSyncExecution("DecorSetInt", entity, propertyName, value)
    end
end

Components.Sync.DetachEntity = function (entity, p1, collision)
    if NetworkHasControlOfEntity(entity) then
        DetachEntity(entity, p1, collision)
    else
        RequestSyncExecution("DetachEntity", entity, p1, collision)
    end
end

Components.Sync.SetEntityCoords = function (entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    if NetworkHasControlOfEntity(entity) then
        SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    else
        RequestSyncExecution("SetEntityCoords", entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    end
end

Components.Sync.SetEntityHeading = function (entity, heading)
    if NetworkHasControlOfEntity(entity) then
        SetEntityHeading(entity, heading)
    else
        RequestSyncExecution("SetEntityHeading", entity, heading)
    end
end

Components.Sync.FreezeEntityPosition = function (entity, freeze)
    if NetworkHasControlOfEntity(entity) then
        FreezeEntityPosition(entity, freeze)
    else
        RequestSyncExecution("FreezeEntityPosition", entity, freeze)
    end
end

Components.Sync.SetVehicleDoorsLocked = function (entity, status)
    if NetworkHasControlOfEntity(entity) then
        SetVehicleDoorsLocked(entity, status)
    else
        RequestSyncExecution("SetVehicleDoorsLocked", entity, status)
    end
end

Components.Sync.NetworkExplodeVehicle = function (vehicle, isAudible, isInvisible, p3)
    if NetworkHasControlOfEntity(vehicle) then
        NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3)
    else
        RequestSyncExecution("NetworkExplodeVehicle", vehicle, isAudible, isInvisible, p3)
    end
end

Components.Sync.SetBoatAnchor = function (vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetBoatAnchor(vehicle, state)
    else
        RequestSyncExecution("SetBoatAnchor", vehicle, state)
    end
end

Components.Sync.SetBoatFrozenWhenAnchored = function (vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetBoatFrozenWhenAnchored(vehicle, state)
    else
        RequestSyncExecution("SetBoatFrozenWhenAnchored", vehicle, state)
    end
end

Components.Sync.SetForcedBoatLocationWhenAnchored = function (vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetForcedBoatLocationWhenAnchored(vehicle, state)
    else
        RequestSyncExecution("SetForcedBoatLocationWhenAnchored", vehicle, state)
    end
end

Components.Sync.SetVehicleOnGroundProperly = function (vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleOnGroundProperly(vehicle)
    else
        RequestSyncExecution("SetVehicleOnGroundProperly", vehicle)
    end
end

Components.Sync.SetVehicleTyreFixed = function (vehicle, index)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyreFixed(vehicle, index)
    else
        RequestSyncExecution("SetVehicleTyreFixed", vehicle, index)
    end
end

Components.Sync.SetVehicleEngineHealth = function (vehicle, health)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleEngineHealth(vehicle, health + 0.0)
    else
        RequestSyncExecution("SetVehicleEngineHealth", vehicle, health  + 0.0)
    end
end

Components.Sync.SetVehicleBodyHealth = function (vehicle, health)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleBodyHealth(vehicle, health + 0.0)
    else
        RequestSyncExecution("SetVehicleBodyHealth", vehicle, health  + 0.0)
    end
end

Components.Sync.SetVehicleDeformationFixed = function (vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDeformationFixed(vehicle)
    else
        RequestSyncExecution("SetVehicleDeformationFixed", vehicle)
    end
end

Components.Sync.SetVehicleFixed = function (vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleFixed(vehicle)
    else
        RequestSyncExecution("SetVehicleFixed", vehicle)
    end
end

-- Components.Sync.SetVehicleDeformationFixed = function (vehicle)
--     if NetworkHasControlOfEntity(vehicle) then
--         SetVehicleDeformationFixed(vehicle)
--     else
--         RequestSyncExecution("SetVehicleDeformationFixed", vehicle)
--     end
-- end

Components.Sync.SetEntityAsNoLongerNeeded = function (entity)
    if NetworkHasControlOfEntity(entity) then
        SetEntityAsNoLongerNeeded(entity)
    else
        RequestSyncExecution("SetEntityAsNoLongerNeeded", entity)
    end
end

Components.Sync.SetPedKeepTask = function (ped, keepTask)
    if NetworkHasControlOfEntity(ped) then
        SetPedKeepTask(ped, keepTask)
    else
        RequestSyncExecution("SetPedKeepTask", ped, keepTask)
    end
end

-- Components.Sync.SetVehicleMods = function (vehicle, mods)
--     if NetworkHasControlOfEntity(vehicle) then
--         exports['comet-vehicles']:SetVehicleMods(vehicle, mods)
--     else
--         RequestSyncExecution("SetVehicleMods", vehicle, mods)
--     end
-- end

-- Components.Sync.SetVehicleAppearance = function (vehicle, appearance)
--     if NetworkHasControlOfEntity(vehicle) then
--         exports['comet-vehicles']:SetVehicleAppearance(vehicle, appearance)
--     else
--         RequestSyncExecution("SetVehicleAppearance", vehicle, appearance)
--     end
-- end

Components.Sync.SetVehicleTyresCanBurst = function (vehicle, enabled)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyresCanBurst(vehicle, enabled)
    else
        RequestSyncExecution("SetVehicleTyresCanBurst", vehicle, enabled)
    end
end