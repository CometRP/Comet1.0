local hasDonePreloading = {}

Callback = nil or exports['comet-base']:FetchComponent("Callback")
Functions = nil or exports['comet-base']:FetchComponent("Functions")
Player = nil or exports['comet-base']:FetchComponent("Player")
AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback"
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
        Functions = exports['comet-base']:FetchComponent("Functions")
        Player = exports['comet-base']:FetchComponent("Player")
        print("[COMET-MULTICHARACTER] Loaded Components")
    end)
end)
-- Mai

-- Functions

local function GiveStarterItems(source)
    local src = source
    local Player = exports['comet-base']:FetchComponent("Player").GetBySource(src)

    for _, v in pairs(exports['comet-base']:FetchComponent("Shared").StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.cid = Player.PlayerData.cid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end

local function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    -- TriggerClientEvent("qb-garages:client:houseGarageConfig", -1, HouseGarages)
    -- TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Houses)
end

-- Commands

CreateThread(function()

    local Command = exports['comet-base']:FetchComponent("Commands")

    while not Command do
        Wait(15)
    end

    Command.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
        local src = source
        exports['comet-base']:FetchComponent("Player").Logout(src)
        TriggerClientEvent('comet-multicharacter:client:chooseChar', src)
    end, "admin")

end)

-- exports['comet-base']:FetchComponent("Commands").Add("closeNUI", "Close Multi NUI", {}, false, function(source)
--     local src = source
--     TriggerClientEvent('comet-multicharacter:client:closeNUI', src)
-- end)

-- Events

AddEventHandler('comet-base:loadedPlayer', function(Player)
    Wait(1000) -- 1 second should be enough to do the preloading in other resources
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('comet-base:playerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('comet-multicharacter:server:disconnect', function()
    local src = source
    DropPlayer(src, "You have disconnected from CometRP")
end)

RegisterNetEvent('comet-multicharacter:server:loadUserData', function(cData)
    local src = source
    if exports['comet-base']:FetchComponent("Player").Login(src, cData.cid) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        print('^2[comet-base]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.cid..') has succesfully loaded!')
        exports['comet-base']:FetchComponent("Commands").Refresh(src)
        TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
        -- TriggerClientEvent('ps-housing:client:setupSpawnUI', src, cData)
        -- TriggerEvent("qb-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** (<@"..(Functions.GetIdentifier(src, 'discord'):gsub("discord:", "") or "unknown").."> |  ||"  ..(Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.cid.." | "..src..") loaded..")
    end
end)

RegisterNetEvent('comet-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if exports['comet-base']:FetchComponent("Player").Login(src, false, newData) then
        repeat
            Wait(10)
        until hasDonePreloading[src]
        -- if Apartments.Starting then
        --     local randbucket = (GetPlayerPed(src) .. math.random(1,999))
        --     SetPlayerRoutingBucket(src, randbucket)
        --     print('^2[qb-core]^7 '..GetPlayerName(src)..' has successfully loaded!')
        --     exports['comet-base']:FetchComponent("Commands").Refresh(src)
        --     loadHouseData(src)
        --     TriggerClientEvent("comet-multicharacter:client:closeNUI", src)
        --     TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
        --     GiveStarterItems(src)
        -- else
            print('^2[qb-core]^7 '..GetPlayerName(src)..' has successfully loaded!')
            exports['comet-base']:FetchComponent("Commands").Refresh(src)
            loadHouseData(src)
            TriggerClientEvent("comet-multicharacter:client:closeNUIdefault", src)
            -- GiveStarterItems(src)
        -- end
    end
end)


-- RegisterNetEvent('comet-multicharacter:server:createCharacter', function(data)
--     local src = source
--     local newData = {}
--     newData.cid = data.cid
--     newData.charinfo = data
--     if exports['comet-base']:FetchComponent("Player").Login(src, false, newData) then
--         repeat
--             Wait(10)
--         until hasDonePreloading[src]
--         print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
--         exports['comet-base']:FetchComponent("Commands").Refresh(src)
--         TriggerClientEvent("comet-multicharacter:client:closeNUI", src)
--         newData.cid = QBCore.Functions.GetPlayer(src).PlayerData.cid
--         TriggerClientEvent('apartments:client:setupSpawnUI', src, newData, true)
--         -- TriggerClientEvent('ps-housing:client:setupSpawnUI', src, newData)
--         GiveStarterItems(src)
--     end
-- end)

RegisterNetEvent('comet-multicharacter:server:deleteCharacter', function(cid)
    local src = source
    exports['comet-base']:FetchComponent("Player").DeleteCharacter(src, cid)
end)

-- Callbacks

CreateThread(function()

    local Callback = exports['comet-base']:FetchComponent("Callback")
    local Functions = exports['comet-base']:FetchComponent("Functions")

    while not Callback do
        Wait(15)
    end
    while not Functions do
        Wait(15)
    end

    Callback.Register("comet-multicharacter:server:GetUserCharacters", function(data)
        local src = source
        local license = Functions.GetIdentifier(src, 'license')
        MySQL.Async.execute('SELECT * FROM players WHERE license = ?', {license}, function(result)
            return result
        end)
    end)
    
    Callback.Register("comet-multicharacter:server:GetServerLogs", function(data)
        MySQL.Async.execute('SELECT * FROM server_logs', {}, function(result)
            return result
        end)
    end)
    
    Callback.Register("comet-multicharacter:server:GetNumberOfCharacters", function(data)
        print("test")
        local src = source
        print(src, source)
        local license = Functions.GetIdentifier(src, 'license')
        local numOfChars = 0
    
        if next(Config.PlayersNumberOfCharacters) then
            for i, v in pairs(Config.PlayersNumberOfCharacters) do
                if v.license == license then
                    numOfChars = v.numberOfChars
                    break
                else 
                    numOfChars = Config.DefaultNumberOfCharacters
                end
            end
        else
            numOfChars = Config.DefaultNumberOfCharacters
        end
        return numOfChars
    end)
    
    Callback.Register("comet-multicharacter:server:setupCharacters", function(data)
        local source = source
        local license = Functions.GetIdentifier(source, 'license')
        local plyChars = {}
        MySQL.Async.fetchAll('SELECT * FROM players WHERE license = ?', {license}, function(result)
            for i = 1, (#result), 1 do
                result[i].charinfo = json.decode(result[i].charinfo)
                result[i].money = json.decode(result[i].money)
                result[i].job = json.decode(result[i].job)
                plyChars[#plyChars+1] = result[i]
            end
            return plyChars
        end)
        return plyChars
    end)
    
    Callback.Register("comet-multicharacter:server:getSkin", function(data)
        local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE cid = ? AND active = ?', {data.cid, 1})
        if result[1] ~= nil then
            return result[1].model, result[1].skin
        else
            return nil
        end
    end)
    
end)