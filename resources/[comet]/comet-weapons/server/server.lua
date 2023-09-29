RegisterNetEvent("comet-weapons:attackedByCash")
AddEventHandler("comet-weapons:attackedByCash", function(pAttacker)
    local victim = source
    TriggerClientEvent("comet-weapons:hitPlayerWithCash", pAttacker, victim)
end)

RegisterNetEvent("comet-weapons:processGiveCashAmount")
AddEventHandler("comet-weapons:processGiveCashAmount", function(pTarget, pAmount)
    local attacker = source
    local victim = pTarget
    local Player = exports['comet-base']:FetchComponent("Player").GetBySource(victim)

    Player.AddMoney('cash', pAmount)
            
end)

CreateThread(function()
    local Callback = exports['comet-base']:FetchComponent("Callback")
    
    while not Callback do Wait(25) end

    Callback.Register("weapons:getAmmo", function(pSource)
        local ammoTable = {}
        local Player = exports['comet-base']:FetchComponent("Player").GetBySource(pSource)
        exports.oxmysql:execute("SELECT type, ammo FROM characters_weapons WHERE id = @id", {['id'] = Player.PlayerData.cid}, function(result)
            for i = 1, #result do
                if ammoTable["" .. result[i].type .. ""] == nil then
                    ammoTable["" .. result[i].type .. ""] = {}
                    ammoTable["" .. result[i].type .. ""]["ammo"] = result[i].ammo
                    ammoTable["" .. result[i].type .. ""]["type"] = ""..result[i].type..""
                end
            end
            TriggerClientEvent('comet-items:SetAmmo', pSource, ammoTable)
        end)
    end)
end)


RegisterNetEvent('comet-weapons:getAmmo')
AddEventHandler('comet-weapons:getAmmo', function()
    local ammoTable = {}
    local src = source
	local Player = exports['comet-base']:FetchComponent("Player").GetBySource(src)
    exports.oxmysql:execute("SELECT type, ammo FROM characters_weapons WHERE id = @id", {['id'] = Player.PlayerData.cid}, function(result)
        for i = 1, #result do
            if ammoTable["" .. result[i].type .. ""] == nil then
                ammoTable["" .. result[i].type .. ""] = {}
                ammoTable["" .. result[i].type .. ""]["ammo"] = result[i].ammo
                ammoTable["" .. result[i].type .. ""]["type"] = ""..result[i].type..""
            end
        end
        TriggerClientEvent('comet-items:SetAmmo', src, ammoTable)
    end)
end)

RegisterNetEvent('comet-weapons:updateAmmo')
AddEventHandler('comet-weapons:updateAmmo', function(newammo,ammoType,ammoTable)
    local src = source
	local Player = exports['comet-base']:FetchComponent("Player").GetBySource(src)

    exports.oxmysql:execute('SELECT ammo FROM characters_weapons WHERE type = @type AND id = @identifier',{['@type'] = ammoType, ['@identifier'] = Player.PlayerData.cid}, function(result)
        if result[1] == nil then
            exports.oxmysql:execute('INSERT INTO characters_weapons (id, type, ammo) VALUES (@identifier, @type, @ammo)', {
                ['@identifier'] = Player.PlayerData.cid,
                ['@type'] = ammoType,
                ['@ammo'] = newammo
            }, function()
            end)
        else
            exports.oxmysql:execute('UPDATE characters_weapons SET ammo = @newammo WHERE type = @type AND ammo = @ammo AND id = @identifier', {
                ['@identifier'] = Player.PlayerData.cid,
                ['@type'] = ammoType,
                ['@ammo'] = result[1].ammo,
                ['@newammo'] = newammo
            }, function()
            end)
        end
    end)
end)


