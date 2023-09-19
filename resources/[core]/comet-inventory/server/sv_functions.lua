Inventory = {}
Inventory.AddItem = function(source, id, amount, generateInformation, itemdata, returnData, devItem)
    TriggerClientEvent("player:receiveItem", source, id, amount, generateInformation, itemdata, returnData, devItem)
end
exports['comet-base']:CreateComponent("Inventory", Inventory)
exports("AddItem", Inventory.AddItem)

Citizen.CreateThread(function()
     TriggerEvent("inv:playerSpawned");
end)

-- local function AddItem(source, id, amount, generateInformation, itemdata, returnData, devItem)
--     local source = source
--     TriggerClientEvent("player:receiveItem", source, id, amount, generateInformation, itemdata, returnData, devItem)
-- end


RegisterServerEvent("server-item-quality-update")
AddEventHandler("server-item-quality-update", function(player, data)
    if data.quality < 1 then
        exports.oxmysql:execute("UPDATE user_inventory SET `quality` = @quality WHERE name = @name AND slot = @slot AND item_id = @item_id", {
            ['quality'] = "0", 
            ['name'] = 'ply-' ..player, 
            ['slot'] = data.slot,
            ['item_id'] = data.itemid
        })
    end
end)


RegisterServerEvent('people-search')
AddEventHandler('people-search', function(target)
    local source = source
    local user = exports["comet-base"]:getModule("Player"):GetUser(target)
    local characterId = user:getVar("character").id

	TriggerClientEvent("server-inventory-open", source, "1", 'ply-'.. characterId)
end)

-- RegisterServerEvent('Stealtheybread')
-- AddEventHandler('Stealtheybread', function(target)
--     local src = source
--     local user = exports["comet-base"]:getModule("Player"):GetUser(src)
--     local targetply = exports["comet-base"]:getModule("Player"):GetUser(target)
--     user:addMoney(targetply:getCash())
--     targetply:removeMoney(targetply:getCash())
-- end)


RegisterServerEvent('redpack:item')
AddEventHandler('redpack:item', function(itemid)
    TriggerClientEvent('player:receiveItem', source, 'ciggy', 10)
end)


RegisterNetEvent('comet-weapons:getAmmo')
AddEventHandler('comet-weapons:getAmmo', function()
    local ammoTable = {}
    local src = source
    -- local user = exports["comet-base"]:getModule("Player"):GetUser(src)
    -- local characterId = user:getCurrentCharacter()
    local user = exports["comet-base"]:getModule("Player"):GetUser(src)
    print(user)
    local characterId = user:getVar("character").id

    exports.oxmysql:execute("SELECT type, ammo FROM characters_weapons WHERE id = @id", {['id'] = characterId}, function(result)
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
    -- local user = exports["comet-base"]:getModule("Player"):GetUser(target)
    -- local characterId = user:getCurrentCharacter()
    local user = exports["comet-base"]:getModule("Player"):GetUser(src)
    print(user)
    local characterId = user:getVar("character").id
    exports.oxmysql:execute('SELECT ammo FROM characters_weapons WHERE type = @type AND id = @identifier',{['@type'] = ammoType, ['@identifier'] = characterId}, function(result)
        if result[1] == nil then
            exports.oxmysql:execute('INSERT INTO characters_weapons (id, type, ammo) VALUES (@identifier, @type, @ammo)', {
                ['@identifier'] = characterId,
                ['@type'] = ammoType,
                ['@ammo'] = newammo
            }, function()
            end)
        else
            exports.oxmysql:execute('UPDATE characters_weapons SET ammo = @newammo WHERE type = @type AND ammo = @ammo AND id = @identifier', {
                ['@identifier'] = characterId,
                ['@type'] = ammoType,
                ['@ammo'] = result[1].ammo,
                ['@newammo'] = newammo
            }, function()
            end)
        end
    end)
end)

RegisterServerEvent("comet-inventory:update:settings")
AddEventHandler("comet-inventory:update:settings", function(data)
    local src = source
    local user = GetPlayerIdentifiers(src)[1]
    local insert = {
        ["holdToDrag"] = data.holdToDrag,
        ["closeOnClick"] = data.closeOnClick,
        ["ctrlMovesHalf"] = data.ctrlMovesHalf,
        ["showTooltips"] = data.showTooltips,
        ["enableBlur"] = data.enableBlur
    }
    local encode = json.encode(insert)
    exports.oxmysql:execute('UPDATE users SET inventory_settings = ? WHERE hex_id = ?', {encode, user})
end)

RegisterServerEvent("comet-inventory:RetreiveSettings")
AddEventHandler("comet-inventory:RetreiveSettings", function()
    local src = source
    local user = GetPlayerIdentifiers(src)[1]
    exports.oxmysql:execute("SELECT `inventory_settings` FROM users WHERE hex_id = @hex_id", {['hex_id'] = user}, function(result)
        if (result[1]) then
            TriggerClientEvent('comet-base:update:settings', src, result[1].inventory_settings) -- does nothi8ng rn kekw
        end
    end)
end)

