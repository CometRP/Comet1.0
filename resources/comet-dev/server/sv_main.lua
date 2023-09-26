RegisterCommand("GetHashKey", function(s,a)
    print(GetHashKey(a[1]))
end, true)

--453432689
RegisterCommand("giveitem", function(s,a)
    -- exports['comet-base']:FetchComponent("Inventory").Add()
    TriggerClientEvent("player:receiveItem", a[1], a[2], a[3])
end)