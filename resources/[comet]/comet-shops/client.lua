local methlocation = { ['x'] = 1763.75,['y'] = 2499.44,['z'] = 50.43,['h'] = 213.58, ['info'] = ' cell1' }
------------------------------
--FONCTIONS
-------------------------------

local tool_shops = {
	{ ['x'] = 44.838947296143, ['y'] = -1748.5364990234, ['z'] = 29.549386978149 },
	{ ['x'] = 2749.2309570313, ['y'] = 3472.3308105469, ['z'] = 55.679393768311 },
}

local twentyfourseven_shops = {
	{ ['x'] = 25.925277709961, ['y'] = -1347.4022216797, ['z'] = 29.482055664062},
    { ['x'] = -48.34285736084, ['y'] = -1757.7890625, ['z'] = 29.414672851562},
    { ['x'] = -707.9208984375, ['y'] = -914.62414550781, ['z'] = 19.20361328125},
    { ['x'] = 1135.6878662109, ['y'] = -981.71868896484, ['z'] = 46.399291992188},
    { ['x'] = -1223.6307373047, ['y'] = -906.76483154297, ['z'] = 12.312133789062},
    { ['x'] = 373.81979370117, ['y'] = 326.0439453125, ['z'] = 103.55383300781},
    { ['x'] = 1163.6439208984, ['y'] = -324.13186645508, ['z'] = 69.197021484375},
    { ['x'] = -2968.298828125, ['y'] = 390.59341430664, ['z'] = 15.041748046875},
    { ['x'] = -3242.4658203125, ['y'] = 1001.6703491211, ['z'] = 12.817626953125},
    { ['x'] = -1820.7427978516, ['y'] = 792.36926269531, ['z'] = 138.11279296875},
    { ['x'] = 2557.1472167969, ['y'] = 382.12747192383,['z'] = 108.60876464844},
    { ['x'] = 2678.8879394531, ['y'] = 3280.3911132812, ['z'] = 55.228515625},
    { ['x'] = 1961.5648193359, ['y'] = 3740.6901855469, ['z'] = 32.329711914062},
    { ['x'] = 1392.3824462891, ['y'] = 3604.5495605469, ['z'] = 34.97509765625},
    { ['x'] = 1698.158203125, ['y'] = 4924.404296875, ['z'] = 42.052001953125},
    { ['x'] = 1728.9230957031, ['y'] = 6414.3823242188, ['z'] = 35.025634765625},
    { ['x'] = 1166.4000244141, ['y'] = 2709.1647949219, ['z'] = 38.142822265625},
    { ['x'] = 547.49011230469, ['y'] = 2671.2131347656, ['z'] = 42.153076171875},
    --{ ['x'] = 460.9186706543,['y'] = -982.31207275391, ['z'] = 30.678344726562},
    --{ ['x'] = 448.23297119141, ['y'] = -973.95166015625, ['z'] = 34.958251953125},
    { ['x'] = 1841.3670654297, ['y'] = 2591.2878417969,['z'] = 46.01171875},
}

local weashop_locations = {
	{entering = {811.973572,-2155.33862,28.8189938}, inside = {811.973572,-2155.33862,28.8189938}, outside = {811.973572,-2155.33862,28.8189938},delay = 900},
	{entering = { 1692.54, 3758.13, 34.71}, inside = { 1692.54, 3758.13, 34.71}, outside = { 1692.54, 3758.13, 34.71},delay = 600},
	{entering = {252.915,-48.186,69.941}, inside = {252.915,-48.186,69.941}, outside = {252.915,-48.186,69.941},delay = 600},
	{entering = {844.352,-1033.517,28.094}, inside = {844.352,-1033.517,28.194}, outside = {844.352,-1033.517,28.194},delay = 780},
	{entering = {-331.487,6082.348,31.354}, inside = {-331.487,6082.348,31.454}, outside = {-331.487,6082.348,31.454},delay = 600},
	{entering = {-664.268,-935.479,21.729}, inside = {-664.268,-935.479,21.829}, outside = {-664.268,-935.479,21.829},delay = 600},
	{entering = {-1305.427,-392.428,36.595}, inside = {-1305.427,-392.428,36.695}, outside = {-1305.427,-392.428,36.695},delay = 600},
	{entering = {-1119.1, 2696.92, 18.56}, inside = {-1119.1, 2696.92, 18.56}, outside = {-1119.1, 2696.92, 18.56},delay = 600},
	{entering = {2569.978,294.472,108.634}, inside = {2569.978,294.472,108.734}, outside = {2569.978,294.472,108.734},delay = 800},
	{entering = {-3172.584,1085.858,20.738}, inside = {-3172.584,1085.858,20.838}, outside = {-3172.584,1085.858,20.838},delay = 600},
	{entering = {20.0430,-1106.469,29.697}, inside = {20.0430,-1106.469,29.797}, outside = {20.0430,-1106.469,29.797},delay = 600},
}


