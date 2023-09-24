Config.Peds["recycler"] = {
    id = 'recycler',
    position = {
        --vector4(982.4, -2278.42, 30.51, 87.49)
        coords = vector3(982.4, -2278.42, 30.51 - 1),
        heading = 87.49,
    },
    pedType = 0,
    model = 's_m_y_dockwork_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "ez-recycle:openRecycle",
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
    animation = {testdic = 'amb@world_human_leaning@male@wall@back@legs_crossed@base' , testanim = 'base' },
}

