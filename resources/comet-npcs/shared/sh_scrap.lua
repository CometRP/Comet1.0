Config.Peds["scrap"] = {
    id = 'scrap',
    position = {
        --vector4(262.63, -1796.93, 27.11, 50.36)
        coords = vector3(262.63, -1796.93, 27.11 - 1),
        heading = 50.36,
    },
    pedType = 0,
    model = 's_m_y_dockwork_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "ez-scrap:openScrap",
                icon = "fas fa-box-circle-check",
                label = "Trade Recyclables",
            },
        },
        distance = 3.0,
    },
    settings = {
        { mode = 'invincible', active = true },
        { mode = 'ignore', active = true },
        { mode = 'freeze', active = true },
    },
    scenario = "WORLD_HUMAN_CLIPBOARD",
    -- animation = {testdic = 'amb@world_human_leaning@male@wall@back@legs_crossed@base' , testanim = 'base' },
}

