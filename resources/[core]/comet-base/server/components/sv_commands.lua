Components.Commands = {}
Components.Commands.List = {}
Components.Commands.IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['god'] = true, -- We don't need to create an ace because god is allowed all commands
    ['user'] = true -- We don't need to create an ace because builtin.everyone
}

CreateThread(function() -- Add ace to node for perm checking
    local permissions = Shared.Config.Server.Permissions
    for i=1, #permissions do
        local permission = permissions[i]
        ExecuteCommand(('add_ace comet.%s %s allow'):format(permission, permission))
    end
end)

-- Register & Refresh Commands

function Components.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    local restricted = true -- Default to restricted for all commands
    if not permission then permission = 'user' end -- some commands don't pass permission level
    if permission == 'user' then restricted = false end -- allow all users to use command

    RegisterCommand(name, function(source, args, rawCommand) -- Register command within fivem
        if argsrequired and #args < #arguments then
            return TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", Lang:t("error.missing_args2")}
            })
        end
        callback(source, args, rawCommand)
    end, restricted)

    local extraPerms = ... and table.pack(...) or nil
    if extraPerms then
        extraPerms[extraPerms.n + 1] = permission -- The `n` field is the number of arguments in the packed table
        extraPerms.n += 1
        permission = extraPerms
        for i = 1, permission.n do
            if not Components.Commands.IgnoreList[permission[i]] then -- only create aces for extra perm levels
                ExecuteCommand(('add_ace comet.%s command.%s allow'):format(permission[i], name))
            end
        end
        permission.n = nil
    else
        permission = tostring(permission:lower())
        if not Components.Commands.IgnoreList[permission] then -- only create aces for extra perm levels
            ExecuteCommand(('add_ace comet.%s command.%s allow'):format(permission, name))
        end
    end

    Components.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function Components.Commands.Refresh(source)
    local src = source
    local Player = Components.Player.GetBySource(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(Components.Commands.List) do
            local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.'..command)
            if hasPerm then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', src, suggestions)
    end
end

RegisterNetEvent('comet-base:callCommand', function(command, args)
    local src = source
    if not Components.Commands.List[command] then return end
    local Player = Components.Player.GetBySource(src)
    if not Player then return end
    local hasPerm = Components.Functions.HasPermission(src, "command."..Components.Commands.List[command].name)
    if hasPerm then
        if Components.Commands.List[command].argsrequired and #Components.Commands.List[command].arguments ~= 0 and not args[#Components.Commands.List[command].arguments] then
            -- TriggerClientEvent('QBCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            Components.Commands.List[command].callback(src, args)
        end
    else
        -- TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Teleport
Components.Commands.Add('tp', Lang:t("command.tp.help"), { { name = Lang:t("command.tp.params.x.name"), help = Lang:t("command.tp.params.x.help") }, { name = Lang:t("command.tp.params.y.name"), help = Lang:t("command.tp.params.y.help") }, { name = Lang:t("command.tp.params.z.name"), help = Lang:t("command.tp.params.z.help") } }, false, function(source, args)
    if args[1] and not args[2] and not args[3] then
        if tonumber(args[1]) then
        local target = GetPlayerPed(tonumber(args[1]))
        if target ~= 0 then
            local coords = GetEntityCoords(target)
            TriggerClientEvent('comet-base:teleportToPlayer', source, coords)
        else
            -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
        end
    else
            local location = QBShared.Locations[args[1]]
            if location then
                TriggerClientEvent('comet-base:teleportToCoords', source, location.x, location.y, location.z, location.w)
            else
                -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.location_not_exist'), 'error')
            end
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(",",""))) + .0
            local y = tonumber((args[2]:gsub(",",""))) + .0
            local z = tonumber((args[3]:gsub(",",""))) + .0
            if x ~= 0 and y ~= 0 and z ~= 0 then
                TriggerClientEvent('comet-base:teleportToCoords', source, x, y, z)
            else
                -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.wrong_format'), 'error')
            end
        else
            -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.missing_args'), 'error')
        end
    end
end, 'admin')

Components.Commands.Add('tpm', Lang:t("command.tpm.help"), {}, false, function(source)
    TriggerClientEvent('QBCore:Command:GoToMarker', source)
end, 'admin')

Components.Commands.Add('togglepvp', Lang:t("command.togglepvp.help"), {}, false, function()
    Shared.Config.Server.PVP = not Shared.Config.Server.PVP
    TriggerClientEvent('comet-base:pvpToggle', -1, Shared.Config.Server.PVP)
end, 'admin')

-- Permissions

Components.Commands.Add('addpermission', Lang:t("command.addpermission.help"), { { name = Lang:t("command.addpermission.params.id.name"), help = Lang:t("command.addpermission.params.id.help") }, { name = Lang:t("command.addpermission.params.permission.name"), help = Lang:t("command.addpermission.params.permission.help") } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Components.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

Components.Commands.Add('removepermission', Lang:t("command.removepermission.help"), { { name = Lang:t("command.removepermission.params.id.name"), help = Lang:t("command.removepermission.params.id.help") }, { name = Lang:t("command.removepermission.params.permission.name"), help = Lang:t("command.removepermission.params.permission.help") } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Components.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

-- Open & Close Server

Components.Commands.Add('openserver', Lang:t("command.openserver.help"), {}, false, function(source)
    if not Shared.Config.Server.Closed then
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.server_already_open'), 'error')
        return
    end
    if Components.Functions.HasPermission(source, 'admin') then
        Shared.Config.Server.Closed = false
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('success.server_opened'), 'success')
    else
        Components.Player.Kick(source, Lang:t("error.no_permission"), nil, nil)
    end
end, 'admin')

Components.Commands.Add('closeserver', Lang:t("command.closeserver.help"), {{ name = Lang:t("command.closeserver.params.reason.name"), help = Lang:t("command.closeserver.params.reason.help")}}, false, function(source, args)
    if Shared.Config.Server.Closed then
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.server_already_closed'), 'error')
        return
    end
    if Components.Functions.HasPermission(source, 'admin') then
        local reason = args[1] or 'No reason specified'
        Shared.Config.Server.Closed = true
        Shared.Config.Server.ClosedReason = reason
        for k in pairs(Components.Players) do
            if not Components.Functions.HasPermission(k, Shared.Config.Server.WhitelistPermission) then
                Components.Player.Kick(k, reason, nil, nil)
            end
        end
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('success.server_closed'), 'success')
    else
        Components.Player.Kick(source, Lang:t("error.no_permission"), nil, nil)
    end
end, 'admin')

-- Vehicle

-- Components.Commands.Add('car', Lang:t("command.car.help"), {{ name = Lang:t("command.car.params.model.name"), help = Lang:t("command.car.params.model.help") }}, true, function(source, args)
--     TriggerClientEvent('QBCore:Command:SpawnVehicle', source, args[1])
-- end, 'admin')

-- Components.Commands.Add('dv', Lang:t("command.dv.help"), {}, false, function(source)
--     TriggerClientEvent('QBCore:Command:DeleteVehicle', source)
-- end, 'admin')

-- Money

Components.Commands.Add('givemoney', Lang:t("command.givemoney.help"), { { name = Lang:t("command.givemoney.params.id.name"), help = Lang:t("command.givemoney.params.id.help") }, { name = Lang:t("command.givemoney.params.moneytype.name"), help = Lang:t("command.givemoney.params.moneytype.help") }, { name = Lang:t("command.givemoney.params.amount.name"), help = Lang:t("command.givemoney.params.amount.help") } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    if Player then
        Player.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

Components.Commands.Add('setmoney', Lang:t("command.setmoney.help"), { { name = Lang:t("command.setmoney.params.id.name"), help = Lang:t("command.setmoney.params.id.help") }, { name = Lang:t("command.setmoney.params.moneytype.name"), help = Lang:t("command.setmoney.params.moneytype.help") }, { name = Lang:t("command.setmoney.params.amount.name"), help = Lang:t("command.setmoney.params.amount.help") } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    if Player then
        Player.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        -- TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Job

-- QBCore.Commands.Add('job', Lang:t("command.job.help"), {}, false, function(source)
--     local PlayerJob = Components.Player.GetBySource(source).PlayerData.job
--     TriggerClientEvent('QBCore:Notify', source, Lang:t('info.job_info', {value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
-- end, 'user')

-- QBCore.Commands.Add('setjob', 'Set A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' }, { name = 'grade', help = 'Grade' } }, true, function(source, args)
--     local Player = Components.Player.GetBySource(tonumber(args[1]))
--     if Player then
--         local job = tostring(args[2])
--         local grade = tonumber(args[3])
--         local sgrade = tostring(args[3])
--         local jobInfo = QBCore.Shared.Jobs[job]
--         if jobInfo then
--             if jobInfo["grades"][sgrade] then
--                 Player.SetJob(job, grade)
--                 exports['qb-phone']:hireUser(job, Player.PlayerData.citizenid, grade)
--             else
--                 TriggerClientEvent('QBCore:Notify', source, "Not a valid grade", 'error')
--             end
--         else
--             TriggerClientEvent('QBCore:Notify', source, "Not a valid job", 'error')
--         end
--     else
--         TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
--     end
-- end, 'admin')

-- QBCore.Commands.Add('removejob', 'Removes A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' } }, true, function(source, args)
--     local Player = Components.Player.GetBySource(tonumber(args[1]))
--     if Player then
--         if Player.PlayerData.job.name == tostring(args[2]) then
--             Player.SetJob("unemployed", 0)
--         end
--         exports['qb-phone']:fireUser(tostring(args[2]), Player.PlayerData.citizenid)
--     else
--         TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
--     end
-- end, 'admin')
-- Gang

-- QBCore.Commands.Add('gang', Lang:t("command.gang.help"), {}, false, function(source)
--     local PlayerGang = Components.Player.GetBySource(source).PlayerData.gang
--     TriggerClientEvent('QBCore:Notify', source, Lang:t('info.gang_info', {value = PlayerGang.label, value2 = PlayerGang.grade.name}))
-- end, 'user')

-- QBCore.Commands.Add('setgang', Lang:t("command.setgang.help"), { { name = Lang:t("command.setgang.params.id.name"), help = Lang:t("command.setgang.params.id.help") }, { name = Lang:t("command.setgang.params.gang.name"), help = Lang:t("command.setgang.params.gang.help") }, { name = Lang:t("command.setgang.params.grade.name"), help = Lang:t("command.setgang.params.grade.help") } }, true, function(source, args)
--     local Player = Components.Player.GetBySource(tonumber(args[1]))
--     if Player then
--         Player.SetGang(tostring(args[2]), tonumber(args[3]))
--     else
--         TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
--     end
-- end, 'admin')
