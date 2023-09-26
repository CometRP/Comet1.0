RegisterServerEvent('seatbelt:server:EjectPlayer')
AddEventHandler('seatbelt:server:EjectPlayer', function(table, velocity)
for i=1, #table do
        if table[i] then
            TriggerClientEvent("seatbelt:client:EjectPlayer", table[i], velocity)
        end
    end
end)