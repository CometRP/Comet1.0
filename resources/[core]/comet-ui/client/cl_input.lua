local HasActiveInput, InputPromise = false, nil

exports("CreateInput", function(Data, Cb)
    if HasActiveInput then return LoggerModule.Error("Ui/Input", "Input is already active.") end

    HasActiveInput, InputPromise = true, promise:new()

    SendUIMessage("Input", "BuildInput", Data)
    SetCursorLocation(0.5, 0.5)
    SetNuiFocus(true, true)

    return Citizen.Await(InputPromise)
end)
UiComponents.CreateInput = exports['comet-ui']:CreateInput

exports("HideInput", function(Data, Cb)
    if not HasActiveInput then return LoggerModule.Error("Ui/Input", "There is no active input to close.") end

    HasActiveInput = false

    SendUIMessage("Input", "RemoveFocus", Data)
    SetNuiFocus(false, false)
end)
UiComponents.HideInput = exports['comet-ui']:HideInput

RegisterNUICallback('Input/OnButtonClick', function(Data, Cb)
    if Data.Button == 'submit' then
        InputPromise:resolve(Data.Result)        
    end
    exports['comet-ui']:HideInput()
    Cb('Ok')
end)

RegisterNUICallback('Input/Close', function(Data, Cb)
    exports['comet-ui']:HideInput()
    Cb('Ok')
end)

RegisterNUICallback("Input/OnChoiceClick", function(Data, Cb)
    if Data.ChoiceData.EventType == nil or Data.ChoiceData.EventType:lower() == 'client' then
        TriggerEvent(Data.ChoiceData.OnClickEvent, Data.ChoiceData)
    elseif Data.ChoiceData.EventType:lower() == 'server' then
        TriggerServerEvent(Data.ChoiceData.OnClickEvent, Data.ChoiceData)
    end

    Cb('Ok')
end)

RegisterNetEvent('comet-ui:client:ui-reset', function()
    exports['comet-ui']:HideInput()
end)