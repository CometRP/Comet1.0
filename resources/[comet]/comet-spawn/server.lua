Callback, Commands, Player = nil, nil, nil
AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback",
        "Commands",
        "Player",
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
        Commands = exports['comet-base']:FetchComponent("Commands")
        Player = exports['comet-base']:FetchComponent("Player")
    end)
end)

CreateThread(function()
    while not Callback do
        Citizen.Wait(25)
    end
    while not Commands do
        Citizen.Wait(25)
    end
    -- Callback.Register('apartments:GetOwnedApartment', function(cid)
    --     local source = source
    --     if cid ~= nil then
    --         local result = MySQL.query.await('SELECT * FROM apartments WHERE cid = ?', { cid })
    --         if result[1] ~= nil then
    --             return result[1]
    --         end
    --         return nil
    --     else
    --         local src = source
    --         local Player = Player.GetBySource(src)
    --         local result = MySQL.query.await('SELECT * FROM apartments WHERE cid = ?', { Player.PlayerData.cid })
    --         if result[1] ~= nil then
    --             return result[1]
    --         end
    --         return nil
    --     end
    -- end)
    Callback.Register('comet-spawn:server:getOwnedHouses', function(source, data, cb)
        local p = promise.new()
        if cid ~= nil then
            local houses = exports.oxmysql:executeSync('SELECT * FROM player_houses WHERE cid = ?', {data.cid}) -- OLD
            -- local houses = MySQL.query.await('SELECT * FROM player_houses WHERE cid = ?', {cid}) -- NEW
            if houses[1] ~= nil then
                p:resolve(houses)
            else
                p:resolve(nil)
            end
        else
            p:resolve(nil)
        end
        cb(Citizen.Await(p)) -- Sending back whatever was resolved.
    end)

    
    Commands.Add("addloc", "Add location for spawn (God Only)", {}, false, function(source)
        local src = source
        TriggerClientEvent('comet-spawn:client:OpenUIForSelectCoord', src)
    end, "god")

end)
