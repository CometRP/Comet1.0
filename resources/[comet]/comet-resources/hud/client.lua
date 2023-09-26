local disableHudComponents = Hud.Disable.disableHudComponents
local disableControls = Hud.Disable.disableControls
local displayAmmo = Hud.Disable.displayAmmo

CreateThread(function()
    while true do

        -- Hud Components

        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end

        for i = 1, #disableControls do
            DisableControlAction(2, disableControls[i], true)
        end

        DisplayAmmoThisFrame(displayAmmo)
        Wait(0)
    end
end)

exports('addDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        disableHudComponents[#disableHudComponents+1] = hudComponents
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #hudComponents do
            disableHudComponents[#disableHudComponents+1] = hudComponents[i]
        end
    end
end)

exports('removeDisableHudComponents', function(hudComponents)
    local hudComponentsType = type(hudComponents)
    if hudComponentsType == 'number' then
        for i = 1, #disableHudComponents do
            if disableHudComponents[i] == hudComponents then
                table.remove(disableHudComponents, i)
                break
            end
        end
    elseif hudComponentsType == 'table' and table.type(hudComponents) == "array" then
        for i = 1, #disableHudComponents do
            for i2 = 1, #hudComponents do
                if disableHudComponents[i] == hudComponents[i2] then
                    table.remove(disableHudComponents, i)
                end
            end
        end
    end
end)

exports('getDisableHudComponents', function() return disableHudComponents end)

exports('addDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        disableControls[#disableControls+1] = controls
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #controls do
            disableControls[#disableControls+1] = controls[i]
        end
    end
end)

exports('removeDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        for i = 1, #disableControls do
            if disableControls[i] == controls then
                table.remove(disableControls, i)
                break
            end
        end
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #disableControls do
            for i2 = 1, #controls do
                if disableControls[i] == controls[i2] then
                    table.remove(disableControls, i)
                end
            end
        end
    end
end)

exports('getDisableControls', function() return disableControls end)

exports('setDisplayAmmo', function(bool) displayAmmo = bool end)

exports('getDisplayAmmo', function() return displayAmmo end)