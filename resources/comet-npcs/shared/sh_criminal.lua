Config.Peds["weapnheist"] = {
    id = 'weapnheist',
    position = {
        --vector4(2016.91, 4987.84, 42.1, 132.92),
        coords = vector3(2016.91, 4987.84, 42.1 - 1),
        heading = 132.92,
    },
    pedType = 0,
    model = 'g_m_m_chicold_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                icon = 'fas fa-circle',
                label = 'Talk',
                action = function(entity)
                    print(entity)
                    -- exports['qb-core']:Progressbar("talking_man", "Talking..", 10000, false, true, {
                    --     disableMovement = false,
                    --     disableCarMovement = false,
                    --     disableMouse = false,
                    --     disableCombat = true,
                    -- }, {}, {}, {}, function() -- Done
                    --     TriggerServerEvent("weapheist:StartHeist")
                    -- end)
                end,
            },
        },
        distance = 3.0,
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    -- scenario = "WORLD_HUMAN_CLIPBOARD",
    animation = {testdic = 'amb@world_human_leaning@male@wall@back@legs_crossed@base' , testanim = 'base' },
}

Config.Peds["hitmna"] = {
    id = 'hitmna',
    position = {
        coords = vector3(465.52, -790.54, 27.36 - 1),
        heading = 329.66,
    },
    pedType = 0,
    model = 'g_m_m_chicold_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                icon = 'fas fa-circle',
                label = 'Hit Contracts',
                action = function(entity)
                    print(entity)
              
                end,
            },
        },
        distance = 3.0,
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    -- scenario = "WORLD_HUMAN_CLIPBOARD",
    animation = {testdic = 'amb@world_human_leaning@male@wall@back@legs_crossed@base' , testanim = 'base' },
}

