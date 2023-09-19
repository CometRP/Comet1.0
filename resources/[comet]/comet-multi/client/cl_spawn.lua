LoginSafe = {}
Login.CreatedPeds = {}
Login.CurrentPed = nil
Login.CurrentPedInfo = nil
Login.Hiding = false
Login.Open = false
LoginSafe.Cam = nil
Login.Selected = false
Login.CurrentClothing = {}
Login.HasTransistionFinished = true
Login.LoadFinished = true
Login.isTrainMoving = false
Login.currentProtected = {}
Login.finished = true
Login.custompeds = {}

Login.actionsBlocked = false

local vehicle = nil
local vehicleBack = nil

Login.Emotes = {
	[1] = 166523388,
	[2] = 354512356,
	[3] = -653113914,
	[4] = -822629770,
	[5] = -339257980,
}

Login.spawnLoc = {
	[1] = vector4(-1082.6829833984, -249.57432556152, 43.021297454834, 288.80969238281),
	[2] = vector4 (-1083.1560058594, -248.65216064453, 43.021297454834, 300.84490966797),
	[3] = vector4(-1083.5137939453, -247.7400970459, 43.021297454834, 297.24487304688),
	[4] = vector4 (-1082.4169921875, -246.79808044434, 43.021297454834, 229.93260192871),
	[5] = vector4(-1081.9797363281, -246.3455657959, 43.021297454834, 176.88397216797),
}

function Login.Init()
	CreateThread(function()

		Login.HidePlayer(true)
		TriggerEvent("inSpawn",true)
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-1077.7121582031, -248.65330505371, 46.055854797363), false, false, false, false)
		FreezeEntityPosition(PlayerPedId(), true)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			Wait(0)
		end

		Login.SetCharacterLoginCam()
		Wait(500)
		TriggerEvent("loading:disableLoading")
		Login.ShowMenu(true)

		
		SetEntityCoordsNoOffset(PlayerPedId(), vector3(-1077.7121582031, -248.65330505371, 46.055854797363), false, false, false, false)
	end)
end

function Login.HidePlayer(toggle)

	CreateThread(function()
		local ped = PlayerPedId()

		while not ped do
			Wait(0)
			ped = PlayerPedId()
		end
	end)

end

function Login.ShowMenu(toggle)
	Login.Open = toggle == nil and not Login.open or toggle

	if Login.Open then
		SendNUIMessage({
			showAnim = true
		})
		return
	end

	SendNUIMessage({
		close = true
	})
	SetNuiFocus(false, false)

end


function Login.SetCharacterLoginCam()
	LoginSafe.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local camCoords = {-1077.7121582031, -248.65330505371, 46.055854797363 }
	SetEntityCoordsNoOffset(PlayerPedId(), vector3(-1077.7121582031, -248.65330505371, 46.055854797363), false, false, false, false)
	SetCamRot(LoginSafe.Cam, -14.0, 0.0, 80.764556884766, 2)
	SetCamCoord(LoginSafe.Cam, camCoords[1], camCoords[2], camCoords[3])
	StopCamShaking(LoginSafe.Cam, true)
	SetCamFov(LoginSafe.Cam, 55.75)
	SetCamActive(LoginSafe.Cam, true)
	RenderScriptCams(true, false, 0, true, true)
end


function Login.nativeStart(AlreadySpawned)
	isNear = true
	ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)

	if not AlreadySpawned then
		tatCategory = exports["comet-clothing"]:GetTatCategs()
		tattooHashList = exports["comet-clothing"]:GetTatCategs()
		Login.custompeds = exports["comet-clothing"]:GetCustomSkins()

		--Prevent blur from getting stuck
		while IsScreenblurFadeRunning() do
			Wait(0)
		end
		TransitionFromBlurred(1)

		Login.Init()
		Login.getCharacters(false)

		CreateThread(function()
			while Login.LoadFinished do
		        Wait(10)
		    end
		    TriggerScreenblurFadeOut(1)

		    spawnTrain()
		    Wait(2000)
		    SendNUIMessage({
				startAnim = true
			})
		end)
		
	else
		Login.SetCharacterLoginCam()
		Login.getCharacters(true)
	end
	
end

RegisterNetEvent("character:PlayerSelectedCharacter")
AddEventHandler("character:PlayerSelectedCharacter", function(charId)
	SendNUIMessage({
		close = true
	})
	Login.HidePlayer(false)
end)

