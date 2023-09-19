Components.Blips = Components.Blips or {}
Shared.Blips = Shared.Blips or {}

function Components.Blips.CreateBlip(self, id, data)
    local blip = AddBlipForCoord(data.x, data.y, data.z)

    if data.sprite then SetBlipSprite(blip, data.sprite) end
    if data.range then SetBlipAsShortRange(blip, data.range) else SetBlipAsShortRange(blip, true) end
    if data.color then SetBlipColour(blip, data.color) end
    if data.display then SetBlipDisplay(blip, data.display) end
    if data.playername then SetBlipNameToPlayerName(blip, data.playername) end
    if data.showcone then SetBlipShowCone(blip, data.showcone) end
    if data.secondarycolor then SetBlipSecondaryColour(blip, data.secondarycolor) end
    if data.friend then SetBlipFriend(blip, data.friend) end
    if data.mission then SetBlipAsMissionCreatorBlip(blip, data.mission) end
    if data.route then SetBlipRoute(blip, data.route) end
    if data.friendly then SetBlipAsFriendly(blip, data.friendly) end
    if data.routecolor then SetBlipRouteColour(blip, data.routecolor) end
    if data.scale then SetBlipScale(blip, data.scale) else SetBlipScale(blip, 0.7) end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    Shared.Blips[id] = {blip = blip, data = data}
end

function Components.Blips.RemoveBlip(self, id)
    local blip = Shared.Blips[id]
    if blip then RemoveBlip(blip.blip) end
    Shared.Blips[id] = nil
end

function Components.Blips.HideBlip(self, id, toggle)
    local blip = Shared.Blips[id]
    if not blip then return end
    if toggle then SetBlipAlpha(blip, 0) else SetBlipAlpha(blip, 255) end
end

function Components.Blips.GetBlip(self, id)
    local blip = Shared.Blips[id]
    if not blip then return false end
    return blip
end

local blips = {
    {id = "pcenter", name = "Payments & Internet Center", scale = 0.7, sprite = 351, color = 17, x=-1081.8293457031, y=-248.12872314453, z=37.763294219971},
    {id = "courthouse", name = "Los Santos Courthouse", scale = 0.7, color = 5, sprite = 58, x=-551.62670898438, y=-192.11676025391, z=38.21968460083},
    {id = "Bennys", name = "Bennys Motor Works", scale = 0.7, color = 1, sprite = 72, x=-212.28814697266, y=-1324.95703125, z=30.890},
    {id = "Auto Bodies", name = "Auto Bodies", scale = 0.7, color = 1, sprite = 72, x=-338.38021850586, y=-135.76963806152, z=39.009654998779},
    {id = "Tuner Shop", name = "Tuner Shop", scale = 0.7, color = 1, sprite = 72, x=937.23828125, y=-970.89343261719, z=39.543106079102},
    {id = "Paleto Preformance", name = "Paleto Preformance", scale = 0.7, color = 1, sprite = 72, x=108.35273742676, y=6625.1982421875, z= 31.787202835083},
    {id = "Burger Shot", name = "Burger Shot", scale = 0.7, color = 60, sprite = 106, x=-1191.6701660156, y=-889.74584960938, z= 14.508341789246},
    {id = "truckjob1", name = "Delivery Garage", scale = 0.7, color = 17, sprite = 67, x =165.22, y=-28.38, z=67.94},
    {id = "truckjob2", name = "Delivery Garage", scale = 0.7, color = 17, sprite = 67, x = -627.99, y= -1649.99, z= 25.83},
    {id = "weazel", name = "Weazel News", scale = 0.7, color = 6, sprite = 47, x = -598.248046875, y= -929.77307128906, z= 23.869129180908},
    {id = "beanmachine", name = "Bean Machine", scale = 0.7, color = 44, sprite = 106, x = -629.541015625, y= 233.69226074219, z= 81.881462097168},
    {id = "bestbuds", name = "BestBuds", scale = 0.7, color = 61, sprite = 140, x = -622.3955078125, y= -297.32778930664, z= 35.341938018799},
    {id = "morsmutual", name = "Mors Mutual", scale = 0.7, color = 59, sprite = 225, x = -826.15130615234, y= -261.63632202148, z= 38.002964019775},
    {id = "mining", name = "Mining", scale = 0.7, color = 59, sprite = 85, x = 2952.876953125, y= 2788.6508789062, z= 41.551727294922},
    {id = "mining", name = "Mining Washing", scale = 0.7, color = 59, sprite = 365, x = 1687.8176269531, y= 41.877899169922, z= 161.76719665527},
    {id = "mining", name = "Smelting", scale = 0.7, color = 36, sprite = 478, x = 1071.7906494141, y= -1962.1102294922, z= 31.014358520508},
}

AddEventHandler("comet-base:playerSessionStarted", function()
    Citizen.CreateThread(function()
        for k,v in ipairs(blips) do
            Components.Blips.CreateBlip(v.id, v)
        end
    end)
end)


