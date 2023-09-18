local AnimationDict, RadioOn, CurrentChannel = nil, false, 0

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            TriggerEvent('comet-ui/client/do-radio-check')
            Citizen.Wait(4000)
        else
            Citizen.Wait(450)
        end
    end
end)

AddInitialize(function()
    KeybindsModule.Add("radioUp", 'Radio', 'Channel Up', '', function(IsPressed)
        if not IsPressed then return end
        if CurrentChannel > 0 then
            TriggerEvent('comet-ui/client/radio-set-channel', CurrentChannel + 1)
        end
    end)
    KeybindsModule.Add("radioDown", 'Radio', 'Channel Down',  '', function(IsPressed)
        if not IsPressed then return end
        if (CurrentChannel - 1) > 0 then
            TriggerEvent('comet-ui/client/radio-set-channel', CurrentChannel - 1)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent('comet-ui/client/do-radio-check', function()
    if not exports['comet-inventory']:HasEnoughOfItem('radio', 1) and not exports['comet-inventory']:HasEnoughOfItem('pdradio', 1) then
        TriggerEvent('comet-ui/client/remove-from-radio')
    end
end)

RegisterNetEvent('comet-items/client/used-radio', function()
    Citizen.SetTimeout(1000, function()
        exports['comet-assets']:AttachProp('Walkie')
        AnimationDict = 'cellphone@'
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            AnimationDict = 'anim@cellphone@in_car@ps'
        end
        FunctionsModule.RequestAnimDict(AnimationDict)
        TaskPlayAnim(PlayerPedId(), AnimationDict, 'cellphone_text_in', 3.0, 3.0, -1, 50, 0, false, false, false)
        SetNuiFocus(true, true)
        SendUIMessage('Radio', 'OpenRadio', {})
    end)
end)

RegisterNetEvent('comet-ui/client/remove-from-radio', function()
    if CurrentChannel > 0 then
        TriggerEvent('comet-ui/client/notify', "radio-connect", "Disconnected from radio", 'error')
        TriggerServerEvent('comet-voice/server/remove-player-from-radio', CurrentChannel)
        TriggerEvent("comet-ui/client/play-sound", "radio-disconnect", 0.25)
        CurrentChannel = 0
        TriggerEvent('comet-ui/client/update-radio-values')
    end
end)

RegisterNetEvent('comet-ui/client/radio-set-channel', function(ChannelId)
    if CurrentChannel == ChannelId then return end

    if not RadioOn then
        TriggerEvent('comet-ui/client/notify', "radio-connect", "Your radio is not turned on..", 'error')
        return
    end

    CurrentChannel = ChannelId + 0.0

    SendUIMessage('Radio', 'SetRadioValue', CurrentChannel)
    TriggerServerEvent('comet-voice/server/add-player-to-radio', CurrentChannel, true)
    TriggerEvent('comet-ui/client/notify', "radio-connect", "Connected to channel "..CurrentChannel, 'success')
end)

RegisterNetEvent('comet-ui/client/ui-reset', function()
    StopAnimTask(PlayerPedId(), AnimationDict, 'cellphone_text_in', 1.0)
    exports['comet-ui']:SendUIMessage("Radio", "CloseRadio")
    exports['comet-assets']:RemoveProps('Walkie')
    AnimationDict = nil
end)

-- [ Nui Callbacks ] --

RegisterNUICallback('Radio/TogglePower', function(Data, Cb)
    if RadioOn then
        RadioOn = false
        if CurrentChannel > 0 then
            TriggerServerEvent('comet-voice/server/remove-player-from-radio', CurrentChannel)
        end
        SendUIMessage('Radio', 'SetRadioValue', 'Off')
        TriggerEvent('comet-ui/client/play-sound', 'radio-off', 0.5)
        TriggerEvent('comet-ui/client/notify', "radio-state", "Radio turned off..", 'error')
    else
        RadioOn = true
        if CurrentChannel > 0 then
            SendUIMessage('Radio', 'SetRadioValue', CurrentChannel)
            TriggerServerEvent('comet-voice/server/add-player-to-radio', CurrentChannel, true)
        else
            SendUIMessage('Radio', 'SetRadioValue', 0)
        end
        TriggerEvent('comet-ui/client/play-sound', 'radio-on', 0.1)
        TriggerEvent('comet-ui/client/notify', "radio-state", "Radio turned on..", 'success')
    end
    Cb('Ok')
end)

RegisterNUICallback('Radio/JoinRadio', function(Data, Cb)
    local PlayerData = PlayerModule.GetPlayerData()
    local ChannelToJoin, CanJoinChannel = tonumber(Data.Channel), false
    if RadioOn and ChannelToJoin ~= nil and ChannelToJoin > 0 then
        if ChannelToJoin <= 10.0 and (PlayerData.Job.Name == 'police' or PlayerData.Job.Name == 'ems') and PlayerData.Job.Duty then
            CanJoinChannel = true
        elseif ChannelToJoin > 10.99 and ChannelToJoin < 500.0 then
            CanJoinChannel = true
        end
        Citizen.SetTimeout(50, function()
            if CanJoinChannel and CurrentChannel ~= (ChannelToJoin + 0.0) then
                CurrentChannel = ChannelToJoin + 0.0
                TriggerEvent('comet-ui/client/update-radio-values')
                TriggerServerEvent('comet-voice/server/add-player-to-radio', CurrentChannel, true)
                TriggerEvent('comet-ui/client/notify', "radio-connect", "Connected to "..CurrentChannel..' Mhz.', 'success')
            else
                TriggerEvent('comet-ui/client/notify', "radio-error", "It seems you can\'t connect to this frequency", 'error')
            end
        end)
    end
    Cb('Ok')
end)

RegisterNUICallback('Radio/LeaveRadio', function(Data, Cb)
    TriggerEvent('comet-ui/client/remove-from-radio')
    Cb('Ok')
end)

RegisterNUICallback('Radio/Close', function(Data, Cb)
    StopAnimTask(PlayerPedId(), AnimationDict, 'cellphone_text_in', 1.0)
    exports['comet-assets']:RemoveProps('Walkie')
    SetNuiFocus(false, false)
    AnimationDict = nil
    Cb('Ok')
end)

RegisterNUICallback('Radio/Click', function(Data, Cb)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    Cb('Ok')
end)

exports('RadioConnected', function()
    return RadioOn and (CurrentChannel > 0)
end)

exports('IsRadioOn', function()
    return RadioOn
end)