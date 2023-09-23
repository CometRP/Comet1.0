CreateThread(function()
    local Callback = exports['comet-base']:FetchComponent("Callback")
    local Commands = exports['comet-base']:FetchComponent("Commands")
    local Player = exports['comet-base']:FetchComponent("Player")
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
    Callback.Register('comet-spawn:server:getOwnedHouses', function(source, data)
        print("aids")
        -- local p = promise.new()
        if cid ~= nil then
            local houses = exports.oxmysql:executeSync('SELECT * FROM player_houses WHERE cid = ?', {data.cid}) -- OLD
            -- local houses = MySQL.query.await('SELECT * FROM player_houses WHERE cid = ?', {cid}) -- NEW
            if houses[1] ~= nil then
                return houses
            else
                return {}
                -- p:resolve(nil)
            end
        else
            return {}
            -- p:resolve(nil)
        end
        -- cb(Citizen.Await(p)) -- Sending back whatever was resolved.
    end)

    
    Commands.Add("addloc", "Add location for spawn (God Only)", {}, false, function(source)
        local src = source
        TriggerClientEvent('comet-spawn:client:OpenUIForSelectCoord', src)
    end, "god")

end)
