Components = Components or {}
Components.Base = Components.Base or {}

local Dependencies = {
    [GetCurrentResourceName()] = true,
}

DoesComponentExist = function(i)
    if Components[i] ~= nil then 
        return true
    end
    return false
end
exports("DoesComponentExist", DoesComponentExist)

CreateComponent = function(comp, funcs)
    local resourceName = GetInvokingResource() or GetCurrentResourceName()
    if DoesComponentExist(comp) then
        print("[COMPONENTS] Component with this name already exist")
        return false
    end
    Dependencies[resourceName] = true
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
    RefreshComponents()
end
exports("AddExtraComponent", AddExtraComponent)

FetchComponent = function(comp)
    if DoesComponentExist(comp) then 
        return Components[comp]
    end     
    print(("[COMPONENTS] Failed to fetch `%s` Component Does not Exist"):format(comp))
    return false
end
exports("FetchComponent", FetchComponent)

RefreshComponents = function()
    TriggerEvent("comet-base:refreshComponents")
end
exports("RefreshComponents", RefreshComponents)
-- CreateThread(RefreshComponents)
AddEventHandler('onResourceStart', function(resourceName)
    if Dependencies[resourceName] then
        print("[COMPONENTS] RELOADED MFFFF")
        CreateThread(RefreshComponents)
        -- RefreshComponents()
    end
end)

LoadComponents = function(comps, cb)
    local resourceName = GetInvokingResource() or GetCurrentResourceName()
    local finished = false
    local failed = false
    local checked = {}
    local attempts = {}
    CreateThread(function()
        while not finished do
            for k, v in pairs(comps) do
                if attempts[k] == nil then attempts[k] = 1 end
                if DoesComponentExist(v) then
                    if not checked[k] then checked[k] = true end
                else
                    if attempts[k] > 50 then
                        print("^5[COMPONENTS/" .. (resourceName) .. "]^7 Failed to fetch componenents ^2[" .. v .. "]^7 (Maximum Attempts of 50 Exceeded)")
                        failed = true
                        cb(false)
                        return
                    end
                    attempts[k] = attempts[k] + 1
                end
            end

            if #checked == #comps then 
                finished = true 
            end
            Wait(100)
        end
        cb(true)
    end)
end
exports("LoadComponents", LoadComponents)

Components.Base.ExportsReady = false
function Components.Base.WaitForExports(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if exports and exports["comet-base"] then
                TriggerEvent("comet-base:exportsReady")
                Components.Base.ExportsReady = true
                return
            end
        end
    end)
end
Components.Base:WaitForExports()