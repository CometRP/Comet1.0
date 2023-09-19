Keybinds, Callback = nil, nil

RegisterNetEvent("comet-base:refreshComponents", function()
    exports['comet-base']:LoadComponents({
        "Keybinds",
        "Callback",
    }, function(pass)
        if not pass then return end
        Keybinds = exports['comet-base']:FetchComponent("Keybinds")
        Callback = exports['comet-base']:FetchComponent("Callback")
    end)
end)



local fixingvehicle = false
local justUsed = false
local retardCounter = 0
local lastCounter = 0 
local HeadBone = 0x796e;

local validWaterItem = {
    ["oxygentank"] = true,
    ["water"] = true,
    ["vodka"] = true,
    ["beer"] = true,
    ["whiskey"] = true,
    ["coffee"] = true,
    ["bscoffee"] = true,
    ["frappuccino"] = true,
    ["fishtaco"] = true,
    ["taco"] = true,
    ["burrito"] = true,
    ["churro"] = true,
    ["hotdog"] = true,
    ["greencow"] = true,
    ["donut"] = true,
    ["eggsbacon"] = true,
    ["icecream"] = true,
    ["mshake"] = true,
    ["sandwich"] = true,
    ["hamburger"] = true,
    ["cola"] = true,
    ["sprunk"] = true,
    ["jailfood"] = true,
    ["bleederburger"] = true,
    ["heartstopper"] = true,
    ["torpedo"] = true,
    ["meatfree"] = true,
    ["moneyshot"] = true,
    ["fries"] = true,
    ["slushy"] = true,
    ["softdrink"] = true,
    ["ramen"] = true,
    ["muffin"] = true,
    ["maccheese"] = true,
}

