Config.Peds["valetcrime"] = {
    id = 'valetcrime',
    position = {
        coords = vector3(-1221.43, -206.31, 39.3 - 1),
        heading = 37.51,
    },
    pedType = 0,
    model = 's_m_y_valet_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "comet-crime:valet:signin",
                icon = "fas fa-circle",
                label = "Sign In",
                canInteract = function()
                    local job = exports['comet-crime']:GetJob()
                    if job then
                        return false
                    end
                    return true
                end
            },
            {
                type = "client",
                event = "comet-crime:signoff",
                icon = "fas fa-circle",
                label = "Sign Off",
                canInteract = function()
                    local job = exports['comet-crime']:GetJob()
                    if job ~= "valet" then 
                        return false
                    end
                    return true
                end
            },
            -- {
            --     type = "client",
            --     event = "comet-crime:valet:C",
            --     icon = "fas fa-circle",
            --     label = "Sign Off",
            --     canInteract = function()
            --         local job = exports['comet-crime']:GetJob()
            --         if job ~= "valet" then 
            --             return false
            --         end
            --         return true
            --     end
            -- },
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


Config.Peds["illegalcardealer"] = {
    id = 'illegalcardealer',
    position = {
        coords = vector3(887.38, -953.8, 39.21 - 1),
        heading = 4.59,
    },
    pedType = 0,
    model = 'g_m_m_casrn_01',
    networked = false,
    distance = 50.0,
    target = {
        options = {
            {
                type = "client",
                event = "comet-crime:valet:reqeust",
                icon = "fas fa-circle",
                label = "Request Vehicle",
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
}


