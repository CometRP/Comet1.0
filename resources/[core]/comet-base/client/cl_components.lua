Components = {}

DoesComponentExist = function(i)
    if Components[i] ~= nil then 
        return true
    end
    return false
end
exports("DoesComponentExist", DoesComponentExist)

CreateComponent = function(comp, funcs)
    if DoesComponentExist(comp) then
        print("[COMPONENTS] Component with this name already exist")
        return false
    end
    Components[comp] = funcs
end
exports("CreateComponent", CreateComponent)

AddExtraComponent = function(comp, name, func)
    if not DoesComponentExist(comp) then
        print(("[COMPONENTS] r u dumb bruh `%s` Component Does not Exist"):format(comp))
        return false 
    end
    if Components[comp][name] then 
        print(("[COMPONENTS] `%s` Component already has `%s`"):format(comp, name))
        return false
    end
    Components[comp][name] = func
end
exports("AddExtraComponent", AddExtraComponent)

FetchComponent = function(comp)
    if DoesComponentExist(comp) then 
        return Components[comp]
    end     
    -- SetTimeout(5000, function()
    --     if DoesComponentExist(comp) then 
    --         return Components[comp]
    --     end
    -- end)
    print(("[COMPONENTS] Failed to fetch `%s` Component Does not Exist"):format(comp))
    return false
end
exports("FetchComponent", FetchComponent)

RefreshComponents = function()
    TriggerEvent("comet-base:refreshComponents")
end
exports("RefreshComponents", RefreshComponents)

RegisterNetEvent("comet-base:refreshComponents", function()

end)
