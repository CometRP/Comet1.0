SQL, Callback, Player = nil, nil, nil

AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "SQL",
        "Callback",
        "Player",
    }, function(pass)
        if not pass then return end
        SQL = exports['comet-base']:FetchComponent("SQL")
        Callback = exports['comet-base']:FetchComponent("Callback")
        Player = exports['comet-base']:FetchComponent("Player")
    end)
end)


local FirstCreateChar = false

RegisterNetEvent("IsFirst")
AddEventHandler("IsFirst", function(pBull)
    FirstCreateChar = pBull
end)

CreateThread(function()
    while not Callback do
        Wait(25)
    end

    Callback.Register("comet-clothingUI:saveSkin",function(source, data, cb)
        local save = TriggerClientEvent("comet-clothingUI:save", source)
        cb(save, true)
    end)

    Callback.Register("clothing:purchasecash",function(source, data, cb)
        local Player = Player.GetBySource(source)
        local p = promise.new()
        if Player.PlayerData.money.cash >= data.pPrice then
            Player.Functions.RemoveMoney('cash', data.pPrice)
            p:resolve(true)
        else 
            p:resolve(false)
        end
        cb(Citizen.Await(p))
    end)
    
    Callback.Register("clothing:bankpurchase",function(source, data, cb)
        local src = source
        local Player = Player.GetBySource(source)
        local p = promise.new()
        if Player.PlayerData.money.bank >= data.pPrice then
            Player.Functions.RemoveMoney('bank', data.pPrice)
            p:resolve(true)
        else 
            p:resolve(false)
        end
        TriggerClientEvent('DoLongHudText', src, 'You do not have enough money ! Required Ammount : $200', 2)
        cb(Citizen.Await(p))
    end)
    
    Callback.Register("comet-clothingUI:getTextureNames",function(source, name, cb)
        local p = promise.new()
        local data = LoadResourceFile(GetCurrentResourceName(), "./client/names.json")
        data = json.decode(data)
    
        if data then
            p:resolve(data[1][name.name])
        else 
            p:resolve({})
        end
        cb(Citizen.Await(p))
    end)
end)