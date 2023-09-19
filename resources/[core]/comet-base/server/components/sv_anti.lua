
local DeleterblockedItems = {
	"stt_prop_stunt_track_uturn",
	"stt_prop_stunt_track_turnice",
	"stt_prop_stunt_track_hill",
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
	"prop_windmill_01",
	"p_spinning_anus_s",
	"stt_prop_ramp_adj_flip_m",
	"stt_prop_ramp_adj_flip_mb",
	"stt_prop_ramp_adj_flip_s",
	"stt_prop_ramp_adj_flip_sb",
	"stt_prop_ramp_adj_hloop",
	"stt_prop_ramp_adj_loop",
	"stt_prop_ramp_jump_l",
	"stt_prop_ramp_jump_m",
	"stt_prop_ramp_jump_s",
	"stt_prop_ramp_jump_xl",
	"stt_prop_ramp_jump_xs",
	"stt_prop_ramp_jump_xxl",
	"stt_prop_ramp_multi_loop_rb",
	"stt_prop_ramp_spiral_l",
	"stt_prop_ramp_spiral_l_l",
	"stt_prop_ramp_spiral_l_m",
	"stt_prop_ramp_spiral_l_s",
	"stt_prop_ramp_spiral_l_xxl",
	"stt_prop_ramp_spiral_m",
	"stt_prop_ramp_spiral_s",
	"stt_prop_ramp_spiral_xxl",
	"stt_prop_stunt_track_dwslope30",
	"stt_prop_stunt_track_start",
	"stt_prop_stunt_track_slope45",
	"stt_prop_stunt_track_slope30",
	"stt_prop_stunt_track_slope15",
	"stt_prop_stunt_track_short",
	"stt_prop_stunt_track_sh45_a",
	"stt_prop_stunt_track_sh45",
	"stt_prop_stunt_track_sh30",
	"stt_prop_stunt_track_sh15",
	"stt_prop_stunt_track_otake",
	"stt_prop_stunt_track_link",
	"stt_prop_stunt_track_jump",
	"stt_prop_stunt_track_hill2",
	"stt_prop_stunt_track_hill",
	"stt_prop_stunt_track_funnel",
	"stt_prop_stunt_track_funlng",
	"stt_prop_stunt_track_fork",
	"stt_prop_stunt_track_exshort",
	"stt_prop_stunt_track_dwuturn",
	"stt_prop_stunt_track_dwturn",
	"stt_prop_stunt_track_dwslope45",
	"stt_prop_stunt_track_dwslope30",
	"stt_prop_stunt_track_dwslope15",
	"stt_prop_stunt_track_dwshort",
	"stt_prop_stunt_track_dwsh15",
	"stt_prop_stunt_track_dwlink_02",
	"stt_prop_stunt_track_dwlink",
	"stt_prop_stunt_track_cutout",
	"stt_prop_stunt_track_bumps",
	"stt_prop_stunt_target_small",
	"stt_prop_stunt_target",
	"stt_prop_stunt_soccer_sball",
	"stt_prop_stunt_soccer_lball",
	"stt_prop_stunt_soccer_goal",
	"stt_prop_stunt_soccer_ball",
	"stt_prop_stunt_ramp",
	"stt_prop_stunt_landing_zone_01",
	"stt_prop_stunt_jump_sb",
	"stt_prop_stunt_jump_s",
	"stt_prop_stunt_jump_mb",
	"stt_prop_stunt_jump_m",
	"stt_prop_stunt_jump_loop",
	"stt_prop_stunt_jump_lb",
	"stt_prop_stunt_jump_l",
	"stt_prop_stunt_jump45",
	"stt_prop_stunt_jump30",
	"stt_prop_stunt_jump15",
	"stt_prop_stunt_domino"
}


local BlacklistedModels = {
    "RHINO",
    "lazer",
    "cargobob",
    "tanker2",
    "boxville4",
    "hydra",
    "insurgent",
    "technical",
    "technical2",
    "savage",
    "valkyrie",
    "blazer5",
    "dune4",
    "ruiner2",
    "phantom2",
    "akula",
    "chernobog",
    "apc",
    "tamapq3",
    "halftrack",
    "barrage",
    "deluxo",
    "thruster",
    "riot2",
    "caracara",
    "buzzard",
    "buzzard2",
    "dukes2",
    "limo2",
    "vigilante",
    "voltic2",
    "technical3",
    "ambulance",
    "vindicator",
    "thrust",
    "wastelander",
    "havok",
    "bestra",
    "supervolito",
    "swift",
    "supervolito2",
    "cargobob2",
    "cargobob3",
    "cargobob4",
    "valkyrie2",
    "annihilator",
    "skylift",
    "frogger",
    "seasparrow",
    "frogger2",
    "volatus",
    "hunt",
    "hunter",
    "khanjali",
    "barracks",
    "barracks2",
    "barracks3",
    "trailersmall2",
    "crusader",
    "blimp",
    "blimp2",
    "blimp3",
    "shamal",
    "nimbus",
    "velum2",
    "avenger",
    "velum",
    "alphaz1",
    "cuban800",
    "tula",
    "duster",
    "bombushka",
    "molotok",
    "pyro",
    "seabreeze",
    "volatol",
    "starling",
    "mogul",
    "titan",
    "nokota",
    "miljet",
    "strikeforce",
    "howard",
    "cargoplane",
    "dodo",
    "besra",
    "jet",
    "luxor2",
    "vestra",
    "rogue",
    "stunt",
    "mammatus",
    "avenger2",
    "tampa3",
    "scarab3",
    "scarab",
    "scarab2",
    "minitank",
    "zr3803",
    "raptor",
    "zr3802",
    "kuruma2",
    "zr380",
    "ruiner3",
    "ratloader",
    "slamvan4",
    "slamvan5",
    "imperator3",
    "dominator5",
    "dominator4",
    "impaler4",
    "dominator6",
    "imperator2",
    "impaler3",
    "slamvan6",
    "boxville5",
    "dune2",
    "dune3",
    "nightshark",
    "insurgent3",
    "menacer",
    "marshall",
    "monster",
    "dune5",
    "bruiser",
    "monster5",
    "monster3",
    "monster4",
    "zhaba",
    "scramjet",
    "oppressor",
    "rrocket",
    "shotaro",
    "oppressor2",
    "shotaro",
}

