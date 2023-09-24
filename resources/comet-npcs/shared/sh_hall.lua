Config.Peds["citythall"] = {
    id = 'citythall',
    position = {
        --vector4(-553.72, -189.36, 38.22, 215.32)
        coords = vector3(-553.72, -189.36, 38.22 - 1),
        heading = 215.32,
    },
    pedType = 0,
    model = 'cs_carbuyer',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "ez-hall:open",
                icon = "fas fa-box-circle-check",
                label = "Open",
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
    -- animation = {testdic = 'amb@world_human_leaning@male@wall@back@legs_crossed@base' , testanim = 'base' },
}

