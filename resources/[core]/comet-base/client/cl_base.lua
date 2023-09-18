CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            TriggerEvent("comet-base:playerSessionStarted")
            TriggerServerEvent("comet-base:playerSessionStarted")
            break
        end
    end
end)