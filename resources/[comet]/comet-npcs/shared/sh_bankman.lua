Config.Peds["bankman"] = {
    id = 'bankman',
    position = {
        --vector4(-564.78, 228.77, 74.89, 354.02)
        coords = vector3(-564.78, 228.77, 74.89 - 1),
        heading = 354.02,
    },
    pedType = 0,
    model = 'hc_hacker',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type="client",
                event = "fleeca:client:menuCheck",
                icon = "fas fa-laptop-code",
                label = "Check Availability"
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
    animation = {testdic = 'anim@heists@prison_heiststation@cop_reactions' , testanim = 'cop_b_idle' },
}

