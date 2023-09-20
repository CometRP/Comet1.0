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
                args = {"System", 'All arguments must be filled out!'}
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
            TriggerClientEvent('QBCore:Notify', src, 'All arguments must be filled out!', 'error')
        else
            Components.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'No access to this command', 'error')
    end
end)

-- Teleport
Components.Commands.Add('tp', 'TP To Player or Coords (Admin Only)', { { name = 'id/x', help = 'ID of player or X position' }, { name = 'y', help = 'Y position' }, { name = 'z', help = 'Z position' } }, false, function(source, args)
    if args[1] and not args[2] and not args[3] then
        if tonumber(args[1]) then
            local target = GetPlayerPed(tonumber(args[1]))
            if target ~= 0 then
                local coords = GetEntityCoords(target)
                TriggerClientEvent('comet-base:teleportToPlayer', source, coords)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Player Not Online', 'error')
            end
        else
            -- local location = Shared.Locations[args[1]]
            -- if location then
            --     TriggerClientEvent('comet-base:teleportToCoords', source, location.x, location.y, location.z, location.w)
            -- else
            --     -- TriggerClientEvent('QBCore:Notify', source, "Location does not exist", 'error')
            -- end
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(",",""))) + .0
            local y = tonumber((args[2]:gsub(",",""))) + .0
            local z = tonumber((args[3]:gsub(",",""))) + .0
            if x ~= 0 and y ~= 0 and z ~= 0 then
                TriggerClientEvent('comet-base:teleportToCoords', source, x, y, z)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Incorrect Format', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Not every argument has been entered (x, y, z)', 'error')
        end
    end
end, 'admin')

Components.Commands.Add('tpm','TP To Marker (Admin Only)', {}, false, function(source)
    TriggerClientEvent('comet-base:goToMarker', source)
end, 'admin')

Components.Commands.Add('togglepvp','Toggle PVP on the server (Admin Only)', {}, false, function()
    Shared.Config.Server.PVP = not Shared.Config.Server.PVP
    TriggerClientEvent('comet-base:pvpToggle', -1, Shared.Config.Server.PVP)
end, 'admin')

-- Permissions

Components.Commands.Add('addpermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Components.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Player Not Online', 'error')
    end
end, 'god')

Components.Commands.Add('removepermission', 'Remove Players Permissions (God Only)', { { name = 'id', help = 'ID of player' } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        Components.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Player Not Online', 'error')
    end
end, 'god')

-- Open & Close Server

Components.Commands.Add('openserver', "Open the server for everyone (Admin Only)", {}, false, function(source)
    if not Shared.Config.Server.Closed then
        TriggerClientEvent('QBCore:Notify', source, 'The server is already open', 'error')
        return
    end
    if Components.Functions.HasPermission(source, 'admin') then
        Shared.Config.Server.Closed = false
        TriggerClientEvent('QBCore:Notify', source, 'The server has been opened', 'success')
    else
        Components.Player.Kick(source, 'You don\'t have permissions for this..', nil, nil)
    end
end, 'admin')

Components.Commands.Add('closeserver', "Close the server for people without permissions (Admin Only)", { {  name = 'reason', help = 'Reason for closing (optional)'  } }, false, function(source, args)
    if Shared.Config.Server.Closed then
        TriggerClientEvent('QBCore:Notify', source, 'The server is already closed', 'error')
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
        TriggerClientEvent('QBCore:Notify', source, 'The server has been closed', 'success')
    else
        Components.Player.Kick(source, 'You don\'t have permissions for this..', nil, nil)
    end
end, 'admin')

-- Vehicle

Components.Commands.Add('car', 'Spawn Vehicle (Admin Only)', { { name = 'model', help = 'Model name of the vehicle' } }, true, function(source, args)
    local src = source
    TriggerClientEvent('comet-base:spawnVehicle', src, args[1])
end, 'admin')

Components.Commands.Add('dv', 'Delete Vehicle (Admin Only)', {}, false, function(source)
    local src = source
    TriggerClientEvent('comet-base:deleteVehicle', src)
end, 'admin')

-- Money

Components.Commands.Add('givemoney', 'Give A Player Money (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    if Player then
        Player.AddMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
    end
end, 'admin')

Components.Commands.Add('setmoney', 'Set Players Money Amount (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'moneytype', help = 'Type of money (cash, bank, crypto)' }, { name = 'amount', help = 'Amount of money' } }, true, function(source, args)
    local Player = Components.Player.GetBySource(tonumber(args[1]))
    if Player then
        Player.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
    end
end, 'admin')

-- Job

-- QBCore.Commands.Add('job', "'Check Your Job'", {}, false, function(source)
--     local PlayerJob = Components.Player.GetBySource(source).PlayerData.job
--     TriggerClientEvent('QBCore:Notify', source, ('Job: %s | Grade: %s | Duty: %s'):format(PlayerJob.label,PlayerJob.grade.name, {layerJob.onduty}))
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
--                 exports['qb-phone']:hireUser(job, Player.PlayerData.cid, grade)
--             else
--                 TriggerClientEvent('QBCore:Notify', source, "Not a valid grade", 'error')
--             end
--         else
--             TriggerClientEvent('QBCore:Notify', source, "Not a valid job", 'error')
--         end
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
--     end
-- end, 'admin')

-- QBCore.Commands.Add('removejob', 'Removes A Players Job (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'job', help = 'Job name' } }, true, function(source, args)
--     local Player = Components.Player.GetBySource(tonumber(args[1]))
--     if Player then
--         if Player.PlayerData.job.name == tostring(args[2]) then
--             Player.SetJob("unemployed", 0)
--         end
--         exports['qb-phone']:fireUser(tostring(args[2]), Player.PlayerData.cid)
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
--     end
-- end, 'admin')
-- Gang

-- QBCore.Commands.Add('gang', "Check Your Gang", {}, false, function(source)
--     local PlayerGang = Components.Player.GetBySource(source).PlayerData.gang
--     TriggerClientEvent('QBCore:Notify', source, ('Gang: %s | Grade: %s'):format(PlayerGang.label, PlayerGang.grade.name))
-- end, 'user')

-- QBCore.Commands.Add('setgang', "Set A Players Gang (Admin Only)", { { name = 'id', help = 'Player ID' }, { name = 'gang', help = 'Gang name' },  { name = 'grade', help = 'Gang grade' } }, true, function(source, args)
--     local Player = Components.Player.GetBySource(tonumber(args[1]))
--     if Player then
--         Player.SetGang(tostring(args[2]), tonumber(args[3]))
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Player not online', 'error')
--     end
-- end, 'admin')