RegisterNetEvent('RunUseItem')
AddEventHandler('RunUseItem', function(itemid, slot, inventoryName, isWeapon)
    if itemid == nil then
        return
    end
    local player = PlayerPedId()
    local ItemInfo = GetItemInfo(slot)
    print(ItemInfo)
    print(ItemInfo.quality)
    local currentVehicle = GetVehiclePedIsUsing(player)
    LastUsedItem = ItemInfo.id
    LastUsedItemId = itemid
    if ItemInfo.quality == nil then return end
    if ItemInfo.quality < 1 then
        TriggerEvent("cl_SendNotify","Item is too worn.",2)
        if isWeapon then
            TriggerEvent("brokenWeapon")
        end
        return
    end

    if (isWeapon) then
        if tonumber(ItemInfo.quality) > 0 then
            TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
        end
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        Wait(1500)
        TriggerEvent("AttachWeapons")
        return
    end
    -- if (isWeapon) then
    --     TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
    --     justUsed = false
    --     retardCounter = 0
    --     lastCounter = 0
    --     return
    -- end



    TriggerEvent("hud-display-item",itemid,"Used")

    Wait(800)

    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)

    if (not IsPedInAnyVehicle(player)) then
        if (itemid == "Suitcase") then
            TriggerEvent('attach:suitcase')
        end

        if (itemid == "Boombox") then
                TriggerEvent('attach:boombox')
        end
        if (itemid == "Box") then
                TriggerEvent('attach:box')
        end
        if (itemid == "DuffelBag") then
                TriggerEvent('attach:blackDuffelBag')
        end
        if (itemid == "MedicalBag") then
                TriggerEvent('attach:medicalBag')
        end
        if (itemid == "SecurityCase") then
                TriggerEvent('attach:securityCase')
        end
        if (itemid == "Toolbox") then
                TriggerEvent('attach:toolbox')
        end
    end

    local remove = false
    local itemreturn = false
    local drugitem = false
    local fooditem = false
    local drinkitem = false
    local healitem = false

    if (itemid == "joint" or itemid == "weed5oz" or itemid == "weedq" or itemid == "beer" or itemid == "vodka" or itemid == "whiskey" or itemid == "lsdtab") then
        drugitem = true
    end

    if (itemid == "spikes") then
        TriggerEvent('cl_setSpike')
        remove = true
    end

    if (itemid == "wtint") then
        TriggerEvent('cl_checkTint')
        -- remove = true
    end

    if (itemid == "fakeplate") then
      TriggerEvent("fakeplate:change")
    end

    if (itemid == "boostlaptop") then
        TriggerEvent("boosting:DisplayUI")
    end
    if (itemid == "boostdisabler") then
        TriggerEvent("boosting:DisablerUsed")
    end

    if (itemid == "tuner") then

        local finished = exports['comet-hud']:beginProgress(2,"Connecting Laptop",true)
        if (finished) then
        TriggerEvent("tuner:open")
      end
    end

    if (itemid == "electronickit") then
      TriggerEvent("comet-yacht:electronic")
      
    end
    if (itemid == "locksystem") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if (itemid == "thermite") then
      TriggerEvent("comet-humane:thermite")
      TriggerEvent("comet-humane:thermite2")
      TriggerEvent("comet-humane:thermite3")
      TriggerEvent("comet-humane:thermite4")
      TriggerEvent("comet-humane:thermite5")
      TriggerEvent("comet-humane:thermite6")
      TriggerEvent("fleeca:thermite")
      TriggerEvent('comet-vault:thermiteDoor')
      TriggerEvent("bobcat:thermite")
    end

    if(itemid == "evidencebag") then
        TriggerEvent("evidence:startCollect", itemid, slot)
        local itemInfo = GetItemInfo(slot)
        local data = itemInfo.information
        if data == '{}' then
            TriggerEvent("cl_SendNotify","Start collecting evidence!",1) 
            TriggerEvent("inventory:updateItem", itemid, slot, '{"used": "true"}')
            --
        else
            local dataDecoded = json.decode(data)
            if(dataDecoded.used) then
             --   -- print'YOURE ALREADY COLLECTING EVIDENCE YOU STUPID FUCK')
            end
        end
    end

    if (itemid == "lsdtab" or itemid == "badlsdtab") then
        TriggerEvent("animation:PlayAnimation","pill")
        local finished = exports['comet-hud']:beginProgress(2,"Using LSD",true)
        if (finished) then
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",24,1200)
            TriggerEvent("fx:run", "lsd", 180, nil, (itemid == "badlsdtab" and true or false))
            remove = true
        end
    end

    if (itemid == "decryptersess" or itemid == "decrypterfv2" or itemid == "decrypterenzo") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
        local finished = exports['comet-hud']:beginProgress(25,"Decrypting",true)
        if (finished) then
            TriggerEvent("pixerium:check",3,"request:BankUpdate",true)
          end
      end

      if #(GetEntityCoords(player) - vector3( 2328.94, 2571.4, 46.71)) < 3.0 then
        local finished = exports['comet-hud']:beginProgress(25,"Decrypting",true)
        if (finished) then
            TriggerEvent("pixerium:check",3,"robbery:decrypt2",true)
          end
      end

      if #(GetEntityCoords(player) - vector3( 1208.73,-3115.29, 5.55)) < 3.0 then
        local finished = exports['comet-hud']:beginProgress(25,"Decrypting",true)
        if (finished) then
            TriggerEvent("pixerium:check",3,"robbery:decrypt3",true)
          end
      end
      
    end

    if (itemid == "fireworkfountain") then
        TriggerEvent('firework:fountain')
        remove = true
    end

    if (itemid == "fireworkrocket") then
        TriggerEvent('firework:rocket')
        remove = true
    end

    if (itemid == "fireworkshotburst") then
        TriggerEvent('firework:shotburst')
        remove = true
    end

    if (itemid == "radio") or (itemid == "radio2") then
        TriggerEvent('radioGui')
    end

    if (itemid == 'hpblueprint') then
        local finished = exports['comet-hud']:beginProgress(10, 'Learning!', true)
        if (finished) then
            if (hasEnoughOfItem('hpblueprint', 1, false)) then
                local msg = Callback.Execute('comet-blueprints:alterPrintState', 'HPISTOL_BP')

                if (msg) then
                    TriggerEvent('cl_SendNotify', msg)
                    remove = true
                end
            end
        end
    end

    if (itemid == 'uziblueprint') then
        local finished = exports['comet-hud']:beginProgress(10, 'Learning!', true)
        if (finished) then
            if (hasEnoughOfItem('uziblueprint', 1, false)) then
                local msg = Callback.Execute('comet-blueprints:alterPrintState', 'UZI_BP')

                if (msg) then
                    TriggerEvent('cl_SendNotify', msg)
                    remove = true
                end
            end
        end
    end

    if (itemid == 'tec9bp') then
        local finished = exports['comet-hud']:beginProgress(10, 'Learning!', true)
        if (finished) then
            if (hasEnoughOfItem('tec9bp', 1, false)) then
                local msg = Callback.Execute('comet-blueprints:alterPrintState', 'TEC9_BP')

                if (msg) then
                    TriggerEvent('cl_SendNotify', msg)
                    remove = true
                end
            end
        end
    end

    if (itemid == "pix2") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
        local finished = exports['comet-hud']:beginProgress(25,"Decrypting", true)
        if (finished) then
            TriggerEvent("Crypto:GivePixerium",math.random(5,12))
            remove = true
          end
      end
    end

    if (itemid == "femaleseed") then
       TriggerEvent("comet-state:stateSet",4,1600)
       TriggerEvent("comet-weed:plantSeed", itemid)
    end

    if (itemid == "maleseed") then
        TriggerEvent("comet-state:stateSet",4,1600)
        TriggerEvent("comet-weed:plantSeed", itemid)
    end

    if (itemid == "weedoz") then
 
        local finished = exports['comet-hud']:beginProgress(1,"Packing Q Bag", true)
        if (finished) then
            CreateCraftOption("weedq", 40, true)
        end
        
    end

    if ( itemid == "smallbud" and hasEnoughOfItem("qualityscales",1, false) ) then
        local finished = exports['comet-hud']:beginProgress(1,"Rolling Joints", true)
        if (finished) then
            CreateCraftOption("joint2", 80, true)    
        end
    end

    if (itemid == "weedq") then
        local finished = exports['comet-hud']:beginProgress(1,"Rolling Joints", true)
        if (finished) then
            CreateCraftOption("joint", 80, true)    
        end
    end

    if (itemid == "redpack") then
        remove = true
        TriggerServerEvent('redpack:item', itemid)
    end

    if (itemid == "lighter") then
        TriggerEvent("animation:PlayAnimation","lighter")
        local finished = exports['comet-hud']:beginProgress(2,"Starting Fire", true)
        if (finished) then
            
        end
    end

    if (itemid == "joint") or (itemid == "joint2") then

        

        if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
            local finished = exports['comet-hud']:beginProgress(7, "Smoking Joint", true)

            if (finished) then
                if exports["comet-inventory"]:getQuantity(itemid) <= 0 then return end
                SetPlayerMaxArmour(PlayerId(), 100)
                
                SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 15)
                local newArmour =  GetPedArmour(PlayerPedId())

                if newArmour >= 100 then
                    SetPedArmour(PlayerPedId(), 100)
                end
                TriggerServerEvent("sv_alterStress", false, math.random(750,1000))
                remove = true
            else
                TriggerEvent('cl_SendNotify', 'Cancelled.')
            end

        elseif GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
            local finished = exports['comet-hud']:beginProgress(5, "Smoking Joint", true)

            if (finished and IsPedUsingAnyScenario(PlayerPedId())) then
                if exports["comet-inventory"]:getQuantity(itemid) <= 0 then return end
                SetPlayerMaxArmour(PlayerId(), 100)
                
                SetPedArmour(PlayerPedId(), GetPedArmour(PlayerPedId()) + 15)
                local newArmour =  GetPedArmour(PlayerPedId())

                if newArmour >= 100 then
                    SetPedArmour(PlayerPedId(), 100)
                end
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent("sv_alterStress", false, math.random(750,1000))
                remove = true
            else
                TriggerEvent('cl_SendNotify', 'Cancelled.')
            end
        end
    end

    if (itemid == "vodka" or itemid == "beer" or itemid == "whiskey") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
        TriggerEvent("Evidence:StateSet", 8, 600)
        local alcoholStrength = 0.5
        if itemid == "vodka" or itemid == "whiskey" then alcoholStrength = 1.0 end
        TriggerEvent("fx:run", "alcohol", 180, alcoholStrength)
    end

    if (itemid == "coffee") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","coffee:drink",true,itemid,playerVeh)
    end

    if (itemid == "bscoffee" or itemid == "frappuccino") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","coffee:drink2",true,itemid,playerVeh)
    end


    if (itemid == "fishtaco") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:FishTaco",true,itemid,playerVeh)
    end

    if (itemid == "taco" or itemid == "burrito") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Taco",true,itemid,playerVeh)
    end

    if (itemid == "churro" or itemid == "hotdog") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "chips" or itemid == "treat") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "greencow") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "chocobar") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "donut" or itemid == "eggsbacon") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "icecream" or itemid == "mshake") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:IceCream",true,itemid,playerVeh)
    end



    if (itemid == "crackingtool") then
            TriggerEvent('inv:advancedLockpick',inventoryName,slot)
    end


    if (itemid == "Gruppe6Card") then
        TriggerEvent("sec:usegroup6card")
    end

    if (itemid == "bobcat_card") then
        TriggerEvent("BobcatHitTruck")
    end

    if (itemid == "usbdevice") then
        local finished = exports['comet-hud']:beginProgress(15,"Scanning", true)
        if (finished) then
            TriggerEvent("hacking:attemptHack")
        end
        
    end

    if (itemid == "weed12oz") then
        TriggerServerEvent("exploiter", "Someone ate a box with 12oz of weed for no reason / removing item in unintended way")
        TriggerEvent("inv:weedPacking") -- cannot find the end of this call anywhere
        remove = true
    end

    if (itemid == "heavyammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            if exports["comet-inventory"]:getQuantity("heavyammo") > 0 then
                TriggerEvent("actionbar:ammo",1788949567,50,true)
                remove = true
            end
        end
    end

    if (itemid == "pistolammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            if exports["comet-inventory"]:getQuantity("pistolammo") > 0 then
                TriggerEvent("actionbar:ammo",1950175060,50,true)
                remove = true
            end
        end
    end

    if (itemid == "snowballammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            TriggerEvent("actionbar:ammo", `AMMO_SNOWBALL_2`, 50, true)
            remove = true
        end
    end

    if (itemid == "rifleammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            if exports["comet-inventory"]:getQuantity("rifleammo") > 0 then
            TriggerEvent("actionbar:ammo",218444191,50,true)
            remove = true
    end
end
    end

    if (itemid == "securitygold")  then
        TriggerEvent("comet-yacht:startYacht")
    end

    -- if (itemid == "sniperammo") then
   -- local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
    -- if (finished) then
    --         TriggerEvent("actionbar:ammo",1285032059,5,true)
    --         remove = true
    --     end
    -- end

    if (itemid == "shotgunammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            TriggerEvent("actionbar:ammo",-1878508229,50,true)
            remove = true
        end
    end

    if (itemid == "subammo") then
        local finished = exports['comet-hud']:beginProgress(5,"Reloading", true)
        if (finished) then
            TriggerEvent("actionbar:ammo",1820140472,50,true)
            remove = true
        end
    end

    if (itemid == "taserammo") then
        local finished = exports['comet-hud']:beginProgress(2,"Reloading", true)
        if (finished) then
            TriggerEvent("FillTazer")
            remove = true
        end
    end


    if (itemid == "armor" or itemid == "pdarmor") then
        TriggerEvent("animation:armor")
        local finished = exports['comet-hud']:beginProgress(7, "Applying Armor", true)
        if (finished) then
         if exports["comet-inventory"]:getQuantity("armor") > 0 or exports["comet-inventory"]:getQuantity("pdarmor") > 0 then
            SetPlayerMaxArmour(PlayerId(), 100)
            SetPedArmour(player, 100)
            TriggerEvent("UseBodyArmor")
            ClearPedTasks(GetPlayerPed(-1))
            remove = true
        end
    end
end

    if (itemid == "securityblue") then
        TriggerEvent("comet-fleecas:start")
    end


    if (itemid == "cbrownie" or itemid == "cgummies" or itemid == "420bar") then
        TriggerEvent("animation:PlayAnimation","pill")
        local finished = exports['comet-hud']:beginProgress(3,"Consuming", true)
        if (finished) then
            TriggerEvent("Evidence:StateSet",3,1200)
            TriggerEvent("Evidence:StateSet",7,1200)
            TriggerEvent("fx:run", "weed", 180, -1, false)
            remove = true
        end
    end

    if (itemid == "cabsinthe") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drinking Absinthe","changethirst",true,itemid,playerVeh)
        TriggerEvent("fx:run", "weed", 180, -1, false)
    end

    if (itemid == "clotion") then
        TaskItem("amb@code_human_in_car_mp_actions@grab_crotch@std@ds@base", "idle_a", 49,6000,"Rubbing on lotion","Weedlotion",true,itemid,playerVeh,slot)
        TriggerEvent("fx:run", "weed", 180, -1, false)
        TriggerEvent("cl_SendNotify","Feels Good",1)
    end


    if (itemid == "bodybag") then
        local finished = exports['comet-hud']:beginProgress(10,"Opening", true)
        if (finished) then
            remove = true
            TriggerEvent( "player:receiveItem", "humanhead", 1 )
            TriggerEvent( "player:receiveItem", "humantorso", 1 )
            TriggerEvent( "player:receiveItem", "humanarm", 2 )
            TriggerEvent( "player:receiveItem", "humanleg", 2 )
        end
    end

    if (itemid == "bodygarbagebag") then
        local finished = exports['comet-hud']:beginProgress(10,"Opening", true)
        if (finished) then
                remove = true
                TriggerServerEvent('loot:useItem', itemid)
            end
    end

    if (itemid == "foodsupplycrate") then
        TriggerEvent("cl_SendNotify","Make sure you have a ton of space in your inventory! 100 or more.",2)
        local finished = exports['comet-hud']:beginProgress(20,"Opening", true)
        if (finished) then
            remove = true
            TriggerEvent( "player:receiveItem", "heartstopper", 10 )
            TriggerEvent( "player:receiveItem", "moneyshot", 10 )
            TriggerEvent( "player:receiveItem", "bleederburger", 10 )
            TriggerEvent( "player:receiveItem", "fries", 10 )
            TriggerEvent( "player:receiveItem", "cola", 10 )
        end
end

    if (itemid == "organcooler") then
        local finished = exports['comet-hud']:beginProgress(5,"Opening", true)
        if (finished) then
            remove = true
            TriggerEvent( "player:receiveItem", "humanheart", 1 )
            TriggerEvent( "player:receiveItem", "organcooleropen", 1 )
        end
    end

    if itemid == "humanhead" then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid,playerVeh,true,"humanskull")
    end

    if (itemid == "humantorso" or itemid == "humanarm" or itemid == "humanhand" or itemid == "humanleg" or itemid == "humanfinger") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid,playerVeh,true,"humanbone")
    end

    if (itemid == "humanear" or itemid == "humanintestines" or itemid == "humanheart" or itemid == "humaneye" or itemid == "humanbrain" or itemid == "humankidney" or itemid == "humanliver" or itemid == "humanlungs" or itemid == "humantongue" or itemid == "humanpancreas") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 10000, "Eating (ESC to Cancel)", "inv:wellfed", true,itemid)
    end

    if (itemid == "Bankbox") then
        local finished = exports['comet-hud']:beginProgress(10,"Opening", true)
        if (finished) then
                remove = true
                local roll = math.random(4)
                if roll == 1 then
                TriggerEvent("player:receiveItem", "-771403250", math.random(1,3))
                TriggerEvent("player:receiveItem", "pistolammo", 3)
                elseif roll == 2 then
                TriggerEvent("player:receiveItem", "-771403250", math.random(1,3))
                TriggerEvent("player:receiveItem", "pistolammo", 3)            
                elseif roll == 3 then
                TriggerEvent("player:receiveItem", "-771403250", math.random(1,3))
                TriggerEvent("player:receiveItem", "pistolammo", 3)
                elseif roll == 4 then
                TriggerEvent("player:receiveItem", "1649403952", 1)
                TriggerEvent("player:receiveItem", "band", 75)
            end
        end
    end

    if (itemid == "Securebriefcase") then
        if (hasEnoughOfItem("Bankboxkey",1, false)) then
            local finished = exports['comet-hud']:beginProgress(5,"Opening", true)
            if (finished) then
                remove = true
                TriggerEvent("inventory:removeItem","Bankboxkey", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("cl_SendNotify","You are missing something to open the briefcase with",2)
        end
    end

    if (itemid == "Largesupplycrate") then
        if (hasEnoughOfItem("2227010557",1, false)) then
            local finished = exports['comet-hud']:beginProgress(15,"Opening", true)
            if (finished) then
                remove = true
                TriggerEvent("inventory:removeItem","2227010557", 1)  

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("cl_SendNotify","You are missing something to open the crate with",2)
        end
    end

    if (itemid == "xmasgiftcoal") then
        local finished = exports['comet-hud']:beginProgress(15,"Opening", true)
        if (finished) then
            remove = true
            TriggerServerEvent('loot:useItem', itemid)
        end
    end

    if (itemid == "Mediumsupplycrate") then
        TriggerEvent("PlaceCrates", `prop_drop_crate_01_set2`)
    end
    
    if (itemid == "fishingrod") then
        TriggerEvent("comet-fish:tryToFish")
    end

    if (itemid == "fishingtacklebox") then
        local finished = exports['comet-hud']:beginProgress(5,"Opening", true)
        if (finished) then
            remove = true
            TriggerServerEvent('loot:useItem', itemid)
        end
    end

    if (itemid == "fishingchest") then
        local finished = exports['comet-hud']:beginProgress(5,"Opening", true)
        if (finished) then
            remove = true
            TriggerEvent( "player:receiveItem", "goldbar", math.random(1,5) )
        end
    end

    if (itemid == "fishinglockbox") then
        local finished = exports['comet-hud']:beginProgress(5,"Opening", true)
        if (finished) then
            --remove = true
            --TriggerServerEvent('loot:useItem', itemid)
            TriggerEvent("cl_SendNotify","Add your map thing here DW you fucking fuck fuck",2)
        end
    end

    if (itemid == "backpack") then
        local finished = exports['comet-hud']:beginProgress(15,"Unzipping", true)
        if (finished) then
            remove = true
            TriggerServerEvent("backpack:give:items")
        end
    end

    if (itemid == "gps") then
        local radarEnabled = IsRadarEnabled()
        if IsPedInAnyVehicle(PlayerPedId()) and radarEnabled then  
            TriggerEvent("cl_SendNotify","Get on foot you nonce",2)
        else
            DisplayRadar(1)
        end
    end

    if (itemid == "binoculars") then 
        TriggerEvent("binoculars:Activate")
    end

    if (itemid == "camera") then
        TriggerEvent("camera:Activate")
    end

    if (itemid == "nitrous") then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        
        if not IsToggleModOn(currentVehicle,18) then
            TriggerEvent("cl_SendNotify","You need a Turbo to use NOS!",2)
        else
            local finished = 0
            local cancelNos = false
            Citizen.CreateThread(function()
                while finished ~= 100 and not cancelNos do
                    Citizen.Wait(100)
                    if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                        exports["comet-taskbar"]:closeGuiFail()
                        cancelNos = true
                    end
                end
            end)
            local finished = exports['comet-hud']:beginProgress(20,"Applying Nitrous", true)
            if (finished) then
                TriggerEvent("NosStatus")
                TriggerEvent("noshud", 100, false)
                remove = true
            else
                TriggerEvent("cl_SendNotify","You can't drive and hook up nos at the same time.",2)
            end
        end
    end

    if (itemid == "lockpick") then
        local myJob = exports['isPed'].isPed("myjob")
        if myJob ~= "news" then
            TriggerEvent("inv:lockPick",false,inventoryName,slot)

        else
            TriggerEvent("cl_SendNotify","Nice news reporting, you shit lord idiot.")
        end
    end
    
    if (itemid == "lockpick") then
        TriggerEvent('houseRobberies:attempt')
    end

    if (itemid == "umbrella") then
        TriggerEvent("animation:PlayAnimation","umbrella")
        
    end

    if (itemid == "repairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end

    if (itemid =="advrepairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end
    if (itemid == "securityblack" or itemid == "securitygreen" or itemid == "securitygold" or itemid == "securityred")  then
        TriggerEvent("robbery:scanLock",false,itemid)       
    end

    if (itemid == "Gruppe6Card2")  then
        TriggerEvent("comet-vault:g6Card")
    end

    if (itemid == "Gruppe6Card222")  then
        TriggerEvent('comet-vault:g6Card')
        TriggerEvent('comet-vault:card')
    end

    if (itemid == "Gruppe6Card22")  then
        TriggerEvent("comet-vault:g6Card")
    end    

    if (itemid == "ciggy") then
        if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING", 0,"Smoke")
            local finished = exports['comet-hud']:beginProgress(5,"Lighting", true)
            if (finished) then
                if exports["comet-inventory"]:getQuantity("ciggy") > 0 then
                    TriggerEvent("client:newStress",false, 750)
                    remove = true
                end
            end
        end
    end

    if (itemid == "cigar") then
        local finished = exports['comet-hud']:beginProgress(1,"Lighting Cigar", true)
        if (finished) then
            Wait(300)
            TriggerEvent("animation:PlayAnimation","cigar")
        end
    end

    if (itemid == "oxygentank") then
        local finished = exports['comet-hud']:beginProgress(30,"Applying Tank", true)
        if (finished) then  
            TriggerEvent("UseOxygenTank")
            remove = true
        end
    end

    if (itemid == "bandage") then
        TaskPlayAnim(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c",1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
        local finished = exports['comet-hud']:beginProgress(4,"Healing", true)
        if finished then
        TriggerEvent("healed:minors")
        TriggerEvent('inventory:removeItem',"bandage", 1)
        ClearPedTasks(PlayerPedId())
    end
end 

    if (itemid == "coke50g") then
        CreateCraftOption("coke5g", 80, true)
        
    end

    if (itemid == "bakingsoda") then 
        CreateCraftOption("1gcrack", 80, true)
    end

    if (itemid == "drill") then 
        TriggerEvent("comet-vault:drillUsed")
    end

    if (itemid == "glucose") then 
        CreateCraftOption("1gcocaine", 80, true)
        
    end

    if (itemid == "idcard") then 
        local ItemInfo = GetItemInfo(slot)
        TriggerServerEvent("police:showID",ItemInfo.information)   
    end

    if (itemid == "drivingtest") then 
        local ItemInfo = GetItemInfo(slot)
        if (ItemInfo.information ~= "No information stored") then
            local data = json.decode(ItemInfo.information)
            TriggerServerEvent("driving:getResults", data.ID)
        end
    end

    if (itemid == "1gcocaine") then
        TriggerEvent("attachItemObjectnoanim","drugpackage01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 49, 5000, "Coke Gaming", "hadcocaine", true,itemid,playerVeh)
    end

    if (itemid == "adrenaline") then
        TriggerEvent("animation:PlayAnimation","stunned")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49, 5000, "Injecting Adrenaline", "hadcocaine", true,itemid,playerVeh)
    end

    if (itemid == "1gcrack") then 
        TriggerEvent("attachItemObjectnoanim","crackpipe01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 5000, "Smoking Quack", "hadcrack", true,itemid,playerVeh)
    end

    if (itemid == "treat") then
        local model = GetEntityModel(player)
        if model == GetHashKey("a_c_chop") then
            TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 1200, "Treat Num's", "hadtreat", true,itemid,playerVeh)
        end
    end

    if (itemid == "IFAK") then
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49,2000,"Applying IFAK","healed:useOxy",true,itemid,playerVeh)
    end


    if (itemid == "oxy") then
        TriggerEvent("animation:PlayAnimation","pill")
        TriggerEvent("useOxy")
        TriggerEvent("healed:useOxy")
        remove = true
    end

    if (itemid == "sandwich" or itemid == "hamburger") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "cola" or itemid == "sprunk" or itemid == "water" or itemid == "softdrink") then
        --attachPropsToAnimation(itemid, 6000)
        --TaskItem("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
    end


    if (itemid == "jailfood" or itemid == "bleederburger" or itemid == "heartstopper" or itemid == "torpedo" or itemid == "nachos" or itemid == "meatfree" or itemid == "moneyshot" or itemid == "fries" or itemid == "ramen" or itemid == "muffin" or itemid == "maccheese") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","inv:wellfed",true,itemid,playerVeh)
        --attachPropsToAnimation(itemid, 6000)
        --TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 6000, "Eating", "inv:wellfed", true,itemid)
    end

    if (itemid == "methbag") then
        local finished = exports["comet-taskbarskill"]:taskBar(2500,10)
        if (finished == 100) then  
            TriggerEvent("attachItemObjectnoanim","crackpipe01")
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",6,1200)
            TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 1500, "💩 Smoking Ass Meth 💩", "hadcocaine", true, itemid,playerVeh)
        end
    end
    if itemid == "slushy" then
        --attachPropsToAnimation(itemid, 6000)
        TriggerEvent("healed:useOxy")
        TriggerServerEvent("jail:cuttime")
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49, 6000,"Eating", "inv:wellfed",true,itemid,playerVeh)
    end

    if (itemid == "shitlockpick") then
        lockpicking = true
        TriggerEvent("animation:lockpickinvtestoutside") 
        local finished = exports["comet-taskbarskill"]:taskBar(2500,math.random(5,20))
        if (finished == 100) then    
            TriggerEvent("police:uncuffMenu")
        end
        lockpicking = false
        remove = true
    end

    if (itemid == "watch") then
        TriggerEvent("carHud:compass")
    end

    if (itemid == "harness") then
        local veh = GetVehiclePedIsIn(player, false)
        local driver = GetPedInVehicleSeat(veh, -1)
        if (PlayerPedId() == driver) then
            TriggerEvent("vehicleMod:useHarnessItem")
            remove = true
        end
    end

    TriggerEvent("comet-inventory:itemUsed", itemid, passedItemInfo, inventoryName, slot)


    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end

    Wait(500)
    retardCounter = 0
    justUsed = false


end)

AddEventHandler("comet-inventory:itemUsed", function(name, info)
    if not info then return end
    local info = json.decode(info)
    if not info._is_poisoned then return end
    local potency = info.potency or 5
    if not potency or potency < 1 then
      potency = 1
    end
    if potency and potency > 101 then
      potency = 101
    end
    local interval = info.interval or 60
    if interval < 1 then
      interval = 1
    end
    local duration = info.duration or 60
    if duration < 1 then
      duration = 1
    end
  end)
  
function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid,vehicle)
    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" or itemid == "muffin" or itemid == "maccheese" or itemid == "ramen" then
        TriggerEvent("attachItem", "hamburger")
        TriggerEvent('comet-hud:updateHunger', 30)
    elseif itemid == "sandwich" then
        TriggerEvent("attachItem", "sandwich")
        TriggerEvent('comet-hud:updateHunger', 30)
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
        TriggerEvent('comet-hud:updateHunger', 30)
    elseif itemid == "water" or itemid == "cola" or itemid == "sprunk" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" or itemid == "softdrink "then
        TriggerEvent("attachItem", itemid)
        TriggerEvent('comet-hud:updateWater', 30)
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
        TriggerEvent('comet-hud:updateHunger', 30)
    elseif itemid == "greencow" then
        TriggerEvent("attachItem", "energydrink")
        TriggerEvent('comet-hud:updateWater', 30)
    elseif itemid == "slushy" then
        TriggerEvent("attachItem", "cup")
        TriggerEvent('comet-hud:updateWater', 30)
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
    TriggerEvent("destroyProp")
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)



