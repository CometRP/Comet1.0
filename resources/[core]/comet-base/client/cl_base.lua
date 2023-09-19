CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            -- Player Session Started
            TriggerEvent("comet-base:playerSessionStarted")
            TriggerServerEvent("comet-base:playerSessionStarted")

            --
            TriggerEvent("comet-base:refreshComponents")
            TriggerServerEvent("comet-base:refreshComponents")
            break
        end
        Wait(0)
    end
end)