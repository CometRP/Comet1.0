CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            -- Player Session Started
            TriggerEvent("comet-base:playerSessionStarted")
            TriggerServerEvent("comet-base:playerSessionStarted")

            --
            -- TriggerEvent("comet-base:refreshComponents")
            -- TriggerServerEvent("comet-base:refreshComponents")
            break
        end
        Wait(0)
    end
end)

RegisterNetEvent("comet-base:waitForExports", function()
    if not Components.Base.ExportsReady then return end

    while true do
        Citizen.Wait(0)
        if exports and exports["comet-base"] then
            TriggerEvent("comet-base:refreshComponents")
            return
        end
    end
end)