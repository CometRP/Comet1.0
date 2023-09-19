Vehicles = Vehicles or {}

Shared = {}

Shared.Debug = true

Shared.Classes = {
    C = 325,
    B = 400,
    A = 550,
    S = 700,
    X = 900,
}

Vehicle.GetTierClasses = function()
    return Shared.Classes
end
exports("GetTierClasses", function()
    return Shared.Classes
end)