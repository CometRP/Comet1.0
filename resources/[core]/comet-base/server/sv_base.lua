-- RegisterNetEvent('paycheck:collect:log')
-- AddEventHandler('paycheck:collect:log', function()
--     local src = source
--     local user = exports["comet-base"]:FetchComponent("Player"):GetUser(src)
--     local hexId = user:getVar("hexid")
--     local pName = GetPlayerName(source)
--     local pDiscord = GetPlayerIdentifiers(src)[3]
--     local LogData = {
--         {
--             ['description'] = string.format("`%s`\n\n`• Server Id: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Picked up their paycheck!", src, hexId, pDiscord),
--             ['color'] = 2317994,
--             ['author'] = {
--                 ['name'] = "Steam Name: "..pName
--             },
--         }
--     }

--     PerformHttpRequest(webhook5, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })
-- end)

Components.Base = Components.Base or {}

-- function Components.Base.ConsoleLog(self, msg, mod, ply)
-- 	if not tostring(msg) then return end
-- 	if not tostring(mod) then mod = "No Module" end

-- 	local pMsg = string.format("^3[ot LOG - %s]^7 %s", mod, msg)
-- 	if not pMsg then return end

-- 	if ply and tonumber(ply) then
-- 		TriggerClientEvent("comet-base:consoleLog", ply, msg, mod)
-- 	end
-- end


AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("comet-base:waitForExports", -1)

	if not Components.Base.ExportsReady then return end

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(0)
			if Components.Base.ExportsReady then
				TriggerEvent("comet-base:refreshComponents")
				return
			else
			end
		end
	end)
end)