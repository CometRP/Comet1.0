



--[[
    Functions below: Ped spawning / clothing attachment 
    Description: function spawns and skins the peds acourding to the players chars , this is also where the start of the train spawn takes place 
    along with fetching players char data from DB , clothing data is done before this function.
    This also determains the model for the spawning peds be it the one based on char clothing or a empty ped slot
]]


function Login.CreatePlayerCharacterPeds(characterModelData,isReset)
    if Login.actionsBlocked and not isReset then return end
    Login.actionsBlocked = true
    if not isReset then
        Wait(1000)
        Login.LoadFinished = false
        Login.ClearSpawnedPeds()
        CleanUpArea()
        Wait(1000)
        CleanUpArea()

        while Login.isTrainMoving do
            Wait(10)
        end

        while Login.HasTransistionFinished do
            Wait(10)
        end


    end


    Login.CurrentClothing = characterModelData

    -- local events = exports["comet-base"]:getModule("Events")
    Events:Trigger("comet-base:fetchPlayerCharacters", nil, function(data)
        if data.err then
            return
        end

        local pedCoords = GetEntityCoords(PlayerPedId())
       
        if isReset then
            Login.ClearSpawnedPeds()
        end
        Login.CreatedPeds = {}
        local PlusOneEmpty = false
		
        local noCharacters = true
		
        for _=1,#Login.spawnLoc do
            local isCustom = false
            local character = nil
            local cid = 0


            local cModelHash = GetHashKey("mp_f_freemode_01")
            if data[_] ~= nil then 
                character = data[_]

                local gender = `mp_male`

                if character.gender == 1 then
                    cModelHash = GetHashKey("mp_f_freemode_01")
                    gender = `mp_female`
                else
                    cModelHash = GetHashKey("mp_m_freemode_01")
                    
                end
                
                cid = character.id
               
                if characterModelData[cid] ~= nil then cModelHash = tonumber(characterModelData[cid].model) end
				noCharacters = false
            else
                if math.random(2) == 1 then
                    cModelHash = GetHashKey("mp_f_freemode_01")
                end
            end

            if character == nil and not PlusOneEmpty then
                PlusOneEmpty = _
            end

            Login.RequestModel(cModelHash, function(loaded, model, modelHash)
                RequestAnimDict("timetable@ron@ig_3_couch")
				SetPedFleeAttributes(created_ped12, 0, 0)
				while not HasAnimDictLoaded("timetable@ron@ig_3_couch") do
				Wait(0)
				end

                if loaded then

                    local newPed = nil 
                    
                    if character ~= nil then
                        if modelHash == 1603401902 or modelHash == 1578646463 or modelHash == 1638605387 or modelHash == 355108384 or modelHash == -1387550604 or modelHash == 1847322483 or modelHash == 1873393017 or modelHash == -43215771 or modelHash == 1111127623 or modelHash == -624584435 or modelHash == 1938225476 then
                            newPed = CreatePed(3, 1885233650,Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z, 0.72, false, false)
                        else
                        newPed = CreatePed(3, modelHash,Login.spawnLoc[_].x, Login.spawnLoc[_].y, Login.spawnLoc[_].z, 0.72, false, false)
                        TaskPlayAnim(newPed, "timetable@ron@ig_3_couch", "base", 1.0,-2.0, -1, 1, 1, true, true, true)
                        end
                    end

                    
                    
                    
                    if newPed == nil then
                        goto skip_to_next
                    end

                    SetEntityHeading(newPed, Login.spawnLoc[_].w)
                    if character ~= nil and characterModelData[cid] ~= nil and characterModelData[cid] ~= {} and not isCustom then
                        Login.LoadPed(newPed, characterModelData[cid], modelHash)
                    end

                    if not isCustom then
                        if modelHash == GetHashKey("mp_f_freemode_01") or modelHash == GetHashKey("mp_m_freemode_01") then
                            if character ~= nil then
                                -- SetEntityAlpha(newPed,200,false)
                            else
                                SetEntityAlpha(newPed,0.9,false)
                            end
                     end
                    end

                    TaskLookAtCoord(newPed, vector3(-197.75,-1002.46,28.15 ),-1, 0, 2)
                    FreezeEntityPosition(newPed, true)
                    SetEntityInvincible(newPed, true)
                    SetBlockingOfNonTemporaryEvents(newPed, true)

                    Login.currentProtected[newPed] = true

                    if character ~= nil then
                        Login.CreatedPeds[_] = {
                            pedObject = newPed,
                            charId = cid,
                            posId = _
                        }
                    else
                        Login.CreatedPeds[_] = {
                            pedObject = newPed,
                            charId = 0,
                            posId = _
                        }
                    end

                    ::skip_to_next::
                end
            end)
        end


        Wait(600)
        SetNuiFocus(true, true)
        SendNUIMessage({
            open = true,
           chars = data
        })
		
		--If no characters, open Creation menu
        if noCharacters then
            SendNUIMessage({ firstOpen = true })
        end
    end)

    Login.actionsBlocked = false
