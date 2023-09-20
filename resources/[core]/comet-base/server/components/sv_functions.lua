Components.Functions = Components.Functions or {}
Components.Player_Buckets = Components.Player_Buckets or {}
Components.Entity_Buckets = Components.Entity_Buckets or {}
-- Components.UsableItems = {}

function Components.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

function Components.Functions.GetIdentifier(source, idtype)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

function Components.Functions.GetSource(identifier)
    for src, _ in pairs(Components.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end


-- Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
function Components.Functions.GetBucketObjects()
    return Components.Player_Buckets, Components.Entity_Buckets
end

-- Will set the provided player id / source into the provided bucket id
function Components.Functions.SetPlayerBucket(source --[[ int ]], bucket --[[ int ]])
    if source and bucket then
        local plicense = Components.Functions.GetIdentifier(source, 'license')
        SetPlayerRoutingBucket(source, bucket)
        Components.Player_Buckets[plicense] = {id = source, bucket = bucket}
        return true
    else
        return false
    end
end

-- Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
function Components.Functions.SetEntityBucket(entity --[[ int ]], bucket --[[ int ]])
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        Components.Entity_Buckets[entity] = {id = entity, bucket = bucket}
        return true
    else
        return false
    end
end

-- Will return an array of all the player ids inside the current bucket
function Components.Functions.GetPlayersInBucket(bucket --[[ int ]])
    local curr_bucket_pool = {}
    if Components.Player_Buckets and next(Components.Player_Buckets) then
        for _, v in pairs(Components.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

-- Will return an array of all the entities inside the current bucket (not for player entities, use GetPlayersInBucket for that)
function Components.Functions.GetEntitiesInBucket(bucket --[[ int ]])
    local curr_bucket_pool = {}
    if Components.Entity_Buckets and next(Components.Entity_Buckets) then
        for _, v in pairs(Components.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

-- Check if player is whitelisted, kept like this for backwards compatibility or future plans

function Components.Functions.IsWhitelisted(source)
    if not Shared.Config.Server.Whitelist then setdicordid(source) return true end
    if Components.Functions.HasPermission(source, Shared.Config.Server.WhitelistPermission) then
        setdicordid(source)
		
         return true end
    return false
end

-- Setting & Removing Permissions

function Components.Functions.AddPermission(source, permission)
    if not IsPlayerAceAllowed(source, permission) then
        ExecuteCommand(('add_principal player.%s comet.%s'):format(source, permission))
        Components.Commands.Refresh(source)
    end
end

function Components.Functions.RemovePermission(source, permission)
    if permission then
        if IsPlayerAceAllowed(source, permission) then
            ExecuteCommand(('remove_principal player.%s comet.%s'):format(source, permission))
            Components.Commands.Refresh(source)
        end
    else
        for _, v in pairs(Shared.Config.Server.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                ExecuteCommand(('remove_principal player.%s comet.%s'):format(source, v))
                Components.Commands.Refresh(source)
            end
        end
    end
end

-- Checking for Permission Level

function Components.Functions.HasPermission(source, permission)
    if type(permission) == "string" then
        if IsPlayerAceAllowed(source, permission) then return true end
    elseif type(permission) == "table" then
        for _, permLevel in pairs(permission) do
            if IsPlayerAceAllowed(source, permLevel) then return true end
        end
    end

    return false
end

function Components.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs (Shared.Config.Server.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end

-- Opt in or out of admin reports

function Components.Functions.IsOptin(source)
    local license = Components.Functions.GetIdentifier(source, 'license')
    if not license or not Components.Functions.HasPermission(source, 'admin') then return false end
    local Player = Components.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

function Components.Functions.ToggleOptin(source)
    local license = Components.Functions.GetIdentifier(source, 'license')
    if not license or not Components.Functions.HasPermission(source, 'admin') then return end
    local Player = Components.Player.GetBySource(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.SetPlayerData('optin', Player.PlayerData.optin)
end

-- Check if player is banned

function Components.Functions.IsPlayerBanned(source)
    local plicense = Components.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

-- Check for duplicate license

function Components.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, id in pairs(identifiers) do
            if string.find(id, 'license') then
                if id == license then
                    return true
                end
            end
        end
    end
    return false
end
