-- local QBCore = exports['qb-core']:GetCoreObject()
local _INV = {}
_INV.UsableItems = {}
_INV.CreateUsableItem = function(item, cb)
    _INV.UsableItems[item] = cb
end
_INV.CanUseItem = function(item)
	return _INV.UsableItems[item]
end
_INV.UseItem = function(itemName, ...)
    local itemData = _INV.CanUseItem(itemName)
    local callback = type(itemData) == 'table' and (rawget(itemData, '__cfx_functionReference') and itemData or itemData.cb or itemData.callback) or type(itemData) == 'function' and itemData
    if not callback then return end
    -- print('am here dude fuck you')
    callback(...)
end exports('UseItem', _INV.UseItem)

CreateThread(function()
    TriggerEvent("comet-base:exportsReady")
end)

AddEventHandler("comet-base:exportsReady", function()
    exports['comet-base']:CreateComponent("Inventory", _INV)

    exports['comet-base']:FetchComponent("Callback").Register('GetCurrentCash', function(source, data)
        local Player = exports['comet-base']:FetchComponent("Player").GetBySource(source)
        return Player.PlayerData.money.cash
    end)
    
    exports['comet-base']:FetchComponent("Callback").Register('CheckLicenseForCharacter', function(source, data)
        -- print(pCid, pType)
        -- local typyes = {
        --     [2] = true,
        --     [12] = true,
        -- }
        -- return true
        return true
    end)
    
end)

-- TriggerServerEvent("inventory:server:OpenInventory", "stash","housestash".. Config.stash[data.stashname].name, {
--     maxweight = Config.stash[data.stashname].weight,
--     slots =  Config.stash[data.stashname].slot,
-- })

-- RegisterNetEvent('', function()
--     TriggerEvent("server-inventory-open", "1", ("personalStorage-%s-%s"):format(location, cid))
-- end)



RegisterServerEvent("cash:remove")
AddEventHandler("cash:remove", function(pSource, pAmount)
    local Player = exports['comet-base']:FetchComponent("Player").GetBySource(pSource)
    Player.RemoveMoney('cash', pAmount)
end)

RegisterServerEvent('comet-inventory:itemUsed')
AddEventHandler('comet-inventory:itemUsed', function(itemid, passedItemInfo, inventoryName, slot)
	local src = source
	_INV.UseItem(itemid, src, json.decode(passedItemInfo))
end)


function hasjewls(pItemId, pCid)
	local amount = 0
	local checkQuality = true
        local invId = 'container-jewelry:'..pCid..'-Jewelry-jewelry'
        local query = 'SELECT count(item_id) as amount FROM user_inventory2 WHERE name = @inventory AND item_id = @item'
        local p = promise:new()

        local decayDate

        if checkQuality then
            decayDate = exports['comet-inventory']:GetDecayDate(pItemId)

            if decayDate then
                query = query .. ' AND @decayDate < creationDate'
            end
        end

        exports.oxmysql:scalar(query, { ['inventory'] = invId, ['item'] = pItemId, ['decayDate'] = decayDate}, function(data)
            p:resolve(data and data or 0)
        end)

        amount = Citizen.Await(p)
    return amount
end

RegisterNetEvent('server-inventory-refresh')
AddEventHandler('server-inventory-refresh', function(pCid)
    local src = source
    if pCid == 0 then return end
    if hasjewls('jewelry_relic', pCid) > 0 or hasjewls('jewelry_necklace', pCid) > 0 or hasjewls('jewelry_ring', pCid) > 0 then
        TriggerClientEvent('qb-hud:givemebuffs', src, 'dollar', 1)
    else
        TriggerClientEvent('qb-hud:givemebuffs', src, 'dollar', 0)
    end
end)