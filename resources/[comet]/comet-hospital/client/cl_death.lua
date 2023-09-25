local thecount = 0
local isEMS = false  
local imDead = 0
local inwater = false
local EHeld = 500

local isViolent = false
local isMinor = false
local allowLocalEMS = false
local inDoctorBed = false
local isPoisoned = false
local deathText
local respawnText

local lastDamageTaken = {
    hash = "",
    source = -1,
    melee = false,
}


-- Anims for normal death and vehicular death.
local defaultAnimTree = "dead"
local defaultAnim = "dead_d"
local minorAnim = "dead_a"
local minorDict = "dead"
local carAnimTree = "random@crash_rescue@car_death@std_car"
local carAnim = "loop"

local InjuryList = {
    [-1569615261] = { "WEAPON_UNARMED", "Fist Marks", minor = true },
    [-100946242] = { "WEAPON_ANIMAL", "Animal Bites and Claws", minor = true },
    [148160082] = { "WEAPON_COUGAR", "Animal Bites and Claws" },
    [-1716189206] = { "WEAPON_KNIFE", "Knife Wounds", violent = true },
    [1737195953] = { "WEAPON_NIGHTSTICK", "Blunt Object (Metal)", minor = true, violent = true },
    [1317494643] = { "WEAPON_HAMMER", "Small Blunt Object (Metal)", minor = true, violent = true },
    [-1024456158] = { "WEAPON_BAT", "Large Blunt Object" },
    [1141786504] = { "WEAPON_GOLFCLUB", "Long Thing Blunt Object", minor = true, violent = true },
    [-2067956739] = { "WEAPON_CROWBAR", "Medium Size Jagged Metal Object", minor = true, violent = true },
    [453432689] = { "WEAPON_PISTOL", "Pistol Bullets", violent = true },
    [1593441988] = { "WEAPON_COMBATPISTOL", "Combat Pistol Bullets", violent = true },
    [584646201] = { "WEAPON_APPISTOL", "AP Pistol Bullets", violent = true },
    [-1716589765] = { "WEAPON_PISTOL50", "50 Cal Pistol Bullets", violent = true },
    [324215364] = { "WEAPON_MICROSMG", "Micro SMG Bullets", violent = true },
    [736523883] = { "WEAPON_SMG", "SMG Bullets", violent = true },
    [-270015777] = { "WEAPON_ASSAULTSMG", "Assault SMG Bullets", violent = true },
    [-1074790547] = { "WEAPON_ASSAULTRIFLE", "Assault Rifle Bullets", violent = true },
    [-2084633992] = { "WEAPON_CARBINERIFLE", "Carbine Rifle Bullets", violent = true },
    [-1357824103] = { "WEAPON_ADVANCEDRIFLE", "Advanced Rifle bullets", violent = true },
    [-1660422300] = { "WEAPON_MG", "Machine Gun Bullets", violent = true },
    [2144741730] = { "WEAPON_COMBATMG", "Combat MG Bullets", violent = true },
    [487013001] = { "WEAPON_PUMPSHOTGUN", "Pump Shotgun Bullets", violent = true },
    [2017895192] = { "WEAPON_SAWNOFFSHOTGUN", "Sawn Off Bullets", violent = true },
    [-494615257] = { "WEAPON_ASSAULTSHOTGUN", "Assault Shotgun Bullets", violent = true },
    [-1654528753] = { "WEAPON_BULLPUPSHOTGUN", "Bullpup Shotgun Bullets", violent = true },
    [911657153] = { "WEAPON_STUNGUN", "Stun Gun Damage", minor = true, violent = true },
    [100416529] = { "WEAPON_SNIPERRIFLE", "Sniper Rifle Wounds", violent = true },
    [205991906] = { "WEAPON_HEAVYSNIPER", "Sniper Rifle Wounds", violent = true },
    [856002082] = { "WEAPON_REMOTESNIPER", "Sniper Rifle Wounds", violent = true },
    [-1568386805] = { "WEAPON_GRENADELAUNCHER", "Explosive Damage (Grenades)", violent = true },
    [1305664598] = { "WEAPON_GRENADELAUNCHER_SMOKE", "Smoke Damage", minor = true, violent = true },
    [-1312131151] = { "WEAPON_RPG", "RPG damage", violent = true },
    [1752584910] = { "WEAPON_STINGER", "RPG damage", violent = true },
    [1119849093] = { "WEAPON_MINIGUN", "Minigun Wounds", violent = true },
    [-1813897027] = { "WEAPON_GRENADE", "Grenade Wounds", violent = true },
    [741814745] = { "WEAPON_STICKYBOMB", "Sticky Bomb Wounds", violent = true },
    [-37975472] = { "WEAPON_SMOKEGRENADE", "Smoke Damage", violent = true },
    [-1600701090] = { "WEAPON_BZGAS", "Gas Damage", violent = true },
    [615608432] = { "WEAPON_MOLOTOV", "Molotov/Accelerant Burns", violent = true },
    [101631238] = { "WEAPON_FIREEXTINGUISHER", "Fire Extenguisher Damage", minor = true },
    [883325847] = { "WEAPON_PETROLCAN", "Petrol Can Damage" },
    [1233104067] = { "WEAPON_FLARE", "Flare Damage" },
    [1223143800] = { "WEAPON_BARBED_WIRE", "Barbed Wire Damage" },
    [-10959621] = { "WEAPON_DROWNING", "Drowning" },
    [1936677264] = { "WEAPON_DROWNING_IN_VEHICLE", "Drowned in Vehicle" },
    [-1955384325] = { "WEAPON_BLEEDING", "Died to Blood Loss" },
    [-1833087301] = { "WEAPON_ELECTRIC_FENCE", "Electric Fence Wounds", minor = true },
    [539292904] = { "WEAPON_EXPLOSION", "Explosion Damage" },
    [-842959696] = { "WEAPON_FALL", "Fall / Impact Damage" },
    [910830060] = { "WEAPON_EXHAUSTION", "Died of Exhaustion", minor = true },
    [-868994466] = { "WEAPON_HIT_BY_WATER_CANNON", "Water Cannon Pelts", violent = true },
    [133987706] = { "WEAPON_RAMMED_BY_CAR", "Vehicular Accident", minor = true },
    [-1553120962] = { "WEAPON_RUN_OVER_BY_CAR", "Runover by Vehicle" },
    [341774354] = { "WEAPON_HELI_CRASH", "Heli Crash" },
    [-544306709] = { "WEAPON_FIRE", "Fire Victim" },
    [4024951519] = { "WEAPON_ASSAULTSMG", "Assault SMG", violent = true },
    [1627465347] = { "WEAPON_GUSENBERG", "Gusenberg", violent = true },
    [171789620] = { "WEAPON_COMBATPDW", "Combat PDW", violent = true },
    [984333226] = { "WEAPON_HEAVYSHOTGUN", "Heavy Shotgun", violent = true },
    [317205821] = { "WEAPON_AUTOSHOTGUN", "Autoshotgun", violent = true },
    [2640438543] = { "WEAPON_BULLPUPSHOTGUN", "Bullpup Shotgun", violent = true },
    [3800352039] = { "WEAPON_ASSAULTSHOTGUN", "Assault Shotgun", violent = true },
    [2132975508] = { "WEAPON_BULLPUPRIFLE", "Bullpup Rifle", violent = true },
    [3220176749] = { "WEAPON_ASSAULTRIFLE", "Assault Rifle", violent = true },
    [3219281620] = { "WEAPON_PISTOL_MK2", "PD Pistol", violent = true },
    [`WEAPON_BRICK`] = { "WEAPON_BRICK", "Brick", minor = true, violent = true },
    [`WEAPON_SHOE`] = { "WEAPON_SHOE", "Shoe", minor = true },
    [`WEAPON_CASH`] = { "WEAPON_CASH", "Cash", minor = true },
    [`WEAPON_PAINTBALL`] = { "WEAPON_PAINTBALL", "PaintBall Gun", minor = true },
}


