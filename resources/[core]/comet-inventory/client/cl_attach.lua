-- types, 1 = gun, 2 = contraband, 3 melee weapons, 4 katana for sheath

-- print(`weapon_assaultrifle`)
function generalInventory()
    -- local dead = exports["isPed"]:isPed("dead")
    -- if not insidePrompt and not inventoryDisabled and not focusTaken and not dead and not promptCurrent then
    --     TriggerEvent("inventory-open-request")
    -- end
    if not insidePrompt and not inventoryDisabled and not focusTaken and not promptCurrent then
        TriggerEvent("inventory-open-request")
    end
end
  
function generalEscapeMenu()
    if guiEnabled and not focusTaken then
        closeGuiFail()
    end
end

Citizen.CreateThread(function()
    RegisterCommand('+generalInventory', generalInventory, false)
    RegisterCommand('-generalInventory', function() end, false)
	exports["jay-interactions"]:AddKeyMapping("Inventory", "+generalInventory", "-generalInventory", "Open", "keyboard", "TAB")

    RegisterCommand('+generalEscapeMenu', generalEscapeMenu, false)
    RegisterCommand('-generalEscapeMenu', function() end, false)
	exports["jay-interactions"]:AddKeyMapping("Player", "+generalEscapeMenu", "-generalEscapeMenu", "Escape Menu", "keyboard", "ESCAPE")
end)

RegisterCommand("ak", function(s,args)

	TriggerEvent( "player:receiveItem", "-1074790547", 1 )
-- 	TriggerEvent( "player:receiveItem", args[1], args[2] )
end)


local ag = {}
local ad = {}
local am = {}
local ab = {}
local gunLimit = 4
local drugLimit = 5
local meleeLimit = 4
local disabled = false -- is only temp disable for clothing etc to prevent items everywhere

local w = {
	[1] = { ["type"] = 1, "AK47", ["id"] = "-1074790547", ["model"] = 'w_ar_assaultrifle', ["z"] = 0.0, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
	[2] = { ["type"] = 1, "PD 556", ["id"] = "-2084633992", ["model"] = 'w_ar_carbinerifle', ["z"] = 0.1, ["rx"] = 0.0, ["ry"] = 0.0, ["rz"] = 0.0 },
}

RegisterNetEvent("attachedItems:block")
AddEventHandler("attachedItems:block", function(status)
	disabled = status
	if status then
		DeleteAttached()
	else
		TriggerEvent("AttachWeapons")
	end
end)

RegisterNetEvent("AttachWeapons")
AddEventHandler("AttachWeapons", function()
	if disabled then
		return
	end
	local ped = PlayerPedId()
	local num, curw = GetCurrentPedWeapon(ped, false)
	local sheathed = false
	DeleteAttached()
	for i = 1, #w do
		if exports["comet-inventory"]:getQuantity(w[i]["id"]) > 0 then
			local mdl = GetHashKey(w[i]["model"])
			loadmodel(mdl)
			if w[i]["type"] == 1 and #ag < gunLimit and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24818)
				ag[#ag+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ag[#ag], ped, bone, w[i]["z"], -0.155, 0.21 - (#ag/10), w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 2 and #ad < drugLimit and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817)
				ad[#ad+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ad[#ad], ped, bone, w[i]["z"]-0.1, -0.11, 0.24 - (#ad/10), w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 3 and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817)
				am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				-- melee weapons will be placed in specific spots pending on type here, sort of aids but we can have infinite really if they all have a belt spot or w./e
				-- also our item id is not the correct hash, so it fucks up atm. :)
				if w[i]["id"] == "3713923289" and curw ~= -581044007 then
					AttachEntityToEntity(am[#am], ped, bone, w[i]["z"]-0.4, -0.135, -0.15, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
				end
			elseif w[i]["type"] == 4 and not sheathed then
				sheathed = true
				local bone = GetPedBoneIndex(ped, 24817)
				am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(am[#am], ped, bone, w[i]["z"]-0.4, (w[i]["x"] or 0.0)-0.135, 0.0, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 5 and curw ~= tonumber(w[i]["id"]) then
				am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				local bone = GetPedBoneIndex(ped, 28422)
				AttachEntityToEntity(am[#am], ped, bone, 0.05, 0.01, -0.01, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			elseif w[i]["type"] == 6 and curw ~= tonumber(w[i]["id"]) then
				local bone = GetPedBoneIndex(ped, 24817)
				ab[#ab+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
				AttachEntityToEntity(ab[#ab], ped, bone, w[i]["z"]-0.7, -0.02, 0.0, w[i]["rx"], w[i]["ry"], w[i]["rz"], 0, 1, 0, 1, 0, 1)
			end
		end
	end
end)

function loadmodel(mdl)
	RequestModel(mdl)
	local rst = 0
	while not HasModelLoaded(mdl) and rst < 10 do
		Citizen.Wait(100)
		rst = rst + 1
	end
end

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	DeleteAttached()
end)

function DeleteAttached()
	for i = 1, #ag do
		DeleteEntity(ag[i])
	end
	for i = 1, #ad do
		DeleteEntity(ad[i])
	end	
	for i = 1, #am do
		DeleteEntity(am[i])
	end	
	for i = 1, #ab do
		DeleteEntity(ab[i])
	end	
	ag = {}
	ad = {}
	am = {}
	ab = {}
end

exports('GetAttachedBag', function()
	return ab[1] and ab[1] or 0
end)

RegisterNetEvent('reloadprops', function(invehicle)
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

RegisterCommand('reloadprops', function()
    TriggerEvent("reloadprops")
end)