local clientInventory = {};
RegisterNetEvent('current-items')
AddEventHandler('current-items', function(inv)
    clientInventory = inv
    checkForItems()
    checkForAttachItem()
    TriggerEvent("AttachWeapons")
end)






RegisterNetEvent('SniffRequestCID')
AddEventHandler('SniffRequestCID', function(src)
    local cid = exports['isPed'].isPed("cid")
    TriggerServerEvent("SniffCID",cid,src)
end)


function GetItemInfo(checkslot)
    for i,v in pairs(clientInventory) do
        if (tonumber(v.slot) == tonumber(checkslot)) then
            local info = {["information"] = v.information,["id"] = v.id, ["quality"] = v.quality }
            return info
        end
    end
    return "No information stored";
end


function GetInfoForFirstItemOfName(item_id)
    for i,v in pairs(clientInventory) do
        if (v.item_id == item_id) then
            local info = {
              ["information"] = v.information,
              ["id"] = v.id,
              ["quality"] = v.quality,
            }
            return info
        end
    end
    return nil
end

function GetItemsByItemMetaKV(item_id, meta_key, meta_value)
  local items = {}
  for i, v in pairs(clientInventory) do
      if v.item_id == item_id then
          local info = json.decode(v.information)
          if info[meta_key] == meta_value then
              items[#items + 1] = {
                ["information"] = v.information,
                ["id"] = v.id,
                ["quality"] = v.quality,
              }
          end
      end
  end
  return items