-- unsure if there is a event triggered on change of ped or not.
Citizen.CreateThread(function()
    local ped = PlayerPedId()
    SetPedConfigFlag(ped,184,true)
    while true do
        Wait(5000)
        if PlayerPedId() ~= ped then
            ped = PlayerPedId()
            SetPedConfigFlag(ped,184,true)
        end
    end
end)

function GetDeathStatus()
    if isPlayerDead == 1 then
        poggers = true
    elseif isPlayerDead == 0 then
        poggers = false
    end
    return poggers
end


function isCop()
    -- if player.hasGroup(exports['wave-cid']:police()) then
    --     return player.get('inService')
    -- end
end

function isEMS()
    -- if player.hasGroup(exports['wave-cid']:ems()) then
    --     return player.get('inService')
    -- end
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- INFO: Death Check Thread
Citizen.CreateThread(function()
    SetEntityInvincible(PlayerPedId(), false)
    imDead = 0

    while true do
        Wait(100)
        local player = PlayerPedId()
        if IsEntityDead(player) then
            TriggerEvent("actionbar:setEmptyHanded")
            -- TriggerEvent('ox_inventory:disarm')
            local deathHash = GetPedCauseOfDeath(player)
            if not deathHash or deathHash == 0 then deathHash = lastDamageTaken.hash end
            local deathSource = GetPedSourceOfDeath(player)
            if not deathSource or deathSource == 0 then deathSource = lastDamageTaken.source end

            isViolent = IsViolentCauseOfDeath(deathHash)
            isMinor = IsMinorCauseOfDeath(deathHash) or isPoisoned

            allowLocalEMS = not isViolent

            if (IsEntityAPed(deathSource) and IsPedAPlayer(deathSource) and deathSource ~= player) or isViolent then
                TriggerEvent('comet-hospital:sendPing')
                allowLocalEMS = false
            end

            allowLocalEMS = allowLocalEMS or isCop()

            SetEntityInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(player))

            if imDead == 0 then
                imDead = 1
                deathTimer()
            end
        end
    end
