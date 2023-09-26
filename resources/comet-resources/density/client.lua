function tableContains(tbl, value)
    for k, v in pairs(tbl) do
      if v == value then return true end
    end
    return false
end
  

DecorRegister('ScriptedPed', 2)

local Densitities = {}

local density = 0.8
local pedDensity = 1.0
local IsSpeeding = false
local IsDriver = false

local disabledRogue = false
local disabledDensity = false

CreateThread(function()
  while true do
    local vehDensity = IsSpeeding and (IsDriver and 0.1 or 0.0) or density

    if disabledDensity then vehDensity = 1.0 end

    SetParkedVehicleDensityMultiplierThisFrame(pedDensity)
    SetVehicleDensityMultiplierThisFrame(vehDensity)
    SetRandomVehicleDensityMultiplierThisFrame(vehDensity)
    SetPedDensityMultiplierThisFrame(pedDensity)
    SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity) -- Walking ezC Density
    Wait(0)
  end
end)

function RegisterDensityReason(pReason, pPriority)
  Densitities[pReason] = { reason = pReason, priority = pPriority, level = -1, active = false }
end

exports('RegisterDensityReason', RegisterDensityReason)

function ChangeDensity(pReason, pLevel)
  if not Densitities[pReason] then return end

  Densitities[pReason]['level'] = pLevel

  local level = Density.populationDensity
  local priority

  for _, reason in pairs(Densitities) do
    if reason.level ~= -1 and (not priority or priority < reason.priority) then
      priority = reason.priority
      level = reason.level
    end
  end


  -- print('density', level)

  density = level + 0.0
end

exports('ChangeDensity', ChangeDensity)
-- exports['comet-resources']:ChangeDensity()

AddEventHandler('pausePopulation', function(pPause)
  density = pPause and 0.0 or Density.populationDensity
  print('pausing polulation', density)
end)

AddEventHandler('density:disable', function (pDensity, pRogue)
    disabledDensity = pDensity
    disabledRogue = pRogue
end)

local MarkedPeds = {}
local RequiredChecks = 4

function IsModelValid(ped)
  local eType = GetPedType(ped)
  return eType ~= 0 and eType ~= 1 and eType ~= 3 and eType ~= 28 and not IsPedAPlayer(ped)
end

function IsPedValid(ped)
  local isScripted = DecorExistOn(ped, 'ScriptedPed')

  return not isScripted and IsModelValid(ped) and not IsEntityAMissionEntity(ped) and NetworkGetEntityIsNetworked(ped) and not IsPedDeadOrDying(ped, 1)  and IsPedStill(ped) and IsEntityStatic(ped) and not IsPedInAnyVehicle(ped) and not IsPedUsingAnyScenario(ped)
end

Citizen.CreateThread(function()
    while true do
      local idle = 2000
      local success

      if not disabledRogue then
        local handle, ped = FindFirstPed()

        repeat
            if IsPedValid(ped) and not MarkedPeds[ped] then
              MarkedPeds[ped] = 1
            end

            success, ped = FindNextPed(handle)
        until not success

        EndFindPed(handle)
      end

      Citizen.Wait(idle)
    end
end)

function DeleteRoguePed(pPed)
  local owner = NetworkGetEntityOwner(pPed)

  if owner == -1 or owner == PlayerId() then
    DeleteEntity(pPed)
  else
    local netId = NetworkGetNetworkIdFromEntity(pPed)

    return { netId = netId, owner = GetPlayerServerId(owner)}
  end
end