function Login.NUICallback(data)

	if Login.actionsBlocked and data.action ~= "proceed" then return end

	if data.action == "selectCharacter" then
       Login.SelectedChar(data)
	end

	if data.action == "proceed" then
		Login.HasTransistionFinished = false
	end

	if data.action == "currentHover" then
		local offset = vector2(data.x,data.y)
		local coords = Util:ScreenRelToWorld(GetCamCoord(LoginSafe.Cam), GetCamRot(LoginSafe.Cam,2),offset)
	    local pedCaught = LocationInWorld(coords,LoginSafe.Cam)
	    local pedData = findCharPed(pedCaught,true)

		SendNUIMessage({
			update = true,
			currentSelect = pedData,
			fadeHover = true
		})
	end

	if data.action == "singleClick" or data.action == "doubleClick" then
	    local offset = vector2(data.x,data.y)
	    local coords = Util:ScreenRelToWorld(GetCamCoord(LoginSafe.Cam), GetCamRot(LoginSafe.Cam,2),offset)
	    local pedCaught = LocationInWorld(coords,LoginSafe.Cam)
	   	local pedData = nil
	    if data.safe then
		    pedData = findCharPed(pedCaught,false)

		    if pedData == nil then
		    	Login.Selected = false 
		    else
		    	Login.Selected = true
		    end

		    SendNUIMessage({
				update = true,
				currentSelect = pedData,
				fadeHover = false,
				forceHover = true
			})
		end


	    if pedData ~= nil then

		    if data.action == "doubleClick" then
	    		if pedData.charId == 0 then
	    			SendNUIMessage({
						newChar = true
					})
	    		else
					local construct = {
						actionData = pedData.charId
					}
		    		Login.SelectedChar(construct)
		    	end
		    end
		end
	end
	

	if data.action == "deleteCharacter" then
		Login.actionsBlocked = true
		local events = exports["comet-base"]:FetchComponent("Events")
		events:Trigger("comet-base:deleteCharacter", data.actionData, function(deleted)
            Login.getCharacters(true)
        end)
	end

	if data.action == "newCharacter" then
		Login.actionsBlocked = true
		local cData = data.actionData
		local events = exports["comet-base"]:FetchComponent("Events")
		local gender = 0 
		if cData.gender == "F" then gender = 1 end
		local chardata = {
			firstname = cData.first_name,
			lastname = cData.last_name,
			dob = cData.dob,
			gender = gender,
			story = "Default story - new char system"
		}
		
        if not chardata then return end

		events:Trigger("comet-base:createCharacter", chardata, function(created)
            if not created then
				TriggerEvent("cl_SendNotify","There was an error while creating your character, value returned nil or false. Contact an administrator if this persists.",2) 
				Login.CreatePlayerCharacterPeds(Login.CurrentClothing,true)
                return
            end

			if type(created) == "table" and created.err then
				TriggerEvent("cl_SendNotify",created.msg,2) 
				Login.CreatePlayerCharacterPeds(Login.CurrentClothing,true)
                return
			end
			
            Login.getCharacters(true)
        end)
	end
	
	if data.action == "refreshCharacters" then
		Login.CreatePlayerCharacterPeds(Login.CurrentClothing, true)
	end

	if data.action == "favorite" then
		local fav = data.actionData
		exports["storage"]:set(fav,"npfavorite")
	end

	if data.action == "spawnLocation" then
		local spawnInfo = data.actionData
		Spawn.selectedSpawn(spawnInfo)
	end
end

RegisterNUICallback("nuiCallback", Login.NUICallback)

--[[
	Functions below: cleanup 
	Description: functions that deal with cleaning up peds/cams
]]

function Login.ClearSpawnedPeds()
    for _, spawnedPed in ipairs(Login.CreatedPeds) do
        DeletePed(spawnedPed.pedObject)
        SetNuiFocus(false, false)
    end
end


function Login.DeleteCamera()
    ClearFocus()
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1, true, true)
    SetNuiFocus(false, false)
end

--[[
	Functions below: native handlers 
	Description: managing outcomes for native handlers 
]]


AddEventHandler("onResourceStop", function()
	Login.ClearSpawnedPeds()
end)

RegisterNetEvent("comet-base:spawnInitialized")
AddEventHandler("comet-base:spawnInitialized", function()
	TriggerServerEvent("commands:reset:login")
	TriggerServerEvent("comet-base:clearStates")
	Login.nativeStart()
end)

RegisterNetEvent("comet-base:relog")
AddEventHandler("comet-base:relog", function(type)
	TriggerServerEvent("commands:reset:login")
	TriggerServerEvent("comet-base:clearStates")
	if type == "motel" then
		Login.nativeStart()
	end
end)

--[[
	Functions below: Trains 
	Description: Spawning and moving of the train for spawn and the deletion of the trains.
]]


function spawnTrain()

	local tempmodel = GetHashKey("metrotrain")
	RequestModel(tempmodel)
	while not HasModelLoaded(tempmodel) do
		RequestModel(tempmodel)
		Citizen.Wait(0)
	end

	

    local coords = vector3(-3948.49,2036.35,499.1)
    vehicle = CreateVehicle(tempmodel, coords, 160.0, false, false)
    FreezeEntityPosition(vehicle, true)
     
    local heading = GetEntityHeading(vehicle)
    local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -11.0, 0.0)

    vehicleBack = CreateVehicle(tempmodel, coords, 158.0, false, false)
    FreezeEntityPosition(vehicleBack, true)
    AttachEntityToEntity(vehicleBack , vehicle , 51 , 0.0, -11.0, 0.0, 180.0, 180.0, 0.0, false, false, false, false, 0, true)

    Citizen.CreateThread(function()
    	Login.isTrainMoving = true
	    for i=1,100 do
	    	local posoffset = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 0.0)
	    	local setpos = VecLerp(-3948.49,2036.35,499.1, -3957.58,2008.75, 499.1, i/100, true)
	    	SetEntityCoords(vehicle,setpos)
	  		Wait(15)
	    end
	    Login.isTrainMoving = false
	end)
end

function deleteTrain()
	if vehicle ~= nil then
		DeleteEntity(vehicle)
		DeleteEntity(vehicleBack)
	end
end

