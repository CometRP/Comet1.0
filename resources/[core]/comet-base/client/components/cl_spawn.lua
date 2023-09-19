Components.Spawn = Components.Spawn or {}

Components.Spawn.Initialize = function(self)
    Citizen.CreateThread(function()

        FreezeEntityPosition(PlayerPedId(), true)

        DoScreenFadeOut(500)

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

        SetEntityVisible(ped, false)

        DoScreenFadeIn(10000)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        Citizen.Wait(10000)

        TriggerEvent("comet-base:spawnInitialized")
        TriggerServerEvent("comet-base:spawnInitialized")

    end)
end

Components.Spawn.InitialSpawn = function(self)
    Citizen.CreateThread(function()
        DisableAllControlActions(0)
      
        DoScreenFadeOut(10)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        local character = Components.LocalPlayer:getCurrentCharacter()


        --Tells raid clothes to set ped to correct skin
        TriggerEvent("comet-base:initialSpawnModelLoaded")

        local ped = PlayerPedId()

        SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)
        
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        --ClearPlayerWantedLevel(PlayerId())

        EnableAllControlActions(0)

        TriggerEvent("character:finishedLoadingChar")
    end)
end

AddEventHandler("comet-base:firstSpawn", function()
    Components.Spawn:InitialSpawn()
end)

RegisterNetEvent('comet-base:clearStates')
AddEventHandler('comet-base:clearStates', function()
    TriggerServerEvent("reset:blips")
    TriggerEvent("nowEMSDeathOff")
    TriggerEvent("nowCopDeathOff")
    TriggerEvent("stopSpeedo")
    TriggerEvent("wk:disableRadar")
    exports['pma-voice']:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end)
