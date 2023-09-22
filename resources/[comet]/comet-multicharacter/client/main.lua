local cam = nil
local charPed = nil
--local ped1 = nil
Callback = nil or exports['comet-base']:FetchComponent("Callback")
AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback"
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
        print("[COMET-MULTICHARACTER] Loaded Components")
    end)
end)
-- Main Thread

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('comet-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Functions

local function pednpc(model)
    CreateThread(function()---New character
        local randommodels = Config.PlayerModels
        local model = GetHashKey(randommodels[math.random(1, #randommodels)])
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        charnpc = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
        TaskStartScenarioAtPosition(charnpc, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
        SetEntityAlpha(charnpc, 400)
        SetPedComponentVariation(charnpc, 0, 0, 0, 2)
        FreezeEntityPosition(charnpc, false)
        SetEntityInvincible(charnpc, true)
        PlaceObjectOnGroundProperly(charnpc)
        SetBlockingOfNonTemporaryEvents(charnpc, true)
    end)
end

local function skyCam(bool)
    TriggerEvent('comet-weathersync:client:DisableSync')
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.0 ,0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local function openCharMenu(bool)
    -- QBCore.Functions.TriggerCallback("comet-multicharacter:server:GetNumberOfCharacters", function(result)
    local result = Callback:CallAsync("comet-multicharacter:server:GetNumberOfCharacters")
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            action = "ui",
            toggle = bool,
            nChar = result,
            enableDeleteButton = Config.EnableDeleteButton,
        })
        skyCam(bool)
		pednpc(model)
		
    -- end)
end

-- Events

RegisterNetEvent('comet-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    SetEntityHeading(PlayerPedId(), Config.DefaultSpawn.w)
    TriggerServerEvent('comet-base:playerLoaded')
    TriggerEvent('comet-base:playerLoaded')
    -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    -- TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('comet-weathersync:client:EnableSync')
    TriggerEvent('comet-clothingUI:client:CreateFirstCharacter')
end)

RegisterNetEvent('comet-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('comet-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    openCharMenu(false)
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('comet-multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('comet-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData.cData
	SetEntityAsMissionEntity(charnpc, true, true)
	DeleteEntity(charnpc)	
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        -- QBCore.Functions.TriggerCallback('comet-multicharacter:server:getSkin', function(model, data)
        local model, data = Callback:CallAsync('comet-multicharacter:server:getSkin', {cid = cData.cid} )
            model = model ~= nil and tonumber(model) or false
            if model ~= nil then
                CreateThread(function()
                    -- jay fix the fuck model time
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
                    charPed = ClonePed(PlayerPedId(), false, true, false)
                    -- jay fix the fuck model time

                    TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    data = json.decode(data)
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
                end)
            else
                CreateThread(function()
                    local randommodels = Config.PlayerModels
                    model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
					TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
            cb("ok")
        -- end, cData.cid)
    else
        CreateThread(function()---شخصية جديدة
            local randommodels = Config.PlayerModels
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
			TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
			SetEntityAlpha(charPed, 400)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
        cb("ok")
    end
end)

RegisterNUICallback('setupCharacters', function(_, cb)
    local result = Callback:CallAsync("comet-multicharacter:server:setupCharacters")
    -- QBCore.Functions.TriggerCallback("comet-multicharacter:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        cb("ok")
    -- end)
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Male" then
        cData.gender = 0
    elseif cData.gender == "Female" then
        cData.gender = 1
    end
    TriggerServerEvent('comet-multicharacter:server:createCharacter', cData)
    Wait(500)
    cb("ok")
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('comet-multicharacter:server:deleteCharacter', data.cid)
    TriggerEvent('comet-multicharacter:client:chooseChar')
    cb("ok")
end)