Citizen.CreateThread(function()
    while true do
      local idle = 3000

      local toDelete = {}
      local playerCoords = GetEntityCoords(PlayerPedId())

      for ped, count in pairs(MarkedPeds) do
        if ped and DoesEntityExist(ped) and IsPedValid(ped) then
          local entitycoords = GetEntityCoords(ped)

          if count >= RequiredChecks and #(entitycoords - playerCoords) <= 100.0 then

            local deleteInfo = DeleteRoguePed(ped)

            if deleteInfo then
              toDelete[#toDelete+1] = deleteInfo
            end
          end

          MarkedPeds[ped] = count + 1
        else
          MarkedPeds[ped] = nil
        end
      end

      if #toDelete > 0 then
        TriggerServerEvent('density:peds:rogue', toDelete)
      end

      Citizen.Wait(idle)
    end
end)

RegisterNetEvent('density:peds:rogue:delete')
AddEventHandler('density:peds:rogue:delete', function(pNetId)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    DeleteEntity(entity)
  end
end)

RegisterNetEvent('density:peds:decor:set')
AddEventHandler('density:peds:decor:set', function (pNetId, pType, pProperty, pValue)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    if pType == 1 then
      DecorSetFloat(entity, pProperty, pValue)
    elseif pType == 2 then
      DecorSetBool(entity, pProperty, pValue)
    elseif pType == 3 then
      DecorSetInt(entity, pProperty, pValue)
    end
  end
end)

AddEventHandler('baseevents:vehicleSpeeding', function (isSpeeding)
  IsSpeeding = isSpeeding
end)

AddEventHandler('baseevents:enteredVehicle', function (currentVehicle, currentSeat)
  IsSpeeding = false
  IsDriver = currentSeat == -1
end)

AddEventHandler('baseevents:leftVehicle', function ()
  IsSpeeding = false
  IsDriver = false
end)


AddEventHandler('baseevents:vehicleChangedSeat', function (currentVehicle, currentSeat)
  IsDriver = currentSeat == -1
end)



local Checking, Ack, Ghosted, Zone, IsSpeeding = {}, {}, {}, nil, false

-- AddEventHandler('comet-resources:loadResource', function (pId)
--     if (pId ~= 'density') then return end

--     if Zone == nil then return end

--     local playerVehicle = Zone.entity

--     Citizen.Wait(1000)

--     Zone:destroy()

--     Zone = EntityZone:Create(playerVehicle, { scale = { Density.antiGhostScaleX, Density.antiGhostScaleY, 5.0 }, debugPoly = Density.antiGhostDebug })
-- end)

AddEventHandler('baseevents:vehicleSpeeding', function (isSpeeding)
    IsSpeeding = isSpeeding

    if not isSpeeding then return end

    Ghosted = {}

    Citizen.CreateThread(function ()
        while IsSpeeding and Zone do
            for vehicle, enabled in pairs(Checking) do

                if not enabled then goto continue end

                local coord = GetEntityCoords(vehicle)

                local inside = Zone:isPointInside(coord)

                if inside and not Ghosted[vehicle] then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    local isPlayer = driver ~= 0 and IsPedAPlayer(driver)
                    if not isPlayer then
                        NetworkConcealEntity(vehicle, true)
                        Ghosted[vehicle] = true
                        if Density.antiGhostYeetVehicles then
                            TriggerEvent('density:yeet', vehicle)
                        end
                    end
                elseif not inside and Ghosted[vehicle] then
                    NetworkConcealEntity(vehicle, false)
                    Ghosted[vehicle] = false
                end

                ::continue::
            end

            Citizen.Wait(IsSpeeding and 0 or 50)
        end

        for vehicle, _ in pairs(Ghosted) do
            NetworkConcealEntity(vehicle, false)
        end
    end)
end)

AddEventHandler('baseevents:enteredVehicle', function (playerVehicle)
    Zone = EntityZone:Create(playerVehicle, { scale = { Density.antiGhostScaleX, Density.antiGhostScaleY, 5.0 }, debugPoly = Density.antiGhostDebug })

    Ack, Checking, Ghosted = {}, {}, {}

    Citizen.CreateThread(function ()
        local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        while Zone do
            local vehicles = GetGamePool('CVehicle')

            for _, vehicle in ipairs(vehicles) do
                if vehicle ~= playerVehicle and not Ack[vehicle] and not Checking[vehicle] then
                    local driver = GetPedInVehicleSeat(vehicle, -1)

                    local isPlayer = driver ~= 0 and IsPedAPlayer(driver)

                    if not isPlayer then
                        Checking[vehicle] = true
                    end
                end
            end

            Citizen.Wait(IsSpeeding and 0 or 50)
        end
    end)

    Citizen.CreateThread(function ()
        local prevCoords = {}

        while Zone do
            local idle = 500

            for vehicle, v in pairs(Checking) do
                Ack[vehicle] = (Ack[vehicle] or 0) + 1

                if Ack[vehicle] > 5 then
                    Checking[vehicle] = nil
                end
            end

            for vehicle, checks in pairs(Ack) do
                if not DoesEntityExist(vehicle) then
                    Ack[vehicle] = nil

                    Ghosted[vehicle] = nil

                    Checking[vehicle] = nil

                    goto continue
                end

                if checks > 5 then
                    local coords = GetEntityCoords(vehicle)

                    if not prevCoords[vehicle] then prevCoords[vehicle] = coords end

                    local change = #(prevCoords[vehicle] - coords)

                    if change > 100.0 then
                        Ack[vehicle] = 0
                        Checking[vehicle] = true
                    end

                    if Ghosted[vehicle] and not Checking[vehicle] and not Zone:isPointInside(coords) then
                        NetworkConcealEntity(vehicle, false)
                        Ghosted[vehicle] = false
                    end

                    prevCoords[vehicle] = coords
                end

                ::continue::
            end

            Citizen.Wait(idle)
        end
    end)
end)

AddEventHandler('baseevents:leftVehicle', function ()
    if Zone == nil then return end

    Zone:destroy()

    Zone = nil
end)

AddEventHandler('density:yeet', function (vehicle)
    -- local playerUsed = exports['comet-vehicles']:InUse(vehicle)

    -- if playerUsed then return end

    exports['comet-base']:SyncedExecution('DeleteEntity', vehicle)
end)

--[[
    BUBBLE POPPER 3000
    While in a race, check for all player-controlled vehicles within 35 units
    If other vehicle is a RACER then ENABLE ghost for ourselves
    If ANY other player vehicle is close (NON RACER) then we have to DISABLE ghost
    If the RACER vehicle is CLOSE (ie. touching distance) then we need to DISABLE ghost
    Every RACER client will run this, allowing for bubbles to not actually affect anything
--]]

local isRacing = false
SetLocalPlayerAsGhost(false)
-- Set our alpha to others as 254 (near ghost)
SetGhostedEntityAlpha(254)

-- local nosActive = true
-- AddEventHandler('vehicles:nitro:started', function()
--     nosActive = true
-- end)

-- AddEventHandler('vehicles:nitro:stopped', function()
--     nosActive = false
-- end)

local PlayersInScope = {}

RegisterNetEvent('oezlayerJoining')
AddEventHandler('oezlayerJoining', function(serverId)
    local playerId = GetPlayerFromServerId(serverId)
    if (playerId == PlayerId()) then return end

    PlayersInScope[serverId] = playerId
end)

RegisterNetEvent('oezlayerDropped')
AddEventHandler('oezlayerDropped', function(serverId)
    if (not PlayersInScope[serverId]) then return end

    PlayersInScope[serverId] = nil
end)

function startBubblePopper(pRace)
    if not pRace.bubblePopper and pRace.phasing == 'none' then return end

    local fullPhase = pRace.phasing == 'full'

    -- print('Starting Race', json.encode(pRace))

    isRacing = true

    local closePlayers = {}
    local playerIds = {}
    local playerPed = PlayerPedId()

    local myServerId = GetPlayerServerId(PlayerId())
    local myVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    for _, player in pairs(pRace.players) do
        if myServerId ~= player.id then
            playerIds[player.id] = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(player.id)), false)
        end
    end

    for i, playerId in ipairs(GetActivePlayers()) do
        local serverId = GetPlayerServerId(playerId)
        if serverId and not PlayersInScope[serverId] then PlayersInScope[serverId] = playerId end
    end

    -- print('Starting vehicle tracking...')

    local ghosted = false
    local forceOff = false

    if pRace.phasing ~= 'none' and pRace.phasing ~= 'full' then
        local phasingSeconds = tonumber(pRace.phasing)
        if phasingSeconds ~= nil then
            fullPhase = true
            TriggerEvent('cl_SendNotify', 'Phase Active (' .. pRace.phasing .. 's)')
            SetTimeout((phasingSeconds - 5) * 1000, function()
                TriggerEvent('cl_SendNotify', 'Phase disabling in 5 seconds', 2)
            end)
            SetTimeout(phasingSeconds * 1000, function()
                fullPhase = pRace.phasing == 'full' or false
                SetLocalPlayerAsGhost(false)
                ghosted = false
                TriggerEvent('cl_SendNotify', 'Phase disabled', 2)
            end)
        end
    end

    -- Update playerPed, playerIds, and closePlayers
    Citizen.CreateThread(function()
        while isRacing do
            playerPed = PlayerPedId()
            local myCoords = GetEntityCoords(playerPed)

            myVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            for playerId, _ in pairs(playerIds) do
                playerIds[playerId] = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
            end

            for serverId, playerId in pairs(PlayersInScope) do
                -- Only check player if they are not in the race.
                if not playerIds[serverId] then
                    local ped = GetPlayerPed(playerId)
                    local dist = #(myCoords - GetEntityCoords(ped))
                    local closeVehicle = dist < 100.0 and GetVehiclePedIsIn(ped, false) or 0
                    -- If `ped` is in a vehicle, it's close enough, and it's not a vehicle of a player in the race
                    if closeVehicle ~= 0 and closeVehicle ~= myVehicle and not tableContains(playerIds, closeVehicle) then
                        closePlayers[serverId] = ped
                    else
                        closePlayers[serverId] = nil
                    end
                end
            end

            Wait(250)
        end
    end)

    -- Tracks close players
    Citizen.CreateThread(function()
        while isRacing do
            forceOff = false
            local myCoords = GetEntityCoords(playerPed)

            for serverId, ped in pairs(closePlayers) do
                local dist = #(myCoords - GetEntityCoords(ped))
                if dist < 30.0 and ped ~= playerPed and not playerIds[serverId] then
                    forceOff = true -- Some other vehicle is too close, disable ghost mode
                end
            end

            Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while isRacing do
            Wait(0) -- Update time, this will determine how fast we should disable when ramming someone, should be LOW

            local inRange = false
            local toClose = false
            local myCoords = GetEntityCoords(playerPed)
            local myVehicle = GetVehiclePedIsIn(playerPed, false)
            if myVehicle ~= 0 then
                if fullPhase then
                    if (not ghosted) and (not forceOff) then
                        -- print('Phase Active, ghosting', ghosted, forceOff)
                        SetLocalPlayerAsGhost(true)
                        ghosted = true
                    end
                end

                if pRace.bubblePopper then
                    local myVelocity = GetEntityVelocity(myVehicle)
                    for _, vehicle in pairs(playerIds) do
                        local innerBubbleThreshold = 10.0
                        local dist = #(myCoords - GetEntityCoords(vehicle))
                        if dist < 25.0 then
                            inRange = true -- At least one vehicle close enough, enable ghost mode
                            local relativeVelocity = #(GetEntityVelocity(vehicle) - myVelocity)
                            innerBubbleThreshold = math.max(6.5, math.min(10.0, relativeVelocity + 2.5))
                        end
                        if dist < innerBubbleThreshold then
                            toClose = true -- At least one vehicle inside of us, disable ghost mode
                        end
                    end

                    if inRange and not toClose and not ghosted then
                        SetLocalPlayerAsGhost(true)
                        ghosted = true
                        -- print('In range, ghosting')
                    end

                    if (toClose or forceOff) and ghosted and (not fullPhase) then
                        SetLocalPlayerAsGhost(false)
                        ghosted = false
                        -- print('To close, disabling')
                    end

                    if not inRange and not toClose and ghosted and (not fullPhase) then
                        SetLocalPlayerAsGhost(false)
                        ghosted = false
                        -- print('Nobody in range and not to close, disabling')
                    end
                end

                if ghosted and forceOff then
                    -- print('Forced off, unghosting', ghosted, forceOff)
                    SetLocalPlayerAsGhost(false)
                    ghosted = false
                end
            elseif ghosted then
                -- print('out of vehicle, disabling')
                SetLocalPlayerAsGhost(false)
                ghosted = false
            end
        end
        SetLocalPlayerAsGhost(false)
        ghosted = false
    end)
end

AddEventHandler("mkr_racing:api:currentRace", function(currentRace)
    isRacing = currentRace ~= nil
    if isRacing then
        startBubblePopper(currentRace)
    end
end)