end)

RegisterNetEvent('comet-hospital:Timer', function()
    TriggerServerEvent('comet-hospital:setDeathStatus', true)
    deathText = isMinor and ("Unconscious: ~p~ %d~w~ seconds remaining") or ("Dead: ~p~ %d ~w~ seconds remaining")
    respawnText = isMinor and ("~W~HOLD ~p~E ~w~ (%d) ~w~ TO ~p~GET UP~w~") or ("~w~HOLD ~p~E ~w~(%d) ~w~TO ~p~RESPAWN ~w~OR WAIT FOR ~p~EMS")
    while imDead == 1 do
        Citizen.Wait(0)
        if thecount > 0 then
            drawTxt(0.89, 1.42, 1.0,1.0,0.6, deathText:format(thecount), 255, 255, 255, 255)
        else
            drawTxt(0.89, 1.42, 1.0,1.0,0.6, respawnText:format(math.ceil(EHeld/100)), 255, 255, 255, 255)
        end
    end
    inDoctorBed = false
    TriggerServerEvent('comet-hospital:setDeathStatus', false)
end)



dragged = false
RegisterNetEvent('deathdrop')
AddEventHandler('deathdrop', function(beingDragged)
    dragged = beingDragged
    if not beingDragged and imDead == 1 then
        SetEntityHealth(PlayerPedId(), 200.0)
        SetEntityCoords( PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 1.0) )
    end 
end)

function InVeh()
  local ply = PlayerPedId()
  local intrunk = false
  if IsPedSittingInAnyVehicle(ply) or intrunk then
    return true
  else
    return false
  end
end


local disablingloop = false

RegisterNetEvent('disableAllActions')
AddEventHandler('disableAllActions', function()
    if not disablingloop then
        local ped = PlayerPedId()

        disablingloop = true

        -- wait for any ragdoll / falling to finish
        while GetEntitySpeed(ped) > 0.5 do
            Citizen.Wait(1)
        end 

        -- wait for any fire effects on player to finish
        local fireLength = 60
        while FireCheck(ped) and fireLength > 1 do
            Wait(1000)
            fireLength = fireLength - 1
        end

        -- get vehicle seat
        local seat = 0
        local veh = GetVehiclePedIsUsing(ped)
        if veh then
            local vehmodel = GetEntityModel(veh)
            for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
                if GetPedInVehicleSeat(veh,i) == ped then
                    seat = i
                end
            end
        end

        -- resurrect player
        -- TriggerEvent("resurrect:relationships")

        -- new ped after resurrect & reseat
        ped = PlayerPedId()
        if veh then
            TaskWarpPedIntoVehicle(ped,veh,seat)
        end

        TriggerEvent("disableAllActions2")
        SetEntityInvincible(ped, true)
        
        while imDead == 1 do
            ped = PlayerPedId()
            Citizen.Wait(200)
            if InVeh() and (not IsDeadVehAnimPlaying() or IsPedRagdoll(ped)) and not FireCheck(ped) then
                DoVehDeathAnim(ped)
            elseif not InVeh() and (not IsDeadAnimPlaying() or IsPedRagdoll(ped)) and not FireCheck(ped) and not IsPedFalling(ped) then
                DoDeathAnim(ped)
            end
            Citizen.Wait(800)
        end
        SetEntityInvincible(ped, false)
        SetPedCanRagdoll(PlayerPedId(), true)
        ClearPedTasksImmediately(ped)
        disablingloop = false
    end
end)

