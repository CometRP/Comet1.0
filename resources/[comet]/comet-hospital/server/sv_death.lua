RegisterServerEvent('comet-hospital:removeallitems', function()
    -- exports.ox_inventory.Clear(source)
end)


CreateThread(function()
	TriggerEvent("comet-base:exportsReady")
end)

AddEventHandler("comet-base:exportsReady", function()
	exports['comet-base']:FetchComponent("Commands").Add('revive2', 'Revive Player (Admin Only)', { { name = 'id', help = 'Player ID' } }, true, function(source, args)
		local src = tonumber(args[1])
		local Player = exports['comet-base']:FetchComponent("Player").GetBySource(src)
		if Player then
			TriggerClientEvent("reviveFunction", src or source)
		else
			TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
		end
	end, 'admin')
	
end)

-- lib.addCommand('group.admin', 'revive', function(source, args)
--     TriggerClientEvent("reviveFunction", tonumber(args.target) or args.target)
-- end, {'target'})



RegisterServerEvent('trycpr')
AddEventHandler('trycpr', function()

end)

RegisterServerEvent('serverCPR')
AddEventHandler('serverCPR', function()
	TriggerClientEvent('revive', source)
end)


RegisterServerEvent('comet-hospital:reviveSV')
AddEventHandler('comet-hospital:reviveSV', function(t)
	TriggerClientEvent('comet-hospital:revive', t)

end)

RegisterServerEvent('comet-hospital:reviveSV2')
AddEventHandler('comet-hospital:reviveSV2', function()
	TriggerClientEvent('comet-hospital:revive', source)
end)