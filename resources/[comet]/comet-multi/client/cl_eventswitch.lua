function Login.playerLoaded() end

function Login.characterLoaded()
  -- Main events leave alone 
  TriggerEvent("comet-base:playerSpawned")
  TriggerEvent("loadedinafk")
  TriggerEvent("playerSpawned")
  TriggerServerEvent('character:loadspawns')
  TriggerEvent("spawnselector:open")
  TriggerServerEvent('comet-clothing:retrieve_tats')
  
  -- Main events leave alone 
  TriggerEvent("resetinhouse")
  TriggerEvent("fx:clear")
  TriggerServerEvent('Blemishes:retrieve')
  TriggerServerEvent("currentconvictions")
  TriggerServerEvent("GarageData")
  TriggerEvent("banking:viewBalance")
  TriggerEvent("TurnHudOn")
  TriggerServerEvent('comet-doors:requestlatest')
  TriggerServerEvent("comet-weapons:getAmmo")
  Wait(3000)
  TriggerServerEvent("bones:server:requestServer")

  	-- Events
	TriggerServerEvent("police:SetMeta")
	TriggerServerEvent("server:currentpasses")
	TriggerServerEvent("commands:player:login")
	TriggerServerEvent("retreive:licenes:server")
	TriggerServerEvent("comet-inventory:RetreiveSettings")
	--Licenses for hunting / fishing
	
	TriggerServerEvent('comet-fish:retreive:license')
	TriggerServerEvent('comet-hunting:retreive:license')

  -- Gang shit
  TriggerServerEvent("server-jail-item", 'ply-'..isPed.isPed("cid"), false)
  -- TriggerServerEvent('comet-territories:approvedgang')
  -- TriggerServerEvent('comet-territories:leader')
  -- TriggerServerEvent('comet-territories:grove')
  -- TriggerServerEvent('comet-territories:covenant')
  -- TriggerServerEvent('comet-territories:brouge')
  -- TriggerServerEvent('comet-territories:forum')
  -- TriggerServerEvent('comet-territories:jamestown')
  -- TriggerServerEvent('comet-territories:mirrorpark')
  -- TriggerServerEvent('comet-territories:fudge')
  -- TriggerServerEvent('comet-territories:vespucci')
  -- TriggerServerEvent('comet-territories:cougar')
  -- TriggerServerEvent('comet-territories:harmony')
  -- TriggerServerEvent('comet-territories:mission1')
  -- TriggerServerEvent('comet-territories:mission2')
  -- TriggerServerEvent('comet-territories:mission3')
  -- TriggerServerEvent('comet-territories:mission4')
  -- TriggerServerEvent('comet-territories:mission5')
  TriggerServerEvent('ReceiveLockStatus')
  TriggerServerEvent('ReceiveLockStatus2')
  -- TriggerServerEvent('hotel:ting')

  TriggerServerEvent("spawn")

  -- TriggerServerEvent("comet-mdt:retreive:warrant")
  -- TriggerEvent("eyetoggle")
  -- TriggerEvent("SvSide")
-- Robbery Cooldowns
  -- TriggerServerEvent('comet-robbery:vaultcooldown')

  -- Scuba SmootherSon
  -- TriggerServerEvent('comet-assets:scubasmooth')
  -- Jail/Bank Logs
	TriggerServerEvent("retreive:jail",isPed.isPed("cid"))	
	TriggerServerEvent("bank:getLogs")
end

function Login.characterSpawned()

  isNear = false
  TriggerServerEvent('comet-base:sv:player_control')
  TriggerServerEvent('comet-base:sv:player_settings')

  TriggerServerEvent("TokoVoip:clientHasSelecterCharacter")
  TriggerEvent("spawning", false)
  TriggerEvent("attachWeapons")
  TriggerEvent("tokovoip:onPlayerLoggedIn", true)

  TriggerServerEvent("request-dropped-items")
  TriggerServerEvent("server-request-update", isPed.isPed("cid"))
  TriggerServerEvent("stocks:retrieveclientstocks")


  TriggerEvent("comet-hud:initHud")


  if Spawn.isNew then
    Wait(1000)
    if not exports["comet-inventory"]:hasEnoughOfItem("mobilephone", 1, false) then
        TriggerEvent("player:receiveItem", "mobilephone", 1)
    end

    -- commands to make sure player is alive and full food/water/health/no injuries
    local src = GetPlayerServerId(PlayerId())
    TriggerServerEvent("reviveGranted", src)
    TriggerEvent("Hospital:HealInjuries", src, true)
    TriggerServerEvent("ems:healplayer", src)
    TriggerEvent("heal", src)
    TriggerEvent("status:needs:restore", src)
    TriggerServerEvent("comet-clothing:get_character_current", src)
    TriggerServerEvent("comet-multi:newPlayerFullySpawned")
  end
  SetPedMaxHealth(PlayerPedId(), 200)
  SetPlayerMaxArmour(PlayerId(), 100)
  runGameplay() -- moved from comet-base 
  Spawn.isNew = false
end
RegisterNetEvent("comet-multi:characterSpawned");
AddEventHandler("comet-multi:characterSpawned", Login.characterSpawned);
