Components.Base = Components.Base or {}

Components.Base.hasLoaded = false


function Components.Base.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                 -- Player Session Started
                TriggerEvent("comet-base:playerSessionStarted")
                TriggerServerEvent("comet-base:playerSessionStarted")

                -- Component Refresher
                -- TriggerEvent("comet-base:refreshComponents")
                -- TriggerServerEvent("comet-base:refreshComponents")
                break
            end
        end
    end)
end
Components.Base.Initialize()

-- CreateThread(function()
--     while true do
--         if NetworkIsSessionStarted() then
--             -- Player Session Started
--             TriggerEvent("comet-base:playerSessionStarted")
--             TriggerServerEvent("comet-base:playerSessionStarted")

--             --
--             TriggerEvent("comet-base:refreshComponents")
--             TriggerServerEvent("comet-base:refreshComponents")
--             break
--         end
--         Wait(0)
--     end
-- end)

AddEventHandler("comet-base:playerSessionStarted", function()
    while not Components.Base.hasLoaded do
        ---- print"waiting in loop")
        Wait(100)
    end
    ShutdownLoadingScreen()
    Components.Spawn:Initialize()
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

RegisterNetEvent("base:disableLoading")
AddEventHandler("base:disableLoading", function()
    -- print"player has spawned ")
    if not Components.Base.hasLoaded then
         Components.Base.hasLoaded = true
    end
end)

Citizen.CreateThread( function()
    TriggerEvent("base:disableLoading")
end)


RegisterNetEvent("paycheck:client:call")
AddEventHandler("paycheck:client:call", function()
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("paycheck:server:send", cid)
end)

RegisterNetEvent("paycheck:collect:log:handler")
AddEventHandler("paycheck:collect:log:handler", function()
    TriggerServerEvent('paycheck:collect:log')
end)