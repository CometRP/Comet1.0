local spawns = {
    [1] = {coords = vector3(271.52947998047, -642.59320068359, 42.019844055176), label = "Apartments"},
    [2] = {coords = vector3(427.05679321289, -981.81048583984, 30.752111434937), label = "PD Center"},
    [3] = {coords = vector3(352.107421875, -606.13397216797, 28.787105560303), label = "Hospital"},
    [4] = {coords = vector3(-260.39819335938, -973.28887939453, 31.552110671997), label = "Job Center"},
    [5] = {coords = vector3(-441.99172973633, 6017.5278320312, 31.667984008789), label = "Blaine County"},
    [6] = {coords = vector3(1839.8686523438, 3672.5166015625, 35.220104217529), label = "Sandy"},
    [7] = {coords = vector3(-1036.0920410156, -2733.7995605469, 13.756637573242), label = "Airport"},
}

local Cam = false
local isFirst = false

RegisterNetEvent("spawnselector:open")
AddEventHandler("spawnselector:open", function(bool)
    isFirst = bool
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, false)
    SendNUIMessage({ data = spawns })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
    Cam = false
    SetEntityVisible(PlayerPedId(), true)
end)

RegisterNUICallback("spawn", function(data)
    SetNuiFocus(false, false)
    if data.id == 0 then
        DoScreenFadeOut(0)
        DestroyAllCams(true)
        TriggerEvent("spawn:destroycams")
        SetEntityVisible(PlayerPedId(), true)
        Citizen.Wait(550)
        DoScreenFadeIn(2500)
        startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActiveWithInterp(cam, cam2, 3700, true, true)
        SetEntityVisible(PlayerPedId(), true, 0)
        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvisibleLocally(PlayerPedId(), false)
        SetPlayerInvincible(PlayerPedId(), false)

        DestroyCam(startcam, false)
        DestroyCam(cam, false)
        DestroyCam(cam2, false)
        Citizen.Wait(0)
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerEvent("SpawnApt")
        Citizen.Wait(2500)
        -- exports["ez-hud"]:toggleHud(true)
    else
        TriggerEvent("spawnselector:spawnPlayer", data.coords, data.label)
        print(data.label)
        print(data.coords)
        print(data.id)
    end
end)

RegisterNetEvent("spawnselector:spawnPlayer")
AddEventHandler("spawnselector:spawnPlayer", function(coords, label)
    DoScreenFadeOut(200)
    Citizen.Wait(1550)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    DestroyAllCams(true)
    TriggerEvent("spawn:destroycams")
    TaskLookAtCoord(PlayerPedId(), coords.x, coords.y, coords.z,-1, 0, 2)
    SetEntityVisible(PlayerPedId(), true)
    Citizen.Wait(550)
    DoScreenFadeIn(2500)
    startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(false, true, 500, true, true)
	SetCamActiveWithInterp(cam, cam2, 3700, true, true)
	SetEntityVisible(PlayerPedId(), true, 0)
	FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvisibleLocally(PlayerPedId(), false)
    SetPlayerInvincible(PlayerPedId(), false)

    DestroyCam(startcam, false)
    DestroyCam(cam, false)
    DestroyCam(cam2, false)
    Citizen.Wait(0)
    FreezeEntityPosition(PlayerPedId(), false)
    -- exports["ez-hud"]:toggleHud(true)
    if isFirst then
        isFirst = false
    end
end)