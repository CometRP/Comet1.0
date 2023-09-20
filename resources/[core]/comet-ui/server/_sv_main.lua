RegisterNetEvent("comet-ui:server:play-sound-on-entity", function(Source, Sound, Entity, Timeout)
    TriggerClientEvent('comet-ui:client:playaudio-on-entity', Source, Sound, Entity, Timeout, math.random(111, 999))
end)

RegisterNetEvent("comet-ui:server:play-sound-in-distance", function(Source, Data)
    -- Data['Type']  Distance or Spatial
    local Coords = GetEntityCoords(GetPlayerPed(Source))
    local Position = Data['Position'] ~= nil and Data['Position'] or {[1] = Coords.x, [2] = Coords.y, [3] = Coords.z}
    TriggerClientEvent('comet-ui:client:play-audio-at-pos', Source, Position, Data['Distance'], Data['Name'], Data['Volume'])
end)