end

RegisterNetEvent("login:CreatePlayerCharacterPeds")
AddEventHandler("login:CreatePlayerCharacterPeds", Login.CreatePlayerCharacterPeds)


--[[
    Functions below: base attachment
    Description: dealing with comet-base functionality in order to set/get the correct information for chars
]]



function Login.getCharacters(isReset)
    -- local events = exports["comet-base"]:getModule("Events")
    
    if not isReset then
        TransitionFromBlurred(500)
        Events:Trigger("comet-base:loginPlayer", nil, function(data)
            if type(data) == "table" and data.err then
                return
            end
        end)
    end

    Events:Trigger("comet-base:fetchPlayerCharacters", nil, function(data)
        if data.err then
            -- print"Found error in getting player Char")
            return
        end

        local charIds = {}

        for k,v in ipairs(data) do
            charIds[#charIds + 1] = v.id
        end

        TriggerServerEvent("login:getCharModels", charIds, isReset)
    end)
end

function Login.SelectedChar(data)

	Login.ClearSpawnedPeds()
	TriggerEvent("character:PlayerSelectedCharacter")
	-- local events = exports["comet-base"]:getModule("Events")
	Events:Trigger("comet-base:selectCharacter", data.actionData, function(returnData)
       
        if not returnData.loggedin or not returnData.chardata then sendMessage({err = {err = true, msg = "There was a problem logging in as that character, if the problem persists, contact an administrator <br/> Cid: " .. tostring(data.selectcharacter)}}) return end

        -- local LocalPlayer = exports["comet-base"]:getModule("LocalPlayer")
        LocalPlayer:setCurrentCharacter(returnData.chardata)
        local cid = LocalPlayer:getCurrentCharacter().id
        TriggerEvent('updatecid', cid)
       	
        if Login.CurrentClothing[data.actionData] == nil then
        	Login.setClothingForChar()
        else
            deleteTrain()
	        SetPlayerInvincible(PlayerPedId(), true)
	        TriggerEvent("comet-base:firstSpawn")
            TriggerServerEvent("asset_portals:get:coords")
            TriggerServerEvent('comet-scoreboard:AddPlayer')
            TriggerServerEvent('comet-admin:AddPlayer')
            TriggerServerEvent("police:getAnimData")
            TriggerServerEvent("police:getEmoteData")
            TriggerServerEvent("police:getMeta")
            TriggerServerEvent("comet-weapons:getAmmo")
            TriggerServerEvent("trucker:returnCurrentJobs")
            TriggerEvent("reviveFunction")
            TriggerServerEvent("kGetWeather")
            exports.spawnmanager:setAutoSpawn(false)
	    end
    end)
end

