local prices = {
    ['rifle'] = 150000,
    ['smg'] = 27000,
    ['pistol'] = 19280,
    ['shotgun'] = 12500,
}

CreateThread(function()
    exports['comet-base']:LoadComponents({
        "Callback",
        "Player",
    }, function(pass)
        if not pass then return end

        local Callback = exports['comet-base']:FetchComponent("Callback")
        local Player = exports['comet-base']:FetchComponent("Player")

        Callback.Register('comet-weapons:getCurrentBodyPrices', function(source, data)
            return prices
        end)
        
        Callback.Register('comet-weapons:purchaseWeaponBody', function(source, data)
            local finalprice = prices[pType] * pAmont
            local player = Player.GetBySource(source)
            if player.PlayerData.money["cash"] >= finalprice then
                player.RemoveMoney('cash', finalprice)
                if pType == 'rifle' then
                    TriggerClientEvent("player:receiveItem", source, 'riflebody', data.pAmont)
                elseif pType == 'shotgun' then
                    TriggerClientEvent("player:receiveItem", source, 'shotgunbody', data.pAmont)
                elseif pType == 'smg' then
                    TriggerClientEvent("player:receiveItem", source, 'smgbody', data.pAmont)
                elseif pType == 'pistol' then
                    TriggerClientEvent("player:receiveItem", source, 'pistolbody', data.pAmont)
                end
            end
        end)
    end)

   
end)