Config.Peds["towjob"] = {
    id = 'towjob',
    position = {
        --vector4(1214.81, -1280.04, 35.45, 79.53)
        coords = vector3(1214.81, -1280.04, 35.45 - 1),
        heading = 79.53,
    },
    pedType = 0,
    model = 'ig_tonya',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "ez-tow:SignIn",
                icon = "fas fa-box-circle-check",
                label = "Sign In",
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

