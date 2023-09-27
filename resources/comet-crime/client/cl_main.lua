CurrentCrime = {}
CurrentCrime.job = nil
exports("GetJob", function()
    return CurrentCrime.job
end)
RegisterNetEvent("comet-crime:signoff", function()
    CurrentCrime.job = nil
end)

CreateThread(function()
    local PolyZone = nil or exports['comet-base']:FetchComponent("PolyZone")
    exports['comet-base']:LoadComponents({
        "PolyZone"
    }, function(pass)
        if not pass then return end
        PolyZone = exports['comet-base']:FetchComponent("PolyZone")
    end)

    while not PolyZone do Wait(25) end
    PolyZone.AddBoxZone("valetdropoff", vector3(1979.1, 5171.94, 47.64), 15.0, 8, {
        name="valetdropoff",
        heading=310,
        --debugPoly=true,
        minZ=45.64,
        maxZ=50.64
    })
end)
