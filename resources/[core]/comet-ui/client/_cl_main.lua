UI = { Initializes = {}}

UiComponents = UiComponents or {}
UiComponents.Refresh = function()
    TriggerEvent("comet-ui:client:ui-reset")
end

AddEventHandler("comet-base:exportsReady", function()
    exports['comet-base']:CreateComponent("UI", UiComponents)
end)
-- [ Code ] --

RegisterCommand("ui-r", function()
    TriggerEvent("comet-ui:client:ui-reset")
end)

-- [ Events ] --

RegisterNetEvent('comet-ui:client:ui-reset', function()
    SetNuiFocus(false, false)
    SendUIMessage('root', 'SetVisibility', { Bool = false })
    SendUIMessage('Prompts', 'CreatePrompt', {
        color = 'primary',
        text = 'Requesting a full UI refresh, please wait..',
        duration = 2000,
        id = 'ui-reset'
    })
    Citizen.Wait(2500)
    SendUIMessage('root', 'SetVisibility', { Bool = true })
end)

RegisterNUICallback("DOMReady", function()
    while not _Ready do Citizen.Wait(4) end
    Citizen.SetTimeout(1500, function()
        for k, v in pairs(UI.Initializes) do v() end
        SendUIMessage('root', 'SetTax', Shared.Tax)
    end)
end)

RegisterNetEvent('comet-ui:client:notify', function(id, message, type, duration)
    SendUIMessage("Prompts", "CreatePrompt", {
        text = message,
        color = type,
        duration = duration,
        id = id,
    })
end)

RegisterNetEvent('comet-ui:client:CopyToClipboard', function(Text)
    SendUIMessage("Main", "CopyToClipboard", Text)
end)

-- [ Functions ] --

function AddInitialize(Cb)
    table.insert(UI.Initializes, Cb)
end

function SendUIMessage(app, action, data)
    --[[
        if app == 'Phone' then
            print(('Phone-UI: Action: %s; Data: '):format(action))
            exports['comet-base']:DebugTable(data)
        end
    ]]
    SendNUIMessage({
        app = app,
        action = action,
        data = data
    })
end
exports("SendUIMessage", SendUIMessage)
UiComponents.SendUIMessage = SendUIMessage

function OpenContextMenu(MenuData)
    if #MenuData.MainMenuItems == 0 then return end
    SendUIMessage('Context', 'OpenContext', {MenuData = MenuData})
    Citizen.SetTimeout(5, function()
        Citizen.InvokeNative(0xFC695459D4D0E219, 0.7, 0.25)
        SetNuiFocus(true, true)
    end)
end
exports("OpenContext", OpenContextMenu)
UiComponents.OpenContext = OpenContextMenu

function SetInteraction(Text, Color, IgnoreSlide)
    SendUIMessage('Prompts', 'SetInteraction', {color = Color, text = Text, IgnoreSlide = IgnoreSlide})
end
exports("SetInteraction", SetInteraction)
UiComponents.SetInteraction = SetInteraction

function HideInteraction()
    SendUIMessage('Prompts', 'HideInteraction', {})
end
exports("HideInteraction", HideInteraction)
UiComponents.HideInteraction = HideInteraction

function Notify(Id, Text, Color, Duration)
    SendUIMessage("Prompts", "CreatePrompt", {
        text = Text,
        color = Color,
        duration = Duration,
        id = Id,
    })
end
exports("Notify", Notify)
UiComponents.Notify = Notify

function RotationToDirection(Rotation)
	local AdjustedRotation = {x = (math.pi / 180) * Rotation.x, y = (math.pi / 180) * Rotation.y, z = (math.pi / 180) * Rotation.z}
	local Direction = {x = -math.sin(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)), y = math.cos(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)), z = math.sin(AdjustedRotation.x)}
	return Direction
end

-- [ NUI Callbacks ] --

RegisterNUICallback('Context/CloseContext', function(Data, Cb)
    SetNuiFocus(false, false)
    Cb('Ok')
end)

RegisterNUICallback('Context/ContextEvent', function(Data, Cb)
    if Data.MenuData == nil then return end
    if Data.MenuData.Type == 'Client' then
        TriggerEvent(Data.MenuData.Event, Data.MenuData)
    else
        TriggerServerEvent(Data.MenuData.Event, Data.MenuData)
    end
    Cb('Ok')
end)

RegisterNUICallback('SetAppVisiblity', function(Data, Cb)
    SendUIMessage(Data.App, 'SetAppVisiblity', {
        Visible = Data.Visible or false,
    })
    Cb('Ok')
end)

-- [ Exports ] --

exports("SetNuiFocus", SetNuiFocus)
exports("SetNuiFocusKeepInput", SetNuiFocusKeepInput)
exports("CopyToClipboard", function(Text) 
    SendUIMessage("Main", "CopyToClipboard", Text) 
end)