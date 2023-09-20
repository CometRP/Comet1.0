Shared.Config = Shared.Config or {}

Shared.Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
Shared.Config.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
Shared.Config.UpdateInterval = 5 -- how often to update player data in minutes
Shared.Config.StatusInterval = 5000 -- how often to check hunger/thirst status in milliseconds

Shared.Config.Money = {}
Shared.Config.Money.MoneyTypes = { cash = 500, bank = 5000, gne = 0, shung = 0 } -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
Shared.Config.Money.DontAllowMinus = { 'cash', 'bank' } -- Money that is not allowed going in minus
Shared.Config.Money.PayCheckTimeOut = 10 -- The time in minutes that it will give the paycheck
Shared.Config.Money.PayCheckSociety = false -- If true paycheck will come from the society account that the player is employed at, requires qb-management

Shared.Config.Player = {}
Shared.Config.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
Shared.Config.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
Shared.Config.Player.Bloodtypes = {
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
}

Shared.Config.Server = {} -- General server config
Shared.Config.Server.Closed = false -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
Shared.Config.Server.ClosedReason = "Server Closed" -- Reason message to display when people can't join the server
Shared.Config.Server.Uptime = 0 -- Time the server has been up.
Shared.Config.Server.Whitelist = false -- Enable or disable whitelist on the server
Shared.Config.Server.WhitelistPermission = 'admin' -- Permission that's able to enter the server when the whitelist is on
Shared.Config.Server.PVP = true -- Enable or disable pvp on the server (Ability to shoot other players)
Shared.Config.Server.Discord = "" -- Discord invite link
Shared.Config.Server.CheckDuplicateLicense = true -- Check for duplicate rockstar license on join
Shared.Config.Server.Permissions = { 'god', 'admin', 'mod' } -- Add as many groups as you want here after creating them in your server.cfg
