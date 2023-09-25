Citizen.CreateThread(function()
    for k, v in pairs(Config.Peds) do
        exports['comet-npcs']:RegisterNPC(v)
    end
end)