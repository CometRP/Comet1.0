-- local QBCore = exports['qb-core']:GetCoreObject()
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local choosingSpawn = false
local Houses = {}
local cam = nil
local cam2 = nil

-- Functions

local function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Events

RegisterNetEvent('comet-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    DoScreenFadeOut(250)
    Wait(1000)
    DoScreenFadeIn(250)
    exports['comet-base']:FetchComponent("Player").GetPlayerData(function(PlayerData)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Wait(500)
    SetDisplay(value)
end)

RegisterNetEvent('qb-houses:client:setHouseConfig', function(houseConfig)
    Houses = houseConfig
end)

RegisterNetEvent('apartments:client:setupSpawnUI', function(cData, isNew)

        TriggerEvent("comet-clothing:inSpawn", true)
    -- if not isNew then 
        TriggerEvent('comet-spawn:client:setupSpawns', cData, false, nil)
        TriggerEvent('comet-spawn:client:openUI', true)
    -- elseif isNew then
    --     TriggerEvent('comet-spawn:client:setupSpawns', cData, true, nil)
    --     TriggerEvent('comet-spawn:client:openUI', false)
    -- else
    --     print("ERROR")
    -- end



    -- Callbacks.TriggerCallback('apartments:GetOwnedApartment', function(result)
    --     if result then
    --         TriggerEvent('comet-spawn:client:setupSpawns', cData, false, nil)
    --         TriggerEvent('comet-spawn:client:openUI', true)
    --         TriggerEvent("apartments:client:SetHomeBlip", result.type)
    --     else
    --         if Apartments.Starting then
    --             TriggerEvent('comet-spawn:client:setupSpawns', cData, true, Apartments.Locations)
    --             TriggerEvent('comet-spawn:client:openUI', true)
    --         else
    --             TriggerEvent('comet-spawn:client:setupSpawns', cData, false, nil)
    --             TriggerEvent('comet-spawn:client:openUI', true)
    --         end
    --     end
    -- end, cData.cid)
end)

RegisterNetEvent('comet-spawn:client:setupSpawns', function(cData, new, apps)

    if not new then
        -- Callbacks.TriggerCallback('comet-spawn:server:getOwnedHouses', function(houses)
        TriggerServerEvent("comet-clothing:retrieve_tats")
        TriggerServerEvent('comet-clothing:get_character_current')
        TriggerServerEvent('comet-clothing:get_character_face')
        local houses = exports["comet-base"]:FetchComponent("Callback").Execute("comet-spawn:server:getOwnedHouses", {cid = cData.cid})
        print(json.encode(houses))

            local myHouses = {}
            if houses ~= nil then
                for i = 1, (#houses), 1 do
                    myHouses[#myHouses+1] = {
                        house = houses[i].house,
                        label = Houses[houses[i].house].adress,
                    }
                end
            end
            Wait(400)
            -- local Apartment = nil
            -- local ApartmentName = nil
            -- eCallBacks.TriggerCallback('apartments:GetOwnedApartment', function(result)
            --     Apartment = Apartments.Locations[result.type]  
            --     ApartmentName = result.name
            -- end)
            Wait(400)
            SendNUIMessage({
                action = "setupLocations",
                locations = Config.Spawns,
                houses = myHouses,
                -- Apartment = Apartment,
                -- ApartmentNames = ApartmentName,
                Access = Config.SpawnAccess,
            })
        -- end, cData.cid)
    elseif new then
        -- local coords = vector4(328.22, -203.86, 54.09, 158.98)

        -- TriggerEvent("comet-clothingUI:client:CreateFirstCharacter")

        -- SendNUIMessage({
        --     action = "setupAppartements",
        --     locations = apps,
        -- })
    end
end)

-- NUI Callbacks


local cam = nil
local cam2 = nil

local function SetCam(campos)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
end

RegisterNUICallback('setCam', function(data, cb)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    DoScreenFadeOut(200)
    Wait(500)
    DoScreenFadeIn(200)

    if DoesCamExist(cam) then DestroyCam(cam, true) end
    if DoesCamExist(cam2) then DestroyCam(cam2, true) end

    if type == "current" then
        exports['comet-base']:FetchComponent("Player").GetPlayerData(function(PlayerData)
            SetCam(PlayerData.position)
        end)
    elseif type == "house" then
        SetCam(Houses[location].coords.enter)
    elseif type == "normal" then
        SetCam(Config.Spawns[location].coords)
    -- elseif type == "appartment" then
    --     SetCam(Apartments.Locations[location].coords.enter)
    end
    cb('ok')
end)

-- RegisterNUICallback('chooseAppa', function(data, cb)
--     local ped = PlayerPedId()
--     local appaYeet = data.appType
--     SetDisplay(false)
--     DoScreenFadeOut(500)
--     Wait(5000)
--     TriggerServerEvent("apartments:server:CreateApartment", appaYeet, Apartments.Locations[appaYeet].label)
--     TriggerServerEvent('comet-base:playerLoaded')
--     TriggerEvent('comet-base:playerLoaded')
--     FreezeEntityPosition(ped, false)
--     RenderScriptCams(false, true, 500, true, true)
--     SetCamActive(cam, false)
--     DestroyCam(cam, true)
--     SetCamActive(cam2, false)
--     DestroyCam(cam2, true)
--     SetEntityVisible(ped, true)
--     cb('ok')
-- end)

local function PreSpawnPlayer()
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(2000)
end

local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
end

RegisterNUICallback('spawnplayerappartment2', function(data, cb)
    PreSpawnPlayer()
    local Data = data.spawnloc
    local Data2 = data.apartName
    TriggerServerEvent('comet-base:playerLoaded')
    TriggerEvent('comet-base:playerLoaded')
    -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    -- TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    -- TriggerEvent('qb-apartments:client:LastLocationHouse', Data, Data2)
    PostSpawnPlayer()
    cb('ok')
end)

RegisterNUICallback('spawnplayer', function(data, cb)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = exports['comet-base']:FetchComponent("Player").GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]

    if type == "current" then
        PreSpawnPlayer()
        exports['comet-base']:FetchComponent("Player").GetPlayerData(function(pd)
            ped = PlayerPedId()
            SetEntityCoords(ped, pd.position.x, pd.position.y, pd.position.z)
            SetEntityHeading(ped, pd.position.a)
            FreezeEntityPosition(ped, false)
        end)

        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            TriggerEvent('qb-houses:client:LastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('qb-apartments:client:LastLocationHouse', apartmentType, apartmentId)
        end
        TriggerServerEvent('comet-base:playerLoaded')
        TriggerEvent('comet-base:playerLoaded')
        PostSpawnPlayer()
    elseif type == "house" then
        PreSpawnPlayer()
        TriggerEvent('qb-houses:client:enterOwnedHouse', location)
        TriggerServerEvent('comet-base:playerLoaded')
        TriggerEvent('comet-base:playerLoaded')
        TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        PostSpawnPlayer()
    elseif type == "normal" then
        local pos = Config.Spawns[location].coords
        PreSpawnPlayer()
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        TriggerServerEvent('comet-base:playerLoaded')
        TriggerEvent('comet-base:playerLoaded')
        TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.w)
        PostSpawnPlayer()
    end
    cb('ok')
end)

RegisterNetEvent('comet-spawn:client:OpenUIForSelectCoord', function()
    local PlayerCoord = GetEntityCoords(PlayerPedId(), 1)
    local PlayerHeading = GetEntityHeading(PlayerPedId())
    SendNUIMessage({
        action = "AddCoord",
        Coord = {x = PlayerCoord[1], y = PlayerCoord[2], z = PlayerCoord[3], h = PlayerHeading},
            
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('CloseAddCoord', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Threads

CreateThread(function()
    while true do
        Wait(0)
        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Wait(1000)
        end
    end
end)
