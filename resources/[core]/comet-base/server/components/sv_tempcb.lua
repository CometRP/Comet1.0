Components.Callback = Components.Callback or {}

local Callbacks = {}

-- CreateThread(function()

--     TriggerEvent("comet-base:executeCB", math.random(1,9999999), "callbacktester", {cid = "42C"})


-- end)

RegisterNetEvent("comet-base:executeCB", function(key, name, data)
    print(GetInvokingResource() or GetCurrentResourceName())
    if not data then data = {} end
    local source = source
    local event = ("comet-base:%s:%s"):format(name, key)

    -- print(name, source, data, key, Callbacks, Callbacks[name])
    local cb = Callbacks[name]
    local result = cb(source, data)
    TriggerClientEvent(event, source, result)
end)

Components.Callback.Register = function(name, cb)
    -- print(name, cb)
    -- print(json.encode(cb))
    -- print(type(cb))
    -- if type(cb) ~= "table" then print("[CALLBACKS] `"..name.."` is not a function!") return end

    if Callbacks[name] then print("[CALLBACKS] `"..name.."` already exists!") return end

    Callbacks[name] = cb
end

Components.Callback.Register("callbacktester", function(source, data)
    if not data then return end
    if not data.cid then 
        return "no cid"
    end
    -- print(source)

    return data.cid == "42C"
end)

-- Components.Callback.Execute = function(name, data)
-- 	local newEvent = nil
-- 	local p = promise.new()
-- 	local Key = math.random(1,9999999)
-- 	local event = ("comet-base:%s:%s"):format(name, Key)
-- 	RegisterNetEvent(event)
-- 	newEvent = AddEventHandler(event, function(result)
-- 		newEvent = RemoveEventHandler(newEvent)
-- 		p:resolve(result)
-- 	end)
-- 	TriggerServerEvent("comet-base:executeCB", Key, Data)
-- 	return Citizen.Await(p)
-- end