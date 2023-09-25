local curDoctors = 0
-- local isTriageEnabled = false

local isdoc = false
local isadded = false
local injurycount = 0
local inbed = false

local bedcoords = {
    [1] =  { ['x'] = 310.26,['y'] = -577.63,['z'] = 43.29,['h'] = 53.16 },   
    [2] =  { ['x'] = 321.9,['y'] = -585.86,['z'] = 43.29,['h'] = 193.55 },
    [3] =  { ['x'] = 318.56,['y'] = -580.69,['z'] = 43.29,['h'] = 245.66 },
    [4] =  { ['x'] = 316.87,['y'] = -584.93,['z'] = 43.29,['h'] = 247.1 },
    [5] =  { ['x'] = 313.56,['y'] = -583.83,['z'] = 43.29,['h'] = 250.0 },
    [6] =  { ['x'] = 314.91,['y'] = -579.39,['z'] = 43.29,['h'] = 68.7 },
    [7] =  { ['x'] = 312.01,['y'] = -583.34,['z'] = 43.29,['h'] = 66.16 },
}

local hspLocs = {
	[1] = { ["x"] = 326.2477722168, ["y"] = -583.00897216797, ["z"] = 43.317371368408, ["h"] = 330.01126098633, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[2] = { ["x"] = 308.50784301758, ["y"] = -596.73718261719, ["z"] = 43.291816711426, ["h"] = 9.658652305603, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[3] = { ["x"] = 305.08477783203, ["y"] = -598.11743164063, ["z"] = 43.291816711426, ["h"] = 74.243743896484, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[4] = { ["x"] = 331.91491699219, ["y"] = -576.86529541016, ["z"] = 43.317203521729, ["h"] = 66.368347167969, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[5] = { ["x"] = 344.10360717773, ["y"] = -586.115234375, ["z"] = 43.315013885498, ["h"] = 143.51832580566, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[6] = { ["x"] = 347.22564697266, ["y"] = -587.91693115234, ["z"] = 43.31504440307, ["h"] = 67.972259521484, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[7] = { ["x"] = 329.59005737305, ["y"] = -581.37854003906, ["z"] = 43.317241668701, ["h"] = 86.95824432373, ["name"] = "None", ["fnc"] = "aiSCAN" },
	[8] = { ["x"] = 315.22637939453, ["y"] = -593.30419921875, ["z"] = 43.291805267334, ["h"] = 115.40777587891, ["name"] = "None", ["fnc"] = "aiSCAN" },
	[9] = { ["x"] = 353.38198852539, ["y"] = -588.38922119141, ["z"] = 43.315010070801, ["h"] = 61.995723724365, ["name"] = "None", ["fnc"] = "aiSCAN" },
}

--307.39239501953, -595.33642578125, 43.123157501221

local TargetZones = {
    [1] = vec3(307.39239501953, -595.33642578125, 43.12315750122),
}
-- for i = 1, #TargetZones do
--     exports.ox_target:addSphereZone({
--         coords = TargetZones[i],
--         radius = 1,
--         debug = true,
--         options = {
--             {
--                 name = 'check_in',
--                 event = 'comet-hospital:checkin',
--                 icon = 'fa-solid fa-clipboard',
--                 label = 'Check In',
--                 distance = 1.0,
--             }
--         }
--     })
-- end

RegisterNetEvent("comet-hospital:checkin", function()
	local count = 5
	if count < Config.EMSNeeded then
		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',1.0, 1.0, -1, 1, 0, 0, 0, 0)

        if lib.progressBar({
            duration = 3000,
            label = 'Checking Credentials',
            useWhileDead = true,
            canCancel = true,
            disable = {
                car = true,
            },
        }) then 
            TriggerEvent("reviveFunction")
			Citizen.Wait(500)
			TriggerEvent("comet-hospital:bed:checkin")
        end
	else
		lib.notify({
            description = "There are active EMS, Wait for one of them.",
            type = 'inform',
        })
		return
	end
end)

function CheckBeds(x,y,z)
	local players = GetPlayers()
	local ply = PlayerPedId()
	local closestplayers = {}
	local closestdistance = {}
	local closestcoords = {}
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(x,y,z))
			if(distance < 3) then
				return false
			end
		end
	end
	return true
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

sleeping = false
showInteraction = true
local shit = false

local beds = {
  2117668672,
  1631638868,
  -1787305376,
  666470117,
  -1182962909,
  -1519439119, -- operation
  -289946279, -- mri
  -1091386327,
}

function getout()

    local ped = PlayerPedId()

    local testdic = "switch@franklin@bed"
    local testanim = "sleep_getup_rubeyes"



    RequestAnimDict(testdic)

    while not HasAnimDictLoaded(testdic) and not handCuffed do
        Citizen.Wait(0)
    end

    if IsEntityPlayingAnim(ped, testdic, testanim, 3) then
        ClearPedSecondaryTask(ped)
    else
        local animLength = GetAnimDuration(testdic, testanim)

        local pronepos = GetEntityCoords(PlayerPedId())
        TaskPlayAnim(ped, testdic, testanim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)

        -- TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, animLength, 8, -1, 0, 0, 0)
    end
    playing_emote = false
end

RegisterNetEvent("comet-hospital:bed")
AddEventHandler("comet-hospital:bed",function()
  local ped = PlayerPedId()
  lastPlayerPos = GetEntityCoords(PlayerPedId())

  local objFound = nil
  local near = 999

  for i=1, #beds do

    local curobjFound = GetClosestObjectOfType(lastPlayerPos, 3.0, beds[i], 0, 0, 0)
    if curobjFound ~= 0 then
      local dist = #(GetEntityCoords(curobjFound) - GetEntityCoords(ped))

      if DoesEntityExist(curobjFound) then
        if dist ~= 0 and dist < near then
          near = dist
          objFound = curobjFound
        end
      end
    end
  end

  if DoesEntityExist(objFound) then
    loadAnimDict( "missfinale_c1@" )
    Citizen.Wait(500)

    sleeping = true
    showInteraction = true
	lib.showTextUI('[E] Leave Bed')

    if GetEntityModel(objFound) and shit == true then
		sleeping = false
        lib.hideTextUI()

	  local counter = 0
		SetEntityHeading(GetEntityHeading(PlayerPedId()-90))
		-- TriggerEvent("animation:PlayAnimation","getup")
        getout()
		local count=0
		while counter < 400 do
		  counter = counter + 1
  
		  if counter > 250 then
			count = count + 0.004
			AttachEntityToEntity(ped, objFound, 1, 0.1, 0.02, 2 / 2.0, 0.0, 0.0, -90.0, false, false, false, false, 0, false)
		  else
			 AttachEntityToEntity(ped, objFound, 1, 0.1, 0.02, 2 / 2.0, 0.0, 0.0, -90.0, false, false, false, false, 0, false)
		  end
		  Citizen.Wait(1)
		end
		camOff()
		DetachEntity(PlayerPedId(), 1, true)
		shit = false
	  end
    end

      while sleeping do
		local bedOffset = vector3(-0.2, 0.1, 1.4)
        AttachEntityToEntity(ped, objFound, 1, bedOffset.x, bedOffset.y, bedOffset.z, 0.0, 0.0, 180.0, true, true, true, true, 1, true)
		shit = true
		TaskPlayAnim( ped, "missfinale_c1@", "lying_dead_player0", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
		if not showInteraction then
			lib.hideTextUI()
        end
        Citizen.Wait(1000)
    end
end)

function camOn()
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam,  true)
		RenderScriptCams(true,  false,  0,  true,  true)
	end	
end

function camOff()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
end

RegisterNetEvent("comet-hospital:bed:checkin")
AddEventHandler("comet-hospital:bed:checkin",function()
	findBed(true)
end)

function findBed(fadein)
    
	if not inbed then
		myinjury = "General Checkups"
		local mybedx,mybedy,mybedz = 363.86135864258,-593.99725341797,43.389274597168
		for i = 1, #bedcoords do
			if CheckBeds(bedcoords[i]["x"],bedcoords[i]["y"],bedcoords[i]["z"]) and not inbed then
				inbed = true
				mybedx,mybedy,mybedz = bedcoords[i]["x"],bedcoords[i]["y"],bedcoords[i]["z"]
			end
		end

		SetEntityCoords(PlayerPedId(),mybedx,mybedy,mybedz)

		if inbed then
			TriggerEvent("comet-hospital:bed")
		end
		
		TriggerEvent("comet-hospital:inBed",fadein)
		
		Citizen.Wait(5000)

		-- TriggerEvent("chatMessage", "Service ", 5, "It was a success, you have been billed for your injuries in the amount of: $100.")

		SetEntityHealth(PlayerPedId(),200)
		Citizen.Wait(1000)
		inbed = false
		injurycount = 0
		TriggerServerEvent("comet-hospital:reviveSV2")
	end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5)
		if IsControlJustReleased(1, 38) and shit == true then
			TriggerEvent("comet-hospital:bed")
		end
	end
end)

RegisterNetEvent("comet-hospital:inBed")
AddEventHandler("comet-hospital:inBed",function(fadein)
	local opacityc
	if fadein then
		opacityc = 0
	else
		opacityc = 255
	end
	while inbed do
		if opacityc < 255 then
			opacityc = opacityc + 1
		end
		DrawRect(0, 0, 10.0, 10.0, 1, 1, 1, opacityc)
		Citizen.Wait(1)
	end
end)


local checkupCounter = 45 + math.random(10,25)
local hospitalization = {}
local myspawns = {}
local skipCheckup = false
hospitalization.level = 0
hospitalization.illness = "None"
hospitalization.time = 0
--     level,illness,time = getHospitalization(cid)
RegisterNetEvent("client:hospitalization:status")
AddEventHandler("client:hospitalization:status", function(passedVar1,passedVar2,passedVar3)
	hospitalization.level = passedVar1
	hospitalization.illness = passedVar2
	hospitalization.time = passedVar3
	if hospitalization.illness == "icu" and not ICU then
		ICUscreen(false)
		return
	end		

	if hospitalization.illness == "dead" and not ICU then
		ICUscreen(true)
		return
	end	

end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


--sounds
--heartmonbeat
--heartmondead
--ventilator
--TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.1)
ICU = false
dead = false
local counter = 0
function ICUscreen(dying)
	counter = 0
	ICU = true
	dead = false
	while ICU do
		SetEntityCoords(PlayerPedId(),345.02133178711,-590.51824951172,60.109081268311)
		FreezeEntityPosition(PlayerPedId(),true)	
		SetEntityHealth(PlayerPedId(), 200.0)
		SetEntityInvincible(PlayerPedId(),true)
		Citizen.Wait(2300)
		if math.random(15) > 14 then
			TriggerEvent("changethirst")
			TriggerEvent("changehunger")
		end
		TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)

		counter = counter + 1

		if counter > 20 then
			dead = true
		end

		if dead then

			if dying then
				TriggerEvent("InteractSound_CL:PlayOnOne","heartmondead",0.5)
				Citizen.Wait(9500)
			end

			ICU = false
			logout()
			return

		end

	end

end

function logout()
	ExecuteCommand("logout")
end

Citizen.CreateThread( function()
	while true do 
		if ICU then
			DrawRect(0,0, 10.0, 10.0, 1, 1, 1, 255)
			DisableControlAction(0, 47, true)
		end
		Citizen.Wait(1)
	end
end)
local checktypes = {
	[1] = "Prescription Pickup",
	[2] = "Result Review",
	[3] = "Injury Checkup"
}
Citizen.CreateThread( function()
	while true do 
		Citizen.Wait(60000)
		if hospitalization.illness == "ICU" and not ICU then
			ICUscreen(false)
		end		
		if hospitalization.illness == "DEAD" and not ICU then
			ICUscreen(true)
		end		
		if checkupCounter > 0 then
			if hospitalization.level > 0 and checkupCounter == 45 and not skipCheckup then
				mychecktype = math.random(1,3)

				-- TriggerEvent("chatMessage", "EMAIL ", 8, "You are ready for your next " .. checktypes[mychecktype] .. " at the hospital! (Regarding: "..hospitalization.illness..") Failure to report may be bad for your health.")
				skipCheckup = true
			end			
			checkupCounter = checkupCounter - 1
		else
			checkupCounter = 60 + math.random(80)			
			if hospitalization.level > 0 then
				if skipCheckup then
					TriggerEvent("client:newStress",true,math.random(500))
				end
			end
		end
	end
end)

function randomHspPed()
	local math = math.random(6)
	ret = 1092080539
	if math == 5 then
		ret = 1092080539
	elseif math == 4 then
		ret = 1092080539
	elseif math == 3 then
		ret = 1092080539		
	end
	return ret
end

function randomScenario()
	local math = math.random(10)
	ret = "WORLD_HUMAN_CLIPBOARD"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math < 4 then
		ret = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
	end

	return ret
end
function findNPC(x,y,z)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    local pedfound = false
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(x,y,z) - pos)
        if distance < 11.0 and (distanceFrom == nil or distance < distanceFrom) then
        	pedfound = true
        end
        success, ped = FindNextPed(handle)
    until not success or pedfound
    EndFindPed(handle)
    return pedfound
end