local weashop_blips = {}

CreateThread(function()

	for station,pos in pairs(weashop_locations) do
		local loc = pos
		pos = pos.entering
		local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
		-- 60 58 137
		SetBlipSprite(blip,110)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 17)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Ammunation')
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip,true)
		SetBlipAsMissionCreatorBlip(blip,true)
		weashop_blips[#weashop_blips+1]= {blip = blip, pos = loc}
	end

	for k,v in ipairs(twentyfourseven_shops)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Shop")
		EndTextCommandSetBlipName(blip)
	end

	for k,v in ipairs(tool_shops)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tool Shop")
		EndTextCommandSetBlipName(blip)
	end	

end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('shop:general')
AddEventHandler('shop:general', function()
	TriggerEvent("server-inventory-open", "2", "Shop")
	Wait(1000)
end)
RegisterNetEvent('produceshop:general')
AddEventHandler('produceshop:general', function()
	TriggerEvent("server-inventory-open", "12", "Shop")
	Wait(1000)
end)

RegisterNetEvent('weed:store')
AddEventHandler('weed:store', function()
	TriggerEvent("server-inventory-open", "714", "Shop")
	Wait(1000)
end)


RegisterNetEvent('police:general')
AddEventHandler('police:general', function()
	local job = exports["comet-base"]:isPed("myJob")
	if (job == "police") then
		TriggerEvent("server-inventory-open", "10", "Shop");	
		Wait(1000)
	else
	end
end)

RegisterNetEvent('toolshop:general')
AddEventHandler('toolshop:general', function()
	TriggerEvent("server-inventory-open", "4", "Shop");	
	Wait(1000)
end)

RegisterNetEvent('parachute:general')
AddEventHandler('parachute:general', function()
	TriggerEvent("server-inventory-open", "0412", "Shop");	
	Wait(1000)
end)

RegisterNetEvent('evidence:general')
AddEventHandler('evidence:general', function()
	local job = exports["comet-base"]:isPed("myJob")
	if (job == "police") then
		TriggerEvent("server-inventory-open", "1", "trash-1")
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
		Wait(1000)
	else
	end
end)

RegisterNetEvent('personallocker:general')
AddEventHandler('personallocker:general', function()
	local cid = exports["comet-base"]:isPed("cid")
	local job = exports["comet-base"]:isPed("myJob")
	if (job == "police") then
		TriggerEvent("server-inventory-open", "1", "personalMRPD-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
		Wait(1000)
	else
	end
end)

RegisterNetEvent('personallocker2:general')
AddEventHandler('personallocker2:general', function()
	local cid = exports["comet-base"]:isPed("cid")
	local job = exports["comet-base"]:isPed("myJob")
	if (job == "police") then
		TriggerEvent("server-inventory-open", "1", "personalSandy-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
		Wait(1000)
	else
	end
end)

RegisterNetEvent('personallocker3:general')
AddEventHandler('personallocker3:general', function()
	local cid = exports["comet-base"]:isPed("cid")
	local job = exports["comet-base"]:isPed("myJob")
	if (job == "police") then
		TriggerEvent("server-inventory-open", "1", "personalPaleto-"..cid)
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
		Wait(1000)
	else
	end
end)

RegisterNetEvent('emslocker:general')
AddEventHandler('emslocker:general', function()
    local cid = exports["comet-base"]:isPed("cid")
    local job = exports["comet-base"]:isPed("myJob")
    if (job == "ems") then
        TriggerEvent("server-inventory-open", "1", "personalEMS-"..cid)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'LockerOpen', 0.4)
        Wait(1000)
    else
    end
end)

RegisterNetEvent("comet-stores:redCounter")
AddEventHandler("comet-stores:redCounter", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_counter");
end)

RegisterNetEvent("comet-stores:redCounter2")
AddEventHandler("comet-stores:redCounter2", function()
    TriggerEvent("server-inventory-open", "1", "redcircle_counter2");
end)

RegisterNetEvent('weapon:general')
AddEventHandler('weapon:general', function()
	TriggerServerEvent('comet-stores:WeaponShopStatus')
end)

RegisterNetEvent('huntingbuy:general')
AddEventHandler('huntingbuy:general', function()
	TriggerEvent("server-inventory-open", "209", "Shop");
	Wait(1000)
end)

RegisterNetEvent('weedshop:counter1')
AddEventHandler('weedshop:counter1', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter1");
end)

RegisterNetEvent('weedshop:counter2')
AddEventHandler('weedshop:counter2', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter2");
end)

RegisterNetEvent('weedshop:counter3')
AddEventHandler('weedshop:counter3', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter3");
end)

RegisterNetEvent('weedshop:counter4')
AddEventHandler('weedshop:counter4', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter4");
end)

RegisterNetEvent('weedshop:counter5')
AddEventHandler('weedshop:counter5', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter5");
end)

RegisterNetEvent('weedshop:counter6')
AddEventHandler('weedshop:counter6', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter6");
end)

RegisterNetEvent('weedshop:counter7')
AddEventHandler('weedshop:counter7', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter7");
end)

RegisterNetEvent('weedshop:counter8')
AddEventHandler('weedshop:counter8', function()
    TriggerEvent("server-inventory-open", "1", "cosmic_counter8");
end)

RegisterNetEvent('weedshop:general')
AddEventHandler('weedshop:general', function()
	local jobs = exports["comet-base"]:GroupRank('cosmic_cannabis')
	if jobs > 0 then 
		TriggerEvent("server-inventory-open", "204", "Shop");	
		Wait(1000)
	end
end)

RegisterNetEvent('weedshop:counterStash')
AddEventHandler('weedshop:counterStash', function()
	local jobs = exports["comet-base"]:GroupRank('cosmic_cannabis')
	if jobs > 0 then 
		TriggerEvent("server-inventory-open", "1", "cosmic_counterStash");
	end
end)

RegisterNetEvent('courthouse:idbuy')
AddEventHandler('courthouse:idbuy', function()
	TriggerServerEvent('shops:GetIDCardSV')
	Wait(1000)
end)

RegisterNetEvent('familystorage:general')
AddEventHandler('familystorage:general', function()
	local jobs = exports["comet-base"]:GroupRank('drift_school')
	if jobs >= 1 then
		TriggerEvent("server-inventory-open", "1", "familystorage:general")
		Wait(1000)
	end
end)

RegisterNetEvent('shops:water')
AddEventHandler('shops:water', function()
	TriggerEvent("server-inventory-open", "421", "Shop");	
	Wait(1000)
end)

RegisterNetEvent('shops:food')
AddEventHandler('shops:food', function()
	TriggerEvent("server-inventory-open", "4242", "Shop");	
	Wait(1000)
end)

RegisterNetEvent('shops:digitalden')
AddEventHandler('shops:digitalden', function()
	TriggerEvent("server-inventory-open", "1312", "Shop");	
	Wait(1000)
end)

RegisterNetEvent('shops:coffee')
AddEventHandler('shops:coffee', function()
	TriggerEvent("server-inventory-open", "422", "Shop");
	Wait(1000)
end)

RegisterNetEvent('shops:soda')
AddEventHandler('shops:soda', function()
	TriggerEvent("server-inventory-open", "4292", "Shop");
	Wait(1000)
end)

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


-- CreateThread(function()
--     while true do
--         SetDiscordAppId(1101496293211259032)
--         SetDiscordRichPresenceAsset('logo')
--         SetDiscordRichPresenceAssetText('Real Dreams')
--         SetRichPresence('Players: More Then Yours')

--         Wait(60000)
--     end
-- end)
