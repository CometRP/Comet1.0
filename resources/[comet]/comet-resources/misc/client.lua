-- Minimap shit
CreateThread(function()
    while true do
        SetRadarBigmapEnabled(false, false)
        SetRadarZoom(1000)
        Wait(500)
    end
end)

--Blacklisted Scenarios Types & Groups
CreateThread(function()
    while true do
        for _, sctyp in next, Misc.BlacklistedScenarios['TYPES'] do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, Misc.BlacklistedScenarios['GROUPS'] do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, Misc.BlacklistedScenarios['SUPPRESSED'] do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
        Wait(10000)
    end
end)

AddEventHandler("populationPedCreating", function(x, y, z)
	Wait(500) -- Give the entity some time to be created
	local _, handle = GetClosestPed(x, y, z, 1.0) -- Get the entity handle
	SetPedDropsWeaponsWhenDead(handle, false)
end)

CreateThread(function() -- all these should only need to be called once
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("DisableFlightMusic", true)
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
	SetAudioFlag("PoliceScannerDisabled", false)
	SetGarbageTrucks(false)
	SetCreateRandomCops(false)
	SetCreateRandomCopsNotOnScenarios(false)
	SetCreateRandomCopsOnScenarios(false)
	DistantCopCarSirens(false)
	RemoveVehiclesFromGeneratorsInArea(335.2616 - 300.0, -1432.455 - 300.0, 46.51 - 300.0, 335.2616 + 300.0, -1432.455 + 300.0, 46.51 + 300.0) -- central los santos medical center
	RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0) -- police station mission row
	RemoveVehiclesFromGeneratorsInArea(316.79 - 300.0, -592.36 - 300.0, 43.28 - 300.0, 316.79 + 300.0, -592.36 + 300.0, 43.28 + 300.0) -- pillbox
	RemoveVehiclesFromGeneratorsInArea(-2150.44 - 500.0, 3075.99 - 500.0, 32.8 - 500.0, -2150.44 + 500.0, -3075.99 + 500.0, 32.8 + 500.0) -- military
	RemoveVehiclesFromGeneratorsInArea(-1108.35 - 300.0, 4920.64 - 300.0, 217.2 - 300.0, -1108.35 + 300.0, 4920.64 + 300.0, 217.2 + 300.0) -- nudist
	RemoveVehiclesFromGeneratorsInArea(-458.24 - 300.0, 6019.81 - 300.0, 31.34 - 300.0, -458.24 + 300.0, 6019.81 + 300.0, 31.34 + 300.0) -- police station paleto
	RemoveVehiclesFromGeneratorsInArea(1854.82 - 300.0, 3679.4 - 300.0, 33.82 - 300.0, 1854.82 + 300.0, 3679.4 + 300.0, 33.82 + 300.0) -- police station sandy
	RemoveVehiclesFromGeneratorsInArea(-724.46 - 300.0, -1444.03 - 300.0, 5.0 - 300.0, -724.46 + 300.0, -1444.03 + 300.0, 5.0 + 300.0) -- REMOVE CHOPPERS WOW
end)

CreateThread(function()
    local pedPool = GetGamePool('CPed')
    for _, v in pairs(pedPool) do
        SetPedDropsWeaponsWhenDead(v, false)
    end
end)

CreateThread(function()
    while true do
        Wait(2500)
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        if Misc.BlacklistedWeapons[weapon] then
            RemoveWeaponFromPed(ped, weapon)
        end
    end
end)
-- Delete Props When Hitting Them With a Vehicle
local Props = {
    [729253480] = true,
    [-655644382] = true,
    [589548997] = true,
    [793482617] = true,
    [1502931467] = true,
    [1803721002] = true,
    [-1651641860] = true,
    [-156356737] = true,
    [1043035044] = true,
    [862871082] = true,
    [-1798594116] = true,
    [865627822] = true,
    [840050250] = true,
    [1821241621] = true,
    [-797331153] = true,
    [-949234773] = true,
    [1191039009] = true,
    [-463994753] = true,
    [-276539604] = true,
    [1021745343] = true,
    [-1063472968] = true,
    [1441261609] = true,
    [-667908451] = true,
    [-365135956] = true,
    [-157127644] = true,
    [-1057375813] = true,
    [-639994124] = true,
    [173177608] = true,
    [-879318991] = true,
    [-1529663453] = true,
    [267702115] = true,
    [1847069612] = true,
    [1452666705] = true,
    [681787797] = true,
    [1868764591] = true,
    [-1648525921] = true,
    [-1114695146] = true,
    [-943634842] = true,
    [-331378834] = true,
    [431612653] = true,
    [-97646180] = true,
    [1437508529] = true,
    [-2007495856] = true,
    [-16208233304] = true,
    [2122387284] = true,
    [1411103374] = true,
    [-216200273] = true,
    [1322893877] = true,
    [93794225] = true,
    [373936410] = true,
    [-872399736] = true,
    [-1178167275] = true,
    [1327054116] = true,
}

Citizen.CreateThread(function()
    while true do
        local PropsToDelete = {}
        local ped = PlayerPedId()
        local idle, success = 1000
        local handle, prop = FindFirstObject()
        repeat               
            if Props[GetEntityModel(prop)] then
                if GetObjectFragmentDamageHealth(prop,true) < 1.0 or (GetObjectFragmentDamageHealth(prop,true) ~= nil and GetEntityHealth(prop) < GetEntityMaxHealth(prop)) then
                    PropsToDelete[#PropsToDelete+1] = prop
                end
            end
            
            success, prop = FindNextObject(handle)
        until not success
        EndFindObject(handle)
        Citizen.Wait(1500)
        for i = 1, #PropsToDelete do
            SetEntityCoords(PropsToDelete[i],0,0,0)
        end
        Citizen.Wait(500)
    end
end)

-- Remove North Blip
CreateThread(function()
    SetBlipAlpha(GetNorthRadarBlip(), 0)
end)

-- No Driver Shooting
local passengerDriveBy = true
local minSpeedDriver = 40 -- MPH
local maxSpeedPassenger = 160 -- MPH
local conversionNum = 2.23694 --2.23694 for mph | 3.6 for kmh

local function GetVehicleSpeed(vehicle)
    local speed = GetEntitySpeed(vehicle)
    return (speed * conversionNum)
end

CreateThread(function()
	while true do
		Wait(1)

		playerPed = PlayerPedId()
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
                if GetVehicleSpeed(car) < minSpeedDriver then
				    SetPlayerCanDoDriveBy(PlayerId(), true)
                else
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                end
			elseif passengerDriveBy then
                if GetVehicleSpeed(car) < maxSpeedPassenger then
				    SetPlayerCanDoDriveBy(PlayerId(), true)
                end
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

--- Disables wierd run after shooting
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            if IsPedUsingActionMode(ped) then
                SetPedUsingActionMode(ped, -1, -1, 1)
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

-- Deactivate Idle Cam
CreateThread(function()
    while true do
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
        Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
    end
end)

-- Remove Pistol Whipping
CreateThread(function()
    while true do
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
        Wait(5)
    end
end)

--Blind Fire
CreateThread(function()
	while true do
		Wait(5)
		local ped = PlayerPedId()
		if IsPedInCover(ped, 1) and not IsPedAimingFromCover(ped, 1) then 
			DisableControlAction(2, 24, true) 
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 257, true)
		end		
	end
end)


-- Map Zoom Sens
CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)