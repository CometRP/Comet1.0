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
    while not Player do
        Wait(25)
    end

    Callback.Register("comet-clothingUI:saveSkin", function(source, data)
        local save = TriggerClientEvent("comet-clothingUI:save", source)
        return save, true
    end)

    Callback.Register("clothing:purchasecash",function(source, data)
        local Player = Player.GetBySource(source)
        if Player.PlayerData.money.cash >= data.pPrice then
            Player.RemoveMoney('cash', data.pPrice)
            return true
        else 
            return false
        end
    end)
    
    Callback.Register("clothing:bankpurchase",function(source, data)
        local src = source
        local Player = Player.GetBySource(source)
        if Player.PlayerData.money.bank >= data.pPrice then
            Player.RemoveMoney('bank', data.pPrice)
            return true
        else 
            TriggerClientEvent('DoLongHudText', src, 'You do not have enough money ! Required Ammount : $200', 2)
            return false

        end
    end)
    -- this one errors
    Callback.Register("comet-clothingUI:getTextureNames",function(source,name)
        local data = LoadResourceFile(GetCurrentResourceName(), "./client/names.json")
        data = json.decode(data)
        if data then
            return data[1][name.name]
        else 
            return {}
        end
    end)
end)