end
exports("GetItemsByItemMetaKV", GetItemsByItemMetaKV)


-- item id, amount allowed, crafting.
function CreateCraftOption(id, add, craft)
    TriggerEvent("CreateCraftOption", id, add, craft)
end

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh,itemreturn,itemreturnid)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    local timer = tonumber(timer/1200)
    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end
    if timer > 0 then
        local finished = exports['comet-hud']:beginProgress(timer,message, true)
        if finished then
            ClearPedTasks(PlayerPedId())
            TriggerEvent(func)

            if itemreturn then
                TriggerEvent( "player:receiveItem",itemreturnid, 1 )
            end

        end
    else
        TriggerEvent(func)
    end
end



function GetCurrentWeapons()
    local returnTable = {}
    for i,v in pairs(clientInventory) do
        if (tonumber(v.item_id)) then
            local t = { ["hash"] = v.item_id, ["id"] = v.id, ["information"] = v.information, ["name"] = v.item_id, ["slot"] = v.slot }
            returnTable[#returnTable+1]=t
        end
    end   
    if returnTable == nil then 
        return {}
    end
    return returnTable
end

function getQuantity(itemid)
    local amount = 0
    for i,v in pairs(clientInventory) do
        if (v.item_id == itemid) then
            amount = amount + v.amount
        end
    end
    return amount
end

function hasEnoughOfItem(itemid,amount,shouldReturnText)
    if shouldReturnText == nil then shouldReturnText = true end
    if itemid == nil or itemid == 0 or amount == nil or amount == 0 then if shouldReturnText then TriggerEvent("cl_SendNotify","I dont seem to have " .. itemid .. " in my pockets.",2) end return false end
    amount = tonumber(amount)
    local slot = 0
    local found = false

    if getQuantity(itemid) >= amount then
        return true
    end
    if (shouldReturnText) then
        -- TriggerEvent("cl_SendNotify","I dont have enough of that item...",2) 
    end    
    return false
end


function getItemsOfType(itemid, limitAmount, checkQuality, metaInformation)
    if itemid == nil then
        return nil
    end
    local itemsFound = {}
    local amount = tonumber(limitAmount)
    for i,v in pairs(clientInventory) do
        if amount and #itemsFound >= amount then
            break
        end

        local qCheck = not checkQuality or v.quality > 0
        if v.item_id == itemid and qCheck then
            if metaInformation then
                local totalMetaKeys = 0
                local metaFoundCount = 0
                local itemMeta = json.decode(v.information)
                for metaKey, metaValue in pairs(metaInformation) do
                    totalMetaKeys = totalMetaKeys + 1
                    if itemMeta[metaKey] and itemMeta[metaKey] == metaValue then
                        metaFoundCount = metaFoundCount + 1
                    end
                end
                if totalMetaKeys <= metaFoundCount then
                    itemsFound[#itemsFound+1] = v
                end
            else
                itemsFound[#itemsFound+1] = v
            end
        end
    end
    return itemsFound
end

exports("getItemsOfType", getItemsOfType)

function checkForAttachItem()
    local AttatchItems = {
        "stolentv",
        "stolenmusic",
        "stolencoffee",
        "stolenmicrowave",
        "stolencomputer",
        "stolenart",
        "darkmarketpackage",
        "weedpackage",
        "methpackage",
        "boxscraps",
        "dodopackagesmall",
        "dodopackagemedium",
        "dodopackagelarge",
        "housesafe",
        "huntingcarcass4",
        "huntingcarcass3",
        "huntingcarcass2",
        "huntingcarcass1",
        "fridge",
        "barrel_fuel"
    }

    local itemToAttach = "none"
    for k,v in pairs(AttatchItems) do
        if getQuantity(v) >= 1 then
            itemToAttach = v
            break
        end
    end

    TriggerEvent("animation:carry",itemToAttach,true)
end


local PreviousItemCheck = {}

function checkForItems()
    local items = {
        "mobilephone",
        "stoleniphone",
        "stolennokia",
        "stolenpixel3",
        "stolens8",
        "boomerphone",
        "radio",
        "civradio",
        "burgershotheadset",
        "megaphone",
        "watch",
        "boxinggloves",
        "cgchain",
        "gsfchain",
        "cerberuschain",
        "mdmchain",
        "vagoschain",
        "koilchain",
        "racingusb2",
    }

    for _, item in ipairs(items) do
        local quantity = getQuantity(item)
        local hasItem = quantity >= 1

        if hasItem and not PreviousItemCheck[item] then
            PreviousItemCheck[item] = true
            TriggerEvent('comet-inventory:itemCheck', item, true, quantity)
        elseif not hasItem and PreviousItemCheck[item] then
            PreviousItemCheck[item] = false
            TriggerEvent('comet-inventory:itemCheck', item, false, quantity)
        end
    end
end

function isValidUseCase(itemID,isWeapon)
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    if playerVeh ~= 0 then
        local model = GetEntityModel(playerVeh)
        if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
            if IsEntityInAir(playerVeh) then
                Wait(1000)
                if IsEntityInAir(playerVeh) then
                    TriggerEvent("cl_SendNotify","You appear to be flying through the air",2) 
                    return false
                end
            end
        end
    end

    if not validWaterItem[itemID] and not isWeapon then
        if IsPedSwimming(player) then
            local targetCoords = GetEntityCoords(player, 0)
            Wait(700)
            local plyCoords = GetEntityCoords(player, 0)
            if #(targetCoords - plyCoords) > 1.3 then
                TriggerEvent("cl_SendNotify","Cannot be moving while swimming to use this.",2) 
                return false
            end
        end

        if IsPedSwimmingUnderWater(player) then
            TriggerEvent("cl_SendNotify","Cannot be underwater to use this.",2) 
            return false
        end
    end

    return true
end





























-- DNA



RegisterNetEvent('evidence:addDnaSwab')
AddEventHandler('evidence:addDnaSwab', function(dna)
    TriggerEvent("cl_SendNotify", "DNA Result: " .. dna,1)    
end)

RegisterNetEvent('CheckDNA')
AddEventHandler('CheckDNA', function()
    TriggerServerEvent("Evidence:checkDna")
end)

RegisterNetEvent('evidence:dnaSwab')
AddEventHandler('evidence:dnaSwab', function()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
        TriggerServerEvent("police:dnaAsk", GetPlayerServerId(t))
    else
		TriggerEvent("cl_SendNotify", "No player near you!",2)
    end
end)

RegisterNetEvent('evidence:swabNotify')
AddEventHandler('evidence:swabNotify', function()
    TriggerEvent("cl_SendNotify", "DNA swab taken.",1)
end)


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end


-- DNA AND EVIDENCE END
























-- this is the upside down world, be careful.


function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end

local burgies = 0
RegisterNetEvent('inv:wellfed')
AddEventHandler('inv:wellfed', function()
    TriggerEvent("Evidence:StateSet",25,3600)
    TriggerEvent("changehunger")
    TriggerEvent("changehunger")
    TriggerEvent("client:newStress",false,1000)
    TriggerEvent("changehunger")
    TriggerEvent("changethirst")
    burgies = 0
end)

RegisterNetEvent('animation:lockpickinvtestoutside')
AddEventHandler('animation:lockpickinvtestoutside', function()
    local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    
    while lockpicking do        
        TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
        Citizen.Wait(2500)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('animation:lockpickinvtest')
AddEventHandler('animation:lockpickinvtest', function(disable)
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    if disable ~= nil then
        if not disable then
            lockpicking = false
            return
        else
            lockpicking = true
        end
    end
    while lockpicking do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)



RegisterNetEvent('inv:lockPick')
AddEventHandler('inv:lockPick', function(isForced,inventoryName,slot)
    TriggerEvent("robbery:scanLock",true)
    if lockpicking then return end

    lockpicking = true
    playerped = PlayerPedId()
    targetVehicle = GetVehiclePedIsUsing(playerped)
    local itemid = 21

    if targetVehicle == 0 then
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
        local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
        if targetVehicle == 0 then
            lockpicking = false
            TriggerEvent("robbery:lockpickhouse",isForced)
            return
        end

        if driverPed ~= 0 then
            lockpicking = false
            return
        end
            local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
            local leftfront = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)

            local count = 5000
            local dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
            while dist > 2.0 and count > 0 do
                dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
                Citizen.Wait(1)
                count = count - 1
                DrawText3Ds(leftfront["x"],leftfront["y"],leftfront["z"],"Move here to lockpick.")
            end

            if dist > 2.0 then
                lockpicking = false
                return
            end


            TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
            Citizen.Wait(1000)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end

            TriggerEvent("animation:lockpickinvtestoutside")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)



 
            local finished = exports["comet-taskbarskill"]:taskBar(25000,3)

            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["comet-taskbarskill"]:taskBar(2200,10)

            if finished ~= 100 then
                 lockpicking = false
                return
            end


            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then

                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerEvent("cl_SendNotify", "Vehicle Unlocked.",1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 0.1)

                end
            end
        lockpicking = false
    else
        if targetVehicle ~= 0 and not isForced then

            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end

            SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
            TriggerEvent("animation:lockpickinvtest")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)

           
            local carTimer = GetVehicleHandlingFloat(targetVehicle, 'CHandlingData', 'nMonetaryValue')
            if carTimer == nil then
                carTimer = math.random(25000,180000)
            end
            if carTimer < 25000 then
                carTimer = 25000
            end

            if carTimer > 180000 then
                carTimer = 180000
            end
            
            carTimer = math.ceil(carTimer / 3)


            local myJob = exports['isPed'].isPed("myjob")
            if myjob == "towtruck" then
                carTimer = 4000
            end

            local finished = exports["comet-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["comet-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["comet-taskbarskill"]:taskBar(1500,math.random(5,15))
            if finished ~= 100 then
                TriggerEvent("cl_SendNotify", "The lockpick bent out of shape.",2)
                TriggerEvent("inventory:removeItem","lockpick", 1)                
                 lockpicking = false
                return
            end     


            Citizen.Wait(500)
            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then

                    local plate = GetVehicleNumberPlateText(targetVehicle)
                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerEvent("keys:addNew",targetVehicle,plate)
                    TriggerEvent("cl_SendNotify", "Ignition Working.",1)
                    SetEntityAsMissionEntity(targetVehicle,false,true)
                    SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
                    TriggerEvent("chop:plateoff",plate)

                end
                lockpicking = false
            end
        end
    end
    lockpicking = false
end)

local reapiring = false
RegisterNetEvent('veh:repairing')
AddEventHandler('veh:repairing', function(inventoryName,slot,itemid)
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    local advanced = false
    if itemid == "advrepairkit" then
        advanced = true
    end

    if targetVehicle ~= 0 then

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d2["y"]+0.5,0.2)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000
        local fueltankhealth = GetVehiclePetrolTankHealth(targetVehicle)

        while dist > 1.5 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
        end

        if reapiring then return end
        reapiring = true
        
        local timeout = 20

        NetworkRequestControlOfEntity(targetVehicle)

        while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
            NetworkRequestControlOfEntity(targetVehicle)
            Citizen.Wait(100)
            timeout = timeout -1
        end


        if dist < 1.5 then
            TriggerEvent("animation:repair",targetVehicle)
            fixingvehicle = true

            local repairlength = 1000

            if advanced then
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1200
                        else
                           timeAdded = timeAdded + 800
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 5) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            else
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1600
                        else
                           timeAdded = timeAdded + 1200
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 3) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            end



            local finished = exports["comet-taskbarskill"]:taskBar(15000,math.random(10,20))
            if finished ~= 100 then
                fixingvehicle = false
                reapiring = false
                ClearPedTasks(playerped)
                return
            end

            if finished == 100 then
                
                local myJob = exports['isPed'].isPed("myjob")
                if myJob == "towtruck" then

                    SetVehicleEngineHealth(targetVehicle, 1000.0)
                    SetVehicleBodyHealth(targetVehicle, 1000.0)
                    SetVehiclePetrolTankHealth(targetVehicle, 4000.0)

                    if math.random(100) > 95 then
                        TriggerEvent("inventory:removeItem","repairtoolkit",1)
                    end

                else

                    TriggerEvent('veh.randomDegredation',30,targetVehicle,3)

                    if advanced then
                        TriggerEvent("inventory:removeItem","advrepairkit", 1)
                        TriggerEvent('veh.randomDegredation',30,targetVehicle,3)
                        if GetVehicleEngineHealth(targetVehicle) < 900.0 then
                            SetVehicleEngineHealth(targetVehicle, 900.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 3800.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 3800.0)
                        end

                    else

                        local timer = math.ceil(GetVehicleEngineHealth(targetVehicle) * 5)
                        if timer < 2000 then
                            timer = 2000
                        end
                        local finished = exports["comet-taskbarskill"]:taskBar(timer,math.random(5,15))
                        if finished ~= 100 then
                            fixingvehicle = false
                            reapiring = false
                            ClearPedTasks(playerped)
                            return
                        end

                        if math.random(100) > 95 then
                            TriggerEvent("inventory:removeItem","repairtoolkit",1)
                        end

                        if GetVehicleEngineHealth(targetVehicle) < 200.0 then
                            SetVehicleEngineHealth(targetVehicle, 200.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 2900.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 2900.0)
                        end                        

                        if GetEntityModel(targetVehicle) == `BLAZER` then
                            SetVehicleEngineHealth(targetVehicle, 600.0)
                            SetVehicleBodyHealth(targetVehicle, 800.0)
                        end
                    end                    
                end

                for i = 0, 5 do
                    SetVehicleTyreFixed(targetVehicle, i) 
                end
            end
            ClearPedTasks(playerped)
        end
        fixingvehicle = false
    end
    reapiring = false
