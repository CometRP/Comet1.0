local CreditCard = false

Player = nil

RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Player",
    }, function(pass)
        if not pass then return end
        Player = exports['comet-base']:FetchComponent("Player")
    end)
end)


RegisterServerEvent('comet:idcard')
AddEventHandler('comet:idcard', function()
    local src = source
    local user = Player:GetUser(src)
    if (tonumber(user:getCash()) >= 50) then
        user:removeMoney(50)
        TriggerClientEvent('courthouse:idbuy', src)
    else
        TriggerClientEvent("DoLongHudText", src, "You need $50", 2)
    end
end)

RegisterServerEvent("CreditCard")
AddEventHandler("CreditCard", function(status)
    CreditCard = status
end)

RegisterServerEvent('cash:remove')
AddEventHandler('cash:remove', function(pSrc, amount)
    -- print("d")
    local user = Player:GetUser(tonumber(pSrc))
	if (tonumber(user:getCash()) >= amount) then
		user:removeMoney(amount)
        -- print(amount)
        -- print(CreditCard)
    else
        if CreditCard then
            if (tonumber(user:getBalance()) >= amount) then
                user:removeBank(amount)
        -- print(amount)
            end
        end
	end
end)