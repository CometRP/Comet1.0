Callback, Player = nil, nil

AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback",
		"Player",
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
		Player = exports['comet-base']:FetchComponent("Player")
    end)
end)


-- local QBCore = exports['qb-core']:GetCoreObject()
-- RegisterServerEvent("itemMoneyCheck")
-- AddEventHandler("itemMoneyCheck", function(itemType,askingPrice,location)
-- 	local src = source
--     local user = exports["qb-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()
-- 	if (user:getCash() >= askingPrice) then
-- 		user:removeMoney(askingPrice) 
-- 		if askingPrice > 0 then
-- 			TriggerClientEvent('qb-notification:client:Alert', src, {style = 'info', duration = 3000, message = "Purchased"})
-- 		end
-- 		TriggerClientEvent("player:receiveItem",src,itemType,1)

-- 	else
-- 		TriggerClientEvent('qb-notification:client:Alert', src, {style = 'error', duration = 3000, message = "Not enough money!"})
-- 	end
-- end)

-- RegisterServerEvent("shop:useVM:server")
-- AddEventHandler("shop:useVM:server", function(locatoion)
-- 	local src = source
--     local user = exports["qb-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()
-- 	if (tonumber(pCash) >= 20) then
-- 		TriggerClientEvent("shop:useVM:finish",src)
-- 		user:removeMoney(20) 
-- 	else
-- 		TriggerClientEvent('qb-notification:client:Alert', src, {style = 'error', duration = 3000, message = "You need 20$"})
-- 	end
-- end)

local locations = {}
local itemTypes = {}

-- RegisterServerEvent("take100")
-- AddEventHandler("take100", function(tgtsent)
--     local user = exports["qb-base"]:getModule("Player"):GetUser(tgtsent)
--     local char = user:getCurrentCharacter()
-- 	user:removeMoney(100) 
-- end)

-- RegisterServerEvent("movieticket")
-- AddEventHandler("movieticket", function(askingPrice)
-- 	local src = source
--     local user = exports["qb-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()
-- 	if (user:getCash() >= askingPrice) then
-- 		user:removeMoney(askingPrice) 
-- 		TriggerClientEvent("startmovies",src)
-- 	else
-- 		TriggerClientEvent('qb-notification:client:Alert', src, {style = 'error', duration = 3000, message = "Not enough money!"})
-- 	end
-- end)

-- RegisterServerEvent('shops:GetIDCardSV')
-- AddEventHandler('shops:GetIDCardSV', function()
-- 	local src = source
--     local user = exports["qb-base"]:getModule("Player"):GetUser(src)
--     local char = user:getCurrentCharacter()
-- 	if (user:getCash() >= 500) then
-- 		user:removeMoney(500)
-- 		TriggerClientEvent("player:receiveItem", src, 'idcard', 1)
-- 	else
-- 		TriggerClientEvent('qb-notification:client:Alert', src, {style = 'error', duration = 3000, message = "Not enough money!"})
-- 	end
-- end)

RegisterServerEvent("comet-stores:WeaponShopStatus")
AddEventHandler("comet-stores:WeaponShopStatus", function()
	local src = source
	-- local user = exports["qb-base"]:getModule("Player"):GetUser(src)
	-- local char = user:getCurrentCharacter()
	-- exports.oxmysql:execute("SELECT status FROM user_licenses WHERE cid = @cid AND type = @type ",{['@cid'] = char.id, ['@type'] = 'weapon'}, function(result)
	-- 	if result[1].status == 1 then 
	-- 		TriggerClientEvent("server-inventory-open", src, "5", "Shop");
	-- 		Wait(1000)
	-- 	else
			TriggerClientEvent("server-inventory-open", src, "weapon", "Shop");
	-- 		Wait(1000)
	-- 		TriggerClientEvent("DoLongHudText", src, "You dont have an active weapons license, contact the police.", 2)
	-- 	end
	-- end)
end)

-- local count = 0
-- RegisterNetEvent('rich:GetPlayers')
-- AddEventHandler('rich:GetPlayers', function()
--     count = 0
--     for _, playerId in ipairs(GetPlayers()) do
-- 			count = count + 1
--     end
--     TriggerClientEvent('rich:TakePlayers', -1, count)
-- end)

CreateThread(function()
	while not Callback do Wait(15) end
	Callback.Register('comet-stores:GetCurrentPlayers', function(data)
		local TotalPlayers = 0
		local players = Player.GetPlayers()
		for _ in pairs(players) do
			TotalPlayers = TotalPlayers + 1
		end
		return TotalPlayers
	end)
	
end)