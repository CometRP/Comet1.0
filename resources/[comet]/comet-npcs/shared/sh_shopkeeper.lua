ShopKeeperLocations = {
    vector4(-3037.773, 584.8989, 6.97, 30.0),
    vector4(1960.64, 3739.03, 31.50, 321.36),
    vector4(1393.84,3606.8,33.99,172.8),
    vector4(549.01,2672.44,41.16,122.33),
    vector4(2558.39,380.74,107.63,21.54),
    vector4(-1819.57,793.59,137.09,134.3),
    vector4(-1221.26,-907.92,11.3,54.44),
    vector4(-706.12,-914.56,18.22,94.66),
    vector4(24.47,-1348.47,28.5,298.26),
    vector4(-47.36,-1758.68,28.43,50.84),
    vector4(1164.95,-323.7,68.21,101.73),
    vector4(372.19,325.74,102.57,276.17),
    vector4(2678.63,3278.86,54.25,344.4),
    vector4(1727.3,6414.27,34.04,259.1),
    vector4(-160.56,6320.76,30.59,319.99),
    vector4(1165.29,2710.85,37.16,178.47),
    vector4(1697.23,4923.42,41.07,327.94),
    vector4(159.84,6640.89,30.7,242.18),
    vector4(-1486.81,-377.38,39.17,143.01),
    vector4(-3241.1,999.93,11.84,10.23),
    vector4(-2966.38,391.79,14.05,99.55),
    vector4(1134.29,-983.39,45.42,292.7),
    vector4(-1422.56,-271.43,45.27,34.69)
}

for k,v in pairs(ShopKeeperLocations) do
    Config.Peds["shopkeeper"..k] = {
        id = "shopkeeper"..k,
        position = {
            coords = vector3(v[1], v[2], v[3]),
            heading = v[4],
        },
        pedType = 0,
        model = 'a_m_m_indian_01',
        networked = false,
        distance = 50.0,
        target = {
            options = {
                {
                    type = "client",
                    event = "shop:general",
                    icon = "fas fa-cart-shopping",
                    label = "Shop",
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
    
end