Components.Anticheat = Components.Anticheat or {}

Citizen.CreateThread(function()
	if GetConvarInt('logs_enabled', 0) == 1 then
		print("^5[anti-cheat]^0 | ^2Running and logging all components^0")		
	else
		print("^5[anti-cheat]^0 | ^8Disabled | Dev Server ^0")	
	end
end)


AddEventHandler('entityCreating', function(entity)
    if GetConvarInt('logs_enabled', 0) == 1 then
        local model = GetEntityModel(entity)
        local pOwner = NetworkGetEntityOwner(entity)
        for i=1, #blockedItems do 
            if model == GetHashKey(blockedItems[i]) then
                CancelEvent()
                local LogInfo = "Prop Hash: " .. model
                Components.Log.SendDiscord("https://discord.com/api/webhooks/871329645574885447/7yP2-lwoF7mAwcCCEg7BsssK8LlOg7QxHw7nLIQowXje6PYS2Lgupy9_n5T1TFPROzfJ", pOwner, "Cheater: Spawned Blacklisted Prop", "Spawning Props", LogInfo)
                Citizen.Wait(100)
                DropPlayer(pOwner, "[Anti-Cheat]: You have been permanently banned.")
                break
            end
        end
    end
end)
AddEventHandler('entityCreating', function(entity)
    local model = GetEntityModel(entity)
    local pOwner = NetworkGetEntityOwner(entity)
    for i=1, #BlacklistedModels do 
        if model == GetHashKey(BlacklistedModels[i]) then
            CancelEvent()
            break
        end
    end
end)

-- Send message when Player disconnects from the server
AddEventHandler('playerDropped', function(reason)
    if GetConvarInt('logs_enabled', 0) == 1 then
        local pSrc = source
        local pName = GetPlayerName(pSrc)
        local LogInfo =  pName.. " Disconnected | Reason: " .. reason
        Components.Log.SendDiscord("https://discord.com/api/webhooks/852705393967890472/W3LrJvhuH-LEDdNQeoO9g5b7ErRrQ5k4LMgtaS8--lIWVZi4CAXFQ7LNPYqHioOvNLP8", pSrc, "Player Disconnected", "", LogInfo)
    end
end)


RegisterServerEvent('player:dead')
AddEventHandler('player:dead',function(killer, DeathReason)
    if GetConvarInt('logs_enabled', 0) == 1 then
        local pSrc = source
        local pName = GetPlayerName(pSrc)
        local tName = GetPlayerName(killer)

        local LogInfo = pName .. " was killed by " .. tName .. "  | Type: " ..DeathReason
        Components.Log.SendDiscord("https://discord.com/api/webhooks/852705457054547970/E07HDCWPlE0SHbmkWe3eZu6ENLxhiPXR4LxgR2WQNGQrayMfo2Ylpscgg8AYkZn2XZ1z", killer, "Combat Encounter", "", LogInfo)
    end
end)


RegisterServerEvent('player:damage:multi')
AddEventHandler('player:damage:multi',function(attacker, weapon, dmg)
    local aName = GetPlayerName(attacker)
    local pName = GetPlayerName(source)
    local pLogData = "Attacker's Steam Name: " ..  aName .. " | ID: " .. attacker .. "\n Damage Modifier: " .. dmg .. "\n Victim's Name: " ..pName.. "\n Weapon: " .. weapon
    Components.Anticheat.SendLog(attacker, "damage_multi", pLogData)
    DropPlayer(attacker, "Cheating | Damage Modifier | Perma Banned")
end)


function Components.Anticheat.SendLog(pSrc, LogType, LogInfo)
    if GetConvarInt('logs_enabled', 0) == 1 then
        if LogType == "Spawned:items" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Spawned Item -> with admin menu", "", LogInfo)
        elseif LogType == "Spawned:car" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Spawned Car -> with admin menu", "", LogInfo)
        elseif LogType == "Spectating" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Spectating Toggled -> with admin menu", "", LogInfo)
        elseif LogType == "Searching" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Searching Toggled -> with admin menu", "", LogInfo)
        elseif LogType == "deposit" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Banking Deposit", "", LogInfo)
        elseif LogType == "withdraw" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Banking Withdraw", "", LogInfo)
        elseif LogType == "transfer" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Bank Transfer", "", LogInfo)
        elseif LogType == "give_cash" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Give Cash", "", LogInfo)
        elseif LogType == "damage_multi" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Damage Modifier", "Cheating | Damage Modifier | Perma Banned", LogInfo)
        elseif LogType == "external-pay" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Payment sent from phone - External Pay", "", LogInfo)
        elseif LogType == "external-deposit" then
            Components.Log.SendDiscord("https://discord.com/api/webhooks/994958069614256158/bV_sF0zPDUx99XEwFJaTQBpxjv4X7ul718Ty3HE_LqdO6iCAAHiGc7QQE5kysOnqaaav", pSrc, "Payment deposit from phone - External Deposit", "", LogInfo)
        end
    end
end