function Login.setClothingForChar()
    Login.actionsBlocked = true

    SendNUIMessage({
      close = true
    })
    SetEntityVisible(PlayerPedId(), true)
    TriggerEvent("ez:afk:update", true)
    SetEntityHeading(PlayerPedId(),64.71)
    SetGameplayCamRelativeHeading(180.0)
    SetGameplayCamRelativePitch(1.0, 1.0)

    Wait(800)

    Login.Open = false
    -- local LocalPlayer = exports["comet-base"]:getModule("LocalPlayer")
    local gender = LocalPlayer:getCurrentCharacter().gender

    if gender ~= 0 then
        SetSkin(GetHashKey("mp_f_freemode_01"), true)
    else
        SetSkin(GetHashKey("mp_m_freemode_01"), true)
    end
    TriggerEvent("ez:afk:update", false)
    TriggerEvent("comet-clothing:Spawning", false)
    ChoosingClothes = true
    Citizen.Wait(500)
    DoScreenFadeOut(100)
    spawnChar()
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    EnableAllControlActions(0)
    Login.DeleteCamera()
    TriggerEvent("comet-base:playerSpawned")
    TriggerServerEvent("character:loadspawns", exports["isPed"]:isPed("cid"), true)
    SetPlayerInvincible(PlayerId(), false)
    Citizen.Wait(500)
    TriggerServerEvent("comet-multi:licenses")
    Citizen.Wait(5000)
    TriggerEvent("comet-clothing:openClothing")
    TriggerEvent("comet-clothing:inSpawn", true)
    SetEntityHeading(PlayerPedId(),144.70988464355)
    
    SetGameplayCamRelativeHeading(180.0)

    SetGameplayCamRelativePitch(8.0, 3.0)
end

function backToMenu()
    Login.actionsBlocked = false
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
	Login.nativeStart(true)
end

function spawnChar()
    Login.actionsBlocked = false
    deleteTrain()

    SetPlayerInvincible(PlayerPedId(), true)
    TriggerServerEvent("asset_portals:get:coords")
    TriggerServerEvent('comet-scoreboard:AddPlayer')
    TriggerServerEvent('comet-admin:AddPlayer')
    TriggerServerEvent("police:getAnimData")
    TriggerServerEvent("police:getEmoteData")
    TriggerServerEvent("police:getMeta")
    TriggerServerEvent("comet-weapons:getAmmo")
    TriggerServerEvent("trucker:returnCurrentJobs")
    TriggerEvent("reviveFunction")
    TriggerServerEvent("kGetWeather")
    exports.spawnmanager:setAutoSpawn(false)

    SendNUIMessage({
        default = true
    })

    Login.Selected = false
    Login.CurrentPedInfo = nil
    Login.CurrentPed = nil
    Login.CreatedPeds = {}
end


RegisterNetEvent("character:finishedLoadingChar")
AddEventHandler("character:finishedLoadingChar", function()
    Login.characterLoaded()
end)

RegisterNetEvent("spawn:destroycams")
AddEventHandler("spawn:destroycams", function()
    DestroyAllCams(true)
    SetCamActive(LoginSafe.Cam, false)
    -- print("Bye")
end)

RegisterNetEvent("comet-multi:finishedClothing")
AddEventHandler("comet-multi:finishedClothing", function(endType)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local pos = vector3(-3965.88,2014.55, 501.6)
    local distance = #(playerCoords - pos)

    -- TriggerEvent("comet-clothing:inSpawn", false)

    if ChoosingClothes then
        ChoosingClothes = false
        SetEntityVisible(PlayerPedId(), false)
    	if endType == "Finished" then
            TriggerEvent("ez:afk:update", false)
            TriggerEvent("comet-clothing:Spawning", false)
            SetEntityVisible(PlayerPedId(), true)
            FreezeEntityPosition(PlayerPedId(), false)
            SetNuiFocus(false, false)
            EnableAllControlActions(0)
            Login.DeleteCamera()
            SetPlayerInvincible(PlayerId(), false)
            Citizen.Wait(500)

    	else
    		backToMenu()
    	end
    end	
end)