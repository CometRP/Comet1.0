Components.Players = Components.Players or {}
Components.Player = Components.Player or {}

Components.Player.GetBySource = function(source)
    if type(source) == 'number' then
        return Components.Players[source]
    else
        return Components.Players[Components.Functions.GetSource(source)]
    end
end

Components.Player.GetByCid = function(cid)
    for src in pairs(Components.Players) do
        if Components.Players[src].PlayerData.cid == cid then
            return Components.Players[src]
        end
    end
    return nil
end

Components.Player.GetOfflinePlayerByCid = function(cid)
    return Components.Player.GetOfflinePlayer(cid)
end

Components.Player.GetByPhone = function(number)
    for src in pairs(Components.Players) do
        if Components.Players[src].PlayerData.charinfo.phone == number then
            return Components.Players[src]
        end
    end
    return nil
end


Components.Player.GetPlayers = function()
    local sources = {}
    for k in pairs(Components.Players) do
        sources[#sources+1] = k
    end
    return sources
end

-- Will return an array of QB Player class instances
-- unlike the GetPlayers() wrapper which only returns IDs
Components.Player.GetCometPlayers = function()
    return Components.Players
end

Components.Player.Login = function(source, cid, newData)
    local src = source
    if src then
        if cid then
            local license = Components.Functions.GetIdentifier(src, 'license')
            local PlayerData = MySQL.Sync.prepare('SELECT * FROM players where cid = ?', { cid })
            if PlayerData and license == PlayerData.license then
                TriggerClientEvent('updatecid', source, cid)
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
                Components.Player.CheckPlayerData(src, PlayerData)
            else
                DropPlayer(src, 'You Have Been Kicked For Exploitation')
                -- TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(src) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            Components.Player.CheckPlayerData(src, newData)
        end
        return true
    else
        -- Components.ShowError(GetCurrentResourceName(), 'ERROR COMPONENTS.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end


Components.Player.GetOfflinePlayer = function(cid)
    if cid then
        local PlayerData = MySQL.Sync.prepare('SELECT * FROM players where cid = ?', {cid})
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return Components.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

Components.Player.CreateCid = function()
    local UniqueFound = false
    local cid = nil
    while not UniqueFound do
        -- MySQL.insert('INSERT INTO `players` (cid) VALUES (?)', {
        --     key, json.encode(data)
        -- }, function(id)
        --     print(id)
        -- end)

        -- 100000
        cid = ("%s%s"):format(math.random(1,999999))
        print(cid)
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE cid = ?', { cid })
        if result == 0 then
            UniqueFound = true
        end
    end
    return cid
end

Components.Player.CreateAccountNumber = function()
    local UniqueFound = false
    local AccountNumber = nil
    while not UniqueFound do
        AccountNumber = math.random(1,9) .. math.random(1,9) .. math.random(1,9) .. math.random(1,9) .. math.random(1,9) .. math.random(1,9) .. math.random(1,9) .. math.random(1,9)
        local query = '%' .. AccountNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return AccountNumber
end

Components.Player.CreatePhoneNumber = function()
    local UniqueFound = false
    local PhoneNumber = nil
    while not UniqueFound do
        PhoneNumber = math.random(100,999) .. math.random(1000000,9999999)
        local query = '%' .. PhoneNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return PhoneNumber
end

Components.Player.CreateFingerId = function()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(Components.Shared.RandomStr(2) .. Components.Shared.RandomInt(3) .. Components.Shared.RandomStr(1) .. Components.Shared.RandomInt(2) .. Components.Shared.RandomStr(3) .. Components.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end

Components.Player.CreateWalletId = function()
    local UniqueFound = false
    local WalletId = nil
    while not UniqueFound do
        WalletId = math.random(11111111, 99999999)
        local query = '%' .. WalletId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return WalletId
end

Components.Player.CreateSerialNumber = function()
    local UniqueFound = false
    local SerialNumber = nil
    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
        local query = '%' .. SerialNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return SerialNumber
end



Components.Player.CheckPlayerData = function(source, PlayerData)
    PlayerData = PlayerData or {}
    local Offline = true
    if source then
        PlayerData.source = source
        PlayerData.license = PlayerData.license or Components.Functions.GetIdentifier(source, 'license')
        PlayerData.name = GetPlayerName(source)
        Offline = false
    end

    PlayerData.cid = PlayerData.cid or Components.Player.CreateCid()
    TriggerClientEvent('updatecid', source, PlayerData.cid)
    PlayerData.charid = PlayerData.charid or 1
    PlayerData.money = PlayerData.money or {}
    PlayerData.optin = PlayerData.optin or true
    for moneytype, startamount in pairs(Shared.Config.Money.MoneyTypes) do
        PlayerData.money[moneytype] = PlayerData.money[moneytype] or startamount
    end

    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.firstname = PlayerData.charinfo.firstname or 'Firstname'
    PlayerData.charinfo.lastname = PlayerData.charinfo.lastname or 'Lastname'
    PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate or '00-00-0000'
    PlayerData.charinfo.gender = PlayerData.charinfo.gender or 0
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'USA'
    PlayerData.charinfo.phone = PlayerData.charinfo.phone or Components.Player.CreatePhoneNumber()
    PlayerData.charinfo.account = PlayerData.charinfo.account or Components.Player.CreateAccountNumber()
    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['tracker'] = PlayerData.metadata['tracker'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['phone'] = PlayerData.metadata['phone'] or {}
    PlayerData.metadata['fitbit'] = PlayerData.metadata['fitbit'] or {}
    PlayerData.metadata['commandbinds'] = PlayerData.metadata['commandbinds'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or Shared.Config.Player.Bloodtypes[math.random(1, #Shared.Config.Player.Bloodtypes)]
    PlayerData.metadata['dealerrep'] = PlayerData.metadata['dealerrep'] or 0
    PlayerData.metadata['craftingrep'] = PlayerData.metadata['craftingrep'] or 0
    PlayerData.metadata['attachmentcraftingrep'] = PlayerData.metadata['attachmentcraftingrep'] or 0
    PlayerData.metadata['currentapartment'] = PlayerData.metadata['currentapartment'] or nil
    PlayerData.metadata['deliveries'] = PlayerData.metadata['deliveries'] or 0
    PlayerData.metadata['heistrep'] = PlayerData.metadata['heistrep'] or 0
    -- PlayerData.metadata['Shungite'] = PlayerData.metadata['Shungite'] or 0
    -- PlayerData.metadata['gne'] = PlayerData.metadata['gne'] or 0
    PlayerData.metadata['paycheck'] = PlayerData.metadata['paycheck'] or 0

    PlayerData.metadata['casinospent'] = PlayerData.metadata['casinospent'] or 0
    
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['alias'] = PlayerData.metadata['alias'] or 'NO ALIAS'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or Components.Player.CreateFingerId()
    PlayerData.metadata['walletid'] = PlayerData.metadata['walletid'] or Components.Player.CreateWalletId()
    PlayerData.metadata['criminalrecord'] = PlayerData.metadata['criminalrecord'] or {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false
    }
    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }
    PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = Components.Player.CreateSerialNumber(),
        InstalledApps = {},
    }

    PlayerData.metadata['jobrep'] = PlayerData.metadata['jobrep'] or {}
    PlayerData.metadata['jobrep']['tow'] = PlayerData.metadata['jobrep']['tow'] or 0
    PlayerData.metadata['jobrep']['trucker'] = PlayerData.metadata['jobrep']['trucker'] or 0
    PlayerData.metadata['jobrep']['taxi'] = PlayerData.metadata['jobrep']['taxi'] or 0
    PlayerData.metadata['jobrep']['hotdog'] = PlayerData.metadata['jobrep']['hotdog'] or 0

    -- Job
    if PlayerData.job and PlayerData.job.name and not Components.Shared.Jobs[PlayerData.job.name] then PlayerData.job = nil end
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    PlayerData.job.type = PlayerData.job.type or 'none'
    if PlayerData.job.onduty == nil then
        PlayerData.job.onduty = Components.Shared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.isboss = PlayerData.job.isboss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    if PlayerData.gang and PlayerData.gang.name and not Components.Shared.Gangs[PlayerData.gang.name] then PlayerData.gang = nil end
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or Shared.Config.DefaultSpawn
    -- PlayerData.items = {}
    return Components.Player.CreatePlayer(PlayerData, Offline)
end

-- On player logout

Components.Player.Logout = function(source)
    TriggerClientEvent('comet-base:playerUnload', source)
    TriggerEvent('comet-base:playerUnload', source)
    Wait(200)
    Components.Players[source] = nil
end

Components.Player.CreatePlayer = function(PlayerData, Offline)
    local self = {}
    -- self.Functions = {}
    self.PlayerData = PlayerData
    self.Offline = Offline

    function self.UpdatePlayerData()
        if self.Offline then return end -- Unsupported for Offline Players
        TriggerEvent('comet-base:setPlayerData', self.PlayerData)
        TriggerClientEvent('comet-base:setPlayerData', self.PlayerData.source, self.PlayerData)
    end

    function self.SetJob(job, grade)
        job = job:lower()
        grade = tostring(grade) or '0'
        if not Components.Shared.Jobs[job] then return false end
        self.PlayerData.job.name = job
        self.PlayerData.job.label = Components.Shared.Jobs[job].label
        self.PlayerData.job.onduty = Components.Shared.Jobs[job].defaultDuty
        self.PlayerData.job.type = Components.Shared.Jobs[job].type or 'none'
        if Components.Shared.Jobs[job].grades[grade] then
            local jobgrade = Components.Shared.Jobs[job].grades[grade]
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = jobgrade.name
            self.PlayerData.job.grade.level = tonumber(grade)
            self.PlayerData.job.payment = jobgrade.payment or 30
            self.PlayerData.job.isboss = jobgrade.isboss or false
        else
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = 'No Grades'
            self.PlayerData.job.grade.level = 0
            self.PlayerData.job.payment = 30
            self.PlayerData.job.isboss = false
        end

        if not self.Offline then
            self.UpdatePlayerData()
            TriggerEvent('comet-base:jobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerClientEvent('comet-base:jobUpdate', self.PlayerData.source, self.PlayerData.job)
        end

        return true
    end

    function self.SetGang(gang, grade)
        gang = gang:lower()
        grade = tostring(grade) or '0'
        if not Components.Shared.Gangs[gang] then return false end
        self.PlayerData.gang.name = gang
        self.PlayerData.gang.label = Components.Shared.Gangs[gang].label
        if Components.Shared.Gangs[gang].grades[grade] then
            local ganggrade = Components.Shared.Gangs[gang].grades[grade]
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = ganggrade.name
            self.PlayerData.gang.grade.level = tonumber(grade)
            self.PlayerData.gang.isboss = ganggrade.isboss or false
        else
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = 'No Grades'
            self.PlayerData.gang.grade.level = 0
            self.PlayerData.gang.isboss = false
        end

        if not self.Offline then
            self.UpdatePlayerData()
            TriggerEvent('comet-base:gangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerClientEvent('comet-base:gangUpdat', self.PlayerData.source, self.PlayerData.gang)
        end

        return true
    end

    function self.SetJobDuty(onDuty)
        self.PlayerData.job.onduty = not not onDuty -- Make sure the value is a boolean if nil is sent
        self.UpdatePlayerData()
    end

    function self.SetPlayerData(key, val)
        if not key or type(key) ~= 'string' then return end
        self.PlayerData[key] = val
        self.UpdatePlayerData()
    end

    function self.SetMetaData(meta, val)
        if not meta or type(meta) ~= 'string' then return end
        if meta == 'hunger' or meta == 'thirst' then
            val = val > 100 and 100 or val
        end
        self.PlayerData.metadata[meta] = val
        self.UpdatePlayerData()
    end

    function self.GetMetaData(meta)
        if not meta or type(meta) ~= 'string' then return end
        return self.PlayerData.metadata[meta]
    end

    -- function self.AddJobReputation(amount)
    --     if not amount then return end
    --     amount = tonumber(amount)
    --     self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
    --     self.UpdatePlayerData()
    -- end

    function self.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        if not self.Offline then
            self.UpdatePlayerData()
            if amount > 100000 then
                -- TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (cid: ' .. self.PlayerData.cid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                -- TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (cid: ' .. self.PlayerData.cid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            -- TriggerClientEvent('qb-interface:addedMoney', self.PlayerData.source, amount,self.PlayerData.money[moneytype], amount)
            if moneytype == 'cash' or moneytype == 'bank' then
                TriggerClientEvent('comet-base:addedMoney', self.PlayerData.source, amount, self.PlayerData.money[moneytype])
            end

            --QBCore:Client:OnMoneyChange QBCore:Server:OnMoneyChange
            TriggerClientEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
            TriggerEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
        end

        return true
    end

    function self.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        for _, mtype in pairs(Shared.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end
        end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        if not self.Offline then
            self.UpdatePlayerData()
            if amount > 100000 then
                -- TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (cid: ' .. self.PlayerData.cid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                -- TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (cid: ' .. self.PlayerData.cid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            if moneytype == 'cash' or moneytype == 'bank' then
                TriggerClientEvent('comet-base:removedMoney', self.PlayerData.source, amount, self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)
            TriggerEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)
        end

        return true
    end

    function self.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end
        if not self.PlayerData.money[moneytype] then return false end
        local difference = amount - self.PlayerData.money[moneytype]
        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.UpdatePlayerData()
            -- TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (cid: ' .. self.PlayerData.cid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            -- TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            TriggerClientEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "set", reason)
            TriggerEvent('comet-base:onMoneyChange', self.PlayerData.source, moneytype, amount, "set", reason)
        end

        return true
    end

    function self.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end

    function self.SetCreditCard(cardNumber)
        self.PlayerData.charinfo.card = cardNumber
        self.UpdatePlayerData()
    end

    -- function self.GetCardSlot(cardNumber, cardType)
    --     local item = tostring(cardType):lower()
    --     local slots = exports['qb-inventory']:GetSlotsByItem(self.PlayerData.items, item)
    --     for _, slot in pairs(slots) do
    --         if slot then
    --             if self.PlayerData.items[slot].info.cardNumber == cardNumber then
    --                 return slot
    --             end
    --         end
    --     end
    --     return nil
    -- end

    function self.Save()
        if self.Offline then
            Components.Player.SaveOffline(self.PlayerData)
        else
            Components.Player.Save(self.PlayerData.source)
        end
    end

    function self.Logout()
        if self.Offline then return end -- Unsupported for Offline Players
        Components.Player.Logout(self.PlayerData.source)
    end

    -- function self.AddMethod(methodName, handler)
    --     self.Functions[methodName] = handler
    -- end

    -- function self.AddField(fieldName, data)
    --     self[fieldName] = data
    -- end

    if self.Offline then
        return self
    else
        Components.Players[self.PlayerData.source] = self
        Components.Player.Save(self.PlayerData.source)

        -- At this point we are safe to emit new instance to third party resource for load handling
        -- TriggerEvent('QBCore:Server:PlayerLoaded', self)
        TriggerEvent('comet-base:loadedPlayer', self)
        self.UpdatePlayerData()
    end
end


Components.Player.Save = function(source)
    local src = source
    local ped = GetPlayerPed(src)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = Components.Players[src].PlayerData
    local playerId = src
    if PlayerData then
        MySQL.Async.insert('INSERT INTO players (cid, charid, license, name, money, charinfo, job, gang, position, metadata, firstname, lastname) VALUES (:cid, :charid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata, :firstname, :lastname) ON DUPLICATE KEY UPDATE charid = :charid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata, firstname = :firstname, lastname = :lastname', {
            cid = PlayerData.cid,
            charid = tonumber(PlayerData.charid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata),
            firstname = PlayerData.charinfo.firstname,
            lastname = PlayerData.charinfo.lastname,
        })
        Components.ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' PLAYER SAVED!')
    else
        Components.ShowError(GetCurrentResourceName(), 'ERROR COMPONENTS.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

Components.Player.Kick = function(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. Shared.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end