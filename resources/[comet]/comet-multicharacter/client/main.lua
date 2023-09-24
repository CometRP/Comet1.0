local cam = nil
local charPed = nil
--local ped1 = nil
Callback = nil or exports['comet-base']:FetchComponent("Callback")
AddEventHandler("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Callback"
    }, function(pass)
        if not pass then return end
        Callback = exports['comet-base']:FetchComponent("Callback")
        print("[COMET-MULTICHARACTER] Loaded Components")
    end)
end)
-- Main Thread

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('comet-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Functions

local function pednpc(model)
    CreateThread(function()---New character
        local randommodels = Config.PlayerModels
        local model = GetHashKey(randommodels[math.random(1, #randommodels)])
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        charnpc = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
        TaskStartScenarioAtPosition(charnpc, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
        SetEntityAlpha(charnpc, 400)
        SetPedComponentVariation(charnpc, 0, 0, 0, 2)
        FreezeEntityPosition(charnpc, false)
        SetEntityInvincible(charnpc, true)
        PlaceObjectOnGroundProperly(charnpc)
        SetBlockingOfNonTemporaryEvents(charnpc, true)
    end)
end

local function skyCam(bool)
    TriggerEvent('comet-weathersync:client:DisableSync')
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.0 ,0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local function openCharMenu(bool)
    local result = Callback.Execute("comet-multicharacter:server:GetNumberOfCharacters")
	SetNuiFocus(bool, bool)
	SendNUIMessage({
		action = "ui",
		toggle = bool,
		nChar = result,
		enableDeleteButton = Config.EnableDeleteButton,
	})
	skyCam(bool)
	pednpc(model)
end

-- Events

RegisterNetEvent('comet-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(1000)
    local model = `mp_m_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    SetEntityHeading(PlayerPedId(), Config.DefaultSpawn.w)
    TriggerServerEvent('comet-base:playerLoaded')
    TriggerEvent('comet-base:playerLoaded')
    -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    -- TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('comet-weathersync:client:EnableSync')
    TriggerEvent('comet-clothingUI:client:CreateFirstCharacter')
end)

RegisterNetEvent('comet-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('comet-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function(_, cb)
    openCharMenu(false)
    cb("ok")
end)

RegisterNUICallback('disconnectButton', function(_, cb)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('comet-multicharacter:server:disconnect')
    cb("ok")
end)

RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('comet-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    cb("ok")
end)

RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData.cData
	SetEntityAsMissionEntity(charnpc, true, true)
	DeleteEntity(charnpc)	
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        local result = Callback.Execute('comet-multicharacter:server:getSkin', {cid = cData.cid} )
        local model = result.model
        local data = result.data
        -- print(json.encode(data))
		model = model ~= nil and tonumber(model) or false
		-- print(model)
		if model ~= nil then
			CreateThread(function()
				-- jay fix the fuck model time
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
				end
				SetPlayerModel(PlayerId(), model)
				charPed = ClonePed(PlayerPedId(), false, true, false)
				-- jay fix the fuck model time

				TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
				SetPedComponentVariation(charPed, 0, 0, 0, 2)
				FreezeEntityPosition(charPed, false)
				SetEntityInvincible(charPed, true)
				PlaceObjectOnGroundProperly(charPed)
				SetBlockingOfNonTemporaryEvents(charPed, true)
				-- data = json.decode(data)
			end)
		else
			CreateThread(function()
				local randommodels = Config.PlayerModels
				model = GetHashKey(randommodels[math.random(1, #randommodels)])
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
				end
				charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
				TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
				SetPedComponentVariation(charPed, 0, 0, 0, 2)
				FreezeEntityPosition(charPed, false)
				SetEntityInvincible(charPed, true)
				PlaceObjectOnGroundProperly(charPed)
				SetBlockingOfNonTemporaryEvents(charPed, true)
			end)
		end
		cb("ok")
    else
        CreateThread(function()--
            local randommodels = Config.PlayerModels
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
			TaskStartScenarioAtPosition(charPed, 'PROP_HUMAN_SEAT_BENCH', Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, 0, false, true)
			SetEntityAlpha(charPed, 400)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
        cb("ok")
    end
end)

RegisterNUICallback('setupCharacters', function(_, cb)
    local result = Callback.Execute("comet-multicharacter:server:setupCharacters")
	SendNUIMessage({
		action = "setupCharacters",
		characters = result
	})
	cb("ok")
end)

RegisterNUICallback('removeBlur', function(_, cb)
    SetTimecycleModifier('default')
    cb("ok")
end)

RegisterNUICallback('createNewCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Male" then
        cData.gender = 0
    elseif cData.gender == "Female" then
        cData.gender = 1
    end
    TriggerServerEvent('comet-multicharacter:server:createCharacter', cData)
    Wait(500)
    cb("ok")
end)

RegisterNUICallback('removeCharacter', function(data, cb)
    TriggerServerEvent('comet-multicharacter:server:deleteCharacter', data.cid)
    TriggerEvent('comet-multicharacter:client:chooseChar')
    cb("ok")
end)


local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}
tatCategory = nil
tattooHashList = nil

function LoadPed(ped, data, model)
    SetClothing(ped, data.drawables, data.props, data.drawtextures, data.proptextures)
    if data.tattoos then
        -- currentTats = data.tattoos
        SetTats(ped,GetTats(data.tattoos))
        -- SetTats(ped, GetTats(data.tattoos)) --tattoos = json.decode(ct[1].tattoos)
    end
    Citizen.Wait(500)
    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then
        SetPedHeadBlend(ped, data.headBlend)
        SetHeadStructure(ped, data.headStructure)
        SetHeadOverlayData(ped, data.headOverlay)
		if data.hairColor then
        	SetPedHairColor(ped, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))
		end
    end
    return
end


function SetClothing(ped,drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(ped, i-1)
        SetPedPropIndex(
            ped,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end


function SetPedHeadBlend(ped,data)
	if data then
		SetPedHeadBlendData(ped,
			tonumber(data['shapeFirst']),
			tonumber(data['shapeSecond']),
			tonumber(data['shapeThird']),
			tonumber(data['skinFirst']),
			tonumber(data['skinSecond']),
			tonumber(data['skinThird']),
			tonumber(data['shapeMix']),
			tonumber(data['skinMix']),
			tonumber(data['thirdMix']),
			false)
	end
end

function SetHeadStructure(ped,data)
	if data then
		for i = 1, #face_features do
			SetPedFaceFeature(ped, i-1, data[i])
		end
	end
end

function SetHeadOverlayData(ped,data)
	if data then
		if json.encode(data) ~= "[]" then
			for i = 1, #head_overlays do
				SetPedHeadOverlay(ped,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
				-- SetPedHeadOverlayColor(ped, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
			end

			SetPedHeadOverlayColor(ped, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
			SetPedHeadOverlayColor(ped, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
			SetPedHeadOverlayColor(ped, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
			SetPedHeadOverlayColor(ped, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
			SetPedHeadOverlayColor(ped, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
			SetPedHeadOverlayColor(ped, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
			SetPedHeadOverlayColor(ped, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
			SetPedHeadOverlayColor(ped, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
			SetPedHeadOverlayColor(ped, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
			SetPedHeadOverlayColor(ped, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
			SetPedHeadOverlayColor(ped, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
			SetPedHeadOverlayColor(ped, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
		end
	end
end
-- tattoos
tattoosList = {
	["mpbusiness_overlays"] = {
		"MP_Buis_M_Neck_000",
		"MP_Buis_M_Neck_001",
		"MP_Buis_M_Neck_002",
		"MP_Buis_M_Neck_003",
		"MP_Buis_M_LeftArm_000",
		"MP_Buis_M_LeftArm_001",
		"MP_Buis_M_RightArm_000",
		"MP_Buis_M_RightArm_001",
		"MP_Buis_M_Stomach_000",
		"MP_Buis_M_Chest_000",
		"MP_Buis_M_Chest_001",
		"MP_Buis_M_Back_000",
		"MP_Buis_F_Chest_000",
		"MP_Buis_F_Chest_001",
		"MP_Buis_F_Chest_002",
		"MP_Buis_F_Stom_000",
		"MP_Buis_F_Stom_001",
		"MP_Buis_F_Stom_002",
		"MP_Buis_F_Back_000",
		"MP_Buis_F_Back_001",
		"MP_Buis_F_Neck_000",
		"MP_Buis_F_Neck_001",
		"MP_Buis_F_RArm_000",
		"MP_Buis_F_LArm_000",
		"MP_Buis_F_LLeg_000",
		"MP_Buis_F_RLeg_000",
	},

	["mphipster_overlays"] = {
		"FM_Hip_M_Tat_000",
		"FM_Hip_M_Tat_001",
		"FM_Hip_M_Tat_002",
		"FM_Hip_M_Tat_003",
		"FM_Hip_M_Tat_004",
		"FM_Hip_M_Tat_005",
		"FM_Hip_M_Tat_006",
		"FM_Hip_M_Tat_007",
		"FM_Hip_M_Tat_008",
		"FM_Hip_M_Tat_009",
		"FM_Hip_M_Tat_010",
		"FM_Hip_M_Tat_011",
		"FM_Hip_M_Tat_012",
		"FM_Hip_M_Tat_013",
		"FM_Hip_M_Tat_014",
		"FM_Hip_M_Tat_015",
		"FM_Hip_M_Tat_016",
		"FM_Hip_M_Tat_017",
		"FM_Hip_M_Tat_018",
		"FM_Hip_M_Tat_019",
		"FM_Hip_M_Tat_020",
		"FM_Hip_M_Tat_021",
		"FM_Hip_M_Tat_022",
		"FM_Hip_M_Tat_023",
		"FM_Hip_M_Tat_024",
		"FM_Hip_M_Tat_025",
		"FM_Hip_M_Tat_026",
		"FM_Hip_M_Tat_027",
		"FM_Hip_M_Tat_028",
		"FM_Hip_M_Tat_029",
		"FM_Hip_M_Tat_030",
		"FM_Hip_M_Tat_031",
		"FM_Hip_M_Tat_032",
		"FM_Hip_M_Tat_033",
		"FM_Hip_M_Tat_034",
		"FM_Hip_M_Tat_035",
		"FM_Hip_M_Tat_036",
		"FM_Hip_M_Tat_037",
		"FM_Hip_M_Tat_038",
		"FM_Hip_M_Tat_039",
		"FM_Hip_M_Tat_040",
		"FM_Hip_M_Tat_041",
		"FM_Hip_M_Tat_042",
		"FM_Hip_M_Tat_043",
		"FM_Hip_M_Tat_044",
		"FM_Hip_M_Tat_045",
		"FM_Hip_M_Tat_046",
		"FM_Hip_M_Tat_047",
		"FM_Hip_M_Tat_048",
	},

	["mpbiker_overlays"] = {
		"MP_MP_Biker_Tat_000_M",
		"MP_MP_Biker_Tat_001_M",
		"MP_MP_Biker_Tat_002_M",
		"MP_MP_Biker_Tat_003_M",
		"MP_MP_Biker_Tat_004_M",
		"MP_MP_Biker_Tat_005_M",
		"MP_MP_Biker_Tat_006_M",
		"MP_MP_Biker_Tat_007_M",
		"MP_MP_Biker_Tat_008_M",
		"MP_MP_Biker_Tat_009_M",
		"MP_MP_Biker_Tat_010_M",
		"MP_MP_Biker_Tat_011_M",
		"MP_MP_Biker_Tat_012_M",
		"MP_MP_Biker_Tat_013_M",
		"MP_MP_Biker_Tat_014_M",
		"MP_MP_Biker_Tat_015_M",
		"MP_MP_Biker_Tat_016_M",
		"MP_MP_Biker_Tat_017_M",
		"MP_MP_Biker_Tat_018_M",
		"MP_MP_Biker_Tat_019_M",
		"MP_MP_Biker_Tat_020_M",
		"MP_MP_Biker_Tat_021_M",
		"MP_MP_Biker_Tat_022_M",
		"MP_MP_Biker_Tat_023_M",
		"MP_MP_Biker_Tat_024_M",
		"MP_MP_Biker_Tat_025_M",
		"MP_MP_Biker_Tat_026_M",
		"MP_MP_Biker_Tat_027_M",
		"MP_MP_Biker_Tat_028_M",
		"MP_MP_Biker_Tat_029_M",
		"MP_MP_Biker_Tat_030_M",
		"MP_MP_Biker_Tat_031_M",
		"MP_MP_Biker_Tat_032_M",
		"MP_MP_Biker_Tat_033_M",
		"MP_MP_Biker_Tat_034_M",
		"MP_MP_Biker_Tat_035_M",
		"MP_MP_Biker_Tat_036_M",
		"MP_MP_Biker_Tat_037_M",
		"MP_MP_Biker_Tat_038_M",
		"MP_MP_Biker_Tat_039_M",
		"MP_MP_Biker_Tat_040_M",
		"MP_MP_Biker_Tat_041_M",
		"MP_MP_Biker_Tat_042_M",
		"MP_MP_Biker_Tat_043_M",
		"MP_MP_Biker_Tat_044_M",
		"MP_MP_Biker_Tat_045_M",
		"MP_MP_Biker_Tat_046_M",
		"MP_MP_Biker_Tat_047_M",
		"MP_MP_Biker_Tat_048_M",
		"MP_MP_Biker_Tat_049_M",
		"MP_MP_Biker_Tat_050_M",
		"MP_MP_Biker_Tat_051_M",
		"MP_MP_Biker_Tat_052_M",
		"MP_MP_Biker_Tat_053_M",
		"MP_MP_Biker_Tat_054_M",
		"MP_MP_Biker_Tat_055_M",
		"MP_MP_Biker_Tat_056_M",
		"MP_MP_Biker_Tat_057_M",
		"MP_MP_Biker_Tat_058_M",
		"MP_MP_Biker_Tat_059_M",
		"MP_MP_Biker_Tat_060_M",
	},

	["mpairraces_overlays"] = {
		"MP_Airraces_Tattoo_000_M",
		"MP_Airraces_Tattoo_001_M",
		"MP_Airraces_Tattoo_002_M",
		"MP_Airraces_Tattoo_003_M",
		"MP_Airraces_Tattoo_004_M",
		"MP_Airraces_Tattoo_005_M",
		"MP_Airraces_Tattoo_006_M",
		"MP_Airraces_Tattoo_007_M",
	},

	["mpbeach_overlays"] = {
		"MP_Bea_M_Back_000",
		"MP_Bea_M_Chest_000",
		"MP_Bea_M_Chest_001",
		"MP_Bea_M_Head_000",
		"MP_Bea_M_Head_001",
		"MP_Bea_M_Head_002",
		"MP_Bea_M_Lleg_000",
		"MP_Bea_M_Rleg_000",
		"MP_Bea_M_RArm_000",
		"MP_Bea_M_Head_000",
		"MP_Bea_M_LArm_000",
		"MP_Bea_M_LArm_001",
		"MP_Bea_M_Neck_000",
		"MP_Bea_M_Neck_001",
		"MP_Bea_M_RArm_001",
		"MP_Bea_M_Stom_000",
		"MP_Bea_M_Stom_001",
	},

	["mpchristmas2_overlays"] = {
		"MP_Xmas2_M_Tat_000",
		"MP_Xmas2_M_Tat_001",
		"MP_Xmas2_M_Tat_003",
		"MP_Xmas2_M_Tat_004",
		"MP_Xmas2_M_Tat_005",
		"MP_Xmas2_M_Tat_006",
		"MP_Xmas2_M_Tat_007",
		"MP_Xmas2_M_Tat_008",
		"MP_Xmas2_M_Tat_009",
		"MP_Xmas2_M_Tat_010",
		"MP_Xmas2_M_Tat_011",
		"MP_Xmas2_M_Tat_012",
		"MP_Xmas2_M_Tat_013",
		"MP_Xmas2_M_Tat_014",
		"MP_Xmas2_M_Tat_015",
		"MP_Xmas2_M_Tat_016",
		"MP_Xmas2_M_Tat_017",
		"MP_Xmas2_M_Tat_018",
		"MP_Xmas2_M_Tat_019",
		"MP_Xmas2_M_Tat_022",
		"MP_Xmas2_M_Tat_023",
		"MP_Xmas2_M_Tat_024",
		"MP_Xmas2_M_Tat_025",
		"MP_Xmas2_M_Tat_026",
		"MP_Xmas2_M_Tat_027",
		"MP_Xmas2_M_Tat_028",
		"MP_Xmas2_M_Tat_029",
	},

	["mpgunrunning_overlays"] = {
		"MP_Gunrunning_Tattoo_000_M",
		"MP_Gunrunning_Tattoo_001_M",
		"MP_Gunrunning_Tattoo_002_M",
		"MP_Gunrunning_Tattoo_003_M",
		"MP_Gunrunning_Tattoo_004_M",
		"MP_Gunrunning_Tattoo_005_M",
		"MP_Gunrunning_Tattoo_006_M",
		"MP_Gunrunning_Tattoo_007_M",
		"MP_Gunrunning_Tattoo_008_M",
		"MP_Gunrunning_Tattoo_009_M",
		"MP_Gunrunning_Tattoo_010_M",
		"MP_Gunrunning_Tattoo_011_M",
		"MP_Gunrunning_Tattoo_012_M",
		"MP_Gunrunning_Tattoo_013_M",
		"MP_Gunrunning_Tattoo_014_M",
		"MP_Gunrunning_Tattoo_015_M",
		"MP_Gunrunning_Tattoo_016_M",
		"MP_Gunrunning_Tattoo_017_M",
		"MP_Gunrunning_Tattoo_018_M",
		"MP_Gunrunning_Tattoo_019_M",
		"MP_Gunrunning_Tattoo_020_M",
		"MP_Gunrunning_Tattoo_021_M",
		"MP_Gunrunning_Tattoo_022_M",
		"MP_Gunrunning_Tattoo_023_M",
		"MP_Gunrunning_Tattoo_024_M",
		"MP_Gunrunning_Tattoo_025_M",
		"MP_Gunrunning_Tattoo_026_M",
		"MP_Gunrunning_Tattoo_027_M",
		"MP_Gunrunning_Tattoo_028_M",
		"MP_Gunrunning_Tattoo_029_M",
		"MP_Gunrunning_Tattoo_030_M",
	},

	["mpimportexport_overlays"] = {
		"MP_MP_ImportExport_Tat_000_M",
		"MP_MP_ImportExport_Tat_001_M",
		"MP_MP_ImportExport_Tat_002_M",
		"MP_MP_ImportExport_Tat_003_M",
		"MP_MP_ImportExport_Tat_004_M",
		"MP_MP_ImportExport_Tat_005_M",
		"MP_MP_ImportExport_Tat_006_M",
		"MP_MP_ImportExport_Tat_007_M",
		"MP_MP_ImportExport_Tat_008_M",
		"MP_MP_ImportExport_Tat_009_M",
		"MP_MP_ImportExport_Tat_010_M",
		"MP_MP_ImportExport_Tat_011_M",
	},

	["mplowrider2_overlays"] = {
		"MP_LR_Tat_000_M",
		"MP_LR_Tat_003_M",
		"MP_LR_Tat_006_M",
		"MP_LR_Tat_008_M",
		"MP_LR_Tat_011_M",
		"MP_LR_Tat_012_M",
		"MP_LR_Tat_016_M",
		"MP_LR_Tat_018_M",
		"MP_LR_Tat_019_M",
		"MP_LR_Tat_022_M",
		"MP_LR_Tat_028_M",
		"MP_LR_Tat_029_M",
		"MP_LR_Tat_030_M",
		"MP_LR_Tat_031_M",
		"MP_LR_Tat_032_M",
		"MP_LR_Tat_035_M",
	},

	["mplowrider_overlays"] = {
		"MP_LR_Tat_001_M",
		"MP_LR_Tat_002_M",
		"MP_LR_Tat_004_M",
		"MP_LR_Tat_005_M",
		"MP_LR_Tat_007_M",
		"MP_LR_Tat_009_M",
		"MP_LR_Tat_010_M",
		"MP_LR_Tat_013_M",
		"MP_LR_Tat_014_M",
		"MP_LR_Tat_015_M",
		"MP_LR_Tat_017_M",
		"MP_LR_Tat_020_M",
		"MP_LR_Tat_021_M",
		"MP_LR_Tat_023_M",
		"MP_LR_Tat_026_M",
		"MP_LR_Tat_027_M",
		"MP_LR_Tat_033_M",
	}
}

local tatCategs = {
    {"ZONE_TORSO", 0},
    {"ZONE_HEAD", 0},
    {"ZONE_LEFT_ARM", 0},
    {"ZONE_RIGHT_ARM", 0},
    {"ZONE_LEFT_LEG", 0},
    {"ZONE_RIGHT_LEG", 0},
    {"ZONE_UNKNOWN", 0},
    {"ZONE_NONE", 0},
}

function AddZoneIDToTattoos()
    tempTattoos = {}
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            if tempTattoos[key] == nil then tempTattoos[key] = {} end
            tempTattoos[key][i] = {
                tattoosList[key][i],
                tatCategs[
                    GetPedDecorationZoneFromHashes(
                        key,
                        GetHashKey(tattoosList[key][i])
                    ) + 1
                ][1]
            }
        end
    end
    tattoosList = tempTattoos
end
AddZoneIDToTattoos()

function CreateHashList()
    tempTattooHashList = {}
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            local categ = tattoosList[key][i][2]
            if tempTattooHashList[categ] == nil then tempTattooHashList[categ] = {} end
            table.insert(
                tempTattooHashList[categ],
                {GetHashKey(tattoosList[key][i][1]),
                GetHashKey(key)}
            )
        end
    end
    return tempTattooHashList
end

function GetTatCategs()
    for key in pairs(tattoosList) do
        for i = 1, #tattoosList[key] do
            local zone = GetPedDecorationZoneFromHashes(
                key,
                GetHashKey(tattoosList[key][i][1])
            )
            tatCategs[zone+1] = {tatCategs[zone+1][1], tatCategs[zone+1][2]+1}
        end
    end
    return tatCategs
end


local tatCategory = GetTatCategs()
local tattooHashList = CreateHashList()

function GetTats(currentTats)
    local tempTats = {}
    if currentTats == nil then return {} end
    for i = 1, #currentTats do
        for key in pairs(tattooHashList) do
            for j = 1, #tattooHashList[key] do
                if tattooHashList[key][j][1] == currentTats[i][2] then
                    tempTats[key] = j
                end
            end
        end
    end
    return tempTats
end

function SetTats(ped,data)
    currentTats = {}
    for k, v in pairs(data) do
        -- print(k,v)
        for categ in pairs(tattooHashList) do
            if k == categ then
                local something = tattooHashList[categ][tonumber(v)]
                if something ~= nil then
                    table.insert(currentTats, {something[2], something[1]})
                end
            end
        end
    end
    ClearPedDecorations(ped)
    for i = 1, #currentTats do
        ApplyPedOverlay(ped, currentTats[i][1], currentTats[i][2])
    end
end