end)

-- Animations
RegisterNetEvent('animation:load')
AddEventHandler('animation:load', function(dict)
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end)

RegisterNetEvent('animation:repair')
AddEventHandler('animation:repair', function(veh)
    SetVehicleDoorOpen(veh, 4, 0, 0)
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end

    TaskTurnPedToFaceEntity(PlayerPedId(), veh, 1.0)
    Citizen.Wait(1000)

    while fixingvehicle do
        local anim3 = IsEntityPlayingAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 3)
        if not anim3 then
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    SetVehicleDoorShut(veh, 4, 1, 1)
end)

RegisterNetEvent("closinginv")
AddEventHandler("closinginv", function()
TriggerEvent("closeInventoryGui2")
    OpenInv = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
end)

-- RegisterCommand('steal', function()
--     RequestAnimDict("random@shop_robbery")
--     while not HasAnimDictLoaded("random@shop_robbery") do
--         Citizen.Wait(0)
-- 	end
--     t, distance, closestPed = GetClosestPlayer()
--     if(distance ~= -1 and distance < 5) then
--         local searchPlayerPed = GetPlayerPed(t)
--         if ( IsEntityPlayingAnim(GetPlayerPed(t), "dead", "dead_a", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "amb@code_human_cower@male@base", "base", 3) or  IsEntityPlayingAnim(GetPlayerPed(t), "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "mp_arresting", "idle", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(t), "missfbi5ig_22", "hands_up_loop_scientist", 3) ) then
--             if IsPedArmed(PlayerPedId(), 7) then
--                 TaskPlayAnim(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
--                 local finished = exports['comet-hud']:beginProgress(5,"Robbing", true)
--                 if (finished) then
--                     t, distance, closestPed = GetClosestPlayer()
--                     if(distance ~= -1 and distance < 5) then
--                         TriggerServerEvent("people-search", GetPlayerServerId(t))
--                         TriggerServerEvent("Stealtheybread", GetPlayerServerId(t))
--                         TriggerServerEvent("stealcommand:log")
--                     else
--                         TriggerEvent("cl_SendNotify", "No player near you!",2)
--                     end
--                     ClearPedTasks(PlayerPedId())
--                 end
--             else
--                 TriggerEvent("cl_SendNotify", "You need a weapon!",2)
--             end
--         end
--     end
-- end)

RegisterNetEvent('animation:armor')
AddEventHandler('animation:armor', function()
		inanimation = true
		local lPed = GetPlayerPed(-1)
		RequestAnimDict("clothingshirt")
		while not HasAnimDictLoaded("clothingshirt") do
			Citizen.Wait(0)
		end

		if IsEntityPlayingAnim(lPed, "clothingshirt", "try_shirt_positive_d", 3) then
			ClearPedSecondaryTask(lPed)
		else
			TaskPlayAnim(lPed, "clothingshirt", "try_shirt_positive_d", 8.0, -8, -1, 49, 0, 0, 0, 0)
			seccount = 4
			while seccount > 0 do
				Citizen.Wait(7500)
				seccount = seccount - 1
			end
			ClearPedSecondaryTask(lPed)
		end		
		inanimation = false

end)

RegisterNetEvent('MakeTaco')
AddEventHandler('MakeTaco', function()
	TriggerEvent("server-inventory-open", "18", "Craft")
end)