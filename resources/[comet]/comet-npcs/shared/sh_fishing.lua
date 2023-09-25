Config.Peds["boatgear1"] = {
    id = 'boatgear1',
    position = {
        coords = vector3(-806.17, -1496.57, 0.6),
        heading = 100.0,
    },
    pedType = 0,
    model = 's_m_y_ammucity_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:BoatMenu",
                icon = "fas fa-anchor",
                label = "Boat Rental",
                location = 1 --LaPuerta
            },
            {
                event = "ez-fishing:client:buyFishingGear",
                icon = "fas fa-fish",
                label = "Fishing Gear",
            },
        },
        distance = 10.0
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_STAND_FISHING",
}

Config.Peds["boatgear2"] = {
    id = 'boatgear2',
    position = {
    	coords = vector3(-1604.236, 5256.483, 1.073),               
		heading = 291.202,
    },
    pedType = 0,
    model = 'u_m_m_filmdirector',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:BoatMenu",
                icon = "fas fa-anchor",
                label = "Boat Rental",
                location = 2 --PaletoCove
            },
            {
                event = "ez-fishing:client:buyFishingGear",
                icon = "fas fa-fish",
                label = "Fishing Gear",
            },
        },
        distance = 10.0
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_STAND_FISHING",
}

Config.Peds["boatgear3"] = {
    id = 'boatgear3',
    position = {
		coords = vector3(3373.215, 5183.515, 0.46),               
		heading = 266.111,
    },
    pedType = 0,
    model = 's_m_o_busker_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:BoatMenu",
                icon = "fas fa-anchor",
                label = "Boat Rental",
                location = 3 --ElGordo
            },
            {
                event = "ez-fishing:client:buyFishingGear",
                icon = "fas fa-fish",
                label = "Fishing Gear",
            },
        },
        distance = 10.0
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_STAND_FISHING",
}

Config.Peds["boatgear4"] = {
    id = 'boatgear4',
    position = {
		coords = vector3(1694.811, 39.927, 160.767),               
		heading = 191.786,
    },
    pedType = 0,
    model = 'ig_cletus',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:BoatMenu",
                icon = "fas fa-anchor",
                label = "Boat Rental",
                location = 4 --ActDam
            },
            {
                event = "ez-fishing:client:buyFishingGear",
                icon = "fas fa-fish",
                label = "Fishing Gear",
            },
        },
        distance = 10.0
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_STAND_FISHING",
}

Config.Peds["boatgear5"] = {
    id = 'boatgear5',
    position = {
        coords = vector3(1299.665, 4231.885, 32.909),               
		heading = 81.693,
    },
    pedType = 0,
    model = 'a_m_m_hillbilly_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:BoatMenu",
                icon = "fas fa-anchor",
                label = "Boat Rental",
                location = 5 --AlamoSea
            },
            {
                event = "ez-fishing:client:buyFishingGear",
                icon = "fas fa-fish",
                label = "Fishing Gear",
            },
        },
        distance = 10.0
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_STAND_FISHING",
}


Config.Peds["fishingsell"] = {
    id = 'fishingsell',
    position = {
        coords = vector3(-1816.406, -1193.334, 13.305),         -- Regular/Exotic Fish Sells
		heading = 325.172,
    },
    pedType = 0,
    model = 's_m_y_busboy_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                event = "ez-fishing:client:SellLegalFish",
                icon = "fa fa-fish",
                label = "Sell Fish",
            },
            {
                event = "ez-fishing:client:SellillegalFish",
                icon = "fa fa-fish",
                label = "Sell Exotic Fish",
                canInteract = function()
                    return Inventory:HasItem("pearlscard")
                end
            },
        },
        distance = 3.5
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_CLIPBOARD",
}