function FireCheck()
    local Coords = GetEntityCoords(PlayerPedId())
    local retval --[[ boolean ]], outPosition --[[ vector3 ]] =
	GetClosestFirePos(
		Coords.x --[[ number ]], 
		Coords.y --[[ number ]], 
		Coords.z --[[ number ]]
    )
    return retval
end

function IsDeadVehAnimPlaying()
    if IsEntityPlayingAnim(PlayerPedId(), carAnimTree, carAnim, 1) then
        return true
    else
        return false
    end
end

function IsDeadAnimPlaying()
    if IsEntityPlayingAnim(PlayerPedId(), defaultAnimTree, defaultAnim, 1) or IsEntityPlayingAnim(PlayerPedId(), minorDict, minorAnim, 1) then
        return true
    else
        return false
    end
end

function DoVehDeathAnim(ped)
    --print("car anim")
    loadAnimDict( carAnimTree ) 
    TaskPlayAnim(ped, carAnimTree, carAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
end

function DoDeathAnim(ped)
    --print("death anim")
    ClearPedTasksImmediately(ped)
    if isMinor then
        loadAnimDict(minorDict)
        TaskPlayAnim(ped, minorDict, minorAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
    else
        loadAnimDict(defaultAnimTree)
        TaskPlayAnim(ped, defaultAnimTree, defaultAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
    end
end



RegisterNetEvent('disableAllActions2')
AddEventHandler('disableAllActions2', function()
        TriggerEvent("disableVehicleActions")
        local playerPed = PlayerPedId()
        while imDead == 1 do
            Citizen.Wait(0) 
            DisableInputGroup(0)
            DisableInputGroup(1)
            DisableInputGroup(2)
            DisableControlAction(1, 19, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 9, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 8, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(1, 33, true)
            DisableControlAction(1, 34, true)
            DisableControlAction(1, 35, true)
            DisableControlAction(1, 21, true)  -- space
            DisableControlAction(1, 22, true)  -- space
            DisableControlAction(1, 23, true)  -- F
            DisableControlAction(1, 24, true)  -- F
            DisableControlAction(1, 25, true)  -- F
            if IsControlJustPressed(1,29) then
                SetPedToRagdoll(playerPed, 26000, 26000, 3, 0, 0, 0) 
                 Citizen.Wait(22000)
                 TriggerEvent("deathAnim")
            end
            DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(1, 140, true) --Disables Melee Actions
            DisableControlAction(1, 141, true) --Disables Melee Actions
            DisableControlAction(1, 142, true) --Disables Melee Actions 
            DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
            DisablePlayerFiring(playerPed, true) -- Disable weapon firing
        end
        SetPedCanRagdoll(PlayerPedId(), false)
end)

RegisterNetEvent('disableVehicleActions')
AddEventHandler('disableVehicleActions', function()
    local playerPed = PlayerPedId()
    while imDead == 1 do
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        Wait(300)
        if playerPed ==  GetPedInVehicleSeat(currentVehicle, -1) then
            SetVehicleUndriveable(currentVehicle,true)
        end
    end
end)

local bleedtime = 0
function deathTimer()

    EHeld = 500
    thecount = (isMinor or isCop()) and 60 or 300
    TriggerEvent("comet-hospital:Timer")
    TriggerEvent("disableAllActions")
    bleedtime = 0

    while imDead == 1 do
        Citizen.Wait(1000)
        thecount = thecount - 1

        bleedtime = bleedtime + 1
        if bleedtime == 30 then
            TriggerEvent("evidence:bleeding",false)
            bleedtime = 0
        end

        while thecount < 0 do
            Citizen.Wait(0)
            if IsControlPressed(1,38) then
                local hspDist = #(vector3(307.93017578125,-594.99530029297,43.291835784912) - GetEntityCoords(PlayerPedId()))
                EHeld = EHeld - 1
                if hspDist > 5 and EHeld < 1 and not (isMinor and InVeh()) then
                    thecount = 99999999
                    if isMinor or inDoctorBed then
                        attemptRevive()
                        return
                    end
                    TriggerEvent("evidence:bleeding",true)
                    releaseBody(not allowLocalEMS)
                end
            else
                EHeld = 500
            end
        end
    end
end

RegisterNetEvent('trycpr')
AddEventHandler('trycpr', function()
    curDist = #(GetEntityCoords(PlayerPedId(), 0) - vector3(2438.3266601563,4960.3046875,47.27229309082))
    curDist2 = #(GetEntityCoords(PlayerPedId(), 0) - vector3(-1001.18, 4850.52, 274.61))
    if curDist < 5 or curDist2 < 5 then
        local penis = 0
        while penis < 10 do
            penis = penis + 1

            exports['wave-ui']:Circle(function(success)
                if not success then
                    return
                end
            end, math.random(5, 10), math.random(20, 60)) -- NumberOfCircles, MS

            Wait(100)
        end
        TriggerServerEvent("serverCPR")
    else
        -- lib.notify({
        --     description = "You are not near the rest house",
        --     type = 'inform',
        -- })
    end
end)

RegisterNetEvent('reviveFunction')
AddEventHandler('reviveFunction', function()
    attemptRevive()
end)

-- INFO: Respawn Function
function releaseBody(dropItems)
    thecount = 300
    local player = PlayerPedId()
    FreezeEntityPosition(player, false)
    RemoveAllPedWeapons(player)
    DoScreenFadeOut(3000)
    Wait(3000)
    if dropItems then
        -- lib.notify({
        --     title = "Local EMS",
        --     description = "We could not recover your pockets",
        --     type = 'inform',
        -- })
        TriggerServerEvent("comet-hospital:removeallitems")
    end
    SetCurrentPedWeapon(player, 2725352035, true)
    ClearPedTasksImmediately(player)
    Wait(2000)
    SetEntityInvincible(player, false)
    ClearPedBloodDamage(player)
    local doctors = 0
    if not doctors or doctors <= 0 then
        imDead = 0
    else
        thecount = 60
        inDoctorBed = true
        deathText = ("Dead: Wait for a ~p~doctor~w~ to receive medical treatment (%d)")
        respawnText = ("Dead: Wait for a ~p~doctor~w~ to receive medical treatment or use local doctors ~p~E (%d)")
    end
    local coords,hosp = getClosestHospital()
    SetEntityCoords(player, coords)
    Wait(2000)
    TriggerEvent("comet-hospital:bed:checkin", doctors and doctors > 0)
    DoScreenFadeIn(3000)
end


exports('AmIDead', function()
    return imDead
end)

-- INFO: Revive Function
function attemptRevive()
    if not devmode and InVeh() then
        return
    end
    if imDead == 1 or IsDeadAnimPlaying() or IsDeadVehAnimPlaying() then
        imDead = 0
        thecount = 240
        local ped = PlayerPedId()
        TriggerEvent("heal")
        SetEntityInvincible(ped, false)
        SetPedMaxHealth(ped, 200)
        SetPlayerMaxArmour(PlayerId(), 60)
        ClearPedBloodDamage(ped)
        local plyPos = GetEntityCoords(ped,  true)
        local heading = GetEntityHeading(ped)
        -- TriggerEvent("resurrect:relationships")
        -- TriggerEvent("Evidence:isAlive")
        -- TriggerEvent('ai:resetKOS')
        ClearPedTasksImmediately(ped)

        -- local wasBeatdown = exports["police"]:getBeatmodeDebuff()

        -- if wasBeatdown then
        --     TriggerEvent("police:startBeatdownDebuff")
        -- end
        NetworkResurrectLocalPlayer(plyPos, heading, false, false, false)
        Citizen.Wait(500)
        RemoveAllPedWeapons(ped,true)
        getup()
    end
end

function getup()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "random@crash_rescue@help_victim_up" ) 
    TaskPlayAnim( PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    SetCurrentPedWeapon(PlayerPedId(),2725352035,true)
    Citizen.Wait(3000)
    endanimation()
end

function endanimation()
    ClearPedSecondaryTask(PlayerPedId())
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while(not HasAnimDictLoaded(dict)) do
        Citizen.Wait(0)
    end
end


RegisterNetEvent("heal")
AddEventHandler('heal', function()
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
	end
end)

function IsMinorCauseOfDeath(deathHash)
    if InjuryList[deathHash] and InjuryList[deathHash].minor then
        return true
    end
    return false
end

function IsViolentCauseOfDeath(deathHash)
    if InjuryList[deathHash] and InjuryList[deathHash].violent then
        return true
    end
    return false
end

function getClosestHospital()
    local hospitals = {
        ['Pillbox Hospital'] = vector3(357.43, -593.36, 28.79),
        -- ['Viceroy Hospital'] = vector3(-800.99, -1251.32, 7.34),
    }
    local plyCoords = GetEntityCoords(PlayerPedId())
    local min = 9999
    local foundName = 'Pillbox Hospital'
    local foundCoords = hospitals[foundName]
    for name,hospital in ipairs(hospitals) do
        local dist = #(hospital - plyCoords)
        if dist < min then
            min = dist
            foundCoords = hospital
            foundName = name
        end
    end
    return foundCoords, foundName
end

AddEventHandler("DamageEvents:EntityDamaged", function(victim, attacker, pWeapon, isMelee)
    local playerPed = PlayerPedId()

    if victim ~= playerPed then
      return
    end

    lastDamageTaken = {
        hash = pWeapon,
        source = attacker,
        melee = isMelee
    }
end)

local lastPing = 0
AddEventHandler('comet-hospital:sendPing', function()
    if GetGameTimer() - lastPing < 180 * 1000 then
        return
    end
    lastPing = GetGameTimer()
    -- dispatch send death
end)

AddEventHandler('comet-hospital:respawnLocal', function()
    releaseBody(false)
end)

AddEventHandler('comet-hospital:setPoisonState', function(pState)
    isPoisoned = pState
end)

exports('allowRespawn', function() return allowLocalEMS and thecount < 0 and not inDoctorBed end)

function SetPlayerHealth(pAmount, pFromHeal)
    local ped = PlayerPedId()
    local prevHealth = GetEntityHealth(ped)
    local maxHealth = GetEntityMaxHealth(ped)
    if pAmount > maxHealth then
        pAmount = maxHealth
    end

    if pFromHeal then
        local hunger = 100 -- COME BACK NEEDED NIG
        if hunger < 40 then
            local hungerFactor = (hunger / 40)
            local diff = math.floor((pAmount - prevHealth) * hungerFactor + 0.5)
            if diff == 1 and math.random(1,100) > 40 * hungerFactor then
                diff = 0
            end
            pAmount = pAmount + diff
        end
    end

    SetEntityHealth(ped, pAmount)
end

function SetPlayerArmor(pAmount)
    local ped = PlayerPedId()
    local maxArmor = GetPlayerMaxArmour(PlayerId())
    if pAmount > maxArmor then
        pAmount = maxArmor
    end
    SetPedArmour(ped, pAmount)
end

function SetMaxArmor()
    local armor = math.floor(((currentPercent / 100) * MAX_ARMOR) + 0.5)
    SetPlayerMaxArmour(PlayerId(), math.max(MIN_ARMOR, armor))
end

function SetMaxHealth()
    local health = math.floor(((currentPercent / 100) * MAX_HEALTH) + 0.5)
    SetPedMaxHealth(PlayerPedId(), math.max(MIN_HEALTH, health))
end


exports('SetPlayerHealth', SetPlayerHealth)
exports('SetPlayerArmor', SetPlayerArmor)
exports('SetMaxHealth', SetMaxHealth)
exports('SetMaxArmor', SetMaxArmor)
-- exports('OverrideMaxHealth', OverrideMaxHealth)
-- exports('DisableReduceFactor', DisableReduceFactor)
