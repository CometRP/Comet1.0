
local fullVehicleList = {
    ["sultan"] = {
        worth = 300000,
        label = "Sultan",
    },
    ["vigero2"] = {
        worth = 300000,
        label = "Vigero",
    },
    ["paragon"] = {
        worth = 300000,
        label = "Paragon",
    },
    ["infernus"] = {
        worth = 300000,
        label = "infernus",
    },
    ["asbo"] = {
        worth = 300000,
        label = "asbo",
    },
    ["sultan2"] = {
        worth = 300000,
        label = "sultan2",
    },
    ["adder"] = {
        worth = 300000,
        label = "adder",
    },

}
local inputOptions = {}
for vehicle, data in pairs(fullVehicleList) do 
    inputOptions[#inputOptions+1] = { value = vehicle, text = data.label }
end



local vehicleSpawnCoords = {
    vector4(-1291.61, -169.24, 42.91, 142.64),
    vector4(-1221.32, -265.66, 37.73, 46.06),
    vector4(-1274.22, -282.28, 37.44, 27.67),
    vector4(-1316.09, -189.78, 43.08, 305.7),
}

local vehicleDriveCoords = vector4(-1216.24, -190.17, 38.53, 331.76)

local ValetVehicles = {}



local DriverPeds = {
    "ig_claypain",
    "ig_nigel",
    "a_m_m_ktown_01",
    "a_m_m_malibu_01",
    "ig_tomcasino",
    "u_m_m_promourn_01",
}

local DeliveryVehicles = {
    'sultan',
    'baller',
    'stalion',
    'windsor',
    'asbo',
    'dilettante',
}

local needsList = {
    ["CID"] = {
        model = "sultan",
    }
}

RegisterNetEvent("comet-crime:valet:requestVehicle", function(veh)
    local source = source
    local Player = exports['comet-base']:FetchComponent("Player").GetBySource(source)
    if not Player then return end
    needsList[Player.PlayerData.cid] = {
        model = veh
    }
end)

RegisterNetEvent("comet-crime:valet:spawn", function()
    local source = source
    local VehicleCoords = vehicleSpawnCoords[math.random(1, #vehicleSpawnCoords)]
    local DriveCoords = vehicleDriveCoords
    local RandomPed = DriverPeds[math.random(1, #DriverPeds)]
    if #DeliveryVehicles <= 0 then 
        return
    end
    local RandomVehicle = DeliveryVehicles[math.random(1, #DeliveryVehicles)]
    local Vehicle = CreateVehicle(GetHashKey(RandomVehicle), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, VehicleCoords.w, true, false)
    while not DoesEntityExist(Vehicle) do
        Citizen.Wait(5)
    end
    CreatePedInsideVehicle(Vehicle, 4, GetHashKey(RandomPed), -1, true)
    -- Do veh stuff
    local netId = NetworkGetNetworkIdFromEntity(Vehicle)
    ValetVehicles[netId] = {
        Delivered = false,
        model = RandomVehicle,
    }
    TriggerClientEvent('comet-crime:valet:set-veh-data', -1, netId, false)
    TriggerClientEvent('comet-crime:valet:veh-drive-to-coord', -1, netId, DriveCoords)
end)

RegisterNetEvent("comet-crime:valet:dropOff", function(NetId)
    local source = source
    local Player = exports['comet-base']:FetchComponent("Player").GetBySource(source)
    if not Player then return end

    -- Set vehicle delivered
    ValetVehicles[NetId].Delivered = true
    TriggerClientEvent('comet-crime:valet:set-veh-data', -1, nil, true)

    local vehWorth = 300000
    local min = vehWorth/100
    local gen = math.random(70, 100)
    local max = vehWorth/gen

    local reward = math.random(min,max)

    Player.AddMoney("cash", reward)

end)



RegisterNetEvent("comet-crime:valet:requestConfig", function()
    local source = source
    local config = {}
    local cache = {}
    for i = 1, 6 do 
        local random = math.random(1, #inputOptions)
        if not cache[random] then
            cache[random] = true 
            config[i] = inputOptions[random]
        end
    end

    TriggerClientEvent("comet-crime:valet:config", source, config)
end)